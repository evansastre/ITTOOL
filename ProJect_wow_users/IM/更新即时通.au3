Local Const $sFilePath = @TempDir & "\user_data.conf"  ;����ʱĿ¼����conf�ļ�
Local Const $confPath= @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra" ;conf�ļ�����·��
DirCopy("\\192.168.112.241\Popoem-Intra",$confPath,1) ;���������ļ�

FileWrite($sFilePath,"user_data_path = "& $confPath);�����ļ��е��û��ļ���ָ������

FileCopy($sFilePath,$confPath,1+8);�滻����conf�ļ�
FileDelete($sFilePath);ɾ������ʱĿ¼������conf�ļ�


;~ $source = @DesktopDir& "\"&@UserName & "@battlenet.im" 
;~ $des= $confPath &"\users\" &@UserName & "@battlenet.im"
;~ DirCopy($source,$des,1) ;�����û���¼������λ��  
FileCreateShortcut("C:\Program Files (x86)\corpname\corpname EIM\Start.exe",@DesktopDir &"\���׼�ʱͨ")



