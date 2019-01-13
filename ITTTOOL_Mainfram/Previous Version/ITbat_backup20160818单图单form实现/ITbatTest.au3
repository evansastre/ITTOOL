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
;~ #include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>		
#include <Misc.au3>
#include <TrayConstants.au3>

#include "OpenInit.au3"
#include "GUI_EnableDragAndResize.au3"

;~ #include "play_backgroundmusic.au3"

;~ #include "GUICtrlPic.au3" 

;~ #include "Icons.au3"

#include "GUICtrlOnHover.au3"
#include "GuiCtrlCreatePNG.au3"



If _Singleton("ITTOOLS", 1) = 0 Then
	MsgBox(0, "", "ITbatPRO�Ѿ�����");Prevent repeated opening of the program
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


	;������������������������������������������������������������������������������������������������������������������������������
	;�����
;~ 	Global $Form1 = GUICreate("ITbatPRO", 900, 600, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU,$WS_EX_LAYERED), $WS_EX_WINDOWEDGE)
;~ 	Global $Form1 = GUICreate("ITbatPRO", 900, 600, -1, -1,$WS_EX_LAYERED)
	Global $Form1 = GUICreate("ITbatPRO", 900, 600, -1, -1)
	GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
	GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore") ;
;~ 	GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore") ;

;~ 	GUISetBkColor(0x282828); ������͸��ɫ
;~ 	GUISetCursor(2,1)
	
	
	GUISetState(@SW_SHOW,$form1)
	_GUI_EnableDragAndResize($Form1, 900, 600, 900, 600)

	_GDIPlus_StartUp() ;����GDI+



		 	;����
	$backgroud_img=@TempDir & "\OW_itbat_materials\BGstyle\ȫ����.jpg"
	Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,900,600,-1,$WS_EX_LAYERED)
;~ 	GUICtrlSetOnEvent($backgroud,"close_button")	
	GuiCtrlSetState(-1,$GUI_DISABLE) ;�����д�����
	GUICtrlSetState($backgroud, $GUI_SHOW)

	
	;�ϲ���
	;������������������������������������������������������������������������������������������������������������������������������
	;IT����logo,���Ͻ�
	Global $backgroud_img_topIcon=@TempDir & "\OW_itbat_materials\BGstyle\IT����-logo.png"
;~ 	$backgroud_topIcon = _GUICtrlPic_Create($backgroud_img_topIcon , 10, 7, 145, 37)
	$backgroud_topIcon =  _GuiCtrlCreatePNG($backgroud_img_topIcon, 10, 7, $Form1)
	
	;�ر�Button
	Global $backgroud_img_closeIcon=@TempDir & "\OW_itbat_materials\BGstyle\�ر�Button.png"
	$backgroud_closeIcon = _GuiCtrlCreatePNG($backgroud_img_closeIcon , 870, 22, $Form1)

;~ 	_SetGraphicToControl($backgroud_closeIcon[0],$backgroud_img_closeIcon)
;~ 	GUISwitch($Form1)
	GUICtrlSetOnEvent($backgroud_closeIcon[1],"close_button")

	
	GUISwitch($Form1) ;_GuiCtrlCreatePNG�����ú��Խ���һ��form������仯�ˣ�����Ҫת������form
	;��С��Button
;~ 	Global $backgroud_img_minimizeIcon=@TempDir & "\itbat_materials\BGstyle\�ر�Button.png"
;~ 	GUICtrlSetOnEvent($backgroud_minimizeIcon,"minimize_button")
	$backgroud_minimizeIcon = GUICtrlCreateLabel("v", 846, 12, 10,20)
	GUICtrlSetOnEvent($backgroud_minimizeIcon,"minimize_button")
	GUICtrlSetColor(-1,0xFFFFFF)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,11,"","","΢���ź�")
	
    ;�ײ�Button
	;������������������������������������������������������������������������������������������������������������������������������
	
	Global $play_label = GUICtrlCreateLabel(". ",  200, 563, 120, 30)
	GUICtrlSetState($play_label, $GUI_HIDE)


	;��ʾ�汾�ţ����½�
	$version_label = GUICtrlCreateLabel($version, 835, 575, 50, 22)
	GUICtrlSetColor(-1,0xFFFFFF)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1,9,"","","΢���ź�")
	



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



	Global $btnID_toolTag[0][2] ;ID�š����߱��
	
	;��ʼ�����б�ǩ��form��Button
	Global  $MyTabsPics[0][4]  ; ���ص�pngͼƬ����浽������ , normal , hover ,clicked , position
	Global $a_idTab[$Categorysnum] ;��ʼ��TAb��ID
	Global $a_idForm[$Categorysnum];��ʼ��TAB��Ӧ��formID 
	Global $sideForm[0];��ʼ����ǰtab��Ӧform����form������ǰform�Ĺ���������18ʱ����
	Global $lastPressedTab[4]=["NO",0,"NO",0];���һ�ε����tabButton�� �洢tabid
