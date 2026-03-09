-- Terminal Triage stub: forward to base CorsixTH base_config.lua
--
-- map.lua loads this file via loadfile(app:getFullPath({"Lua","base_config.lua"}))
-- which resolves to TerminalTriage/Lua/base_config.lua when the mod is active.
-- This stub dofiles the real base_config.lua so map loading works correctly.
local pathsep = package.config:sub(1, 1)
local this_dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])")
local base_file = this_dir .. ".." .. pathsep .. ".." .. pathsep
                .. "CorsixTH" .. pathsep .. "Lua" .. pathsep .. "base_config.lua"
return dofile(base_file)
