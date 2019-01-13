#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Y:\Office\visio2016install.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include<math.au3>
#include<file.au3>



judgeLocation()
autoInstall()

Func judgeLocation()
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		$visio2016="\\ITTOOL_node2\ITTOOLS\SoftwareDeploy\SW_DVD5_Visio_Pro_2016_64Bit_ChnSimp_MLF_X20-42759\setup.exe"

		
		
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
		$visio2016="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\SW_DVD5_Visio_Pro_2016_64Bit_ChnSimp_MLF_X20-42759\setup.exe"

		
	EndIf
	
	Global $runInstall[1]=[$visio2016]
	runBat($runInstall)
    
EndFunc

Func autoInstall()
	WinWaitActive("Microsoft Visio 专业版 2016")
	Send("!A")
	Send("!C")
	Sleep(1000)
	Send("!I")
	While	WinExists("Microsoft Visio 专业版 2016") 
		Sleep(2000) ;用户没有关掉安装界面则等待  
	WEnd
	
	autoActive()
EndFunc

Func autoActive()
	$cmd1="cd C:\Program Files\Microsoft Office\Office16"
	$cmd2="cscript ospp.vbs /sethst:192.168.112.253"
	$cmd3="cscript ospp.vbs /act"
	Global $autoActive[3]=[$cmd1,$cmd2,$cmd3]
	runBat($autoActive)
;~ 	MsgBox(0,"","done")
EndFunc

Func runBat($cmd);$cmd must be array
	
    Local $sFilePath =_TempFile(Default,Default,".bat")
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next

	FileWriteLine($sFilePath,"del %0")
	ShellExecute($sFilePath,"",@UserProfileDir,"open",@SW_HIDE)
	
EndFunc