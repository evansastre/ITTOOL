#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Y:\Office\office2016uninstall.exe
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
		$office2016="\\ITTOOL_node2\ITTOOLS\SoftwareDeploy\SW_DVD5_Office_Professional_Plus_2016_64Bit_ChnSimp_MLF_X20-42426\setup.exe"
		
		
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
		$office2016="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\SW_DVD5_Office_Professional_Plus_2016_64Bit_ChnSimp_MLF_X20-42426\setup.exe"
		
	EndIf
	
;~ 	MsgBox(0,"",$office2016)
;~ 	Exit
	
	Global $mycmd[1]=[$office2016&" /uninstall  "]
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