#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\Tools_Support_Interior.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
;DirRemove(@DesktopDir & "\Tools_Support Interior",1)
DirCopy("\\ITTOOL_node1\ITTOOLS\Scripts\Tools_Support Interior",@DesktopDir & "\Tools_Support Interior",1)
ShellExecute("explorer",@DesktopDir & "\Tools_Support Interior")
MsgBox(0,"","部署已完成，在桌面打开 Tools_Support Interior 文件夹")

WO_rec("部署Tools_Support Interior")


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc