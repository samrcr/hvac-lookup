@echo off
echo Deploying HVAC Lookup...

set REPO=C:\Users\SamHannaford\OneDrive - RCR Infrastructure Limited\Sams apps\HVAC Lookup\hvac-lookup
set GIT_BASE=C:\Users\SamHannaford\AppData\Local\GitHubDesktop

REM ── Auto-detect GitHub Desktop git ──────────────────────────────────
set GIT_EXE=
for /d %%D in ("%GIT_BASE%\app-*") do (
    if exist "%%D\resources\app\git\cmd\git.exe" set GIT_EXE=%%D\resources\app\git\cmd\git.exe
)
if "%GIT_EXE%"=="" (where git >nul 2>&1 && set GIT_EXE=git)
if "%GIT_EXE%"=="" (echo ERROR: git not found & pause & exit /b 1)
echo Using git: %GIT_EXE%

REM ── Find HVAC_Asset_Lookup*.html — newest first via PowerShell ────────
set HTML_SRC=
for /f "usebackq delims=" %%F in (`powershell -nologo -noprofile -command "Get-ChildItem ([System.IO.Path]::Combine($env:USERPROFILE,'Downloads'),'HVAC_Asset_Lookup*.html') -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName 2>$null"`) do set HTML_SRC=%%F

REM ── Fallbacks ─────────────────────────────────────────────────────────
if "%HTML_SRC%"=="" if exist "%~dp0HVAC_Asset_Lookup.html"                      set HTML_SRC=%~dp0HVAC_Asset_Lookup.html
if "%HTML_SRC%"=="" if exist "%USERPROFILE%\Desktop\HVAC_Asset_Lookup.html"     set HTML_SRC=%USERPROFILE%\Desktop\HVAC_Asset_Lookup.html
if "%HTML_SRC%"=="" if exist "%USERPROFILE%\Downloads\HVAC_Asset_Lookup.html"   set HTML_SRC=%USERPROFILE%\Downloads\HVAC_Asset_Lookup.html

if "%HTML_SRC%"=="" (
    echo ERROR: Could not find HVAC_Asset_Lookup.html
    echo Steps: open admin app ^> click Export Lookup HTML ^> run this script
    pause & exit /b 1
)
echo Found: %HTML_SRC%

REM ── Check repo ───────────────────────────────────────────────────────
if not exist "%REPO%" (echo ERROR: Repo not found & pause & exit /b 1)

REM ── Copy to repo as index.html ────────────────────────────────────────
copy /Y "%HTML_SRC%" "%REPO%\index.html" >nul
echo Copied to repo as index.html

REM ── Git push ──────────────────────────────────────────────────────────
cd /d "%REPO%"
"%GIT_EXE%" add index.html
"%GIT_EXE%" diff --cached --quiet
if %errorlevel%==0 (
    echo No changes — file already matches what is live.
    echo Make sure you clicked Export Lookup HTML in the admin app first.
    pause & exit /b 0
)
"%GIT_EXE%" commit -m "Update HVAC lookup app"
"%GIT_EXE%" push
if %errorlevel% neq 0 (echo ERROR: Git push failed & pause & exit /b 1)

echo.
echo Done! Cloudflare will update in ~30 seconds.
pause
