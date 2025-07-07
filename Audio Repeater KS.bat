@echo off
setlocal enabledelayedexpansion

:: input[#]			/Input:<str>			Input (capture, recording) endpoint name
:: output[#]			/Output:<str>			Output (playback, rendering) endpoint name
:: samplingRate[#]		/SamplingRate:<num>		Sampling rate (samples per second)
:: bitsPerSample[#]	/BitsPerSample:<num>	Bits per sample
:: channels			/Channels:<num>			Number of channels
:: chanCfg				/ChanCfg:<str>			Channel configuration
:: bufferMs[#]			/BufferMs:<num>			Total buffering length in milliseconds
:: buffers[#]			/BufferParts:<num>			Number of buffers (parts of buffering space)
:: 					/Prefill:<percent>		Percent of each queue size to pre-fill before starting
:: 					/ResyncAt:<percent>		Percent of each queue size to pause until pre-filled
:: 					/VacClockMode:<mode>	VAC clock control mode (Off, Any, Input, Output)
:: priority			/Priority:<str>			Process priority <normal | high>
:: windowName[#]		/WindowName:<str>		Name of application instance window
:: 					/AutoStart				Start audio transfer automatically <blank | autostart>
:: 					/CloseInstance:<str>	Close a specified Audio Repeater instance by its window name
:: 					/Config:<str>			Read options from the specified file.

:: Smaller bufferms allows larger buffers.
:: More buffers mean more accuracy in buffer but can create more overhead.

:: srcdir	-- Location of audiorepeater_ks.exe.


set "appDir=D:\OneDrive\Documents\GitHub\AudioRepeater"
set "configDir=D:\OneDrive\Documents\GitHub\AudioRepeater\configs"

:: Runtime control flags.
set vacCount=4
set interval=3

:: Audio Repeater Window Names.
set "vac0_WindowName=ARKS-L1-System"
set "vac1_WindowName=ARKS-L2-Game"
set "vac2_WindowName=ARKS-L3-Voice"
set "vac3_WindowName=ARKS-L4-Playback"

:: Audio Repeater Config Files.
set "vac0_Config=Line1-System.cfg"
set "vac1_Config=Line2-Game.cfg"
set "vac2_Config=Line3-Voice.cfg"
set "vac3_Config=Line4-Playback.cfg"

:: Audio Repeater Min state.
set "vac0_Min=/min"
set "vac1_Min=/min"
set "vac2_Min=/min"
set "vac3_Min="

:: Audio Repeater AutoStart state.
set "vac0_AutoStart=/AutoStart"
set "vac1_AutoStart=/AutoStart"
set "vac2_AutoStart=/AutoStart"
set "vac3_AutoStart="


echo [96mSet Audio Repeater to which device?[0m
echo 1. Speakers.
echo 2. Yamaha MG10XU.
echo 3. Close all instances of Audio Repeater.
echo 4. Quit.
choice /t 15 /c 1234 /n /d 1

if errorlevel 4 goto :end
if errorlevel 3 goto :gc
if errorlevel 2 goto :mixer
if errorlevel 1 goto :speakers


:speakers

set "playbackDir=Speakers"

echo.
echo [96mConfiguring audio repeaters to speakers.[0m

goto :gc


:mixer

set "playbackDir=Mixer"
set "vac3_Min=/min"
set "vac3_AutoStart=/AutoStart"

echo.
echo [96mConfiguring audio repeaters to Yamaha MG10XU.[0m


:gc

echo.
echo [96mScanning for and closing existing Audio Repeater instances...[0m
echo.

:: Loop through known Audio Repeater instances
set /a lastIndex=vacCount - 1
for /L %%i in (0,1,!lastIndex!) do (
	taskkill /fi "WINDOWTITLE eq !vac%%i_WindowName!" /f >nul 2>&1
)

:: Wait if any were closed
timeout /t %interval% /nobreak >nul

:: Goto End if no audio repeaters are flagged for creation.
if not defined playbackDir (
    echo [91mNo device selected. Skipping instance creation.[0m
    goto :end
)

goto :createinstances


:createinstances

set /a lastIndex=vacCount - 1
for /L %%i in (0,1,!lastIndex!) do (
    set "cfgFile=!configDir!\!playbackDir!\!vac%%i_Config!"
	
    if exist "!cfgFile!" (
		call start "!vac%%i_WindowName!" !vac%%i_Min! "!appDir!\audiorepeater_ks.exe" /Config:"!cfgFile!" /WindowName:"!vac%%i_WindowName!" !vac%%i_AutoStart!
		call echo [92mAudio Repeater created for !vac%%i_WindowName!.[0m
    ) else (
        echo [91mConfig file missing: !cfgFile!. Skipping instance.[0m
    )
)



:end

echo.
echo [92mCOMPLETE.[0m
timeout /t 15