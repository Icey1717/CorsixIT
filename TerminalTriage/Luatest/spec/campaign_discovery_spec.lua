--[[ Terminal Triage — Campaign and Level Discovery Tests
  Verifies that the Terminal Triage campaign and level files are correctly
  structured and discoverable from the mod package.

  Run from TerminalTriage/Luatest/:
    busted

  These tests exercise:
    1. terminal_triage.campaign parses correctly and has a non-empty levels table
    2. Each referenced level file exists in TerminalTriage/Levels/
    3. Level files contain the required %Name and %MapFile directives
    4. The campaign/level directory paths align with the getFullPath override
--]]

-- Resolve the path to the TerminalTriage root.
-- busted is run from TerminalTriage/Luatest/, so lfs.currentdir() gives us
-- that directory; going up one level gives TerminalTriage/.
local lfs = require("lfs")
local pathsep = package.config:sub(1, 1)

local function up_n(path, n)
  local p = path:gsub("[/\\]$", "")  -- strip trailing sep
  for _ = 1, n do
    p = p:match("(.*)[/\\].*") or p
  end
  return p .. pathsep
end

-- CWD is TerminalTriage/Luatest/ → go up 1 to reach TerminalTriage/
local mod_root = up_n(lfs.currentdir(), 1)

-- ── helpers ──────────────────────────────────────────────────────────────────

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close(); return true end
  return false
end

--- Parse a .campaign file by executing it in a clean Lua environment.
--- Returns the populated table or nil + error.
local function parse_campaign(path)
  local chunk, err = loadfile(path)
  if not chunk then return nil, err end
  local env = {}
  setmetatable(env, {__index = _G, __newindex = function(t, k, v) rawset(t, k, v) end})
  -- campaign files assign globals; capture them via the env table
  -- Lua 5.4: use load() with the chunk's env
  local ok, run_err = pcall(function()
    debug.setupvalue(chunk, 1, env)
    chunk()
  end)
  if not ok then return nil, run_err end
  return env
end

--- Read every line of a .level file and extract all %-directives.
--- Returns table: { Name = "...", MapFile = "..." } (and any others present)
local function parse_level_directives(path)
  local result = {}
  local f = assert(io.open(path, "r"), "Cannot open level file: " .. path)
  for line in f:lines() do
    local key, val = line:match("^%%(%w+)%s*=%s*\"(.-)\"")
    if key then result[key] = val end
    -- Also accept un-quoted form: %MapFile = LEVEL.L1
    if not key then
      key, val = line:match("^%%(%w+)%s*=%s*(%S+)")
      if key then result[key] = val end
    end
  end
  f:close()
  return result
end

-- ── Campaign file ─────────────────────────────────────────────────────────────

