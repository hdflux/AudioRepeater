@echo off
setlocal EnableDelayedExpansion

cd /d "%~dp0"

call config.bat


echo [96mSet Audio Repeater to which device?[0m
echo 1. Speakers.
echo 2. Yamaha MG10XU.
echo 3. Close all instances of Audio Repeater.
echo 4. Quit.
choice /t 15 /c 1234 /n /d 1

if errorlevel 4 goto :EndOfApp
if errorlevel 3 goto :GarbageCollection
if errorlevel 2 goto :Mixer
if errorlevel 1 goto :Speakers


:Speakers

echo [96mConfiguring audio repeaters to speakers.[0m
set "playbackDir=Speakers"
goto :GarbageCollection


:Mixer

echo [96mConfiguring audio repeaters to Yamaha MG10XU.[0m
set "playbackDir=Mixer"
goto :GarbageCollection

:GarbageCollection

echo [96mScanning for and closing existing Audio Repeater instances...[0m

:: Loop through known Audio Repeater instances
set /a lastIndex=vacCount - 1
for /L %%i in (0,1,!lastIndex!) do (
	set "vacWindowName=!vac%%i_WindowName!"
	tasklist /FI "WINDOWTITLE eq !vacWindowName!" | find /I "audiorepeater_ks.exe" >nul
	if not errorlevel 1 (
		audiorepeater_ks.exe /CloseInstance:"!vacWindowName!"
		REM taskkill /FI "WINDOWTITLE eq !vac%%i_WindowName!" /F >nul 2>&1
	)
)


:: Wait if any were closed
timeout /t %interval% /nobreak >nul

:: Goto EndOfApp if no audio repeaters are flagged for creation.
if not defined playbackDir (
    echo [91mNo device selected. Skipping instance creation.[0m
    goto :EndOfApp
)

goto :createinstances


:createinstances

set /a lastIndex=vacCount - 1
for /L %%i in (0,1,!lastIndex!) do (
	set "vacConfig=!vac%%i_Config!"
    set "cfgFile=configs\!playbackDir!\!vacConfig!"
	set "vacWindowName=!vac%%i_WindowName!"
	set "vacMin=!vac%%i_Min!"
	set "vacAutoStart=!vac%%i_AutoStart!"
	
    if exist "!cfgFile!" (
		call start "!vacWindowName!" !vacMin! "audiorepeater_ks.exe" /Config:"!cfgFile!" /WindowName:"!vacWindowName!" !vacAutoStart!
		call echo [92mAudio Repeater created for !vacWindowName!.[0m
    ) else (
        echo [91mConfig file missing: !cfgFile!. Skipping instance.[0m
    )
)


:EndOfApp

echo [92mCOMPLETE.[0m
timeout /t 15