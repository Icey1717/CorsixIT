--[[ Terminal Triage: strings.lua override

The base Strings:init() scans only self.app:getFullPath({"Lua","languages"})
which resolves to TerminalTriage/Lua/languages/ — so English and other base
language files are never loaded, and Inherit("English") in the mod language
file fails to resolve.

Fix: extend Strings:init to also scan the base game's languages directory.
The second scan uses the same loadfile_envcall path but skips files already
loaded from the mod directory (mod language files take priority).
--]]

local pathsep = package.config:sub(1, 1)
local this_dir = debug.getinfo(1, "S").source:sub(2):match("^(.*[/\\])")
local base_lua_dir = this_dir .. ".." .. pathsep .. ".." .. pathsep
                   .. "CorsixTH" .. pathsep .. "Lua" .. pathsep
local base_lang_dir = base_lua_dir .. "languages" .. pathsep

-- Load the base strings.lua so the Strings class is fully defined.
dofile(base_lua_dir .. "strings.lua")

local _base_init = Strings.init

function Strings:init()
  _base_init(self)

  -- Record which filenames are already loaded from the mod languages directory.
  local loaded_files = {}
  for _, filename in pairs(self.language_chunks) do
    loaded_files[filename:match("[^/\\]+$")] = true
  end

  -- Load base game language files not already present.
  local ok, iter, state = pcall(lfs.dir, base_lang_dir)
  if not ok then return end
  for file in iter, state do
    if file:match("%.lua$") and not loaded_files[file] then
      local result, err = loadfile_envcall(base_lang_dir .. file)
      if not result then
        print("Error loading base language " .. file .. ":\n" .. tostring(err))
      else
        self.language_chunks[result] = "languages" .. pathsep .. file
      end
    end
  end

  -- Re-register Language() names for the newly added chunks.
  local good_error_marker = {}
  local infinite_table_mt
  infinite_table_mt = { __index = function() return setmetatable({}, infinite_table_mt) end }

  for chunk in pairs(self.language_chunks) do
    local already = false
    for _, v in pairs(self.language_to_chunk) do
      if v == chunk then already = true; break end
    end
    if not already then
      local env = setmetatable({
        utf8 = function(...) return ... end,
        cp437 = function(...) return ... end,
        pairs = pairs,
        Language = function(...)
          local names = {...}
          if names[1] ~= "original_strings" then
            self.languages[#self.languages + 1] = names[1]
            self.languages_english[names[1]] = names[2] or names[1]
          end
          for _, name in ipairs(names) do
            self.language_to_chunk[name:lower()] = chunk
            self.language_to_lang_code[name:lower()] = names[3]
          end
          self.chunk_to_names[chunk] = names
          error(good_error_marker)
        end,
        Font             = function(...) self.chunk_to_font[chunk] = ... end,
        Inherit          = function() end,
        SetSpeechFile    = function() end,
        Encoding         = function() end,
        IsArabicNumerals = function() end,
        LoadStrings      = infinite_table_mt.__index,
      }, infinite_table_mt)
      local ok2, err = pcall(chunk, env)
      if not ok2 and err ~= good_error_marker and TheApp.good_install_folder then
        print("Error registering language: " .. tostring(err))
      end
    end
  end

  table.sort(self.languages)
end
