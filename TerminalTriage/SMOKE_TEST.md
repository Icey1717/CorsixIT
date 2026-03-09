# Terminal Triage — Bootstrap Smoke-Test Checklist

Use this checklist to validate that the Terminal Triage bootstrap/package milestone
is working correctly.  Run it after any change to the bootstrapper stubs, the
launcher scripts, or `config.txt.template`.

---

## Pre-flight

- [ ] `config.txt` exists (copied from `config.txt.template`)
- [ ] `theme_hospital_install` in `config.txt` points to a valid Theme Hospital data directory
- [ ] `CORSIXTH_EXE` in `launch.bat` / `launch.sh` resolves to a runnable CorsixTH binary (v0.67+)
- [ ] Unit tests pass: `cd TerminalTriage\Luatest && lua %APPDATA%\luarocks\bin\busted`

---

## 1. Startup

**Steps:** launch the mod via `launch.bat` (Windows) or `launch.sh` (Linux/macOS).

- [ ] CorsixTH starts without a Lua error dialog
- [ ] The main menu is visible (title screen loads)
- [ ] No "module not found" error appears in the console or log

---

## 2. Isolated Config

**Purpose:** confirm the mod uses its own `config.txt` and does not touch the base
CorsixTH user config.

- [ ] Saves appear in `TerminalTriage\Saves\` (not the default CorsixTH saves location)
- [ ] Screenshots appear in `TerminalTriage\Screenshots\` (if taken)
- [ ] Changing `language` in `TerminalTriage\config.txt` does **not** affect a separate base CorsixTH installation

---

## 3. Alternate-Root Path Resolution

**Purpose:** verify that `App:getFullPath` resolves relative to `TerminalTriage\`,
not `CorsixTH\`.

- [ ] Starting a new game shows the campaign/level selection screen (not an error)
- [ ] Levels and Campaigns directories resolve to `TerminalTriage\Levels\` and
  `TerminalTriage\Campaigns\`
- [ ] Lua overrides in `TerminalTriage\Lua\languages\` are loaded (language strings
  reflect Terminal Triage text where applicable)

---

## 4. Custom Campaign Loading

**Purpose:** verify that `terminal_triage.campaign` is discovered and playable.

- [ ] The campaign selection screen lists "Terminal Triage" (or the campaign name
  defined in `terminal_triage.campaign`)
- [ ] Selecting the campaign shows the expected levels
- [ ] Starting level 1 loads without a Lua error

---

## 5. Graphics Override (Phase 3/4 — skip until art assets exist)

**Purpose:** validate the `use_new_graphics` path once custom `.dat` animation
files are available.

- [ ] Add `use_new_graphics = true` to `config.txt`
- [ ] Game starts without a graphics-load error
- [ ] `TerminalTriage\Graphics\file_mapping.txt` is read (no "file not found" error)
- [ ] Custom animations appear in-game (visual check)
- [ ] Removing `use_new_graphics` reverts to base Theme Hospital graphics

> **Note:** sprite sheet (Tab/Dat) overrides are **not** supported in the current
> pipeline.  Only `.dat` animation files can be overridden.  See bead
> `CorsixIT-6ph.4.1` for the planned extension.

---

## 6. Fallback Require

**Purpose:** confirm that modules NOT present in `TerminalTriage\Lua\` are loaded
transparently from `CorsixTH\Lua\`.

- [ ] Hospital world loads (rooms, diseases, staff objects all initialise)
- [ ] No "module not found in mod or base" error appears
- [ ] Saving and loading a game works (exercises many base modules)

---

## Pass Criteria

All checkboxes in sections 1–4 and 6 must be ticked for the bootstrap milestone
to be considered complete.  Section 5 is deferred to the Phase 3/4 art milestone.
