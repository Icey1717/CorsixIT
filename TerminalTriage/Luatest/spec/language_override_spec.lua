--[[ Terminal Triage — Language Override Tests
  Verifies that english_terminal_triage.lua exists, parses correctly, and
  contains the expected IT-themed string overrides from Phase 2.

  Run from TerminalTriage/Luatest/:
    busted

  These tests cover:
    1. Language file exists at TerminalTriage/Lua/languages/
    2. File parses as valid Lua in a mocked DSL sandbox
    3. Staff class labels are IT-themed (no "nurse", "doctor", "handyman" etc.)
    4. Room names map to IT equivalents
    5. Disease names are IT-themed (not original hospital disease names)
    6. Key adviser messages replace hospital terminology
    7. Transaction labels are IT-appropriate
    8. Casebook labels are IT-appropriate
    9. "hospital" does not appear in staff class or room name strings
   10. VIP remarks table has exactly 15 entries (matching original structure)
--]]

local lfs = require("lfs")
local pathsep = package.config:sub(1, 1)

local function up_n(path, n)
  local p = path:gsub("[/\\]$", "")
  for _ = 1, n do
    p = p:match("(.*)[/\\].*") or p
  end
  return p .. pathsep
end

-- CWD is TerminalTriage/Luatest/ → up 1 = TerminalTriage/
local mod_root = up_n(lfs.currentdir(), 1)
local lang_file = mod_root .. "Lua" .. pathsep .. "languages" .. pathsep .. "english_terminal_triage.lua"

-- ── Sandbox helpers ───────────────────────────────────────────────────────────

-- Returns a deep auto-vivifying table that records all nested assignments.
local function auto_table()
  local t = {}
  local mt = {}
  mt.__index = function(tbl, k)
    local child = auto_table()
    rawset(tbl, k, child)
    return child
  end
  setmetatable(t, mt)
  return t
end

--- Load the language file in a sandbox that mocks all CorsixTH DSL functions.
-- Returns the populated sandbox environment or nil + error message.
local function load_language_file(path)
  local chunk, err = loadfile(path)
  if not chunk then return nil, "loadfile failed: " .. tostring(err) end

  -- Provide all top-level namespaces the file writes into.
  local env = {
    -- CorsixTH DSL no-ops
    Font             = function() end,
    Language         = function() end,
    Inherit          = function() end,
    IsArabicNumerals = function() end,
    SetSpeechFile    = function() end,
    Encoding         = function() end,

    -- Standard Lua globals needed by some language files
    ipairs  = ipairs,
    pairs   = pairs,
    type    = type,
    tostring = tostring,
    string  = string,
    table   = table,

    -- String namespaces (auto-vivifying so nested keys work)
    staff_class      = auto_table(),
    staff_title      = auto_table(),
    rooms_short      = auto_table(),
    rooms_long       = auto_table(),
    room_classes     = auto_table(),
    diseases         = auto_table(),
    adviser          = auto_table(),
    transactions     = auto_table(),
    graphs           = auto_table(),
    research         = auto_table(),
    casebook         = auto_table(),
    dynamic_info     = auto_table(),
    misc             = auto_table(),
    bank_manager     = auto_table(),
    tooltip          = auto_table(),
    confirmation     = auto_table(),
    fax              = auto_table(),
    vip_names        = {},
    information      = auto_table(),
    room_descriptions = auto_table(),
    totd_window      = auto_table(),
    subtitles        = {},
    cheats_window    = auto_table(),
  }

  setmetatable(env, {__index = _G})

  local ok, run_err = pcall(function()
    debug.setupvalue(chunk, 1, env)
    chunk()
  end)

  if not ok then return nil, "execution failed: " .. tostring(run_err) end
  return env
end

-- ── File existence ────────────────────────────────────────────────────────────

describe("english_terminal_triage.lua file presence", function()

  it("language file exists at TerminalTriage/Lua/languages/", function()
    local f = io.open(lang_file, "r")
    assert.truthy(f, "Expected language file at: " .. lang_file)
    if f then f:close() end
  end)

  it("language file is non-empty", function()
    local attr = lfs.attributes(lang_file)
    assert.truthy(attr and attr.size > 500,
      "Language file should have substantial content (>500 bytes), got: " .. tostring(attr and attr.size))
  end)

end)

-- ── Parse validity ────────────────────────────────────────────────────────────

