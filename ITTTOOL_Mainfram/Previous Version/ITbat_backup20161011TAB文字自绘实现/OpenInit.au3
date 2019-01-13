#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=OpenInit.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include "GIFAnimation.au3"
#include "getConf.au3"
#include <File.au3>

;~ OpenInit()




Func OpenInit()
	Global $mylocation=judgeLocation() ;判断所在地
	Global $server_itbat_dir
	
	If $mylocation=='HZ' Then
		$server_itbat_dir = "\\ITTOOL_node1\ITbat\"
	ElseIf $mylocation=='SH' Then
		$server_itbat_dir = "\\ITTOOL_node2\ITbat\"
	EndIf
	
	
	
	
	Global $sTempFolder = @TempDir & "\OW_itbat_materials"
	If Not FileExists($sTempFolder) Then DirCreate($sTempFolder)
	
    ;加载动画、主图标
;~ 	FileInstall("itbat_materials\cat001.gif",@TempDir & "\itbat_materials\cat001.gif")
;~ 	FileInstall("itbat_materials\ITbat.ico", @TempDir & "\itbat_materials\ITbat.ico")
;~ 	RunWait(DirRemove(@TempDir & "\OW_button_capture",1))

    Global $itbat_materials="robocopy " & $server_itbat_dir & "OW_itbat_materials  %temp%\OW_itbat_materials /mir"  ;itbat主框架素材
    Global $tab_icons="robocopy " & $server_itbat_dir & "OW_tab_icons  %temp%\OW_tab_icons /mir"                 ;标签页素材
;~     Global $tab_icons=" "                 ;标签页素材  testing!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    Global $button_icons="robocopy " & $server_itbat_dir & "OW_button_icons  %temp%\OW_button_icons /mir"        ;Button素材
	Local  $fileinstall_materials[3]=[$itbat_materials,$tab_icons,$button_icons]  
	runBatWait($fileinstall_materials)
	
	FileInstall("iRobocopy.exe", @TempDir&"\iRobocopy.exe",1)
	
	Global $sFile = @TempDir& "\OW_itbat_materials\Opening.gif"
	
	Sleep(1000)
	If Not FileExists($sFile) Then
		MsgBox(262192, "tip", "载入失败!")
		Exit
	EndIf
	;__________________________________________________________________________________________
	;加载动画窗口

	; 获取GIF尺寸
	Global $aGIFDimension = _GIF_GetDimension($sFile)
	; Make GUI
;~ 	Global $hGui = GUICreate("ITbatPRO", $aGIFDimension[0], $aGIFDimension[1], 150, 110, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
	Global $hGui = GUICreate("IT部署工具", $aGIFDimension[0], $aGIFDimension[1], -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
	GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
	; GIF job
	Global $hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
	GUICtrlSetTip(-1, "ESC退出")

	; 窗口透明
	GUISetBkColor(345) ; some random color
	_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
	_WinAPI_SetParent($hGui, 0)

	; Show it
	GUISetState(@SW_SHOW )
	
	
	;__________________________________________________________________________________________
	;各种素材初始化
	
	;顶层Button素材：播放、暂停、 关闭
;~ 	Global $play_ico=@TempDir & "\OW_itbat_materials\play.ico"
;~ 	Global $play_next_ico=@TempDir & "\OW_itbat_materials\next.ico"
;~ 	Global $pause_ico=@TempDir & "\OW_itbat_materials\pause.ico"
;~ 	Global $minimize_ico=@TempDir & "\OW_itbat_materials\minimize.ico"

;~ 	Global $close_ico=@TempDir & "\OW_itbat_materials\close_ico.ico"

;~ 	Global $select_ico=@TempDir & "\OW_itbat_materials\Orc Hand.cur"
;~ 	Global $select_oringin_ico=@TempDir & "\OW_itbat_materials\aero_link.cur"
	
	
;~ 	FileInstall("itbat_materials\play.ico", $play_ico)
;~ 	FileInstall("itbat_materials\pause.ico", $pause_ico)
;~ 	FileInstall("itbat_materials\close_ico.ico", $close_ico)
	
	;mp3
;~ 	Global $mp3=@TempDir&"\itbat_materials\Merry Christmas Mr.Lawrence.mp3"
	
;~ 	FileInstall("itbat_materials\Merry Christmas Mr.Lawrence.mp3",$mp3)
	
	

;~ 	TrayTip("","正在初始化......",1)
	TraySetToolTip("正在初始化.......请勿关闭")
	getConf()
	FileCreateShortcut(@ScriptDir & "\IT部署工具.exe" ,@DesktopDir &"\IT部署工具.lnk")
	TraySetToolTip("ITTOOLS")

	GUIDelete($hGui)
EndFunc



Func _SetCursor($s_file, $i_cursor)
   Local $newhcurs, $lResult
   $newhcurs = DllCall("user32.dll", "int", "LoadCursorFromFile", "str", $s_file)
   If Not @error Then
      $lResult = DllCall("user32.dll", "int", "SetSystemCursor", "int", $newhcurs[0], "int", $i_cursor)
      If Not @error Then
         $lResult = DllCall("user32.dll", "int", "DestroyCursor", "int", $newhcurs[0])
      Else
         MsgBox(0, "Error", "Failed SetSystemCursor")
      EndIf
   Else
      MsgBox(0, "Error", "Failed LoadCursorFromFile")
   EndIf
EndFunc  ;==>_SetCursor


Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	FileWriteLine($sFilePath,"set path=%temp%;%path% ")
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc


Func runBatWait($cmd);$cmd must be array
;~ 	MsgBox(0,"",$cmd)
	
    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc