# Terminal Triage Technical Plan

This document translates the IT-repair total-conversion GDD into a concrete implementation plan based on the current CorsixTH codebase. It focuses on what is actually in `CorsixTH\`, how the game loads content, which parts are easy to re-theme, and where deeper work is required.

## 1. What is in `CorsixTH\`

At the top level, the `CorsixTH` folder is already split in a way that is useful for a total conversion:

- `Lua\` - gameplay logic, content definitions, UI, strings, and most simulation behavior
- `Levels\` - level configuration files (`.level`)
- `Campaigns\` - campaign definitions (`.campaign`)
- `Graphics\` - custom graphics mapping support
- `Bitmap\` - shipped graphics resources and tools
- `Src\` and `SrcUnshared\` - C++ engine code

For this mod, the practical center of gravity is `CorsixTH\Lua\`. The game bootstraps almost all gameplay content from Lua, then uses the C++ engine primarily for rendering, map/pathfinding, and low-level file / audio / graphics support.

## 2. Key technical findings

### 2.1 Most game content is Lua-driven

During app startup, `App:init()` loads most content from fixed Lua folders:

- walls from `Lua\walls`
- objects from `Lua\objects` and `Lua\objects\machines`
- rooms from `Lua\rooms`
- humanoid actions from `Lua\humanoid_actions`
- diseases and diagnosis content from `Lua\diseases` and `Lua\diagnosis`

Relevant files:

- `CorsixTH\Lua\app.lua`
- `CorsixTH\Lua\room.lua`
- `CorsixTH\Lua\hospital.lua`
- `CorsixTH\Lua\world.lua`

This is good news for the mod: the core gameplay content is editable without needing immediate C++ changes.

### 2.2 Levels and campaigns are already extensible

CorsixTH already supports custom levels and campaigns:

- built-in campaign directory: `CorsixTH\Campaigns\`
- built-in levels directory: `CorsixTH\Levels\`
- user campaign and user level directories from config
- custom campaign browser in `Lua\dialogs\resizables\menu_list_dialogs\custom_campaign.lua`
- custom level browser in `Lua\dialogs\resizables\menu_list_dialogs\custom_game.lua`

Relevant files:

- `CorsixTH\Lua\app.lua`
- `CorsixTH\Lua\map.lua`
- `CorsixTH\Lua\dialogs\resizables\menu_list_dialogs\custom_campaign.lua`
- `CorsixTH\Lua\dialogs\resizables\menu_list_dialogs\custom_game.lua`
- `CorsixTH\Lua\config_finder.lua`

This means the IT conversion can ship its own campaign and level files without fighting the base game format.

### 2.3 Graphics already have an override path

If `use_new_graphics` is enabled, CorsixTH will look for custom graphics mappings in a `Graphics\file_mapping.txt` path, either from config or from the default `Graphics` folder relative to the current Lua tree.

Relevant files:

- `CorsixTH\Lua\graphics.lua`
- `CorsixTH\Lua\config_finder.lua`

This is a strong fit for the mod's art phase.

### 2.4 Audio is more constrained than graphics

Background music can come from a user-supplied folder, but speech / announcer archives are loaded from `Sound\Data\Sound-*.dat` via the Theme Hospital install filesystem. That makes custom voice packs harder than text or graphics.

Relevant file:

- `CorsixTH\Lua\audio.lua`

For MVP, text subtitles can change immediately, but custom spoken announcements likely need either:

- reuse of original voice assets,
- a patched Theme Hospital data setup, or
- a small code extension to support an external speech archive path.

### 2.5 There is no general-purpose mod loader, but there is a powerful bootstrap hook

The biggest practical discovery is in `CorsixTH\CorsixTH.lua`: the bootstrap accepts `--lua-dir=...`, and `corsixth.require()` loads Lua files from that selected code directory. Because `App:getFullPath()` derives paths from the currently loaded Lua files, an alternate Lua tree can effectively redirect the game's default `Lua`, `Levels`, `Campaigns`, and `Graphics` roots.

Relevant file:

- `CorsixTH\CorsixTH.lua`

This means a standalone total-conversion package is viable without first writing a new mod loader, as long as the mod mirrors the expected folder structure.

## 3. Recommended packaging strategy

### 3.1 Recommended approach: alternate Lua root

The cleanest path is to build Terminal Triage as an alternate CorsixTH content tree and launch it with `--lua-dir`.

Suggested structure:

```text
TerminalTriage\
  Lua\
  Levels\
  Campaigns\
  Graphics\
  config.txt
  hotkeys.txt
  run-terminal-triage.bat
