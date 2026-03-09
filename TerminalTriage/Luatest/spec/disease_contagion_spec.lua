--[[ Terminal Triage — Disease Contagion Alignment Tests
  Verifies that disease.contagious flags are semantically correct for the IT
  fiction: only network/malware diseases can spread (and therefore trigger
  malware-outbreak epidemic events).  Hardware defects, physical damage, and
  user-error problems must be non-contagious so that only genuine digital
  infections produce outbreak faxes.

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

-- CWD is TerminalTriage/Luatest/ → up 1 = TerminalTriage/
local mod_root      = up_n(lfs.currentdir(), 1)
local diseases_dir  = mod_root .. "Lua" .. pathsep .. "diseases" .. pathsep

-- ── sandbox helpers ──────────────────────────────────────────────────────────

-- Returns a deep auto-vivifying proxy used to swallow _S string lookups.
local function make_strings()
  local function av()
    local t = {}
    setmetatable(t, { __index = function(_, _) return av() end })
    return t
  end
  return av()
end

--- Load a disease file and return the `disease` table it defines.
-- Returns disease_table or nil, error_message.
-- Uses debug.setupvalue to inject _ENV (Lua 5.4 compatible; no setfenv).
local function load_disease(filename)
  local path = diseases_dir .. filename
  local chunk, err = loadfile(path)
  if not chunk then return nil, "loadfile failed: " .. tostring(err) end

  -- Disease files use: local disease = {} … return disease
  -- They reference _S for strings, AnimationEffect for visual effects, and
  -- TheApp.config for a few feature flags. All are mocked via auto-vivifying
  -- proxies so that property reads return a dummy value without errors.
  local function av()
    local t = {}
    setmetatable(t, { __index = function(_, _) return av() end })
    return t
  end
  local env = setmetatable({
    _S              = make_strings(),
    math            = math,
    corsixth        = { require = function() end },
    AnimationEffect = av(),
    TheApp          = av(),
  }, { __index = _G })
  debug.setupvalue(chunk, 1, env)

  local ok, result = pcall(chunk)
  if not ok then return nil, "runtime error: " .. tostring(result) end
  if type(result) ~= "table" then
    return nil, "expected disease table return, got " .. type(result)
  end
  return result
end

-- ── expected contagion map ────────────────────────────────────────────────────
-- true  = spreads through facility network (malware / software infection)
-- false = device-specific or physical issue (hardware, user error, etc.)
local expected = {
  -- ── malware / network infections → contagious ────────────────────────────
  discrete_itching        = true,  -- Ransomwear: ransomware spreads across network
  fake_blood              = true,  -- Phishing Hangover: phishing chain infects devices
  infectious_laughter     = true,  -- Latency Gremlins: network issue spreads through LAN
  kidney_beans            = true,  -- Data Corruption: malware-caused, spreads on shared storage
  gut_rot                 = true,  -- Software Rot: corrupted packages spread in shared environments
  sleeping_illness        = true,  -- Update Loop Fever: botched update propagates through network
  uncommon_cold           = true,  -- Registry Rot: viral registry damage from malware
  transparency            = true,  -- Privacy Spill: spyware exfiltrates via network

  -- ── hardware defects → not contagious ────────────────────────────────────
  bloaty_head             = false, -- Battery Balloon: physical battery swelling
  fractured_bones         = false, -- Screen Splatter: physical screen damage
  hairyitis               = false, -- Cable Nesting: physical cable disorder
  invisibility            = false, -- Wi-Fi Stage Fright: device-specific RF issue
  serious_radiation       = false, -- Thermal Meltdown: hardware overheating
  iron_lungs              = false, -- Overclocking Incident: user-caused hardware damage

  -- ── user-error / behavioural issues → not contagious ────────────────────
  alien_dna               = false, -- Driver Amnesia: device-specific driver conflict
  baldness                = false, -- Desktop Archaeology: hoarding, device-specific
  broken_heart            = false, -- Port Collapse: physical port damage
  broken_wind             = false, -- Backup Mirage: user forgot to make backups
  chronic_nosehair        = false, -- Password Panic: user-specific credential issue
  corrugated_ankles       = false, -- Button Mashing Syndrome: physical wear from user
  gastric_ejections       = false, -- Folder Catastrophe: user error with files
  golf_stones             = false, -- Hard Drive Calcification: physical drive wear
  heaped_piles            = false, -- Disk Overflow: storage filled by single user
  jellyitis               = false, -- Tab Tsunami: browser misuse, device-specific
  king_complex            = false, -- Admin Complex: user entitlement issue
  ruptured_nodules        = false, -- Settings Labyrinth: user misconfigured settings
  slack_tongue            = false, -- Notification Storm: app overload, device-specific
  spare_ribs              = false, -- Cloud Confusion: user confusion, not an infection
  sweaty_palms            = false, -- Static Discharge Syndrome: physical ESD
  the_squits              = false, -- Crash Loop: device-specific instability
  third_degree_sideburns  = false, -- Sync Drift: timing/clock issue, device-specific
  tv_personalities        = false, -- Printer Diplomacy Failure: peripheral problem
  unexpected_swelling     = false, -- RAM Bloat: resource hog, device-specific
  pregnant                = false, -- (no IT equivalent; not used in campaign)
}

-- ── tests ─────────────────────────────────────────────────────────────────────

describe("Disease contagion flags", function()
  for id, should_be_contagious in pairs(expected) do
    local filename = id .. ".lua"
    it(id .. " contagious=" .. tostring(should_be_contagious), function()
      local d, err = load_disease(filename)
      assert.is_not_nil(d, "could not load " .. filename .. ": " .. tostring(err))
      assert.equal(d.id, id,
        filename .. " disease.id should be '" .. id .. "'")
      assert.equal(d.contagious, should_be_contagious,
        id .. " should have contagious=" .. tostring(should_be_contagious) ..
        " (IT fiction: " .. (should_be_contagious and "malware/network infection" or "hardware/user-error issue") .. ")")
    end)
  end
end)
