@echo off
:: Terminal Triage Companion App launcher
:: Starts the local server and opens the browser.

cd /d "%~dp0"

where node >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js not found. Download it from https://nodejs.org/
    pause
    exit /b 1
)

echo Starting Terminal Triage Companion...
start "" "http://localhost:3747"
node server.js