```

Example launcher concept:

```text
CorsixTH.exe --lua-dir=G:\path\to\TerminalTriage\Lua --config-file=G:\path\to\TerminalTriage\config.txt
```

Why this is the best starting point:

- it avoids editing the user's base CorsixTH install in place
- it lets the mod own its own Lua, levels, campaigns, and graphics tree
- it works with the current bootstrap design
- it postpones engine changes until they are truly needed

### 3.2 Development workflow

For development inside this repository, keep using the in-repo `CorsixTH\` tree first, then extract the mod into its own mirrored folder once the first playable slice exists. That gives faster iteration while still targeting the cleaner standalone layout.

## 4. Mod architecture decisions

### 4.1 Preserve internal IDs for the first playable version

For the first fully playable build, keep the internal IDs and classes stable:

- keep room IDs like `gp`, `pharmacy`, `psych`
- keep disease IDs like `bloaty_head`, `slack_tongue`
- keep object and machine IDs where possible
- keep staff classes as Doctor / Nurse / Handyman / Receptionist internally

Only change what the player sees:

- string tables
- descriptions
- campaign framing
- room purpose text
- disease presentation
- graphics and audio where available

Why this matters:

- `room.id` and `disease.id` are used throughout routing and pricing logic
- disease definitions carry `expertise_id` values that align with level config tables
- `.level` files refer to original expertise and object slots
- changing internal IDs too early creates unnecessary code churn

Example: `bloaty_head` can become "Battery Balloon" in UI while still using the internal `bloaty_head` disease ID and `inflation` treatment room during the MVP phase.

### 4.2 Use new files selectively, not everywhere

New files are best reserved for:

- new campaigns and levels
- new language variant(s)
- later-stage bespoke rooms or mechanics such as QA / burn-in
- extra events or helper modules

For core remapping, editing or forking existing room / disease definitions is safer than inventing a completely parallel ID space immediately.

### 4.3 Prefer a dedicated language file over rewriting `english.lua`

Because `Strings:init()` scans `Lua\languages\*.lua`, the mod can add a dedicated language variant such as:

- `Lua\languages\english_terminal_triage.lua`

That file can inherit from English and override strings for:

- staff labels
- room names
- disease names and descriptions
- adviser messages
- tooltips
- campaign text

This is cleaner than rewriting the stock English file and makes fallback behavior easier to reason about.

## 5. File-by-file mod surfaces

### 5.1 Content definitions

### Rooms

Primary touchpoints:

- `CorsixTH\Lua\rooms\*.lua`
- `CorsixTH\Lua\room.lua`

Use for:

- renaming room identity in UI
- adjusting room tooltips and descriptions
- repurposing existing treatment logic
- later adding bespoke rooms such as QA / burn-in

### Diseases and diagnosis

Primary touchpoints:

- `CorsixTH\Lua\diseases\*.lua`
- `CorsixTH\Lua\diagnosis\*.lua`
- `CorsixTH\Lua\base_config.lua`

Use for:

- mapping diseases to device problems
- preserving diagnosis/treatment chains
- tuning prices and difficulty
- deciding which issues are contagious for malware-style gameplay

### Objects and machines

Primary touchpoints:

- `CorsixTH\Lua\objects\*.lua`
- `CorsixTH\Lua\objects\machines\*.lua`

Use for:

- turning medical equipment into repair benches, scanners, clean-room tools, and service hardware
- remapping build costs and strengths
- later introducing custom IT-specific machine behavior

### Staff and customer behavior

Primary touchpoints:

- `CorsixTH\Lua\entities\humanoids\patient.lua`
- `CorsixTH\Lua\entities\humanoids\staff\doctor.lua`
- `CorsixTH\Lua\entities\humanoids\staff\nurse.lua`
- `CorsixTH\Lua\entities\humanoids\staff\handyman.lua`
- `CorsixTH\Lua\entities\humanoids\staff\receptionist.lua`
- `CorsixTH\Lua\staff_profile.lua`

Use for:

- customer impatience tuning
- role renaming
- trait repurposing
- later IT-specific staff specializations

### 5.2 Progression, economy, and events

Primary touchpoints:

- `CorsixTH\Lua\hospital.lua`
- `CorsixTH\Lua\research_department.lua`
- `CorsixTH\Lua\epidemic.lua`
- `CorsixTH\Lua\earthquake.lua`
- `CorsixTH\Lua\endconditions.lua`
- `CorsixTH\Levels\*.level`
- `CorsixTH\Campaigns\*.campaign`

Use for:

- business-value / brand-trust framing
- research renaming
- malware outbreak mapping
- power / infrastructure failure mapping
- new campaign goals and pacing

### 5.3 UI, strings, and presentation

Primary touchpoints:

- `CorsixTH\Lua\languages\original_strings.lua`
- `CorsixTH\Lua\languages\english.lua`
- `CorsixTH\Lua\strings.lua`
- `CorsixTH\Lua\dialogs\*.lua`
- `CorsixTH\Lua\dialogs\fullscreen\*.lua`
- `CorsixTH\Lua\dialogs\resizables\*.lua`

Use for:

- replacing hospital terminology
- changing casebook / policy wording
- updating adviser and dialog copy
- later adding IT-specific dashboards or contract panels

### 5.4 Asset delivery

Primary touchpoints:

- `CorsixTH\Graphics\file_mapping.txt`
- `CorsixTH\Lua\graphics.lua`
- `CorsixTH\Lua\audio.lua`

Use for:

- custom sprites and room art
- new icon mapping
- custom music
- evaluating the gap for custom speech delivery

## 6. Phased implementation plan

## Phase 0 - Bootstrap the mod as a runnable package

Goal: create a repeatable Terminal Triage runtime before content work begins.

Tasks:

1. Create a mirrored mod root with `Lua`, `Levels`, `Campaigns`, and `Graphics`.
2. Add a launcher that starts CorsixTH with `--lua-dir=<mod>\Lua`.
3. Add a mod-specific `config.txt` that points to the Theme Hospital install and enables the mod's graphics path if needed.
4. Smoke-test that the alternate Lua tree boots and resolves paths correctly.

Success criteria:

- the game boots from the mod tree
- custom campaigns and levels resolve from the mod package
- custom graphics can be enabled from the mod package

## Phase 1 - Text-first total conversion

Goal: make the game read like an IT repair sim before changing behavior deeply.

Tasks:

1. Add a Terminal Triage language file in `Lua\languages\`.
2. Override:
   - room names
   - staff labels
   - disease names, causes, cures, and tooltips
   - adviser lines
   - reputation / death phrasing where possible
3. Rewrite campaign and level briefings for the new fiction.
4. Update menu and custom campaign text to expose the mod cleanly.

Primary files:

- `Lua\languages\*.lua`
- `Campaigns\*.campaign`
- `Levels\*.level`

Notes:

- keep internal IDs unchanged
- this phase should already feel like a total-conversion prototype even with stock mechanics

## Phase 2 - Content remap while preserving mechanics

Goal: make the IT fiction line up with the existing gameplay loop.

Tasks:

1. Remap each disease to an IT issue in `Lua\diseases\`.
2. Remap each room to an IT service department in `Lua\rooms\`.
3. Remap machines and objects in `Lua\objects\` and `Lua\objects\machines\`.
4. Tune prices, expertise unlocks, and progression in:
   - `Lua\base_config.lua`
   - custom `.level` files
5. Build a new Terminal Triage campaign in `Campaigns\terminal_triage.campaign`.
6. Create a new set of `.level` files for the IT locations described in the GDD.

Primary files:

- `Lua\diseases\*.lua`
- `Lua\rooms\*.lua`
- `Lua\objects\*.lua`
- `Lua\base_config.lua`
- `Levels\*.level`
- `Campaigns\*.campaign`

Recommendation:

- ship the first public playable version at the end of this phase
- do not wait for bespoke new systems if the core total-conversion loop already works

## Phase 3 - Art pass and presentation pass

Goal: remove hospital visual leakage.

Tasks:

1. Build a custom `Graphics\file_mapping.txt`.
2. Replace room, machine, and customer-facing sprites progressively.
3. Add custom menu / icon / room art as needed.
4. Add custom background music through the supported music path.
5. Keep announcement subtitles aligned with the new fiction even if spoken lines remain temporary.

Primary files:

- `Graphics\file_mapping.txt`
- asset folders referenced by that mapping
- `Lua\graphics.lua` only if gaps appear

Notes:

- this is where the mod stops looking like a smart reskin and starts looking like its own game

## Phase 4 - Behavioral extensions

Goal: add the mechanics that are unique to the IT fantasy.

Tasks:

1. Rework epidemics into malware outbreaks:
   - `Lua\epidemic.lua`
   - `Lua\hospital.lua`
2. Rework earthquakes into infrastructure failures:
   - `Lua\earthquake.lua`
3. Add QA / burn-in as a late-stage room:
   - new room file under `Lua\rooms\`
   - supporting objects / machines as needed
4. Add contract / SLA systems if still desired after playtesting:
   - likely new helper module plus changes in `hospital.lua` and UI dialogs
5. Rework customer failure outcomes:
   - `patient.lua`
   - `hospital.lua`
   - possibly `humanoid_actions\die.lua` if the grim reaper sequence is no longer acceptable

Notes:

- this is the highest-risk phase
- several goals here are nice-to-have, not required for the first full campaign release

## 7. Biggest risks and how to handle them

### Risk 1: changing internal IDs too early

If room or disease IDs are renamed everywhere up front, the mod will end up chasing routing, pricing, casebook, and level-config breakage.

Mitigation:

- preserve internal IDs for MVP
- change player-facing names first

### Risk 2: audio fidelity lags behind the rest of the mod

Custom speech is harder than custom text and graphics because spoken archives are loaded from the original data path.

Mitigation:

- treat custom voice as a later enhancement
- rely on subtitles and rewritten UI text first

### Risk 3: medical leftovers remain in deep UI or simulation copy

There are many string surfaces, including dynamic info, adviser messages, casebook text, and level text.

Mitigation:

- do a structured terminology pass before deep feature work
- maintain a mapping sheet for core terms such as patient, doctor, cure, reputation, epidemic, emergency, and death

### Risk 4: the mod becomes a fork that is hard to maintain

If the mod edits the repository in place with no packaging strategy, updating from upstream will become expensive.

Mitigation:

- target the alternate `--lua-dir` package layout early
- keep the mod's changed tree isolated

## 8. Recommended first sprint

The first implementation sprint should aim for a narrow but runnable slice:

1. Boot from an alternate Lua root.
2. Add a Terminal Triage language file.
3. Re-theme GP, Pharmacy, Research, Staff Room, and a handful of diseases.
4. Create one custom campaign and one custom level.
5. Verify that a player can complete a small IT-themed scenario end to end.

That slice will validate the most important assumptions:

- packaging works
- strings pipeline works
- custom campaign pipeline works
- existing room / disease mechanics can sell the new fantasy

## 9. Recommendation

The project is technically viable with the current CorsixTH architecture, and it does not need an engine rewrite to get to a strong first release. The best path is to build the mod as an alternate Lua-root package, keep internal IDs stable for the first playable version, ship the new campaign and terminology early, and treat custom audio plus bespoke systems like contracts and QA as later layers rather than prerequisites.
