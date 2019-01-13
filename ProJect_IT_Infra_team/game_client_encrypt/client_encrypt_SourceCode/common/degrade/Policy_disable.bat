::net user newAdmin  Password@1
::net user newUser  Password@2  
::change passwd

reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v dismount /t REG_SZ /d C:\common\other\dismount.bat /f
::Run dismount on boot


reg add HKLM\SYSTEM\CurrentControlSet\Services\UsbStor /v Start /t reg_dword /d 4 /f
::forbid USB storage device

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /v debugger /t reg_sz /d debugfile.exe /f
::forbidIE

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v NoDrives /t reg_binary /d FF000003 
::hide driver
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v NoViewOnDrive /t reg_binary /d FB000003 
::hide driver£¬forbid access£¬but shortcut of game client can access 

::reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v restrictrun /t reg_dword /d 1 
::forbid "Run"

reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System"  /v DisableCMD /t reg_dword /d 2
::forbid cmd & all bat 2    ,forbid all 1 ,allow all 0


reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System"  /v DisableRegistryTools /t reg_dword /d 1
::forbid registry

powercfg -h off
::close sleep mode

net stop wuauserv
sc config wuauserv start= disabled
::forbid windows update

net localgroup administrators newUser /del
::detele newUser from local administrators group


echo Please confirm the result
pause>nul