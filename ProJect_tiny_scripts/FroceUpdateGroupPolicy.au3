#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AutoIt3Wrapper_OutFile=Y:\FroceUpdateGroupPolicy.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Language=2052
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****

$command1="gpupdate /force"
$command2="pause >nul"
Global $command[2]=[$command1,$command2]  
WO_rec("FroceUpdateGroupPolicy")
runBat($command)


TrayTip("tip", "完成", "", 1)
Sleep(1000)

$choose = MsgBox(1, "tip", "需要重启计算使某些策略生效，要重启吗？")
If $choose == 1 Then
	Shutdown(2)
	Exit
ElseIf $choose == 2 Then
	MsgBox(0, "tip", "请手动完成重启")
	Exit
EndIf



Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	;Run(@ComSpec & " /c "& "explorer " &@TempDir)
	RunWait($sFilePath)
	
	
	FileDelete($sFilePath)
EndFunc


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
