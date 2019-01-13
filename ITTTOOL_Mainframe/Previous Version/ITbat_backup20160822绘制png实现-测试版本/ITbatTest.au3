#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=X:\OW_itbat_materials\ITbat.ico
#AccAu3Wrapper_OutFile=\\fs02\补丁\IT部署的工具\ITTOOLS.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****



#include <WinAPI.au3>
#include <WinAPIEx.au3>
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
;~ #include "GUICtrlPic.au3" 

#include "GUICtrlOnHover.au3"

#include "Icons.au3"
;~ #include "GuiCtrlCreatePNG.au3"


If _Singleton("ITTOOLS", 1) = 0 Then
	MsgBox(0, "", "ITTOOLS经运行");Prevent repeated opening of the program
	Exit
EndIf

OpenInit()

;~ MsgBox(0,"",_Timer_Diff($hStarttime))  ;×××××××××××××××××显示初始化时常
;~ MsgBox(0,"","accesstoolsNum:"&$AccesstoolsNum)
;~ _ArrayDisplay($AccessTools) ;显示所有用户可访问的工具
;~ _ArrayDisplay($AccessCommandText) ;显示所有用户可访问的命令
;~ _ArrayDisplay($AccessDescribe) ;显示所有用户可访问的描述
;~ _ArrayDisplay($AccessCategory) ;显示所有用户可访问的描述


InitSetting()
MainWindow()


Func InitSetting() ;基本元素绘制
	;当前版本号
	Global $version = "1.00006"
	
	;模式定义
;~ 	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)
	Opt("TrayMenuMode", 3) ; 默认托盘菜单项目将不会显示, 当选定项目时也不检查. TrayMenuMode 的其它选项为 1, 2.
	Opt("TrayOnEventMode", 1) ; 启用托盘 OnEvent 事件函数通知.

	;角标tip
	TrayCreateItem("关于...")
	TrayItemSetOnEvent(-1, "show_version")
	TrayCreateItem("") ; 创建分隔线.
	TrayCreateItem("退出")
	TrayItemSetOnEvent(-1, "close_button")
	TraySetState($TRAY_ICONSTATE_SHOW) ; 显示托盘菜单.


	Global $Width = 900, $Height = 600
	_GDIPlus_Startup()
	
	Global $hGUI = GUICreate("ITTOOLS", $Width, $Height, -1, -1, $WS_CAPTION, $WS_EX_LAYERED)
	GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
	
	
	
	
	#region 窗体背景
	;_________________________________________________________________________________________________________
	Global $bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\全背景.jpg")
	Global $hGraphic = _GDIPlus_ImageGetGraphicsContext($bg)


;~ 	Global $Bgbitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
;~ 	Global $hGraphic2 = _GDIPlus_ImageGetGraphicsContext($Bgbitmap)
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $bg, 0, 0, $Width, $Height)
;~ 	

			;左上角logo
	Global $logo = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\IT工具-logo.png")

	
	;最小化Button
	Global $hBrush = _GDIPlus_BrushCreateSolid(0xffff9c00)
	Global $hFormat = _GDIPlus_StringFormatCreate()
	Global $hFamily = _GDIPlus_FontFamilyCreate("微软雅黑")
	Global $hFont = _GDIPlus_FontCreate($hFamily, 11, 0)
	Global $tLayout = _GDIPlus_RectFCreate(841, 17, 10,20)

	
	  ;最小化Button
	$minimize_btn = GUICtrlCreateLabel("_", 841, 22-30, 20,20)
	GUICtrlSetOnEvent($minimize_btn,"minimize_button")
	
	
	;关闭Button
	$close = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\关闭Button.png")

	
	;关闭Button
	$close_btn = GUICtrlCreateLabel("X", 870, 22-30, 20,20)
	GUICtrlSetOnEvent($close_btn,"close_button")
	
	
	
	;显示版本号，右下角
	Global $hBrush2 = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Global $hFormat2 = _GDIPlus_StringFormatCreate()
	Global $hFamily2 = _GDIPlus_FontFamilyCreate("微软雅黑")
	Global $hFont2 = _GDIPlus_FontCreate($hFamily2, 9, 0)
	Global $tLayout2 = _GDIPlus_RectFCreate(835, 575, 55, 25)
	
		


	;_________________________________________________________________________________________________________

	
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

;~ 	_SetCursor($select_ico, $OCR_HAND) ;鼠标在Button上的悬停指针
	Global $btnID_toolTag[0][2] ;ID号、工具标号
	
	;初始化所有标签、form、Button
	Global  $MyTabsPics[0][4]  ; 加载的png图片句柄存到数组中 , normal , hover ,clicked , position
	Global $a_idTab[$Categorysnum] ;初始化TAb的ID
	Global $a_idForm[$Categorysnum];初始化TAB对应的formID 
	Global $sideForm[0];初始化当前tab对应form的子form，当当前form的工具数超过18时生成
	Global $lastPressedTab[2]=["NO",0];最后一次点击的tabButton， 存储tabid
