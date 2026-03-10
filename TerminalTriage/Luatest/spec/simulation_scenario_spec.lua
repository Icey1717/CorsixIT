-- busted unit tests for simulation scenario helper logic
-- Tests the utility functions and assertion conditions used in simulation_scenario.lua
-- without requiring the full game engine.

describe("simulation_scenario helpers", function()

  -- ---------------------------------------------------------------
  -- Mocks shared by multiple test blocks
  -- ---------------------------------------------------------------
  local function make_map(cam_x, cam_y, w, h)
    return {
      getCameraTile = function(self, _idx) return cam_x, cam_y end,
      size = function(self) return w, h end,
    }
  end

  local function make_hospital(in_hosp_fn, player_idx)
    return {
      getPlayerIndex = function(self) return player_idx or 1 end,
      isInHospital   = in_hosp_fn or function(self, x, y) return true end,
      staff          = {},
      balance        = 50000,
    }
  end

  local function make_world(hospital, map)
    local entities = {}
    local w = {
      available_diseases = {{id="broken_leg"}, {id="flu"}},
      map = { th = map },
      getLocalPlayerHospital = function(self) return hospital end,
      newEntity = function(self, class_name, anim, mood)
        local e = {
          humanoid_class = class_name,
          _anim = anim,
          profile = nil,
          _tile_x = nil, _tile_y = nil,
          _in_corridor = false,
          _hospital = nil,
          setProfile     = function(e2, p) e2.profile = p end,
          setTile        = function(e2, x, y) e2._tile_x = x; e2._tile_y = y end,
          onPlaceInCorridor = function(e2) e2._in_corridor = true end,
          setHospital    = function(e2, h) e2._hospital = h end,
        }
        entities[#entities + 1] = e
        return e
      end,
    }
    return w, entities
  end

  local function make_profile(world, class_name)
    return {
      humanoid_class = class_name,
      name = "Test Staff",
      skill = 0,
      wage  = 100,
      init  = function(self, skill) self.skill = skill; self.wage = 150 end,
    }
  end

  -- ---------------------------------------------------------------
  -- hireStaffMember logic
  -- ---------------------------------------------------------------
  describe("hireStaffMember equivalent logic", function()
    it("places staff at a hospital tile near the camera", function()
      local map = make_map(30, 30, 64, 64)
      local hospital = make_hospital(
        function(self, x, y) return x >= 25 and x <= 35 and y >= 25 and y <= 35 end
      )
      local world, entities = make_world(hospital, map)

      -- Inline the placement logic from simulation_scenario.lua
      local map_offset = 10
      local cam_x, cam_y = map:getCameraTile(1)
      local map_x, map_y = map:size()
      local x_safe = math.max(map_offset + 1, math.min(cam_x, map_x - map_offset))
      local y_safe = math.max(map_offset + 1, math.min(cam_y, map_y - map_offset))

      local staff = world:newEntity("Receptionist", 2, 2)
      local placed = false
      for _ = 1, 100 do
        local xa = x_safe + math.random(-map_offset, map_offset)
        local ya = y_safe + math.random(-map_offset, map_offset)
        if hospital:isInHospital(xa, ya) then
          staff:setTile(xa, ya)
          placed = true
          break
        end
      end

      assert.is_true(placed, "staff should have been placed in hospital")
      assert.is_not_nil(staff._tile_x)
      assert.is_not_nil(staff._tile_y)
    end)

    it("falls back to camera tile when random placement fails", function()
      local map = make_map(30, 30, 64, 64)
      -- Only the camera tile itself is in hospital
      local hospital = make_hospital(
        function(self, x, y) return x == 30 and y == 30 end
      )
      local world, _ = make_world(hospital, map)

      local cam_x, cam_y = map:getCameraTile(1)
      local map_offset = 10
      local map_x, map_y = map:size()
      local x_safe = math.max(map_offset + 1, math.min(cam_x, map_x - map_offset))
      local y_safe = math.max(map_offset + 1, math.min(cam_y, map_y - map_offset))

      local staff = world:newEntity("Doctor", 2, 2)
      local placed = false
      for _ = 1, 100 do
        local xa = x_safe + math.random(-map_offset, map_offset)
        local ya = y_safe + math.random(-map_offset, map_offset)
        if hospital:isInHospital(xa, ya) then
          staff:setTile(xa, ya)
          placed = true
          break
        end
      end
      if not placed then
        if hospital:isInHospital(cam_x, cam_y) then
          staff:setTile(cam_x, cam_y)
          placed = true
        end
      end

      assert.is_true(placed, "fallback to camera tile should succeed")
      assert.equals(30, staff._tile_x)
      assert.equals(30, staff._tile_y)
    end)

    it("sets all expected fields on the created entity", function()
      local map = make_map(32, 32, 64, 64)
      local hospital = make_hospital()
      local world, entities = make_world(hospital, map)

      local profile = make_profile(world, "Receptionist")
      local staff = world:newEntity("Receptionist", 2, 2)
      staff:setProfile(profile)
      staff:setTile(32, 32)
      staff:onPlaceInCorridor()
      hospital.staff[#hospital.staff + 1] = staff
      staff:setHospital(hospital)

      assert.equals("Receptionist", staff.humanoid_class)
      assert.equals(profile, staff.profile)
      assert.equals(32, staff._tile_x)
      assert.is_true(staff._in_corridor)
      assert.equals(hospital, staff._hospital)
      assert.equals(1, #hospital.staff)
    end)
  end)

  -- ---------------------------------------------------------------
  -- placeReceptionDesk error handling
  -- ---------------------------------------------------------------
  describe("placeReceptionDesk pcall guard", function()
    it("returns nil when newObject always throws", function()
      local map = make_map(30, 30, 64, 64)
      local hospital = make_hospital()
      local world, _ = make_world(hospital, map)
      -- Override newObject to always throw
      world.newObject = function() error("simulated object placement failure") end

      local desk = nil
      local function try_place()
        for _ = 1, 100 do
          if hospital:isInHospital(30, 30) then
            local ok, obj = pcall(world.newObject, world, "reception_desk", 30, 30, "north", "test")
            if ok and obj then desk = obj; return end
          end
        end
      end
      try_place()

      assert.is_nil(desk, "desk should be nil when newObject always throws")
    end)

    it("returns the object when newObject succeeds", function()
      local fake_desk = {id = "reception_desk", receptionist = nil}
      local map = make_map(30, 30, 64, 64)
      local hospital = make_hospital()
      local world, _ = make_world(hospital, map)
      world.newObject = function() return fake_desk end

      local desk = nil
      for _ = 1, 100 do
        if hospital:isInHospital(30, 30) then
          local ok, obj = pcall(world.newObject, world, "reception_desk", 30, 30, "north", "test")
          if ok and obj then desk = obj; break end
        end
      end

      assert.equals(fake_desk, desk)
    end)
  end)

  -- ---------------------------------------------------------------
  -- Date assertion conditions
  -- ---------------------------------------------------------------
  describe("date advancement assertions", function()
    local function make_date(year, month)
      return {
        year         = function(self) return year  end,
        monthOfYear  = function(self) return month end,
      }
    end

    it("passes when month >= 3 in year 1", function()
      local d = make_date(1, 3)
      local ok = d:year() > 1 or d:monthOfYear() >= 3
      assert.is_true(ok)
    end)

    it("passes when year > 1 regardless of month", function()
      local d = make_date(2, 1)
      local ok = d:year() > 1 or d:monthOfYear() >= 3
      assert.is_true(ok)
    end)

    it("passes for month 4 in year 1", function()
      local d = make_date(1, 4)
      local ok = d:year() > 1 or d:monthOfYear() >= 3
      assert.is_true(ok)
    end)

    it("fails when still in month 2 year 1", function()
      local d = make_date(1, 2)
      local ok = d:year() > 1 or d:monthOfYear() >= 3
      assert.is_false(ok)
    end)

    it("fails for month 1 year 1", function()
      local d = make_date(1, 1)
      local ok = d:year() > 1 or d:monthOfYear() >= 3
      assert.is_false(ok)
    end)
  end)

  -- ---------------------------------------------------------------
  -- World / hospital pre-condition checks
  -- ---------------------------------------------------------------
  describe("world pre-condition validation", function()
    it("accepts a world with diseases loaded", function()
      local map = make_map(30, 30, 64, 64)
      local hospital = make_hospital()
      local world, _ = make_world(hospital, map)

      assert.is_truthy(world)
      assert.is_truthy(hospital)
      assert.is_true(#world.available_diseases > 0)
    end)

    it("detects a world with no diseases", function()
      local map = make_map(30, 30, 64, 64)
      local hospital = make_hospital()
      local world, _ = make_world(hospital, map)
      world.available_diseases = {}

      assert.is_false(#world.available_diseases > 0)
    end)
  end)

end)
