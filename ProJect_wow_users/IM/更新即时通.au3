Local Const $sFilePath = @TempDir & "\user_data.conf"  ;在临时目录建立conf文件
Local Const $confPath= @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra" ;conf文件所在路径
DirCopy("\\192.168.112.241\Popoem-Intra",$confPath,1) ;拷贝配置文件

FileWrite($sFilePath,"user_data_path = "& $confPath);配置文件中的用户文件夹指向配置

FileCopy($sFilePath,$confPath,1+8);替换现有conf文件
FileDelete($sFilePath);删除在临时目录建立的conf文件


;~ $source = @DesktopDir& "\"&@UserName & "@battlenet.im" 
;~ $des= $confPath &"\users\" &@UserName & "@battlenet.im"
;~ DirCopy($source,$des,1) ;拷贝用户记录到定义位置  
FileCreateShortcut("C:\Program Files (x86)\corpname\corpname EIM\Start.exe",@DesktopDir &"\网易即时通")



