@echo off
powershell -Command $pword = read-host "Enter password" -AsSecureString ; $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword) ; [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) > .tmp.txt & set /p password=<.tmp.txt & del .tmp.txt

D:\client\TrueCryptPortable\TrueCryptPortable.exe  D:\client\game_client  /a  /p %password%  /l y    /q
::Mount to Y:\


