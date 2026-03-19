@echo off
title HeartSafe Backend Server
echo.
echo ============================================
echo   HeartSafe - Backend Server Startup
echo ============================================
echo.
echo Starting server on port 5000...
echo.

cd /d "%~dp0"
node server.js

pause
