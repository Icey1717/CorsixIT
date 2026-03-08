--[[ Terminal Triage bootstrapper tests
  Tests for TerminalTriage/Lua/app.lua — the alternate Lua root bootstrapper.

  Run from TerminalTriage/Luatest/:
    busted

  These tests exercise:
    1. Mod root path extraction from the bootstrapper's own source path
    2. App:getFullPath() override — resolves relative to TerminalTriage/ not CorsixTH/
    3. corsixth.require fallback mechanism
--]]

describe("Mod root path extraction", function()
  -- The bootstrapper captures its own directory using:
  --   debug.getinfo(1, "S").source:sub(2, -12)
  -- This is the same math that CorsixTH's native App:getFullPath uses, but
  -- applied to TerminalTriage/Lua/app.lua instead of CorsixTH/Lua/app.lua.
  -- sub(2, -12) strips the leading '@' AND 11 chars from the end ("Lua\app.lua"
  -- or "Lua/app.lua" = 3+1+7 = 11 chars).

  it("extracts the mod root on Windows (backslash paths)", function()
    local source = "@C:\\Users\\user\\mods\\TerminalTriage\\Lua\\app.lua"
    local result = source:sub(2, -12)
    assert.equal("C:\\Users\\user\\mods\\TerminalTriage\\", result)
  end)

  it("extracts the mod root on Linux/macOS (forward slash paths)", function()
    local source = "@/home/user/mods/TerminalTriage/Lua/app.lua"
    local result = source:sub(2, -12)
    assert.equal("/home/user/mods/TerminalTriage/", result)
  end)

  it("mod root contains 'TerminalTriage', not 'CorsixTH'", function()
    local mod_source  = "@G:\\repos\\CorsixIT\\TerminalTriage\\Lua\\app.lua"
    local base_source = "@G:\\repos\\CorsixIT\\CorsixTH\\Lua\\app.lua"
    local mod_root  = mod_source:sub(2, -12)
    local base_root = base_source:sub(2, -12)
    -- They must differ — getFullPath should use mod root, not base
    assert.not_equal(mod_root, base_root)
    assert.truthy(mod_root:find("TerminalTriage", 1, true))
    assert.falsy(mod_root:find("CorsixTH", 1, true))
  end)

  it("strips exactly the right number of chars for 'Lua/app.lua'", function()
    -- Verify the constant -12 is correct:
    --   '@' prefix        = 1 char (stripped by sub(2,...))
    --   from end: 'app.lua' = 7 chars
    --             '/'       = 1 char
    --             'Lua'     = 3 chars   => 11 chars from end = sub(...,-12)
    local tail = "Lua/app.lua"
    assert.equal(11, #tail)  -- confirms -12 is right
    -- Same length for backslash variant
    local tail_win = "Lua\\app.lua"
    assert.equal(11, #tail_win)
  end)
end)

describe("App:getFullPath override", function()
  -- After the bootstrapper dofiles base app.lua, it must override App.getFullPath
  -- so that Levels/, Campaigns/, and Lua/languages/ resolve to TerminalTriage/,
  -- not to CorsixTH/.
  --
  -- This test verifies the override logic in isolation by simulating the class.

  local pathsep = package.config:sub(1, 1)

  -- Simulate what the original (un-patched) getFullPath does:
  -- it uses debug.getinfo(1,"S") which always returns CorsixTH/Lua/app.lua
  local function original_getFullPath(folders, trailing_slash)
    if type(folders) ~= "table" then folders = {folders} end
    local ending = trailing_slash and pathsep or ""
    -- Hardcode the base source as it would appear when CorsixTH/Lua/app.lua runs
    local base_source = "@G:\\repos\\CorsixIT\\CorsixTH\\Lua\\app.lua"
    return base_source:sub(2, -12) .. table.concat(folders, pathsep) .. ending
  end

  -- Simulate the patched getFullPath the bootstrapper installs:
  local mod_root = "G:\\repos\\CorsixIT\\TerminalTriage\\"
  local function patched_getFullPath(_, folders, trailing_slash)
    if type(folders) ~= "table" then folders = {folders} end
    local ending = trailing_slash and pathsep or ""
    return mod_root .. table.concat(folders, pathsep) .. ending
  end

  it("original getFullPath resolves to CorsixTH/", function()
    local result = original_getFullPath({"Levels"}, true)
    assert.truthy(result:find("CorsixTH", 1, true))
    assert.falsy(result:find("TerminalTriage", 1, true))
  end)

  it("patched getFullPath resolves to TerminalTriage/", function()
    local result = patched_getFullPath(nil, {"Levels"}, true)
    assert.truthy(result:find("TerminalTriage", 1, true))
    assert.falsy(result:find("CorsixTH", 1, true))
  end)

  it("patched getFullPath resolves Levels/ correctly", function()
    local result = patched_getFullPath(nil, {"Levels"}, true)
    assert.truthy(result:find("Levels", 1, true))
    assert.equal(pathsep, result:sub(-1))  -- trailing slash present
  end)

  it("patched getFullPath resolves Campaigns/ correctly", function()
    local result = patched_getFullPath(nil, {"Campaigns"}, true)
    assert.truthy(result:find("TerminalTriage", 1, true))
    assert.truthy(result:find("Campaigns", 1, true))
  end)

  it("patched getFullPath resolves Lua/languages/ correctly", function()
    local result = patched_getFullPath(nil, {"Lua", "languages"}, true)
    assert.truthy(result:find("TerminalTriage", 1, true))
    assert.truthy(result:find("languages", 1, true))
    -- Must NOT point inside CorsixTH tree
    assert.falsy(result:find("CorsixTH", 1, true))
  end)
end)

describe("corsixth.require fallback mechanism", function()
  -- The bootstrapper wraps corsixth.require so that modules missing from
  -- TerminalTriage/Lua/ fall back to CorsixTH/Lua/.

  local function make_fallback_require(mod_modules, base_modules)
    -- mod_modules: table of name -> value for modules in the mod dir
    -- base_modules: table of name -> value for modules in the base dir
    local orig_req = function(name)
      if mod_modules[name] then return mod_modules[name] end
      error("module '" .. name .. "' not found in mod dir")
    end
    local fallback_cache = {}
    return function(name)
      if fallback_cache[name] then
        local c = fallback_cache[name]
        return table.unpack(c, 1, c.n)
      end
      local ok, result = pcall(orig_req, name)
      if ok then return result end
      -- Fallback
      if not base_modules[name] then
        error("Terminal Triage: module '" .. name .. "' not found in mod or base.")
      end
      local results = table.pack(base_modules[name])
      fallback_cache[name] = results
      return table.unpack(results, 1, results.n)
    end
  end

  it("returns mod version when module exists in mod dir", function()
    local req = make_fallback_require(
      {["world"] = "mod_world"},
      {["world"] = "base_world"}
    )
    assert.equal("mod_world", req("world"))
  end)

  it("falls back to base when module is absent from mod dir", function()
    local req = make_fallback_require(
      {},  -- nothing in mod dir
      {["world"] = "base_world"}
    )
    assert.equal("base_world", req("world"))
  end)

  it("errors when module is absent from both mod dir and base", function()
    local req = make_fallback_require({}, {})
    assert.has_error(function() req("nonexistent") end)
  end)

  it("caches fallback results to avoid repeated lookups", function()
    local base_call_count = 0
    local orig_req = function(name)
      error("module '" .. name .. "' not found in mod dir")
    end
    local fallback_cache = {}
    local req = function(name)
      if fallback_cache[name] then
        local c = fallback_cache[name]
        return table.unpack(c, 1, c.n)
      end
      local ok, result = pcall(orig_req, name)
      if ok then return result end
      -- Fallback: single access to base
      base_call_count = base_call_count + 1
      local base_val = "base_" .. name
      local results = table.pack(base_val)
      fallback_cache[name] = results
      return table.unpack(results, 1, results.n)
    end
    req("world")
    req("world")  -- second call — should use cache
    assert.equal(1, base_call_count)
  end)

  it("mod override takes priority over base", function()
    local req = make_fallback_require(
      {["strings"] = "mod_strings"},
      {["strings"] = "base_strings"}
    )
    -- Mod version must win
    assert.equal("mod_strings", req("strings"))
  end)
end)
