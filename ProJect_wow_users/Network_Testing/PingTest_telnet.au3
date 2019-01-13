#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=PingTest_telnet.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****



$tool="telnet"
$ipaddress=$CmdLine[1]

$cmd = $tool & " " & $ipaddress 
$pause="pause>>nul"
Global $command_cmd[2] = [$cmd,$pause]
runBat($command_cmd,@SW_MAXIMIZE)

;~ ShellExecute("C:\Windows\System32\telnet.exe")


Func runBat($cmd,$SW);$cmd must be array
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd
		FileWriteLine($sFilePath, $i)
	Next
	RunWait($sFilePath, "", $SW)
	
	
	FileDelete($sFilePath)
EndFunc   ;==>runBat