;~ 	Global $lastHoverTab[2];最后一次悬浮的tabButton， 存储tabid、图标id
	
	

	Global $Bgbitmaps[$Categorysnum]
	Global $hGraphics[$Categorysnum]
	
	
	
	For $i = 0 To $Categorysnum - 1 ;给每个bitmap放入素材
		
		$Bgbitmaps[$i]= _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
		$hGraphics[$i]=_GDIPlus_ImageGetGraphicsContext($Bgbitmaps[$i])
		_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $bg, 0, 0, $Width, $Height)
			
			
		;左上角logo
		_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $logo,  10, 7, 145, 37)
		
		;最小化Button
		_GDIPlus_GraphicsDrawStringEx($hGraphics[$i], "——", $hFont, $tLayout, $hFormat, $hBrush)
		

		;关闭Button
		_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $close,  870, 22, 10,10)
		
		
		;显示版本号，右下角
		_GDIPlus_GraphicsDrawStringEx($hGraphics[$i], $version, $hFont2, $tLayout2, $hFormat2, $hBrush2)
		
	Next

	
	
	For $i = 0 To $Categorysnum - 1
		
	
		
		;标签页Button图片初始化
		Local $this_categotys=$Categorys[$i][0]
		Local $this_normal_png=@TempDir & "\OW_tab_icons\"& $this_categotys  &"-默认Button.png"   
		Local $this_normal=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-默认Button.png")

		If Not FileExists($this_normal_png)  Then
			MsgBox(0,"",$this_normal_png & "  不存在")
			Local $this_categotys="战网客户端同步"
			Local $this_normal=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-默认Button.png")
		EndIf
		
		Local $this_hover=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-HOVERButton.png")
		Local $this_clicked=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-点击后Button.png")
		_ArrayAdd($MyTabsPics,$this_normal&"|"&$this_hover& "|" &$this_clicked & "|"& 55 + $i*40)  ; 加载的png图片句柄存到数组中
		
		
		For $j = 0 To $Categorysnum - 1
;~ 		For $j = 0 To 2
			
			If $j==$i Then
				_GDIPlus_GraphicsDrawImageRect($hGraphics[$j], $this_clicked,  0 , 55 + $i*40 , 160,40)
			Else
				_GDIPlus_GraphicsDrawImageRect($hGraphics[$j], $this_normal,  0 , 55 + $i*40 , 160,40)
			EndIf
			
;~ 			
		Next



		If $i==0 Then
;~ 			;初始化点击第一个tab
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
			$lastPressedTab[0]=$a_idTab[0]
;~ 			
			Global $now_hover_tab=-1 ;初始化TAB的hover状态为-1
			Global $now_hover_j=-1 ;初始化button的hover状态为-1
;~ 			
			;初始化所有label,即Button的标题
			Global $labels[18]
			For $j=0 To 17 
				
				Local $row = Int($j / 6)	
				Local $x=15+Mod($j, 6)*(115+4)
				Local $y=15 + $row*(161+4)
				

				$labels[$j]=GUICtrlCreateLabel(" 123", $x+15 +160    ,   $y+80.5+55  +10 , 85, 50, $SS_CENTER)
				GUICtrlSetColor(-1,0xFFFFFF)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1,9,"","","微软雅黑")
				
			Next
;~ 			
;~ 			;初始化所有标题
;~ 			
;~ 		Else
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
		EndIf


	Next


	
	;按上或下或TAB(等同按下)可以进行选择调整
	Global $up = GUICtrlCreateButton("up", 0, 0, 10, 10)
	GUICtrlSetOnEvent(-1,"HotKeyPressed")
	GUICtrlSetState($up,$GUI_HIDE)
    Global $down = GUICtrlCreateButton("down", 10, 0, 10, 10)
	GUICtrlSetOnEvent(-1,"HotKeyPressed")
	GUICtrlSetState($down,$GUI_HIDE)
    Global $tab =  GUICtrlCreateButton("tab", 20, 0, 10, 10)
	GUICtrlSetOnEvent(-1,"HotKeyPressed")
	GUICtrlSetState($tab,$GUI_HIDE)
	Global $aAccelKeys[3][2] = [["{UP}", $up],["{DOWN}", $down],["{TAB}", $tab]]
    GUISetAccelerators($aAccelKeys)


	;为流畅的 GFX 对象动作创建缓冲图形框架
;~ 	Global $g_hBitmap = _GDIPlus_BitmapCreateFromGraphics(900, 600, $g_hGraphic)
;~     Global $g_hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
	
	
	Global  $MyButtonsPics[0][5]  ; 加载的png图片句柄存到数组中 , normal , hover , x ,y , i_idform
	Global $Form_Button_ID[$Categorysnum][3] ;存储formiID和其下拥有的label文字、buttonID
;~ 	
	
	
;~ 	SetBitmap($hGUI, $Bgbitmap)
	GUISetState()
	
	
EndFunc


Func MainWindow()





;~ 	$testB= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\魔兽世界-默认Button.png")
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testB,49.5 +160, 49.5+55, 46,46)

;~ 	$testA= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\魔兽世界hoverButton.png")
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testA,15 +160, 15+55+3, 115,161)




#CS
	Global $g_hBitmap = _GDIPlus_BitmapCreateFromGraphics(900, 600, $g_hGraphic)
    Global $g_hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
	_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt, $backgroud_img_topIcon_load, 10, 7, 145, 37) ;绘制位图到后备缓冲区
	_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt, $backgroud_img_closeIcon_load, 870, 22, 10,10) ;绘制位图到后备缓冲区
	
	
#CE

	;———————————————————————————————————————————————————————————————
	;主框架
;~ 	Global $Form1 = GUICreate("ITTOOLS", 900, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU,$WS_EX_LAYERED ), $WS_EX_ACCEPTFILES)
;~ 	Global $Form1 =  GUICreate("ITTOOLS_btn", 900, 600-30, 0, 30, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
	Global $Form1 =  GUICreate("ITTOOLS_btn", 160, 600-30, 0, 30, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
	GUISetBkColor(0x123456, $Form1)
	
;~ 	_GDIPlus_Startup()
	Global $g_hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form1) ;全局的图像

;~ 	GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore",$Form1) ;
;~ 	GUISetOnEvent($GUI_EVENT_DROPPED, "MainFormRenew",$Form1) ;
;~ 	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "MainFormRenew",$Form1) ; 
;~ 	

;~ 	$test_label = GUICtrlCreateLabel("7.00000", 160, 55-25, 115,161)
	$test_label = GUICtrlCreateLabel("7.00000", 160, 0, 115,161)
	GUICtrlSetColor(-1,0xFFFFFF)
	;~ GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,9,"","","微软雅黑")
	GUICtrlSetTip(-1, "haaatesttest")
;

;~ 	_API_SetLayeredWindowAttributes($Form1, 0x123456, 195)
	GUISwitch($Form1)
	GUISetState(@SW_SHOW,$Form1)
	GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
;~ 	_GUI_EnableDragAndResize($Form1, 900, 600, 900, 600)
	

	;———————————————————————————————————————————————————————————————
	
	
;~ 	Global $hGraphics[$Categorysnum] 

;~ 	Global $Bgbitmaps[$Categorysnum] = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
;~ 	Global $hGraphics[$Categorysnum] = _GDIPlus_ImageGetGraphicsContext($Bgbitmap)
;~ 	
	
;~ 	SetBitmap($hGUI, $Bgbitmap)

	

	
	For $i = 0 To $Categorysnum - 1
		$a_idTab[$i] =GUICtrlCreateLabel("" ,0 ,  $i*40 , 160,40)
		_GUICtrl_OnHoverRegister(-1, "TAB_Hover_Proc", "TAB_Leave_Hover_Proc", "TAB_PrimaryDown_Proc", "TAB_PrimaryUp_Proc")
		GUICtrlSetOnEvent(-1,"TAB_CLICK")
		
		
;~ 		$a_idForm[$i]=GUICreate("childform"&$i, 900-160,600-55, 160,55, $WS_CHILD,"", $hGUI)
		$a_idForm[$i]=GUICreate("childform"&$i, 900-160,600-55-30, 160,55, $WS_POPUP,BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
;~ 		Global $Form1 =  GUICreate("ITTOOLS_btn", 900, 600-30, 0, 30, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
		
		$tmp_arr = StringSplit($Categorys[$i][1], "&")
		$this_button_nums = $tmp_arr[0] ;当前分类的Button数量
;~ 		MsgBox(0,"",$this_button_nums)
		If $this_button_nums>18 Then $this_button_nums=18 ;测试用
		
		Local $page_num=Int($this_button_nums/18+1) -1 ;-1为测试用
		Local  $a_idBtn[$this_button_nums]
		
		
		$Form_Button_ID[$i][0]=$a_idForm[$i]
		
				

		
		For $j = 0 To $this_button_nums - 1  
			
			$tool_tag = $tmp_arr[$j + 1] ;工具在数组中的标号
			Local $row = Int($j / 6)
			
			If $AccessIco[$tool_tag] == "" Or (Not FileExists(@TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png")) Then
				$this_normal_png = @TempDir & "\OW_button_icons\default.png"
				$this_hover_png = @TempDir & "\OW_button_icons\default-hoverButton.png"
			Else
				$this_normal_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png"
				$this_hover_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag]& "-hoverButton.png"
			EndIf

			
			Local $this_normal=_GDIPlus_ImageLoadFromFile($this_normal_png)
			Local $this_hover=_GDIPlus_ImageLoadFromFile($this_hover_png)


;~ 			_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $this_normal,  160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46)
;~ 			MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;绘制Button图标

			Local $x=15+Mod($j, 6)*(115+4)
			Local $y=15 + $row*(161+4)
			_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $this_normal,  160+37.5+$x , 55+37.5+$y , 46,46)
			
			
			$a_idBtn[$j] =GUICtrlCreateLabel("" ,$x , $y , 115,161)
;~ 			GUICtrlSetOnEvent(-1,"autoCmd")
			_GUICtrl_OnHoverRegister(-1, "BUTTON_Hover_Proc", "BUTTON_Leave_Hover_Proc", "BUTTON_PrimaryDown_Proc", "BUTTON_PrimaryUp_Proc")
			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)  ;Button的ID、标号存入数组，以便cmd调用
			;悬停描述
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)
			
			_ArrayAdd($MyButtonsPics,$this_normal&"|"&$this_hover & "|"&  $x & "|"& $y & "|"& $a_idForm[$i])  ; 加载的png图片句柄存到数组中
			
			;Button的标题
			$len = StringLen($Accesstools[$tool_tag])
			$this_label = StringMid($Accesstools[$tool_tag], 2, $len - 2) ;
			
