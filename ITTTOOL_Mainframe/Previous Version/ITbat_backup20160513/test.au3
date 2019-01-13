
#include <ButtonConstants.au3>
#include <GuiButton.au3>
#include <WinAPI.au3>
#include <WinAPIEx.au3>
#include <GuiTab.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>
#include <Misc.au3>
#include "OpenInit.au3"
#include "play_backgroundmusic.au3"
#include "GUI_EnableDragAndResize.au3"
#include <TrayConstants.au3>
MainWindow()
Func MainWindow()
;~ 	Opt("GUIResizeMode", 1)
;~ 	Opt("GUIOnEventMode", 1)

;~ 	Opt("TrayMenuMode", 3) ; 默认托盘菜单项目将不会显示, 当选定项目时也不检查. TrayMenuMode 的其它选项为 1, 2.
;~ 	Opt("TrayOnEventMode", 1) ; 启用托盘 OnEvent 事件函数通知.

;~ 	TrayCreateItem("关于...")
;~ 	Global $version = "1.00003"
;~ 	TrayCreateItem("") ; 创建分隔线.
;~ 	TrayCreateItem("退出")
;~ 	TraySetState($TRAY_ICONSTATE_SHOW) ; 显示托盘菜单.

	;———————————————————————————————————————————————————————————————
	;主框架


;~ 	Global $Form1 = GUICreate("ITbatPRO", 800, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU), $WS_EX_WINDOWEDGE)
	
;~ 	GUISetBkColor(0x282828); 背景黑透明色
;~ 	GUISetBkColor(0xd1d2d3); 背景黑透明色
;~ 	GUISetBkColor(0xffee5e); 背景黑透明色
;~ 	GUISetBkColor(0x75a9d1); 背景黑透明色
;~ 	GUISetCursor(2,0)
;~ 	_GUI_EnableDragAndResize($Form1, 800, 600, 800, 600)


	Global $Form1 = GUICreate("ITbatPRO", 800, 600, -1, -1)
;~ 	GUISetIcon(@TempDir & "\itbat_materials\ITbat.ico")
	Global $close_ico=@TempDir & "\itbat_materials\close_ico.ico"
	Global $backgroud_img=@TempDir & "\itbat_materials\background.jpg"
;~ 	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,800,600)
	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,800,600,$WS_CLIPSIBLINGS)
;~ 	GUICtrlSetState($backgroud, $GUI_DISABLE)
	GUICtrlSetState($backgroud, $GUI_SHOW)


	GUISetState(@SW_SHOWNORMAL)
	While 1
		Sleep(100)
;~ 		_GUI_DragAndResizeUpdate($Form1)
;~ 		GUISetState(@SW_SHOWNORMAL )

;~ 		$end_time=_TimeToTicks(@HOUR, @MIN, @SEC)
;~ 		If ($end_time-$start_time>$play_time) Then
;~ 			MsgBox(0,"","程序打开超时，请重启",10)
;~ 			Return
;~ 		EndIf
	WEnd

EndFunc