;~ 	Global $lastHoverTab[2];���һ��������tabButton�� �洢tabid��ͼ��id
	

;~ 	Global $g_hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form1)
	
	;TAB���
	;~ 	;������������������������������������������������������������������������������������������������������������������������������
	For $i = 0 To $Categorysnum - 1 
		
		;��ǩҳButtonͼƬ��ʼ��
		Local $this_categotys=$Categorys[$i][0]
		Local $this_normal=@TempDir & "\OW_tab_icons\"& $this_categotys  &"-Ĭ��Button.png"   

		If Not FileExists($this_normal)  Then
			MsgBox(0,"",$this_normal & "  ������")
			Local $this_categotys="ս���ͻ���ͬ��"

		EndIf
		
		Local $this_hover=@TempDir & "\OW_tab_icons\"& $this_categotys   &"-HOVERButton.png"
		Local $this_clicked=@TempDir & "\OW_tab_icons\"& $this_categotys   &"-�����Button.png"
		_ArrayAdd($MyTabsPics,$this_normal&"|"&$this_hover& "|" &$this_clicked & "|"& 55 + $i*40)  ; ���ص�pngͼƬ����浽������
		

		$a_idTab[$i] =_GuiCtrlCreatePNG($this_normal ,3 , 3+55 + $i*40 ,  $Form1)
;~ 		$a_idTab[$i] =_GuiCtrlCreatePNG($this_clicked ,2 , 55 + $i*40 ,  $Form1)
;~ 		_GUICtrl_OnHoverRegister($a_idTab[$i][1], "TAB_Hover_Proc", "TAB_Leave_Hover_Proc", "TAB_PrimaryDown_Proc", "TAB_PrimaryUp_Proc")
		_GUICtrl_OnHoverRegister(($a_idTab[$i])[1], "TAB_Hover_Proc", "TAB_Leave_Hover_Proc", "TAB_PrimaryDown_Proc", "TAB_PrimaryUp_Proc")
;~ 		$backgroud_closeIcon = _GuiCtrlCreatePNG($backgroud_img_closeIcon , 870, 22, $Form1)
;~ 		GUICtrlSetOnEvent($backgroud_closeIcon[1],"close_button")
		GUISwitch($Form1) ;_GuiCtrlCreatePNG�����ú��Խ���һ��form������仯�ˣ�����Ҫת������form
		
		

		If $i==0 Then
			;��ʼ�������һ��tab
			_SetGraphicToControl(($a_idTab[$i])[0],$this_clicked)
			GUISwitch($Form1)
			$lastPressedTab[0]=($a_idTab[0])[1]
			

			;��ʼ������label,��Button�ı���
			Global $labels[18]
			For $j=0 To 17 
				Local $row = Int($j / 6)	
				Local $x=15+Mod($j, 6)*(115+4)
				Local $y=15 + $row*(161+4)
;~ 				$labels[$j]=GUICtrlCreateLabel("label:"&$j, $x+15 +160    ,   $y+80.5+55  +10 , 85, 50, $SS_CENTER)
				$labels[$j]=GUICtrlCreateLabel("123 ", $x+15 +160    ,   $y+80.5+55  +10 , 85, 50, $SS_CENTER)
				GUICtrlSetColor(-1,0xFFFFFF)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1,9,"","","΢���ź�")
			Next
			


			;��ʼ�����б���
		Else
			
		EndIf

	Next
	
;~ 	GUISwitch($Form1) 
	
	;��TAB������һ���������ϻ��»�TAB(��ͬ����)���Խ���ѡ�����
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
	




	Global  $MyButtonsPics[0][5]  ; ���ص�pngͼƬ����浽������ , normal , hover , x ,y , i_idform
	Global $Form_Button_ID[$Categorysnum][4] ;�洢formiID������ӵ�е�label���֡�buttonID(Button��form��label)
	
	For $i = 0 To $Categorysnum - 1
				
		$a_idForm[$i]=GUICreate("", 900-160,600-55, 160,55,$WS_POPUP,BitOR($WS_EX_LAYERED,$WS_EX_MDICHILD),$Form1)