;~ 			$Form_Button_ID[$i][2]=$a_idBtn[$j] 
			
			If $j==0 Then
				$Form_Button_ID[$i][1]=$this_label
				$Form_Button_ID[$i][2]=$a_idBtn[$j] 
			Else
				$Form_Button_ID[$i][1] = $Form_Button_ID[$i][1] & "|" & $this_label
				$Form_Button_ID[$i][2] = $Form_Button_ID[$i][2] & "|" & $a_idBtn[$j]
			EndIf
		
		Next	
		
		If $i==0 Then
;~ 			SetBitmap($hGUI, $Bgbitmaps[$i])
		EndIf
		
		
	Next
	
	
	SetBitmap($hGUI, $Bgbitmaps[2])
;~ 	GUISetState()
	GUISetState(@SW_SHOW, $a_idForm[2])
#CS



	For $i = 0 To $Categorysnum - 1
				
		$a_idForm[$i]=GUICreate("childform"&$i, 900-160,600-55, 160,55, $WS_CHILD,"", $Form1)
		
		$tmp_arr = StringSplit($Categorys[$i][1], "&")
		$this_button_nums = $tmp_arr[0] ;当前分类的Button数量
;~ 		MsgBox(0,"",$this_button_nums)
		If $this_button_nums>18 Then $this_button_nums=18 ;测试用
		
		Local $page_num=Int($this_button_nums/18+1) -1 ;-1为测试用
		Local  $a_idBtn[$this_button_nums]
		
		
		$Form_Button_ID[$i][0]=$a_idForm[$i]
		
				
		
		For $j = 0 To $this_button_nums - 1  
			
			$tool_tag = $tmp_arr[$j + 1] ;工具在数组中的标号
			Local $row = Int($j / 6)
			
			If $AccessIco[$tool_tag] == "" Or (Not FileExists(@TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png")) Then
				$this_normal_png = @TempDir & "\OW_button_icons\default.png"
				$this_hover_png = @TempDir & "\OW_button_icons\default-hoverButton.png"
			Else
				$this_normal_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png"
				$this_hover_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag]& "-hoverButton.png"
			EndIf

			
			Local $this_normal=_GDIPlus_ImageLoadFromFile($this_normal_png)
			Local $this_hover=_GDIPlus_ImageLoadFromFile($this_hover_png)


			Local $x=15+Mod($j, 6)*(115+4)
			Local $y=15 + $row*(161+4)
			$a_idBtn[$j] =GUICtrlCreatePic("" ,$x , $y , 115,161)
			GUICtrlSetOnEvent(-1,"autoCmd")
			_GUICtrl_OnHoverRegister(-1, "BUTTON_Hover_Proc", "BUTTON_Leave_Hover_Proc", "BUTTON_PrimaryDown_Proc", "BUTTON_PrimaryUp_Proc")
			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)  ;Button的ID、标号存入数组，以便cmd调用
			;悬停描述
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)
			
			_ArrayAdd($MyButtonsPics,$this_normal&"|"&$this_hover & "|"&  $x & "|"& $y & "|"& $a_idForm[$i])  ; 加载的png图片句柄存到数组中
			
			;Button的标题
			$len = StringLen($Accesstools[$tool_tag])
			$this_label = StringMid($Accesstools[$tool_tag], 2, $len - 2) ;
			
;~ 			$Form_Button_ID[$i][2]=$a_idBtn[$j] 
			
			If $j==0 Then
				$Form_Button_ID[$i][1]=$this_label
				$Form_Button_ID[$i][2]=$a_idBtn[$j] 
			Else
				$Form_Button_ID[$i][1] = $Form_Button_ID[$i][1] & "|" & $this_label
				$Form_Button_ID[$i][2] = $Form_Button_ID[$i][2] & "|" & $a_idBtn[$j]
			EndIf
		
		Next	

		
	Next		
	
	
#CE

	
	
	

;~ 	MainFormRestore() ;初始绘制		
;~ 	GUISetState( @SW_SHOW ,$a_idForm[0])

	
	Global $hStarttime = _Timer_Init()
	Global $last_state=15 ;初始状态为15，激活态。之后代表最后的状态
	While 1
		
		
		Global $timelast=_Timer_Diff($hStarttime)
		
		Global $now_state=WinGetState("ITTOOLS")

