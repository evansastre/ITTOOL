#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=itbat_materials\ITbat.ico
#AccAu3Wrapper_OutFile=ITbatPRO.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****


;~ #AccAu3Wrapper_Icon=itbat_materials\ITbat.ico
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



If _Singleton("ITbatPRO", 1) = 0 Then
	MsgBox(0, "", "ITbatPRO已经运行");Prevent repeated opening of the program
	Exit
EndIf

$hStarttime = _Timer_Init() ;计时
OpenInit()
;~ MsgBox(0,"",_Timer_Diff($hStarttime))  ;×××××××××××××××××显示初始化时常

;~ MsgBox(0,"","accesstoolsNum:"&$AccesstoolsNum)
;~ _ArrayDisplay($AccessTools) ;显示所有用户可访问的工具

;~ MsgBox(0,"",$AccessTools[0])

;~ _ArrayDisplay($AccessCommandText) ;显示所有用户可访问的命令
;~ _ArrayDisplay($AccessDescribe) ;显示所有用户可访问的描述
;~ _ArrayDisplay($AccessCategory) ;显示所有用户可访问的描述
;~ exit

;~ MsgBox(0,"",$PROFILEPATH)






MainWindow()
Func MainWindow()
	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)

	Opt("TrayMenuMode", 3) ; 默认托盘菜单项目将不会显示, 当选定项目时也不检查. TrayMenuMode 的其它选项为 1, 2.
	Opt("TrayOnEventMode", 1) ; 启用托盘 OnEvent 事件函数通知.

	TrayCreateItem("关于...")
	TrayItemSetOnEvent(-1, "show_version")
	Global $version = "1.00003"
	TrayCreateItem("") ; 创建分隔线.
	TrayCreateItem("退出")
	TrayItemSetOnEvent(-1, "close_button")
	TraySetState($TRAY_ICONSTATE_SHOW) ; 显示托盘菜单.

	;———————————————————————————————————————————————————————————————
	;主框架
;~ 	Global $Form1 = GUICreate("ITbatPRO", 800, 600,-1, -1, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))

	Global $Form1 = GUICreate("ITbatPRO", 800, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU), $WS_EX_WINDOWEDGE)
	GUISetIcon(@TempDir & "\itbat_materials\ITbat.ico")
	GUISetBkColor(0x282828); 背景黑透明色
;~ 	GUISetBkColor(0xd1d2d3); 背景
;~ 	GUISetBkColor(0xffee5e); 背景
;~ 	GUISetBkColor(0x75a9d1); 背景
	GUISetCursor(2,0)
	
	
;~ 	$backgroud_img=@TempDir & "\itbat_materials\background.jpg"
;~ 	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,800,600,-1,$WS_EX_LAYERED)
;~ 	GuiCtrlSetState(-1,$GUI_DISABLE)

;~ 	GUICtrlSetState($backgroud, $GUI_SHOW)

	_GUI_EnableDragAndResize($Form1, 800, 600, 800, 600)
	
    ;顶层Button
	;———————————————————————————————————————————————————————————————
	Global $play_button = GUICtrlCreateIcon($play_ico, -1, 10, 10, 38, 32)
	GUICtrlSetResizing(-1, 2 + 768)
	GUICtrlSetTip(-1, "play")
	GUICtrlSetOnEvent($play_button, "play_button")
	GUICtrlSetState($play_button, $GUI_HIDE)

	Global $pause_button = GUICtrlCreateIcon($pause_ico, -1, 10, 10, 38, 32)
	GUICtrlSetResizing(-1, 2 + 768)
	GUICtrlSetTip(-1, "pause")
	GUICtrlSetOnEvent($pause_button, "pause_button")
;~ 	GUICtrlSetState($pause_button,$GUI_HIDE)
	GUICtrlSetState($pause_button, $GUI_SHOW)


	Global $close_button = GUICtrlCreateIcon($close_ico, -1, 750, 10, 38, 32)
	GUICtrlSetResizing(-1, 4 + 768)
;~ 	GUICtrlSetDefBkColor(0x282828)
	GUICtrlSetTip(-1, "quit")
	GUICtrlSetOnEvent($close_button, "close_button")
	GUICtrlSetState($close_button, $GUI_SHOW)

	$version_label = GUICtrlCreateLabel($version, 750, 580, 50, 12)

