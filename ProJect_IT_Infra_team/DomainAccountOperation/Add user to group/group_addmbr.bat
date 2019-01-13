set mygroup=corp_no_psw
::要添加到的组在此定义

del DN.txt,result.txt
for /f %%i in (user.txt) do (dsquery user -samid %%i ) >>DN.txt
for /f %%i in (DN.txt) do (dsquery group -name %mygroup% | dsmod group -addmbr   %%i) >> result.txt
pause >>nul