;~ 		If $timelast>3000 Then
;~ 			MainFormRenew()
;~ 			$hStarttime= _Timer_Init()
;~ 			MsgBox(0,"",$now_state,1)
;~ 			$hStarttime= _Timer_Init()
;~ 		EndIf
			


;~ 		_GUILock($Form1)
		
	WEnd
	

EndFunc   ;==>MainWindow





Func _API_SetLayeredWindowAttributes($hwnd, $i_transcolor, $Transparency = 255, $isColorRef = False)

        Local Const $AC_SRC_ALPHA = 1

        Local Const $ULW_ALPHA = 2

        Local Const $LWA_ALPHA = 0x2

        Local Const $LWA_COLORKEY = 0x1

        If Not $isColorRef Then

                $i_transcolor = Hex(String($i_transcolor), 6)

                $i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))

        EndIf

        Local $Ret = DllCall("user32.dll", "int", "SetLayeredWindowAttributes", "hwnd", $hwnd, "long", $i_transcolor, "byte", $Transparency, "long", $LWA_COLORKEY + $LWA_ALPHA)

        If @error Then

                Return SetError(@error, 0, 0)

        ElseIf $Ret[0] = 0 Then

                Return SetError(4, 0, 0)

        Else

                Return 1

        EndIf

EndFunc   ;==>_API_SetLayeredWindowAttributes


Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam) ;命令消息回调函数
        Dim $iIDFrom = BitAND($iwParam, 0xFFFF)
        Dim $iCode = BitShift($iwParam, 16)
        Dim $hControl = GUICtrlGetHandle($iIDFrom)
;~         Switch $iIDFrom
;~                 Case $hTestBtn
;~                         Switch $iCode
;~                                 Case 0
;~                                         MsgBox(0,"测试Button！", GUICtrlRead($hText))
;~                         EndSwitch
;~                 Case $hExitBtn
;~                         Switch $iCode
;~                                 Case 0
;~                                         jindt()
;~                         EndSwitch
;~         EndSwitch
EndFunc

Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
        Local $nID = BitAND($wParam, 0x0000FFFF)
        Switch $nID
                Case 0xf060
                        If $hWnd = $HGui Then
                                Exit
                        Else
                                GUIDelete($hWnd)
                        EndIf
        EndSwitch
EndFunc   ;==>WM_SYSCOMMAND

Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
        Switch $hWnd
                Case $hGUI
                        Switch $iMsg
                                Case $WM_NCHITTEST
                                        Return $HTCAPTION
                        EndSwitch
        EndSwitch
        Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NCHITTEST

Func SetBitmap($hGUI, $hImage, $iOpacity = 255)
        Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
        $hScrDC = _WinAPI_GetDC(0)
        $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
        $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
        $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
        $tSize = DllStructCreate($tagSIZE)
        $pSize = DllStructGetPtr($tSize)
        DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
        DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
        $tSource = DllStructCreate($tagPOINT)
        $pSource = DllStructGetPtr($tSource)
        $tBlend = DllStructCreate($tagBLENDFUNCTION)
        $pBlend = DllStructGetPtr($tBlend)
        DllStructSetData($tBlend, "Alpha", $iOpacity)
        DllStructSetData($tBlend, "Format", 1)
        _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
        _WinAPI_SelectObject($hMemDC, $hOld)
        _WinAPI_ReleaseDC(0, $hScrDC)
        _WinAPI_DeleteDC($hMemDC)
        _WinAPI_DeleteObject($hBitmap)
EndFunc   ;==>SetBitmap

Func _GUILock($hGUI) ;边界检测与还原

#CS
        Local $aPos = WinGetPos($hGUI), _
                        $iX = $aPos[0], $iY = $aPos[1], $iWidth = $aPos[2], $iHeight = $aPos[3]
						
		
        If $now_state == 23 Then  Return ;  ;23为最小化时的状态码
		If $now_state <> 15 And 	$timelast >3000 Then
			MainFormRenew()
			$hStarttime= _Timer_Init()
		EndIf
		
		
		If $now_state <> $last_state  Then ; 状态改变时，刷新窗口
			
			MainFormRenew()
			$last_state=$now_state
;~ 			$hStarttime= _Timer_Init()
		EndIf
		
		
		
			

        ;边界检测功能，暂时去掉
		If $iX < 0  Then
                $iX = 0
				WinMove($hGUI, '', $iX, $iY)
				MainFormRenew()
        ElseIf $iX + $iWidth > @DesktopWidth Then
                $iX = @DesktopWidth - $iWidth
				WinMove($hGUI, '', $iX, $iY)
				MainFormRenew()
		EndIf
		
        If $iY < 0   Then
                $iY = 0
				WinMove($hGUI, '', $iX, $iY)
				MainFormRenew()
        ElseIf $iY + $iHeight > @DesktopHeight Then
                $iY = @DesktopHeight - $iHeight
				WinMove($hGUI, '', $iX, $iY)
				MainFormRenew()
        EndIf

