@echo off
echo ========================================
echo   BPS Cleaning System - Dev Server
echo ========================================
echo.
echo Starting Laravel Server and Ngrok Tunnel...
echo.

REM Start Laravel in new window
start "Laravel Server" cmd /k "cd /d %~dp0 && artisan-serve.bat"

REM Wait 3 seconds for Laravel to start
timeout /t 3 /nobreak >nul

REM Start Ngrok in new window
start "Ngrok Tunnel" cmd /k "cd /d %~dp0 && ngrok-serve.bat"

echo.
echo ========================================
echo   Both servers started!
echo ========================================
echo.
echo Laravel Server: http://localhost:8000
echo Ngrok Dashboard: http://localhost:4040
echo.
echo Check Ngrok window for public URL!
echo.
pause