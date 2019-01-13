#NoTrayIcon
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=X:\OW_itbat_materials\ITbat.ico
#AccAu3Wrapper_OutFile=ITTOOLS.exe
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

;~ #include "Icons.au3"
;~ #include "GuiCtrlCreatePNG.au3"

;~ #include <ScreenCapture.au3>




If _Singleton("ITTOOLS", 1) = 0 Then
	MsgBox(0, "", "ITTOOLS������");Prevent repeated opening of the program
	Exit
EndIf

$hStarttime = _Timer_Init() ;��ʱ
OpenInit()

;~ MsgBox(0,"",_Timer_Diff($hStarttime))  ;������������������������������������ʾ��ʼ��ʱ��
;~ MsgBox(0,"","accesstoolsNum:"&$AccesstoolsNum)
;~ _ArrayDisplay($AccessTools) ;��ʾ�����û��ɷ��ʵĹ���
;~ _ArrayDisplay($AccessCommandText) ;��ʾ�����û��ɷ��ʵ�����
;~ _ArrayDisplay($AccessDescribe) ;��ʾ�����û��ɷ��ʵ�����
;~ _ArrayDisplay($AccessCategory) ;��ʾ�����û��ɷ��ʵ�����


MainWindow()




Func MainWindow()
	
	_GDIPlus_StartUp() ;����GDI+
	;��ǰ�汾��
;~ 	Global $version = "�汾 1.00004" & @LF &  "Designed By IT & YW_UED"
	Global $version = "1.00005"
	
	;ģʽ����
	Opt("GUIResizeMode", 1)
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



	;~ _RTEmptyWorkingSet();Thread.au3��ĺ����������ڴ�ռ�õ�
	Global $hGUIxx
	Global $Width = 900, $Height = 600
	Global $PanBtnRect[3],$topbutton[3],$topbuttonhoverimg[3],$topbuttondownimg[3],$topbuttontip[3]

	_GDIPlus_Startup()




	;������������������������������������������������������������������������������������������������������������������������������
	;�����
;~ 	Global $Form1 = GUICreate("ITTOOLS", 900, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU,$WS_EX_LAYERED), $WS_EX_WINDOWEDGE)
;~ 	Global $Form1 = GUICreate("ITTOOLS", 900, 600, -1, -1,$WS_EX_LAYERED)
	Global $Form1 = GUICreate("ITTOOLS", 900, 600, -1, -1,$WS_CAPTION, $WS_EX_LAYERED)
;~ 	GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
;~ 	GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore") ;
;~ 	GUISetBkColor(0x282828); ������͸��ɫ
;~ 	GUISetCursor(2,1)

	

#CS
	$bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ȫ����.jpg")
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($bg)

	$Bgbitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
	$hGraphic2 = _GDIPlus_ImageGetGraphicsContext($Bgbitmap)
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $bg, 0, 0, $Width, $Height)

	$logo = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\IT����-logo.png")
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $logo,  10, 7, 145, 37)
	$mini = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\��ҳ��1.png")
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $mini, 380, 0, 35, 18)
	$max = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\��ҳ��2.png")
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $max, 408, 0, 35, 18)
	$close = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ħ������hoverButton.png")
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $close, 436, 0, 115,161)

	$testB= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ħ������-Ĭ��Button.png")
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testB,49.5 +160, 49.5+55, 46,46)

	$testA= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ħ������hoverButton.png")
	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testA,15 +160, 15+55+3, 115,161)

	SetBitmap($Form1, $Bgbitmap)
	GUISetState()
#CE

	
	

;~ 	$bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ȫ����.jpg")
;~ 	$g_hGraphic = _GDIPlus_ImageGetGraphicsContext($bg)
	Global $g_hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form1)
;~ 	
	Global $g_hBitmap = _GDIPlus_BitmapCreateFromGraphics(900, 600, $g_hGraphic)
    Global $g_hGfxCtxt = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
	
	
	;������������������������������������������������������������������������������������������������������������������������������
	;IT����logo,���Ͻ�
	Global $backgroud_img_topIcon=@TempDir & "\OW_itbat_materials\BGstyle\IT����-logo.png"
	Global $backgroud_img_topIcon_load=_GDIPlus_ImageLoadFromFile($backgroud_img_topIcon)