#CE

        
EndFunc   ;==>_GUILock



Func search_buttonID($this_buttonID)
	For $j = 0 To $AccesstoolsNum
		If $this_buttonID == $btnID_toolTag[$j][0] Then
;~ 			Return $btnID_toolTag[$j][1] ;这个值代表Button在数组中的编号，而不是序数
			Return $j
		EndIf
	Next
EndFunc

Func setTagRECT($left,$top,$right,$bottom)
	Global $struct = DllStructCreate($tagRECT)			;struct erstellen
	DllStructSetData($struct,"Left" , 	$left) 	;hier die parameter eingeben
	DllStructSetData($struct,"Top", 	$top)	;struct beschreiben 
	DllStructSetData($struct,"Right", 	$right)
	DllStructSetData($struct,"Bottom",	$bottom)
	Global $Pointer = DllStructGetPtr($struct)
	
	Return $Pointer
EndFunc

Func MY_FORM_PAINT_CLEAR()	
	$Pointer =setTagRECT(160,55,900,600) ;整个form区域
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT






; 绘制 TAB 图像
;__________________________________________________
Func MY_TAB_PAINT($form,$this_image,$p_x,$p_y)
	$Pointer =setTagRECT($p_x,$p_y,160+$p_x,40+$p_y)
	_WinAPI_RedrawWindow($form, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
;~ 	MY_TAB_CLEAR($form,$p_x,$p_y)
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,160,40)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT

Func MY_TAB_CLEAR($form,$p_x,$p_y)
	$Pointer =setTagRECT($p_x,$p_y,160+$p_x,40+$p_y)
	_WinAPI_RedrawWindow($form, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
;~     _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,160,40)
;~     Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT


;TAB的相关操作：鼠标悬停、离开、点击事件， 键盘热键上、下、TAB键事件
;__________________________________________________



Func TAB_Hover_Proc($tabID)
;~ 	MsgBox(0,"","hover:"&$tabID)
	
	For $j = 0 To $Categorysnum-1
		If 	$tabID== $a_idTab[$j] Then
			If $tabID==$lastPressedTab[0] Then 
				Local $hoverPng=$MyTabsPics[$j][2]
			Else
				Local $hoverPng=$MyTabsPics[$j][1]
			EndIf
			
			Local $pos=$MyTabsPics[$j][3]
			MY_TAB_PAINT($hGUI,$hoverPng,0, $pos)
			$now_hover_tab=$j
			Return
		EndIf
		
	Next
	
EndFunc


Func TAB_Leave_Hover_Proc($tabID)
;~ 	MsgBox(0,"","leavehover:"&$tabID)
	If $tabID==$lastPressedTab[0] Then Return ;鼠标离开的是最后一个点击的tab时，不会还原到normal状态
	
	For $j = 0 To $Categorysnum-1
		If 	$tabID== $a_idTab[$j] Then
			Local $pos=$MyTabsPics[$j][3]
			Local $normalPng=$MyTabsPics[$j][0]
;~ 			MY_TAB_PAINT($Form1,$normalPng,0, $pos)
			MY_TAB_CLEAR($hGUI,0, $pos)
			$now_hover_tab=-1
			Return
		EndIf
	Next
EndFunc



Func resetLastTab()
	Local $j=$lastPressedTab[1] ;上一次点击的序号
	
	Local $pos=$MyTabsPics[$j][3]
	Local $normalPng=$MyTabsPics[$j][0]
	MY_TAB_PAINT($Form1,$normalPng,0, $pos)
	
EndFunc


Func TAB_PrimaryDown_Proc($tabID)
	Return
EndFunc


Func TAB_PrimaryUp_Proc($tabID)

EndFunc



#cs

Func TAB_CLICK()
	
	Local $tabID=@GUI_CtrlId
	If $lastPressedTab[0]=$tabID Then Return ;如果点击的是上一次点击状态的Button，则直接返回
	
	If $lastPressedTab[0]<>"NO" Then
;~ 		resetLastTab();还原上一次点击的Button到初始态normal
		GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;隐藏上一次的form
	EndIf
;~ 	MsgBox(0,"","bingo:")
	
	$lastPressedTab[0]=$tabID
	For $j = 0 To $Categorysnum-1
		If 	$tabID== $a_idTab[$j] Then
			$lastPressedTab[1]=$j
;~ 			MsgBox(0,"","bingo:"&$lastPressedTab[1])
			ExitLoop
		EndIf
	Next
	
	;显示当前点击的form
	MainFormRestore()
EndFunc
#CE




Func TAB_CLICK()
	MsgBox(0,"",@GUI_CtrlId)
EndFunc






Func HotKeyPressed()
	
	If $lastPressedTab[0]<>"NO" Then
		Switch @GUI_CtrlId
			Case $up
;~ 				MsgBox(0,"","up")
				If Not WinActive("ITTOOLS") Then Return
				;还原上一次点击的Button到初始态normal
