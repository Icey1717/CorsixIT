--[[ Terminal Triage - English string overrides
  This language file inherits from CorsixTH English and overrides all hospital
  terminology with IT-repair equivalents. It is loaded automatically because
  the mod's Lua\languages\ folder is scanned by Strings:init().

  To activate: set  language = [[Terminal Triage English]]  in config.txt

  Implementation note (Phase 1):
    Add string overrides below as each section is re-themed.
    Preserve internal IDs throughout - only player-visible strings change.
    See docs\it-total-conversion-technical-plan.md sections 4.1 and 4.3.
--]]

Font("cp437")
Language("Terminal Triage English", "Terminal Triage English", "tt", "ttr")
Inherit("English", 0)
IsArabicNumerals(true)

-- ============================================================
-- Phase 1 string overrides go here
-- ============================================================
-- Example:
--   staff_class.nurse = "Technician"
--   staff_class.doctor = "Engineer"
--   staff_class.handyman = "Facilities Tech"
--   staff_class.receptionist = "Service Desk Agent"
