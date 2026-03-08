# Terminal Triage

## Total Conversion Mod Game Design Document

This document proposes a total conversion mod for CorsixTH that replaces the hospital fantasy of *Theme Hospital* with a comedic IT repair and support business. Instead of curing patients, the player operates a repair shop, service center, and managed-support business where customers bring in malfunctioning hardware, broken software, and self-inflicted tech disasters.

The goal is to preserve the original game's strengths - readable room-based management, bottleneck-driven play, escalating chaos, and darkly comic simulation - while shifting every major system into an Information Technology setting.

## 1. High concept

### Working title

**Terminal Triage**

Alternative names for later consideration:

- Theme Tech Support
- Critical Reboot
- Panic Room IT
- Service Desk Simulator

### Elevator pitch

Run a chaotic IT repair empire where customers arrive with corrupted laptops, swollen batteries, malware infections, dead consoles, printer curses, and impossible expectations. Build departments, hire specialists, route jobs through diagnostics and repair, manage warranties and customer patience, and grow from a tiny repair counter into a multi-floor technology support powerhouse.

### Vision statement

The mod should feel like a natural cousin to *Theme Hospital*: funny, system-driven, and easy to read at a glance. Players should experience the same satisfaction of finding bottlenecks and expanding operations, but through the fantasy of rescuing devices, data, and workplace productivity instead of human health.

## 2. Design goals

### Primary goals

1. Preserve the original management loop.
2. Re-theme every major gameplay system into IT support and electronics repair.
3. Keep the tone playful and satirical rather than realistic or grim.
4. Make device problems visually distinctive and mechanically legible.
5. Support a full campaign arc from neighborhood repair store to enterprise support campus.

### Non-goals

- Hard simulation of real electronics engineering
- Realistic treatment of privacy law or IT compliance
- A serious cyber-security training product
- Direct character control or manual minigame-heavy repair gameplay

## 3. Core fantasy

The player is not a lone repair technician. They are the owner-operator of a growing tech service business. Their fantasy is built on five satisfactions:

- **Rescue**: turning useless devices into working machines
- **Diagnosis**: figuring out what is actually wrong before committing resources
- **Optimization**: designing a workplace that moves jobs efficiently
- **Expansion**: unlocking new tools, labs, and service offerings
- **Comedy**: dealing with absurd user behavior, cursed devices, and overconfident staff

The best emotional frame is "running an overworked but weirdly successful repair and support company."

## 4. Design pillars

### 4.1 Systems first, theme second

The original game's success comes from queue management, room specialization, and profit under pressure. This mod should keep that structure intact. The IT theme must map cleanly onto those systems instead of replacing them with unrelated mechanics.

### 4.2 Humor through exaggeration

The setting should satirize consumer technology, corporate support culture, influencer gadget obsession, and common user mistakes. Problems should feel recognizable, but amplified into memorable visual jokes.

### 4.3 Readability through departments

Each room should have a clear function and an understandable place in the repair pipeline. Players should always be able to answer:

- where a job enters the system
- what queue is currently overloaded
- which specialist or machine is the bottleneck
- which upgrade will relieve pressure

### 4.4 Indirect management

Players should influence workflow through layout, staff hiring, policies, priority settings, and expansion, not by manually performing repairs. The player is a manager of systems, not a screwdriver-based action hero.

### 4.5 Escalation through complexity

Later progression should add new device categories, more specialized rooms, stricter turnaround expectations, contract customers, and cascading failures rather than simply increasing customer counts.

## 5. The new gameplay loop

The mod's loop should mirror *Theme Hospital* while feeling native to an IT service business.

### 5.1 Intake

Customers arrive carrying devices or filing support tickets. They register at the **Service Counter** and enter the system with an initial complaint such as:

- "Laptop won't boot"
- "Phone battery got puffy"
- "Printer is possessed"
- "All my files have become soup"
- "The cloud ate my homework"

### 5.2 Triage

