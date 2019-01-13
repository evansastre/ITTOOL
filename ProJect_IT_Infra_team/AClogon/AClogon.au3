#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\AClogon\AClogon.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include<math.au3>
#include <File.au3>
;~ MsgBox(0,'',judgeLocation())


$mylocation=judgeLocation() 
If $mylocation='SH' Then
	$file='\\ITTOOL_node1\AClogon\ACSH\corpnameAC.ini'
	$acserver=IniRead($file,"ACserver","server","server")
	$acport=IniRead($file,"ACserver","port","noport")
	$acpwd=IniRead($file,"ACserver","pwd","nopwd")
	
	$logon_ac="start \\ITTOOL_node1\AClogon\ACSH\logon.exe  " &  $acserver & " "& $acport & " " & $acpwd

	Local $cmd[1]=[$logon_ac]
	runBat($cmd)
Else
	$file='\\ITTOOL_node1\AClogon\ACHZ\corpnameAC.ini'
	$acserver=IniRead($file,"ACserver","server","server")
	$acport=IniRead($file,"ACserver","port","noport")
	$acpwd=IniRead($file,"ACserver","pwd","nopwd")
	$logon_ac= "start \\ITTOOL_node1\AClogon\ACHZ\logon.exe  " &  $acserver & " "& $acport & " " & $acpwd

	Local $cmd[1]=[$logon_ac]

	runBat($cmd)

EndIf


Func judgeLocation()
	
	Local $location
	$sh=Ping("dc1") 
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
	EndIf
	
	Return $location
EndFunc

Func runBat($mycmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $mycmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc