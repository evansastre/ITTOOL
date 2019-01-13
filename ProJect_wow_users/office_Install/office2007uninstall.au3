#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Y:\Office\office2007uninstall.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include<math.au3>
#include<file.au3>



judgeLocation()

Func judgeLocation()
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		$office2007="\\ITTOOL_node2\ITTOOLS\SoftwareDeploy\office2007\setup.exe"
		
		
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
		$office2007="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\office2007\setup.exe"
		
	EndIf
	
	Global $mycmd[1]=[$office2007]
	runBat($mycmd)
;~ 	MsgBox(0,"",$location)
EndFunc



Func runBat($cmd);$cmd must be array
	
    Local $sFilePath =_TempFile(Default,Default,".bat")
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
;~ 	MsgBox(0,"",$cmd)
	FileWriteLine($sFilePath,"del %0")
	ShellExecute($sFilePath,"","","open",@SW_HIDE)
	
EndFunc