#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=\\hsh-d-863\E$\test5_x64.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
;~ Global $timemark = ' ' & @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC 
;~ MsgBox(0,"",$starttime)
#include<file.au3>

$timemark = '-' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & '-' & @MIN & '-' & @SEC 
Local $copytxt[1]=['copy %temp%\NetTestPro_speed.txt  "' & @ScriptDir&'\NetTestPro_speed'  & $timemark &  '.txt"' ]
runBat($copytxt)
;~ FileCopy(@TempDir&"\NetTestPro_speed.txt",@ScriptDir&"\NetTestPro_speed"  & $timemark &  ".txt")


;~ $res=FileCopy(@TempDir&"\NetTestPro_speed.txt",@ScriptDir&"\NetTestPro_speed"  & $timemark &  ".txt")
;~ MsgBox(0,"",$res)
;~ MsgBox(0,"",@error)



Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc