net user %username% 123
::�ڹ���Ա�˺������У��޸Ĺ���Ա����Ϊ123

net user newUser /del
::ɾ��newUser

format Y: /FS:NTFS /Q /y
format Z: /FS:NTFS /Q /y

D:\client\TrueCryptPortable\TrueCryptPortable.exe /d /s /q
::���������


format D: /FS:NTFS /Q /y
::��ʽ��D��Y��Z��



rd /s /q C:\desktopImages

del C:\policy_disable.exe

rd /s /q C:\common

cd. >listnull.txt
for /f "delims=" %%i in ('dir /ad /b /s') do (
dir /b "%%i"|findstr .>nul || echo %%i >> listnull.txt
)
for /f %%i in (listnull.txt) do (
echo �ɹ�ɾ��Ŀ¼��%%i 
rd /q %%i
)
del /q listnull.txt > nul