;~ 	Global $minimize_button=GUICtrlCreateIcon($minimize_ico, -1, 690, 10,38,32)
;~ 	GUICtrlSetResizing(-1,4+768)
;~ 	GUICtrlSetTip(-1,"minimize")
;~ 	GUICtrlSetOnEvent ( $minimize_button, "minimize_button" )
;~ 	GUICtrlSetState($minimize_button,$GUI_SHOW )
;~ 	;———————————————————————————————————————————————————————————————
	
	;标签页
;~ 	Global $idTab = GUICtrlCreateTab(10, 50, 780, 500, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY, $TCS_FLATBUTTONS,$TCS_OWNERDRAWFIXED), $WS_EX_WINDOWEDGE);$WS_EX_DLGMODALFRAME    $TCS_SCROLLOPPOSITE
	Global $idTab = GUICtrlCreateTab(10, 50, 780, 500, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY), $WS_EX_WINDOWEDGE);$WS_EX_DLGMODALFRAME    $TCS_SCROLLOPPOSITE
;~ 	GUICtrlSetBkColor($idTab,0x282828); 背景黑透明色
	GUICtrlSetResizing(-1, 802)
;~  	GUICtrlSetResizing(-1,1)
;~ 	GUICtrlSetDefBkColor(0x282828)
;~ 	GUICtrlSetDefBkColor($COLOR_WHITE)
;~ 	GUICtrlSetFont(-1,12)
;~ 	GUICtrlSetFont(-1,11, $FW_MEDIUM  ,"MS Sans Serif")
	GUICtrlSetFont(-1, 11, $FW_MEDIUM, "", "微软雅黑")

	;收集同一分类下的所有工具编号
	Global $Categorysnum = 0 ;定义分类数
	Global $Categorys[0][2] ;存放分类
	For $i = 0 To $AccesstoolsNum - 1
		$res = _ArraySearch($Categorys, $AccessCategory[$i])
		If $res == -1 Then
			$this_init = String($AccessCategory[$i] & "|" & $i)
			_ArrayAdd($Categorys, $this_init)
			$Categorysnum += 1
		Else
			$Categorys[$res][1] = $Categorys[$res][1] & "&" & $i
		EndIf
	Next



	_SetCursor($select_ico, $OCR_HAND) ;鼠标在Button上的悬停指针
	
	Global $a_idTab[$Categorysnum]
	Global $btnID_toolTag[0][2]
	;初始化所有标签、Button
	For $i = 0 To $Categorysnum - 1
;~ 		MsgBox(0,"",$Categorys[$i][0])

		$a_idTab[$i] = GUICtrlCreateTabItem($Categorys[$i][0])
		GUICtrlSetResizing(-1, 802)
;~ 		$a_idTab[$i]=_GUICtrlTab_Create($Form1,$Categorys[$i][0])
;~ 		GUISetFont(12)
;~ 		GUICtrlSetFont(-1,12)
;~ 		GUICtrlSetColor(-1,$COLOR_RED)

;~ 		GUICreate("", 500, 300, 40, 80, $WS_POPUP, $WS_EX_MDICHILD, $Form1)
;~ 		GUICtrlCreateListView("1|2|3|4|5|6",40, 80, 700, 400)
		
		$tmp_arr = StringSplit($Categorys[$i][1], "&")
		$this_button_nums = $tmp_arr[0] ;当前分类的Button数量
		
		Local $a_idBtn[$this_button_nums]
		Local $a_idLab[$this_button_nums]

		For $j = 0 To $this_button_nums - 1
			$tool_tag = $tmp_arr[$j + 1] ;工具在数组中的标号
			Local $row = Int($j / 7)

			
