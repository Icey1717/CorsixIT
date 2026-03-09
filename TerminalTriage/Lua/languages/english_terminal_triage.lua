-- Terminal Triage - English string overrides
-- This language file inherits from CorsixTH English and overrides all hospital
-- terminology with IT-repair equivalents. It is loaded automatically because
-- the mod's Lua/languages/ folder is scanned by Strings:init().
--
-- To activate: set  language = "Terminal Triage English"  in config.txt
--
-- Preservation note: internal IDs are never changed - only player-visible
-- string values are overridden here. This file covers Phase 2 of the total
-- conversion: the text-first re-theme. All sections follow the key structure
-- documented in CorsixTH/Lua/languages/original_strings.lua.

Font("cp437")
Language("Terminal Triage English", "Terminal Triage English", "tt", "ttr")
Inherit("English", 0)
IsArabicNumerals(true)

-- ============================================================
-- SECTION 1: Staff labels
-- ============================================================

staff_class.nurse         = "Bench Technician"
staff_class.doctor        = "Technician"
staff_class.handyman      = "Facilities Tech"
staff_class.receptionist  = "Service Desk Coord."
staff_class.surgeon       = "Hardware Engineer"

-- Titles displayed in the dynamic info bar and staff windows
staff_title.receptionist  = "Service Desk Coord."
staff_title.general       = "General Tech"
staff_title.nurse         = "Bench Tech"
staff_title.junior        = "Junior Tech"
staff_title.doctor        = "Technician"
staff_title.surgeon       = "Hardware Engineer"
staff_title.psychiatrist  = "Support Specialist"
staff_title.consultant    = "Senior Technician"
staff_title.researcher    = "R&D Specialist"

-- ============================================================
-- SECTION 2: Room names
-- ============================================================

rooms_short.reception         = "Service Counter"
rooms_short.gps_office        = "Triage Desk"
rooms_short.psychiatric       = "Customer Support"
rooms_short.ward              = "Bulk Repair Bay"
rooms_short.operating_theatre = "Clean Room"
rooms_short.pharmacy          = "Quick Fix Counter"
rooms_short.cardiogram        = "Hardware Monitor"
rooms_short.scanner           = "Malware Scanner"
rooms_short.ultrascan         = "Deep Scan Suite"
rooms_short.blood_machine     = "Storage Test Bench"
rooms_short.x_ray             = "Thermal Imaging"
rooms_short.inflation         = "Battery Repair Bay"
rooms_short.dna_fixer         = "Circuit Board Lab"
rooms_short.hair_restoration  = "Refurb Studio"
rooms_short.tongue_clinic     = "Audio & Comms Lab"
rooms_short.fracture_clinic   = "Screen Repair Shop"
rooms_short.training_room     = "Training Center"
rooms_short.electrolysis      = "Data Recovery Suite"
rooms_short.jelly_vat         = "Network Test Lab"
rooms_short.staffroom         = "Break Room"
rooms_short.general_diag      = "Diagnostic Lab"
rooms_short.research_room     = "R&D Lab"
rooms_short.toilets           = "Restrooms"
rooms_short.decontamination   = "Malware Containment"
rooms_short.destroyed         = "Destroyed"
rooms_short.corridor_objects  = "Corridor"

rooms_long.gps_office        = "Triage Desk"
rooms_long.psychiatric       = "Customer Support Lab"
rooms_long.ward              = "Bulk Repair Bay"
rooms_long.operating_theatre = "Clean Room Workshop"
rooms_long.pharmacy          = "Quick Fix Counter"
rooms_long.cardiogram        = "Hardware Monitor Room"
rooms_long.scanner           = "Malware Scanner"
rooms_long.ultrascan         = "Deep Scan Suite"
rooms_long.blood_machine     = "Storage Test Bench"
rooms_long.x_ray             = "Thermal Imaging Bay"
rooms_long.inflation         = "Battery Repair Bay"
rooms_long.dna_fixer         = "Circuit Board Lab"
rooms_long.hair_restoration  = "Refurbishment Studio"
rooms_long.tongue_clinic     = "Audio & Comms Lab"
rooms_long.fracture_clinic   = "Screen Repair Workshop"
rooms_long.training_room     = "Training Center"
rooms_long.electrolysis      = "Data Recovery Suite"
rooms_long.jelly_vat         = "Network Test Lab"
rooms_long.staffroom         = "Break Room"
rooms_long.general_diag      = "Diagnostic Laboratory"
rooms_long.research_room     = "R&D Laboratory"
rooms_long.toilets           = "Restrooms"
rooms_long.decontamination   = "Malware Containment Lab"
rooms_long.general           = "General Area"
rooms_long.emergency         = "Surge Job Bay"
rooms_long.corridors         = "Corridors"

-- ============================================================
-- SECTION 3: Room categories
-- ============================================================

room_classes.diagnosis  = "Diagnostics"
room_classes.treatment  = "Repair"
room_classes.clinics    = "Service Labs"
room_classes.facilities = "Facilities"

-- ============================================================
-- SECTION 4: Device issues (diseases)
-- Internal IDs are unchanged; only player-visible text is replaced.
-- Each issue maps to the original disease mechanic and treatment room.
-- ============================================================

diseases.general_practice.name = "General Query"

-- bloaty_head: treated in the inflation room (Battery Repair Bay)
diseases.bloaty_head.name     = "Battery Balloon"
diseases.bloaty_head.cause    = "Cheap fast-charging protocols have caused the lithium cells to expand beyond containment."
diseases.bloaty_head.symptoms = "The battery has physically deformed the device chassis. The device is warm to the touch and mildly explosive."
diseases.bloaty_head.cure     = "Requires careful battery replacement in the Battery Repair Bay. Do not puncture."

-- hairyitis: treated in hair_restoration (Refurb Studio)
diseases.hairyitis.name     = "Cable Nesting"
diseases.hairyitis.cause    = "Years of cable accumulation with zero management. Chargers, USB hubs, and peripherals have formed a self-sustaining ecosystem."
diseases.hairyitis.symptoms = "Customer arrives trailing seventeen cables of unknown purpose. Several are tangled. Two appear to be load-bearing."
diseases.hairyitis.cure     = "Untangle and identify all cables in the Refurbishment Studio. Minimum three technicians and rubber gloves recommended."

-- king_complex: treated in psychiatry (Customer Support Lab)
diseases.king_complex.name     = "Admin Complex"
diseases.king_complex.cause    = "Customer discovered they had administrator access. They used it immediately and comprehensively."
diseases.king_complex.symptoms = "Registry is a creative writing project. Security settings are disabled. System theme is now Dragon Fire."
diseases.king_complex.cure     = "Restore all settings to sane defaults in the Customer Support Lab. Manage customer expectations firmly but kindly."

-- invisibility: treated in dna_fixer (Circuit Board Lab)
diseases.invisibility.name     = "Wi-Fi Stage Fright"
diseases.invisibility.cause    = "The device is connected but refuses to appear on any network or device list when observed."
diseases.invisibility.symptoms = "Pings are unanswered. Shared drives are inaccessible. The device becomes slightly smug when unobserved."
diseases.invisibility.cure     = "Requires driver and network stack reset in the Circuit Board Lab. Do not make eye contact with the device."

-- serious_radiation: treated in decontamination (Malware Containment Lab)
diseases.serious_radiation.name     = "Thermal Meltdown"
diseases.serious_radiation.cause    = "Fan vents blocked by debris. Thermal paste last applied during a previous decade. CPU believes it is a barbecue grill."
diseases.serious_radiation.symptoms = "Device surface can cook eggs. Fan sounds like a turbine. Performance is measured in instructions per cooling cycle."
diseases.serious_radiation.cure     = "Clean vents, replace thermal paste, and test cooling system in the Malware Containment Lab."

-- slack_tongue: treated in tongue_clinic (Audio & Comms Lab)
diseases.slack_tongue.name     = "Notification Storm"
diseases.slack_tongue.cause    = "Every installed application has maximum notification privileges. A total of sixty-four apps are competing for attention."
diseases.slack_tongue.symptoms = "Screen is never idle. Alerts appear in layers. Device makes sound every 0.4 seconds on average."
diseases.slack_tongue.cure     = "Disable all unnecessary notifications in the Audio & Comms Lab. Customer will object. Proceed anyway."

-- alien_dna: treated in dna_fixer (Circuit Board Lab)
diseases.alien_dna.name     = "Driver Amnesia"
diseases.alien_dna.cause    = "A failed update wiped driver signatures. Device no longer recognizes its own keyboard, trackpad, or display adapter."
diseases.alien_dna.symptoms = "Mouse is optional. Keyboard is aspirational. The device is having a full identity crisis."
diseases.alien_dna.cure     = "Reinstall all drivers from scratch in the Circuit Board Lab. Keep spare peripherals nearby."

-- fractured_bones: treated in fracture_clinic (Screen Repair Workshop)
diseases.fractured_bones.name     = "Screen Splatter"
diseases.fractured_bones.cause    = "Physical impact, typically involving a bag, a car door, or overambitious pocket storage."
diseases.fractured_bones.symptoms = "Display presents a modern art piece in one corner. Touch response is interpretive. Spiders have moved in."
diseases.fractured_bones.cure     = "Complete screen replacement in the Screen Repair Workshop. Do not vacuum the shards with good equipment."

