pyinstaller -F -w UnLockDomainUser.py

copy .\dist\UnLockDomainUser.exe  \\ITTOOL_node2\ITTOOLS\Scripts\UnLockDomainUser.exe
pause>nul



:: ������Сд����
:: -F, �Conefile �����һ��exe�ļ���
:: -D, �Conedir ����һ��Ŀ¼������exe�ļ������������ܶ��ļ���Ĭ��ѡ���
:: -c, �Cconsole, �Cnowindowed ʹ�ÿ���̨���޽���(Ĭ��)
:: -w, �Cwindowed, �Cnoconsole ʹ�ô��ڣ��޿���̨