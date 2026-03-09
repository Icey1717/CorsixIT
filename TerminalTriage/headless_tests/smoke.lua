--[[ Terminal Triage headless smoke test
  Minimal integration test that verifies the game initialises correctly in
  headless mode and that a campaign level has been loaded.

  Run via:
    test_runner.bat headless_tests\smoke.lua

  The script receives the App instance as its first argument (via vararg).
  It must either return normally (treated as PASS) or call error() / os.exit(1)
  to signal failure.
--]]

local app = ...

-- 1. App must be present and properly initialised
assert(type(app) == "table", "Expected App table, got: " .. type(app))
assert(type(app.config) == "table", "app.config must be a table")
assert(type(app.gfx)    == "table", "app.gfx must be present after init")

-- 2. Language strings must be loaded
assert(_S ~= nil, "Global _S (strings) must be populated after init")

-- 3. A campaign level should be loaded (--campaign=terminal_triage was passed)
if app.world then
  assert(type(app.world) == "table", "app.world must be a table when loaded")
  print("[smoke] World loaded — campaign level is active")

  -- 4. Verify the world has a hospital for the local player
  local hospital = app.world:getLocalPlayerHospital()
  assert(hospital ~= nil, "Local player hospital must exist after level load")
  print("[smoke] Hospital present: OK")
else
  -- It is acceptable for world to be nil if no TH data is available
  -- (e.g. on a CI agent without the Theme Hospital install).
  print("[smoke] No world loaded (no TH data available) — skipping world checks")
end

print("[smoke] PASSED")
