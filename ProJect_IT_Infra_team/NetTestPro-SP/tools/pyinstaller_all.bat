pyinstaller -F -c   sendmail_battlenet.py
pyinstaller -F -c   sendmail_speed.py
pyinstaller -F -c   sendmail_TV.py
pyinstaller -F -c   getmyip.py
copy .\dist\sendmail_battlenet.exe    .\sendmail_battlenet.exe
copy .\dist\sendmail_speed.exe    .\sendmail_speed.exe
copy .\dist\sendmail_TV.exe    .\sendmail_TV.exe
copy .\dist\getmyip.exe    .\getmyip.exe
pause >nul

:: ������Сд����
:: -F, �Conefile �����һ��exe�ļ���
:: -D, �Conedir ����һ��Ŀ¼������exe�ļ������������ܶ��ļ���Ĭ��ѡ���
:: -c, �Cconsole, �Cnowindowed ʹ�ÿ���̨���޽���(Ĭ��)
:: -w, �Cwindowed, �Cnoconsole ʹ�ô��ڣ��޿���̨