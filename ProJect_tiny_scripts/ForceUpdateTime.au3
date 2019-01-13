#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\Scripts\ForceUpdateTime.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
$net_use='net use \\dc1 '
$net_time='net time \\dc1 /set /y '
Global $command_rec[2]=[$net_use,$net_time]  
runBat($command_rec)
WO_rec("时间更新")
MsgBox(0,"","时间已更新")

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
	;RunAsWait($sFilePath,"",@SW_DISABLE)
	
	RunAsWait("ITSuperAdmin","CorpDomain","Password@4",0,$sFilePath,"",@SW_DISABLE)
;~ 	RunAsWait("wow",@ComputerName,"Password@2",0,$sFilePath,"",@SW_DISABLE)   ;本地的用法
	
	FileDelete($sFilePath)
	
EndFunc


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc