# Audio Repeater Automation
#### By Eric Albrecht (eric.albrecht@hotmail.ca)

## What it is about?
This application was developed to automate the process of switching between two studio environments. With version 2.0.0 the user is now able to do the majority of their configuration in config.bat and *.cfg files. The current settings for the audio repeaters are set with my pc requirements in mind, though I suspect that they will work on other computers.

### Audio Repeater Automation Application
<img width="304" alt="2025-07-07 (1)" src="https://github.com/user-attachments/assets/e95171f1-6abd-4019-b134-476f0d901aed" />

### VAC Control Panel
<img width="740" alt="2025-07-07" src="https://github.com/user-attachments/assets/4e0f4ade-89ac-4dcb-b854-e7157aa60322" />

### Audio Repeater (Kernel Streaming)
<img width="635" alt="2025-07-07 (2)" src="https://github.com/user-attachments/assets/22e1a44a-2317-489d-b639-4b3a237708cd" />

## What is planned?
1. I would like to further empower the user with configuration options such that they never have to modify the _audio repeater ks.bat_ file by having all user input done in config files. The framework code should never be touched by the end user.
2. Include the MME version into the application so the user has a choice between that and the KS version.

## Known Bugs
There is a bug with the kernel version of audio repeater, at least with version 1.90 where the /CloseInstance parameter does not work. Thus my only way of terminating instances is through brute force taskkill. The API for the current version implies that this parameter should work, which would allow me to gracefully stop and flush the buffer streams before terminating the instances, unfortunately that is not the case. I don't really see this as being a problem, but it is something to be aware of.
