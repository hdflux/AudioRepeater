@echo off

REM input[#]			/Input:<str>			Input (capture, recording) device name
REM output[#]			/Output:<str>			Output (playback, rendering) device name
REM samplingRate[#]		/SamplingRate:<num>		Sampling rate (samples per second)
REM bitsPerSample[#]	/BitsPerSample:<num>	Bits per sample
REM channels			/Channels:<num>			Number of channels
REM chanCfg				/ChanCfg:<str>			Channel configuration
REM bufferMs[#]			/bufferMs:<num>			Total buffering length in milliseconds
REM buffers[#]			/buffers:<num>			Number of buffers (parts of buffering space)
REM priority			/Priority:<str>			Process priority <normal | high>
REM windowName[#]		/WindowName:<str>		Name of application instance window
REM 					/AutoStart				Start audio transfer automatically <blank | autostart>
REM 					/CloseInstance:<str>	Close a specified Audio Repeater instance by its window name

REM Smaller bufferms allows larger buffers.
REM More buffers mean more accuracy in buffer but can create more overhead.

REM srcdir	-- Location of audiorepeater_ks.exe.


set scriptDir=H:\Data\Installs\vac467full\x64
set channels=2
set chanCfg=stereo
set priority=high
set autoStart=/AutoStart


set windowName[0]=Audio Repeater - Line 1 - System Sounds
set input[0]=Virtual Cable 1
set resyncAt[0]=20
set outputPreFill[0]=50
set buffers[0]=16
set bufferMs[0]=100

set windowName[1]=Audio Repeater - Line 2 - Game
set input[1]=Virtual Cable 2
set resyncAt[1]=20
set outputPreFill[1]=50
set buffers[1]=16
set bufferMs[1]=100

set windowName[2]=Audio Repeater - Line 3 - Voice Chat
set input[2]=Virtual Cable 3
set resyncAt[2]=20
set outputPreFill[2]=50
set buffers[2]=16
set bufferMs[2]=100

set windowName[3]=Audio Repeater - Line 4 - Line To Device
set input[3]=Virtual Cable 4
set resyncAt[3]=20
set outputPreFill[3]=50
set buffers[3]=16
set bufferMs[3]=300


echo Set Audio Repeater to which device?
echo 1. Speakers.
echo 2. Headphones.
echo 3. Close all instances of Audio Repeater.
echo 4. Quit.
choice /t 10 /c 1234 /n /d 1

if errorlevel 4 goto :end
if errorlevel 3 goto :gc
if errorlevel 2 goto :headphones
if errorlevel 1 goto :speakers


:speakers

set output=Realtek HD Audio Output

set bitsPerSample[0]=16
set bitsPerSample[1]=16
set bitsPerSample[2]=16
set bitsPerSample[3]=16

set samplingRate[0]=96000
set samplingRate[1]=96000
set samplingRate[2]=96000
set samplingRate[3]=96000

echo.
echo Repeating audio to speakers on device %output%...
goto :gc


:headphones

set output=MG-XU-1

set bitsPerSample[0]=24
set bitsPerSample[1]=24
set bitsPerSample[2]=24
set bitsPerSample[3]=24

set samplingRate[0]=48000
set samplingRate[1]=48000
set samplingRate[2]=48000
set samplingRate[3]=48000

echo.
echo Repeating audio to headphones on device %output%...
goto :gc


:gc

echo Shutting down any active audio repeaters...
REM start "%scriptDir%\audiorepeater_ks.exe" /CloseInstance:"%windowName[0]%"
REM start "%scriptDir%\audiorepeater_ks.exe" /CloseInstance:"%windowName[1]%"
REM start "%scriptDir%\audiorepeater_ks.exe" /CloseInstance:"%windowName[2]%"
REM start "%scriptDir%\audiorepeater_ks.exe" /CloseInstance:"%windowName[3]%"
taskkill /fi "WindowTitle eq %windowName[0]%" > nul
taskkill /fi "WindowTitle eq %windowName[1]%" > nul
taskkill /fi "WindowTitle eq %windowName[2]%" > nul
taskkill /fi "WindowTitle eq %windowName[3]%" > nul

if not defined output goto :end


:createinstances

start /min "%windowName[3]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%input[3]%" /Output:"%output%" /SamplingRate:%samplingRate[3]% /BitsPerSample:%bitsPerSample[3]% /Channels:%channels% /ChanCfg:%chanCfg% /BufferMs:%bufferMs[3]% /Buffers:%buffers[3]% /OutputPreFill:%outputPreFill[3]% /ResyncAt:%resyncAt[3]% /WindowName:"%windowName[3]%" /Priority:%priority% %autoStart%
echo Audio Repeater created for %windowName[3]%.

start /min "%windowName[0]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%input[0]%" /Output:"Virtual Cable 4" /SamplingRate:%samplingRate[0]% /BitsPerSample:%bitsPerSample[0]% /Channels:%channels% /ChanCfg:%chanCfg% /BufferMs:%bufferMs[0]% /Buffers:%buffers[0]% /OutputPreFill:%outputPreFill[0]% /ResyncAt:%resyncAt[0]% /WindowName:"%windowName[0]%" /Priority:%priority% %autoStart%
echo Audio Repeater created for %windowName[0]%.

start /min "%windowName[1]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%input[1]%" /Output:"Virtual Cable 4" /SamplingRate:%samplingRate[1]% /BitsPerSample:%bitsPerSample[1]% /Channels:%channels% /ChanCfg:%chanCfg% /BufferMs:%bufferMs[1]% /Buffers:%buffers[1]% /OutputPreFill:%outputPreFill[1]% /ResyncAt:%resyncAt[1]% /WindowName:"%windowName[1]%" /Priority:%priority% %autoStart%
echo Audio Repeater created for %windowName[1]%.

start /min "%windowName[2]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%input[2]%" /Output:"Virtual Cable 4" /SamplingRate:%samplingRate[2]% /BitsPerSample:%bitsPerSample[2]% /Channels:%channels% /ChanCfg:%chanCfg% /BufferMs:%bufferMs[2]% /Buffers:%buffers[2]% /OutputPreFill:%outputPreFill[2]% /ResyncAt:%resyncAt[2]% /WindowName:"%windowName[2]%" /Priority:%priority% %autoStart%
echo Audio Repeater created for %windowName[2]%.


:end

timeout /t 5