Jobs move to a **Triage Desk** where a general technician performs the first assessment. Like the GP loop in *Theme Hospital*, triage decides whether the issue is obvious, requires deeper diagnostics, or can be routed straight to a quick-fix service.

### 5.3 Diagnosis

Complex jobs may pass through one or more diagnostic rooms to raise certainty:

- hardware testing
- malware scanning
- data recovery analysis
- network emulation
- customer interview and settings review

The central tension remains the same: more diagnosis improves success rates but slows throughput and fills queues.

### 5.4 Repair or service

Once the problem is known well enough, the device enters the appropriate service room. Successful work restores the device, earns revenue, and improves reputation. Failed work wastes time, causes refunds, damages customer trust, or destroys the device entirely.

### 5.5 Quality assurance and handoff

Some jobs finish immediately, while more complex jobs should pass through **QA / Burn-In Testing** before pickup. This provides an additional lever for balancing risk versus speed.

### 5.6 Reinvestment

Revenue is reinvested into:

- more staff
- better tools
- new service rooms
- staff training
- expanded floor space
- research and automation

### 5.7 Event response

The smooth loop is interrupted by malware outbreaks, recall surges, impatient contract clients, power fluctuations, overheating equipment, and pests made of cables, dust, or office drones. The player's challenge is to keep service flowing while chaos escalates.

## 6. Loop at three scales

### Moment-to-moment loop

Watch queues, move technicians, fix equipment, calm down frustrated customers, and decide which department is falling behind.

### Operational loop

Tune layout, staffing mix, device routing, and policy thresholds so intake, diagnosis, repair, and pickup form an efficient pipeline.

### Campaign loop

Progress through increasingly complex locations, unlocking new tools, contract types, device families, and customer expectations.

## 7. Setting and tone

### Setting

The world is a heightened version of late-1990s to near-future consumer technology culture. Players manage a chain of repair and support businesses in towns and business districts where every electronic device is fragile, cursed, insecure, or used incorrectly.

### Tone

The tone should be satirical and affectionate:

- customers speak with total confidence and zero technical literacy
- devices fail in absurd but readable ways
- staff are skilled but eccentric
- corporate clients are wealthy, impatient, and unreasonable
- announcer lines are dry, sarcastic, and lightly exasperated

The comedy target is "office and gadget chaos," not mean-spirited mockery of customers.

## 8. Customer fantasy and avatar types

Customers replace patients, but they should still be readable as moving gameplay entities with visible states.

### Customer categories

- everyday consumers
- students
- office workers
- gamers
- creators and streamers
- small business owners
- corporate account reps
- confused seniors
- overconfident hobbyists

### Visible states

- calm
- impatient
- panicked
- angry
- relieved
- waiting on estimate approval
- waiting for pickup

### Need states

These mirror the original need pressures:

- comfort while waiting
- information clarity
- speed of service
- trust in the business
- access to vending, seating, power outlets, and restrooms

## 9. Staff roles

Staff roles should map closely to existing classes where possible, while adopting new names and identities.

| Original role | IT mod role | Function |
| --- | --- | --- |
| Receptionist | Service Desk Coordinator | Registers customers, creates tickets, routes intake |
| Doctor | Technician / Engineer | Performs triage, diagnostics, specialist repairs, research, and training |
| Nurse | Bench Technician | Handles quick-turn service rooms and standardized repair tasks |
| Handyman | Facilities Tech | Maintains machines, cleans e-waste, refills supplies, handles pests and utility failures |

### Technician specializations

Specialization should mirror the original "doctor skill" structure.

- **Generalist Tech**: good at intake, simple diagnosis, and flexible coverage
- **Hardware Engineer**: motherboard repair, component replacement, soldering stations, screen and battery work
- **Software Specialist**: malware removal, OS repair, driver fixes, account recovery
- **Network Engineer**: connectivity issues, router work, enterprise systems, server racks
- **Data Recovery Expert**: storage diagnostics, file restoration, backup recovery
- **R&D Specialist**: researches new services, upgrades, and efficiency boosts
- **Trainer**: raises staff skill growth and cross-training efficiency

