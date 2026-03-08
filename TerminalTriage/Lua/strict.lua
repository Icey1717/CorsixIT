--[[ Terminal Triage — forward stub: strict
  Loaded by corsixth.require("strict") in CorsixTH.lua before app.lua can
  patch the require function. Delegates directly to the base CorsixTH
  installation so strict mode and destrict() are available exactly as normal.
--]]
local pathsep = package.config:sub(1, 1)
local mod_lua_dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])")
local base_lua_dir = mod_lua_dir .. ".." .. pathsep .. ".." .. pathsep
                   .. "CorsixTH" .. pathsep .. "Lua" .. pathsep
return dofile(base_lua_dir .. "strict.lua")
