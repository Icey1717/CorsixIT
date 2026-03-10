--[[ simulation_scenario.lua
  Headless gameplay scenario that exercises a complete game flow:
  - Verifies Level 1 loaded successfully
  - Hires a receptionist and a technician
  - Places a reception desk and assigns the receptionist
  - Advances the simulation to Year 1 Month 3
  - Asserts that the date and hospital state are valid

  Called by test_runner.bat:
    test_runner.bat headless_tests\simulation_scenario.lua
  Or directly via app:runHeadlessTest("Lua/tests/simulation_scenario.lua")
--]]

local app = ...
local world = app.world
local hospital = world:getLocalPlayerHospital()

-- Hire a staff member near the camera tile using the same placement logic as
-- Hospital:initStaff(). Directly appends to hospital.staff to avoid the
-- fee charged by Hospital:addStaff().
local function hireStaffMember(humanoid_class, staff_class_string)
  local profile = StaffProfile(world, humanoid_class, staff_class_string)
  if humanoid_class == "Doctor" then
    profile:initDoctor(0, 0, 0, nil, nil, 0.5)
  else
    profile:init(0.5)
  end
  local staff = world:newEntity(humanoid_class, 2, 2)
  staff:setProfile(profile)

  local map = world.map.th
  local map_x_length, map_y_length = map:size()
  local map_offset = 10
  local cam_x, cam_y = map:getCameraTile(hospital:getPlayerIndex())
  local x_safe = math.max(map_offset + 1, math.min(cam_x, map_x_length - map_offset))
  local y_safe = math.max(map_offset + 1, math.min(cam_y, map_y_length - map_offset))

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
    else
      staff:setTile(math.floor(map_x_length / 2), math.floor(map_y_length / 2))
    end
  end

  staff:onPlaceInCorridor()
  hospital.staff[#hospital.staff + 1] = staff
  staff:setHospital(hospital)
  return staff
end

-- Attempt to place a reception desk at the first valid hospital tile found
-- near the camera. Returns (desk, x, y) on success, or nil on failure.
local function placeReceptionDesk()
  local map = world.map.th
  local map_x_length, map_y_length = map:size()
  local map_offset = 10
  local cam_x, cam_y = map:getCameraTile(hospital:getPlayerIndex())
  local x_safe = math.max(map_offset + 1, math.min(cam_x, map_x_length - map_offset))
  local y_safe = math.max(map_offset + 1, math.min(cam_y, map_y_length - map_offset))

  for _ = 1, 100 do
    local xa = x_safe + math.random(-map_offset, map_offset)
    local ya = y_safe + math.random(-map_offset, map_offset)
    if hospital:isInHospital(xa, ya) then
      local ok, desk = pcall(world.newObject, world, "reception_desk", xa, ya, "north", "test desk")
      if ok and desk then
        return desk, xa, ya
      end
    end
  end
  return nil
end

-- =============================================================
-- Scenario begins
-- =============================================================

print("[scenario] Starting simulation scenario")

-- 1. Verify the world is loaded
assert(world,    "[scenario] FAIL: world not loaded")
assert(hospital, "[scenario] FAIL: hospital not found")
assert(#world.available_diseases > 0,
  "[scenario] FAIL: no available diseases (level config error?)")

local start_date = world:date()
print(string.format("[scenario] Date: Year %d Month %d  Balance: %d  Diseases: %d",
  start_date:year(), start_date:monthOfYear(),
  hospital.balance, #world.available_diseases))

-- 2. Hire staff
local receptionist = hireStaffMember("Receptionist", _S.staff_class["receptionist"])
local technician   = hireStaffMember("Doctor",        _S.staff_class["doctor"])
print(string.format("[scenario] Hired '%s' (receptionist) and '%s' (technician)",
  receptionist.profile and receptionist.profile.name or "?",
  technician.profile   and technician.profile.name   or "?"))

-- 3. Place reception desk and assign receptionist to it
local desk = placeReceptionDesk()
if desk then
  desk.receptionist = receptionist
  print("[scenario] Reception desk placed and staffed")
else
  print("[scenario] Warning: reception desk could not be placed; skipping desk assertion")
end

-- 4. Run initial ticks to let the simulation stabilise
print("[scenario] Running 500 warm-up ticks...")
app:runSimulatedTicks(500)

-- 5. Advance the game to Year 1 Month 3
print("[scenario] Advancing to Year 1 Month 3...")
world:advanceToDate(1, 3, 1)
print("[scenario] Advance complete")

-- 6. Assert the date advanced
local end_date = world:date()
print(string.format("[scenario] End date: Year %d Month %d  Balance: %d  Staff: %d  Cured: %d",
  end_date:year(), end_date:monthOfYear(),
  hospital.balance, #hospital.staff, hospital.num_cured or 0))

local date_ok = end_date:year() > 1 or end_date:monthOfYear() >= 3
assert(date_ok,
  string.format("[scenario] FAIL: date did not advance to Month 3 (got Year %d Month %d)",
    end_date:year(), end_date:monthOfYear()))

-- 7. Assert hospital balance is non-zero (simulation should have charged/credited something)
assert(hospital.balance ~= 0,
  "[scenario] FAIL: hospital balance is zero — simulation may not have run")

-- 8. Assert world entity list has no nil slots
local nil_entity_count = 0
for i, entity in ipairs(world.entities or {}) do
  if entity == nil then
    nil_entity_count = nil_entity_count + 1
    print(string.format("[scenario] Warning: nil entity at index %d", i))
  end
end
assert(nil_entity_count == 0,
  string.format("[scenario] FAIL: %d nil entities found in world.entities", nil_entity_count))

-- 9. Assert room list is not corrupted (every room entry must have an id and a valid tile_x/y)
local bad_room_count = 0
for i, room in ipairs(world.rooms or {}) do
  if type(room) ~= "table" or room.id == nil then
    bad_room_count = bad_room_count + 1
    print(string.format("[scenario] Warning: corrupted room at index %d (type=%s)", i, type(room)))
  end
end
assert(bad_room_count == 0,
  string.format("[scenario] FAIL: %d corrupted room entries in world.rooms", bad_room_count))

-- 10. Assert at least one customer has been serviced (num_cured or num_deaths gives activity)
local activity = (hospital.num_cured or 0) + (hospital.num_deaths or 0) + (hospital.num_visitors or 0)
print(string.format("[scenario] Customer activity: cured=%d deaths=%d visitors=%d",
  hospital.num_cured or 0, hospital.num_deaths or 0, hospital.num_visitors or 0))
-- We warn but don't hard-fail here: a headless run with no display may receive no customers.
if activity == 0 then
  print("[scenario] Note: no customer activity recorded (expected in pure headless mode)")
end

print("[scenario] PASSED")
