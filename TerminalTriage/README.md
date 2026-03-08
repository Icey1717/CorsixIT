# Terminal Triage

**Terminal Triage** is a total-conversion mod for [CorsixTH](https://github.com/CorsixTH/CorsixTH) that re-themes the classic hospital management gameplay as an IT repair and support shop. Instead of treating patients with bizarre ailments, you run a tech-repair business: diagnosing broken devices, fixing software issues, managing engineers and technicians, and handling malware outbreaks.

## Package Layout

```
TerminalTriage/
  Lua/                      <- Alternate Lua root (passed via --lua-dir)
    languages/
      english_terminal_triage.lua   <- IT re-theme string overrides (Phase 1)
    ...                     <- Future: custom rooms, diseases, objects, etc.
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

For active development inside the CorsixTH repository:

1. Work directly in the `TerminalTriage\` directory in this repo.
2. Copy `config.txt.template` to `config.txt` and configure your Theme Hospital path.
3. Launch using the launchers above, pointing at this directory.
4. CorsixTH will load Lua from `TerminalTriage\Lua\`, which starts minimal and grows as mod content is added.
5. Once a feature is stable, it stays in `TerminalTriage\` - no changes are made to the base `CorsixTH\` tree.

This keeps Terminal Triage isolated so upstream CorsixTH updates do not conflict with mod changes.

## Architecture Notes

- **Internal IDs are preserved for the first release.** Room IDs (`gp`, `pharmacy`, etc.), disease IDs (`bloaty_head`, etc.), and object IDs are kept stable. Only player-facing text changes.
- **Language overrides** live in `Lua\languages\english_terminal_triage.lua`. This file inherits from `English` and overrides all hospital terminology with IT-repair equivalents.
- **Custom campaign and levels** live in `Campaigns\` and `Levels\`. The campaign file references level files by name.
- **Graphics overrides** are optional for the first release but `Graphics\` and a stub `file_mapping.txt` are ready for Phase 3.

## See Also

- `docs\it-total-conversion-mod-gdd.md` - Full game design document
- `docs\it-total-conversion-technical-plan.md` - Technical implementation plan