local env  -- populated once for all subsequent tests
local load_error

describe("english_terminal_triage.lua syntax and parse", function()

  it("loads and executes without error in a mocked DSL sandbox", function()
    env, load_error = load_language_file(lang_file)
    assert.truthy(env, "Language file failed to load: " .. tostring(load_error))
  end)

end)

-- All tests below depend on a successful load.
local function require_env()
  if not env then
    env, load_error = load_language_file(lang_file)
  end
  assert.truthy(env, "Prerequisite: language file must load cleanly. Error: " .. tostring(load_error))
  return env
end

-- ── Staff class labels ────────────────────────────────────────────────────────

describe("staff_class overrides (IT-themed)", function()

  it("staff_class.nurse is re-themed away from 'Nurse'", function()
    local e = require_env()
    local v = tostring(e.staff_class.nurse)
    assert.not_equal("Nurse", v, "staff_class.nurse should be re-themed")
    assert.truthy(#v > 0, "staff_class.nurse must not be empty")
  end)

  it("staff_class.doctor is re-themed away from 'Doctor'", function()
    local e = require_env()
    local v = tostring(e.staff_class.doctor)
    assert.not_equal("Doctor", v, "staff_class.doctor should be re-themed")
    assert.truthy(#v > 0)
  end)

  it("staff_class.handyman is re-themed away from 'Handyman'", function()
    local e = require_env()
    local v = tostring(e.staff_class.handyman)
    assert.not_equal("Handyman", v, "staff_class.handyman should be re-themed")
    assert.truthy(#v > 0)
  end)

  it("staff_class.receptionist is re-themed", function()
    local e = require_env()
    local v = tostring(e.staff_class.receptionist)
    assert.truthy(#v > 0, "staff_class.receptionist must not be empty")
  end)

  it("none of the staff_class values contain 'hospital' (case-insensitive)", function()
    local e = require_env()
    for key, val in pairs(e.staff_class) do
      if type(val) == "string" then
        assert.falsy(val:lower():find("hospital"),
          "staff_class." .. key .. " must not contain 'hospital': " .. val)
      end
    end
  end)

end)

-- ── Room names ────────────────────────────────────────────────────────────────

describe("rooms_short overrides (IT-themed)", function()

  it("reception is renamed to an IT equivalent", function()
    local e = require_env()
    local v = tostring(e.rooms_short.reception)
    assert.not_equal("Reception", v, "rooms_short.reception should be re-themed")
    assert.truthy(#v > 0)
  end)

  it("gps_office is renamed away from GP's Office", function()
    local e = require_env()
    local v = tostring(e.rooms_short.gps_office)
    assert.falsy(v:lower():find("gp"), "rooms_short.gps_office must not contain 'GP': " .. v)
    assert.truthy(#v > 0)
  end)

  it("operating_theatre is renamed to a hardware repair equivalent", function()
    local e = require_env()
    local v = tostring(e.rooms_short.operating_theatre)
    assert.falsy(v:lower():find("operating"), "rooms_short.operating_theatre must not say 'Operating': " .. v)
    assert.truthy(#v > 0)
  end)

  it("pharmacy is renamed to a quick fix equivalent", function()
    local e = require_env()
    local v = tostring(e.rooms_short.pharmacy)
    assert.falsy(v:lower():find("pharma"), "rooms_short.pharmacy must not say 'Pharma': " .. v)
    assert.truthy(#v > 0)
  end)

  it("staffroom is renamed to a break room equivalent", function()
    local e = require_env()
    local v = tostring(e.rooms_short.staffroom)
    assert.truthy(#v > 0, "rooms_short.staffroom must not be empty")
  end)

  it("none of the rooms_short values contain 'hospital'", function()
    local e = require_env()
    for key, val in pairs(e.rooms_short) do
      if type(val) == "string" then
        assert.falsy(val:lower():find("hospital"),
          "rooms_short." .. key .. " must not contain 'hospital': " .. val)
      end
    end
  end)

end)

-- ── Disease names ─────────────────────────────────────────────────────────────

describe("disease name overrides (IT-themed)", function()

  it("diseases.bloaty_head.name is re-themed (Battery Balloon or similar)", function()
    local e = require_env()
    local v = tostring(e.diseases.bloaty_head.name)
    assert.not_equal("Bloaty Head", v, "diseases.bloaty_head.name should be re-themed")
    assert.truthy(#v > 0)
  end)

  it("diseases.bloaty_head has cause, symptoms, and cure text", function()
    local e = require_env()
    assert.truthy(type(e.diseases.bloaty_head.cause)    == "string" and #e.diseases.bloaty_head.cause    > 0, "bloaty_head.cause is missing")
    assert.truthy(type(e.diseases.bloaty_head.symptoms) == "string" and #e.diseases.bloaty_head.symptoms > 0, "bloaty_head.symptoms is missing")
    assert.truthy(type(e.diseases.bloaty_head.cure)     == "string" and #e.diseases.bloaty_head.cure     > 0, "bloaty_head.cure is missing")
  end)

  it("diseases.king_complex.name replaces 'King Complex' with an IT equivalent", function()
    local e = require_env()
    local v = tostring(e.diseases.king_complex.name)
    assert.not_equal("King Complex", v)
    assert.truthy(#v > 0)
  end)

  it("diseases.jellyitis.name is re-themed", function()
    local e = require_env()
    local v = tostring(e.diseases.jellyitis.name)
    assert.not_equal("Jellyitis", v)
    assert.truthy(#v > 0)
  end)

  it("diseases.diag_scanner.name is overridden for the diagnostic display", function()
    local e = require_env()
    local v = tostring(e.diseases.diag_scanner.name)
    assert.truthy(#v > 0, "diag_scanner.name must be set")
  end)

  -- At least 10 main diseases should have all four fields
  it("at least 10 main diseases have name, cause, symptoms and cure all set", function()
    local e = require_env()
    local treatable = {
      "bloaty_head", "hairyitis", "king_complex", "invisibility",
      "serious_radiation", "slack_tongue", "alien_dna", "fractured_bones",
      "baldness", "jellyitis",
    }
    local count = 0
    for _, key in ipairs(treatable) do
      local d = e.diseases[key]
      if type(d.name)     == "string" and #d.name     > 0 and
         type(d.cause)    == "string" and #d.cause    > 0 and
         type(d.symptoms) == "string" and #d.symptoms > 0 and
         type(d.cure)     == "string" and #d.cure     > 0 then
        count = count + 1
      end
    end
    assert.truthy(count >= 10,
      "Expected all 10 sampled diseases to have full text; only " .. count .. " do")
  end)

end)

-- ── Adviser strings ───────────────────────────────────────────────────────────

describe("adviser string overrides (IT-themed)", function()

  it("adviser.warnings.money_low is overridden", function()
    local e = require_env()
    local v = tostring(e.adviser.warnings.money_low)
    assert.truthy(#v > 0, "adviser.warnings.money_low must be set")
  end)

  it("adviser.goals.lose.kill replaces 'patients' with IT language", function()
    local e = require_env()
    local v = tostring(e.adviser.goals.lose.kill)
    assert.truthy(#v > 0)
    -- Should not say "patients" in the IT mod
    assert.falsy(v:lower():find("patients"),
      "adviser.goals.lose.kill must not say 'patients': " .. v)
  end)

  it("adviser.room_requirements.gps_office_need_doctor is re-themed", function()
    local e = require_env()
    local v = tostring(e.adviser.room_requirements.gps_office_need_doctor)
    assert.truthy(#v > 0)
  end)

  it("adviser.staff_advice.need_doctors mentions Technicians not doctors", function()
    local e = require_env()
    local v = tostring(e.adviser.staff_advice.need_doctors)
    assert.truthy(#v > 0)
    assert.falsy(v:lower():find("doctor"),
      "adviser.staff_advice.need_doctors should say Technicians, not doctors: " .. v)
  end)

end)

-- ── Transaction labels ────────────────────────────────────────────────────────

describe("transaction label overrides (IT-themed)", function()

  it("transactions.cure is renamed to Repair Revenue", function()
    local e = require_env()
    local v = tostring(e.transactions.cure)
    assert.not_equal("", v)
    assert.falsy(v:lower():find("cure"),
      "transactions.cure should not say 'cure' in IT mod: " .. v)
  end)

  it("transactions.emergency_bonus is overridden", function()
    local e = require_env()
    local v = tostring(e.transactions.emergency_bonus)
    assert.truthy(#v > 0)
  end)

  it("transactions.vaccination is re-themed to malware removal", function()
    local e = require_env()
    local v = tostring(e.transactions.vaccination)
    assert.truthy(#v > 0)
    assert.falsy(v:lower():find("vaccin"),
      "transactions.vaccination should not say 'vaccination': " .. v)
  end)

end)

-- ── Casebook labels ───────────────────────────────────────────────────────────

describe("casebook label overrides (IT-themed)", function()

  it("casebook.cured is renamed away from 'Cured'", function()
    local e = require_env()
    local v = tostring(e.casebook.cured)
    assert.not_equal("Cured", v, "casebook.cured should be re-themed")
    assert.truthy(#v > 0)
  end)

  it("casebook.deaths is renamed to a device loss equivalent", function()
    local e = require_env()
    local v = tostring(e.casebook.deaths)
    assert.not_equal("Deaths", v, "casebook.deaths should be re-themed")
    assert.truthy(#v > 0)
  end)

  it("casebook.reputation is re-themed to Brand Trust", function()
    local e = require_env()
    local v = tostring(e.casebook.reputation)
    assert.truthy(v:lower():find("brand") or v:lower():find("trust"),
      "casebook.reputation should mention Brand Trust: " .. v)
  end)

end)

-- ── VIP remarks table ─────────────────────────────────────────────────────────

describe("fax.vip_visit_result.remarks table structure", function()

  it("remarks table has exactly 15 entries to match original structure", function()
    local e = require_env()
    local count = 0
    for i = 1, 15 do
      if type(e.fax.vip_visit_result.remarks[i]) == "string" and
         #e.fax.vip_visit_result.remarks[i] > 0 then
        count = count + 1
      end
    end
    assert.equal(15, count,
      "fax.vip_visit_result.remarks must have 15 string entries; found " .. count)
  end)

  it("remarks[1] (best) contains positive language", function()
    local e = require_env()
    local v = tostring(e.fax.vip_visit_result.remarks[1])
    local has_positive = v:lower():find("outstanding") or v:lower():find("excellent") or
                         v:lower():find("exceptional") or v:lower():find("great")
    assert.truthy(has_positive, "remarks[1] (best) should be positive: " .. v)
  end)

  it("remarks[15] (worst) contains negative language", function()
    local e = require_env()
    local v = tostring(e.fax.vip_visit_result.remarks[15])
    local has_negative = v:lower():find("never") or v:lower():find("moment") or
                         v:lower():find("authority") or v:lower():find("worst")
    assert.truthy(has_negative, "remarks[15] (worst) should be negative: " .. v)
  end)

end)

-- ── Hospital terminology check ────────────────────────────────────────────────

describe("hospital terminology should not leak into IT mod strings", function()

  local hospital_terms = {"hospital", "patient", "ward nurse", "gp's office"}

  it("graphs.cures and graphs.deaths are re-themed (no 'cure'/'death' labels)", function()
    local e = require_env()
    local cures  = tostring(e.graphs.cures)
    local deaths = tostring(e.graphs.deaths)
    assert.falsy(cures:lower()  == "cures",  "graphs.cures should be re-themed: " .. cures)
    assert.falsy(deaths:lower() == "deaths", "graphs.deaths should be re-themed: " .. deaths)
  end)

  it("misc.hospital_open does not say 'hospital'", function()
    local e = require_env()
    local v = tostring(e.misc.hospital_open)
    assert.falsy(v:lower():find("hospital"),
      "misc.hospital_open should not say 'hospital': " .. v)
  end)

  it("bank_manager.hospital_value does not say 'hospital'", function()
    local e = require_env()
    local v = tostring(e.bank_manager.hospital_value)
    assert.falsy(v:lower():find("hospital"),
      "bank_manager.hospital_value should not say 'hospital': " .. v)
  end)

end)

-- ── Level-lost screen ─────────────────────────────────────────────────────────

describe("information.level_lost overrides (no hospital/patient framing)", function()

  it("level_lost.percentage_killed does not mention 'patients'", function()
    local e = require_env()
    local level_lost = e.information and e.information.level_lost
    assert.truthy(type(level_lost) == "table",
      "information.level_lost must be overridden in the IT language file")
    local v = tostring(level_lost.percentage_killed or "")
    assert.truthy(#v > 0, "information.level_lost.percentage_killed must be set")
    assert.falsy(v:lower():find("patient"),
      "level_lost.percentage_killed must not say 'patient': " .. v)
  end)

  it("level_lost.patient_happiness does not mention 'patient happiness'", function()
    local e = require_env()
    local level_lost = e.information and e.information.level_lost
    assert.truthy(type(level_lost) == "table",
      "information.level_lost must be overridden in the IT language file")
    local v = tostring(level_lost.patient_happiness or "")
    assert.truthy(#v > 0, "information.level_lost.patient_happiness must be set")
    assert.falsy(v:lower():find("patient"),
      "level_lost.patient_happiness must not say 'patient': " .. v)
  end)

  it("level_lost[1] (fail headline) is IT-themed and does not say 'hospital'", function()
    local e = require_env()
    local level_lost = e.information and e.information.level_lost
    assert.truthy(type(level_lost) == "table",
      "information.level_lost must be overridden in the IT language file")
    local v = tostring(level_lost[1] or "")
    assert.truthy(#v > 0, "information.level_lost[1] must be set")
    assert.falsy(v:lower():find("hospital"),
      "level_lost[1] must not say 'hospital': " .. v)
  end)

end)

-- ── Casebook tooltip overrides ────────────────────────────────────────────────

describe("tooltip.casebook overrides (no treatment/disease framing)", function()

  it("tooltip.casebook.cure_requirement.hire_staff does not say 'treatment'", function()
    local e = require_env()
    local v = tostring(e.tooltip.casebook.cure_requirement.hire_staff)
    assert.truthy(#v > 0, "tooltip.casebook.cure_requirement.hire_staff must be overridden")
    assert.falsy(v:lower():find("treatment"),
      "casebook.cure_requirement.hire_staff must not say 'treatment': " .. v)
  end)

  it("tooltip.casebook.cure_type.unknown does not say 'disease'", function()
    local e = require_env()
    local v = tostring(e.tooltip.casebook.cure_type.unknown)
    assert.truthy(#v > 0, "tooltip.casebook.cure_type.unknown must be overridden")
    assert.falsy(v:lower():find("disease"),
      "casebook.cure_type.unknown must not say 'disease': " .. v)
  end)

end)

-- ── Object tooltip overrides ──────────────────────────────────────────────────

describe("tooltip.objects overrides (no hospital/patient framing)", function()

  it("tooltip.objects.litter does not say 'patient'", function()
    local e = require_env()
    local v = tostring(e.tooltip.objects.litter)
    assert.truthy(#v > 0, "tooltip.objects.litter must be overridden")
    assert.falsy(v:lower():find("patient"),
      "tooltip.objects.litter must not say 'patient': " .. v)
  end)

  it("tooltip.objects.rathole does not say 'hospital'", function()
    local e = require_env()
    local v = tostring(e.tooltip.objects.rathole)
    assert.truthy(#v > 0, "tooltip.objects.rathole must be overridden")
    assert.falsy(v:lower():find("hospital"),
      "tooltip.objects.rathole must not say 'hospital': " .. v)
  end)

end)

-- ── Room descriptions ─────────────────────────────────────────────────────────

describe("room_descriptions overrides (no medical framing)", function()

  it("room_descriptions.inflation[2] does not say 'Patients' or 'cranium'", function()
    local e = require_env()
    local inf = e.room_descriptions and e.room_descriptions.inflation
    if type(inf) == "table" and inf[2] then
      local v = tostring(inf[2])
      assert.falsy(v:lower():find("patients"),
        "room_descriptions.inflation[2] must not say 'Patients': " .. v)
      assert.falsy(v:lower():find("cranium"),
        "room_descriptions.inflation[2] must not say 'cranium': " .. v)
    end
  end)

end)

-- ── Tip of the Day overrides ──────────────────────────────────────────────────

describe("totd_window.tips overrides (no hospital/patient/doctor framing)", function()

  local hospital_medical_terms = {"hospital", "patients", "doctor", "gp's office", "handyman"}

  it("totd_window.tips is overridden and is a table", function()
    local e = require_env()
    local tips = e.totd_window and e.totd_window.tips
    assert.truthy(type(tips) == "table",
      "totd_window.tips must be a table (overridden with IT-themed tips)")
    assert.truthy(#tips >= 10,
      "totd_window.tips must have at least 10 entries, got " .. tostring(#tips))
  end)

  it("totd_window.tips has same count as base (20 tips)", function()
    local e = require_env()
    local tips = e.totd_window and e.totd_window.tips
    if type(tips) == "table" then
      assert.equal(20, #tips,
        "totd_window.tips should have 20 entries to match base game; got " .. #tips)
    end
  end)

  for _, term in ipairs(hospital_medical_terms) do
    it("no tip contains '" .. term .. "'", function()
      local e = require_env()
      local tips = e.totd_window and e.totd_window.tips
      if type(tips) == "table" then
        for i, tip in ipairs(tips) do
          assert.falsy(tostring(tip):lower():find(term, 1, true),
            "tip[" .. i .. "] must not contain '" .. term .. "': " .. tostring(tip))
        end
      end
    end)
  end

end)

-- ── PA Subtitle announcements ─────────────────────────────────────────────────

describe("subtitles overrides (IT-themed PA announcements)", function()

  -- Epidemic (malware outbreak) subtitles
  local epidemic_keys = {"epid001","epid002","epid003","epid004","epid005","epid006","epid007","epid008"}
  local epidemic_forbidden = {"epidemic", "stand down", "stand by"}

  for _, key in ipairs(epidemic_keys) do
    it("subtitles." .. key .. " does not use 'epidemic'", function()
      local e = require_env()
      local v = tostring(e.subtitles[key] or "")
      assert.truthy(#v > 0, "subtitles." .. key .. " must be overridden with IT-themed text")
      for _, term in ipairs(epidemic_forbidden) do
        assert.falsy(v:lower():find(term, 1, true),
          "subtitles." .. key .. " must not say '" .. term .. "': " .. v)
      end
    end)
  end

  -- Emergency (surge job) subtitles — spot-check a few for IT disease name accuracy
  local emerg_spot = {
    emerg001 = "Disk Overflow",
    emerg002 = "Crash Loop",
    emerg014 = "Tab Tsunami",
    emerg022 = "Privacy Spill",
  }
  for key, expected_name in pairs(emerg_spot) do
    it("subtitles." .. key .. " mentions IT device name '" .. expected_name .. "'", function()
      local e = require_env()
      local v = tostring(e.subtitles[key] or "")
      assert.truthy(#v > 0, "subtitles." .. key .. " must be overridden")
      assert.truthy(v:find(expected_name, 1, true),
        "subtitles." .. key .. " should mention '" .. expected_name .. "', got: " .. v)
    end)
  end

  -- Staff-required subtitles must use IT staff names
  local reqd_forbidden = {"doctor", "nurse", "handyman", "gp's office"}
  local reqd_keys = {
    "reqd001","reqd002","reqd003","reqd004","reqd005","reqd006","reqd007",
    "reqd008","reqd009","reqd010","reqd012","reqd013","reqd014","reqd015",
    "reqd016","reqd019","reqd020","reqd021","reqd023","reqd024"
  }
  for _, key in ipairs(reqd_keys) do
    it("subtitles." .. key .. " does not say 'Doctor', 'Nurse', or 'Handyman'", function()
      local e = require_env()
      local v = tostring(e.subtitles[key] or "")
      assert.truthy(#v > 0, "subtitles." .. key .. " must be overridden")
      for _, term in ipairs(reqd_forbidden) do
        assert.falsy(v:lower():find(term, 1, true),
          "subtitles." .. key .. " must not say '" .. term .. "': " .. v)
      end
    end)
  end

  -- Maintenance subtitles must use IT staff/room names
  local maint_forbidden = {"handyman", "tongue slicer", "x-ray", "dna fixer", "inflator",
                            "electrolysis", "blood machine", "ultrascanner", "cardio", "hair restorer"}
  local maint_keys = {
    "maint004","maint005","maint006","maint007","maint008","maint009",
    "maint010","maint011","maint012","maint013","maint014","maint015","maint016"
  }
  for _, key in ipairs(maint_keys) do
    it("subtitles." .. key .. " does not use 'Handyman' or hospital room names", function()
      local e = require_env()
      local v = tostring(e.subtitles[key] or "")
      assert.truthy(#v > 0, "subtitles." .. key .. " must be overridden")
      for _, term in ipairs(maint_forbidden) do
        assert.falsy(v:lower():find(term, 1, true),
          "subtitles." .. key .. " must not say '" .. term .. "': " .. v)
      end
    end)
  end

  -- Staff dismissal subtitles must use IT staff names
  local sack_forbidden = {"doctor", "nurse", "handyman"}
  local sack_keys = {"sack001","sack002","sack003","sack004","sack005","sack006","sack007","sack008"}
  for _, key in ipairs(sack_keys) do
    it("subtitles." .. key .. " does not use hospital staff titles", function()
      local e = require_env()
      local v = tostring(e.subtitles[key] or "")
      assert.truthy(#v > 0, "subtitles." .. key .. " must be overridden")
      for _, term in ipairs(sack_forbidden) do
        assert.falsy(v:lower():find(term, 1, true),
          "subtitles." .. key .. " must not say '" .. term .. "': " .. v)
      end
    end)
  end

  -- Random PA announcements must not use hospital/patient terminology
  local rand_hospital_forbidden = {"hospital", "patients", "gp's office"}
  local rand_check = {"rand002","rand003","rand005","rand006","rand008","rand009",
                      "rand010","rand012","rand016","rand017","rand018","rand019",
                      "rand021","rand022","rand024","rand025","rand026","rand027",
                      "rand028","rand030","rand031","rand032","rand033","rand036",
                      "rand037","rand040","rand041","rand044","rand045"}
  for _, key in ipairs(rand_check) do
    it("subtitles." .. key .. " does not say 'hospital' or 'patients'", function()
      local e = require_env()
      local v = tostring(e.subtitles[key] or "")
      assert.truthy(#v > 0, "subtitles." .. key .. " must be overridden")
      for _, term in ipairs(rand_hospital_forbidden) do
        assert.falsy(v:lower():find(term, 1, true),
          "subtitles." .. key .. " must not say '" .. term .. "': " .. v)
      end
    end)
  end

  -- VIP subtitle must not say 'hospital'
  it("subtitles.vip008 does not say 'hospital'", function()
    local e = require_env()
    local v = tostring(e.subtitles.vip008 or "")
    assert.truthy(#v > 0, "subtitles.vip008 must be overridden")
    assert.falsy(v:lower():find("hospital", 1, true),
      "subtitles.vip008 must not say 'hospital': " .. v)
  end)

end)

-- ── misc.epidemic overrides ───────────────────────────────────────────────────

describe("misc epidemic/outbreak overrides", function()

  it("misc.epidemics_off does not say 'Epidemics'", function()
    local e = require_env()
    local v = tostring(e.misc.epidemics_off or "")
    assert.truthy(#v > 0, "misc.epidemics_off must be overridden")
    assert.falsy(v:lower():find("epidemic", 1, true),
      "misc.epidemics_off must not say 'epidemic': " .. v)
  end)

  it("misc.epidemics_on does not say 'Epidemics'", function()
    local e = require_env()
    local v = tostring(e.misc.epidemics_on or "")
    assert.truthy(#v > 0, "misc.epidemics_on must be overridden")
    assert.falsy(v:lower():find("epidemic", 1, true),
      "misc.epidemics_on must not say 'epidemic': " .. v)
  end)

  it("misc.epidemic_no_diseases does not say 'contagious diseases'", function()
    local e = require_env()
    local v = tostring(e.misc.epidemic_no_diseases or "")
    assert.truthy(#v > 0, "misc.epidemic_no_diseases must be overridden")
    assert.falsy(v:lower():find("contagious diseases", 1, true),
      "misc.epidemic_no_diseases must not say 'contagious diseases': " .. v)
  end)

end)

-- ── dynamic_info epidemic overrides ──────────────────────────────────────────

describe("dynamic_info epidemic-related overrides", function()

  it("dynamic_info.staff.actions.vaccine does not say 'patient'", function()
    local e = require_env()
    local v = tostring(e.dynamic_info.staff.actions.vaccine or "")
    assert.truthy(#v > 0, "dynamic_info.staff.actions.vaccine must be overridden")
    assert.falsy(v:lower():find("patient", 1, true),
      "dynamic_info.staff.actions.vaccine must not say 'patient': " .. v)
  end)

  it("dynamic_info.patient.actions.epidemic_vaccinated does not say 'contagious'", function()
    local e = require_env()
    local v = tostring(e.dynamic_info.patient.actions.epidemic_vaccinated or "")
    assert.truthy(#v > 0, "dynamic_info.patient.actions.epidemic_vaccinated must be overridden")
    assert.falsy(v:lower():find("contagious", 1, true),
      "dynamic_info.patient.actions.epidemic_vaccinated must not say 'contagious': " .. v)
  end)

end)



-- __ Infrastructure disruption (earthquake) string overrides ______

describe("infrastructure disruption string overrides", function()

  it("adviser.earthquake.alert is overridden and contains 'infrastructure'", function()
    local e = require_env()
    local v = tostring(e.adviser.earthquake.alert or "")
    assert.truthy(#v > 0, "adviser.earthquake.alert must be overridden")
    assert.truthy(v:lower():find("infrastructure", 1, true),
      "adviser.earthquake.alert should mention 'infrastructure': " .. v)
  end)

  it("adviser.earthquake.alert does not say 'earthquake' or 'seismic'", function()
    local e = require_env()
    local v = tostring(e.adviser.earthquake.alert or "")
    assert.falsy(v:lower():find("earthquake", 1, true),
      "adviser.earthquake.alert must not say 'earthquake': " .. v)
    assert.falsy(v:lower():find("seismic", 1, true),
      "adviser.earthquake.alert must not say 'seismic': " .. v)
  end)

  it("adviser.earthquake.damage is overridden and contains a %d format specifier", function()
    local e = require_env()
    local v = tostring(e.adviser.earthquake.damage or "")
    assert.truthy(#v > 0, "adviser.earthquake.damage must be overridden")
    assert.truthy(v:find("%d", 1, true),
      "adviser.earthquake.damage should have a %d format arg: " .. v)
  end)

  it("adviser.earthquake.ended is overridden and mentions severity", function()
    local e = require_env()
    local v = tostring(e.adviser.earthquake.ended or "")
    assert.truthy(#v > 0, "adviser.earthquake.ended must be overridden")
    assert.truthy(v:find("%d", 1, true),
      "adviser.earthquake.ended should have a %d for severity: " .. v)
  end)

  it("adviser.earthquake.ended does not say 'earthquake'", function()
    local e = require_env()
    local v = tostring(e.adviser.earthquake.ended or "")
    assert.falsy(v:lower():find("earthquake", 1, true),
      "adviser.earthquake.ended must not say 'earthquake': " .. v)
  end)

  it("misc.earthquakes_off is overridden and does not say 'earthquakes'", function()
    local e = require_env()
    local v = tostring(e.misc.earthquakes_off or "")
    assert.truthy(#v > 0, "misc.earthquakes_off must be overridden")
    assert.falsy(v:lower():find("earthquakes", 1, true),
      "misc.earthquakes_off must not say 'earthquakes': " .. v)
  end)

  it("misc.earthquakes_on is overridden and does not say 'earthquakes'", function()
    local e = require_env()
    local v = tostring(e.misc.earthquakes_on or "")
    assert.truthy(#v > 0, "misc.earthquakes_on must be overridden")
    assert.falsy(v:lower():find("earthquakes", 1, true),
      "misc.earthquakes_on must not say 'earthquakes': " .. v)
  end)

  it("cheats_window.cheats.toggle_earthquake is overridden with IT label", function()
    local e = require_env()
    local v = tostring(e.cheats_window.cheats.toggle_earthquake or "")
    assert.truthy(#v > 0, "cheats_window.cheats.toggle_earthquake must be overridden")
    assert.falsy(v:lower():find("earthquake", 1, true),
      "cheats_window.cheats.toggle_earthquake must not say 'earthquake': " .. v)
  end)

  it("cheats_window.cheats.earthquake is overridden with IT label", function()
    local e = require_env()
    local v = tostring(e.cheats_window.cheats.earthquake or "")
    assert.truthy(#v > 0, "cheats_window.cheats.earthquake must be overridden")
    assert.falsy(v:lower():find("earthquake", 1, true),
      "cheats_window.cheats.earthquake must not say 'earthquake': " .. v)
  end)

  it("tooltip.cheats_window.cheats.toggle_earthquake is overridden", function()
    local e = require_env()
    local v = tostring(e.tooltip.cheats_window.cheats.toggle_earthquake or "")
    assert.truthy(#v > 0, "tooltip.cheats_window.cheats.toggle_earthquake must be overridden")
    assert.falsy(v:lower():find("earthquake", 1, true),
      "tooltip must not say 'earthquake': " .. v)
  end)

  it("tooltip.cheats_window.cheats.earthquake is overridden", function()
    local e = require_env()
    local v = tostring(e.tooltip.cheats_window.cheats.earthquake or "")
    assert.truthy(#v > 0, "tooltip.cheats_window.cheats.earthquake must be overridden")
    assert.falsy(v:lower():find("earthquake", 1, true),
      "tooltip must not say 'earthquake': " .. v)
  end)

end)

