
@echo off
echo Deploying HVAC Lookup...
set GIT="C:\Users\SamHannaford\AppData\Local\GitHubDesktop\app-3.5.12\resources\app\git\cmd\git.exe"
cd /d "C:\Users\SamHannaford\OneDrive - RCR Infrastructure Limited\Sams apps\HVAC Lookup\hvac-lookup"
%GIT% add .
%GIT% commit -m "Auto update %date% %time%"
%GIT% push
echo.
echo Done! Cloudflare will update in ~30 seconds.
pause
 