describe("Campaign file structure", function()

  local campaign_path = mod_root .. "Campaigns" .. pathsep .. "terminal_triage.campaign"

  it("campaign file exists at TerminalTriage/Campaigns/", function()
    assert.truthy(file_exists(campaign_path),
      "Expected campaign file at: " .. campaign_path)
  end)

  it("campaign file parses without error", function()
    local result, err = parse_campaign(campaign_path)
    assert.is_nil(err, "Parse error: " .. tostring(err))
    assert.not_nil(result)
  end)

  it("campaign has a non-empty 'name' field", function()
    local result = assert(parse_campaign(campaign_path))
    assert.not_nil(result.name)
    assert.truthy(#result.name > 0, "Campaign name must be non-empty")
  end)

  it("campaign has a non-empty 'description' or 'description_table'", function()
    local result = assert(parse_campaign(campaign_path))
    local has_desc = (result.description and #result.description > 0)
                  or (result.description_table ~= nil)
    assert.truthy(has_desc, "Campaign must have description or description_table")
  end)

  it("campaign has a non-empty 'levels' table", function()
    local result = assert(parse_campaign(campaign_path))
    assert.not_nil(result.levels, "Campaign must have a 'levels' table")
    assert.truthy(type(result.levels) == "table", "'levels' must be a table")
    assert.truthy(#result.levels > 0,
      "Campaign 'levels' table must contain at least one entry")
  end)

  it("all level entries are non-empty strings ending in .level", function()
    local result = assert(parse_campaign(campaign_path))
    for i, entry in ipairs(result.levels) do
      assert.truthy(type(entry) == "string" and #entry > 0,
        "levels[" .. i .. "] must be a non-empty string")
      assert.truthy(entry:match("%.level$"),
        "levels[" .. i .. "] '" .. entry .. "' must end in .level")
    end
  end)

  it("campaign has a 'winning_text_table' or 'winning_text' field", function()
    local result = assert(parse_campaign(campaign_path))
    local has_win = (result.winning_text and #tostring(result.winning_text) > 0)
                 or (result.winning_text_table ~= nil)
    assert.truthy(has_win, "Campaign must have winning_text or winning_text_table")
  end)

end)

-- ── Level files ───────────────────────────────────────────────────────────────

describe("Level file structure", function()

  local campaign_path = mod_root .. "Campaigns" .. pathsep .. "terminal_triage.campaign"
  local levels_dir    = mod_root .. "Levels" .. pathsep

  -- Load the levels list once for all sub-tests
  local campaign_levels
  before_each(function()
    local result = assert(parse_campaign(campaign_path))
    campaign_levels = result.levels
  end)

  it("at least one level file is referenced in the campaign", function()
    assert.truthy(#campaign_levels > 0)
  end)

  it("each referenced level file exists in TerminalTriage/Levels/", function()
    for _, level_ref in ipairs(campaign_levels) do
      local level_path = levels_dir .. level_ref
      assert.truthy(file_exists(level_path),
        "Level file not found: " .. level_path)
    end
  end)

  it("each level file has a %%Name directive", function()
    for _, level_ref in ipairs(campaign_levels) do
      local level_path = levels_dir .. level_ref
      local directives = parse_level_directives(level_path)
      assert.not_nil(directives.Name,
        level_ref .. " is missing a %%Name directive")
      assert.truthy(#directives.Name > 0,
        level_ref .. " %%Name must be non-empty")
    end
  end)

  it("each level file has a %%MapFile directive", function()
    for _, level_ref in ipairs(campaign_levels) do
      local level_path = levels_dir .. level_ref
      local directives = parse_level_directives(level_path)
      assert.not_nil(directives.MapFile,
        level_ref .. " is missing a %%MapFile directive")
      assert.truthy(#directives.MapFile > 0,
        level_ref .. " %%MapFile must be non-empty")
    end
  end)

end)

-- ── Path alignment ────────────────────────────────────────────────────────────

describe("Campaign and level directory path alignment", function()

  local pathsep_local = package.config:sub(1, 1)

  it("mod_root contains 'TerminalTriage'", function()
    assert.truthy(mod_root:find("TerminalTriage", 1, true),
      "mod_root should contain 'TerminalTriage', got: " .. mod_root)
  end)

  it("Campaigns/ dir resolves inside TerminalTriage/", function()
    local campaigns_dir = mod_root .. "Campaigns" .. pathsep_local
    assert.truthy(campaigns_dir:find("TerminalTriage", 1, true))
    assert.truthy(campaigns_dir:find("Campaigns", 1, true))
    assert.falsy(campaigns_dir:find("CorsixTH", 1, true))
  end)

  it("Levels/ dir resolves inside TerminalTriage/", function()
    local levels_dir = mod_root .. "Levels" .. pathsep_local
    assert.truthy(levels_dir:find("TerminalTriage", 1, true))
    assert.truthy(levels_dir:find("Levels", 1, true))
    assert.falsy(levels_dir:find("CorsixTH", 1, true))
  end)

  it("level file is discoverable by joining level_dir with campaign level ref", function()
    local campaign_path = mod_root .. "Campaigns" .. pathsep_local .. "terminal_triage.campaign"
    local result = assert(parse_campaign(campaign_path))
    local levels_dir = mod_root .. "Levels" .. pathsep_local
    for _, level_ref in ipairs(result.levels) do
      local full_path = levels_dir .. level_ref
      assert.truthy(file_exists(full_path),
        "Level not discoverable via level_dir + ref: " .. full_path)
    end
  end)

end)
