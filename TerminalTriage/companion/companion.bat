@echo off
:: Terminal Triage Companion App launcher
:: Kills any existing server on port 3747, then starts a fresh one.

cd /d "%~dp0"

where node >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js not found. Download it from https://nodejs.org/
    pause
    exit /b 1
)

:: Find and kill any process already listening on port 3747
for /f "tokens=5" %%P in ('netstat -ano ^| findstr ":3747 " ^| findstr "LISTENING"') do (
    echo Stopping existing server ^(PID %%P^)...
    taskkill /PID %%P /F 1>nul 2>nul
)

echo Starting Terminal Triage Companion...
start "" "http://localhost:3747"
node server.js