;~ 	Global $backgroud_topIcon = _GUICtrlPic_Create($backgroud_img_topIcon , 10, 7, 145, 37)
	Global $backgroud_topIcon = GUICtrlCreateLabel(" " , 10, 7, 145, 37)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	
	;�ر�Button
	Global $backgroud_img_closeIcon=@TempDir & "\OW_itbat_materials\BGstyle\�ر�Button.png"
	Global $backgroud_img_closeIcon_load=_GDIPlus_ImageLoadFromFile($backgroud_img_closeIcon)
;~ 	Global $backgroud_closeIcon = _GUICtrlPic_Create($backgroud_img_closeIcon , 870, 22, 10,10)
	Global $backgroud_closeIcon =GUICtrlCreateLabel(" " , 870, 22, 10,10)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnEvent($backgroud_closeIcon,"close_button")
	
	
	_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt, $backgroud_img_topIcon_load, 10, 7, 145, 37) ;����λͼ���󱸻�����
	_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt, $backgroud_img_closeIcon_load, 870, 22, 10,10) ;����λͼ���󱸻�����
	
	SetBitmap($Form1, $g_hBitmap)
	GUISetState()
	
	GUISetState(@SW_SHOW,$form1)
;~ 	_GUI_EnableDragAndResize($Form1, 900, 600, 900, 600)
	
 
#CS
	;ȫ����
	$backgroud_img=@TempDir & "\OW_itbat_materials\BGstyle\ȫ����.jpg"
	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,900,600,-1,$WS_EX_LAYERED)
;~ 	Global $backgroud = GUICtrlCreatePic("",0,0,900,600,-1,$WS_EX_LAYERED)
;~ 	GUICtrlSetImage($backgroud,$backgroud_img)
	GuiCtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetState($backgroud, $GUI_SHOW)
#CE

	
	;�����
	
	
	
	
	;Ϊ������ GFX ��������������ͼ�ο��
	Global $g_hGraphic2 = _GDIPlus_GraphicsCreateFromHWND($Form1)
	Global $g_hBitmap_tab = _GDIPlus_BitmapCreateFromGraphics(160, 545, $g_hGraphic2)
	Global $g_hGfxCtxt_tab = _GDIPlus_ImageGetGraphicsContext($g_hBitmap_tab)
	
	Global $g_hGraphic3 = _GDIPlus_GraphicsCreateFromHWND($Form1)
	Global $g_hBitmap_button = _GDIPlus_BitmapCreateFromGraphics(900-160, 545, $g_hGraphic3)
	Global $g_hGfxCtxt_button = _GDIPlus_ImageGetGraphicsContext($g_hBitmap_button)
	

#CS
	Global $backgroud_img_leftIcon=@TempDir & "\itbat_materials\BGstyle\���˵�������.png"
	Local $hImage = _GDIPlus_ImageLoadFromFile($backgroud_img_leftIcon)
	Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form1)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 55)
#CE



	

	;������������������������������������������������������������������������������������������������������������������������������
	

	
	
	;��С��Button
	$backgroud_minimizeIcon = GUICtrlCreateLabel("__", 851, 13, 10,20)
	GUICtrlSetOnEvent($backgroud_minimizeIcon,"minimize_button")
	GUICtrlSetColor(-1,0xff9c00)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,11,"","","΢���ź�")
	
    ;�ײ�Button
	;������������������������������������������������������������������������������������������������������������������������������
	;��ʾ�汾�ţ����½�
	$version_label = GUICtrlCreateLabel($version, 835, 575, 50, 22)
	GUICtrlSetColor(-1,0xFFFFFF)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,9,"","","΢���ź�")
	
;~ 	;������������������������������������������������������������������������������������������������������������������������������
	
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
		

		$a_idTab[$i] =GUICtrlCreatePic("" ,0 , 55 + $i*40 , 160,40)
		_GUICtrl_OnHoverRegister(-1, "TAB_Hover_Proc", "TAB_Leave_Hover_Proc", "TAB_PrimaryDown_Proc", "TAB_PrimaryUp_Proc")
		
		
		If $i==0 Then
			;��ʼ�������һ��tab
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
			$lastPressedTab[0]=$a_idTab[0]
			
			Global $now_hover_tab=-1 ;��ʼ��tab��hover״̬Ϊ-1
			Global $now_hover_j=-1 ;��ʼ��button��hover״̬Ϊ-1
			
			;��ʼ������label,��Button�ı���
			Global $labels[18]
			For $j=0 To 17 
				
				Local $row = Int($j / 6)	
				Local $x=15+Mod($j, 6)*(115+4)
				Local $y=15 + $row*(161+4)
				
;~ 				$labels[$j]=GUICtrlCreateLabel("label:"&$j, $x+15 +160    ,   $y+80.5+55  +10 , 85, 50, $SS_CENTER)
				$labels[$j]=GUICtrlCreateLabel(" ", $x+15 +160    ,   $y+80.5+55  +10 , 85, 50, $SS_CENTER)
				GUICtrlSetColor(-1,0xFFFFFF)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1,9,"","","΢���ź�")
				
			Next
			
			;��ʼ�����б���
			
		Else
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
	

	MainFormRestore() ;��ʼ����		
	GUISetState( @SW_SHOW ,$a_idForm[0])
	
	
	Local $hStarttime = _Timer_Init()
	While 1
	
#CS
	$timelast=_Timer_Diff($hStarttime)
		If $timelast>(1000) Then
			MainFormRenew()
			$hStarttime= _Timer_Init()
;~ 			MsgBox(0,"",WinGetState("ITTOOLS"))
		EndIf
#CE

			
		_GUILock($Form1)
		
	WEnd
	

EndFunc   ;==>MainWindow




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





Func _GUILock($hGUI) ;�߽����뻹ԭ
        Local $aPos = WinGetPos($hGUI), _
                        $iX = $aPos[0], $iY = $aPos[1], $iWidth = $aPos[2], $iHeight = $aPos[3]
        If WinGetState("ITTOOLS") == 23 Then   ;23Ϊ��С��ʱ��״̬��
			Return ;
		EndIf
		
			
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
        
EndFunc   ;==>_GUILock


;����Button�Ļ���ʵ��
;__________________________________________________

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

Func MY_BUTTON_PAINT_HOVER($form,$this_image,$p_x,$p_y,$w,$h)	
	$Pointer =setTagRECT($p_x,$p_y,$w+$p_x,$h+$p_y) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
	
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,$w,$h)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT

Func MY_BUTTON_PAINT_NORMAL($form,$this_image,$p_x,$p_y,$w,$h)	

	$Pointer =setTagRECT($p_x,$p_y,115+$p_x,161+$p_y) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, 0, BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))  ;�������Button����


    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x+34.5,$p_y+34.5,$w,$h) ;����Button

;~     _WinAPI_RedrawWindow($form1, $Pointer, 0, $RDW_VALIDATE)	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT


;����Button����ͣ�¼�ʵ��
;__________________________________________________
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

Func Button_Leave_Hover_Proc($tabID)
	MY_BUTTON_PAINT_NORMAL($now_hover_form,$now_hover_normalPng,$now_hover_x+160, $now_hover_y+55 ,46,46)
	$now_hover_j=-1
EndFunc


;Button����
;__________________________________________________
Func autoCmd()

;~ 	Local $btnID = @GUI_CtrlId
;~ 	For $j = 0 To $AccesstoolsNum
;~ 		If $btnID == $btnID_toolTag[$j][0] Then
;~ 			$tool_tag = $btnID_toolTag[$j][1]

			$tip = StringStripWS($Accesstools[$tool_tag], 8)
			TrayTip("", $tip & " ����ִ��", 3)
			runBat(show_button_commandtext($AccessCommandText[$tool_tag]))
			
			MainFormRenew()
;~ 			Return ;ֻ�����ҵ������Button�ģ�ѭ�����ؼ���������Ϳ��Է�����
;~ 		EndIf
;~ 	Next

EndFunc   ;==>autoCmd

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




;����ˢ�¡��������õ�ʵ��
;__________________________________________________

Func MainFormRenew_head()

#CS
	$Pointer =setTagRECT(0,0,900,50) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, 0, BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))

;~ 	_GDIPlus_GraphicsClear($g_hGfxCtxt)
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic, $g_hBitmap, 0, 0, 900, 50) ;���ƻ���λͼ��ͼ�ξ��ָ���� GUI

#CE

EndFunc

;~ #include <GDIPlus.au3>
Func MainFormRestore_Tab()
	;���һ�ε����TAB�����
	Local $j=$lastPressedTab[1]
	;����TAB 
	

	_GDIPlus_GraphicsDispose($g_hBitmap_tab)
	_GDIPlus_GraphicsDispose($g_hGfxCtxt_tab)
;~ 	_GDIPlus_GraphicsClear($g_hGfxCtxt_tab)

	Global $g_hBitmap_tab = _GDIPlus_BitmapCreateFromGraphics(160, 600-55, $g_hGraphic2)
	Global $g_hGfxCtxt_tab = _GDIPlus_ImageGetGraphicsContext($g_hBitmap_tab)
	
	

	
	For $i = 0 To $Categorysnum - 1
		If $i==$j Then
			
			_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt_tab,$MyTabsPics[$i][2], 0 ,  $i*40, 160,40) ;����λͼ���󱸻�����
			
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
		Else
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
			_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt_tab, $MyTabsPics[$i][0], 0 , $i*40, 160,40) ;����λͼ���󱸻�����
		EndIf
	Next
	
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic2, $g_hBitmap_tab, 0, 55, 160, 545) ;���ƻ���λͼ��ͼ�ξ��ָ���� GUI
	
	;ʹ��ǰform�ɼ�
	GUISetState(@SW_SHOW, $a_idForm[$j])
EndFunc
Func MainFormRenew_Tab()
	$Pointer =setTagRECT(0,55,160,600) ;����tab����
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));�������tab����
	
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic2, $g_hBitmap_tab, 0, 55, 160, 545) ;���ƻ���λͼ��ͼ�ξ��ָ���� GUI
	
	
	If $now_hover_tab<>-1 Then MY_TAB_PAINT($Form1,$MyTabsPics[$now_hover_tab][1],0 , 55 + $now_hover_tab*40 ) ;����hover״̬�µ�TAB
	;���һ�ε����TAB�����
	Local $j=$lastPressedTab[1]
	;ʹ��ǰform�ɼ�
	GUISetState(@SW_SHOW, $a_idForm[$j])
EndFunc

Func MainFormRenew_Form($j) ;����form�µ�button��label

	$Pointer =setTagRECT(160,55,900,600) ;����button����
;~ 	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));�������tab����
;~ 	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW));�������tab����


	_WinAPI_RedrawWindow($form1, $Pointer, "", $RDW_INVALIDATE);�������tab����
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic3, $g_hBitmap_button, 160, 55, 900-160, 600-55) ;���ƻ���λͼ��ͼ�ξ��ָ���� GUI
	
	
	
	;���һ�ε����TAB�����
;~ 	Local $j=$lastPressedTab[1]
	
;~ 	If $now_hover_j<>-1 Then MY_BUTTON_PAINT_HOVER($a_idForm[$j],$MyButtonsPics[$now_hover_j][1],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) ,115,161) ;����hover״̬�µ�Button
	
	;ʹ��ǰform�ɼ�
;~ 	GUISetState(@SW_SHOW, $a_idForm[$j])

#CS
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
#CE

	
EndFunc

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


;~ 	_GDIPlus_GraphicsClear($g_hGfxCtxt_button)
	
	_GDIPlus_GraphicsDispose($g_hGfxCtxt_button)
	_GDIPlus_GraphicsDispose($g_hBitmap_button)
	
	Global $g_hBitmap_button = _GDIPlus_BitmapCreateFromGraphics(900-160, 600-55, $g_hGraphic3)
	Global $g_hGfxCtxt_button = _GDIPlus_ImageGetGraphicsContext($g_hBitmap_button)
	
	
	Global $buttons[$buttonNUM]
	For $k=0 To $buttonNUM-1
		
		$this_label=$tmp_arr_label[$k+1] ;��ǰlabel�ı�
		$this_buttonID=$tmp_arr_buttonID[$k+1] ;��ǰButtonID
		Local $ID_j=search_buttonID($this_buttonID) ;Button���ڵ�������
	
		GUICtrlSetData($labels[$k],$this_label ) ;����label��ֵ
		
		Local $row = Int($k / 6)	 ;������
	