;~ 		$a_idForm[$i]=GUICreate("", 900-160,600-55, 160,55,$WS_CHILD,"",$Form1)

					
		$tmp_arr = StringSplit($Categorys[$i][1], "&")
		$this_button_nums = $tmp_arr[0] ;��ǰ�����Button����
		If $this_button_nums>18 Then $this_button_nums=18 ;������
		
		
		Local $page_num=Int($this_button_nums/18+1) -1 ;-1Ϊ������
		Local  $a_idBtn[$this_button_nums]
		
		
		$Form_Button_ID[$i][0]=$a_idForm[$i]
		
		
		GUISetState(@SW_HIDE,$a_idForm[$i])
;~ 			MsgBox(0,"",$this_button_nums)
		For $j = 0 To $this_button_nums - 1  
			
		
			$tool_tag = $tmp_arr[$j + 1] ;�����������еı��
			Local $row = Int($j / 6)
			
			If $AccessIco[$tool_tag] == "" Or (Not FileExists(@TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png")) Then
;~ 					MsgBox(0,"","defalt png")
				$this_normal_png = @TempDir & "\OW_button_icons\default.png"
				$this_hover_png = @TempDir & "\OW_button_icons\default-hoverButton.png"
			
			Else
;~ 					MsgBox(0,"","normal png")
				$this_normal_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png"
				$this_hover_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag]& "-hoverButton.png"
			EndIf
;~ 				If FileExists($this_hover_png) Then MsgBox(0,"",$this_hover_png)
	
			

	

	;Buttonͼ��
			;______________________________________________________________________________
;~ 			Local $x=34.5+Mod($j, 6)*(115+4)
;~ 			Local $y=34.5 + $row*(161+4)
			Local $x=15+Mod($j, 6)*(115+4)
			Local $y=15 + $row*(161+4)

;~ 			$a_idBtn[$j] =_GuiCtrlCreatePNG($this_normal_png,$x , $y , $a_idForm[$i])
			$a_idBtn[$j] =_GuiCtrlCreatePNG("",$x , $y , $a_idForm[$i])
			GUICtrlSetOnEvent(($a_idBtn[$j])[1],"close_button")
;~ 			GUICtrlSetOnEvent(-1,"autoCmd")
			_GUICtrl_OnHoverRegister( ($a_idBtn[$j])[1], "BUTTON_Hover_Proc", "BUTTON_Leave_Hover_Proc", "BUTTON_PrimaryDown_Proc", "BUTTON_PrimaryUp_Proc")
			
;~ 			_GUICtrl_OnHoverRegister(($a_idTab[$i])[1], "TAB_Hover_Proc", "TAB_Leave_Hover_Proc", "TAB_PrimaryDown_Proc", "TAB_PrimaryUp_Proc")

			_ArrayAdd($btnID_toolTag, ($a_idBtn[$j])[1] & "|" & $tool_tag)  ;Button��ID����Ŵ������飬�Ա�cmd����
			;��ͣ����
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)
			;______________________________________________________________________________


			_ArrayAdd($MyButtonsPics,$this_normal_png&"|"&$this_hover_png & "|"&  $x & "|"& $y & "|"& $a_idForm[$i])  ; ���ص�pngͼƬ����浽������
			
		
			;Button�ı���
			$len = StringLen($Accesstools[$tool_tag])
			$this_label = StringMid($Accesstools[$tool_tag], 2, $len - 2)
;~ 				MsgBox(0,"",$this_label)
		
			

			If $j==0 Then
				$Form_Button_ID[$i][1]=$this_label
				$Form_Button_ID[$i][2]=($a_idBtn[$j])[0]
				$Form_Button_ID[$i][3]=($a_idBtn[$j])[1]
			Else
				$Form_Button_ID[$i][1] = $Form_Button_ID[$i][1] & "|" & $this_label
				$Form_Button_ID[$i][2] = $Form_Button_ID[$i][2] & "|" & ($a_idBtn[$j])[0]
				$Form_Button_ID[$i][3] = $Form_Button_ID[$i][3] & "|" & ($a_idBtn[$j])[1]
			EndIf
		
		Next	
	
		GUISetState(@SW_HIDE, $a_idForm[$i])
	Next
;~ 	_ArrayDisplay($Form_Button_ID)
		
;~ 	GUISwitch($a_idForm[0])
;~ 	GUISetState(@SW_SHOW, $a_idForm[0])
		
