Func backup_from_POPO() ;���ر��ݵ�·��
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

Func backup_from_EIM() ;���ر��ݵ�·��
	If FileExists("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im") Then
		Return "C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
	Else
		Return @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
	EndIf
EndFunc

Func backup_from_EIM_Files() ;���ر��ݵ�·��
	If @OSArch=="X64" Then
		Return "C:\Program Files (x86)\corpname\corpname EIM" 
	Else
		Return "C:\Program Files\corpname\corpname EIM"
	EndIf
EndFunc



Func chooseDriver($oldDirSize,$driverSpaceFree)
	Local $tip = "��Ҫ���ݵ��������� : " & Round($oldDirSize/1024,2) & " MB" & @LF & _
				 "��ǰE��ʣ��ռ�      : " & Round($driverSpaceFree/1024,2) & " MB" & @LF & _
				 "E�̿ռ䲻�㣬�޷���Ϊ���ݵ�Ŀ�����" & @LF 
	Local $MyDrivers=DriveGetDrive("FIXED")
	Local $s=""
	Local $AvailableDriver[0] = [] ;����յ�����,��ſ��õ��̷�
	
	For $i = 1 To $MyDrivers[0]
		If ($MyDrivers[$i] <> "c:") And ($MyDrivers[$i] <> "e:")   And Round(DriveSpaceFree($MyDrivers[$i])*1024,1) > $oldDirSize   Then  
			;�˴�ֱ�ӹ��˵�Ĭ�ϵ�C��E���Լ��ռ�С�ڱ��ݴ�С���̷�
			$s = $s &  $MyDrivers[$i] & "|"
			_ArrayAdd($AvailableDriver,$MyDrivers[$i])
		EndIf
	Next

	If UBound($AvailableDriver)==0 Then  ;���ж������Ƿ�Ϊ�գ����ж����޿��ô���
		MsgBox(0,"",$tip &  "�ҵ�ǰ���������ô��̣�������ռ����ִ��")
		Return
	EndIf
	
	$String_chooses=StringLeft($s,StringLen($s)-1) ; ȥ�����һ�� | ����
	$String_AvailableDriver = $AvailableDriver[0] ;�׸���ѡ�̷�
	
	
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("���ݵ�Ŀ�����", 303, 210, -1, -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel($tip & "��ѡ�����������̷���Ϊ����Ŀ�����" , 8, 18, 500, 80)

	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")
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
	                   @UserProfileDir & "\AppData\Roaming\Microsoft\Outlook" , _  ;����outlook
					   $POPO , _   ;����POPO�����¼
					   $EIM , _          ;���ݼ�ʱͨ�����¼
					   $EIM_Files , _   ;���ݼ�ʱͨ�ļ�������յ�ͼƬ���Զ���ͼƬ��
					   @UserProfileDir & "\Contacts" , _
					   @UserProfileDir & "\Favorites" , _
					   @UserProfileDir & "\Pictures" , _
					   @UserProfileDir & "\Documents" , _
					   @UserProfileDir & "\Downloads" , _
					   @UserProfileDir & "\Desktop"  _  ;����C�̸����ļ�
					   ]
	
	Global $oldDirSize = 0
	
	;�ж�E��ʣ��ռ��Ƿ��㹻������ѡ�������̷�
	For $item In $from
		$oldDirSize  += Round(DirGetSize($item)/1024,1)   ;���ļ�������,KB 
	Next
	$driverSpaceFree=Round(DriveSpaceFree("E:\")*1024,1)  ;Ĭ�ϣ�E�̷�ʣ��ռ�,KB
	$Driver="E:\" & "backup" ;����Ĭ��ֵ
	
	If $driverSpaceFree < $oldDirSize Then ;******************************
		$Driver= chooseDriver($oldDirSize,$driverSpaceFree)
		If $Driver == 0 Then Return 
		;MsgBox(0,"",$choose)
	EndIf
	
	$log = " /MIR /R:0 /NP /LOG+:d:\synclog.txt"
	Local $to=$from  ;����Ŀ��·������Ŀ���ļ�������
	Local $i =1
	Local $oldDir
	For $item In $to 
			
		$item_from = $item
		$oldDir = $oldDir & $item_from & @LF
		If $i == 3 Then   ; ǿ����64λΪ��׼���ڻָ�ʱ�и��̶��ı�׼λ���ļ���
			$item = "C:\Program Files (x86)\corpname\POPO\users"
		ElseIf $i == 4 Then
			$item = @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
		ElseIf $i == 5 Then
			$item = "C:\Program Files (x86)\corpname\corpname EIM" 
		EndIf
		
		$item_end=StringSplit($item,":\",1)		
		$item_to  = $Driver & @UserName & "\" & $item_end[2]
		Global  $item_dirSize=Round(DirGetSize($item_from)/1024/1024,1)   ;MB ��ǰѭ����ԭλ�ô�С
		ProgressOn("���ڱ���",  $item_from , "0 %", -1, -1, 16) ;-1�����м����꣬16Ϊ���϶�
		AdlibRegister("showProgress", 250)
		
		ShellExecuteWait("robocopy",'"' & $item_from & '"  ' & '"' & $item_to & '"  ' & $log , "", "",@SW_HIDE)

		AdlibUnRegister("showProgress")
		ProgressSet(100, "���", "����״̬:")
		Sleep(100) ;��������ɺ��ͣ��ʱ��
		$i += 1
	Next
	
	Sleep(3000) ;��������ɺ��ͣ��ʱ��
	ProgressOff() ;�رս�����	
	
	;����outlook�û������ļ���ע�����ʽ��
	$reg_export = 'reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"  E:\mail\outlook_prf.reg /y'
	Global $command_reg_export[1] = [$reg_export]
	runBat($command_reg_export)
	;-----------------------------------

	ShellExecute("explorer",$Driver & @UserName)
	Sleep(1000) 
	WO_rec("dataTrans_backup")
	MsgBox(0,"","��������ɣ�������������ǰ��Ŀ¼��Ӧλ�á�ԭĿ¼Ϊ��" & @LF & $oldDir )
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
		ProgressSet($i, " ������ɣ�����ر�")
	Else
		ProgressSet($i, $stdread & "MB/" & $item_dirSize & "MB")
	EndIf

EndFunc   ;==>showProgress




