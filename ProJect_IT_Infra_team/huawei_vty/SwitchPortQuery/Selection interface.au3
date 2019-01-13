#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\godmod\端口查询\选择界面.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>

$dir="\\ITTOOL_node1\ITTOOLS\Scripts\godmod\SwitchPortQuery\"
Global $webaddress=""
GETMANUALINPUT($webaddress)
Login($webaddress)

Func Login($webaddress)
	
	If $webaddress == "Area3" Then
;~ 		ShellExecute($dir & "Area3\listen_up_down.exe","",$dir & "Area3","open",@SW_MAXIMIZE)
		Run($dir & "Area3\listen_up_down.exe",$dir & "Area3")
	ElseIf $webaddress == "Area1" Then
		Run($dir & "Area1\listen_up_down.exe",$dir & "Area1")
	ElseIf $webaddress == "Area2" Then
		Run($dir & "Area2\listen_up_down.exe",$dir & "Area2")
	EndIf

	Return	

EndFunc


Func GETMANUALINPUT(ByRef $webaddress) 
	
	;Ico
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("SwitchPortQuery", 303, 110, -1, -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("Please choose area to query", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "Microsoft Yahei")
	;$USERNAMEEDIT = GUICtrlCreateInput(@UserName, 16, 32, 97, 21)
	;$LABEL2 = GUICtrlCreateLabel("@", 120, 32, 20, 24)$webaddress
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$DOMAINCOMBO = GUICtrlCreateCombo("", 74, 35, 137, 40, 3)
	GUICtrlSetData(-1, "Area3|Area1|Area2", "Area3")
    $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 32, 72, 73, 25)
	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 168, 72, 73, 25)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	While 1
		$NMSG = GUIGetMsg()
		Select
			Case $NMSG = $CONFIRMBUTTON
				;$USERDISPLAYNAME = GUICtrlRead($USERNAMEEDIT)
				$webaddress = GUICtrlRead($DOMAINCOMBO)
				GUIDelete()
				WO_rec("SwitchPortQuery")
				Return False
			Case $NMSG = $CANCELBUTTON Or $NMSG = $GUI_EVENT_CLOSE
				GUIDelete()
				Return False
		EndSelect
	WEnd
	GUIDelete()
	Return True
EndFunc   ;==>GETMANUALINPUT


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