### Staff traits

Traits should stay humorous and mechanically relevant:

- fast worker
- static magnet
- great with customers
- terrible handwriting
- cable hoarder
- caffeine dependent
- security-minded
- overclocks everything
- panic-prone
- warranty whisperer

## 10. Room and department mapping

This section is the backbone of the total conversion. Rooms should feel like direct descendants of the original gameplay structure.

| Hospital concept | IT mod equivalent | Gameplay purpose |
| --- | --- | --- |
| Reception | Service Counter | Customer arrival and ticket creation |
| GP's Office | Triage Desk | First-pass diagnosis and routing |
| General diagnosis rooms | Diagnostic Labs | Increase certainty before repair |
| Pharmacy | Quick Fix Counter | Simple fixes, installs, cable swaps, battery resets |
| Ward | Bulk Repair Bay | Handles batches of standardized repair jobs |
| Psychiatry | Customer Support / Configuration Lab | Solves user-error, settings, onboarding, and training-heavy problems |
| Research | R&D Lab | Unlocks new services, tool upgrades, and efficiency improvements |
| Training Room | Training Center | Upskills staff and unlocks specializations |
| Staff Room | Break Room | Restores staff energy |
| Operating Theatre | Clean Room Workshop | High-risk advanced hardware repair |
| Toilets | Restrooms | Basic facility need |
| Specialized treatment rooms | Specialized Service Labs | Device- or issue-specific repair pipelines |

### Core launch rooms

These rooms should define the early game:

- Service Counter
- Triage Desk
- Quick Fix Counter
- Break Room
- Restrooms
- Basic Hardware Diagnostics
- Basic Software Repair

### Mid-game rooms

- Malware Containment Lab
- Data Recovery Suite
- Bulk Repair Bay
- Training Center
- R&D Lab
- Screen and Battery Workshop
- Network Test Lab

### Late-game rooms

- Clean Room Workshop
- Server Rescue Room
- Console Mod and Repair Lab
- Smart Home Interoperability Bay
- Corporate SLA Operations Center
- Refurbishment and Resale Studio

## 11. Device and issue taxonomy

Device problems replace illnesses. They should be exaggerated, visually clear, and grouped into understandable families.

### Hardware issues

- **Battery Balloon**: swollen battery requiring careful replacement
- **Screen Splatter**: catastrophic cracked display
- **Port Collapse**: charging port destroyed by years of abuse
- **Thermal Meltdown**: fans blocked, paste dried, machine throttling badly
- **Button Mashing Syndrome**: input hardware permanently damaged

### Software issues

- **Driver Amnesia**: device has forgotten what its own components are
- **Update Loop Fever**: machine reboots forever into patch purgatory
- **Notification Storm**: impossible popup spam and alert fatigue
- **Settings Labyrinth**: customer turned on every bad option at once
- **Registry Rot**: system performs worse with every passing minute

### Network and online issues

- **Cloud Confusion**: files exist everywhere and nowhere
- **Wi-Fi Stage Fright**: device refuses to connect when anyone is watching
- **Password Panic**: customer has three accounts and none are correct
- **Sync Drift**: work exists on the wrong machine in the wrong version
- **Latency Gremlins**: multiplayer and streaming performance collapse

### Data and security issues

- **Ransomwear**: malware has "fashionably" encrypted everything
- **Backup Mirage**: customer insists backups exist; they do not
- **Folder Catastrophe**: important files moved into impossible places
- **Phishing Hangover**: access problems after obvious scam links
- **Privacy Spill**: device routed through risky or infected states

### User behavior issues

These are the spiritual successor to comedic diseases caused by bad habits and weird psychology.

