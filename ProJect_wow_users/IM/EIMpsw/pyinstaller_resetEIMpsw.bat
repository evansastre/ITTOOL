pyinstaller -F -c  resetEIMpsw.py -i Start.exe
copy .\dist\resetEIMpsw.exe    .\resetEIMpsw.exe
copy .\dist\resetEIMpsw.exe    \\ITTOOL_node1\ITTOOLS\Scripts\EIM\resetEIMpsw\resetEIMpsw.exe 
copy .\dist\resetEIMpsw.exe    \\ITTOOL_node2\ITTOOLS\Scripts\EIM\resetEIMpsw\resetEIMpsw.exe 
pause >nul

:: ������Сд����
:: -F, �Conefile �����һ��exe�ļ���
:: -D, �Conedir ����һ��Ŀ¼������exe�ļ������������ܶ��ļ���Ĭ��ѡ���
:: -c, �Cconsole, �Cnowindowed ʹ�ÿ���̨���޽���(Ĭ��)
:: -w, �Cwindowed, �Cnoconsole ʹ�ô��ڣ��޿���̨




