reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System"  /v DisableRegistryTools /f
::����ע���

reg add HKLM\SYSTEM\CurrentControlSet\Services\UsbStor /v Start /t reg_dword /d 3 /f
::����USB�洢�豸��ʹ��

reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\iexplore.exe" /v debugger  /f
::����IE


reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v NoDrives /t reg_binary /d 00000000 
::��ʾ�̷�
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v NoViewOnDrive /t reg_binary /d 00000000
::��ʾ�̷����������

::reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"  /v restrictrun /t reg_dword /d 0 
::�������С�

reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System"  /v DisableCMD /t reg_dword /d 0
::forbidcmd����bat 2    ����forbid1 ��������0



echo ��ȷ���������
pause>nul