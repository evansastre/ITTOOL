Func backup_from_POPO() ;返回备份的路径
	If @OSArch=="X64" Then
		If FileExists("C:\Program Files (x86)\corpname\POPO2\users") Then
			Return  "C:\Program Files (x86)\corpname\POPO2\users"
		Else	
			Return  "C:\Program Files (x86)\corpname\POPO\users"	
		EndIf
	Else
		If FileExists("C:\Program Files\corpname\POPO2\users") Then
			Return 	"C:\Program Files\corpname\POPO2\users" 
		Else
			Return  "C:\Program Files\corpname\POPO\users" 
		EndIf
	EndIf
EndFunc

Func backup_from_EIM() ;返回备份的路径
	If FileExists("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im") Then
		Return "C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
	Else
		Return @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
	EndIf
EndFunc

Func backup_from_EIM_Files() ;返回备份的路径
	If @OSArch=="X64" Then
		Return "C:\Program Files (x86)\corpname\corpname EIM" 
	Else
		Return "C:\Program Files\corpname\corpname EIM"
	EndIf
EndFunc



Func chooseDriver($oldDirSize,$driverSpaceFree)
	Local $tip = "需要备份的数据总量 : " & Round($oldDirSize/1024,2) & " MB" & @LF & _
				 "当前E盘剩余空间      : " & Round($driverSpaceFree/1024,2) & " MB" & @LF & _
				 "E盘空间不足，无法作为备份的目标磁盘" & @LF 
	Local $MyDrivers=DriveGetDrive("FIXED")
	Local $s=""
	Local $AvailableDriver[0] = [] ;定义空的数组,存放可用的盘符
	
	For $i = 1 To $MyDrivers[0]
		If ($MyDrivers[$i] <> "c:") And ($MyDrivers[$i] <> "e:")   And Round(DriveSpaceFree($MyDrivers[$i])*1024,1) > $oldDirSize   Then  
			;此处直接过滤掉默认的C和E，以及空间小于备份大小的盘符
			$s = $s &  $MyDrivers[$i] & "|"
			_ArrayAdd($AvailableDriver,$MyDrivers[$i])
		EndIf
	Next

	If UBound($AvailableDriver)==0 Then  ;以判断数组是否为空，来判断有无可用磁盘
		MsgBox(0,"",$tip &  "且当前无其他可用磁盘，请清理空间后再执行")
		Return
	EndIf
	
	$String_chooses=StringLeft($s,StringLen($s)-1) ; 去掉最后一个 | 符号
	$String_AvailableDriver = $AvailableDriver[0] ;首个可选盘符
	
	
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("备份的目标磁盘", 303, 210, -1, -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel($tip & "请选择其他可用盘符作为备份目标磁盘" , 8, 18, 500, 80)

	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")
	;GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$DOMAINCOMBO = GUICtrlCreateCombo("", 74, 115, 137, 40, 3)
	GUICtrlSetData(-1, $String_chooses, $String_AvailableDriver)
	
	$CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 32, 152, 73, 25)
	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 168, 152, 73, 25)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	While 1
		$NMSG = GUIGetMsg()
		Select
			Case $NMSG = $CONFIRMBUTTON
				;$USERDISPLAYNAME = GUICtrlRead($USERNAMEEDIT)
				$choose = GUICtrlRead($DOMAINCOMBO)
				GUIDelete()
				Return  $choose & "\backup"
		
			Case $NMSG = $CANCELBUTTON Or $NMSG = $GUI_EVENT_CLOSE
				GUIDelete()
				Return 
		EndSelect
	WEnd
	GUIDelete()
	;Return "D:\" & "backup"
	
EndFunc






Func backup()
	$EIM = backup_from_EIM()
	$EIM_Files = backup_from_EIM_Files()
	$POPO = backup_from_POPO()
	
	Local $from[] = [  @UserProfileDir & "\AppData\Local\Microsoft\Outlook" , _      
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
	
	Global $oldDirSize = 0
	
	;判断E盘剩余空间是否足够，否则选择其他盘符
	For $item In $from
		$oldDirSize  += Round(DirGetSize($item)/1024,1)   ;旧文件的总量,KB 
	Next
	$driverSpaceFree=Round(DriveSpaceFree("E:\")*1024,1)  ;默认，E盘符剩余空间,KB
	$Driver="E:\" & "backup" ;定义默认值
	
	If $driverSpaceFree < $oldDirSize Then ;******************************
		$Driver= chooseDriver($oldDirSize,$driverSpaceFree)
		If $Driver == 0 Then Return 
		;MsgBox(0,"",$choose)
	EndIf
	
	$log = " /MIR /R:0 /NP /LOG+:d:\synclog.txt"
	Local $to=$from  ;定义目的路径，给目的文件夹命名
	Local $i =1
	Local $oldDir
	For $item In $to 
			
		$item_from = $item
		$oldDir = $oldDir & $item_from & @LF
		If $i == 3 Then   ; 强制以64位为标准，在恢复时有个固定的标准位置文件夹
			$item = "C:\Program Files (x86)\corpname\POPO\users"
		ElseIf $i == 4 Then
			$item = @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
		ElseIf $i == 5 Then
			$item = "C:\Program Files (x86)\corpname\corpname EIM" 
		EndIf
		
		$item_end=StringSplit($item,":\",1)		
		$item_to  = $Driver & @UserName & "\" & $item_end[2]
		Global  $item_dirSize=Round(DirGetSize($item_from)/1024/1024,1)   ;MB 当前循环的原位置大小
		ProgressOn("正在备份",  $item_from , "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
		AdlibRegister("showProgress", 250)
		
		ShellExecuteWait("robocopy",'"' & $item_from & '"  ' & '"' & $item_to & '"  ' & $log , "", "",@SW_HIDE)

		AdlibUnRegister("showProgress")
		ProgressSet(100, "完成", "进度状态:")
		Sleep(100) ;进度条完成后的停留时间
		$i += 1
	Next
	
	Sleep(3000) ;进度条完成后的停留时间
	ProgressOff() ;关闭进度条	
	
	;导出outlook用户配置文件（注册表形式）
	$reg_export = 'reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"  E:\mail\outlook_prf.reg /y'
	Global $command_reg_export[1] = [$reg_export]
	runBat($command_reg_export)
	;-----------------------------------

	ShellExecute("explorer",$Driver & @UserName)
	Sleep(1000) 
	WO_rec("dataTrans_backup")
	MsgBox(0,"","备份已完成，备份数据至当前打开目录相应位置。原目录为：" & @LF & $oldDir )
EndFunc


Func showProgress()
	
;~ 	If Not ProcessExists("robocopy.exe") Then
;~ 		$i=100
;~ 		AdlibUnRegister("showProgress")
;~ 	EndIf
	If Not ProcessExists("robocopy.exe") Then Return

	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
	;$stdread = $arr[3]  ;& " MB"
	$i = Round($stdread/$item_dirSize,3)*100
	If ProcessExists("robocopy.exe") And $i>=99.999 then
		ProgressSet($i, " 即将完成，请勿关闭")
	Else
		ProgressSet($i, $stdread & "MB/" & $item_dirSize & "MB")
	EndIf

EndFunc   ;==>showProgress




