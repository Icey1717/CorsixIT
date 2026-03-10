@echo off
REM Terminal Triage headless test runner for Windows
REM
REM Usage:  test_runner.bat [path\to\test_script.lua]
REM
REM When called without arguments, runs headless_tests\smoke.lua.
REM SDL_AUDIODRIVER=dummy and SDL_VIDEODRIVER=dummy suppress all display/audio
REM requirements.  CorsixIT-5kv is resolved: the C++ renderer skips
REM SDL_WINDOW_OPENGL when SDL_VIDEODRIVER=dummy is detected.
REM
REM Examples:
REM   test_runner.bat                                     (smoke test)
REM   test_runner.bat headless_tests\smoke.lua            (explicit smoke)
REM   test_runner.bat Lua\tests\simulation_scenario.lua   (gameplay scenario)
REM
REM Set CORSIXTH_EXE if the default build path is wrong for your machine.

set CORSIXTH_EXE=G:\repos\CorsixIT\build\win-x64-rel\CorsixTH\RelWithDebInfo\CorsixTH.exe
set MOD_DIR=%~dp0

if "%~1"=="" (
    set TEST_SCRIPT=%MOD_DIR%headless_tests\smoke.lua
) else (
    set TEST_SCRIPT=%~1
)

set SDL_AUDIODRIVER=dummy
set SDL_VIDEODRIVER=dummy

"%CORSIXTH_EXE%" ^
    --interpreter="G:\repos\CorsixIT\CorsixTH\CorsixTH.lua" ^
    --lua-dir="%MOD_DIR%Lua" ^
    --config-file="%MOD_DIR%config.txt" ^
    --campaign=terminal_triage ^
    --headless-test="%TEST_SCRIPT%"
