#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include "GIFAnimation.au3"
#include "getConf.au3"
#include <File.au3>

;~ OpenInit()




Func OpenInit()
	Global $mylocation=judgeLocation()
	Global $server_itbat_dir
	
	If $mylocation=='HZ' Then
		$server_itbat_dir = "\\ITTOOL_node1\ITTOOLS\Conf\ITbat\"
	ElseIf $mylocation=='SH' Then
		$server_itbat_dir = "\\ITTOOL_node2\ITTOOLS\Conf\ITbat\"
	EndIf
	
	
	Global $sTempFolder = @TempDir & "\itbat_materials"
	If Not FileExists($sTempFolder) Then DirCreate($sTempFolder)
	
    ;加载动画、主图标
;~ 	FileInstall("itbat_materials\cat001.gif",@TempDir & "\itbat_materials\cat001.gif")
;~ 	FileInstall("itbat_materials\ITbat.ico", @TempDir & "\itbat_materials\ITbat.ico")
    Global $itbat_materials="robocopy " & $server_itbat_dir & "itbat_materials  %temp%\itbat_materials /mir"
    Global $button_icons="robocopy " & $server_itbat_dir & "button_icons  %temp%\button_icons /mir"
	Local  $fileinstall_materials[2]=[$itbat_materials,$button_icons]  
	runBatWait($fileinstall_materials)
	
	
	Global $sFile = @TempDir& "\itbat_materials\cat001.gif"
	
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
	Global $hGui = GUICreate("ITbatPRO", $aGIFDimension[0], $aGIFDimension[1], -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
	GUISetIcon(@TempDir & "\itbat_materials\ITbat.ico")
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
	Global $play_ico=@TempDir & "\itbat_materials\play.ico"
	Global $play_next_ico=@TempDir & "\itbat_materials\next.ico"
	Global $pause_ico=@TempDir & "\itbat_materials\pause.ico"
	Global $minimize_ico=@TempDir & "\itbat_materials\minimize.ico"
	Global $close_ico=@TempDir & "\itbat_materials\close_ico.ico"

	Global $select_ico=@TempDir & "\itbat_materials\Orc Hand.cur"
	Global $select_oringin_ico=@TempDir & "\itbat_materials\aero_link.cur"
;~ 	FileInstall("itbat_materials\play.ico", $play_ico)
;~ 	FileInstall("itbat_materials\pause.ico", $pause_ico)
;~ 	FileInstall("itbat_materials\close_ico.ico", $close_ico)
	
	;mp3
;~ 	Global $mp3=@TempDir&"\itbat_materials\Merry Christmas Mr.Lawrence.mp3"
	
;~ 	FileInstall("itbat_materials\Merry Christmas Mr.Lawrence.mp3",$mp3)
	
	

;~ 	TrayTip("","正在初始化......",1)
	TraySetToolTip("正在初始化.......请勿关闭")
	getConf()
	TraySetToolTip("ITbatPro")
;~ 	TrayTip(""," ",1)
;~ 	MsgBox(0,"","加载完成",1)
	GUIDelete($hGui)
EndFunc


;~ Global Const $OCR_APPSTARTING = 32650
;~ Global Const $OCR_NORMAL = 32512
;~ Global Const $OCR_CROSS = 32515
;~ Global Const $OCR_HAND = 32649
;~ Global Const $OCR_IBEAM = 32513
;~ Global Const $OCR_NO = 32648
;~ Global Const $OCR_SIZEALL = 32646
;~ Global Const $OCR_SIZENESW = 32643
;~ Global Const $OCR_SIZENS = 32645
;~ Global Const $OCR_SIZENWSE = 32642
;~ Global Const $OCR_SIZEWE = 32644
;~ Global Const $OCR_UP = 32516
;~ Global Const $OCR_WAIT = 32514
;==================================================================
; $s_file - file to load cursor from
; $i_cursor - system cursor to change
;==================================================================
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
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc


Func runBatWait($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc