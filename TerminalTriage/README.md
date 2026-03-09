# Terminal Triage

**Terminal Triage** is a total-conversion mod for [CorsixTH](https://github.com/CorsixTH/CorsixTH) that re-themes the classic hospital management gameplay as an IT repair and support shop. Instead of treating patients with bizarre ailments, you run a tech-repair business: diagnosing broken devices, fixing software issues, managing engineers and technicians, and handling malware outbreaks.

## Package Layout

```
TerminalTriage/
  Lua/                      <- Alternate Lua root (passed via --lua-dir)
    app.lua                 <- Bootstrapper: patches require, loads base app.lua
    class.lua               <- Forward stub -> CorsixTH/Lua/class.lua
    strict.lua              <- Forward stub -> CorsixTH/Lua/strict.lua
    utility.lua             <- Forward stub -> CorsixTH/Lua/utility.lua
    languages/
      english_terminal_triage.lua   <- IT re-theme string overrides (Phase 1)
    ...                     <- Future: mod override files (rooms, diseases, etc.)
  Levels/                   <- Custom .level files for Terminal Triage scenarios
  Campaigns/                <- Custom .campaign files
    terminal_triage.campaign
  Graphics/                 <- Custom graphics overrides
    file_mapping.txt        <- Sprite override mapping (use_new_graphics=true)
  config.txt.template       <- Config template (copy to config.txt and personalise)
  config.txt                <- Your personal config (gitignored - created from template)
  hotkeys.txt               <- Your personal hotkeys (gitignored)
  launch.bat                <- Windows launcher
  launch.sh                 <- Linux/macOS launcher
  README.md                 <- This file
```

## Prerequisites

- A valid [CorsixTH](https://github.com/CorsixTH/CorsixTH) installation (v0.67+)
- A valid [Theme Hospital](https://en.wikipedia.org/wiki/Theme_Hospital) data directory (original game files)
- CorsixTH executable accessible on your PATH or configured in the launcher scripts

## Quick Start

### 1. Create your config

Copy `config.txt.template` to `config.txt` and set `theme_hospital_install` to point to your Theme Hospital data directory.

```
copy config.txt.template config.txt
```

Then open `config.txt` and set:

```
theme_hospital_install = [[C:\Path\To\ThemeHospital]]
```

### 2. Launch

#### Windows

Edit `launch.bat` to set `CORSIXTH_EXE` to your CorsixTH executable path, then double-click it.

#### Linux / macOS

Edit `launch.sh` to set `CORSIXTH_EXE`, then run:

```bash
chmod +x launch.sh
./launch.sh
```

#### Manual Launch

```
CorsixTH.exe --lua-dir="<path-to-TerminalTriage>\Lua" --config-file="<path-to-TerminalTriage>\config.txt"
```

The `--lua-dir` flag redirects CorsixTH to load all Lua content from the mod's own `Lua\` tree, keeping the mod isolated from a user's base CorsixTH installation.

## Development Workflow

### In-Repo Iteration (primary workflow)

Terminal Triage is developed inside the CorsixTH source repository so that the
mod Lua can be rapidly iterated against the live engine without a separate
installation step.

**First-time setup**

1. Clone (or pull) the CorsixIT repository — `TerminalTriage\` and `CorsixTH\`
   must sit side-by-side in the same directory.
2. Copy `config.txt.template` → `config.txt` and set `theme_hospital_install`.
3. Edit the launcher (`launch.bat` / `launch.sh`) to set `CORSIXTH_EXE` if
   CorsixTH is not on your PATH.

**Daily iteration loop**

1. Edit Lua files in `TerminalTriage\Lua\` (or add new override files).
2. Launch via `launch.bat` / `launch.sh` (or the manual command above).
3. Test changes in-game; the `--lua-dir` flag means no installation step is needed.
4. Run the unit tests (see **Running Tests** below) before committing.
5. Commit to the repository — `TerminalTriage\` is version-controlled alongside
   the engine source, which makes it easy to keep in sync with engine changes.

> **Rule**: never edit files under `CorsixTH\` to make Terminal Triage work.
> All mod logic lives exclusively in `TerminalTriage\`.  If a base-engine
> limitation is discovered, document it as a new bead rather than patching the
> engine in-place.

**Adding a mod override**

To replace a base CorsixTH module with a mod-specific version:

1. Identify the module path relative to `CorsixTH\Lua\` (e.g. `rooms\gp.lua`).
2. Create the same relative path under `TerminalTriage\Lua\` (e.g.
   `TerminalTriage\Lua\rooms\gp.lua`).
3. The patched `corsixth.require` in `app.lua` will automatically prefer the
   mod file over the base installation — no additional wiring is required.
4. Add tests in `TerminalTriage\Luatest\spec\` covering the new behaviour.

### Running Tests

The test suite uses **busted 2.3.0** (Lua 5.4 + LuaRocks).

```
cd TerminalTriage\Luatest
lua %APPDATA%\luarocks\bin\busted
```

On Linux/macOS:

```bash
cd TerminalTriage/Luatest
lua ~/.luarocks/bin/busted
```

All tests must pass before merging.  The CorsixTH baseline tests also exist under
`CorsixTH\Luatest\` — run them if you touch any shared logic:

```
cd CorsixTH\Luatest
lua %APPDATA%\luarocks\bin\busted --lpath="../Lua/?.lua"
```

### Transition to Standalone Packaging

> **Status:** future milestone.  The in-repo workflow is the only supported
> approach for active development.

When Terminal Triage is eventually distributed as a standalone package (outside
the repository), the relative paths inside the bootstrapper stubs must be updated
to point to the user's CorsixTH installation rather than `../../CorsixTH/Lua/`.

**What changes for standalone**

| File | In-repo path | Standalone path |
|------|-------------|-----------------|
| `utility.lua` | `../../CorsixTH/Lua/utility.lua` | `<corsixth-install>/CorsixTH/Lua/utility.lua` |
| `strict.lua` | `../../CorsixTH/Lua/strict.lua` | `<corsixth-install>/CorsixTH/Lua/strict.lua` |
| `class.lua` | `../../CorsixTH/Lua/class.lua` | `<corsixth-install>/CorsixTH/Lua/class.lua` |
| `app.lua` (`base_lua_dir`) | `../../CorsixTH/Lua/` | `<corsixth-install>/CorsixTH/Lua/` |

The recommended approach for a future installer is to patch these paths at
install time (or read a `corsixth_lua_root` key from `config.txt`).  Until that
work is done, all contributors must work in the in-repo layout.

**What stays the same for standalone**

- `App:getFullPath` override — correctly resolves to the package directory via
  `debug.getinfo`, so Levels, Campaigns, and Graphics paths are always correct.
- All `launch.bat` / `launch.sh` logic — no changes required.
- `config.txt` — no structural changes required.

## Architecture Notes

### Lua Root Bootstrapper

CorsixTH's `--lua-dir` flag **completely replaces** the normal `CorsixTH/Lua/` search root with the specified directory. This means every module that `corsixth.require` tries to load must be present in the alternate root — there is no automatic fallback.

Terminal Triage solves this with a four-file bootstrapper in `TerminalTriage/Lua/`:

| File | Purpose |
|------|---------|
| `utility.lua` | Forward stub — `dofile`s `CorsixTH/Lua/utility.lua` |
| `strict.lua` | Forward stub — `dofile`s `CorsixTH/Lua/strict.lua` |
| `class.lua` | Forward stub — `dofile`s `CorsixTH/Lua/class.lua` |
| `app.lua` | **Bootstrapper** — patches `corsixth.require` to fall back to `CorsixTH/Lua/`, then `dofile`s the real `app.lua` |

The first three stubs are necessary because CorsixTH.lua loads `utility`, `strict`, and `class` *before* `app`, so the fallback patch cannot yet be in place. After `app.lua` runs, all subsequent `corsixth.require` calls go through the patched version which:

1. Tries the mod's `Lua/` directory first (mod overrides take priority).
2. Falls back to `CorsixTH/Lua/` if the file is absent from the mod directory.

This means the mod only needs to commit files it **actually overrides** — everything else loads transparently from the base game. The relative path `../../CorsixTH/Lua/` is hard-coded in the stubs, making this approach dependent on the development repository layout.

### Other Notes

- **Internal IDs are preserved for the first release.** Room IDs (`gp`, `pharmacy`, etc.), disease IDs (`bloaty_head`, etc.), and object IDs are kept stable. Only player-facing text changes.
- **Language overrides** live in `Lua\languages\english_terminal_triage.lua`. This file inherits from `English` and overrides all hospital terminology with IT-repair equivalents.
- **Custom campaign and levels** live in `Campaigns\` and `Levels\`. The campaign file references level files by name.
- **Graphics overrides** are optional for the first release but `Graphics\` and a stub `file_mapping.txt` are ready for Phase 3.

## See Also

- `SMOKE_TEST.md` - Bootstrap acceptance checklist (run after bootstrapper changes)
- `docs\it-total-conversion-mod-gdd.md` - Full game design document
- `docs\it-total-conversion-technical-plan.md` - Technical implementation plan