- **Tab Tsunami**: browser with hundreds of open tabs
- **Desktop Archaeology**: files, icons, and shortcuts layered into geological strata
- **Printer Diplomacy Failure**: customer and printer are locked in a mutual grudge
- **Cable Nesting**: impossible tangle of chargers and adapters
- **Admin Complex**: customer changed protected settings because they "know computers"

## 12. Diagnostic pipeline design

The diagnostic stage is what keeps the mod strategically faithful to *Theme Hospital*. Repairs should not be a one-click certainty.

### Intended tension

- Diagnose too little: higher failure and refund rates
- Diagnose too much: long queues and missed service deadlines
- Train weak staff poorly: misroutes and wasted room time
- Expand too late: customer patience collapses

### Diagnosis sources

- technician skill
- specialized diagnostic machines
- device history and notes
- customer interview quality
- policy thresholds for certainty

### Policy lever

The player can decide how much diagnostic certainty is required before work begins. Aggressive shops move devices faster but risk expensive mistakes. Conservative shops earn trust but may develop terrible queues.

## 13. Repair room concepts

### Quick Fix Counter

Handles low-complexity issues:

- software reinstall
- accessory replacement
- account relogin
- simple cable or charger swaps
- printer resets

### Basic Hardware Diagnostics

Tests power, thermals, storage health, display output, memory integrity, and peripheral failure.

### Basic Software Repair

Runs scans, patch rollback, boot repair, cleanup, and standard recovery tools.

### Malware Containment Lab

A controlled space for dangerous infections and compromised devices. Higher cure value, higher failure risk, and higher reputational impact.

### Data Recovery Suite

Slow, expensive, high-value room focused on restoring precious files. Strong emotional stakes, high margins, and room for dramatic success or total loss.

### Screen and Battery Workshop

Fast-moving specialist room with visible parts, safety hazards, and strong throughput value.

### Network Test Lab

Simulates home and office networks, router issues, ISP blame loops, and strange compatibility failures.

### Clean Room Workshop

Late-game high-risk room for severe hardware damage, liquid incidents, board-level repair, and premium contracts.

### Corporate SLA Operations Center

A high-volume, contract-driven room or suite focused on business customers with strict response expectations and strong revenue potential.

## 14. Economy design

### Revenue sources

- diagnostic fees
- repair charges
- premium rush service
- data recovery fees
- contracts and SLAs
- refurbished resale
- accessory upsells
- maintenance subscriptions

### Costs

- salaries
- equipment purchase
- room construction
- spare parts
- utilities
- refunds and warranty claims
- loan interest

### Core economic tension

The player is not paid for devices entering the shop. They are paid for moving work through the system successfully without destroying trust, overloading staff, or letting failures spiral.

### Pricing model

The player can adjust pricing policy across broad categories:

- low-cost, high-volume
- balanced service pricing
- premium boutique repair
- aggressive upsell strategy

Pricing should affect customer flow, reputation, and the type of clientele attracted.

## 15. Reputation and trust

Reputation should be reframed as **Brand Trust**.

### Trust increases when:

- repairs succeed
- estimates are fair
- pickup times are reasonable
- waiting spaces are comfortable
- contract deadlines are met
- data is preserved

### Trust decreases when:

- repairs fail
- devices are lost or destroyed
- queues get absurd
- customers leave unserved
- malware spreads within the business
- loud public incidents occur

High trust attracts premium clients and better contracts. Low trust fills the shop with low-margin desperation cases and public complaints.

## 16. Events and disasters

The conversion should preserve the original rhythm of surprise events.

### Emergency equivalent: Surge jobs

A burst of same-type work arrives with a bonus for processing it well.

Examples:

- local school laptop failure
- office printer fleet collapse
- viral phone-screen disaster after a concert
- gaming cafe network outage

### Epidemic equivalent: Malware outbreak

Infected devices spread contamination risk through shared systems, careless staff behavior, or poor containment. The player can isolate the outbreak quietly or suffer a public scandal.

### Earthquake equivalent: Utility / infrastructure failure

Instead of walls shaking, the building suffers:

- power surges
- cooling failures
- network backbone outages
- sprinkler leaks
- inventory system crashes

### VIP visit equivalent: Audit or influencer review

Possible visitors:

- corporate procurement lead
- tech journalist
- local celebrity streamer
- insurance underwriter
- franchise inspector

### Rats equivalent: Cable gremlins

Small, comedic pests made of loose cables, dust bunnies, or rogue office robots appear in corridors and storage areas. The player clicks them away to prevent mess, slowdowns, or minor damage.

## 17. Research and progression

Research should unlock both function and flavor.

### Research categories

- new repair rooms
- better diagnostic certainty
- faster benches and tools
- safer high-risk procedures
- improved spare-part efficiency
- automation and ticket routing
- advanced contract offerings

### Example unlocks

- automated imaging station
- anti-static smart flooring
- battery fire suppression
- premium pickup lockers
- remote diagnostics desk
- enterprise monitoring wall
- refurbished device certification

## 18. Campaign structure

The campaign should follow a business-growth fantasy while introducing new systems in layers.

### Level 1: Mall Kiosk Rescue

Tiny footprint, mostly phones and laptops, teaches intake and quick fixes.

### Level 2: Neighborhood Repair Shop

Adds simple diagnostics, staffing pressure, and first serious queues.

### Level 3: Student Tech Hub

High volume, low patience, cheap devices, lots of software issues.

### Level 4: Small Business Support Center

Introduces contracts, printers, networks, and uptime expectations.

### Level 5: Gamer District Service Lab

Expensive hardware, impatient customers, thermal and performance cases.

### Level 6: Corporate Office Park

Dense contract work, strict deadlines, higher-value service rooms.

### Level 7: Creative Studio Recovery House

High-stakes data recovery and color-critical workstation issues.

### Level 8: Smart Home Chaos Center

Adds ecosystem conflicts, connected devices, and compatibility nightmares.

### Level 9: Electronics Megastore Service Annex

Huge intake volume, poor margins, pressure to optimize throughput.

### Level 10: Managed Services Headquarters

Blends walk-in repairs with contract operations and enterprise incidents.

### Final level: National Tech Support Campus

The full fantasy: large footprint, multiple specializations, nonstop events, and mastery of every system.

## 19. Progression objectives

Campaign win conditions should map to the original but use IT language:

- cash on hand
- business valuation
- brand trust
- completed jobs
- contract retention
- average turnaround time

Failure conditions:

- insolvency
- too many catastrophic service failures
- trust collapse
- repeated contract breaches

## 20. Policies and player decisions

Policies are a strong fit for the IT theme and can provide meaningful strategy.

### Suggested policy sliders

- required diagnostic certainty before repair
- accept risky data-recovery attempts or refuse them
- prioritize rush jobs or fair queue order
- allow junior staff on premium devices
- automatic part replacement thresholds
- refund generosity
- contract work priority versus walk-in customers
- customer communication frequency

These should create real tradeoffs rather than pure upgrades.

## 21. Art direction

### Visual style

The art should remain bright, cartoony, and readable. Avoid sleek realism. The ideal look is a world where every cable, cracked screen, thermal plume, and blinking router light communicates gameplay information instantly.

### Environmental storytelling

Rooms should visually explain themselves:

- repair benches full of parts
- shelves of labeled junk devices
- anti-static mats and tools
- server racks with noisy lights
- customer waiting areas with charging stations
- overflowing cable bins

### Character animation ideas

- customers waving dead phones in the air
- technicians peering through magnifiers
- staff recoiling from spicy batteries
- customers trying to explain impossible issues with grand gestures
- printers spitting error pages like confetti

## 22. Audio direction

### Music

Keep a quirky, light management-game feel with electronic instrumentation, office percussion, modem-like stingers, and playful synthetic tones.

### Announcer style

The announcer should sound mildly amused and thoroughly tired.

Example line directions:

- "Technician needed in Malware Containment."
- "A customer is demanding to speak to someone who actually understands printers."
- "Please do not plug mystery USB sticks into company machines."

### Room audio

- fan whir
- solder hiss
- drive clicking
- keyboard chatter
- alert chirps
- printer errors
- server hum

## 23. UI and terminology

The conversion should rename major concepts clearly.

| Original term | New term |
| --- | --- |
| Patient | Customer / Ticket |
| Doctor | Technician / Engineer |
| Nurse | Bench Tech |
| Handyman | Facilities Tech |
| Reputation | Brand Trust |
| Cure | Repair / Resolution |
| Death | Device Loss / Data Catastrophe |
| Diagnosis | Troubleshooting |
| Hospital Value | Business Value |
| Epidemic | Malware Outbreak |
| Emergency | Surge Job |

All menus, tooltips, and advisor text should reinforce the new fantasy consistently.

## 24. Content production guidelines

To keep the mod coherent, content creators should follow three rules:

1. Every issue name must be funny and instantly readable.
2. Every room must fit a clear spot in the service pipeline.
3. Every new mechanic must strengthen flow management rather than distract from it.

### Naming guidance

Prefer names that imply both fantasy and function:

- good: Battery Balloon, Update Loop Fever, Cloud Confusion
- weak: Broken Device 3, Software Error A

## 25. Implementation strategy for CorsixTH

This section is intended to help a future mod team phase the work realistically.

### Phase 1: Terminology and visual conversion

- rename staff, rooms, and events
- replace key UI strings
- create new room art, object art, and customer sprites
- create issue names and themed flavor text

This phase should already make the game feel substantially different, even if mechanics remain close to the original.

### Phase 2: Content remapping

- map diseases to device problems
- map treatment rooms to repair labs
- map training, research, and policies into IT language
- reskin announcer audio and event prompts

### Phase 3: System extensions

- add contract customers
- add QA / burn-in logic where feasible
- add stronger malware outbreak behaviors
- add new progression rewards or campaign framing

### Phase 4: Deep total-conversion polish

- custom campaigns and maps
- full art pass
- new music and ambient audio
- additional staff traits and flavor systems
- bespoke scripted events

## 26. Technical feasibility notes

### Likely straightforward

- text and terminology changes
- event renaming
- room identity remapping
- disease-to-issue replacement
- art, sound, and UI swaps

### Likely moderate effort

- campaign restructuring
- custom progression pacing
- more tailored advisor text
- custom object and machine animation sets

### Likely higher effort

- new mechanics not supported by existing room logic
- true contract SLA systems
- advanced privacy / data-loss subrules
- major changes to customer AI routing

The safest approach is to preserve as much of the original gameplay skeleton as possible and sell the total conversion through coherent remapping plus selective extensions.

## 27. Risks and mitigations

### Risk: Theme becomes a shallow reskin

**Mitigation:** Ensure every major loop element - staff, rooms, events, progression, and terminology - is reinterpreted as IT work, not just renamed.

### Risk: Too much realism kills the humor

**Mitigation:** Favor absurd but recognizable problems over dry enterprise simulation.

### Risk: Too many new systems dilute the original loop

**Mitigation:** Add only systems that reinforce flow, bottlenecks, and expansion.

### Risk: Device problems are visually unclear

**Mitigation:** Design issue families with strong silhouettes, effects, and room associations.

## 28. Definition of success

The mod succeeds if players can say:

- "This absolutely feels like running a ridiculous IT repair business."
- "I can read my workflow at a glance."
- "Every new room solves one problem and creates a new one."
- "The humor supports the systems instead of distracting from them."
- "It still feels like the same style of management game, just in a new industry."

## 29. Final summary

*Terminal Triage* should be a full-theme reinterpretation of CorsixTH where human illness becomes device failure, treatment becomes troubleshooting and repair, and hospital administration becomes IT service management. Its strength is not realism; its strength is translating the original game's elegant queue-and-bottleneck design into a fresh comedic business fantasy that players can understand immediately and expand for hours.
