Func recovery_to_POPO() ;���ر��ݵ�·��
	If @OSArch=="X64" Then
		Return  "C:\Program Files (x86)\corpname\POPO\users"	
	Else
		Return  "C:\Program Files\corpname\POPO\users" 
	EndIf
EndFunc

Func recovery_to_EIM() ;���ر��ݵ�·��
	Return @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
EndFunc

Func recovery_to_EIM_Files() ;���ر��ݵ�·��
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
	
	MsgBox(0,"","δ�ҵ����ݹ����ݵĴ��̣���ȷʵ�Ƿ��ڱ������������ݡ�")
	Return 0
EndFunc


Func recovery()
;~ 	If @UserName <> "TestUser1" Then 
;~ 		MsgBox(0,"","���԰棬�˹���δ���")
;~ 		Return
;~ 	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	$POPO = recovery_to_POPO()
	$EIM = recovery_to_EIM()
	$EIM_Files = recovery_to_EIM_Files()
		
	Local $to[] = [    @UserProfileDir & "\AppData\Local\Microsoft\Outlook" , _      
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
	

	;��ȡ�����ڴ洢�������ݵ��̷�
	$Driver=backupDriver()
	If $Driver == 0 Then Return
	
	Global $oldDirSize = 0
	Local $from = $to  ;
	Local $i =1
	For $item In $from 
		;$item_to = $item
		If $i == 3 Then   ; ǿ����64λΪ��׼���ڻָ�ʱ�и��̶��ı�׼λ���ļ���
			$from[$i-1] = "C:\Program Files (x86)\corpname\POPO\users"
		ElseIf $i == 4 Then
			$from[$i-1] = @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im"
		ElseIf $i == 5 Then
			$from[$i-1] = "C:\Program Files (x86)\corpname\corpname EIM" 
		EndIf
		
		$item_end=StringSplit($item,":\",1)		
		$from[$i-1]  = $Driver & @UserName & "\" & $item_end[2]
		$oldDirSize  += Round(DirGetSize($from[$i-1])/1024,1)   ;����ԭ���ļ�������,KB 		
		$i += 1
	Next
	
	;start \\ITTOOL_node1\ITTOOLS\Scripts\ת������.exe
	
	Const $length = $i-1 ;���鳤��
	;�ж�C�̿ռ��Ƿ��㹻���ڴ�Żָ�������
	$driverSpaceFree=Round(DriveSpaceFree("C:\")*1024,1)  ; C�̷�ʣ��ռ�,KB
	If $driverSpaceFree < $oldDirSize Then 
		MsgBox(0,"","C�̿ռ䲻�㣬���������������")
		Return
	EndIf
	
	
	$log = " /MIR /R:0 /NP /LOG+:d:\synclog.txt"
		
	For $i = 1 To $length
			
		$item_to = $to[$i-1]	
		$item_from  = $from[$i-1]
		
		;MsgBox(0,"",$item_from & @LF & $item_to)
		
		Global  $item_dirSize=Round(DirGetSize($item_from)/1024/1024,1)   ;MB ��ǰѭ����ԭλ�ô�С
		ProgressOn("���ڻ�ԭ",  $item_from , "0 %", -1, -1, 16) ;-1�����м����꣬16Ϊ���϶�
		AdlibRegister("showProgress", 250)
		
		ShellExecuteWait("robocopy",'"' & $item_from & '"  ' & '"' & $item_to & '"  ' & $log , "", "",@SW_HIDE)
		
		AdlibUnRegister("showProgress")
		ProgressSet(100, "���", "����״̬:")
		Sleep(100) ;��������ɺ��ͣ��ʱ��
		;$i += 1
	Next
	
	Sleep(3000) ;��������ɺ��ͣ��ʱ��
	ProgressOff() ;�رս�����	
	
	ShellExecute("\\ITTOOL_node1\ITTOOLS\Scripts\��ʱͨ\���뼴ʱͨ��¼.exe");���ü�ʱͨ
	CreateShortcut(); ������ݷ�ʽ��eim\popo\outlook
	
	If FileExists("E:\mail\outlook_prf.reg") Then 
		$choose=MsgBox(1,"","�Ƿ���outlookԭ�˺�������Ϣ ��" & @LF & "ע�����뱸�ݵ��˺�������Ϣ���������ǵ�ǰoutlook���ã������ѡ��")
		If $choose==1 Then
			$reg_import ="reg import E:\mail\outlook_prf.reg"
			Global $command_reg_import[1] = [$reg_import]
			RunAs("ITSuperAdmin","CorpDomain","Password@4",4,runBat($command_reg_import)) 
		EndIf
	EndIf
	
	ShellExecute("explorer",$Driver & @UserName)
	Sleep(1000) 
	WO_rec("dataTrans_Recovery")
	MsgBox(0,"","�˴��ı��������ѻ�ԭ��C�̣���Ŀ¼���������ݿ�����ɾ��")
	
EndFunc

Func CreateShortcut()
	If @OSArch=="X64" Then 
		FileCreateShortcut("C:\Program Files (x86)\corpname\POPO\Start.exe",@DesktopDir & "\����POPO.lnk")
		FileCreateShortcut("C:\Program Files (x86)\corpname\corpname EIM\Start.exe",@DesktopDir & "\���׼�ʱͨ.lnk")
	Else
		FileCreateShortcut("C:\Program Files\corpname\POPO\Start.exe",@DesktopDir & "\����POPO.lnk")
		FileCreateShortcut("C:\Program Files\corpname\corpname EIM\Start.exe",@DesktopDir & "\���׼�ʱͨ.lnk")
	EndIf
	
	$outlookPath = RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE", "path") & "outlook.exe"  ;outlook����·��
	FileCreateShortcut($outlookPath,@DesktopDir & "\outlook.lnk") 
EndFunc




