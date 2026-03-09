--[[ Terminal Triage — Level Content Validation Tests
  Validates that each campaign level has correct IT-themed content,
  proper disease/room configuration, and appropriate win/lose conditions.

  Run from TerminalTriage/Luatest/:
    busted
--]]

local lfs = require("lfs")
local pathsep = package.config:sub(1, 1)

local function up_n(path, n)
  local p = path:gsub("[/\\]$", "")
  for _ = 1, n do p = p:match("(.*)[/\\].*") or p end
  return p .. pathsep
end

local mod_root   = up_n(lfs.currentdir(), 1)
local levels_dir = mod_root .. "Levels" .. pathsep
local campaigns_dir = mod_root .. "Campaigns" .. pathsep

-- ── helpers ───────────────────────────────────────────────────────────────────

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close(); return true end
  return false
end

--- Parse a level file into structured tables.
--- Returns:
---   directives  { Name, MapFile, LevelBriefingTable_en, LevelDebriefingTable_en, ... }
---   expertise   array of { index, known, rsch, extra1, extra2 }
---   criteria    { win = [...], lose = [...] }
---   objects     array of { index, ... }
local function parse_level(path)
  local directives = {}
  local expertise  = {}
  local win_crit   = {}
  local lose_crit  = {}
  local objects    = {}

  local f = assert(io.open(path, "r"), "Cannot open: " .. path)
  local full = f:read("*a")
  f:close()

  -- %-directives (single-line values)
  for line in full:gmatch("[^\n]+") do
    -- %Key = "value"
    local k, v = line:match("^%%([%w_%.]+)%s*=%s*\"(.-)\"")
    if k then directives[k:gsub("%.", "_")] = v end
    -- %Key = unquoted
    if not k then
      k, v = line:match("^%%([%w_%.]+)%s*=%s*(%S+)")
      if k then directives[k:gsub("%.", "_")] = v end
    end
  end

  -- Multi-line %LevelBriefingTable.en = "..." block (may span lines)
  local briefing = full:match("%%LevelBriefingTable%.en%s*=%s*\"(.-)\"")
  if briefing then directives["LevelBriefingTable_en"] = briefing end
  local debriefing = full:match("%%LevelDebriefingTable%.en%s*=%s*\"(.-)\"")
  if debriefing then directives["LevelDebriefingTable_en"] = debriefing end

  -- #expertise[n].Known.RschReqd[.MaxDiagDiff] known rsch [maxdiag] ID [TYPE]
  for line in full:gmatch("[^\n]+") do
    local idx = line:match("^#expertise%[(%d+)%]")
    if idx then
      -- Extract Known value
      local known = line:match("%.Known%.RschReqd%s+(%d+)")
      table.insert(expertise, { index = tonumber(idx), known = tonumber(known) })
    end

    -- #win_criteria[n].Criteria.MaxMin.Value.Group.Bound  C M V G B
    local wi = line:match("^#win_criteria%[(%d+)%]")
    if wi then
      local c, m, v = line:match("Bound%s+(%d+)%s+(%d+)%s+([%-]?%d+)")
      win_crit[tonumber(wi)] = { criteria = tonumber(c), maxmin = tonumber(m), value = tonumber(v) }
    end

    -- #lose_criteria
    local li = line:match("^#lose_criteria%[(%d+)%]")
    if li then
      local c, m, v = line:match("Bound%s+(%d+)%s+(%d+)%s+([%-]?%d+)")
      lose_crit[tonumber(li)] = { criteria = tonumber(c), maxmin = tonumber(m), value = tonumber(v) }
    end

    -- #objects[n]
    local oi = line:match("^#objects%[(%d+)%]")
    if oi then table.insert(objects, tonumber(oi)) end
  end

  return directives, expertise, win_crit, lose_crit, objects
end

--- Parse the campaign file to get the levels list.
local function get_campaign_levels()
  local path = campaigns_dir .. "terminal_triage.campaign"
  local chunk, err = loadfile(path)
  assert(chunk, "Failed to load campaign: " .. tostring(err))
  local env = {}
  setmetatable(env, { __index = _G, __newindex = function(t, k, v) rawset(t, k, v) end })
  debug.setupvalue(chunk, 1, env)
  chunk()
  return env.levels or {}
end

--- Check whether all win_criteria values are zero (disabled / tutorial mode).
local function all_criteria_zero(criteria)
  for _, c in pairs(criteria) do
    if c.criteria ~= 0 then return false end
  end
  return true
end

-- ── Campaign level list ───────────────────────────────────────────────────────

describe("Campaign level count", function()
  it("campaign references at least 3 levels", function()
    local levels = get_campaign_levels()
    assert.truthy(#levels >= 3,
      "Expected ≥ 3 levels, got " .. #levels)
  end)

  it("all referenced level files exist", function()
    for _, ref in ipairs(get_campaign_levels()) do
      assert.truthy(file_exists(levels_dir .. ref),
        "Missing level file: " .. ref)
    end
  end)

  it("all referenced map files exist", function()
    for _, ref in ipairs(get_campaign_levels()) do
      local d, _, _, _, _ = parse_level(levels_dir .. ref)
      local mapfile = d["MapFile"]
      assert.not_nil(mapfile, ref .. " missing %MapFile")
      assert.truthy(file_exists(levels_dir .. mapfile),
        ref .. " references missing map: " .. tostring(mapfile))
    end
  end)
end)

-- ── Level 1: First Contact (tutorial — no win conditions) ─────────────────────

describe("Level 1 — First Contact", function()
  local path = levels_dir .. "tt_level_01.level"

  it("level file exists", function()
    assert.truthy(file_exists(path))
  end)

  it("has IT-themed briefing text", function()
    local d = parse_level(path)
    local b = d["LevelBriefingTable_en"] or d["LevelBriefing"] or ""
    -- Should mention devices/tech/repair, not patients/hospital/cure
    assert.falsy(b:lower():find("hospital"),  "Level 1 briefing should not mention 'hospital'")
    assert.falsy(b:lower():find("patients"),  "Level 1 briefing should not mention 'patients'")
    assert.truthy(#b > 20, "Briefing must be non-trivial")
  end)

  it("win conditions are all zeroed (tutorial level)", function()
    local _, _, win = parse_level(path)
    assert.truthy(all_criteria_zero(win), "Level 1 must have no win conditions")
  end)

  it("has at least 3 diseases configured", function()
    local _, expertise = parse_level(path)
    -- Count non-GENERAL_PRACTICE expertise entries (index > 1)
    local disease_count = 0
    for _, e in ipairs(expertise) do
      if e.index > 1 and e.index <= 35 then disease_count = disease_count + 1 end
    end
    assert.truthy(disease_count >= 3,
      "Level 1 needs ≥ 3 diseases, got " .. disease_count)
  end)
end)

-- ── Level 2: Neighborhood Repair Shop ────────────────────────────────────────

describe("Level 2 — Neighborhood Repair Shop", function()
  local path = levels_dir .. "tt_level_02.level"

  it("level file exists", function()
    assert.truthy(file_exists(path))
  end)

  it("has %Name directive", function()
    local d = parse_level(path)
    assert.not_nil(d["Name"])
    assert.truthy(#d["Name"] > 0)
  end)

  it("has IT-themed briefing text", function()
    local d = parse_level(path)
    local b = d["LevelBriefingTable_en"] or d["LevelBriefing"] or ""
    assert.falsy(b:lower():find("hospital"),  "Level 2 briefing should not mention 'hospital'")
    assert.falsy(b:lower():find("patients"),  "Level 2 briefing should not mention 'patients'")
    assert.truthy(#b > 20, "Briefing must be non-trivial")
  end)

  it("has at least 5 diseases configured", function()
    local _, expertise = parse_level(path)
    local count = 0
    for _, e in ipairs(expertise) do
      if e.index > 1 and e.index <= 35 then count = count + 1 end
    end
    assert.truthy(count >= 5, "Level 2 needs ≥ 5 diseases, got " .. count)
  end)

  it("has at least 2 diagnosis rooms configured", function()
    local _, expertise = parse_level(path)
    local count = 0
    for _, e in ipairs(expertise) do
      if e.index >= 36 and e.index <= 43 then count = count + 1 end
    end
    assert.truthy(count >= 2, "Level 2 needs ≥ 2 diagnosis rooms, got " .. count)
  end)

  it("has active win conditions (not all zero)", function()
    local _, _, win = parse_level(path)
    assert.falsy(all_criteria_zero(win), "Level 2 must have win conditions")
  end)

  it("has reputation win condition ≥ 700", function()
    local _, _, win = parse_level(path)
    local found = false
    for _, c in pairs(win) do
      if c.criteria == 1 and c.maxmin == 1 and c.value >= 700 then
        found = true; break
      end
    end
    assert.truthy(found, "Level 2 must require reputation ≥ 700")
  end)

  it("has active lose conditions", function()
    local _, _, _, lose = parse_level(path)
    local has_active = false
    for _, c in pairs(lose) do
      if c.criteria ~= 0 then has_active = true; break end
    end
    assert.truthy(has_active, "Level 2 must have lose conditions")
  end)
end)

-- ── Level 3: Student Tech Hub ─────────────────────────────────────────────────

describe("Level 3 — Student Tech Hub", function()
  local path = levels_dir .. "tt_level_03.level"

  it("level file exists", function()
    assert.truthy(file_exists(path))
  end)

  it("has %Name directive", function()
    local d = parse_level(path)
    assert.not_nil(d["Name"])
    assert.truthy(#d["Name"] > 0)
  end)

  it("has IT-themed briefing text", function()
    local d = parse_level(path)
    local b = d["LevelBriefingTable_en"] or d["LevelBriefing"] or ""
    assert.falsy(b:lower():find("hospital"),  "Level 3 briefing should not mention 'hospital'")
    assert.falsy(b:lower():find("patients"),  "Level 3 briefing should not mention 'patients'")
    assert.truthy(#b > 20, "Briefing must be non-trivial")
  end)

  it("has at least 10 diseases configured", function()
    local _, expertise = parse_level(path)
    local count = 0
    for _, e in ipairs(expertise) do
      if e.index > 1 and e.index <= 35 then count = count + 1 end
    end
    assert.truthy(count >= 10, "Level 3 needs ≥ 10 diseases, got " .. count)
  end)

  it("has at least 3 diagnosis rooms configured", function()
    local _, expertise = parse_level(path)
    local count = 0
    for _, e in ipairs(expertise) do
      if e.index >= 36 and e.index <= 43 then count = count + 1 end
    end
    assert.truthy(count >= 3, "Level 3 needs ≥ 3 diagnosis rooms, got " .. count)
  end)

  it("has more diseases than Level 2", function()
    local _, e2 = parse_level(levels_dir .. "tt_level_02.level")
    local _, e3 = parse_level(levels_dir .. "tt_level_03.level")
    local count2, count3 = 0, 0
    for _, e in ipairs(e2) do if e.index > 1 and e.index <= 35 then count2 = count2 + 1 end end
    for _, e in ipairs(e3) do if e.index > 1 and e.index <= 35 then count3 = count3 + 1 end end
    assert.truthy(count3 > count2,
      "Level 3 should have more diseases than Level 2 (" .. count3 .. " vs " .. count2 .. ")")
  end)

  it("has active win conditions", function()
    local _, _, win = parse_level(path)
    local has_active = false
    for _, c in pairs(win) do
      if c.criteria ~= 0 then has_active = true; break end
    end
    assert.falsy(all_criteria_zero(win), "Level 3 must have win conditions")
  end)

  it("has reputation win condition ≥ 700", function()
    local _, _, win = parse_level(path)
    local found = false
    for _, c in pairs(win) do
      if c.criteria == 1 and c.maxmin == 1 and c.value >= 700 then found = true; break end
    end
    assert.truthy(found, "Level 3 must require reputation ≥ 700")
  end)

  it("has cash win condition ≥ 100000", function()
    local _, _, win = parse_level(path)
    local found = false
    for _, c in pairs(win) do
      if c.criteria == 2 and c.maxmin == 1 and c.value >= 100000 then found = true; break end
    end
    assert.truthy(found, "Level 3 must require cash ≥ $100,000")
  end)

  it("has stricter win conditions than Level 2", function()
    local _, _, win2 = parse_level(levels_dir .. "tt_level_02.level")
    local _, _, win3 = parse_level(levels_dir .. "tt_level_03.level")
    local active2, active3 = 0, 0
    for _, c in pairs(win2) do if c.criteria ~= 0 then active2 = active2 + 1 end end
    for _, c in pairs(win3) do if c.criteria ~= 0 then active3 = active3 + 1 end end
    assert.truthy(active3 >= active2,
      "Level 3 should have at least as many win criteria as Level 2")
  end)

  it("has active lose conditions including death rate check", function()
    local _, _, _, lose = parse_level(path)
    local has_death = false
    for _, c in pairs(lose) do
      if c.criteria == 5 then has_death = true; break end
    end
    assert.truthy(has_death, "Level 3 must have a death-rate lose condition (criteria 5)")
  end)
end)
