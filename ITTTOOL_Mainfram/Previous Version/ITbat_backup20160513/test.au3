
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

;~ 	Opt("TrayMenuMode", 3) ; Ĭ�����̲˵���Ŀ��������ʾ, ��ѡ����ĿʱҲ�����. TrayMenuMode ������ѡ��Ϊ 1, 2.
;~ 	Opt("TrayOnEventMode", 1) ; �������� OnEvent �¼�����֪ͨ.

;~ 	TrayCreateItem("����...")
;~ 	Global $version = "1.00003"
;~ 	TrayCreateItem("") ; �����ָ���.
;~ 	TrayCreateItem("�˳�")
;~ 	TraySetState($TRAY_ICONSTATE_SHOW) ; ��ʾ���̲˵�.

	;������������������������������������������������������������������������������������������������������������������������������
	;�����


;~ 	Global $Form1 = GUICreate("ITbatPRO", 800, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU), $WS_EX_WINDOWEDGE)
	
;~ 	GUISetBkColor(0x282828); ������͸��ɫ
;~ 	GUISetBkColor(0xd1d2d3); ������͸��ɫ
;~ 	GUISetBkColor(0xffee5e); ������͸��ɫ
;~ 	GUISetBkColor(0x75a9d1); ������͸��ɫ
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
;~ 			MsgBox(0,"","����򿪳�ʱ��������",10)
;~ 			Return
;~ 		EndIf
	WEnd

EndFunc