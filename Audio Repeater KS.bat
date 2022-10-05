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
set autoStart=/AutoStart


set vac[0].WindowName=Audio Repeater - Line 1 - System Sounds
set vac[0].Input=Virtual Cable 1
set vac[0].ResyncAt=20
set vac[0].OutputPreFill=50
set vac[0].Buffers=16
set vac[0].BufferMs=200
set vac[0].PacketModeIn=off
set vac[0].PacketModeOut=off
set vac[0].Priority=high
set vac[0].Min=/min

set vac[1].WindowName=Audio Repeater - Line 2 - Game
set vac[1].Input=Virtual Cable 2
set vac[1].ResyncAt=20
set vac[1].OutputPreFill=50
set vac[1].Buffers=16
set vac[1].BufferMs=200
set vac[1].PacketModeIn=off
set vac[1].PacketModeOut=off
set vac[1].Priority=high
set vac[1].Min=/min

set vac[2].WindowName=Audio Repeater - Line 3 - Voice Chat
set vac[2].Input=Virtual Cable 3
set vac[2].ResyncAt=20
set vac[2].OutputPreFill=50
set vac[2].Buffers=16
set vac[2].BufferMs=200
set vac[2].PacketModeIn=off
set vac[2].PacketModeOut=off
set vac[2].Priority=high
set vac[2].Min=/min

set vac[3].WindowName=Audio Repeater - Line 4 - Line To MGX10XU
set vac[3].Input=Virtual Cable 4
set vac[3].Output=MG-XU
set vac[3].ResyncAt=20
set vac[3].OutputPreFill=50
set vac[3].Buffers=16
set vac[3].BufferMs=200
set vac[3].PacketModeIn=off
set vac[3].PacketModeOut=off
set vac[3].Priority=high
set vac[3].Min=

set vac[4].WindowName=Audio Repeater - Line 5 - Line To Speakers
set vac[4].Input=Virtual Cable 5
set vac[4].Output=Realtek HD Audio Output
set vac[4].ResyncAt=20
set vac[4].OutputPreFill=50
set vac[4].Buffers=16
set vac[4].BufferMs=200
set vac[4].PacketModeIn=off
set vac[4].PacketModeOut=off
set vac[4].Priority=high
set vac[4].Min=/min


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

set vac[0].Output=Virtual Cable 5
set vac[1].Output=Virtual Cable 5
set vac[2].Output=Virtual Cable 5

set bitsPerSample=16
set samplingRate=48000
set oi=4

echo.
echo Repeating audio to speakers on device %vac[3].Output%...
goto :gc


:headphones

set vac[0].Output=Virtual Cable 4
set vac[1].Output=Virtual Cable 4
set vac[2].Output=Virtual Cable 4

set bitsPerSample=24
set samplingRate=44100
set oi=3

echo.
echo Repeating audio to headphones on device %vac[3].Output%...


:gc

echo.
echo Shutting down any active audio repeaters...
echo.

for /L %%i in (0, 1, 4) do call taskkill /fi "WindowTitle eq %%vac[%%i].WindowName%%" > nul

if not defined oi goto :end


:createinstances

for /L %%i in (0, 1, 2) do (
	call start %%vac[%%i].Min%% "%%vac[%%i].WindowName%%" "%%scriptDir%%\audiorepeater_ks.exe"^
	 /Input:"%%vac[%%i].Input%%" /Output:"%%vac[%%i].Output%%"^
	 /SamplingRate:%%samplingRate%% /BitsPerSample:%%bitsPerSample%%^
	 /Channels:%%channels%% /ChanCfg:%%chanCfg%%^
	 /BufferMs:%%vac[%%i].BufferMs%% /Buffers:%%vac[%%i].Buffers%%^
	 /ResyncAt:%%vac[%%i].ResyncAt%% /OutputPreFill:%%vac[%%i].OutputPreFill%%^
	 /PacketModeIn:%%vac[%%i].PacketModeIn%% /PacketModeOut:%%vac[%%i].PacketModeOut%%^
	 /WindowName:"%%vac[%%i].WindowName%%"^
	 /Priority:%%vac[%%i].Priority%% %%autoStart%%
	call echo Audio Repeater created for %%vac[%%i].WindowName%%.
)

call start %%vac[%oi%].Min%% "%%vac[%oi%].WindowName%%" "%scriptDir%\audiorepeater_ks.exe"^
 /Input:"%%vac[%oi%].Input%%" /Output:"%%vac[%oi%].Output%%"^
 /SamplingRate:%samplingRate% /BitsPerSample:%bitsPerSample%^
 /Channels:%channels% /ChanCfg:%chanCfg%^
 /BufferMs:%%vac[%oi%].BufferMs%% /Buffers:%%vac[%oi%].Buffers%%^
 /ResyncAt:%%vac[%oi%].ResyncAt%% /OutputPreFill:%%vac[%oi%].OutputPreFill%%^
 /PacketModeIn:%%vac[%oi%].PacketModeIn%% /PacketModeOut:%%vac[%oi%].PacketModeOut%%^
 /WindowName:"%%vac[%oi%].WindowName%%"^
 /Priority:%%vac[%oi%].Priority%% %autoStart%
	
call echo Audio Repeater created for %%vac[%oi%].WindowName%%.


:end

echo.
echo COMPLETE.

timeout /t 15