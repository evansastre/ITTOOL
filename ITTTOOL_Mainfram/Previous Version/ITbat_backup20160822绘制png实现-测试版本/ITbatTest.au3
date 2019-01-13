#NoTrayIcon
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=X:\OW_itbat_materials\ITbat.ico
#AccAu3Wrapper_OutFile=\\fs02\����\IT����Ĺ���\ITTOOLS.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****



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
	MsgBox(0, "", "ITTOOLS������");Prevent repeated opening of the program
	Exit
EndIf

OpenInit()

;~ MsgBox(0,"",_Timer_Diff($hStarttime))  ;������������������������������������ʾ��ʼ��ʱ��
;~ MsgBox(0,"","accesstoolsNum:"&$AccesstoolsNum)
;~ _ArrayDisplay($AccessTools) ;��ʾ�����û��ɷ��ʵĹ���
;~ _ArrayDisplay($AccessCommandText) ;��ʾ�����û��ɷ��ʵ�����
;~ _ArrayDisplay($AccessDescribe) ;��ʾ�����û��ɷ��ʵ�����
;~ _ArrayDisplay($AccessCategory) ;��ʾ�����û��ɷ��ʵ�����


InitSetting()
MainWindow()


Func InitSetting() ;����Ԫ�ػ���
	;��ǰ�汾��
	Global $version = "1.00006"
	
	;ģʽ����
;~ 	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)
	Opt("TrayMenuMode", 3) ; Ĭ�����̲˵���Ŀ��������ʾ, ��ѡ����ĿʱҲ�����. TrayMenuMode ������ѡ��Ϊ 1, 2.
	Opt("TrayOnEventMode", 1) ; �������� OnEvent �¼�����֪ͨ.

	;�Ǳ�tip
	TrayCreateItem("����...")
	TrayItemSetOnEvent(-1, "show_version")
	TrayCreateItem("") ; �����ָ���.
	TrayCreateItem("�˳�")
	TrayItemSetOnEvent(-1, "close_button")
	TraySetState($TRAY_ICONSTATE_SHOW) ; ��ʾ���̲˵�.


	Global $Width = 900, $Height = 600
	_GDIPlus_Startup()
	
	Global $hGUI = GUICreate("ITTOOLS", $Width, $Height, -1, -1, $WS_CAPTION, $WS_EX_LAYERED)
	GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
	
	
	
	
	#region ���屳��
	;_________________________________________________________________________________________________________
	Global $bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ȫ����.jpg")
	Global $hGraphic = _GDIPlus_ImageGetGraphicsContext($bg)


;~ 	Global $Bgbitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
;~ 	Global $hGraphic2 = _GDIPlus_ImageGetGraphicsContext($Bgbitmap)
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $bg, 0, 0, $Width, $Height)
;~ 	

			;���Ͻ�logo
	Global $logo = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\IT����-logo.png")

	
	;��С��Button
	Global $hBrush = _GDIPlus_BrushCreateSolid(0xffff9c00)
	Global $hFormat = _GDIPlus_StringFormatCreate()
	Global $hFamily = _GDIPlus_FontFamilyCreate("΢���ź�")
	Global $hFont = _GDIPlus_FontCreate($hFamily, 11, 0)
	Global $tLayout = _GDIPlus_RectFCreate(841, 17, 10,20)

	
	  ;��С��Button
	$minimize_btn = GUICtrlCreateLabel("_", 841, 22-30, 20,20)
	GUICtrlSetOnEvent($minimize_btn,"minimize_button")
	
	
	;�ر�Button
	$close = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\�ر�Button.png")

	
	;�ر�Button
	$close_btn = GUICtrlCreateLabel("X", 870, 22-30, 20,20)
	GUICtrlSetOnEvent($close_btn,"close_button")
	
	
	
	;��ʾ�汾�ţ����½�
	Global $hBrush2 = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Global $hFormat2 = _GDIPlus_StringFormatCreate()
	Global $hFamily2 = _GDIPlus_FontFamilyCreate("΢���ź�")
	Global $hFont2 = _GDIPlus_FontCreate($hFamily2, 9, 0)
	Global $tLayout2 = _GDIPlus_RectFCreate(835, 575, 55, 25)
	
		


	;_________________________________________________________________________________________________________

	
	;�ռ�ͬһ�����µ����й��߱��
	Global $Categorysnum = 0 ;���������
	Global $Categorys[0][2] ;��ŷ���
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