;~ 				resetLastTab()
				;隐藏上一次的form
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]])
				
				If $lastPressedTab[1]==0 Then
					$lastPressedTab[1]=$Categorysnum-1
				Else
					$lastPressedTab[1]=$lastPressedTab[1]-1
				EndIf
				
				Local $j=$lastPressedTab[1]
				$lastPressedTab[0]=$a_idTab[$j]
				
;~ 				MainFormRestore()
				SetBitmap($hGUI, $Bgbitmaps[$j])
				GUISetState(@SW_SHOW, $a_idForm[$j])
				

		
			Case $down
;~ 				MsgBox(0,"","down")
				;还原上一次点击的Button到初始态normal
				resetLastTab()
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;隐藏上一次的form
				
				If $lastPressedTab[1]==$Categorysnum-1 Then
					$lastPressedTab[1]=0
				Else
					$lastPressedTab[1]=$lastPressedTab[1]+1
				EndIf
					
				Local $j=$lastPressedTab[1]
				$lastPressedTab[0]=$a_idTab[$j]
				
;~ 				MainFormRestore()
				SetBitmap($hGUI, $Bgbitmaps[$j])
				GUISetState(@SW_SHOW, $a_idForm[$j])
				

				
			Case $tab
				;还原上一次点击的Button到初始态normal
;~ 				MsgBox(0,"","tab")
				resetLastTab()
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;隐藏上一次的form
				
				If $lastPressedTab[1]==$Categorysnum-1 Then
					$lastPressedTab[1]=0
				Else
					$lastPressedTab[1]=$lastPressedTab[1]+1
				EndIf
				
				
				Local $j=$lastPressedTab[1]
				$lastPressedTab[0]=$a_idTab[$j]		
				
;~ 				MainFormRestore()
				SetBitmap($hGUI, $Bgbitmaps[$j])
				GUISetState(@SW_SHOW, $a_idForm[$j])
				

		EndSwitch
		
	EndIf
EndFunc









#CS
Func MY_BUTTON_PAINT_HOVER($form,$this_image,$p_x,$p_y,$w,$h)	
	$Pointer =setTagRECT($p_x,$p_y,$w+$p_x,$h+$p_y) ;button所在form的初始偏移量为 (160，55)
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
	
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,$w,$h)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
#CE



#CS
Func MY_BUTTON_PAINT_NORMAL($form,$this_image,$p_x,$p_y,$w,$h)	

	$Pointer =setTagRECT($p_x,$p_y,115+$p_x,161+$p_y) ;button所在form的初始偏移量为 (160，55)
	_WinAPI_RedrawWindow($form1, $Pointer, 0, BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))  ;清除单个Button区域


    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x+34.5,$p_y+34.5,$w,$h) ;绘制Button

;~     _WinAPI_RedrawWindow($form1, $Pointer, 0, $RDW_VALIDATE)	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
#CE



;单个Button的悬停事件实现
;__________________________________________________

#CS
Func Button_Hover_Proc($btnID)

	For $j = 0 To $AccesstoolsNum
		If $btnID == $btnID_toolTag[$j][0] Then
			
			Global $now_hover_j=$j
			Global $tool_tag = $btnID_toolTag[$j][1]
;~ 			MsgBox(0,"",StringStripWS($Accesstools[$tool_tag],8))
			
			Global $now_hover_normalPng=$MyButtonsPics[$j][0]
			Global $now_hover_hoverPng=$MyButtonsPics[$j][1]
			Global $now_hover_x=$MyButtonsPics[$j][2]
			Global $now_hover_y=$MyButtonsPics[$j][3]
			Global $now_hover_form=$MyButtonsPics[$j][4]
			
			
;~ 			MY_BUTTON_PAINT($a_idForm[$j],$MyButtonsPics[$k][1],15+Mod($k, 6)*(115+4) , 15 + $row*(161+4) ,115,161)
			MY_BUTTON_PAINT_HOVER($now_hover_form,$now_hover_hoverPng,$now_hover_x+160 , $now_hover_y+55 ,115,161)
			
			Return ;只运行找到的这个Button的，循环不必继续，这里就可以返回了
		EndIf
	Next
	
EndFunc

#CE


#CS
Func Button_Leave_Hover_Proc($tabID)
	MY_BUTTON_PAINT_NORMAL($now_hover_form,$now_hover_normalPng,$now_hover_x+160, $now_hover_y+55 ,46,46)
	$now_hover_j=-1
EndFunc
#CE



;Button功能
;__________________________________________________



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




#CS
Func autoCmd()

;~ 	Local $btnID = @GUI_CtrlId
;~ 	For $j = 0 To $AccesstoolsNum
;~ 		If $btnID == $btnID_toolTag[$j][0] Then
;~ 			$tool_tag = $btnID_toolTag[$j][1]

			$tip = StringStripWS($Accesstools[$tool_tag], 8)
			TrayTip("", $tip & " 正在执行", 3)
			runBat(show_button_commandtext($AccessCommandText[$tool_tag]))
			
