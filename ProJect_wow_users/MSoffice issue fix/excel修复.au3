#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\excel�޸�.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

main()

Func main()
	closeExcel()
	$path=RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\excel.exe", "Path") & "excel.exe"
	ShellExecute($path)

	$Title="Microsoft Excel"
	$res=WinWait($Title,"",10)
	If $res==0 Then Exit
	WinActivate($Title,"")
	Send("!F") ;�򿪡��ļ���
	$version=GETOUTLOOKPRODUCTVERSION()
	If $version==14 Then
		Send("!T")
		Send("{down 5}")
	;~ 	Send("!O" 3 )
		Send("!{O 3}" )
		Send("{Space}")
		Sleep(2000)
		MsgBox(0,"","��[�߼�]->[����]�·��ҵ� " & @LF & _
					"[����ʹ�ö�̬���ݽ���(DDE)������Ӧ�ó���]��" & @LF & _
					"ȷ�ϵ�ǰ״̬Ϊ 'Cancel��ѡ' , ���excel�����е�[Confirm]������excel���ɡ�")
		WO_rec("excel_Fix")
	ElseIf	$version==12  Then
		Send("!I")
		Send("{down 4}")
	;~ 	Send("!O" 3 )
		Send("!{O 3}" )
		Send("{Space}")
		Sleep(2000)
		
		MsgBox(0,"","��[�߼�]->[����]�·��ҵ� " & @LF & _
					"[����ʹ�ö�̬���ݽ���(DDE)������Ӧ�ó���]��" & @LF & _
					"ȷ�ϵ�ǰ״̬Ϊ 'Cancel��ѡ'  , ���excel�����е�[Confirm]������excel���ɡ�")
		WO_rec("excel�޸�")
	EndIf
EndFunc


Func closeExcel()
	If ProcessExists("excel.exe") Then 
		$res=MsgBox(1,"","��Confirmexcel���ѹر�")
		If $res==1 Then
			closeExcel()
			Return
		ElseIf $res==2 Then
			Exit
		EndIf
	EndIf
EndFunc

Func GETOUTLOOKPRODUCTVERSION()  ;���ذ汾��
	$VERSIONSTRING = RegRead("HKEY_CLASSES_ROOT\Outlook.Application\CurVer", "")
	If $VERSIONSTRING = "" Or StringLen($VERSIONSTRING) <= 2 Then Return ""
	$VERSIONTOKEN = StringRight($VERSIONSTRING, 2)
	Return $VERSIONTOKEN
EndFunc   ;==>GETOUTLOOKPRODUCTVERSION


Func WO_rec($myRec) ;ticket record
	
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\' & $myRec &'.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec

Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd
		FileWriteLine($sFilePath, $i)
	Next
	RunWait($sFilePath, "", @SW_DISABLE)
	FileDelete($sFilePath)
EndFunc   ;==>runBat



;~ If WinActive($Title,"")<>0 Then MsgBox(0,"","True")





