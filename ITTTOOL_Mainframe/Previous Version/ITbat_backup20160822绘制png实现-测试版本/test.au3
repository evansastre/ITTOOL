






#Region ;**** ���������� ACNWrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** ���������� ACNWrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
;~ #include <Thread.au3>

;~ _RTEmptyWorkingSet();Thread.au3��ĺ����������ڴ�ռ�õ�
Global $hGUIxx
Global $Width = 900, $Height = 600
Global $PanBtnRect[3],$topbutton[3],$topbuttonhoverimg[3],$topbuttondownimg[3],$topbuttontip[3]

_GDIPlus_Startup()

$hGUI = GUICreate("CrossDoor_Player", $Width, $Height, -1, -1, $WS_CAPTION, $WS_EX_LAYERED)

$a_idBtn =GUICtrlCreateButton("te" ,500 , 500 , 115,161)
GUICtrlSetTip(-1, "haaaaaaaaaaaaaaaaaaaaaaaaaa1")



#region ���屳��
$bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ȫ����.jpg")
;~ $bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\ħ������hoverButton.png")
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

SetBitmap($hGUI, $Bgbitmap)
GUISetState()







#region �����ؼ����ڣ����пؼ��ڴ˴��ڽ���
;~ $ControlGUI = GUICreate("ControlGUI", 1080, 900, -1, 1, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
$ControlGUI = GUICreate("ControlGUI", 1080, 900, -1, 1, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
GUISetFont(11, 400, -1, "Comic Sans MS")
;~ GUISetBkColor(0x123456, $ControlGUI)

$a_idBtn =GUICtrlCreatePic("haha" ,200 , 200 , 115,161)
$a_idBtn =GUICtrlCreateLabel("haha11" ,300 , 200 , 115,161)
$a_idBtn =GUICtrlCreateButton("te" ,300 , 200 , 115,161)
GUICtrlSetTip(-1, "haaaaaaaaaaaaaaaaaaaaaaaaaa")

$version_label = GUICtrlCreateLabel("7.000000000000", 835, 575, 50, 22)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1,9,"","","΢���ź�")


GUISwitch($ControlGUI)
GUISetState(@SW_SHOW,$ControlGUI)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")


While 1
        Sleep(1000)
;~ 		MY_FORM_PAINT_CLEAR()	
;~ 		$Pointer =setTagRECT(160,55,900,600) ;����form����
;~ 		_WinAPI_RedrawWindow($Bgbitmap, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME, $RDW_ALLCHILDREN));
	
WEnd

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
	_WinAPI_RedrawWindow($hGUI, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT

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










