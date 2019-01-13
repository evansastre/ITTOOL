#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AutoIt3Wrapper_OutFile=Y:\IGSA部署.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Language=2052
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
While ProcessExists("IGSA.exe") 
	ProcessClose("IGSA.exe");关闭即时通
WEnd


DirRemove("D:\IGSA20120510",1); 删除历史版本


DirRemove("D:\IGSA",1)
If FileExists("D:\IGSA") Then
	MsgBox(0,"","删除旧版本失败，请重试或联系IT")
EndIf


$Tip = "tip"
TrayTip($Tip,"IGSA下载中，请耐心等耐","",1)

$netuse='net use \\ITTOOL_node1\ITTOOLS '

$robo_IGSA="robocopy \\ITTOOL_node1\ITTOOLS\Scripts\IGSA D:\IGSA /mir "
Global $command_rec[2]=[$netuse,$robo_IGSA]  
runBat($command_rec)

TrayTip($Tip,"完成","",1)
Sleep(1000)

FileDelete(@DesktopDir&"\IGSA*") ; *为通配符，删除其他的快捷方式
FileCreateShortcut("D:\IGSA\IGSA.exe",@DesktopDir & "\IGSA.exe.lnk","D:\IGSA")

SendKeepActive("Program Manager") ;刷新桌面k
For $i = 1 to 5;How many times
    Sleep(100)
    Send("{F5}")
Next
MsgBox(0,"","IGSA部属已完成")
ShellExecute("D:\IGSA\IGSA.exe","","D:\IGSA")
WO_rec("部署IGSA")

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
	RunWait($sFilePath,"",@SW_DISABLE)
	
	
	FileDelete($sFilePath)
EndFunc



Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
