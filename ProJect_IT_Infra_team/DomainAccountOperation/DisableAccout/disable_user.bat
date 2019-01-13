for /f %%i in (user.txt) do (dsquery user -samid %%i | dsmod user -disabled yes) >>result.txt

