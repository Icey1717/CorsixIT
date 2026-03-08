# Theme Hospital: Game Loop and Design Notes

This document summarizes the core gameplay loop and high-level design of *Theme Hospital*, the 1997 Bullfrog management sim that CorsixTH recreates and extends. It is intended as a quick orientation document for contributors who want context on why the game plays the way it does.

## At a glance

*Theme Hospital* is a business management game disguised as a hospital simulator. The player does not directly control patients moment to moment; instead, they shape the hospital's systems, layout, staffing, and policies so that patients can move through diagnosis and treatment efficiently enough to keep the hospital profitable, reputable, and alive.

The design stands out because it balances three things at once:

- a clear management loop built around rooms, queues, and cash flow
- a comedic tone that makes an otherwise grim subject approachable
- a controlled-chaos structure where the player is always solving the next bottleneck

## Core game loop

The easiest way to think about *Theme Hospital* is as a repeating cycle of build, route, treat, earn, and expand.

### 1. Build the basic hospital

Each level starts with an empty or lightly developed hospital and a limited budget. The player lays out the initial essentials such as:

- Reception
- GP's Office
- Pharmacy
- Staff Room
- toilets and corridor furnishings

This opening phase is about creating the minimum viable hospital before patient flow begins in earnest.

### 2. Admit patients and establish flow

Patients enter, register, and usually begin in a GP's Office. From there, the hospital loop branches into diagnosis and treatment. The player is not manually walking patients around; instead, they influence outcomes through:

- room placement
- staff hiring
- queue management
- hospital policies
- diagnosis coverage

The hospital either functions as a smooth pipeline or collapses into congestion.

### 3. Diagnose patients

Patients often need multiple stops before the game is confident enough to recommend treatment. This creates one of the game's most important management problems: diagnosis is necessary for safe treatment, but too much diagnosis slows throughput and clogs queues.

That tension creates meaningful decisions:

- invest in more diagnosis capacity
- accept slower but safer routing
- push patients into treatment sooner for better turnover but greater risk

### 4. Treat patients and collect revenue

Once diagnosed, patients go to the appropriate treatment room. Successful treatment generates income and contributes to reputation, while failed cures and deaths damage the hospital's performance. The hospital is therefore a production system where curing patients is both the fantasy payoff and the economic engine.

### 5. Reinvest to remove bottlenecks

Revenue is immediately pushed back into the system:

- hiring more or better staff
- opening new diagnosis or treatment rooms
- training specialists
- researching new rooms and cure improvements
- expanding the building footprint

This creates the classic management-game loop: every improvement solves one problem and exposes the next one.

### 6. Respond to disruption

The steady-state loop is repeatedly interrupted by events and maintenance demands:

- machine wear and explosions
- staff fatigue
- epidemics
- emergencies
- VIP visits
- financial pressure

These disruptions keep the game from becoming a static optimization puzzle. The player is constantly pulled between long-term planning and short-term firefighting.

### 7. Meet level goals and move on

Campaign levels are won by reaching targets such as cash, hospital value, reputation, and cured patients while avoiding failure conditions like bankruptcy or too many deaths. This gives each hospital a medium-term arc:

1. stabilize operations
2. expand capacity
3. absorb shocks
4. hit performance thresholds
5. progress to a harder hospital

## The loop at three scales

### Moment-to-moment loop

Watch queues, respond to alerts, move staff, repair machines, and decide which bottleneck matters most right now.

### Operational loop

Tune layout, staffing mix, and room coverage so the hospital can handle patient volume efficiently.

### Campaign loop

Carry lessons from one hospital to the next as maps, disease mixes, and target thresholds grow more demanding.

This layered structure is a big reason the game remains readable: there is always something urgent to do, but that urgent task usually connects back to a larger systems problem.

## Major design principles

### 1. Business simulation first, hospital theme second

Bullfrog framed the hospital as a business rather than a realistic public-health simulation. The player's core job is to convert space, staff time, and equipment into cures and income. That framing explains why pricing, reputation, loans, and throughput matter as much as medical outcomes.

### 2. Humor over realism

The team intentionally moved away from real illnesses and toward fictional diseases such as Bloaty Head and King Complex. That choice avoided a distasteful tone, gave the artists and writers more freedom, and made every room and cure instantly memorable. Humor is not decoration here; it is a usability feature that makes systems easier to parse and remember.

### 3. Readability through room-based systems

The game breaks hospital management into distinct rooms with clear functions. This turns a complicated service simulation into understandable modules:

- GP rooms create entry points
- diagnosis rooms raise certainty
- treatment rooms convert certainty into outcomes and money
- support rooms sustain staff and operations

Because the player thinks in rooms rather than abstract spreadsheets alone, the game feels tactile and approachable.

### 4. Indirect control

Patients and staff largely act on their own. The player influences behavior through layout, policies, staffing, and intervention rather than direct unit control. This keeps the fantasy managerial: the player designs systems and reacts to emergent behavior instead of micromanaging every step.

### 5. Bottleneck-driven challenge

The game rarely asks, "Can you build a hospital at all?" Instead, it asks, "Can you spot the next constraint before it spirals?" A crowded GP queue, an exhausted specialist, or an unmaintained machine can all become the weak link that destabilizes the hospital.

### 6. Controlled chaos

Theme Hospital succeeds because it is busy without becoming unreadable. The animations, announcer messages, and event structure create pressure, but the underlying rules remain legible enough that a player can usually trace failure back to a system choice.

### 7. Escalation through breadth, not just numbers

Progression is not only about bigger targets. Later hospitals ask the player to manage more room types, more specialized staff, more diseases, and more interruptions at once. Difficulty expands the number of interacting systems, which makes progression feel richer than simply increasing patient counts.

## Why the theme works

A real hospital is a serious place, but *Theme Hospital* turns that setting into a playful management sandbox by using exaggeration, satire, and cartoon presentation. The result is a game where:

- disease types double as visual jokes
- treatment machines become memorable set pieces
- staff behavior creates character as well as systems pressure
- the hospital feels alive even when the player is mostly moving icons and budgets

That design choice let Bullfrog keep the strategic appeal of a complex service business while avoiding a grim or clinical tone.

## Why this matters for CorsixTH

CorsixTH recreates this experience, so changes to mechanics, UI, pacing, or balance should preserve the original loop:

- players should still think in terms of flow and bottlenecks
- humor and readability should remain part of the design, not just presentation
- player decisions should shape systems more often than individual characters
- progression should feel like increasing operational complexity

When evaluating changes, a good question is: does this reinforce the "build a funny but efficient cure factory" identity, or does it pull the game toward something more direct, more realistic, or less legible?

## References

These notes are paraphrased from the following sources:

- CorsixTH README: https://github.com/CorsixTH/CorsixTH/blob/master/README.md
- Theme Hospital overview and development history: https://en.wikipedia.org/wiki/Theme_Hospital
- EA store description: https://www.ea.com/games/theme/theme-hospital
- StrategyWiki overview: https://strategywiki.org/wiki/Theme_Hospital
