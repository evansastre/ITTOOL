#include <File.au3>

If $CmdLine[0]==0 Then
	MsgBox(0,"","无传入参数")
	Exit
EndIf

Global $mycmd=$CmdLine[1];定义同步的源目录

Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	
	RunWait($sFilePath,"",@SW_DISABLE)
;~ 	Run($sFilePath,"",@SW_HIDE,$RUN_CREATE_NEW_CONSOLE)
	
	FileDelete($sFilePath)
EndFunc