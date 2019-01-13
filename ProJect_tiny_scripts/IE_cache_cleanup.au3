#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#PRE_OutFile_x64=Y:\IE_cache_cleanup.exe
#PRE_Res_Language=2052
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include<file.au3>
$cmd1='RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 10'
$cmd2='del /s /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"'
$cmd3='del /s /f /q "%userprofile%\AppData\Local\Microsoft\Windows\INetCache\*.*"'
Global $mycmd[3]=[$cmd1,$cmd2,$cmd3]

runBatWait($mycmd)


Func runBatWait($cmd);$cmd must be array
	
    Local $sFilePath =_TempFile(Default,Default,".bat")
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
;~ 	MsgBox(0,"",$cmd)
	FileWriteLine($sFilePath,"del %0")
	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)
	MsgBox(0,"","完成清理")
EndFunc