;~ 			$a_idBtn[$j] = GUICtrlCreateButton($Accesstools[$tool_tag],100*Mod($j,7)+40,$row*100+100,80,50,BitOR($BS_MULTILINE,$BS_ICON,$BS_FLAT),$WS_EX_COMPOSITED)
;~ 			$a_idBtn[$j] = GUICtrlCreateButton($Accesstools[$tool_tag],100*Mod($j,7)+40,$row*100+100,80,50,BitOR($BS_MULTILINE,$BS_ICON,$BS_FLAT),$WS_EX_TRANSPARENT)
;~ 			$a_idBtn[$j] = GUICtrlCreateButton($Accesstools[$tool_tag],100*Mod($j,7)+40,$row*100+100,80,50,$BS_ICON,$WS_EX_TRANSPARENT)
			
			If $AccessIco[$tool_tag] == "" Then
				$this_ico = @TempDir & "\button_icons\default.ico"
			Else
				$this_ico = @TempDir & "\button_icons\" & $AccessIco[$tool_tag]
			EndIf
			
;~ 			$a_idBtn[$j] = GUICtrlCreateIcon($this_ico, -1, 100 * Mod($j, 7) + 56, $row * 100 + 100, 48, 48, $GUI_SS_DEFAULT_PIC)
			$a_idBtn[$j] = GUICtrlCreateIcon($this_ico, -1, 100 * Mod($j, 7) + 56, $row * 100 + 100, 48, 48)
;~ 			MsgBox(0,"","ID:"&$a_idBtn[$j])
;~ 			_GUICtrlButton_SetText($a_idBtn[$j],$Accesstools[$tool_tag])
			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)
;~ 			GUICtrlSetBkColor(-1, $COLOR_RED)
;~ 			GUICtrlSetBKColor(-1,0xFFFFFF)
;~ 			GUICtrlSetColor(-1,0x000000)


			#CS
				;button时的方法
				If $AccessIco[$tool_tag]=="" Then
				GUICtrlSetImage(-1,@TempDir & "\button_icons\default.ico")
				Else
				GUICtrlSetImage(-1,@TempDir & "\button_icons\" & $AccessIco[$tool_tag])
				EndIf
			#CE


			GUICtrlSetResizing(-1, 802)
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)

			;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
;~ 			_WinAPI_SetCursor($select_ico)
;~ 			GUICtrlSetCursor(-1,$hCursor)
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetOnEvent(-1, "autoCmd")


			$len = StringLen($Accesstools[$tool_tag])
			$this_label = StringMid($Accesstools[$tool_tag], 2, $len - 2)
			$a_idLab[$j] = GUICtrlCreateLabel($this_label, 100 * Mod($j, 7) + 40, $row * 100 + 150, 80, 50, $SS_CENTER)
			GUICtrlSetFont(-1, 9.5, 550, "", "微软雅黑")
;~ 			GUICtrlSetColor(-1,$COLOR_WHITE)
			GUICtrlSetResizing(-1, 802)


		Next
		
	Next
;~ 	_ArrayDisplay($btnID_toolTag)
	;____________________________________________________________________________________________________________________
;~ 	$AccessCategory,$AccesstoolsNum,$Accesstools,
;~ 	Global $CommandText
;~ 	$AccessCommandText  $AccessDescribe   $AccessCategory


	;______________________________________________________________
	
	;-----------------------------------------------------------------------------------------------------------------------------------------------------

	GUICtrlCreateTabItem(""); 结束选项标签页的定义
;~ 	GUISetState(@SW_SHOW)
	GUISetState(@SW_SHOWNORMAL)

	play_backgroundmusic()
	pause_button()
	
;~     $start_time=_TimeToTicks(@HOUR, @MIN, @SEC)
;~ 	$end_time=$start_time
	
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

EndFunc   ;==>MainWindow



Func autoCmd()
;~ 	$button_text=_GUICtrlButton_GetText(@GUI_CtrlHandle) ;Button文本，即Button的名称

;~ 	MsgBox(0,"",$button_text)
	Local $btnID = @GUI_CtrlId
	For $j = 0 To $AccesstoolsNum
		If $btnID == $btnID_toolTag[$j][0] Then
			$tool_tag = $btnID_toolTag[$j][1]
;~ 			MsgBox(0,"",StringStripWS($Accesstools[$tool_tag],8))
			$tip = StringStripWS($Accesstools[$tool_tag], 8)
			TrayTip("", $tip & " 正在执行", 3)
			runBat(show_button_commandtext($AccessCommandText[$tool_tag]))
			Return ;只运行找到的这个Button的，循环不必继续，这里就可以返回了
		EndIf
	Next


	