;~ 			MainFormRenew()
;~ 			Return ;只运行找到的这个Button的，循环不必继续，这里就可以返回了
;~ 		EndIf
;~ 	Next

EndFunc   ;==>autoCmd

#CE

;窗口刷新、窗口重置的实现
;__________________________________________________

Func MainFormRenew_head()

#CS
	$Pointer =setTagRECT(0,0,900,37) ;button所在form的初始偏移量为 (160，55)
	_WinAPI_RedrawWindow($form1, $Pointer, 0, BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))

	
;~ 	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $backgroud_img_topIcon_load, 10, 7, 145, 37)
;~ 	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $backgroud_img_closeIcon_load, 870, 22, 10,10)
;~ 	
	
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $g_hBitmap, 0, 0, 900, 600) ;复制绘制位图到图形句柄指定的 GUI


#CE

	
EndFunc





Func MainFormRenew_Tab()

#CS
	;最后一次点击的TAB的序号
	Local $j=$lastPressedTab[1]
	;绘制TAB 
	For $i = 0 To $Categorysnum - 1
		If $i==$j Then
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
		ElseIf $i==$now_hover_tab Then 
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][1],0 , 55 + $i*40 )
		Else
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
		EndIf
	Next
	;使当前form可见
	GUISetState(@SW_SHOW, $a_idForm[$j])
#CE

EndFunc




#CS
Func MainFormRenew_Form($j) ;绘制form下的button和label
;~ 	;清空label文字
;~ 	For $k=0 To 17
;~ 		GUICtrlSetData($labels[$k]," " ) ;设置label的值
;~ 	Next
	 ;清空form区域的绘制
;~ 	MY_FORM_PAINT_CLEAR()
	
	
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$j][1],"|")
	Local $buttonNUM= $tmp_arr_label[0] ;当前form的Button、label总数
	Local $tmp_arr_buttonID=StringSplit($Form_Button_ID[$j][2],"|")

	For $k=0 To $buttonNUM-1
		
		$this_label=$tmp_arr_label[$k+1] ;当前label文本
		$this_buttonID=$tmp_arr_buttonID[$k+1] ;当前ButtonID
		Local $ID_j=search_buttonID($this_buttonID) ;Button所在的总序数
	
;~ 		GUICtrlSetData($labels[$k],$this_label ) ;设置label的值
		
		Local $row = Int($k / 6)	 ;所在行
		If $ID_j == $now_hover_j Then
			MY_BUTTON_PAINT_HOVER($a_idForm[$j],$MyButtonsPics[$ID_j][1],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) ,115,161)
		Else		

			MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;绘制Button图标
		EndIf

	Next
	
EndFunc

#CE


#CS
Func MainFormRestore_Form($j) ;绘制form下的button和label
	;清空label文字
	For $k=0 To 17
		GUICtrlSetData($labels[$k]," " ) ;设置label的值
	Next
	 ;清空form区域的绘制
	MY_FORM_PAINT_CLEAR()
	
	
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$j][1],"|")
	Local $buttonNUM= $tmp_arr_label[0] ;当前form的Button、label总数
	Local $tmp_arr_buttonID=StringSplit($Form_Button_ID[$j][2],"|")

	For $k=0 To $buttonNUM-1
		
		$this_label=$tmp_arr_label[$k+1] ;当前label文本
		$this_buttonID=$tmp_arr_buttonID[$k+1] ;当前ButtonID
		Local $ID_j=search_buttonID($this_buttonID) ;Button所在的总序数
	
		GUICtrlSetData($labels[$k],$this_label ) ;设置label的值
		
		Local $row = Int($k / 6)	 ;所在行
	

		MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;绘制Button图标


	Next
EndFunc

#CE




#CS
Func MainFormRenew();刷新窗口
	
	MainFormRenew_head()
	MainFormRenew_Tab()
	MainFormRenew_Form($lastPressedTab[1])
	
EndFunc

#CE


#CS
Func MainFormRestore();重置窗口
	MainFormRenew_head()
	MainFormRenew_Tab()
	MainFormRestore_Form($lastPressedTab[1])
EndFunc

#CE





;主窗体最小化、关闭、版本号显示
;__________________________________________________

Func minimize_button()
	GUISetState(@SW_MINIMIZE,$hGUI)	
EndFunc   ;==>minimize_button

Func close_button()
;~ 	_SoundClose($aSound);退出播放
	WO_rec()
	$wait="choice /t 2 /d y /n >nul"
	$update_itbat="copy \\fs02\补丁\IT部署的工具\ITTOOLS.exe  "& @ScriptDir&" /y"
	Local $update_itbat_cmd[2]=[$wait,$update_itbat]  
	runBat($update_itbat_cmd)
	
	Exit

EndFunc   ;==>close_button

Func show_version()
	MsgBox(0,"","当前版本："&$version &@LF&@LF&@LF & "design:            WOW_IT" & @LF &"visual design :  WOW_YW_UED")
EndFunc   ;==>show_version



;记录
;__________________________________________________
Func WO_rec() ; 
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\ITTOOLS.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec



