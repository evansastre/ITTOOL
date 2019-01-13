Develop Env:
Install:
python-2.7.10.msi  
py2exe-0.6.9.win32-py2.7   
pywin32-219.win32-py2.7



SourceCode£º
backup.py
**Modify the value of backup_server only when replacing the backup address


Conf£º
Hosts.ini: Storage switch IP address, manually modified according to requirements

Compile:
Run make.bat to generate the folder dist under backup.exe is the available executable file

deploy:
1. Cisco_TFTP_Server (directory), backup.exe, Hosts.ini need to be placed in the same directory on the server
2. Open TFTPServer.exe "View" - "Options" Adjust the server and directory


Set up scheduled tasks: Run every Monday.