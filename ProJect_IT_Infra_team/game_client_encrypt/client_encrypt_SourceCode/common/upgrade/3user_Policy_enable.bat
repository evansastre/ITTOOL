reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System"  /v DisableRegistryTools /f
::允许注册表

reg add HKLM\SYSTEM\CurrentControlSet\Services\UsbStor /v Start /t reg_dword /d 3 /f
::允许USB存储设备的使用

reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /v debugger  /f
::允许IE


reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v NoDrives /t reg_binary /d 00000000 
::显示盘符
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v NoViewOnDrive /t reg_binary /d 00000000
::显示盘符，允许访问

::reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v restrictrun /t reg_dword /d 0 
::允许“运行”

reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System"  /v DisableCMD /t reg_dword /d 0
::forbidcmd允许bat 2    ，都forbid1 ，都放行0



echo 请确认上述结果
pause>nul