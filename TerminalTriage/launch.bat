@echo off
REM Terminal Triage launcher for Windows
REM
REM Set CORSIXTH_EXE to the full path of your CorsixTH.exe
REM Example: set CORSIXTH_EXE=C:\Program Files\CorsixTH\CorsixTH.exe
set CORSIXTH_EXE=G:\repos\CorsixIT\build\win-x64-rel\CorsixTH\RelWithDebInfo\CorsixTH.exe

REM Resolve the directory this script lives in
set MOD_DIR=%~dp0

"%CORSIXTH_EXE%" --interpreter="G:\repos\CorsixIT\CorsixTH\CorsixTH.lua" --lua-dir="%MOD_DIR%Lua" --config-file="%MOD_DIR%config.txt"