-- baldness: treated in hair_restoration (Refurb Studio)
diseases.baldness.name     = "Desktop Archaeology"
diseases.baldness.cause    = "Files have been accumulating on the desktop since the device was new. No folder has ever been created. The Recycle Bin is completely full."
diseases.baldness.symptoms = "Desktop icons require geological mapping to navigate. Boot time is now measured in geological epochs."
diseases.baldness.cure     = "Systematic file organization in the Refurbishment Studio. Archiving is mandatory. Patience is mandatory."

-- discrete_itching: treated in pharmacy (Quick Fix Counter) or general diag
diseases.discrete_itching.name     = "Ransomwear"
diseases.discrete_itching.cause    = "A fashionable phishing attachment has encrypted the device's files. The malware has a logo and a dedicated support line."
diseases.discrete_itching.symptoms = "Files are inaccessible. Wallpaper is now a payment demand. The deadline is tomorrow and counting down."
diseases.discrete_itching.cure     = "Isolate and remove the ransomware in the Malware Containment Lab. Pay nothing. Back up everything."

-- jellyitis: treated in jelly_vat (Network Test Lab)
diseases.jellyitis.name     = "Tab Tsunami"
diseases.jellyitis.cause    = "Customer is a tab hoarder. Current count: 847 open tabs. Browser memory consumption is comfortably illegal."
diseases.jellyitis.symptoms = "System is 94% browser. Scroll bar in the tab strip requires a microscope. Fan is at maximum to manage the shame."
diseases.jellyitis.cure     = "Perform tab triage and memory cleanup in the Network Test Lab. The customer will resist. Stay firm."

-- sleeping_illness: treated via ward (Bulk Repair Bay)
diseases.sleeping_illness.name     = "Update Loop Fever"
diseases.sleeping_illness.cause    = "A patch began installing three days ago. The device has not left the progress bar screen since."
diseases.sleeping_illness.symptoms = "Device perpetually shows: Installing update 1 of 1 (94%). Restarting makes it worse."
diseases.sleeping_illness.cure     = "Boot recovery and patch rollback required. Administer in the Diagnostic Laboratory with Bench Tech support."

-- transparency: treated in dna_fixer (Circuit Board Lab)
diseases.transparency.name     = "Privacy Spill"
diseases.transparency.cause    = "Device has been quietly sending data to somewhere. Nobody is sure where. The device may not know either."
diseases.transparency.symptoms = "Outbound traffic is suspiciously high. Installed apps list is creative. Microphone appears to have opinions."
diseases.transparency.cure     = "Full audit and cleanup in the Malware Containment Lab. Factory reset may be the kindest option."

-- uncommon_cold: treated in pharmacy (Quick Fix Counter)
diseases.uncommon_cold.name     = "Registry Rot"
diseases.uncommon_cold.cause    = "Years of software churn have left the registry as a layered archaeological site of uninstalled programs and duplicate keys."
diseases.uncommon_cold.symptoms = "Performance degrades visibly over time. Every boot takes a few seconds longer than the last."
diseases.uncommon_cold.cure     = "Registry cleanup and optimization at the Quick Fix Counter. Warn the customer this may not be dramatic."

-- broken_wind: general treatment
diseases.broken_wind.name     = "Backup Mirage"
diseases.broken_wind.cause    = "Customer insists backups exist. Investigation reveals they do not and never have. The cloud is mentioned with total confidence."
diseases.broken_wind.symptoms = "No backup system in place. Last known file state: 18 months ago. Customer is entirely serene about this."
diseases.broken_wind.cure     = "Set up an actual backup system. Review with customer in the Diagnostic Laboratory. Limit I told you so to three instances."

-- spare_ribs: treated in operating theatre (Clean Room Workshop)
diseases.spare_ribs.name     = "Cloud Confusion"
diseases.spare_ribs.cause    = "Files are distributed across seven cloud services with overlapping sync permissions. Nobody knows which version is canonical."
diseases.spare_ribs.symptoms = "Opening a file requires knowing which service has today's version. Some files exist in all services. Some exist in none."
diseases.spare_ribs.cure     = "Cloud audit and consolidation in the Clean Room Workshop. One cloud. One truth. Strong coffee required."

-- kidney_beans: general treatment
diseases.kidney_beans.name     = "Data Corruption"
diseases.kidney_beans.cause    = "Storage media has developed bad sectors. The filesystem and the data have reached a creative disagreement."
diseases.kidney_beans.symptoms = "Files open incorrectly, partially, or with decorative artifacts. Some refuse to exist. CHKDSK is pessimistic."
diseases.kidney_beans.cure     = "Storage test and selective recovery in the Storage Test Bench. Not all files can be saved. Manage expectations."

-- broken_heart: treated in fracture_clinic (Screen Repair Workshop)
diseases.broken_heart.name     = "Port Collapse"
diseases.broken_heart.cause    = "The charging port has been inserted at an angle approximately ten thousand times. It is done."
diseases.broken_heart.symptoms = "Device charges only when the cable is held at a very specific angle, in a specific room, by a specific person."
diseases.broken_heart.cure     = "Port replacement in the Screen Repair Workshop. Warn the customer this was entirely preventable."

-- ruptured_nodules: general diag
diseases.ruptured_nodules.name     = "Settings Labyrinth"
diseases.ruptured_nodules.cause    = "Customer has been methodically enabling every non-default option they could find. Over many months."
diseases.ruptured_nodules.symptoms = "System behaves unpredictably in ways that cannot be reproduced. Dark mode is on. Dark mode is also somehow off."
diseases.ruptured_nodules.cure     = "Settings audit and restore in the Customer Support Lab. Document everything before resetting."

-- tv_personalities: treated in psychiatry (Customer Support Lab)
diseases.tv_personalities.name     = "Printer Diplomacy Failure"
diseases.tv_personalities.cause    = "The customer and their printer have been locked in a mutual vendetta since a firmware update last year."
diseases.tv_personalities.symptoms = "Printer is online. Printer insists it is offline. Print jobs queue successfully and disappear spiritually."
diseases.tv_personalities.cure     = "Mediate the conflict in the Customer Support Lab. If necessary, introduce a replacement printer and say nothing."

-- infectious_laughter: treated in psychiatry (Customer Support Lab)
diseases.infectious_laughter.name     = "Latency Gremlins"
diseases.infectious_laughter.cause    = "Network performance has collapsed across all applications. Ping values suggest the server is on another planet."
diseases.infectious_laughter.symptoms = "Streaming buffers perpetually. Multiplayer is chaos. Video calls are abstract impressionist paintings."
diseases.infectious_laughter.cure     = "Network diagnosis and optimization in the Network Test Lab. ISP may be at fault. ISP will deny it."

-- corrugated_ankles: treated in fracture_clinic (Screen Repair Workshop)
diseases.corrugated_ankles.name     = "Button Mashing Syndrome"
diseases.corrugated_ankles.cause    = "Input hardware has been treated as a stress relief device. Keys are sticky, worn, or aspirationally placed."
diseases.corrugated_ankles.symptoms = "Several keys have achieved transcendence. The spacebar is philosophical. The keyboard logs keystrokes from memory."
diseases.corrugated_ankles.cure     = "Full keyboard replacement in the Screen Repair Workshop. Counsel customer on the merits of mechanical switches."

-- chronic_nosehair: treated in hair_restoration (Refurb Studio)
diseases.chronic_nosehair.name     = "Password Panic"
diseases.chronic_nosehair.cause    = "Customer uses three email addresses, two authenticators, and a sticky note. They have lost access to all of them."
diseases.chronic_nosehair.symptoms = "Account access requires a recovery email that requires a phone number recycled by a telecoms company two years ago."
diseases.chronic_nosehair.cure     = "Full account recovery in the Refurbishment Studio. Install a password manager. Do not let them write the master password on a sticky note."

-- third_degree_sideburns: treated in hair_restoration (Refurb Studio)
diseases.third_degree_sideburns.name     = "Sync Drift"
diseases.third_degree_sideburns.cause    = "Work exists on three devices in three different versions. Sync was disabled to save battery three years ago."
diseases.third_degree_sideburns.symptoms = "Customer does not know which device is authoritative. All devices are wrong in different ways."
diseases.third_degree_sideburns.cure     = "Synchronization audit in the Refurbishment Studio. One source of truth established. Many apologies required."

-- fake_blood: general treatment
diseases.fake_blood.name     = "Phishing Hangover"
diseases.fake_blood.cause    = "Customer clicked on a link because the email looked official. It had a logo. It said URGENT in bold."
diseases.fake_blood.symptoms = "Account credentials have been changed remotely. Inbox is subscribed to seventeen newsletters. Someone has ordered a printer."
diseases.fake_blood.cure     = "Account recovery and security hardening in the Malware Containment Lab. Security awareness training is not optional."

-- gastric_ejections: general treatment
diseases.gastric_ejections.name     = "Folder Catastrophe"
diseases.gastric_ejections.cause    = "Files have been moved, renamed, and sorted in a system that made sense to the customer at the time."
diseases.gastric_ejections.symptoms = "No file can be found by name, location, or logical deduction. The Documents folder contains only shortcuts."
diseases.gastric_ejections.cure     = "File recovery and restructuring in the Diagnostic Laboratory. Prepare for surprises in unexpected locations."

-- the_squits: treated via ward (Bulk Repair Bay)
diseases.the_squits.name     = "Crash Loop"
diseases.the_squits.cause    = "System enters a crash, recovery, re-crash cycle it cannot escape. The OS is extremely committed to failing."
diseases.the_squits.symptoms = "Blue screen. Reboot. Blue screen. Reboot. Philosophical crisis. The last restore point is six months old."
diseases.the_squits.cure     = "Boot recovery and OS repair in the Diagnostic Laboratory. Keep installation media nearby."