EndFunc   ;==>autoCmd

Func autoCmdd() ; button的设计方法，此处无实际用处
	$button_text = _GUICtrlButton_GetText(@GUI_CtrlHandle) ;Button文本，即Button的名称

	MsgBox(0, "", $button_text)
	MsgBox(0, "", $button_text)
	
	Local $Tab_curSel = _GUICtrlTab_GetCurSel($idTab)
	$tmp_arr = StringSplit($Categorys[$Tab_curSel][1], "&")
	$this_button_nums = $tmp_arr[0] ;当前分类的Button数量

	For $j = 0 To $this_button_nums - 1
		Local $tool_tag = $tmp_arr[$j + 1] ;工具在数组中的标号
;~ 			MsgBox(0,"",$Accesstools[$tool_tag])
		If $Accesstools[$tool_tag] == $button_text Then
;~ 				MsgBox(0,"",$AccessCommandText[$tool_tag])
			runBat(show_button_commandtext($AccessCommandText[$tool_tag]))
;~ 				MsgBox(0,"","done")
			Return ;只运行找到的这个Button的，循环不必继续，这里就可以返回了
		EndIf
	Next
;~ 	$AccessCategory,$AccesstoolsNum,$Accesstools,
;~ 	Global $CommandText
;~ 	$AccessCommandText  $AccessDescribe   $AccessCategory
	
EndFunc   ;==>autoCmdd

Func play_button()
	GUICtrlSetState($play_button, $GUI_HIDE)
	_SoundResume($aSound)
	GUICtrlSetState($pause_button, $GUI_SHOW)
EndFunc   ;==>play_button

Func pause_button()
	GUICtrlSetState($pause_button, $GUI_HIDE)
	_SoundPause($aSound)
	GUICtrlSetState($play_button, $GUI_SHOW)
EndFunc   ;==>pause_button

Func minimize_button()
	MsgBox(0, "", "111")
	GUISetState($Form1, @SW_HIDE)
EndFunc   ;==>minimize_button

Func close_button()
	_SoundClose($aSound);退出播放
	_SetCursor(@WindowsDir & "\Cursors\aero_link.cur", $OCR_HAND)
	
	$wait="choice /t 2 /d y /n >nul"
	$update_itbat="robocopy \\fs02\补丁\IT部署的工具  D:\IT部署的工具 /mir"
	Local $update_itbat_cmd[2]=[$wait,$update_itbat]  
	runBat($update_itbat_cmd)
	Exit

EndFunc   ;==>close_button

Func show_version()
	MsgBox(0,"","当前版本："&$version)

EndFunc   ;==>show_version









Func show_button_commandtext($string)
	Local $a[0]
	Local $tmp_arr = StringSplit($string, "***thisisanotherline***", 1)
	Local $linenum = $tmp_arr[0]
	Local $s = ""
	For $i = 1 To $linenum - 1
		_ArrayAdd($a, $tmp_arr[$i])
	Next
	
	Return $a
EndFunc   ;==>show_button_commandtext

Func show_button_describe($string)
	Local $tmp_arr = StringSplit($string, "***thisisanotherline***", 1)
	Local $linenum = $tmp_arr[0]
	Local $s = ""
	For $i = 1 To $linenum - 1
		$s &= $tmp_arr[$i] & @LF
	Next

;~ 	MsgBox(0,"",$s)
	Return $s
EndFunc   ;==>show_button_describe



Func Authentication() ;身份验证
	Local $IT[7] = ["s1615", "s0523", "s0636", "s0752", "h0616", "h3883", "TestUser1"]
	$IsITmember = False
	For $member In $IT
		If $member == @UserName Then
			$IsITmember = True
		EndIf
	Next

	If $IsITmember == False Then
		$password = InputBox("IT专用", "开启密码", "", "*")
		If $password <> "Password@2" Then
			WO_rec()
			MsgBox(0, "", "密码错误")
			$screenLock = "%windir%\System32\rundll32.exe user32.dll,LockWorkStation"
			Global $cmd[1] = [$screenLock]
			runBat($cmd)
			Exit
		EndIf
	EndIf
	
EndFunc   ;==>Authentication



Func WO_rec() ; 密码验证错误时记录
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\godmod.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec






