Func recovery_to_POPO() ;返回备份的路径
	If @OSArch=="X64" Then
		Return  "C:\Program Files (x86)\corpname\POPO\users"	
	Else
		Return  "C:\Program Files\corpname\POPO\users" 
	EndIf
EndFunc

Func recovery_to_EIM() ;返回备份的路径
	Return @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
EndFunc

Func recovery_to_EIM_Files() ;返回备份的路径
	If @OSArch=="X64" Then
		Return "C:\Program Files (x86)\corpname\corpname EIM" 
	Else
		Return "C:\Program Files\corpname\corpname EIM"
	EndIf
EndFunc



Func backupDriver()
	Local $MyDrivers=DriveGetDrive("FIXED")
	
	For $i = 1 To $MyDrivers[0]
		If ($MyDrivers[$i] <> "c:") And FileExists($MyDrivers[$i] & "\backup" & @UserName )  Then  
			$Driver = $MyDrivers[$i] & "\backup"
			Return $Driver
		EndIf
	Next
	
	MsgBox(0,"","未找到备份过数据的磁盘，请确实是否在本机上做过备份。")
	Return 0
EndFunc


Func recovery()
;~ 	If @UserName <> "TestUser1" Then 
;~ 		MsgBox(0,"","测试版，此功能未完成")
;~ 		Return
;~ 	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	$POPO = recovery_to_POPO()
	$EIM = recovery_to_EIM()
	$EIM_Files = recovery_to_EIM_Files()
		
	Local $to[] = [    @UserProfileDir & "\AppData\Local\Microsoft\Outlook" , _      
	                   @UserProfileDir & "\AppData\Roaming\Microsoft\Outlook" , _  ;备份outlook
					   $POPO , _   ;备份POPO聊天记录
					   $EIM , _          ;备份即时通聊天记录
					   $EIM_Files , _   ;备份即时通文件，如接收的图片，自定义图片等
					   @UserProfileDir & "\Contacts" , _
					   @UserProfileDir & "\Favorites" , _
					   @UserProfileDir & "\Pictures" , _
					   @UserProfileDir & "\Documents" , _
					   @UserProfileDir & "\Downloads" , _
					   @UserProfileDir & "\Desktop"  _  ;备份C盘个人文件
					   ]
	

	;获取到用于存储备份数据的盘符
	$Driver=backupDriver()
	If $Driver == 0 Then Return
	
	Global $oldDirSize = 0
	Local $from = $to  ;
	Local $i =1
	For $item In $from 
		;$item_to = $item
		If $i == 3 Then   ; 强制以64位为标准，在恢复时有个固定的标准位置文件夹
			$from[$i-1] = "C:\Program Files (x86)\corpname\POPO\users"
		ElseIf $i == 4 Then
			$from[$i-1] = @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
		ElseIf $i == 5 Then
			$from[$i-1] = "C:\Program Files (x86)\corpname\corpname EIM" 
		EndIf
		
		$item_end=StringSplit($item,":\",1)		
		$from[$i-1]  = $Driver & @UserName & "\" & $item_end[2]
		$oldDirSize  += Round(DirGetSize($from[$i-1])/1024,1)   ;待还原的文件的总量,KB 		
		$i += 1
	Next
	
	;start \\ITTOOL_node1\ITTOOLS\Scripts\转移数据.exe
	
	Const $length = $i-1 ;数组长度
	;判断C盘空间是否足够用于存放恢复的数据
	$driverSpaceFree=Round(DriveSpaceFree("C:\")*1024,1)  ; C盘符剩余空间,KB
	If $driverSpaceFree < $oldDirSize Then 
		MsgBox(0,"","C盘空间不足，请清理后重启程序")
		Return
	EndIf
	
	
	$log = " /MIR /R:0 /NP /LOG+:d:\synclog.txt"
		
	For $i = 1 To $length
			
		$item_to = $to[$i-1]	
		$item_from  = $from[$i-1]
		
		;MsgBox(0,"",$item_from & @LF & $item_to)
		
		Global  $item_dirSize=Round(DirGetSize($item_from)/1024/1024,1)   ;MB 当前循环的原位置大小
		ProgressOn("正在还原",  $item_from , "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
		AdlibRegister("showProgress", 250)
		
		ShellExecuteWait("robocopy",'"' & $item_from & '"  ' & '"' & $item_to & '"  ' & $log , "", "",@SW_HIDE)
		
		AdlibUnRegister("showProgress")
		ProgressSet(100, "完成", "进度状态:")
		Sleep(100) ;进度条完成后的停留时间
		;$i += 1
	Next
	
	Sleep(3000) ;进度条完成后的停留时间
	ProgressOff() ;关闭进度条	
	
	ShellExecute("\\ITTOOL_node1\ITTOOLS\Scripts\即时通\导入即时通记录.exe");配置即时通
	CreateShortcut(); 创建快捷方式，eim\popo\outlook
	
	If FileExists("E:\mail\outlook_prf.reg") Then 
		$choose=MsgBox(1,"","是否导入outlook原账号配置信息 ？" & @LF & "注：导入备份的账号配置信息会立即覆盖当前outlook配置，请谨慎选择")
		If $choose==1 Then
			$reg_import ="reg import E:\mail\outlook_prf.reg"
			Global $command_reg_import[1] = [$reg_import]
			RunAs("ITSuperAdmin","CorpDomain","Password@4",4,runBat($command_reg_import)) 
		EndIf
	EndIf
	
	ShellExecute("explorer",$Driver & @UserName)
	Sleep(1000) 
	WO_rec("dataTrans_Recovery")
	MsgBox(0,"","此处的备份数据已还原到C盘，此目录的数据内容可酌情删除")
	
EndFunc

Func CreateShortcut()
	If @OSArch=="X64" Then 
		FileCreateShortcut("C:\Program Files (x86)\corpname\POPO\Start.exe",@DesktopDir & "\网易POPO.lnk")
		FileCreateShortcut("C:\Program Files (x86)\corpname\corpname EIM\Start.exe",@DesktopDir & "\网易即时通.lnk")
	Else
		FileCreateShortcut("C:\Program Files\corpname\POPO\Start.exe",@DesktopDir & "\网易POPO.lnk")
		FileCreateShortcut("C:\Program Files\corpname\corpname EIM\Start.exe",@DesktopDir & "\网易即时通.lnk")
	EndIf
	
	$outlookPath = RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE", "path") & "outlook.exe"  ;outlook程序路径
	FileCreateShortcut($outlookPath,@DesktopDir & "\outlook.lnk") 
EndFunc