-- iron_lungs: treated in operating theatre (Clean Room Workshop)
diseases.iron_lungs.name     = "Overclocking Incident"
diseases.iron_lungs.cause    = "Customer read an article. They applied the advice enthusiastically and without thermal preparation."
diseases.iron_lungs.symptoms = "CPU runs at peak thermal limit continuously. Fan sounds like a jet at takeoff. Performance is both the best and worst it will ever be."
diseases.iron_lungs.cure     = "Reset overclocking settings and replace the thermal solution in the Clean Room Workshop."

-- sweaty_palms: treated in general_diag (Diagnostic Lab)
diseases.sweaty_palms.name     = "Static Discharge Syndrome"
diseases.sweaty_palms.cause    = "Component handled without ESD precautions. Static electricity has expressed strong opinions about the RAM slots."
diseases.sweaty_palms.symptoms = "Random crashes at inexplicable moments. Memory tests fail in creative patterns. Device smells faintly of ozone."
diseases.sweaty_palms.cure     = "Full component re-seating and diagnostics in the Clean Room Workshop. Wrist strap is not optional."

-- heaped_piles: treated in operating theatre (Clean Room Workshop)
diseases.heaped_piles.name     = "Disk Overflow"
diseases.heaped_piles.cause    = "Storage capacity has been at 99% for an indeterminate period. The system is compressing the swap file out of desperation."
diseases.heaped_piles.symptoms = "Every operation requires negotiation with the storage subsystem. Temp files have colonized the entire C drive."
diseases.heaped_piles.cure     = "Disk cleanup and archiving in the Refurbishment Studio. Remind customer that free tier cloud storage has limits."

-- gut_rot: treated in pharmacy (Quick Fix Counter)
diseases.gut_rot.name     = "Software Rot"
diseases.gut_rot.cause    = "Accumulated updates, abandoned trials, legacy dependencies, and forgotten startup items have formed a sedimentary layer."
diseases.gut_rot.symptoms = "Boot time is optimistic. Application launch is aspirational. The task manager is a horror novel."
diseases.gut_rot.cure     = "Full software audit and cleanup at the Quick Fix Counter. Some things cannot be uninstalled and must be accepted."

-- golf_stones: treated in operating theatre (Clean Room Workshop)
diseases.golf_stones.name     = "Hard Drive Calcification"
diseases.golf_stones.cause    = "A spinning-disk hard drive has been bumped and shocked for many years. Sectors are retiring quietly."
diseases.golf_stones.symptoms = "Load times are measured in geological time. The HDD makes a clicking sound the customer describes as completely normal."
diseases.golf_stones.cure     = "Clone to SSD and retire the original drive in the Storage Test Bench. A moment of silence for lost performance."

-- unexpected_swelling: treated in general_diag (Diagnostic Lab)
diseases.unexpected_swelling.name     = "RAM Bloat"
diseases.unexpected_swelling.cause    = "A process is consuming memory without permission, accountability, or a clear objective."
diseases.unexpected_swelling.symptoms = "Available memory is always zero. Task manager lists nothing useful. System is using swap aggressively and emotionally."
diseases.unexpected_swelling.cure     = "Identify and terminate the offending process at the Quick Fix Counter. Upgrade RAM if negotiation fails."

-- Diagnostic procedure display names
diseases.diag_scanner.name       = "Malware Scan"
diseases.diag_blood_machine.name = "Storage Diagnostics"
diseases.diag_cardiogram.name    = "Hardware Monitor"
diseases.diag_x_ray.name         = "Thermal Imaging"
diseases.diag_ultrascan.name     = "Deep Scan"
diseases.diag_general_diag.name  = "General Diagnostics"
diseases.diag_ward.name          = "Bulk Repair Assessment"
diseases.diag_psych.name         = "Customer Interview"
diseases.autopsy.name            = "Post-Mortem Analysis"

-- ============================================================
-- SECTION 5: Adviser messages
-- ============================================================

adviser.staff_advice.need_doctors         = "You need more Technicians. Devices are queueing with nobody to assess them."
adviser.staff_advice.too_many_doctors     = "You have more Technicians than current workload requires. Consider redirecting some to R&D or training."
adviser.staff_advice.need_nurses          = "You need more Bench Technicians. Some service rooms are running understaffed."
adviser.staff_advice.too_many_nurses      = "You have more Bench Technicians than you can usefully employ right now."

adviser.staff_place_advice.only_researchers           = "Only R&D Specialists can work in the R&D Lab."
adviser.staff_place_advice.only_surgeons              = "Only Hardware Engineers can work in the Clean Room Workshop."
adviser.staff_place_advice.only_psychiatrists         = "Only Support Specialists can work in the Customer Support Lab."
adviser.staff_place_advice.only_nurses_in_room        = "Only Bench Technicians can work in %s."
adviser.staff_place_advice.doctors_cannot_work_in_room = "Technicians cannot work in %s."
adviser.staff_place_advice.nurses_cannot_work_in_room  = "Bench Technicians cannot work in %s."
adviser.staff_place_advice.only_doctors_in_room        = "Only Technicians can work in %s."
adviser.staff_place_advice.receptionists_only_at_desk  = "Service Desk Coordinators can only be placed at the Service Counter."

adviser.room_requirements.psychiatry_need_psychiatrist  = "The Customer Support Lab requires a Support Specialist to operate."
adviser.room_requirements.pharmacy_need_nurse           = "The Quick Fix Counter requires a Bench Technician to operate."
adviser.room_requirements.training_room_need_consultant = "The Training Center requires a Senior Technician to operate."
adviser.room_requirements.research_room_need_researcher = "The R&D Lab requires an R&D Specialist to operate."
adviser.room_requirements.op_need_two_surgeons          = "The Clean Room Workshop requires two Hardware Engineers to operate."
adviser.room_requirements.op_need_another_surgeon       = "The Clean Room Workshop needs another Hardware Engineer on duty."
adviser.room_requirements.op_need_ward                  = "The Clean Room Workshop requires a Bulk Repair Bay staffed with a Bench Technician."
adviser.room_requirements.ward_need_nurse               = "The Bulk Repair Bay requires a Bench Technician to operate."
adviser.room_requirements.gps_office_need_doctor        = "The Triage Desk requires a Technician to operate."
adviser.room_requirements.reception_need_receptionist   = "The Service Counter requires a Service Desk Coordinator to operate."

adviser.surgery_requirements.need_surgeons_ward_op = "To perform advanced hardware repair you need two Hardware Engineers and a staffed Bulk Repair Bay."
adviser.surgery_requirements.need_surgeon_ward     = "Advanced hardware repair requires a Bulk Repair Bay. Build one to support the Clean Room."

