; 使用 PNG 图片 by Zedna

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <WindowsConstants.au3>

#include "GUI_EnableDragAndResize.au3"
#include "GUICtrlPic.au3" 
#include "Icons.au3" 





Opt("GUIOnEventMode", 1)
; 创建 GUI
Global $g_hGUI = GUICreate("显示 PNG 图片", 900, 600)

GUISetState(@SW_SHOW)
_GUI_EnableDragAndResize($g_hGUI, 900, 600, 900, 600)

;全背景
$backgroud_img=@TempDir & "\itbat_materials\BGstyle\全背景.jpg"
Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,900,600,-1,$WS_EX_LAYERED)
GuiCtrlSetState(-1,$GUI_DISABLE)
GUICtrlSetState($backgroud, $GUI_SHOW)

	;关闭Button
Global $backgroud_img_closeIcon=@TempDir & "\itbat_materials\BGstyle\关闭Button.png"
$backgroud_closeIcon = _GUICtrlPic_Create($backgroud_img_closeIcon , 870, 22, 10,10)
GUICtrlSetOnEvent($backgroud_closeIcon,"close_button")
	

$hovertest=_GUICtrlPic_Create(@TempDir & "\itbat_materials\BGstyle\魔兽世界hoverButton.png" ,600,  + 100 , 115,161)

Global  $hImage, $hGraphic
;~ Global  $hImage2, $hGraphic2


; Load PNG image
_GDIPlus_StartUp()
$hImage   = _GDIPlus_ImageLoadFromFile(@TempDir & "\itbat_materials\BGstyle\魔兽世界hoverButton.png")
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($g_hGUI)
_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 600,  100)
GUICtrlSetOnEvent(-1,"dosh")


;~ $hovertest2=_GUICtrlPic_Create(@TempDir & "\itbat_materials\BGstyle\魔兽世界hoverButton.png" ,400,  + 100 , 115,161)
$hovertest2=GUICtrlCreatePic( "" ,400,  + 100 , 115,161)
$hImage2   = _GDIPlus_ImageLoadFromFile(@TempDir & "\itbat_materials\BGstyle\魔兽世界hoverButton.png")
$hGraphic2 = _GDIPlus_GraphicsCreateFromHWND($g_hGUI)
_GDIPlus_GraphicsDrawImage($hGraphic2, $hImage2, 400,  100)
GUICtrlSetOnEvent(-1,"dosh2")


; Loop until user exits
While 1
	Sleep(1000)
	
WEnd

;~ ; Clean up resources


Func close_button()
	MsgBox(0,"",@GUI_CtrlId)
;~ 	_GDIPlus_GraphicsDispose($hGraphic)
;~ 	_GDIPlus_ImageDispose($hImage)
;~ 	_GDIPlus_ShutDown()

	Exit

EndFunc   ;==>close_button

Func dosh()
	MsgBox(0,"",@GUI_CtrlId)
EndFunc

Func dosh2()
	MsgBox(0,"",@GUI_CtrlId)
EndFunc


; 绘制 PNG 图像
;~ Func MY_WM_PAINT($hWnd, $iMsg, $wParam, $lParam)
;~     #forceref $hWnd, $iMsg, $wParam, $lParam
;~     _WinAPI_RedrawWindow($g_hGUI, 0, 0, $RDW_UPDATENOW)
;~     _GDIPlus_GraphicsDrawImage($g_hGraphic, $g_hImage, 0, 0)
;~     _WinAPI_RedrawWindow($g_hGUI, 0, 0, $RDW_VALIDATE)
;~     Return $GUI_RUNDEFMSG
;~ EndFunc   ;==>MY_WM_PAINT
