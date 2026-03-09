@echo off
REM Terminal Triage headless test runner for Windows
REM
REM Usage:  test_runner.bat [path\to\test_script.lua]
REM
REM When called without arguments, runs headless_tests\smoke.lua.
REM SDL_VIDEODRIVER=dummy and SDL_AUDIODRIVER=dummy cause SDL to operate
REM without a real display or audio device — safe for CI environments.
REM
REM Set CORSIXTH_EXE if the default build path is wrong for your machine.

set CORSIXTH_EXE=G:\repos\CorsixIT\build\win-x64-rel\CorsixTH\RelWithDebInfo\CorsixTH.exe
set MOD_DIR=%~dp0

if "%~1"=="" (
    set TEST_SCRIPT=%MOD_DIR%headless_tests\smoke.lua
) else (
    set TEST_SCRIPT=%~1
)

set SDL_VIDEODRIVER=dummy
set SDL_AUDIODRIVER=dummy

"%CORSIXTH_EXE%" ^
    --interpreter="G:\repos\CorsixIT\CorsixTH\CorsixTH.lua" ^
    --lua-dir="%MOD_DIR%Lua" ^
    --config-file="%MOD_DIR%config.txt" ^
    --campaign=terminal_triage ^
    --headless-test="%TEST_SCRIPT%"