;~ 	_SetCursor($select_ico, $OCR_HAND) ;�����Button�ϵ���ָͣ��
	Global $btnID_toolTag[0][2] ;ID�š����߱��
	
	;��ʼ�����б�ǩ��form��Button
	Global  $MyTabsPics[0][4]  ; ���ص�pngͼƬ����浽������ , normal , hover ,clicked , position
	Global $a_idTab[$Categorysnum] ;��ʼ��TAb��ID
	Global $a_idForm[$Categorysnum];��ʼ��TAB��Ӧ��formID 
	Global $sideForm[0];��ʼ����ǰtab��Ӧform����form������ǰform�Ĺ���������18ʱ����
	Global $lastPressedTab[2]=["NO",0];���һ�ε����tabButton�� �洢tabid
;~ 	Global $lastHoverTab[2];���һ��������tabButton�� �洢tabid��ͼ��id
	
	

	Global $Bgbitmaps[$Categorysnum]
	Global $hGraphics[$Categorysnum]
	
	
	
	For $i = 0 To $Categorysnum - 1 ;��ÿ��bitmap�����ز�
		
		$Bgbitmaps[$i]= _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
		$hGraphics[$i]=_GDIPlus_ImageGetGraphicsContext($Bgbitmaps[$i])
		_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $bg, 0, 0, $Width, $Height)
			
			
		;���Ͻ�logo
		_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $logo,  10, 7, 145, 37)
		
		;��С��Button
		_GDIPlus_GraphicsDrawStringEx($hGraphics[$i], "����", $hFont, $tLayout, $hFormat, $hBrush)
		

		;�ر�Button
		_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $close,  870, 22, 10,10)
		
		
		;��ʾ�汾�ţ����½�
		_GDIPlus_GraphicsDrawStringEx($hGraphics[$i], $version, $hFont2, $tLayout2, $hFormat2, $hBrush2)
		
	Next

	
	
	For $i = 0 To $Categorysnum - 1
		
	
		
		;��ǩҳButtonͼƬ��ʼ��
		Local $this_categotys=$Categorys[$i][0]
		Local $this_normal_png=@TempDir & "\OW_tab_icons\"& $this_categotys  &"-Ĭ��Button.png"   
		Local $this_normal=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-Ĭ��Button.png")

		If Not FileExists($this_normal_png)  Then
			MsgBox(0,"",$this_normal_png & "  ������")
			Local $this_categotys="ս���ͻ���ͬ��"
			Local $this_normal=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-Ĭ��Button.png")
		EndIf
		
		Local $this_hover=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-HOVERButton.png")
		Local $this_clicked=_GDIPlus_ImageLoadFromFile(@TempDir & "\OW_tab_icons\"& $this_categotys   &"-�����Button.png")
		_ArrayAdd($MyTabsPics,$this_normal&"|"&$this_hover& "|" &$this_clicked & "|"& 55 + $i*40)  ; ���ص�pngͼƬ����浽������
		
		
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
;~ 			;��ʼ�������һ��tab
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
			$lastPressedTab[0]=$a_idTab[0]
;~ 			
			Global $now_hover_tab=-1 ;��ʼ��TAB��hover״̬Ϊ-1
			Global $now_hover_j=-1 ;��ʼ��button��hover״̬Ϊ-1
;~ 			
			;��ʼ������label,��Button�ı���
			Global $labels[18]
			For $j=0 To 17 
				
				Local $row = Int($j / 6)	
				Local $x=15+Mod($j, 6)*(115+4)
				Local $y=15 + $row*(161+4)
				

				$labels[$j]=GUICtrlCreateLabel(" 123", $x+15 +160    ,   $y+80.5+55  +10 , 85, 50, $SS_CENTER)
				GUICtrlSetColor(-1,0xFFFFFF)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1,9,"","","΢���ź�")
				
			Next
;~ 			
;~ 			;��ʼ�����б���
;~ 			
;~ 		Else
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
		EndIf


	Next


	
	;���ϻ��»�TAB(��ͬ����)���Խ���ѡ�����
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


	;Ϊ������ GFX ��������������ͼ�ο��
;~ 	Global $g_hBitmap = _GDIPlus_BitmapCreateFromGraphics(900, 600, $g_hGraphic)
;~     Global $g_hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
	
	
	Global  $MyButtonsPics[0][5]  ; ���ص�pngͼƬ����浽������ , normal , hover , x ,y , i_idform
	Global $Form_Button_ID[$Categorysnum][3] ;�洢formiID������ӵ�е�label���֡�buttonID
;~ 	
	
	
;~ 	SetBitmap($hGUI, $Bgbitmap)
	GUISetState()
	
	
EndFunc


Func MainWindow()





;~ 	$testB= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ħ������-Ĭ��Button.png")
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testB,49.5 +160, 49.5+55, 46,46)

;~ 	$testA= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ħ������hoverButton.png")
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testA,15 +160, 15+55+3, 115,161)




#CS
	Global $g_hBitmap = _GDIPlus_BitmapCreateFromGraphics(900, 600, $g_hGraphic)
    Global $g_hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
	_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt, $backgroud_img_topIcon_load, 10, 7, 145, 37) ;����λͼ���󱸻�����
	_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt, $backgroud_img_closeIcon_load, 870, 22, 10,10) ;����λͼ���󱸻�����
	
	
#CE

	;������������������������������������������������������������������������������������������������������������������������������
	;�����
;~ 	Global $Form1 = GUICreate("ITTOOLS", 900, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU,$WS_EX_LAYERED ), $WS_EX_ACCEPTFILES)
;~ 	Global $Form1 =  GUICreate("ITTOOLS_btn", 900, 600-30, 0, 30, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
	Global $Form1 =  GUICreate("ITTOOLS_btn", 160, 600-30, 0, 30, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
	GUISetBkColor(0x123456, $Form1)
	
;~ 	_GDIPlus_Startup()
	Global $g_hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form1) ;ȫ�ֵ�ͼ��

;~ 	GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore",$Form1) ;
;~ 	GUISetOnEvent($GUI_EVENT_DROPPED, "MainFormRenew",$Form1) ;
;~ 	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "MainFormRenew",$Form1) ; 
;~ 	

;~ 	$test_label = GUICtrlCreateLabel("7.00000", 160, 55-25, 115,161)
	$test_label = GUICtrlCreateLabel("7.00000", 160, 0, 115,161)
	GUICtrlSetColor(-1,0xFFFFFF)
	;~ GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,9,"","","΢���ź�")
	GUICtrlSetTip(-1, "haaatesttest")
;

;~ 	_API_SetLayeredWindowAttributes($Form1, 0x123456, 195)
	GUISwitch($Form1)
	GUISetState(@SW_SHOW,$Form1)
	GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
;~ 	_GUI_EnableDragAndResize($Form1, 900, 600, 900, 600)
	

	;������������������������������������������������������������������������������������������������������������������������������
	
	
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
		$this_button_nums = $tmp_arr[0] ;��ǰ�����Button����
;~ 		MsgBox(0,"",$this_button_nums)
		If $this_button_nums>18 Then $this_button_nums=18 ;������
		
		Local $page_num=Int($this_button_nums/18+1) -1 ;-1Ϊ������
		Local  $a_idBtn[$this_button_nums]
		
		
		$Form_Button_ID[$i][0]=$a_idForm[$i]
		
				

		
		For $j = 0 To $this_button_nums - 1  
			
			$tool_tag = $tmp_arr[$j + 1] ;�����������еı��
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
;~ 			MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;����Buttonͼ��

			Local $x=15+Mod($j, 6)*(115+4)
			Local $y=15 + $row*(161+4)
			_GDIPlus_GraphicsDrawImageRect($hGraphics[$i], $this_normal,  160+37.5+$x , 55+37.5+$y , 46,46)
			
			
			$a_idBtn[$j] =GUICtrlCreateLabel("" ,$x , $y , 115,161)
;~ 			GUICtrlSetOnEvent(-1,"autoCmd")
			_GUICtrl_OnHoverRegister(-1, "BUTTON_Hover_Proc", "BUTTON_Leave_Hover_Proc", "BUTTON_PrimaryDown_Proc", "BUTTON_PrimaryUp_Proc")
			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)  ;Button��ID����Ŵ������飬�Ա�cmd����
			;��ͣ����
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)
			
			_ArrayAdd($MyButtonsPics,$this_normal&"|"&$this_hover & "|"&  $x & "|"& $y & "|"& $a_idForm[$i])  ; ���ص�pngͼƬ����浽������
			
			;Button�ı���
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
		$this_button_nums = $tmp_arr[0] ;��ǰ�����Button����
;~ 		MsgBox(0,"",$this_button_nums)
		If $this_button_nums>18 Then $this_button_nums=18 ;������
		
		Local $page_num=Int($this_button_nums/18+1) -1 ;-1Ϊ������
		Local  $a_idBtn[$this_button_nums]
		
		
		$Form_Button_ID[$i][0]=$a_idForm[$i]
		
				
		
		For $j = 0 To $this_button_nums - 1  
			
			$tool_tag = $tmp_arr[$j + 1] ;�����������еı��
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
			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)  ;Button��ID����Ŵ������飬�Ա�cmd����
			;��ͣ����
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)
			
			_ArrayAdd($MyButtonsPics,$this_normal&"|"&$this_hover & "|"&  $x & "|"& $y & "|"& $a_idForm[$i])  ; ���ص�pngͼƬ����浽������
			
			;Button�ı���
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

	
	
	

