#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
#include "GIFAnimation.au3"
#include "getConf.au3"


;~ OpenInit()
Func OpenInit()
;~ 	Opt("GUICloseOnESC", 1); ESC to exit
	;~ Opt("MustDeclareVars", 1)
	Global $sTempFolder = @TempDir & "\GIFS"
	DirCreate($sTempFolder)
	;~ FileCopy(".\cat001.gif",$sTempFolder,1)
	FileInstall(".\cat001.gif",$sTempFolder& "\cat001.gif",1)
	FileInstall(".\ITbat.ico", @TempDir & "\ITbat.ico", 1)
	Global $sFile = $sTempFolder & "\cat001.gif"
	
	Sleep(1000)
	If Not FileExists($sFile) Then
		MsgBox(262192, "tip", "载入失败!")
		Exit
	EndIf

	; 获取GIF尺寸
	Global $aGIFDimension = _GIF_GetDimension($sFile)
	; Make GUI
	Global $hGui = GUICreate("ITbatPRO", $aGIFDimension[0], $aGIFDimension[1], 150, 110, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
	GUISetIcon(@TempDir & "\ITbat.ico")
	; GIF job
	Global $hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
	GUICtrlSetTip(-1, "ESC退出")

	; 窗口透明
	GUISetBkColor(345) ; some random color
	_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
	_WinAPI_SetParent($hGui, 0)

	; Show it
	GUISetState(@SW_SHOW )

	TrayTip("","正在初始化......",1)
	TraySetToolTip("正在初始化.......请勿关闭")
	getConf()
	TraySetToolTip("ITbatPro")
	TrayTip(""," ",1)
;~ 	MsgBox(0,"","加载完成",1)
	GUIDelete($hGui)
EndFunc



