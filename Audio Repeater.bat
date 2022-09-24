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
set srcdir=H:\Apps\Virtual Audio Cable
set priority=high
set ch=2
set chcfg=stereo
set autostart=/AutoStart

set wn[0]=Audio Repeater Line 1 System
set input[0]=Line 1 (Virtual Audio Cable)
set resync[0]=20
set prefill[0]=50
set bufferparts[0]=64
set bufferms[0]=100
set bps[0]=16
set sr[0]=48000

set wn[1]=Audio Repeater Line 2 Game
set input[1]=Line 2 (Virtual Audio Cable)
set resync[1]=20
set prefill[1]=50
set bufferparts[1]=64
set bufferms[1]=100
set bps[1]=16
set sr[1]=48000

set wn[2]=Audio Repeater Line 3 Voice Chat
set input[2]=Line 3 (Virtual Audio Cable)
set resync[2]=20
set prefill[2]=50
set bufferparts[2]=64
set bufferms[2]=100
set bps[2]=16
set sr[2]=48000


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

set out=Speakers (Realtek High Definiti
echo.
echo Repeating audio to speakers on device %out%...
goto :gc


:headphones

set out=Line (2- MG-XU)
echo.
echo Repeating audio to headphones on device %out%...
goto :gc


:gc

echo Shutting down any active audio repeaters...
taskkill /fi "WindowTitle eq %wn[0]%" > nul
taskkill /fi "WindowTitle eq %wn[1]%" > nul
taskkill /fi "WindowTitle eq %wn[2]%" > nul

if not defined out goto :end


:createinstances

start /min "%wn[0]%" "%srcdir%\audiorepeater.exe" /Input: "%input[0]%" /Output: "%out%" /SamplingRate:%sr[0]% /BitsPerSample:%bps[0]% /Channels:%ch% /BufferMs:%bufferms[0]% /BufferParts:%bufferparts[0]% /Prefill:%prefill[0]% /ResyncAt:%resync[0]% /Priority:%priority% /ChanCfg:%chcfg% /WindowName:"%wn[0]%" %autostart%
echo Audio Repeater created for %wn[0]%.
start /min "%wn[1]%" "%srcdir%\audiorepeater.exe" /Input: "%input[1]%" /Output: "%out%" /SamplingRate:%sr[1]% /BitsPerSample:%bps[1]% /Channels:%ch% /BufferMs:%bufferms[1]% /BufferParts:%bufferparts[1]% /Prefill:%prefill[1]% /ResyncAt:%resync[1]% /Priority:%priority% /ChanCfg:%chcfg% /WindowName:"%wn[1]%" %autostart%
echo Audio Repeater created for %wn[1]%.
start /min "%wn[2]%" "%srcdir%\audiorepeater.exe" /Input: "%input[2]%" /Output: "%out%" /SamplingRate:%sr[2]% /BitsPerSample:%bps[2]% /Channels:%ch% /BufferMs:%bufferms[2]% /BufferParts:%bufferparts[2]% /Prefill:%prefill[2]% /ResyncAt:%resync[2]% /Priority:%priority% /ChanCfg:%chcfg% /WindowName:"%wn[2]%" %autostart%
echo Audio Repeater created for %wn[2]%.


:end

timeout /t 5