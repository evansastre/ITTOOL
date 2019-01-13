#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\AClogon\AClogon_manual.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include<math.au3>
#include <File.au3>
;~ MsgBox(0,'',judgeLocation())


While ProcessExists("logon.exe")
	ProcessClose("logon.exe")
WEnd



$mylocation=judgeLocation() 
If $mylocation='SH' Then
	$file='\\ITTOOL_node1\AClogon\ACSH\corpnameAC.ini'
	$acserver=IniRead($file,"ACserver","server","server")
	$acport=IniRead($file,"ACserver","port","noport")
	$acpwd=IniRead($file,"ACserver","pwd","nopwd")
	
	$logon_ac="start \\ITTOOL_node1\AClogon\ACSH\logon.exe  " &  $acserver & " "& $acport & " " & $acpwd

	Local $cmd[1]=[$logon_ac]
	WO_rec($acserver)
	runBat($cmd)
	MsgBox(0,"tip","Recertified network permissions, please revisit restricted address or app")
Else
	$file='\\ITTOOL_node1\AClogon\ACHZ\corpnameAC.ini'
	$acserver=IniRead($file,"ACserver","server","server")
	$acport=IniRead($file,"ACserver","port","noport")
	$acpwd=IniRead($file,"ACserver","pwd","nopwd")
	$logon_ac= "start \\ITTOOL_node1\AClogon\ACHZ\logon.exe  " &  $acserver & " "& $acport & " " & $acpwd
;~ 	MsgBox(0,"",$logon_ac)
;~ 	Exit

	Local $cmd[1]=[$logon_ac]
	WO_rec($acserver)
	runBat($cmd)
	MsgBox(0,"tip","Recertified network permissions, please revisit restricted address or app")

EndIf


Func judgeLocation()
	
	Local $location
	$sh=Ping("dc1") 
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;
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


Func WO_rec($ACSeverAddr) ;ticket record
	
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\ACconnect.txt"'
	$cur_Time=@YEAR &'-'&@MON &'-'& @MDAY &' '& @HOUR & ':' & @MIN & ':' & @SEC 
	$rec='echo ' & @UserName & "   " & @ComputerName & "   " &  $ACSeverAddr & "       "  &  $cur_Time & '>> %rec%'

    Global $command_rec[3]=[$netuse,$rec_file,$rec]  
	runBat($command_rec)
EndFunc





