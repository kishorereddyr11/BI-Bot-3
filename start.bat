@echo off
setlocal
title BI Bot
cd /d "%~dp0"

echo.
echo === BI Bot - one-command start ===
echo.

rem ---- 1. Make sure Node.js (v20.19+ / v22.12+) is available ----
where node >nul 2>nul
if errorlevel 1 (
    echo Node.js not found. Installing Node.js LTS with winget...
    where winget >nul 2>nul
    if errorlevel 1 (
        echo.
        echo [ERROR] winget is not available on this computer.
        echo Please install Node.js LTS manually from https://nodejs.org and run start.bat again.
        pause
        exit /b 1
    )
    winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
    rem winget does not refresh PATH for this window, so add the default install folder
    set "PATH=%ProgramFiles%\nodejs;%PATH%"
)

where node >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERROR] Node.js still not found. Close this window, open a new one and run start.bat again.
    pause
    exit /b 1
)

for /f "tokens=1 delims=." %%v in ('node -v') do set "NODE_MAJOR=%%v"
set "NODE_MAJOR=%NODE_MAJOR:v=%"
if %NODE_MAJOR% LSS 20 (
    echo.
    echo [ERROR] Node.js %NODE_MAJOR% is too old. Please install Node.js 20.19 or newer from https://nodejs.org
    pause
    exit /b 1
)
for /f %%v in ('node -v') do echo Using Node.js %%v

rem ---- 2. Install dependencies (only when missing) ----
if not exist "node_modules\.bin\vite.cmd" (
    echo.
    echo Installing dependencies - first run only, this can take a minute...
    call npm install
    if errorlevel 1 (
        echo.
        echo [ERROR] npm install failed. Check your internet connection and try again.
        pause
        exit /b 1
    )
)

rem ---- 3. Start the app and open the browser ----
echo.
echo Starting BI Bot at http://localhost:5173  (press Ctrl+C to stop)
echo.
call npm run dev -- --open

pause
