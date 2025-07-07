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
set "vac3_Min=/min"

:: Audio Repeater AutoStart state.
set "vac0_AutoStart=/AutoStart"
set "vac1_AutoStart=/AutoStart"
set "vac2_AutoStart=/AutoStart"
set "vac3_AutoStart=/AutoStart"