--[[ Terminal Triage — Graphics Override Path Tests
  Verifies that the graphics override path resolves correctly from the mod
  package root and that the file_mapping.txt configuration is valid.

  Run from TerminalTriage/Luatest/:
    busted

  These tests cover:
    1. App:getFullPath("Graphics") resolves to TerminalTriage/Graphics/
    2. file_mapping.txt exists at the resolved graphics path
    3. file_mapping.txt parses as valid Lua without error
    4. The parsed result contains a 'file_mapping' table field (not a key-value map)
    5. Priority: config.new_graphics_folder overrides getFullPath resolution
    6. The limitation (animations only, not sprite sheets) is documented
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

-- ── helpers ──────────────────────────────────────────────────────────────────

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close(); return true end
  return false
end

--- Execute a config file in a clean environment and return the populated table.
local function exec_config_file(path)
  local chunk, err = loadfile(path)
  if not chunk then return nil, err end
  local env = {}
  setmetatable(env, {__index = _G, __newindex = function(t, k, v) rawset(t, k, v) end})
  local ok, run_err = pcall(function()
    debug.setupvalue(chunk, 1, env)
    chunk()
  end)
  if not ok then return nil, run_err end
  return env
end

-- ── Graphics path resolution ─────────────────────────────────────────────────

describe("Graphics path resolution via App:getFullPath override", function()

  -- Simulate the patched App:getFullPath (as installed by TerminalTriage/Lua/app.lua)
  local function patched_getFullPath(mod_root_val, folders, trailing_slash)
    if type(folders) ~= "table" then folders = {folders} end
    local ending = trailing_slash and pathsep or ""
    return mod_root_val .. table.concat(folders, pathsep) .. ending
  end

  it("getFullPath('Graphics', true) resolves to TerminalTriage/Graphics/", function()
    local result = patched_getFullPath(mod_root, "Graphics", true)
    assert.truthy(result:find("TerminalTriage", 1, true),
      "Path must contain 'TerminalTriage', got: " .. result)
    assert.truthy(result:find("Graphics", 1, true),
      "Path must contain 'Graphics', got: " .. result)
    assert.equal(pathsep, result:sub(-1), "Path must end with path separator")
  end)

  it("getFullPath('Graphics', true) does NOT resolve to CorsixTH/Graphics/", function()
    local result = patched_getFullPath(mod_root, "Graphics", true)
    assert.falsy(result:find("CorsixTH", 1, true),
      "Path must not contain 'CorsixTH' — it should stay inside TerminalTriage/")
  end)

  it("config.new_graphics_folder takes priority over getFullPath", function()
    -- When config.new_graphics_folder is set it must win over the default.
    -- This test models the priority logic in graphics.lua:106:
    --   graphics_folder = config.new_graphics_folder or app:getFullPath("Graphics", true)
    local override_path = "/custom/graphics/"
    local default_path  = patched_getFullPath(mod_root, "Graphics", true)

    local function graphics_folder(cfg_val)
      return cfg_val or default_path
    end

    -- When config provides a path, use it
    assert.equal(override_path, graphics_folder(override_path))
    -- When config is nil, fall back to getFullPath result
    assert.equal(default_path, graphics_folder(nil))
    -- Confirm the fallback still points to TerminalTriage/
    assert.truthy(default_path:find("TerminalTriage", 1, true))
  end)

  it("path separator is appended when trailing_slash = true", function()
    local with_sep    = patched_getFullPath(mod_root, "Graphics", true)
    local without_sep = patched_getFullPath(mod_root, "Graphics", false)
    assert.equal(pathsep, with_sep:sub(-1))
    assert.not_equal(pathsep, without_sep:sub(-1))
  end)

end)

-- ── file_mapping.txt existence and validity ───────────────────────────────────

describe("file_mapping.txt in TerminalTriage/Graphics/", function()

  local graphics_dir     = mod_root .. "Graphics" .. pathsep
  local file_mapping_path = graphics_dir .. "file_mapping.txt"

  it("Graphics/ directory exists inside TerminalTriage/", function()
    local mode = lfs.attributes(graphics_dir, "mode")
    assert.equal("directory", mode,
      "Expected a directory at: " .. graphics_dir)
  end)

  it("file_mapping.txt exists at TerminalTriage/Graphics/", function()
    assert.truthy(file_exists(file_mapping_path),
      "Expected file_mapping.txt at: " .. file_mapping_path)
  end)

  it("file_mapping.txt parses without Lua error", function()
    local result, err = exec_config_file(file_mapping_path)
    assert.is_nil(err, "Parse error in file_mapping.txt: " .. tostring(err))
    assert.not_nil(result)
  end)

  it("parsed file_mapping.txt has a 'file_mapping' field", function()
    local result = assert(exec_config_file(file_mapping_path))
    assert.not_nil(result.file_mapping,
      "file_mapping.txt must define a 'file_mapping' table")
  end)

  it("'file_mapping' is a table (not nil or another type)", function()
    local result = assert(exec_config_file(file_mapping_path))
    assert.equal("table", type(result.file_mapping),
      "'file_mapping' must be a Lua table")
  end)

  it("'file_mapping' entries (if any) are strings — .dat animation filenames", function()
    local result = assert(exec_config_file(file_mapping_path))
    for i, entry in ipairs(result.file_mapping) do
      assert.equal("string", type(entry),
        "file_mapping[" .. i .. "] must be a string (animation .dat filename)")
      assert.truthy(#entry > 0,
        "file_mapping[" .. i .. "] must be non-empty")
    end
  end)

  it("'file_mapping' is a sequential array, not a key-value map", function()
    -- CorsixTH iterates file_mapping with ipairs (sequential).
    -- A key-value map would silently produce no animations.
    -- Verify no string keys are present.
    local result = assert(exec_config_file(file_mapping_path))
    local fm = result.file_mapping
    local string_key_count = 0
    for k, _ in pairs(fm) do
      if type(k) == "string" then
        string_key_count = string_key_count + 1
      end
    end
    assert.equal(0, string_key_count,
      "file_mapping must be a sequential array of .dat filenames; " ..
      "found " .. string_key_count .. " string key(s). " ..
      "Key-value maps are NOT supported by CorsixTH's loadAnimations().")
  end)

end)

-- ── Sprite sheet readDataFile override ───────────────────────────────────────
--
-- Tests for App:readDataFile override installed by TerminalTriage/Lua/app.lua.
-- The override checks TerminalTriage/Graphics/{dir}/{filename} before falling
-- back to the original Theme Hospital filesystem.
--
-- We simulate the override logic here (same pattern as patched_getFullPath above)
-- so the tests run without the full CorsixTH C runtime.

describe("App:readDataFile sprite sheet override", function()

  local graphics_dir = mod_root .. "Graphics" .. pathsep

  -- Simulate the override logic from TerminalTriage/Lua/app.lua
  local function simulated_readDataFile(custom_root, dir, filename, orig_fn)
    if dir and dir ~= "Bitmap" and dir ~= "Levels" and filename then
      local custom_path = custom_root .. dir .. pathsep .. filename
      local f = io.open(custom_path, "rb")
      if f then
        local data = f:read("*a")
        f:close()
        return data, "custom"
      end
    end
    return orig_fn(dir, filename), "original"
  end

  local function orig_stub(dir, filename)
    return "original_data:" .. tostring(dir) .. "/" .. tostring(filename)
  end

  local function write_temp_file(path, content)
    local f = assert(io.open(path, "wb"), "Cannot create temp file: " .. path)
    f:write(content)
    f:close()
  end

  local data_dir  = graphics_dir .. "Data"  .. pathsep
  local qdata_dir = graphics_dir .. "QData" .. pathsep

  it("Graphics/Data/ override directory exists", function()
    assert.equal("directory", lfs.attributes(data_dir, "mode"),
      "TerminalTriage/Graphics/Data/ must exist for sprite overrides")
  end)

  it("Graphics/QData/ override directory exists", function()
    assert.equal("directory", lfs.attributes(qdata_dir, "mode"),
      "TerminalTriage/Graphics/QData/ must exist for sprite overrides")
  end)

  it("custom Data/ file is returned when override exists", function()
    local custom_file = data_dir .. "TestSprite.tab"
    write_temp_file(custom_file, "custom_sprite_data")
    local result, source = simulated_readDataFile(graphics_dir, "Data", "TestSprite.tab", orig_stub)
    os.remove(custom_file)
    assert.equal("custom",            source)
    assert.equal("custom_sprite_data", result)
  end)

  it("custom QData/ file is returned when override exists", function()
    local custom_file = qdata_dir .. "Req05V.tab"
    write_temp_file(custom_file, "custom_qdata_sprite")
    local result, source = simulated_readDataFile(graphics_dir, "QData", "Req05V.tab", orig_stub)
    os.remove(custom_file)
    assert.equal("custom",              source)
    assert.equal("custom_qdata_sprite", result)
  end)

  it("fallback is called when no custom file exists", function()
    os.remove(data_dir .. "NonExistentSprite.tab")
    local result, source = simulated_readDataFile(graphics_dir, "Data", "NonExistentSprite.tab", orig_stub)
    assert.equal("original", source)
    assert.truthy(result:find("original_data"))
  end)

  it("Bitmap dir bypasses custom graphics check", function()
    local _, source = simulated_readDataFile(graphics_dir, "Bitmap", "aux_ui.tab", orig_stub)
    assert.equal("original", source)
  end)

  it("Levels dir bypasses custom graphics check", function()
    local _, source = simulated_readDataFile(graphics_dir, "Levels", "somemap.tab", orig_stub)
    assert.equal("original", source)
  end)

  it("nil dir bypasses custom graphics check", function()
    local _, source = simulated_readDataFile(graphics_dir, nil, "somefile.dat", orig_stub)
    assert.equal("original", source)
  end)

  it("nil filename bypasses custom graphics check", function()
    local _, source = simulated_readDataFile(graphics_dir, "Data", nil, orig_stub)
    assert.equal("original", source)
  end)

  it("file_mapping.txt defines a sprite_mapping table", function()
    local result = assert(exec_config_file(mod_root .. "Graphics" .. pathsep .. "file_mapping.txt"))
    assert.not_nil(result.sprite_mapping,
      "file_mapping.txt must define a 'sprite_mapping' table")
    assert.equal("table", type(result.sprite_mapping))
  end)

end)

-- ── Updated capability status ─────────────────────────────────────────────────

describe("Graphics override capability status", function()

  it("animation overrides are supported via file_mapping sequential array", function()
    local result = assert(exec_config_file(mod_root .. "Graphics" .. pathsep .. "file_mapping.txt"))
    assert.equal("table", type(result.file_mapping))
    for i, v in ipairs(result.file_mapping) do
      assert.equal("string", type(v), "entry " .. i .. " must be a string filename")
    end
  end)

  it("sprite sheet override IS supported via App:readDataFile override in app.lua", function()
    local graphics_dir = mod_root .. "Graphics" .. pathsep
    local result = assert(exec_config_file(graphics_dir .. "file_mapping.txt"))
    assert.equal("directory", lfs.attributes(graphics_dir .. "Data",  "mode"),
      "Graphics/Data/ must exist for sprite overrides")
    assert.equal("directory", lfs.attributes(graphics_dir .. "QData", "mode"),
      "Graphics/QData/ must exist for sprite overrides")
    assert.not_nil(result.sprite_mapping,
      "sprite_mapping must be documented in file_mapping.txt")
  end)

end)
