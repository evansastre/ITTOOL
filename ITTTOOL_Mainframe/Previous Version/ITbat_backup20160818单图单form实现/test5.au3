#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=X:\OW_itbat_materials\ITbat.ico
#AccAu3Wrapper_OutFile=ITTOOLS.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****


;~ #include <ButtonConstants.au3>
;~ #include <GuiButton.au3>
#include <WinAPI.au3>
#include <WinAPIEx.au3>
;~ #include <GuiTab.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>		
#include <Misc.au3>
#include <TrayConstants.au3>
#include "OpenInit.au3"
#include "play_backgroundmusic.au3"
#include "GUI_EnableDragAndResize.au3"
#include "GUICtrlPic.au3" 

#include "GUICtrlOnHover.au3"

#include "Icons.au3"
#include "GuiCtrlCreatePNG.au3"

#include <ScreenCapture.au3>




If _Singleton("ITTOOLS1", 1) = 0 Then
	MsgBox(0, "", "ITbatPRO已经运行");Prevent repeated opening of the program
	Exit
EndIf

$hStarttime = _Timer_Init() ;计时
OpenInit()




MainWindow()
Func MainWindow()
	
	;当前版本号
;~ 	Global $version = "版本 1.00004" & @LF &  "Designed By IT & YW_UED"
	Global $version = "1.00005"
	
	;模式定义
;~ 	Opt("GUIResizeMode", 1)
;~ 	Opt("GUIOnEventMode", 1)
;~ 	Opt("TrayMenuMode", 3) ; 默认托盘菜单项目将不会显示, 当选定项目时也不检查. TrayMenuMode 的其它选项为 1, 2.
;~ 	Opt("TrayOnEventMode", 1) ; 启用托盘 OnEvent 事件函数通知.


	;角标tip
	TrayCreateItem("关于...")
	TrayCreateItem("") ; 创建分隔线.
	TrayCreateItem("退出")

	TraySetState($TRAY_ICONSTATE_SHOW) ; 显示托盘菜单.


	;———————————————————————————————————————————————————————————————
	;主框架

	Global $Form1 = GUICreate("ITbatPRO1", 900, 600, -1, -1 ,BitOR($WS_SYSMENU, $WS_POPUP), $WS_EX_TOOLWINDOW)
	$Form4 = GUICreate("childform", 400,300, 160,55, $WS_CHILD,"", $Form1)
	$a_idBtn1 =GUICtrlCreatePic("C:\Users\TestUser1\AppData\Local\Temp\OW_button_icons\test.jpg" ,0, 0 , 115,161,$WS_GROUP)
	
	$Form2 = GUICreate("Choices Dialog", 345, 252, 30, 30, $WS_CHILD,"", $Form1)
	$Form3 = GUICreate("Tabbed Notebook Dialog", 420, 320, 30, 30, $WS_CHILD,"", $Form1)
	
	
	
	
	GUISwitch($Form1)
;~ 	GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
;~ 	GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore") ;
;~ 	GUISetBkColor(0x282828); 背景黑透明色
;~ 	GUISetCursor(2,1)
	
	
	
	GUISetState(@SW_SHOW,$form1)
;~ 	_GUI_EnableDragAndResize($Form1, 900, 600, 900, 600)
	


 

	;全背景
	$backgroud_img=@TempDir & "\OW_itbat_materials\BGstyle\全背景.jpg"
;~ 	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,900,600,-1,$WS_EX_LAYERED)
	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,900,600,$WS_CLIPSIBLINGS)
;~ 	Global $backgroud = GUICtrlCreatePic("",0,0,900,600,-1,$WS_EX_LAYERED)
;~ 	GUICtrlSetImage($backgroud,$backgroud_img)

	GuiCtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetState($backgroud, $GUI_SHOW)



	$Button1 = GUICtrlCreateButton("X", 528, 40, 75, 25, $WS_GROUP)
	$Button2 = GUICtrlCreateButton("窗口2", 528, 88, 75, 25, $WS_GROUP)
	$Button3 = GUICtrlCreateButton("窗口3", 528, 136, 75, 25, $WS_GROUP)
;~ 	$Button3 = GUICtrlCreateButton("窗口3", 528, 136, 75, 25, $WS_GROUP)
	
	;侧边栏
	
	_GDIPlus_StartUp() ;启动GDI+
	

	;IT工具logo,左上角
	Global $backgroud_img_topIcon=@TempDir & "\OW_itbat_materials\BGstyle\IT工具-logo.png"
	$backgroud_topIcon = _GUICtrlPic_Create($backgroud_img_topIcon , 10, 7, 145, 37)
	;关闭Button
	Global $backgroud_img_closeIcon=@TempDir & "\OW_itbat_materials\BGstyle\关闭Button.png"
	$backgroud_closeIcon = _GUICtrlPic_Create($backgroud_img_closeIcon , 870, 22, 10,10)
	$backgroud_minimizeIcon = GUICtrlCreateLabel("v", 851, 15, 10,20)
	GUICtrlSetColor(-1,0xFFFFFF)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,11,"","","微软雅黑")
	
	

;~ 	GUISetState(@SW_HIDE, $Form1)
	GUISetState(@SW_SHOW,$Form4)
	
	Local $Current = ""
	GUISetState(@SW_SHOW, $Form1)
	
	While 1
		$nMsg = GUIGetMsg()
        Switch $nMsg
                Case $GUI_EVENT_CLOSE
                        Exit
                Case $Button1
                        If $Current <> "" Then GUISetState(@SW_HIDE, $Current)
                        GUISetState(@SW_SHOW, $Form2)
                        $Current = $Form2
                Case $Button2
                        If $Current <> "" Then GUISetState(@SW_HIDE, $Current)
                        GUISetState(@SW_SHOW, $Form3)
                        $Current = $Form3                        
                Case $Button3
                        If $Current <> "" Then GUISetState(@SW_HIDE, $Current)
                        GUISetState(@SW_SHOW, $Form4)
                        $Current = $Form4                        
        EndSwitch
	WEnd
	
EndFunc