;~ 		MY_BUTTON_PAINT_NORMAL($a_idForm[$j],$MyButtonsPics[$ID_j][0],160+15+Mod($k, 6)*(115+4) , 55+15 + $row*(161+4) , 46,46) ;����Buttonͼ��
		_GDIPlus_GraphicsDrawImageRect($g_hGfxCtxt_button,$MyButtonsPics[$ID_j][0], 49.5+Mod($k, 6)*(115+4) ,  49.5+$row*(161+4) , 46,46) ;����λͼ���󱸻�����
;~ 		SetBitmap($a_idForm[$j],$MyButtonsPics[$ID_j][0])
;~ 		_GuiCtrlCreatePNG($MyButtonsPics[$ID_j][0], 49.5+Mod($k, 6)*(115+4) ,  49.5+$row*(161+4), $a_idForm[$j])

;~ 		$buttons[$k]=_GuiCtrlCreatePNG($MyButtonsPics[$ID_j][0],160 +15+Mod($k, 6)*(115+4) , 55+ 15+$row*(161+4), $Form1)
;~ 		GUISetState(@SW_SHOW,$a_idForm[$j])
	Next
	GUISwitch($Form1)
	
	_GDIPlus_GraphicsDrawImageRect($g_hGraphic3, $g_hBitmap_button, 160, 55, 900-160, 600-55) ;���ƻ���λͼ��ͼ�ξ��ָ���� GUI
EndFunc





#CS
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
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)

EndFunc ;==>SetBitmap
#CE





Func MainFormRenew();ˢ�´���
	
	MainFormRenew_head()
	MainFormRenew_Tab()
	MainFormRenew_Form($lastPressedTab[1])
	
EndFunc

Func MainFormRestore();���ô���
	MainFormRenew_head()
	MainFormRestore_Tab()
	MainFormRestore_Form($lastPressedTab[1])
EndFunc






; ���� TAB ͼ��
;__________________________________________________
Func MY_TAB_PAINT($form,$this_image,$p_x,$p_y)
	$Pointer =setTagRECT($p_x,$p_y,160+$p_x,40+$p_y)
	_WinAPI_RedrawWindow($form, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,160,40)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT



;TAB����ز����������ͣ���뿪������¼��� �����ȼ��ϡ��¡�TAB���¼�
;__________________________________________________

Func TAB_Hover_Proc($tabID)

	For $j = 0 To $Categorysnum-1
		If 	$tabID== $a_idTab[$j] Then
			If $tabID==$lastPressedTab[0] Then 
				Local $hoverPng=$MyTabsPics[$j][2]
			Else
				Local $hoverPng=$MyTabsPics[$j][1]
			EndIf
			
			Local $pos=$MyTabsPics[$j][3]
			MY_TAB_PAINT($Form1,$hoverPng,0, $pos)
			$now_hover_tab=$j
			Return
		EndIf
		
	Next
	
EndFunc


Func TAB_Leave_Hover_Proc($tabID)
	If $tabID==$lastPressedTab[0] Then Return ;����뿪�������һ�������tabʱ�����ỹԭ��normal״̬
	
	For $j = 0 To $Categorysnum-1
		If 	$tabID== $a_idTab[$j] Then
			Local $pos=$MyTabsPics[$j][3]
			Local $normalPng=$MyTabsPics[$j][0]
			MY_TAB_PAINT($Form1,$normalPng,0, $pos)
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


Func HotKeyPressed()
	
	If $lastPressedTab[0]<>"NO" Then
		Switch @GUI_CtrlId
			Case $up
;~ 				MsgBox(0,"","up")
				If Not WinActive("ITTOOLS") Then Return
				;��ԭ��һ�ε����Button����ʼ̬normal
				resetLastTab()
				;������һ�ε�form
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]])
				
				If $lastPressedTab[1]==0 Then
					$lastPressedTab[1]=$Categorysnum-1
				Else
					$lastPressedTab[1]=$lastPressedTab[1]-1
				EndIf
				
				Local $j=$lastPressedTab[1]
				$lastPressedTab[0]=$a_idTab[$j]
				
				MainFormRestore()
				

		
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
				
				MainFormRestore()
				

				
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
				
				MainFormRestore()
				

		EndSwitch
		
	EndIf
EndFunc




;��������С�����رա��汾����ʾ
;__________________________________________________

Func minimize_button()
	GUISetState(@SW_MINIMIZE,$Form1)	
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






