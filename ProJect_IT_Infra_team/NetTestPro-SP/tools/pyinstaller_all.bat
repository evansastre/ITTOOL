pyinstaller -F -c   sendmail_battlenet.py
pyinstaller -F -c   sendmail_speed.py
pyinstaller -F -c   sendmail_TV.py
pyinstaller -F -c   getmyip.py
copy .\dist\sendmail_battlenet.exe    .\sendmail_battlenet.exe
copy .\dist\sendmail_speed.exe    .\sendmail_speed.exe
copy .\dist\sendmail_TV.exe    .\sendmail_TV.exe
copy .\dist\getmyip.exe    .\getmyip.exe
pause >nul

:: 参数大小写敏感
:: -F, –onefile 打包成一个exe文件。
:: -D, –onedir 创建一个目录，包含exe文件，但会依赖很多文件（默认选项）。
:: -c, –console, –nowindowed 使用控制台，无界面(默认)
:: -w, –windowed, –noconsole 使用窗口，无控制台