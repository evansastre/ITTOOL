pyinstaller -F -c   sendmail.py
pyinstaller -F -c   getmyip.py2
copy .\dist\sendmail.exe    .\sendmail.exe
copy .\dist\getmyip.exe    .\getmyip.exe
pause >nul

:: ������Сд����
:: -F, �Conefile �����һ��exe�ļ���
:: -D, �Conedir ����һ��Ŀ¼������exe�ļ������������ܶ��ļ���Ĭ��ѡ���
:: -c, �Cconsole, �Cnowindowed ʹ�ÿ���̨���޽���(Ĭ��)
:: -w, �Cwindowed, �Cnoconsole ʹ�ô��ڣ��޿���̨