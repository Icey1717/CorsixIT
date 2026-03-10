# Terminal Triage Companion App

A local web app for browsing and editing all the name mappings that Terminal Triage
applies on top of CorsixTH — rooms, diseases, staff, and objects.

## Requirements

- [Node.js](https://nodejs.org/) 18 or later (no `npm install` needed)

## Start

Double-click **`companion.bat`** (Windows).

Or from a terminal:
```
node companion\server.js
```

Then open **http://localhost:3747** in your browser.

## Features

- **Browse** all 100+ Terminal Triage → CorsixTH name mappings in four tabs
- **Search** by either original or mod name in real time
- **Flip** the columns to search from either direction
- **Edit mode** — toggle the ✏ switch in the top-right corner to edit any
  Terminal Triage name or disease description directly in the browser
- Changes are saved immediately back to:
  `TerminalTriage/Lua/languages/english_terminal_triage.lua`
- Reload the game after saving to see your changes in-game

## What's editable

| Tab | Editable fields |
|---|---|
| Rooms | Short name, Long name |
| Diseases | Name, Cause, Symptoms, Cure |
| Staff | Display name |
| Objects | Display name |

The original CorsixTH / Theme Hospital names are shown for reference and cannot be
edited (they come from the game's binary data files).

## Stopping the server

Press **Ctrl+C** in the terminal window.
