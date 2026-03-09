## Issue Tracking

This project uses **bd (beads)** for issue tracking.
Run `bd prime` for workflow context.

**Quick reference:**
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2` - Create issue
- `bd close <id>` - Complete work
- `bd dolt push` - Push changes to remote (run at session end)

## Testing

After making code changes, run both of the following:

### 1. Lua unit tests

Run from `TerminalTriage/Luatest/`:
```
lua %APPDATA%\luarocks\bin\busted
```

Run from `CorsixTH/Luatest/` (with the base game Lua on the path):
```
lua %APPDATA%\luarocks\bin\busted --lpath="../Lua/?.lua"
```

All tests must pass before the task is considered done.

### 2. Launch the game and check stdio

Launch the mod and monitor stdout/stderr for errors and warnings:
```
cd TerminalTriage && launch.bat
```

Capture stdio output and inspect it. The game must start with:
- **No `Error` lines** (a hard error will crash or prevent the campaign from loading)
- **No `Warning: This level does not contain any diseases`** (means `#visuals`/`#non_visuals` entries are missing or have wrong indices in the level file)
- **No `Warning: Removing disease … due to missing treatment room`** (means a required room's object has `AvailableForLevel = 0` in `base_config.lua` and the level file doesn't override it)

Soundfont warnings (`Required soundfont is not found`) are a local config issue and can be ignored.

## Searching Code

This project support code munch (jcodemunch) via mcp.
The following tools are available:

index_repo 	Index a GitHub repository
index_folder 	Index a local folder
list_repos 	List indexed repositories
get_file_tree 	Repository file structure
get_file_outline 	Symbol hierarchy for a file
get_symbol 	Retrieve full symbol source
get_symbols 	Batch retrieve symbols
search_symbols 	Search symbols with filters
search_text 	Full-text search
get_repo_outline 	High-level repo overview
invalidate_cache 	Remove cached index