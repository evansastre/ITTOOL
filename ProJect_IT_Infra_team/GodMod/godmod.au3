#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\godmod.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


main()

$dir="\\ITTOOL_node1\ITTOOLS\Scripts\godmod\"
;\\ITTOOL_node1\ITTOOLS\Scripts\godmod\ResetDomainUser.exe
$PROFILEPATH=$dir & "tools.ini"
IniRead($PROFILEPATH, "toollist", "pro1", "'Password@2'") 

Func main()
	Authentication()
	MainWindow()
EndFunc


Func MainWindow()

		#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("GodMod", 640, 150, -1, -1)

	$Button1 = GUICtrlCreateButton("mstsc", 46, 36, 90, 65)
	;GUICtrlSetOnEvent($Button1,"mstscq")

	$Button2 = GUICtrlCreateButton("SwitchConfigBk", 198, 36, 90, 65)
	$Button3 = GUICtrlCreateButton("SwitchPortQuery", 350, 36, 90, 65)
	$Button4 = GUICtrlCreateButton("IPSetting", 502, 36, 90, 65)

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	$dir="\\ITTOOL_node1\ITTOOLS\Scripts\godmod\"
;\\ITTOOL_node1\ITTOOLS\Scripts\godmod\ResetDomainUser.exe

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button1
				mstscq($dir & "mstsc.exe.lnk")
				WO_rec("mstsc")
			Case $Button2
				mstscq($dir & "backup_onekey_telnet.exe")
				WO_rec("SwitchConfigBk")
			Case $Button3
				mstscq($dir & "SwitchPortQuery.exe")
			Case $Button4
				mstscq($dir & "IPset.exe")
			Case $GUI_EVENT_CLOSE
				Exit

		EndSwitch
	WEnd


EndFunc

Func mstscq($tool)
	;ShellExecute($tool,"",@SystemDir,"open",@SW_ENABLE)
	ShellExecute($tool)
EndFunc

#CS

Func run_tool($tool) ; 
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS '
	$run_tool = 'run ' & $tool
    Global $command_run_tool[2]=[$netuse,$run_tool]  
	runBat($command_run_tool)
EndFunc
#CE




Func Authentication()	;
	Local $IT[3]=["ITAdmin1","ITAdmin2","ITAdmin3"]
	$IsITmember= False
	For $member In $IT 
		If $member==@UserName Then
			$IsITmember = True
		EndIf	
	Next

	If $IsITmember==False Then
		$password=InputBox("IT","Access passwd","","*")
		If  $password<>"Password@2" Then
			WO_rec("godmod")
			MsgBox(0,"","Wrong passwd")
			;Lock screen here
			$screenLock="%windir%\System32\rundll32.exe user32.dll,LockWorkStation"
			Global $cmd[1]=[$screenLock]
			runBat($cmd)
			Exit
		EndIf
	EndIf
	
EndFunc

		
	

Func WO_rec($myRec) ;ticket record
	
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\' & $myRec &'.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec

Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd
		FileWriteLine($sFilePath, $i)
	Next
	RunWait($sFilePath, "", @SW_DISABLE)
	FileDelete($sFilePath)
EndFunc   ;==>runBat