adviser.warnings.money_low                  = "Your funds are running low. Watch expenditure carefully."
adviser.warnings.money_very_low_take_loan   = "Funds are critically low. Consider a business loan before operations are disrupted."
adviser.warnings.bankruptcy_imminent        = "Financial collapse is imminent. This business will close if immediate action is not taken."
adviser.warnings.machines_falling_apart     = "Your equipment is in poor condition. Assign Facilities Techs to maintenance before breakdowns cause backlogs."
adviser.warnings.no_patients_last_month     = "No customers arrived last month. Check that your Service Counter is staffed and your business is reachable."
adviser.warnings.nobody_cured_last_month    = "No devices were successfully repaired last month. Review your staffing and room coverage."
adviser.warnings.queues_too_long            = "Queues are becoming unacceptable. Customers are losing patience. Expand your capacity."
adviser.warnings.patient_stuck             = "A customer appears to be stuck. They may need assistance finding their next destination."
adviser.warnings.patients_unhappy          = "Customers are unhappy. Address comfort, wait times, and information clarity."
adviser.warnings.patient_leaving           = "A customer is leaving due to poor service. They will not be recommending you."
adviser.warnings.patients_leaving          = "Customers are leaving. Your Brand Trust is at risk."
adviser.warnings.patients_really_thirsty   = "Customers are very thirsty. Install vending machines or a refreshments station urgently."
adviser.warnings.patients_annoyed          = "Customers are annoyed. Address their concerns before they leave negative reviews."
adviser.warnings.patients_thirsty          = "Customers are thirsty. Consider adding a vending machine or refreshments area."
adviser.warnings.patients_thirsty2         = "Some customers are looking for drinks. A vending machine would help."
adviser.warnings.patients_very_thirsty     = "Customers are very thirsty. This is affecting their satisfaction."
adviser.warnings.patients_too_hot          = "Customers are overheating. Adjust your climate controls."
adviser.warnings.patients_getting_hot      = "Customers are getting too warm. Consider adjusting the heating."
adviser.warnings.patients_very_cold        = "Customers are very cold. Increase the heating or check your climate system."
adviser.warnings.people_freezing           = "People are freezing. Fix the heating immediately."
adviser.warnings.staff_overworked          = "Staff are overworked. Hire additional personnel or redistribute tasks."
adviser.warnings.staff_tired              = "Staff are tired. Ensure break room access and reasonable schedules."
adviser.warnings.staff_too_hot            = "Staff are overheating. Adjust the heating controls."
adviser.warnings.staff_very_cold          = "Staff are very cold. Address the heating system."
adviser.warnings.staff_unhappy            = "Staff morale is low. Check salaries, rest availability, and working conditions."
adviser.warnings.staff_unhappy2           = "Staff are unhappy with conditions. Investigate before you face resignations."
adviser.warnings.doctor_crazy_overwork    = "A Technician is severely overworked and approaching burnout. Intervene before they resign."
adviser.warnings.nurses_tired             = "Your Bench Technicians are exhausted. Ensure they can access the Break Room."
adviser.warnings.doctors_tired            = "Your Technicians are exhausted. Ensure they can access the Break Room."
adviser.warnings.handymen_tired           = "Your Facilities Techs are exhausted. Ensure they can access the Break Room."
adviser.warnings.receptionists_tired      = "Your Service Desk Coordinators are exhausted. Ensure they can access the Break Room."
adviser.warnings.nurses_tired2            = "Bench Technicians are still not resting. Check Break Room access."
adviser.warnings.doctors_tired2           = "Technicians are still not resting. Check Break Room access."
adviser.warnings.handymen_tired2          = "Facilities Techs are still not resting. Check Break Room access."
adviser.warnings.receptionists_tired2     = "Service Desk Coordinators are still not resting. Check Break Room access."
adviser.warnings.need_toilets             = "Customers need restrooms. Build them before the situation becomes unpleasant."
adviser.warnings.build_toilets            = "Consider building restrooms. Customers and staff both need them."
adviser.warnings.build_toilet_now         = "Build restrooms immediately. This is urgent."
adviser.warnings.more_toilets             = "You need more restrooms. Demand is exceeding current capacity."
adviser.warnings.people_did_it_on_the_floor = "Someone had an accident. Build more restrooms immediately."
adviser.warnings.need_staffroom           = "Staff need a break room. Build one before morale collapses."
adviser.warnings.build_staffroom          = "Build a Break Room. Staff cannot work indefinitely without rest."
adviser.warnings.many_killed              = "%d devices have been lost this month. This is a serious Brand Trust problem."
adviser.warnings.plants_thirsty           = "Some plants need watering. Assign a Facilities Tech."
adviser.warnings.too_many_plants          = "You have a great many plants. Perhaps redirect some Facilities Tech attention to maintenance."
adviser.warnings.charges_too_high         = "Your service charges are too high. Customers are choosing not to proceed with repairs."
adviser.warnings.charges_too_low          = "Your service charges are very low. You may be significantly undervaluing your work."
adviser.warnings.machine_severely_damaged  = "Critical: %s is severely damaged and may fail entirely. Repair it immediately."
adviser.warnings.machinery_slightly_damaged = "Some equipment has taken minor damage. Schedule maintenance soon."
adviser.warnings.machinery_damaged         = "Equipment is damaged. Assign a Facilities Tech before performance is affected."
adviser.warnings.machinery_damaged2        = "Equipment damage is increasing. Get a Facilities Tech on this now."
adviser.warnings.machinery_very_damaged    = "Equipment is very damaged and close to failure. Immediate maintenance required."
adviser.warnings.machinery_deteriorating   = "Equipment is deteriorating. Prevent a full breakdown by maintaining it regularly."
adviser.warnings.queue_too_long_send_doctor = "The queue for %s is too long. Send another Technician to assist."
adviser.warnings.queue_too_long_at_reception = "The queue at the Service Counter is too long. Consider adding a second coordinator or desk."
adviser.warnings.reception_bottleneck      = "The Service Counter is a bottleneck. Customers are waiting too long to register."
adviser.warnings.epidemic_getting_serious   = "The malware outbreak is spreading. Take action now."
adviser.warnings.deal_with_epidemic_now     = "The malware outbreak must be dealt with immediately. Delay is no longer an option."
adviser.warnings.many_epidemics             = "Multiple malware outbreaks are active. Containment is critical."
adviser.warnings.hospital_is_rubbish        = "Customers are very unhappy with this facility. Significant improvements are urgently needed."
adviser.warnings.more_benches               = "Customers are having to stand in the waiting area. Add more seating."
adviser.warnings.people_have_to_stand       = "Too many customers are standing. Install more seating in waiting areas."
adviser.warnings.too_much_litter            = "There is too much e-waste in the corridors. Assign Facilities Techs to clean it up."
adviser.warnings.litter_everywhere          = "E-waste is everywhere. Customers are noticing. This reflects poorly on the business."
adviser.warnings.litter_catastrophy         = "E-waste has reached catastrophic levels. The facility looks completely abandoned."
adviser.warnings.some_litter                = "There is some e-waste in the corridor. Keep on top of it."
adviser.warnings.place_plants_to_keep_people = "Adding plants improves the atmosphere and keeps customers calm. Consider planting more."
adviser.warnings.place_plants2              = "More plants would improve the waiting experience."
adviser.warnings.place_plants3              = "Customers would appreciate a greener environment."
adviser.warnings.place_plants4              = "Some greenery would go a long way to improving customer mood."
adviser.warnings.desperate_need_for_watering = "Plants are dying. Have a Facilities Tech water them urgently."
adviser.warnings.change_priorities_to_plants = "Consider adjusting Facilities Tech priorities to include plant care."
adviser.warnings.plants_dying               = "Plants are wilting. They need water."
adviser.warnings.reduce_staff_rest_threshold = "Consider reducing the rest threshold so staff take breaks before they are completely exhausted."
adviser.warnings.financial_trouble          = "Serious financial difficulty: you have £%d left before the level is lost."
adviser.warnings.finanical_trouble2         = "Financial warning: £%d remaining before failure conditions are met."
adviser.warnings.financial_trouble3         = "Critical: only £%d separates you from bankruptcy."
adviser.warnings.cash_low_consider_loan     = "Cash is low. A business loan might help bridge the gap."
adviser.warnings.pay_back_loan              = "Your loan balance is high. Try to repay it before interest becomes a burden."

adviser.praise.many_plants         = "Your facility has an excellent plant arrangement. Customers appreciate the atmosphere."
adviser.praise.plants_are_well     = "The plants are looking healthy. A nice touch."
adviser.praise.plants_thriving     = "Plants are thriving throughout the facility. Customers love it."
adviser.praise.many_benches        = "There is plenty of seating in the waiting areas. Customers appreciate the comfort."
adviser.praise.plenty_of_benches   = "Good seating coverage. Waiting customers are comfortable."
adviser.praise.few_have_to_stand   = "Very few customers are left standing. Well managed."
adviser.praise.patients_cured      = "%d devices successfully repaired this month. Your reputation for quality is growing."

adviser.information.epidemic                = "Warning: a malware outbreak has been detected. Isolate affected devices immediately."
adviser.information.emergency               = "Surge job incoming! A group of customers with urgent tickets requires immediate attention."
adviser.information.promotion_to_doctor     = "One of your Technicians has been promoted. Their diagnostic and repair skills have improved substantially."
adviser.information.promotion_to_specialist = "A Technician has qualified as a %s. They can now be assigned to specialist service rooms."
adviser.information.promotion_to_consultant = "A Technician has reached Senior Technician status. They can now run the Training Center."
adviser.information.first_death             = "A customer's device has been lost. This will not go unnoticed and Brand Trust has suffered."
adviser.information.first_cure              = "Your first successful repair is complete. The customer has left satisfied. This is the beginning."
adviser.information.place_windows           = "Adding windows to rooms improves the atmosphere and staff wellbeing."
adviser.information.larger_rooms            = "Larger rooms can accommodate more equipment and multiple staff, improving throughput."
adviser.information.extra_items             = "Adding extra furniture and equipment to rooms improves staff performance and efficiency."
adviser.information.patient_abducted        = "A customer's device has been taken by persons unknown. This is highly unusual."
adviser.information.patient_leaving_too_expensive = "A customer is leaving because your prices are too high for their budget."
adviser.information.pay_rise                = "Staff are requesting pay reviews. Consider offering raises to retain good technicians."
adviser.information.handyman_adjust         = "You can adjust your Facilities Techs' work priorities using their management window."
adviser.information.fax_received            = "You have received a message. Check your communications panel for details."
adviser.information.vip_arrived             = "%s has arrived to inspect your facility. Make a good impression."
adviser.information.epidemic_health_inspector = "A compliance inspector has arrived, potentially in response to the malware outbreak."
adviser.information.initial_general_advice.research_now_available  = "Research is now available. Assign R&D Specialists to the R&D Lab to unlock new services and equipment."
adviser.information.initial_general_advice.research_symbol          = "This symbol indicates a room where research can unlock improvements."
adviser.information.initial_general_advice.surgeon_symbol           = "This symbol indicates that a Hardware Engineer is required to operate this room."
adviser.information.initial_general_advice.psychiatric_symbol       = "This symbol indicates that a Support Specialist is required to operate this room."
adviser.information.initial_general_advice.rats_have_arrived        = "Cable Gremlins have appeared in your facility! Have your Facilities Techs clear them before they cause disruption."
adviser.information.initial_general_advice.autopsy_available        = "Post-mortem analysis is now available. It helps understand device failures but may affect Brand Trust."
adviser.information.initial_general_advice.first_epidemic           = "A malware outbreak has started. You can declare it publicly or attempt quiet containment. Choose carefully."
adviser.information.initial_general_advice.first_VIP                = "An auditor is visiting. Their assessment will affect your Brand Trust and may bring financial rewards or penalties."
adviser.information.initial_general_advice.taking_your_staff        = "A competitor is trying to poach your staff. Consider reviewing salaries to retain key people."
adviser.information.initial_general_advice.machine_needs_repair     = "A piece of equipment needs maintenance. Assign a Facilities Tech before it breaks down completely."
adviser.information.initial_general_advice.epidemic_spreading       = "The malware outbreak is spreading. Containment measures should be escalated immediately."
adviser.information.initial_general_advice.increase_heating         = "The facility is too cold. Increase the heating setting on the climate panel."
adviser.information.initial_general_advice.place_radiators          = "Consider placing additional radiators to improve comfort in colder areas."
adviser.information.initial_general_advice.decrease_heating         = "The facility is too hot. Reduce the heating setting on the climate panel."
adviser.information.initial_general_advice.first_patients_thirsty   = "Customers are thirsty. Install a vending machine or refreshments area to keep them comfortable."
adviser.information.initial_general_advice.first_emergency          = "A surge job has arrived. Accepting it earns a bonus. Refusing has a small reputational cost."

adviser.earthquake.alert   = "Warning: infrastructure disruption detected. Secure equipment and prepare for a service interruption."
adviser.earthquake.damage  = "Infrastructure event complete. %d machines damaged and %d staff affected."
adviser.earthquake.ended   = "Disruption resolved. Severity rated %d. Inspect and repair before resuming full operations."

adviser.boiler_issue.maximum_heat = "Climate system is at maximum heat output. Equipment is at risk of overheating. Reduce temperature immediately."
adviser.boiler_issue.minimum_heat = "Heating has failed entirely. Staff and customers are at serious risk. Address this immediately."
adviser.boiler_issue.resolved     = "Climate control system has been restored. Temperature is returning to normal."

adviser.vomit_wave.started = "A technical incident is causing disruptions throughout the facility. Maintain calm."
adviser.vomit_wave.ended   = "The incident has been resolved. Normal operations can resume."

adviser.goals.win.money      = "You need £%d more to hit the financial target for this contract."
adviser.goals.win.reputation = "Your Brand Trust needs to reach %d to complete this contract."
adviser.goals.win.value      = "Your business value needs to reach %d to complete this contract."
adviser.goals.win.cure       = "You need to successfully repair %d more devices to complete this contract."
adviser.goals.lose.kill      = "Lose %d more devices and this contract will be failed. Avoid this."

adviser.level_progress.nearly_won              = "You are close to completing all objectives for this contract."
adviser.level_progress.three_quarters_won      = "You are three quarters of the way to completing this contract. Keep going."
adviser.level_progress.halfway_won             = "You are halfway to completing this contract."
adviser.level_progress.nearly_lost             = "You are dangerously close to failing this contract. Urgent action required."
adviser.level_progress.three_quarters_lost     = "Three quarters of the way to failure. Significant changes are needed."
adviser.level_progress.halfway_lost            = "Halfway to failure. Review your operations carefully."
adviser.level_progress.another_patient_cured   = "Another device successfully repaired!"
adviser.level_progress.another_patient_killed  = "Another device has been lost. Brand Trust has taken a hit."
adviser.level_progress.financial_criteria_met  = "Financial target met: your balance has reached £%d."
adviser.level_progress.cured_enough_patients   = "You have successfully repaired enough devices to meet the repair target."
adviser.level_progress.dont_kill_more_patients = "Do not lose any more devices. Every loss damages Brand Trust."
adviser.level_progress.reputation_good_enough  = "Your Brand Trust has reached the required level of %d."
adviser.level_progress.improve_reputation      = "Improve your Brand Trust by %d to complete this contract."
adviser.level_progress.hospital_value_enough   = "Your business value has reached the required threshold of %d."
adviser.level_progress.close_to_win_increase_value = "Your business value is close to target. Keep expanding and investing."

adviser.research.new_machine_researched   = "Research complete: new equipment is now available: %s."
adviser.research.new_drug_researched      = "New repair protocol developed for: %s. Success rates will improve."
adviser.research.drug_improved            = "Repair protocol improved for: %s. Results will be more reliable."
adviser.research.machine_improved         = "Equipment upgrade researched: %s is now more effective."
adviser.research.new_available            = "New capability now available: %s."
adviser.research.drug_fully_researched    = "Full repair methodology established for: %s. This issue can now be resolved with high confidence."
adviser.research.autopsy_discovered_rep_loss = "A post-mortem analysis was conducted. Brand Trust has decreased. Customers prefer not to hear this news."

adviser.competitors.hospital_opened = "A new competitor has opened for business: %s. Monitor your market share."
adviser.competitors.land_purchased  = "%s has purchased nearby land. Expansion appears likely."
adviser.competitors.staff_poached   = "A competitor has poached one of your staff. Review salaries to retain key people."

adviser.epidemic.serious_warning  = "The malware outbreak is becoming serious. Take containment action immediately."
adviser.epidemic.hurry_up         = "Time is running out to contain the malware outbreak. Act now."
adviser.epidemic.multiple_epidemies = "Multiple malware strains are spreading simultaneously. Prioritize containment."

-- ============================================================
-- SECTION 6: Fax and notification messages
-- ============================================================

fax.emergency.choices.accept = "Accept Surge Job"
fax.emergency.choices.refuse = "Decline"
fax.emergency.location       = "Location: %s"
fax.emergency.num_disease    = "There are %d customers with %s who require urgent attention."
fax.emergency.cure_possible_drug_name_efficiency = "Your team can handle this. Repair protocol: %s (confidence: %d%%)"
fax.emergency.cure_possible             = "Your facility can handle this surge job."
fax.emergency.cure_not_possible_build   = "You will need to build a %s"
fax.emergency.cure_not_possible_build_and_employ = "You will need to build a %s and employ a %s"
fax.emergency.cure_not_possible_employ  = "You will need to employ a %s"
fax.emergency.cure_not_possible         = "Your facility cannot currently handle this type of issue."
fax.emergency.bonus                     = "Completion bonus: £%d"
fax.emergency.locations = {
  "Local business district",
  "Nearby school",
  "University campus",
  "Corporate park",
  "Shopping center",
  "Government offices",
  "Gaming cafe",
  "Student accommodation",
  "Home users",
}

fax.emergency_result.close_text    = "Close"
fax.emergency_result.earned_money  = "Surge job complete. Revenue earned: £%d"
fax.emergency_result.saved_people  = "Devices resolved: %d"

fax.disease_discovered_patient_choice.choices.send_home = "Send customer home"
fax.disease_discovered_patient_choice.choices.wait      = "Continue service"
fax.disease_discovered_patient_choice.choices.research  = "Begin research"
fax.disease_discovered_patient_choice.need_to_build_and_employ = "You need to build a %s and employ a %s to handle this."
fax.disease_discovered_patient_choice.need_to_build            = "You need to build a %s to handle this issue."
fax.disease_discovered_patient_choice.need_to_employ           = "You need to employ a %s to handle this issue."
fax.disease_discovered_patient_choice.can_not_cure             = "Your facility cannot currently resolve this type of issue."
fax.disease_discovered_patient_choice.disease_name             = "Issue identified: %s"
fax.disease_discovered_patient_choice.what_to_do_question      = "What would you like to do with this customer?"
fax.disease_discovered_patient_choice.guessed_percentage_name  = "Likely issue (%d%%): %s"

fax.disease_discovered.close_text             = "Close"
fax.disease_discovered.can_cure               = "Your facility is equipped to handle this issue."
fax.disease_discovered.need_to_build_and_employ = "You need to build a %s and employ a %s."
fax.disease_discovered.need_to_build          = "You need to build a %s."
fax.disease_discovered.need_to_employ         = "You need to employ a %s."
fax.disease_discovered.discovered_name        = "New issue type identified: %s"

fax.epidemic.choices.declare  = "Declare outbreak publicly"
fax.epidemic.choices.cover_up = "Contain quietly"
fax.epidemic.disease_name             = "Malware strain: %s"
fax.epidemic.declare_explanation_fine = "Declaring the outbreak will result in a fine but limits reputational damage from discovery later."
fax.epidemic.cover_up_explanation_1   = "Attempting quiet containment avoids immediate penalties."
fax.epidemic.cover_up_explanation_2   = "If the cover-up fails, the consequences will be severe."

fax.epidemic_result.close_text            = "Close"
fax.epidemic_result.failed.part_1_name    = "Outbreak containment FAILED: %s"
fax.epidemic_result.failed.part_2         = "The malware spread before it could be contained. Brand Trust and finances have suffered."
fax.epidemic_result.succeeded.part_1_name = "Outbreak contained: %s"
fax.epidemic_result.succeeded.part_2      = "The malware has been successfully removed. Operations can return to normal."
fax.epidemic_result.compensation_amount   = "Customer compensation: £%d"
fax.epidemic_result.fine_amount           = "Regulatory fine: £%d"
fax.epidemic_result.rep_loss_fine_amount  = "Brand Trust penalty: %d (fine: £%d)"
fax.epidemic_result.hospital_evacuated    = "Facility was evacuated due to the severity of the outbreak."

fax.vip_visit_query.choices.invite = "Invite inspector"
fax.vip_visit_query.choices.refuse = "Decline inspection"
fax.vip_visit_query.vip_name       = "Inspector: %s"

