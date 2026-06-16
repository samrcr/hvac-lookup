@echo off
echo Deploying HVAC Lookup...
cd /d "C:\Users\SamHannaford\OneDrive - RCR Infrastructure Limited\Sams apps\HVAC Lookup\hvac-lookup"
git add .
git commit -m "Auto update %date% %time%"
git push
echo Done! Cloudflare will update in ~30 seconds.
pause