#cs

		For $j = 0 To $this_button_nums - 1  
			
			
			$tool_tag = $tmp_arr[$j + 1] ;�����������еı��
			Local $row = Int($j / 6)
			
			If $AccessIco[$tool_tag] == "" Or (Not FileExists(@TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png")) Then
;~ 					MsgBox(0,"","defalt png")
				$this_normal_png = @TempDir & "\OW_button_icons\default.png"
				$this_hover_png = @TempDir & "\OW_button_icons\default-hoverButton.png"
			
			Else
;~ 					MsgBox(0,"","normal png")
				$this_normal_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag] & ".png"
				$this_hover_png = @TempDir & "\OW_button_icons\" & $AccessIco[$tool_tag]& "-hoverButton.png"
			EndIf
;~ 				If FileExists($this_hover_png) Then MsgBox(0,"",$this_hover_png)
			
;~ 			Local $this_normal=_GDIPlus_ImageLoadFromFile($this_normal_png)
;~ 			Local $this_hover=_GDIPlus_ImageLoadFromFile($this_hover_png)

;~ 				
	
			Local $x=15+Mod($j, 6)*(115+4)
			Local $y=15 + $row*(161+4)
			
;~ 				MsgBox(0,"","x:"&$x&@LF&"Y:"&$y)				


			$a_idBtn[$j] =_GuiCtrlCreatePNG($this_normal_png,$x , $y , $a_idForm[$i])
			GUICtrlSetOnEvent(-1,"autoCmd")
			
			GUISwitch($a_idForm[$i]) 
;~ 			_GUICtrl_OnHoverRegister(-1, "BUTTON_Hover_Proc", "BUTTON_Leave_Hover_Proc", "BUTTON_PrimaryDown_Proc", "BUTTON_PrimaryUp_Proc")
			
			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)  ;Button��ID����Ŵ������飬�Ա�cmd����
			;��ͣ����
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)
			

			_ArrayAdd($MyButtonsPics,$this_normal_png&"|"&$this_hover_png & "|"&  $x & "|"& $y & "|"& $a_idForm[$i])  ; ���ص�pngͼƬ����浽������
			
		
			
			;Button�ı���
			$len = StringLen($Accesstools[$tool_tag])
			$this_label = StringMid($Accesstools[$tool_tag], 2, $len - 2)
			
;~ 			$Form_Button_ID[$i][2]=$a_idBtn[$j] 
			
			If $j==0 Then
				$Form_Button_ID[$i][1]=$this_label
				$Form_Button_ID[$i][2]=$a_idBtn[$j] 
			Else
				$Form_Button_ID[$i][1] = $Form_Button_ID[$i][1] & "|" & $this_label
				$Form_Button_ID[$i][2] = $Form_Button_ID[$i][2] & "|" & $a_idBtn[$j]
			EndIf
			
			
		
		Next	
#CE



;~ 		GUISetState(@SW_HIDE,$a_idForm[$i])
		
		
			


			
;~ 			MsgBox(0,"",$page_num)
;~ 			$sideForm
			
;~ 			Local $page_num=Mod($this_button_nums,18)
;~ 			Local $a_idBtn[$this_button_nums]
;~ 			Local $a_idLab[$this_button_nums]	
		
	

#CS 
		$tmp_arr = StringSplit($Categorys[$i][1], "&")
		$this_button_nums = $tmp_arr[0] ;��ǰ�����Button����
		
		Local $a_idBtn[$this_button_nums]
		Local $a_idLab[$this_button_nums]

		For $j = 0 To $this_button_nums - 1
			$tool_tag = $tmp_arr[$j + 1] ;�����������еı��
			Local $row = Int($j / 7)

			If $AccessIco[$tool_tag] == "" Then
				$this_ico = @TempDir & "\button_icons\default.ico"
			Else
				$this_ico = @TempDir & "\button_icons\" & $AccessIco[$tool_tag]
			EndIf
			
			$a_idBtn[$j] = GUICtrlCreateIcon($this_ico, -1, 100 * Mod($j, 7) + 56 + 160, $row * 100 + 100, 48, 48)

			_ArrayAdd($btnID_toolTag, $a_idBtn[$j] & "|" & $tool_tag)




			GUICtrlSetResizing(-1, 802)
			$show_describe = show_button_describe($AccessDescribe[$tool_tag])
			GUICtrlSetTip(-1, $show_describe)

			;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

			GUICtrlSetCursor(-1, 0)
			GUICtrlSetOnEvent(-1, "autoCmd")


			$len = StringLen($Accesstools[$tool_tag])
			$this_label = StringMid($Accesstools[$tool_tag], 2, $len - 2)
			$a_idLab[$j] = GUICtrlCreateLabel($this_label, 100 * Mod($j, 7) + 40 +160 , $row * 100 + 150, 80, 50, $SS_CENTER)
			GUICtrlSetFont(-1, 9.5, 550, "", "΢���ź�")