fax.vip_visit_result.close_text        = "Close"
fax.vip_visit_result.telegram          = "Audit report received."
fax.vip_visit_result.vip_remarked_name = "%s remarked:"
fax.vip_visit_result.cash_grant        = "Financial award: £%d"
fax.vip_visit_result.rep_boost         = "Brand Trust gained: %d"
fax.vip_visit_result.rep_loss          = "Brand Trust lost: %d"
fax.vip_visit_result.remarks = {
  [1]  = "An outstanding operation. Efficient, well-organized, and genuinely customer-focused.",
  [2]  = "Excellent. Staff morale is high and turnaround times are impressive.",
  [3]  = "Very good. Minor improvements could optimize throughput further.",
  [4]  = "Good performance overall. Some areas would benefit from attention.",
  [5]  = "Satisfactory. Plenty of room for improvement.",
  [6]  = "Below average. Several operational issues require prompt attention.",
  [7]  = "Poor performance. Customer satisfaction metrics are measurably low.",
  [8]  = "Concerning. Equipment maintenance is overdue and queues are excessive.",
  [9]  = "Unacceptable. This facility is not meeting basic service standards.",
  [10] = "Alarming. Multiple critical failures were observed during this visit.",
  [11] = "Severe. Customers are being failed at every stage of the process.",
  [12] = "Catastrophic. Brand Trust is in terminal decline.",
  [13] = "This facility should be closed pending a full compliance review.",
  [14] = "I have reported this facility to the relevant regulatory authority.",
  [15] = "I have never witnessed anything like this. I need a moment.",
}

fax.diagnosis_failed.choices.send_home   = "Send device home unresolved"
fax.diagnosis_failed.choices.take_chance = "Attempt repair anyway"
fax.diagnosis_failed.choices.wait        = "Continue diagnostics"
fax.diagnosis_failed.situation           = "Your team has been unable to fully diagnose the issue with this device."
fax.diagnosis_failed.what_to_do_question = "How would you like to proceed?"
fax.diagnosis_failed.partial_diagnosis_percentage_name = "Probable issue (%d%%): %s"

-- ============================================================
-- SECTION 7: Transactions
-- ============================================================

transactions.wages                = "Staff Wages"
transactions.hire_staff           = "Hiring Costs"
transactions.buy_object           = "Equipment Purchase"
transactions.build_room           = "Room Construction"
transactions.cure                 = "Repair Revenue"
transactions.buy_land             = "Land Purchase"
transactions.treat_colon          = "Service:"
transactions.final_treat_colon    = "Final Service:"
transactions.cure_colon           = "Repair:"
transactions.deposit              = "Deposit"
transactions.advance_colon        = "Advance:"
transactions.research             = "R&D Costs"
transactions.drinks               = "Vending Revenue"
transactions.cheat                = "Cheat Mode Bonus"
transactions.heating              = "Utility Costs"
transactions.insurance_colon      = "Insurance:"
transactions.bank_loan            = "Business Loan"
transactions.loan_repayment       = "Loan Repayment"
transactions.loan_interest        = "Loan Interest"
transactions.research_bonus       = "R&D Bonus"
transactions.drug_cost            = "Parts & Materials"
transactions.overdraft            = "Overdraft Fee"
transactions.severance            = "Redundancy Payment"
transactions.general_bonus        = "Performance Bonus"
transactions.sell_object          = "Equipment Sale"
transactions.personal_bonus       = "Personal Bonus"
transactions.emergency_bonus      = "Surge Job Bonus"
transactions.vaccination          = "Malware Removal"
transactions.epidemy_coverup_fine = "Outbreak Cover-Up Fine"
transactions.compensation         = "Customer Compensation"
transactions.vip_award            = "Auditor Award"
transactions.epidemy_fine         = "Outbreak Disclosure Fine"
transactions.eoy_bonus_penalty    = "End-of-Year Assessment"
transactions.eoy_trophy_bonus     = "End-of-Year Award"
transactions.machine_replacement  = "Equipment Replacement"

-- ============================================================
-- SECTION 8: Graphs
-- ============================================================

graphs.money_in   = "Revenue"
graphs.money_out  = "Costs"
graphs.wages      = "Wages"
graphs.balance    = "Balance"
graphs.visitors   = "Customers"
graphs.cures      = "Repairs"
graphs.deaths     = "Device Losses"
graphs.reputation = "Brand Trust"

-- ============================================================
-- SECTION 9: Research categories
-- ============================================================

research.categories.cure           = "Repair Procedures"
research.categories.diagnosis      = "Diagnostic Methods"
research.categories.drugs          = "Parts & Materials"
research.categories.improvements   = "Equipment Upgrades"
research.categories.specialisation = "Specializations"

-- ============================================================
-- SECTION 10: Casebook
-- ============================================================

casebook.reputation        = "Brand Trust"
casebook.treatment_charge  = "Service Charge"
casebook.earned_money      = "Revenue Earned"
casebook.cured             = "Repaired"
casebook.deaths            = "Devices Lost"
casebook.sent_home         = "Sent Away"
casebook.research          = "Under Research"
casebook.cure              = "Repair Method"

casebook.cure_desc.build_room          = "Build a %s to handle this issue type."
casebook.cure_desc.build_ward          = "Build a Bulk Repair Bay to support this repair pipeline."
casebook.cure_desc.hire_doctors        = "Hire Technicians who can diagnose and repair this issue."
casebook.cure_desc.hire_surgeons       = "Hire Hardware Engineers for advanced component-level work."
casebook.cure_desc.hire_psychiatrists  = "Hire Support Specialists for user-error and configuration issues."
casebook.cure_desc.hire_nurses         = "Hire Bench Technicians to staff this service room."
casebook.cure_desc.no_cure_known       = "No repair method is currently known. R&D may discover one."
casebook.cure_desc.cure_known          = "Repair method known. Ensure the required room and staff are available."
casebook.cure_desc.improve_cure        = "Current repair method can be improved through further R&D investment."

-- ============================================================
-- SECTION 11: Dynamic info bar
-- ============================================================

dynamic_info.patient.actions.dying                       = "Device in critical condition"
dynamic_info.patient.actions.awaiting_decision           = "Awaiting approval"
dynamic_info.patient.actions.queueing_for                = "Queuing for %s"
dynamic_info.patient.actions.on_my_way_to                = "Heading to %s"
dynamic_info.patient.actions.cured                       = "Repair complete"
dynamic_info.patient.actions.fed_up                      = "Leaving: out of patience"
dynamic_info.patient.actions.sent_home                   = "Released: sent home"
dynamic_info.patient.actions.sent_to_other_hospital      = "Referred to another service"
dynamic_info.patient.actions.no_diagnoses_available      = "No diagnostic room available"
dynamic_info.patient.actions.no_treatment_available      = "No repair room available"
dynamic_info.patient.actions.waiting_for_diagnosis_rooms = "Waiting for a diagnostic room"
dynamic_info.patient.actions.waiting_for_treatment_rooms = "Waiting for a repair room"
dynamic_info.patient.actions.prices_too_high             = "Left: prices too high"
dynamic_info.patient.actions.epidemic_sent_home          = "Released: malware isolation"
dynamic_info.patient.actions.epidemic_contagious         = "Quarantined: malware risk"
dynamic_info.patient.diagnosed                           = "Issue: %s"
dynamic_info.patient.guessed_diagnosis                   = "Suspected: %s"
dynamic_info.patient.emergency                           = "Surge job: %s"

dynamic_info.vip            = "Auditor"
dynamic_info.health_inspector = "Compliance Inspector"

dynamic_info.staff.psychiatrist_abbrev     = "Supp."
dynamic_info.staff.actions.waiting_for_patient = "Waiting for customer"
dynamic_info.staff.actions.wandering           = "Wandering"
dynamic_info.staff.actions.going_to_repair     = "Repairing %s"
dynamic_info.staff.tiredness                   = "Fatigue: %d%%"

dynamic_info.object.strength    = "Capacity: %d"
dynamic_info.object.times_used  = "Times used: %d"
dynamic_info.object.queue_size  = "Queue: %d"
dynamic_info.object.queue_expected = "Expected: %d"

-- ============================================================
-- SECTION 12: Miscellaneous UI strings
-- ============================================================

misc.hospital_open = "Business Open"

-- ============================================================
-- SECTION 13: Bank manager
-- ============================================================

bank_manager.hospital_value = "Business Value"

-- ============================================================
-- SECTION 14: Tooltip overrides
-- ============================================================

-- Toolbar
tooltip.toolbar.reputation = "Toggle Brand Trust"

-- Status window
tooltip.status.close       = "Close status window"
tooltip.status.reputation  = "Your Brand Trust should not be less than %d. Currently it is %d"
tooltip.status.balance     = "Your bank balance should not be less than %d. Currently it is %d"

-- Graphs
tooltip.graphs.reputation  = "Toggle Brand Trust graph"
tooltip.graphs.cures       = "Toggle repairs graph"
tooltip.graphs.deaths      = "Toggle device losses graph"
tooltip.graphs.visitors    = "Toggle customers graph"

-- Staff list pagination (corrected in english.lua base, kept here for safety)
tooltip.staff_list.next_person = "Show next page"
tooltip.staff_list.prev_person = "Show previous page"

-- Hire staff window
tooltip.hire_staff_window.doctors       = "Hire Technicians"
tooltip.hire_staff_window.nurses        = "Hire Bench Technicians"
tooltip.hire_staff_window.handymen      = "Hire Facilities Techs"
tooltip.hire_staff_window.receptionists = "Hire Service Desk Coordinators"
tooltip.hire_staff_window.surgeon       = "Has Hardware Engineer specialization"
tooltip.hire_staff_window.psychiatrist  = "Has Support Specialist specialization"
tooltip.hire_staff_window.researcher    = "Has R&D Specialist qualification"

