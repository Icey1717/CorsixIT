<#
.SYNOPSIS
  Runs the Terminal Triage simulation test suite and exits non-zero on failure.

.DESCRIPTION
  Two test tiers are run in sequence:

  Tier 1 – Lua unit tests (always runnable, no display required)
    Runs the busted spec suite under TerminalTriage/Luatest/, which includes
    unit tests for every assertion condition in simulation_scenario.lua.

  Tier 2 – Full engine integration test (requires a real or virtual display)
    Launches CorsixTH with --headless-test pointing at simulation_scenario.lua.
    SDL_AUDIODRIVER=dummy suppresses audio errors.
    NOTE: SDL_VIDEODRIVER=dummy cannot be used until CorsixIT-5kv is resolved
    (SDL_WINDOW_OPENGL is passed unconditionally in th_gfx_sdl.cpp).
    On CI, use Xvfb (Linux) or a virtual display; on Windows, a real display
    or RDP session is required.

.PARAMETER SkipIntegration
  When set, only the Lua unit tests are run (Tier 1).  Useful for CI
  environments that have no display available.

.PARAMETER CorsixTHExe
  Path to CorsixTH.exe.  Defaults to the local build output.

.EXAMPLE
  .\scripts\run_simulation_test.ps1
  .\scripts\run_simulation_test.ps1 -SkipIntegration
#>

[CmdletBinding()]
param(
    [switch]$SkipIntegration,
    [string]$CorsixTHExe = "$PSScriptRoot\..\build\win-x64-rel\CorsixTH\RelWithDebInfo\CorsixTH.exe"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot   = Resolve-Path "$PSScriptRoot\.."
$modDir     = Join-Path $repoRoot "TerminalTriage"
$luatestDir = Join-Path $modDir   "Luatest"

# ---------------------------------------------------------------------------
# Helper: print a coloured section header
# ---------------------------------------------------------------------------
function Write-Header([string]$msg) {
    Write-Host ""
    Write-Host "=" * 72 -ForegroundColor Cyan
    Write-Host "  $msg" -ForegroundColor Cyan
    Write-Host "=" * 72 -ForegroundColor Cyan
}

# ---------------------------------------------------------------------------
# Tier 1 – busted unit tests
# ---------------------------------------------------------------------------
Write-Header "Tier 1: Lua unit tests (busted)"

$bustedExe = "$env:APPDATA\luarocks\bin\busted"
if (-not (Test-Path $bustedExe)) {
    Write-Error "busted not found at '$bustedExe'. Install with: luarocks install busted"
    exit 1
}

Push-Location $luatestDir
try {
    & lua $bustedExe 2>&1
    $luaTier1Exit = $LASTEXITCODE
} finally {
    Pop-Location
}

if ($luaTier1Exit -ne 0) {
    Write-Host ""
    Write-Host "FAIL: Lua unit tests reported failures (exit code $luaTier1Exit)." -ForegroundColor Red
    exit $luaTier1Exit
}
Write-Host ""
Write-Host "PASS: Lua unit tests passed." -ForegroundColor Green

# ---------------------------------------------------------------------------
# Tier 2 – full engine integration test
# ---------------------------------------------------------------------------
if ($SkipIntegration) {
    Write-Host ""
    Write-Host "Skipping Tier 2 (engine integration test) as requested." -ForegroundColor Yellow
    exit 0
}

Write-Header "Tier 2: Engine integration test (simulation_scenario.lua)"

if (-not (Test-Path $CorsixTHExe)) {
    Write-Host "WARNING: CorsixTH.exe not found at '$CorsixTHExe'." -ForegroundColor Yellow
    Write-Host "         Build the project first, or pass -CorsixTHExe <path>." -ForegroundColor Yellow
    Write-Host "         Skipping Tier 2." -ForegroundColor Yellow
    exit 0
}

$scenarioScript = Join-Path $modDir "Lua\tests\simulation_scenario.lua"
$interpreterLua = Join-Path $repoRoot "CorsixTH\CorsixTH.lua"

$env:SDL_AUDIODRIVER = "dummy"
# SDL_VIDEODRIVER=dummy cannot be set until CorsixIT-5kv is fixed.
# Uncomment the line below once SDL_WINDOW_OPENGL is conditionally skipped:
# $env:SDL_VIDEODRIVER = "dummy"

Write-Host "Launching: $CorsixTHExe --headless-test=<scenario>"
& $CorsixTHExe `
    "--interpreter=$interpreterLua" `
    "--lua-dir=$modDir\Lua" `
    "--config-file=$modDir\config.txt" `
    "--campaign=terminal_triage" `
    "--headless-test=$scenarioScript"

$engineExit = $LASTEXITCODE

if ($engineExit -ne 0) {
    Write-Host ""
    Write-Host "FAIL: Engine integration test exited with code $engineExit." -ForegroundColor Red
    exit $engineExit
}

Write-Host ""
Write-Host "PASS: Engine integration test passed." -ForegroundColor Green
exit 0
