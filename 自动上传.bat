@echo off
REM Set proxy
set http_proxy=http://127.0.0.1:10808
set https_proxy=http://127.0.0.1:10808
set all_proxy=socks5://127.0.0.1:10808

set HTTP_PROXY=http://127.0.0.1:10808
set HTTPS_PROXY=http://127.0.0.1:10808
set ALL_PROXY=socks5://127.0.0.1:10808

REM Enter Backup folder
cd /d C:\Users\Dawn\Desktop\sh-backups

REM Pull latest changes to avoid conflicts
git pull origin main

REM Add all modified files
git add .

REM Get datetime in format YYYYMMDD_HHMMSS using PowerShell
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set datetime=%%i

REM Commit with datetime
git commit -m "Backup on %datetime%"

REM Force push to main branch (overwrite remote history)
git push -f origin main

REM Return to previous directory
cd ..

echo.
echo Backup Successfully on Github/5lin/sh!
pause