-- Room build tooltips
tooltip.rooms.gps_office        = "A Technician uses the Triage Desk to assess customers and route them to the correct service room"
tooltip.rooms.psychiatry        = "A Support Specialist uses the Customer Support Lab to resolve user-error, configuration, and settings issues"
tooltip.rooms.ward              = "The Bulk Repair Bay handles batches of standardized repairs. Requires a Bench Technician"
tooltip.rooms.operating_theatre = "A Hardware Engineer uses the Clean Room Workshop for advanced component-level repairs"
tooltip.rooms.pharmacy          = "A Bench Technician uses the Quick Fix Counter for simple, high-volume fixes"
tooltip.rooms.cardiogram        = "The Hardware Monitor raises diagnostic certainty before committing to a repair route"
tooltip.rooms.scanner           = "The Malware Scanner identifies and removes software threats"
tooltip.rooms.ultrascan         = "The Deep Scan Suite provides high-confidence issue identification"
tooltip.rooms.blood_machine     = "The Storage Test Bench diagnoses hard drive and memory issues"
tooltip.rooms.x_ray             = "Thermal Imaging identifies heat-related hardware faults"
tooltip.rooms.inflation         = "The Battery Repair Bay handles battery swelling, replacement, and calibration"
tooltip.rooms.dna_fixer         = "The Circuit Board Lab handles component-level diagnostics and driver recovery"
tooltip.rooms.hair_restoration  = "The Refurbishment Studio handles cable management, cleaning, and cosmetic restoration"
tooltip.rooms.tongue_clinic     = "The Audio & Comms Lab handles speaker, microphone, and connectivity issues"
tooltip.rooms.fracture_clinic   = "The Screen Repair Workshop handles cracked displays and damaged input hardware"
tooltip.rooms.training_room     = "A Senior Technician uses the Training Center to upskill staff"
tooltip.rooms.electrolysis      = "The Data Recovery Suite recovers data from damaged or failing storage media"
tooltip.rooms.jelly_vat         = "The Network Test Lab diagnoses and resolves network and connectivity problems"
tooltip.rooms.staffroom         = "The Break Room restores staff energy. Build one before morale collapses"
tooltip.rooms.general_diag      = "The Diagnostic Laboratory performs general troubleshooting across all issue types"
tooltip.rooms.research_room     = "R&D Specialists use the R&D Laboratory to unlock new services and equipment upgrades"
tooltip.rooms.toilets           = "Restrooms are a basic requirement for customers and staff"
tooltip.rooms.decontamination   = "The Malware Containment Lab isolates and removes active malware outbreaks"

-- Object tooltips (key items)
tooltip.objects.reception_desk  = "Service Counter: requires a Service Desk Coordinator to register incoming customers"
tooltip.objects.computer        = "Computer workstation for diagnostics and administration"
tooltip.objects.litter          = "Litter: Left on the floor by a customer who could not find a bin to throw it in."
tooltip.objects.rathole         = "Home of a rat family that found your repair shop dirty enough to live here."

-- Staff window
tooltip.staff_window.face        = "This person's profile - click to open management screen"
tooltip.staff_window.center_view = "Left click to zoom to staff, right click to cycle through staff members"

-- Bank manager
tooltip.bank_manager.hospital_value = "Current estimated business value"

-- Watch icons
tooltip.watch.hospital_opening = "Business is open"
tooltip.watch.emergency        = "Surge job in progress"
tooltip.watch.epidemic         = "Malware outbreak active"

-- Research tooltips
tooltip.research.cure_dec           = "Decrease Repair Procedures research percentage"
tooltip.research.cure_inc           = "Increase Repair Procedures research percentage"
tooltip.research.diagnosis_dec      = "Decrease Diagnostic Methods research percentage"
tooltip.research.diagnosis_inc      = "Increase Diagnostic Methods research percentage"
tooltip.research.drugs_dec          = "Decrease Parts & Materials research percentage"
tooltip.research.improvements_dec   = "Decrease Equipment Upgrades research percentage"
tooltip.research.improvements_inc   = "Increase Equipment Upgrades research percentage"
tooltip.research.specialisation_dec = "Decrease Specializations research percentage"
tooltip.research.specialisation_inc = "Increase Specializations research percentage"

-- Casebook tooltips
tooltip.casebook.cure_requirement.hire_staff = "You need to employ staff to handle this repair procedure"
tooltip.casebook.cure_type.unknown           = "You do not yet know how to fix this issue"

-- ============================================================
-- SECTION 15: Confirmations
-- ============================================================

confirmation.restart_level = "Are you sure you want to restart this contract?"

-- ============================================================
-- SECTION 16: VIP / auditor names
-- ============================================================

vip_names = {
  health_minister = "Chief Technology Officer",
  "Alex Hartwell",         -- franchise inspector
  "Jordan Sykes",          -- corporate account lead
  "Morgan Chen",           -- tech journalist
  "Casey Park",            -- insurance underwriter
  "Reece Thornton",        -- local authority IT officer
  "Sam Okafor",            -- enterprise procurement lead
  "Taylor Vance",          -- compliance auditor
  "Devon Marsh",           -- startup founder
  "Avery Kowalski",        -- regional franchise director
  "Quinn Faber",           -- IT security consultant
}

-- ============================================================
-- SECTION 17: Level-lost screen
-- ============================================================

information.custom_game = "Welcome to Terminal Triage. Good luck with this contract!"

information.level_lost = {
  "Shut Down! You failed the contract. Better prep next time.",
  "The reason you lost:",
  reputation         = "Your Brand Trust fell below %d.",
  balance            = "Your bank balance fell below %d.",
  percentage_killed  = "You wrote off more than %d percent of customer devices.",
  cheat              = "Hope you didn't click the Lose Level button by accident!",
  staff_happiness    = "Your average staff satisfaction fell below %d%%.",
  patient_happiness  = "Your average customer satisfaction fell below %d%%.",
}

-- ============================================================
-- SECTION 18: Room descriptions
-- ============================================================

room_descriptions.inflation[2] = "Devices with swollen or failing batteries are brought to the Battery Repair Bay. A Bench Technician will safely discharge, replace, and recalibrate the battery cell to restore correct capacity.//"

-- ============================================================
-- SECTION 19: Tip of the Day
-- ============================================================

totd_window.tips = {
  "Every repair shop needs a service counter and a Triage Desk to get going. After that, it depends on what kind of devices are brought in. A Quick Fix Counter is always a good investment.",
  "Machines such as the Battery Repair Bay need maintenance. Employ a Facilities Tech or two to keep equipment running, or you will risk breakdowns mid-repair.",
  "After a while, your staff will get tired. Be sure to build a Break Room so they can recharge.",
  "Place enough radiators to keep your staff and customers comfortable, or they will become unhappy. Use the site map to find any cold spots on the floor.",
  "A senior technician's skill level greatly influences the quality and speed of initial diagnosis. Place your best technician at the Triage Desk to reduce unnecessary diagnostic detours.",
  "Juniors and technicians can improve their skills by learning from a senior consultant in the Training Center. If the consultant holds a specialization (Hardware Engineer, Support Specialist, or R&D Specialist), they will also pass on that knowledge.",
  "Did you try to enter the European emergency number (112) into the fax machine? Make sure your sound is on!",
  "You can adjust some settings such as the resolution and language in the options window found both in the main menu and in-game.",
  "You selected a language other than English, but there is English text all over the place? Help us by translating missing texts into your language!",
  "The CorsixTH team is looking for reinforcements! Are you interested in coding, translating, or creating graphics? Contact us at our Discord Server, Sub-Reddit, or Matrix Server. Links are on our website (CorsixTH.com).",
  "If you find a bug, please report it at our bugtracker: th-issues.corsix.org",
  "Each contract has certain requirements to fulfill before you can move on to the next one. Check the status window to see your progression towards the contract goals.",
  "If you want to edit or remove an existing room, you can do so with the edit room button found in the bottom toolbar.",
  "In a crowd of waiting customers, you can quickly find out which ones are waiting for a particular room by hovering over that room with your mouse cursor.",
  "Click on the door of a room to see its queue. You can do useful fine tuning here, such as reordering the queue or redirecting a customer to a different room.",
  "Unhappy staff will ask for pay rises frequently. Make sure your staff is working in a comfortable environment to keep that from happening.",
  "Customers will get thirsty while waiting in your shop, especially if the heating is turned up! Place vending machines in strategic positions for some extra income.",
  "You can skip the full diagnostic process for a customer and attempt a repair directly if you have already handled the same issue before. Beware: an incorrect repair may result in the device being written off.",
  "Surge jobs can be a great source of extra income, provided you have enough capacity to handle the incoming devices in time.",
  "Did you know you can assign Facilities Techs to specific zones? Just click the 'All Zones' text in their staff profile to cycle through them!",
}

-- ============================================================
-- SECTION 20: Misc epidemic/outbreak overrides
-- ============================================================

misc.epidemics_off             = "Malware outbreaks are disabled. No new outbreaks will be created."
misc.epidemics_on              = "Malware outbreaks are re-enabled."
misc.epidemic_no_icon_to_toggle = "Unable to show/hide compromised icons - no active outbreaks that are not yet revealed."
misc.epidemic_no_diseases      = "Cannot create malware outbreak - no spreading issues available."
misc.epidemic_no_receptionist  = "Cannot create malware outbreak - no staffed service counter."

-- ============================================================
-- SECTION 21: Dynamic info epidemic overrides
-- ============================================================

dynamic_info.staff.actions.vaccine                      = "Patching a device"
dynamic_info.patient.actions.epidemic_vaccinated        = "Issue neutralised - no longer spreading"
dynamic_info.patient.actions.no_gp_available            = "Waiting for you to build a Triage Desk"

-- ============================================================
-- SECTION 22: PA subtitle announcements
-- ============================================================

