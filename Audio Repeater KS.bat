@echo off

REM input[#]		/Input:<str>			Input (capture, recording) device name
REM out				/Output:<str>			Output (playback, rendering) device name
REM sr				/SamplingRate:<num>		Sampling rate (samples per second)
REM bps				/BitsPerSample:<num>	Bits per sample
REM ch				/Channels:<num>			Number of channels
REM chcfg			/ChanCfg:<str>			Channel configuration
REM bufferms		/BufferMs:<num>			Total buffering length in milliseconds
REM bufferparts		/BufferParts:<num>		Number of buffers (parts of buffering space)
REM 				/Priority:<str>			Process priority <normal | high>
REM wn[#]			/WindowName:<str>		Name of application instance window
REM 				/AutoStart				Start audio transfer automatically <blank | autostart>
REM 				/CloseInstance:<str>	Close a specified Audio Repeater instance by its window name

REM Smaller bufferms allows larger bufferparts.
REM More bufferparts mean more accuracy in buffer but can create more overhead.

REM srcdir	-- Location of audiorepeater.exe.


set scriptDir=H:\Data\Installs\vac467full\x64
set samplingRate=48000
set bitsPerSample=16
set numChannels=2
set channelConfig=stereo
set totalBuffer=100
set numBuffers=64
set bufferPrefillPercent=50
set bufferReSyncPrecent=20
set cpuPriority=high
set autoStart=/AutoStart

set windowName[0]=Audio Repeater - Line 1 - System Sounds
set windowName[1]=Audio Repeater - Line 2 - Game
set windowName[2]=Audio Repeater - Line 3 - Voice Chat
set windowName[3]=Audio Repeater - Line 4 - Line To Device

set vacName[0]=Virtual Cable 1
set vacName[1]=Virtual Cable 2
set vacName[2]=Virtual Cable 3
set vacName[3]=Virtual Cable 4


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

set deviceName=Realtek HD Audio Output
echo.
echo Repeating audio to speakers on device %deviceName%...
goto :gc


:headphones

set deviceName=MG-XU
set bitsPerSample=24
echo.
echo Repeating audio to headphones on device %deviceName%...
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

if not defined deviceName goto :end


:createinstances

start /min "%windowName[3]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%vacName[3]%" /Output:"%deviceName%" /SamplingRate:%samplingRate% /BitsPerSample:%bitsPerSample% /Channels:%numChannels% /ChanCfg:%channelConfig% /BufferMs:%totalBuffer% /Buffers:%numBuffers% /OutputPreFill:%bufferPrefillPercent% /ResyncAt:%bufferReSyncPrecent% /WindowName:"%windowName[3]%" /Priority:%cpuPriority% %autoStart%
echo Audio Repeater created for %windowName[3]%.
start /min "%windowName[0]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%vacName[0]%" /Output:"Virtual Cable 4" /SamplingRate:%samplingRate% /BitsPerSample:%bitsPerSample% /Channels:%numChannels% /ChanCfg:%channelConfig% /BufferMs:%totalBuffer% /Buffers:%numBuffers% /OutputPreFill:%bufferPrefillPercent% /ResyncAt:%bufferReSyncPrecent% /WindowName:"%windowName[0]%" /Priority:%cpuPriority% %autoStart%
echo Audio Repeater created for %windowName[0]%.
start /min "%windowName[1]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%vacName[1]%" /Output:"Virtual Cable 4" /SamplingRate:%samplingRate% /BitsPerSample:%bitsPerSample% /Channels:%numChannels% /ChanCfg:%channelConfig% /BufferMs:%totalBuffer% /Buffers:%numBuffers% /OutputPreFill:%bufferPrefillPercent% /ResyncAt:%bufferReSyncPrecent% /WindowName:"%windowName[1]%" /Priority:%cpuPriority% %autoStart%
echo Audio Repeater created for %windowName[1]%.
start /min "%windowName[2]%" "%scriptDir%\audiorepeater_ks.exe" /Input:"%vacName[2]%" /Output:"Virtual Cable 4" /SamplingRate:%samplingRate% /BitsPerSample:%bitsPerSample% /Channels:%numChannels% /ChanCfg:%channelConfig% /BufferMs:%totalBuffer% /Buffers:%numBuffers% /OutputPreFill:%bufferPrefillPercent% /ResyncAt:%bufferReSyncPrecent% /WindowName:"%windowName[2]%" /Priority:%cpuPriority% %autoStart%
echo Audio Repeater created for %windowName[2]%.


:end

timeout /t 5