;~ 	MainFormRestore() ;��ʼ����		
;~ 	GUISetState( @SW_SHOW ,$a_idForm[0])

	
	Global $hStarttime = _Timer_Init()
	Global $last_state=15 ;��ʼ״̬Ϊ15������̬��֮���������״̬
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


Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam) ;������Ϣ�ص�����
        Dim $iIDFrom = BitAND($iwParam, 0xFFFF)
        Dim $iCode = BitShift($iwParam, 16)
        Dim $hControl = GUICtrlGetHandle($iIDFrom)
;~         Switch $iIDFrom
;~                 Case $hTestBtn
;~                         Switch $iCode
;~                                 Case 0
;~                                         MsgBox(0,"����Button��", GUICtrlRead($hText))
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

Func _GUILock($hGUI) ;�߽����뻹ԭ

#CS
        Local $aPos = WinGetPos($hGUI), _
                        $iX = $aPos[0], $iY = $aPos[1], $iWidth = $aPos[2], $iHeight = $aPos[3]
						
		
        If $now_state == 23 Then  Return ;  ;23Ϊ��С��ʱ��״̬��
		If $now_state <> 15 And 	$timelast >3000 Then
			MainFormRenew()
			$hStarttime= _Timer_Init()
		EndIf
		
		
		If $now_state <> $last_state  Then ; ״̬�ı�ʱ��ˢ�´���
			
			MainFormRenew()
			$last_state=$now_state
;~ 			$hStarttime= _Timer_Init()
		EndIf
		
		
		
			

        ;�߽��⹦�ܣ���ʱȥ��
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
;~ 			Return $btnID_toolTag[$j][1] ;���ֵ����Button�������еı�ţ�����������
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
	$Pointer =setTagRECT(160,55,900,600) ;����form����
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT






; ���� TAB ͼ��
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


;TAB����ز����������ͣ���뿪������¼��� �����ȼ��ϡ��¡�TAB���¼�
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
	If $tabID==$lastPressedTab[0] Then Return ;����뿪�������һ�������tabʱ�����ỹԭ��normal״̬
	
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
	Local $j=$lastPressedTab[1] ;��һ�ε�������
	
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
	If $lastPressedTab[0]=$tabID Then Return ;������������һ�ε��״̬��Button����ֱ�ӷ���
	
	If $lastPressedTab[0]<>"NO" Then
;~ 		resetLastTab();��ԭ��һ�ε����Button����ʼ̬normal
		GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;������һ�ε�form
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
	
	;��ʾ��ǰ�����form
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
				;��ԭ��һ�ε����Button����ʼ̬normal
;~ 				resetLastTab()
				;������һ�ε�form
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
				;��ԭ��һ�ε����Button����ʼ̬normal
				resetLastTab()
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;������һ�ε�form
				
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
				;��ԭ��һ�ε����Button����ʼ̬normal
;~ 				MsgBox(0,"","tab")
				resetLastTab()
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;������һ�ε�form
				
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
	$Pointer =setTagRECT($p_x,$p_y,$w+$p_x,$h+$p_y) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
	
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,$w,$h)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
#CE



#CS
Func MY_BUTTON_PAINT_NORMAL($form,$this_image,$p_x,$p_y,$w,$h)	

	$Pointer =setTagRECT($p_x,$p_y,115+$p_x,161+$p_y) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, 0, BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))  ;�������Button����


    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x+34.5,$p_y+34.5,$w,$h) ;����Button

;~     _WinAPI_RedrawWindow($form1, $Pointer, 0, $RDW_VALIDATE)	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT
#CE



;����Button����ͣ�¼�ʵ��
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
			
			Return ;ֻ�����ҵ������Button�ģ�ѭ�����ؼ���������Ϳ��Է�����
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



;Button����
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
			TrayTip("", $tip & " ����ִ��", 3)
			runBat(show_button_commandtext($AccessCommandText[$tool_tag]))
			
;~ 			MainFormRenew()
;~ 			Return ;ֻ�����ҵ������Button�ģ�ѭ�����ؼ���������Ϳ��Է�����
;~ 		EndIf
;~ 	Next

EndFunc   ;==>autoCmd

#CE

;����ˢ�¡��������õ�ʵ��
;__________________________________________________

Func MainFormRenew_head()

#CS
	$Pointer =setTagRECT(0,0,900,37) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, 0, BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))

	