;~ 			GUICtrlSetColor(-1,$COLOR_WHITE)
			GUICtrlSetResizing(-1, 802)



;~ 		Next
		
	#CE
	
;~ 	_ArrayDisplay($btnID_toolTag)
	;____________________________________________________________________________________________________________________
;~ 	$AccessCategory,$AccesstoolsNum,$Accesstools,
;~ 	Global $CommandText
;~ 	$AccessCommandText  $AccessDescribe   $AccessCategory


	;______________________________________________________________
	
	;-----------------------------------------------------------------------------------------------------------------------------------------------------
;~ 	_GDIPlus_GraphicsDrawLine($hGraphic, 0,55+$Categorysnum*40 , 160, 55+$Categorysnum*40, $hPen) ;���һ��TAB�ķָ���
	
	

	;���label�ο�����
;~ 	minimize_button()
;~ 	GUISetState( @SW_RESTORE ,$form1)

	MainFormRestore() ;��ʼ����		



	GUISwitch($Form1) ;_GuiCtrlCreatePNG�����ú��Խ���һ��form������仯�ˣ�����Ҫת������form
	GUISetState(@SW_SHOWNORMAL,$Form1) 
	WinActivate("ITbatPRO")
	
;~ 	GUISetState(@SW_SHOW, $a_idForm[0])
	GUISetState(@SW_HIDE, $a_idForm[0])
	
	While 1
;~ 		Sleep(10)
;~ 		MainFormRenew()
	WEnd


EndFunc   ;==>MainWindow



Func TAB_Hover_Proc($tabID)

	For $j = 0 To $Categorysnum-1
		If 	$tabID== ($a_idTab[$j])[1] Then
;~ 			MsgBox(0,"","tabID:"&$tabID&@LF& "lastPressed"&$lastPressedTab[0])
			
			If $tabID==$lastPressedTab[0] Then 
;~ 				MsgBox(0,"","return")
;~ 				Return
				Local $hoverPng=$MyTabsPics[$j][2]
			Else
				Local $hoverPng=$MyTabsPics[$j][1]
			EndIf
			
;~ 			Local $pos=$MyTabsPics[$j][3]
			GUISetState(@SW_SHOW,($a_idTab[$j])[0])
			_SetGraphicToControl(($a_idTab[$j])[0],$hoverPng)
			GUISetState(@SW_SHOW,($a_idTab[$j])[0])
			Return
		EndIf
		
	Next
	
EndFunc



Func TAB_Leave_Hover_Proc($tabID)
;~ 	MsgBox(0,"","tabID:"&$tabID&@LF & "lastPressed:"&$lastPressedTab[0]  )

	If $tabID==$lastPressedTab[0] Then Return ;����뿪�������һ�������tabʱ�����ỹԭ��normal״̬
	
	For $j = 0 To $Categorysnum-1
		If 	$tabID== ($a_idTab[$j])[1] Then
;~ 			Local $pos=$MyTabsPics[$j][3]
			Local $normalPng=$MyTabsPics[$j][0]
			
			_SetGraphicToControl(($a_idTab[$j])[0],$normalPng)
			Return
		EndIf
	Next
EndFunc



;TAB���ܿ�ʼ _________________________________________________________________________________________________________________
Func resetLastTab()
	Local $j=$lastPressedTab[1] ;��һ�ε�������
	Local $normalPng=$MyTabsPics[$j][0]
	_SetGraphicToControl(($a_idTab[$j])[0],$normalPng)

EndFunc


Func TAB_PrimaryDown_Proc($tabID)

EndFunc


Func TAB_PrimaryUp_Proc($tabID)
	

	If $lastPressedTab[0]<>"NO" Then
;~ 		resetLastTab();��ԭ��һ�ε����Button����ʼ̬normal
		GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;������һ�ε�form
	EndIf

    $lastPressedTab[0]=$tabID
	For $j = 0 To $Categorysnum-1
		If 	$tabID == ($a_idTab[$j])[1] Then
			$lastPressedTab[3]=$lastPressedTab[1]
			$lastPressedTab[1]=$j

			Local $j=$lastPressedTab[1]
;~ 				$lastPressedTab[0]=$a_idTab[$j]		
			$lastPressedTab[2]=$lastPressedTab[0]
			$lastPressedTab[0]=($a_idTab[$j])[1]

;~ 			Local $clickedPNG=$MyTabsPics[$j][2]
;~ 			_SetGraphicToControl(($a_idTab[$j])[0],$clickedPNG)
;~ 			WinActivate("ITbatPRO")
			
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
				If Not WinActive("ITbatPRO") Then Return
				;��ԭ��һ�ε����Button����ʼ̬normal
;~ 				resetLastTab()
				;������һ�ε�form
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]])
				
				If $lastPressedTab[1]==0 Then
					$lastPressedTab[3]=$lastPressedTab[1]
					$lastPressedTab[1]=$Categorysnum-1
				Else
					$lastPressedTab[3]=$lastPressedTab[1]
					$lastPressedTab[1]=$lastPressedTab[1]-1
				EndIf
				
				Local $j=$lastPressedTab[1]
;~ 				$lastPressedTab[0]=$a_idTab[$j]
				$lastPressedTab[2]=$lastPressedTab[0]
				$lastPressedTab[0]=($a_idTab[$j])[1]
				
				;��clicked_tab ͼƬ�޸�
;~ 				Local $clickedPNG=$MyTabsPics[$j][2]
;~ 				_SetGraphicToControl(($a_idTab[$j])[0],$clickedPNG)

				MainFormRestore()
			

		
			Case $down
;~ 				MsgBox(0,"","down")
				;��ԭ��һ�ε����Button����ʼ̬normal
;~ 				resetLastTab()
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;������һ�ε�form
				
				If $lastPressedTab[1]==$Categorysnum-1 Then
					$lastPressedTab[3]=$lastPressedTab[1]
					$lastPressedTab[1]=0
				Else
					$lastPressedTab[3]=$lastPressedTab[1]
					$lastPressedTab[1]=$lastPressedTab[1]+1
				EndIf
					
				Local $j=$lastPressedTab[1]
;~ 				$lastPressedTab[0]=$a_idTab[$j]
				$lastPressedTab[2]=$lastPressedTab[0]
				$lastPressedTab[0]=($a_idTab[$j])[1]
				
				;��clicked_tab ͼƬ�޸�
;~ 				Local $clickedPNG=$MyTabsPics[$j][2]
;~ 				_SetGraphicToControl(($a_idTab[$j])[0],$clickedPNG)
				MainFormRestore()
				

				
			Case $tab
				;��ԭ��һ�ε����Button����ʼ̬normal
;~ 				MsgBox(0,"","tab")
;~ 				resetLastTab()
				GUISetState(@SW_HIDE, $a_idForm[$lastPressedTab[1]]) ;������һ�ε�form
				
				If $lastPressedTab[1]==$Categorysnum-1 Then
					$lastPressedTab[3]=$lastPressedTab[1]
					$lastPressedTab[1]=0
;~ 					MsgBox(0,"","last:"&$lastPressedTab[1])
				Else
					$lastPressedTab[3]=$lastPressedTab[1]
					$lastPressedTab[1]=$lastPressedTab[1]+1
;~ 					MsgBox(0,"","last:"&$lastPressedTab[1])
				EndIf
				
				
				Local $j=$lastPressedTab[1]
;~ 				$lastPressedTab[0]=$a_idTab[$j]		
				$lastPressedTab[2]=$lastPressedTab[0]
				$lastPressedTab[0]=($a_idTab[$j])[1]	
				
				;��clicked_tab ͼƬ�޸�
;~ 				Local $clickedPNG=$MyTabsPics[$j][2]
;~ 				_SetGraphicToControl(($a_idTab[$j])[0],$clickedPNG)
				MainFormRestore()
;~ 				GUISwitch($Form1)
				

		EndSwitch
		
	EndIf
EndFunc

;TAB���ܽ��� _________________________________________________________________________________________________________________





Func Button_Hover_Proc($btnID)

	MsgBox(0,"",$btnID)

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
			
			

;~ 			MY_BUTTON_PAINT_HOVER($now_hover_form,$now_hover_hoverPng,$now_hover_x+160 , $now_hover_y+55 ,115,161)
			
			Return ;ֻ�����ҵ������Button�ģ�ѭ�����ؼ���������Ϳ��Է�����
		EndIf
	Next
	
EndFunc






#CS




Func MY_BUTTON_PAINT_RESTORE($form,$this_image,$p_x,$p_y,$w,$h)	
;~ 	MsgBox(0,"",$p_x&@LF&$p_y&@LF& $w+$p_x   &@LF& $h+$p_y )
	$Pointer =setTagRECT($p_x,$p_y,115+$p_x,161+$p_y) ;button����form�ĳ�ʼƫ����Ϊ (160��55)
	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
	
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x+34.5,$p_y+34.5,$w,$h)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT


Func Button_Leave_Hover_Proc($tabID)
	MY_BUTTON_PAINT_RESTORE($now_hover_form,$now_hover_normalPng,$now_hover_x+160, $now_hover_y+55 ,46,46)
	$now_hover_j=-1
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




#CE




Func search_buttonID($this_buttonID)
	
	For $j = 0 To $AccesstoolsNum
		If $this_buttonID == $btnID_toolTag[$j][0] Then
;~ 			Return $btnID_toolTag[$j][1] ;���ֵ����Button�������еı�ţ�����������
;~ 			MsgBox(0,"",$j)
			Return $j
		EndIf
	Next
EndFunc

Func MY_FORM_PAINT_CLEAR()	
;~ 	$Pointer =setTagRECT(160,55,900,600) ;����form����
;~ 	_WinAPI_RedrawWindow($form1, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
;~ 	
;~     Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT

Func MY_FORM_PAINT($j) ;����form�µ�button��label
;~ 	;���label����
	For $k=0 To 17
		GUICtrlSetData($labels[$k]," " ) ;����label��ֵ
	Next
	
	$former_j=$lastPressedTab[3]
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$former_j][1],"|")
	Local $former_buttonNUM= $tmp_arr_label[0] ;��һ��form��Button��label����
	Local $former_tmp_arr_buttonID_childform=StringSplit($Form_Button_ID[$former_j][2],"|")
	
	For $k=0 To $former_buttonNUM-1
		$this_buttonID_childform=$former_tmp_arr_buttonID_childform[$k+1] ;��ǰButtonID_��form
		_SetGraphicToControl($this_buttonID_childform,@TempDir&"\OW_button_icons\blank.png")
	Next

	
;~ 	$lastPressedTab[2]

	 ;���form����Ļ���
;~ 	MY_FORM_PAINT_CLEAR()
	
	
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$j][1],"|")
	Local $buttonNUM= $tmp_arr_label[0] ;��ǰform��Button��label����
	Local $tmp_arr_buttonID_childlabel=StringSplit($Form_Button_ID[$j][3],"|")
	Local $tmp_arr_buttonID_childform=StringSplit($Form_Button_ID[$j][2],"|")

;~ 	MsgBox(0,"",$Form_Button_ID[$j][2])

;~ 	MsgBox(0,"",$buttonNUM)
;~ 	Return

	For $k=0 To $buttonNUM-1
		$this_label=$tmp_arr_label[$k+1] ;��ǰlabel�ı�
		$this_buttonID__childlabel=$tmp_arr_buttonID_childlabel[$k+1] ;��ǰButtonID_��label
		$this_buttonID_childform=$tmp_arr_buttonID_childform[$k+1] ;��ǰButtonID_��form

;~ 		MsgBox(0,"",$this_buttonID)
		
		Local $ID_j=search_buttonID($this_buttonID__childlabel) ;Button���ڵ�������
;~ 		MsgBox(0,"",$ID_j)

		GUICtrlSetData($labels[$k],$this_label ) ;����label��ֵ
		
		Local $row = Int($k / 6)	 ;������

		Local $normal_button_PNG=$MyButtonsPics[$ID_j][1]
		_SetGraphicToControl($this_buttonID_childform,$normal_button_PNG)

		
;~ 		MY_BUTTON_PAINT($a_idForm[$j],$MyButtonsPics[$ID_j][0],49.5+Mod($k, 6)*(115+4) , 49.5 + $row*(161+4) , 46,46) ;����Buttonͼ��


;~ 		MY_BUTTON_PAINT($a_idForm[$j],$MyButtonsPics[$ID_j][1],15+Mod($k, 6)*(115+4) , 15 + $row*(161+4) ,115,161)
	Next
	
	
	
EndFunc


Func MainFormRestore()
	
	For $i=0 To $Categorysnum-1
		GUISetState(@SW_HIDE, $a_idForm[$i])
    Next
	
	;���һ�ε����TAB�����
	Local $j=$lastPressedTab[1]
	;����TAB 
	For $i = 0 To $Categorysnum - 1
		If $i==$j Then
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
			Local $clickedPNG=$MyTabsPics[$i][2]
;~ 			MsgBox(0,"",$i&@LF&$clickedPNG&@LF&($a_idTab[$i])[0])
			_SetGraphicToControl(($a_idTab[$i])[0],$clickedPNG)
		Else
;~ 			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
			Local $normalPng=$MyTabsPics[$i][0]
;~ 			MsgBox(0,"",$i&@LF&$normalPng&@LF&($a_idTab[$i])[0])
			_SetGraphicToControl(($a_idTab[$i])[0],$normalPng)
		EndIf
	Next
	;ʹ��ǰform�ɼ�
	GUISetState(@SW_SHOW, $a_idForm[$j])
	;form���button��label����
	MY_FORM_PAINT($j)

	GUISwitch($a_idForm[$j])
	GUISetState(@SW_SHOW,$a_idForm[$j])
