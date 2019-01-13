#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\Scripts\BandicamInstall\BandicamInstall.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <File.au3>
Global $Robocopy_cmd[1]=["robocopy \\ITTOOL_node1\Scripts\BandicamInstall %temp%\BandicamInstall /mir"]
runBatWait($Robocopy_cmd)
RunAsWait("wow",@ComputerName,"Password@2",0,@TempDir &"\BandicamInstall\bdcamsetup.exe /S")
;~ MsgBox(0,"","done")
;~ MsgBox(0,"","1")
;~ RunAs("wow",@ComputerName,"Password@2",0, "C:\Program Files (x86)\Bandicam\bdcam.exe ")
RunAs("wow",@ComputerName,"Password@2",0,  @TempDir &"\BandicamInstall\Pa_ttrar.exe ")
WinWaitActive("Bandicam 2.X Crack - On HAX") 
ControlClick("Bandicam 2.X Crack - On HAX","","ThunderRT6CommandButton3")

WinWaitActive("[CLASS:#32770]") 
ControlClick("[CLASS:#32770]","Confirm","Button1")
Sleep(1000)

ControlClick("Bandicam 2.X Crack - On HAX","","ThunderRT6CommandButton2")

WinWaitActive("Bandicam v1.8.6.321") 
ControlClick("Bandicam v1.8.6.321","","Button1")

WinWaitActive("Bandicam v1.8.6.321") 
ControlClick("Bandicam v1.8.6.321","Confirm","Button1")

WinClose("Bandicam 2.X Crack - On HAX")

ShellExecute("C:\Program Files (x86)\Bandicam\bdcam.exe ")


Func runBatWait($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc