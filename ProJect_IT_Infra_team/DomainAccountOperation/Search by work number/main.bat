for /f %%i in (user.txt) do (dsquery user -name %%i | dsget user -samid) >>DN.txt
pause >>nul