;~ 	WinActivate("ITbatPRO")
	WinActivate("ITbatPRO")
EndFunc


#CS
Func MainFormRenew()
	
	;���һ�ε����TAB�����
	Local $j=$lastPressedTab[1]
	;����TAB 
	For $i = 0 To $Categorysnum - 1
		If $i==$j Then
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][2],0 , 55 + $i*40 )
		Else
			MY_TAB_PAINT($Form1,$MyTabsPics[$i][0],0 , 55 + $i*40 )
		EndIf
	Next
	;ʹ��ǰform�ɼ�
	GUISetState(@SW_SHOW, $a_idForm[$j])
	;form���button��label����
	
	 ;���form����Ļ���
	MY_FORM_PAINT_CLEAR()
	
	Local $tmp_arr_label=StringSplit($Form_Button_ID[$j][1],"|")
	Local $buttonNUM= $tmp_arr_label[0] ;��ǰform��Button��label����
	Local $tmp_arr_buttonID=StringSplit($Form_Button_ID[$j][2],"|")

	For $k=0 To $buttonNUM-1
		$this_label=$tmp_arr_label[$k+1] ;��ǰlabel�ı�
		$this_buttonID=$tmp_arr_buttonID[$k+1] ;��ǰButtonID
		Local $ID_j=search_buttonID($this_buttonID) ;Button���ڵ�������
		
		
		Local $row = Int($k / 6)	 ;������
		
		If $ID_j == $now_hover_j Then
			MY_BUTTON_PAINT($a_idForm[$j],$MyButtonsPics[$ID_j][1],15+Mod($k, 6)*(115+4) , 15 + $row*(161+4) ,115,161)
		Else
			MY_BUTTON_PAINT($a_idForm[$j],$MyButtonsPics[$ID_j][0],49.5+Mod($k, 6)*(115+4) , 49.5 + $row*(161+4) , 46,46) ;����Buttonͼ��
		EndIf
;~ 		
	Next
EndFunc
#CE



Func autoCmd()

;~ 	Local $btnID = @GUI_CtrlId
;~ 	For $j = 0 To $AccesstoolsNum
;~ 		If $btnID == $btnID_toolTag[$j][0] Then
;~ 			$tool_tag = $btnID_toolTag[$j][1]

			$tip = StringStripWS($Accesstools[$tool_tag], 8)
			TrayTip("", $tip & " ����ִ��", 3)
			runBat(show_button_commandtext($AccessCommandText[$tool_tag]))
			MainFormRestore()
			
;~ 			Return ;ֻ�����ҵ������Button�ģ�ѭ�����ؼ���������Ϳ��Է�����
;~ 		EndIf
;~ 	Next

EndFunc   ;==>autoCmd


Func close_button()
;~ 	_SoundClose($aSound);�˳�����
	MsgBox(0,"","close")

	
	$wait="choice /t 2 /d y /n >nul"
	$update_itbat="robocopy \\fs02\����\IT����Ĺ���  "& @ScriptDir&" /E"
	Local $update_itbat_cmd[2]=[$wait,$update_itbat]  
	runBat($update_itbat_cmd)
	
	Exit

EndFunc   ;==>close_button

Func minimize_button()
;~ 	GUISetState(@SW_LOCK,$Form1)
	GUISetState(@SW_MINIMIZE,$Form1)	
EndFunc   ;==>minimize_button


Func show_version()
	MsgBox(0,"","��ǰ�汾��"&$version &@LF&@LF&@LF & "design:            WOW_IT" & @LF &"visual design :  WOW_YW_UED")
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




Func WO_rec() ; ������֤����ʱ��¼
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\godmod.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec



#CS

Func play_button()
	GUICtrlSetState($play_button, $GUI_HIDE)
	_SoundResume($aSound)
	GUICtrlSetState($pause_button, $GUI_SHOW)
EndFunc   ;==>play_button

Func play_next_button()
	_SoundClose($aSound)
	play_backgroundmusic()
	GUICtrlSetState($play_button, $GUI_HIDE)
;~ 	_SoundResume($aSound)
	GUICtrlSetState($pause_button, $GUI_SHOW)
EndFunc   ;==>play_button

Func pause_button()
	GUICtrlSetState($pause_button, $GUI_HIDE)
	_SoundPause($aSound)
	GUICtrlSetState($play_button, $GUI_SHOW)
EndFunc   ;==>pause_button

#CE


