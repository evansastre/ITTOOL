#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\excel修复.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

main()

Func main()
	closeExcel()
	$path=RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\excel.exe", "Path") & "excel.exe"
	ShellExecute($path)

	$Title="Microsoft Excel"
	$res=WinWait($Title,"",10)
	If $res==0 Then Exit
	WinActivate($Title,"")
	Send("!F") ;打开“文件”
	$version=GETOUTLOOKPRODUCTVERSION()
	If $version==14 Then
		Send("!T")
		Send("{down 5}")
	;~ 	Send("!O" 3 )
		Send("!{O 3}" )
		Send("{Space}")
		Sleep(2000)
		MsgBox(0,"","在[高级]->[常规]下方找到 " & @LF & _
					"[忽略使用动态数据交换(DDE)的其他应用程序]，" & @LF & _
					"确认当前状态为 'Cancel勾选' , 点击excel界面中的[Confirm]后重启excel即可。")
		WO_rec("excel_Fix")
	ElseIf	$version==12  Then
		Send("!I")
		Send("{down 4}")
	;~ 	Send("!O" 3 )
		Send("!{O 3}" )
		Send("{Space}")
		Sleep(2000)
		
		MsgBox(0,"","在[高级]->[常规]下方找到 " & @LF & _
					"[忽略使用动态数据交换(DDE)的其他应用程序]，" & @LF & _
					"确认当前状态为 'Cancel勾选'  , 点击excel界面中的[Confirm]后重启excel即可。")
		WO_rec("excel修复")
	EndIf
EndFunc


Func closeExcel()
	If ProcessExists("excel.exe") Then 
		$res=MsgBox(1,"","请Confirmexcel都已关闭")
		If $res==1 Then
			closeExcel()
			Return
		ElseIf $res==2 Then
			Exit
		EndIf
	EndIf
EndFunc

Func GETOUTLOOKPRODUCTVERSION()  ;返回版本号
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





