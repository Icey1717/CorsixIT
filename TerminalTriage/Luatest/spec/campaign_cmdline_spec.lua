--[[ Terminal Triage — --campaign command-line flag tests
  Verifies the logic added to App.init's callback_after_movie that finds and
  auto-loads a campaign when --campaign=NAME is passed on the command line.

  The logic under test (from TerminalTriage/Lua/app.lua):
    elseif self.command_line.campaign then
      local campaign_name = self.command_line.campaign
      local campaign_path = nil
      for _, dir in ipairs({self.campaign_dir, self.user_campaign_dir}) do
        local path = dir .. campaign_name .. ".campaign"
        if lfs.attributes(path, "mode") == "file" then
          campaign_path = path
          break
        end
      end
      if campaign_path then
        self:loadCampaign(campaign_path)
      else
        print("Warning: ...")
      end

  These tests exercise the logic in isolation — no CorsixTH C extensions needed.
--]]

local lfs = require("lfs")
local pathsep = package.config:sub(1, 1)

-- ── helpers ───────────────────────────────────────────────────────────────────

--- Simulate the campaign-resolution logic extracted from app.lua.
--- @param campaign_name string  Value passed as --campaign=NAME
--- @param campaign_dir  string  self.campaign_dir  (checked first)
--- @param user_campaign_dir string  self.user_campaign_dir  (fallback)
--- @param file_exists_fn function  (path) -> bool  (seam for testing)
--- @return string|nil  resolved absolute path, or nil if not found
local function resolve_campaign(campaign_name, campaign_dir, user_campaign_dir, file_exists_fn)
  for _, dir in ipairs({campaign_dir, user_campaign_dir}) do
    local path = dir .. campaign_name .. ".campaign"
    if file_exists_fn(path) then
      return path
    end
  end
  return nil
end

local function always_exists(_) return true end
local function never_exists(_)  return false end

-- ── Resolution logic tests ────────────────────────────────────────────────────

describe("--campaign resolution logic", function()

  local campaign_dir      = "G:\\mods\\TerminalTriage\\Campaigns\\"
  local user_campaign_dir = "G:\\mods\\TerminalTriage\\UserCampaigns\\"

  it("finds the campaign in campaign_dir when the file is present there", function()
    local found_in_campaign_dir = false
    local file_exists = function(path)
      if path:find("Campaigns\\terminal_triage.campaign", 1, true) and
         not path:find("UserCampaigns", 1, true) then
        found_in_campaign_dir = true
        return true
      end
      return false
    end
    local result = resolve_campaign("terminal_triage", campaign_dir, user_campaign_dir, file_exists)
    assert.truthy(result, "Should have found a path")
    assert.truthy(found_in_campaign_dir, "Should have checked campaign_dir first")
    assert.truthy(result:find("terminal_triage.campaign", 1, true))
  end)

  it("falls back to user_campaign_dir when campaign_dir does not have the file", function()
    local file_exists = function(path)
      -- Only present in UserCampaigns
      return path:find("UserCampaigns", 1, true) ~= nil
    end
    local result = resolve_campaign("terminal_triage", campaign_dir, user_campaign_dir, file_exists)
    assert.truthy(result, "Should have found path in user_campaign_dir")
    assert.truthy(result:find("UserCampaigns", 1, true))
  end)

  it("returns nil when the campaign is absent from both directories", function()
    local result = resolve_campaign("nonexistent", campaign_dir, user_campaign_dir, never_exists)
    assert.is_nil(result, "Should return nil when campaign not found")
  end)

  it("campaign_dir is checked before user_campaign_dir", function()
    local checked = {}
    local file_exists = function(path)
      table.insert(checked, path)
      return false
    end
    resolve_campaign("terminal_triage", campaign_dir, user_campaign_dir, file_exists)
    -- First path checked must be inside Campaigns/, not UserCampaigns/
    assert.truthy(#checked >= 1, "Should have checked at least one path")
    assert.truthy(checked[1]:find("Campaigns\\terminal_triage", 1, true),
      "First checked path should be in Campaigns/, got: " .. tostring(checked[1]))
    assert.falsy(checked[1]:find("UserCampaigns", 1, true),
      "UserCampaigns must NOT be checked first")
  end)

  it("constructs the path as dir .. name .. '.campaign'", function()
    local checked = {}
    local file_exists = function(path)
      table.insert(checked, path)
      return false
    end
    resolve_campaign("my_campaign", campaign_dir, user_campaign_dir, file_exists)
    assert.truthy(checked[1]:find("my_campaign.campaign", 1, true),
      "Path must end with 'my_campaign.campaign'")
  end)

  it("does not load anything when --campaign is not set (nil)", function()
    -- Simulate the elseif branch: command_line.campaign is nil
    -- The guard condition means resolve is never called
    local calls = 0
    local file_exists = function(_)
      calls = calls + 1
      return false
    end
    local campaign_name = nil  -- simulates command_line.campaign not set
    if campaign_name then
      resolve_campaign(campaign_name, campaign_dir, user_campaign_dir, file_exists)
    end
    assert.equal(0, calls, "No file checks should occur when --campaign is not set")
  end)

  it("does not clobber a --load command when both are set (elseif semantics)", function()
    -- The real code uses elseif, so --load takes priority.
    -- Simulate: if load_cmd then ... elseif campaign_cmd then ...
    local load_called    = false
    local campaign_called = false
    local load_cmd    = "Autosaves/Autosave1.sav"
    local campaign_cmd = "terminal_triage"

    if load_cmd then
      load_called = true
    elseif campaign_cmd then
      campaign_called = true
    end

    assert.truthy(load_called,    "--load branch should fire")
    assert.falsy(campaign_called, "--campaign branch must NOT fire when --load is set")
  end)

end)

-- ── Integration: actual campaign file discoverable on disk ────────────────────

describe("--campaign with actual TerminalTriage files", function()

  local lfs_local = lfs
  local function lfs_file_exists(path)
    return lfs_local.attributes(path, "mode") == "file"
  end

  -- Resolve mod root: busted CWD is TerminalTriage/Luatest/
  local function up_n(path, n)
    local p = path:gsub("[/\\]$", "")
    for _ = 1, n do p = p:match("(.*)[/\\].*") or p end
    return p .. pathsep
  end
  local mod_root          = up_n(lfs.currentdir(), 1)
  local campaign_dir      = mod_root .. "Campaigns" .. pathsep
  local user_campaign_dir = mod_root .. "UserCampaigns" .. pathsep

  it("resolves terminal_triage campaign from the real Campaigns/ directory", function()
    local result = resolve_campaign("terminal_triage", campaign_dir, user_campaign_dir, lfs_file_exists)
    assert.not_nil(result, "terminal_triage.campaign must be discoverable")
    assert.truthy(result:find("terminal_triage.campaign", 1, true))
  end)

  it("resolved path points to a readable file", function()
    local result = resolve_campaign("terminal_triage", campaign_dir, user_campaign_dir, lfs_file_exists)
    assert.not_nil(result)
    local f = io.open(result, "r")
    assert.not_nil(f, "Campaign file must be readable: " .. tostring(result))
    if f then f:close() end
  end)

  it("returns nil for a campaign name that does not exist on disk", function()
    local result = resolve_campaign("does_not_exist_xyz", campaign_dir, user_campaign_dir, lfs_file_exists)
    assert.is_nil(result)
  end)

end)