;~ 	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $backgroud_img_topIcon_load, 10, 7, 145, 37)
;~ 	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $backgroud_img_closeIcon_load, 870, 22, 10,10)
;~ 	
	
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $g_hBitmap, 0, 0, 900, 600) ;���ƻ���λͼ��ͼ�ξ��ָ���� GUI


#CE

	
EndFunc





Func MainFormRenew_Tab()

#CS
	;���һ�ε����TAB�����
	Local $j=$lastPressedTab[1]
	;����TAB 
	For $i = 0 To $Categorysnum - 1
		If $i==$j Then
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
		ElseIf $i==$now_hover_tab Then 
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][1],0 , 55 + $i*40 )
		Else
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
		EndIf
	Next
	;ʹ��ǰform�ɼ�
	GUISetState(@SW_SHOW, $a_idForm[$j])
#CE

EndFunc




#CS
Func MainFormRenew_Form($j) ;����form�µ�button��label
;~ 	;���label����
;~ 	For $k=0 To 17
;~ 		GUICtrlSetData($labels[$k]," " ) ;����label��ֵ
;~ 	Next
	 ;���form����Ļ���
;~ 	MY_FORM_PAINT_CLEAR()
	
	
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$j][1],"|")
	Local $buttonNUM= $tmp_arr_label[0] ;��ǰform��Button��label����
	Local $tmp_arr_buttonID=StringSplit($Form_Button_ID[$j][2],"|")

	For $k=0 To $buttonNUM-1
		
		$this_label=$tmp_arr_label[$k+1] ;��ǰlabel�ı�
		$this_buttonID=$tmp_arr_buttonID[$k+1] ;��ǰButtonID
		Local $ID_j=search_buttonID($this_buttonID) ;Button���ڵ�������
	
;~ 		GUICtrlSetData($labels[$k],$this_label ) ;����label��ֵ
		
		Local $row = Int($k / 6)	 ;������
		If $ID_j == $now_hover_j Then
			MY_BUTTON_PAINT_HOVER($a_idForm[$j],$MyButtonsPics[$ID_j][1],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) ,115,161)
		Else		

			MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;����Buttonͼ��
		EndIf

	Next
	
EndFunc

#CE


#CS
Func MainFormRestore_Form($j) ;����form�µ�button��label
	;���label����
	For $k=0 To 17
		GUICtrlSetData($labels[$k]," " ) ;����label��ֵ
	Next
	 ;���form����Ļ���
	MY_FORM_PAINT_CLEAR()
	
	
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$j][1],"|")
	Local $buttonNUM= $tmp_arr_label[0] ;��ǰform��Button��label����
	Local $tmp_arr_buttonID=StringSplit($Form_Button_ID[$j][2],"|")

	For $k=0 To $buttonNUM-1
		
		$this_label=$tmp_arr_label[$k+1] ;��ǰlabel�ı�
		$this_buttonID=$tmp_arr_buttonID[$k+1] ;��ǰButtonID
		Local $ID_j=search_buttonID($this_buttonID) ;Button���ڵ�������
	
		GUICtrlSetData($labels[$k],$this_label ) ;����label��ֵ
		
		Local $row = Int($k / 6)	 ;������
	

		MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;����Buttonͼ��


	Next
EndFunc

#CE




#CS
Func MainFormRenew();ˢ�´���
	
	MainFormRenew_head()
	MainFormRenew_Tab()
	MainFormRenew_Form($lastPressedTab[1])
	
EndFunc

#CE


#CS
Func MainFormRestore();���ô���
	MainFormRenew_head()
	MainFormRenew_Tab()
	MainFormRestore_Form($lastPressedTab[1])
EndFunc

#CE





;��������С�����رա��汾����ʾ
;__________________________________________________

Func minimize_button()
	GUISetState(@SW_MINIMIZE,$hGUI)	
EndFunc   ;==>minimize_button

Func close_button()
;~ 	_SoundClose($aSound);�˳�����
	WO_rec()
	$wait="choice /t 2 /d y /n >nul"
	$update_itbat="copy \\fs02\����\IT����Ĺ���\ITTOOLS.exe  "& @ScriptDir&" /y"
	Local $update_itbat_cmd[2]=[$wait,$update_itbat]  
	runBat($update_itbat_cmd)
	
	Exit

EndFunc   ;==>close_button

Func show_version()
	MsgBox(0,"","��ǰ�汾��"&$version &@LF&@LF&@LF & "design:            WOW_IT" & @LF &"visual design :  WOW_YW_UED")
EndFunc   ;==>show_version



;��¼
;__________________________________________________
Func WO_rec() ; 
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\ITTOOLS.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec



