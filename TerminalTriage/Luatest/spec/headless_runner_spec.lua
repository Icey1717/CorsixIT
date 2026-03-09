--[[ Terminal Triage headless runner tests
  Tests for the --headless-test flag infrastructure in app.lua.

  Run from TerminalTriage/Luatest/:
    lua %APPDATA%\luarocks\bin\busted

  These tests exercise in pure Lua (no SDL/TH required):
    1. --headless-test=<path> command-line flag parsing
    2. Test-script loading, success, and error paths
    3. Headless-mode config overrides (audio, play_intro, fullscreen)
--]]

-- ---------------------------------------------------------------------------
-- 1. Command-line flag parsing
-- ---------------------------------------------------------------------------
describe("Headless runner: --headless-test flag parsing", function()
  -- Extracted from App:setCommandLine — pure Lua, no game state needed.
  local function parse_cmdline(...)
    local result = {}
    for _, arg in ipairs({...}) do
      local setting, value = arg:match("^%-%-([^=]*)=(.*)$")
      if value then result[setting] = value end
    end
    return result
  end

  it("parses --headless-test=<path> into command_line table", function()
    local cmd = parse_cmdline("--headless-test=/path/to/test.lua")
    assert.equal("/path/to/test.lua", cmd["headless-test"])
  end)

  it("headless-test key is nil when flag is absent", function()
    local cmd = parse_cmdline("--campaign=terminal_triage", "--config-file=config.txt")
    assert.is_nil(cmd["headless-test"])
  end)

  it("is_headless is true when flag is present", function()
    local cmd = parse_cmdline("--headless-test=/smoke.lua", "--campaign=terminal_triage")
    local is_headless = cmd["headless-test"] ~= nil
    assert.is_true(is_headless)
  end)

  it("is_headless is false when flag is absent", function()
    local cmd = parse_cmdline("--campaign=terminal_triage")
    local is_headless = cmd["headless-test"] ~= nil
    assert.is_false(is_headless)
  end)

  it("flag value survives alongside other flags", function()
    local cmd = parse_cmdline(
      "--config-file=config.txt",
      "--headless-test=/tests/smoke.lua",
      "--campaign=terminal_triage"
    )
    assert.equal("/tests/smoke.lua",   cmd["headless-test"])
    assert.equal("terminal_triage",    cmd["campaign"])
    assert.equal("config.txt",         cmd["config-file"])
  end)

  it("flag with a Windows path (backslashes) is preserved verbatim", function()
    local cmd = parse_cmdline([[--headless-test=C:\repos\TerminalTriage\headless_tests\smoke.lua]])
    assert.equal([[C:\repos\TerminalTriage\headless_tests\smoke.lua]], cmd["headless-test"])
  end)
end)

-- ---------------------------------------------------------------------------
-- 2. Test-script execution logic (isolated, no SDL)
-- ---------------------------------------------------------------------------
describe("Headless runner: test-script execution", function()
  -- Replicates the core logic of App:runHeadlessTest without calling os.exit.
  -- Returns { code=0|1, reason="success"|"load_error"|"run_error", msg=... }
  local function run_headless_script(script_path, mock_app)
    mock_app = mock_app or {}
    local fn, load_err = loadfile(script_path)
    if not fn then
      return { code = 1, reason = "load_error", msg = tostring(load_err) }
    end
    local ok, run_err = pcall(fn, mock_app)
    if not ok then
      return { code = 1, reason = "run_error", msg = tostring(run_err) }
    end
    return { code = 0, reason = "success" }
  end

  it("exits 1 with load_error when script file does not exist", function()
    local result = run_headless_script("/nonexistent/path/does_not_exist_12345.lua")
    assert.equal(1, result.code)
    assert.equal("load_error", result.reason)
    assert.truthy(result.msg and #result.msg > 0)
  end)

  it("exits 0 when script runs without error", function()
    local tmp = os.tmpname() .. ".lua"
    local f = assert(io.open(tmp, "w"))
    f:write("-- minimal passing test\n")
    f:close()
    local result = run_headless_script(tmp)
    os.remove(tmp)
    assert.equal(0, result.code)
    assert.equal("success", result.reason)
  end)

  it("exits 1 with run_error when script calls error()", function()
    local tmp = os.tmpname() .. ".lua"
    local f = assert(io.open(tmp, "w"))
    f:write("error('intentional test failure')\n")
    f:close()
    local result = run_headless_script(tmp)
    os.remove(tmp)
    assert.equal(1, result.code)
    assert.equal("run_error", result.reason)
    assert.truthy(result.msg:find("intentional test failure", 1, true))
  end)

  it("exits 1 with run_error when script calls assert(false)", function()
    local tmp = os.tmpname() .. ".lua"
    local f = assert(io.open(tmp, "w"))
    f:write("assert(false, 'assertion failed in test')\n")
    f:close()
    local result = run_headless_script(tmp)
    os.remove(tmp)
    assert.equal(1, result.code)
    assert.equal("run_error", result.reason)
  end)

  it("script receives the mock app as its first argument", function()
    local tmp = os.tmpname() .. ".lua"
    local f = assert(io.open(tmp, "w"))
    -- The script asserts it received a non-nil table as first arg
    f:write("local app = ...\n")
    f:write("assert(type(app) == 'table', 'expected table, got ' .. type(app))\n")
    f:write("assert(app.sentinel == 42, 'sentinel mismatch')\n")
    f:close()
    local result = run_headless_script(tmp, { sentinel = 42 })
    os.remove(tmp)
    assert.equal(0, result.code)
  end)

  it("exits 0 for a script that only prints without erroring", function()
    local tmp = os.tmpname() .. ".lua"
    local f = assert(io.open(tmp, "w"))
    f:write("print('[headless test] hello from script')\n")
    f:close()
    local result = run_headless_script(tmp)
    os.remove(tmp)
    assert.equal(0, result.code)
  end)
end)

-- ---------------------------------------------------------------------------
-- 3. Headless-mode config overrides
-- ---------------------------------------------------------------------------
describe("Headless runner: config overrides applied at init", function()
  -- Simulates the block inside App:init() that mutates config when headless.
  local function apply_headless_config(config, is_headless)
    if is_headless then
      config.play_intro  = false
      config.fullscreen  = false
      config.audio       = false
    end
    return config
  end

  it("play_intro is forced false in headless mode", function()
    local cfg = apply_headless_config({ play_intro = true }, true)
    assert.is_false(cfg.play_intro)
  end)

  it("fullscreen is forced false in headless mode", function()
    local cfg = apply_headless_config({ fullscreen = true }, true)
    assert.is_false(cfg.fullscreen)
  end)

  it("audio is forced false in headless mode", function()
    local cfg = apply_headless_config({ audio = true }, true)
    assert.is_false(cfg.audio)
  end)

  it("normal mode leaves config untouched", function()
    local cfg = apply_headless_config({ play_intro = true, fullscreen = true, audio = true }, false)
    assert.is_true(cfg.play_intro)
    assert.is_true(cfg.fullscreen)
    assert.is_true(cfg.audio)
  end)

  it("headless mode does not affect unrelated config keys", function()
    local cfg = apply_headless_config({ width = 1024, height = 768, audio = true }, true)
    assert.equal(1024, cfg.width)
    assert.equal(768, cfg.height)
  end)
end)
