net user %username% 123
::在管理员账号下运行，修改管理员密码为123

net user newUser /del
::删除newUser

format Y: /FS:NTFS /Q /y
format Z: /FS:NTFS /Q /y

D:\client\TrueCryptPortable\TrueCryptPortable.exe /d /s /q
::解除加载盘


format D: /FS:NTFS /Q /y
::格式化D、Y、Z盘



rd /s /q C:\desktopImages

del C:\policy_disable.exe

rd /s /q C:\common

cd. >listnull.txt
for /f "delims=" %%i in ('dir /ad /b /s') do (
dir /b "%%i"|findstr .>nul || echo %%i >> listnull.txt
)
for /f %%i in (listnull.txt) do (
echo 成功删除目录：%%i 
rd /q %%i
)
del /q listnull.txt > nul

