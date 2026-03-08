--[[ Terminal Triage — Lua root bootstrapper (app.lua)

  CorsixTH.lua loads this file as the "app" module when launched with
  --lua-dir pointing at TerminalTriage/Lua/. It performs three jobs:

  1. Resolves the sibling CorsixTH/Lua/ directory (relative to this file).
  2. Monkey-patches corsixth.require so that any module NOT found in this
     mod's Lua directory falls back transparently to the base installation.
  3. Executes the real app.lua from the base installation so the App class is
     defined in the global environment exactly as normal.

  ARCHITECTURE NOTE
  -----------------
  When --lua-dir is used, corsixth.require ONLY searches the specified
  directory — the base CorsixTH/Lua/ is completely removed from the path.
  Three early stubs (utility.lua, strict.lua, class.lua) are needed because
  they are loaded by CorsixTH.lua BEFORE this bootstrapper runs. After this
  file executes, everything else (api_version, config_finder, world, ui, …)
  is resolved by the patched corsixth.require below.

  MOD OVERRIDES
  -------------
  To override a base module, place a file with the same name in
  TerminalTriage/Lua/. It will be loaded instead of the base version.
  Examples:
    TerminalTriage/Lua/strings.lua       — override the string system
    TerminalTriage/Lua/rooms/gp.lua      — replace the GP room definition
--]]

local pathsep = package.config:sub(1, 1)

-- Resolve the mod's Lua directory from this file's absolute source path.
local mod_lua_dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])")

-- base_lua_dir: two levels up (Lua/ → TerminalTriage/ → repo root/) then
-- into CorsixTH/Lua/.  Assumes the mod lives in the same repository as the
-- base CorsixTH installation, which is the development layout for this repo.
local base_lua_dir = mod_lua_dir .. ".." .. pathsep .. ".." .. pathsep
                   .. "CorsixTH" .. pathsep .. "Lua" .. pathsep

-- Patch corsixth.require to add base CorsixTH/Lua/ as a fallback.
--
-- The original corsixth.require only searches in code_dir (which is now the
-- mod's Lua dir). We wrap it: try the mod first; on failure fall back to the
-- base installation and cache the result to avoid repeated file I/O.
local _orig_req = corsixth.require
local _fallback_cache = {}

corsixth.require = function(name)
  -- Honour our own fallback cache before anything else.
  if _fallback_cache[name] then
    local cached = _fallback_cache[name]
    return unpack(cached, 1, cached.n)
  end

  -- Try the mod directory first via the original (unpatched) require.
  -- pcall catches the error that persist.dofile raises when a file is absent.
  local ok, result = pcall(_orig_req, name)
  if ok then
    return result
  end

  -- Fall back to the base CorsixTH/Lua/ installation.
  local name_path = name:gsub("%.", pathsep)
  local base_file = base_lua_dir .. name_path .. ".lua"
  local chunk, err = loadfile(base_file)
  if not chunk then
    error(
      "Terminal Triage: module '" .. name .. "' not found in mod or base.\n" ..
      "  mod  error : " .. tostring(result) .. "\n" ..
      "  base error : " .. tostring(err),
      2
    )
  end

  -- Execute and cache the result so this fallback only happens once.
  local results
  if table.pack then
    results = table.pack(chunk())
  else
    results = {chunk()}
    results.n = select("#", unpack(results))
  end
  _fallback_cache[name] = results
  return unpack(results, 1, results.n)
end

-- Load the real app.lua from the base installation.
-- This defines the App class in the global environment, exactly as it would
-- be when running unmodded CorsixTH.  All corsixth.require calls that happen
-- later (inside App:init and beyond) will now go through our patched version.
dofile(base_lua_dir .. "app.lua")