subtitles = {
  -- Cheat alerts
  cheat001 = "Business administrator is running unauthorized tools!",
  cheat002 = "Warning! An unsanctioned operator is running the shop!",
  cheat003 = "Compliance alert! Compliance alert!",

  -- Emergency (surge job) announcements — IT device issue names
  emerg001 = "Staff announcement: incoming devices with Disk Overflow.",
  emerg002 = "Staff announcement: devices with Crash Loop are on the way.",
  emerg003 = "Staff announcement: incoming devices with Printer Diplomacy Failure.",
  emerg004 = "Staff announcement: devices with Registry Rot on the way.",
  emerg005 = "Staff announcement: incoming devices with Screen Splatter.",
  emerg006 = "Staff announcement: devices with Wi-Fi Stage Fright arriving.",
  emerg007 = "Staff announcement: incoming devices with Battery Balloon.",
  emerg008 = "Staff announcement: devices with Cable Nesting on the way.",
  emerg009 = "Staff announcement: incoming devices with Admin Complex.",
  emerg010 = "Staff announcement: devices arriving with Thermal Meltdown.",
  emerg011 = "Staff announcement: incoming devices with Notification Storm.",
  emerg012 = "Staff announcement: incoming devices with Desktop Archaeology.",
  emerg013 = "Staff announcement: devices with Ransomwear arriving.",
  emerg014 = "Staff announcement: incoming devices with Tab Tsunami.",
  emerg015 = "Staff announcement: incoming devices with Update Loop Fever.",
  emerg016 = "Staff announcement: devices with Backup Mirage arriving.",
  emerg017 = "Staff announcement: incoming devices with Static Discharge Syndrome.",
  emerg018 = "Staff announcement: incoming devices with RAM Bloat.",
  emerg019 = "Staff announcement: devices with Software Rot arriving.",
  emerg020 = "Staff announcement: incoming devices with Driver Amnesia.",
  emerg021 = "Staff announcement: devices arriving with Data Duplication.",
  emerg022 = "Staff announcement: incoming devices with Privacy Spill.",
  emerg023 = "Staff announcement: devices with Cloud Confusion incoming.",
  emerg024 = "Staff announcement: incoming devices with Data Corruption.",
  emerg025 = "Staff announcement: devices with Port Collapse arriving.",
  emerg026 = "Staff announcement: incoming devices with Settings Labyrinth.",
  emerg027 = "Staff announcement: incoming devices with Latency Gremlins.",
  emerg028 = "Staff announcement: devices with Button Mashing Syndrome on the way.",
  emerg029 = "Staff announcement: incoming devices with Password Panic.",
  emerg030 = "Staff announcement: incoming devices with Sync Drift.",
  emerg031 = "Staff announcement: devices with Phishing Hangover incoming.",
  emerg032 = "Staff announcement: incoming devices with Folder Catastrophe.",
  emerg033 = "Staff announcement: devices arriving with Overclocking Incident.",
  emerg034 = "Staff announcement: incoming devices with Hard Drive Calcification.",

  -- Malware outbreak (epidemic) alerts
  epid001 = "Malware outbreak alert, all staff standby!",
  epid002 = "Staff announcement: malware outbreak warning!",
  epid003 = "Warning, malware outbreak detected!",
  epid004 = "Warning!",
  epid005 = "Malware outbreak resolved, all clear.",
  epid006 = "Malware outbreak now under control.",
  epid007 = "Malware outbreak contained.",
  epid008 = "Malware incident over.",

  -- Machine alarm
  machwarn = "*Equipment Alarm*",

  -- Maintenance (facilities tech calls) — IT room names
  maint004 = "Facilities Tech call to Audio & Comms Lab.",
  maint005 = "Facilities Tech to Thermal Imaging please.",
  maint006 = "Facilities Tech call to Circuit Board Lab.",
  maint007 = "Maintenance required in Refurbishment Studio.",
  maint008 = "Facilities Tech, please service Data Recovery Suite.",
  maint009 = "Maintenance required in Network Test Lab.",
  maint010 = "Facilities Tech call to Hardware Monitor.",
  maint011 = "Facilities Tech, please service Diagnostic Laboratory.",
  maint012 = "Maintenance required in Malware Containment Lab.",
  maint013 = "Facilities Tech, please maintain Battery Repair Bay.",
  maint014 = "Maintenance required in Screen Repair Workshop.",
  maint015 = "Facilities Tech call to Storage Test Bench.",
  maint016 = "Facilities Tech to attend Deep Scan Suite.",

  -- Earthquake warnings (neutral — no hospital terminology)
  quake001 = "Warning! Seismic activity reported.",
  quake002 = "Warning! Seismic event imminent.",
  quake003 = "Attention! Seismic warning.",
  quake004 = "Attention! Seismic event on the way.",

  -- Random PA announcements — IT shop setting
  rand001 = "White courtesy phone.",
  rand002 = "Alex from Networking to the Support Lab please.",
  rand003 = "No food or drink near equipment please.",
  rand005 = "Customers are reminded not to leave devices unattended in the corridors.",
  rand006 = "Malware spreads. Keep your devices patched.",
  rand008 = "Customer message: payment details required.",
  rand009 = "Customer message: purchase orders required.",
  rand010 = "Quiet please, people are working.",
  rand012 = "Customers are asked not to drop devices too much.",
  rand013 = "Warning: This is a warning.",
  rand016 = "Customers leave their devices at their own risk.",
  rand017 = "Frustrated customers are asked to remain as calm as possible.",
  rand018 = "Customers are asked to be patient.",
  rand019 = "Customers are asked to wait quietly.",
  rand021 = "Please do not litter the shop.",
  rand022 = "Dropping litter is against the rules.",
  rand024 = "Customers, please keep your malware to yourself.",
  rand025 = "Customers must have their purchase orders ready.",
  rand026 = "Customers, have your payment details ready.",
  rand027 = "Priority devices to the front of the queue.",
  rand028 = "Please form orderly queues.",
  rand029 = "Look out for other Bullfrog products.",
  rand030 = "No loitering.",
  rand031 = "No littering.",
  rand032 = "No overclocking on premises.",
  rand033 = "Staff members are reminded to rest frequently.",
  rand034 = "Today's special offer: half price cable management.",
  rand035 = "Messrs Burke and Hare to the rear exit please.",
  rand036 = "Please don't feed the vermin, thank you!",
  rand037 = "Customers are kindly reminded to describe their issue clearly, thank you!",
  rand040 = "Litter alert!",
  rand041 = "I'm fed up with announcing, I want to go home.",
  rand044 = "Could people please try not to drop equipment in the corridors.",
  rand045 = "Alex Lecter report to compliance please, Alex Lecter to compliance.",
  rand046 = "Your sound card is working.",

  -- Staff required announcements — IT staff and room names
  reqd001 = "Technician, attend immediately in Hardware Monitor please.",
  reqd002 = "Technician, attend in the Malware Scanner room please.",
  reqd003 = "Technician, attend in Customer Support Lab please.",
  reqd004 = "Bench Technician required in Screen Repair Workshop please.",
  reqd005 = "Technician needed in Audio & Comms Lab.",
  reqd006 = "Technician required in Storage Test Bench room.",
  reqd007 = "Technician wanted in Deep Scan Suite.",
  reqd008 = "Technician required at Triage Desk.",
  reqd009 = "Bench Technician required in Bulk Repair Bay.",
  reqd010 = "Two Hardware Engineers required in Clean Room Workshop.",
  reqd011 = "Another Hardware Engineer required in Clean Room Workshop.",
  reqd012 = "Bench Technician required in Quick Fix Counter.",
  reqd013 = "Technician required in Thermal Imaging.",
  reqd014 = "Technician required in Battery Repair Bay.",
  reqd015 = "Technician required in Circuit Board Lab.",
  reqd016 = "Technician needed in Refurbishment Studio.",
  reqd017 = "Technician required in Training Center.",
  reqd019 = "Technician wanted in Data Recovery Suite.",
  reqd020 = "Technician required in Network Test Lab.",
  reqd021 = "Technician required in Diagnostic Laboratory.",
  reqd023 = "R&D Specialist needed in R&D Laboratory.",
  reqd024 = "Technician required in Malware Containment Lab.",

  -- Staff dismissal announcements — IT staff names
  sack001 = "Technician dismissed.",
  sack002 = "Technician is leaving.",
  sack003 = "Technician on the way out.",
  sack004 = "Bench Technician is leaving.",
  sack005 = "Bench Technician is leaving now.",
  sack006 = "Dismissed Facilities Tech on the way out.",
  sack007 = "Service Desk Coordinator has been asked to leave.",
  sack008 = "Service Desk Coordinator is leaving.",
  sack009 = "Staff member has been poached.",
  sack010 = "Technician has been poached.",

  -- Apology announcements
  sorry001 = "We apologise for the amount of litter.",
  sorry002 = "We apologise for the extreme cold.",
  sorry003 = "We're sorry for the excessive heat.",
  sorry004 = "Apologies to customers, the heating system is malfunctioning.",
  sorry005 = "Spill warning, mind your step.",
  sorry006 = "Maintenance, spill alert in the corridor.",

  -- VIP visit announcements
  vip001 = "Watch out, we've got a VIP in the building.",
  vip002 = "A VIP has entered the building.",
  vip003 = "A VIP is currently visiting.",
  vip004 = "A VIP is touring the building.",
  vip005 = "We have a VIP with us.",
  vip008 = "A corporate auditor is in the building.",
}

