#include <GDIPlus.au3>
#include <GuiConstantsex.au3>
#include <WindowsConstants.au3>
#include "GUI_EnableDragAndResize.au3"



Global $hWNDMain = GUICreate("ITbatPRO", 900, 600, -1, -1)
GUISetIcon(@TempDir & "\OW_itbat_materials\ITbat.ico")
;~ GUISetOnEvent($GUI_EVENT_RESTORE, "MainFormRestore")
;~ 	GUISetBkColor(0x282828); 背景黑透明色
GUISetCursor(2,1)

GUISetState(@SW_SHOW,$hWNDMain)

_GUI_EnableDragAndResize($hWNDMain, 900, 600, 900, 600)

;全背景
$backgroud_img=@TempDir & "\OW_itbat_materials\BGstyle\全背景.jpg"
Global $backgroud = GUICtrlCreatePic($backgroud_img,0,0,900,600,-1,$WS_EX_LAYERED)
GuiCtrlSetState(-1,$GUI_DISABLE)
GUICtrlSetState($backgroud, $GUI_SHOW)

;侧边栏

_GDIPlus_StartUp() ;启动GDI+
	
;~ Dim $Image_OneButton = @ScriptDir&"\Button1.png"
Dim $Image_OneButton = @ScriptDir&"\Button3.png"
Dim $Image_TwoButton = @ScriptDir&"\Button2.png"


Global $g_hGraphic = _GDIPlus_GraphicsCreateFromHWND($hWNDMain)
;~ $Button = _GuiCtrlCreatePNG($Image_OneButton,0 , 0, $hWNDMain)
$Button = _GuiCtrlCreatePNG($Image_OneButton,300 , 300, $hWNDMain)
$CurrentImage = $Image_OneButton


Local $this_hover=_GDIPlus_ImageLoadFromFile(@ScriptDir&"\Button3.png")
MY_BUTTON_PAINT_HOVER($hWNDMain,$this_hover,160 , 300 ,115,161)

Func MY_BUTTON_PAINT_HOVER($form,$this_image,$p_x,$p_y,$w,$h)	
;~ 	MsgBox(0,"",$p_x&@LF&$p_y&@LF& $w+$p_x   &@LF& $h+$p_y )
	$Pointer =setTagRECT($p_x,$p_y,$w+$p_x,$h+$p_y) ;button所在form的初始偏移量为 (160，55)
	_WinAPI_RedrawWindow($hWNDMain, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
	
    _GDIPlus_GraphicsDrawImageRect($g_hGraphic, $this_image, $p_x,$p_y,$w,$h)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT


Func setTagRECT($left,$top,$right,$bottom)
	Global $struct = DllStructCreate($tagRECT)			;struct erstellen
	DllStructSetData($struct,"Left" , 	$left) 	;hier die parameter eingeben
	DllStructSetData($struct,"Top", 	$top)	;struct beschreiben 
	DllStructSetData($struct,"Right", 	$right)
	DllStructSetData($struct,"Bottom",	$bottom)
	Global $Pointer = DllStructGetPtr($struct)
	
	Return $Pointer
EndFunc



Dim $GO = False
while 1

	Sleep(100)

    Switch GUIGetMsg()
        Case $Button[1]
            Msgbox(0,"","Button Clicked")
        case -3 ; $GUI_EVENT_CLOSE
            exit
        _GDIPlus_Shutdown()

        Case Else
        
            $aMouse = GUIGetCursorInfo()
            If NOT IsArray($aMouse) then ContinueCase
            If $aMouse[4] = $Button[1] and $CurrentImage <> $Image_TwoButton then
                $CurrentImage = _SetGraphicToControl($Button[0],$Image_TwoButton)
            ElseIf $aMouse[4] <> $Button[1] and $CurrentImage <> $Image_OneButton Then
                $CurrentImage = _SetGraphicToControl($Button[0],$Image_OneButton)
            EndIf

    EndSwitch



WEnd





Func _SetGraphicToControl($hControl,$sImage)

    Local $hImage
    If NOT FileExists($sImage) then Return 0
    $hImage = _GDIPlus_ImageLoadFromFile($sImage)
    SetBitmap($hControl,$hImage)
    _GDIPlus_ImageDispose($hImage)
    Return $sImage

EndFunc

Func _GuiCtrlCreatePNG($sImage,$iPosX, $iPosY, $hMainGUI)

    Local $hImage, $iw,$iH, $ret[2]
    $hImage = _GDIPlus_ImageLoadFromFile($sImage)
    $iW = _GDIPlus_ImageGetWidth($hImage)
    $iH = _GDIPlus_ImageGetHeight($hImage)
    $Ret[0] = GUICreate("", $iW,$iH, $iPosX, $iPosY,$WS_POPUP,BitOR($WS_EX_LAYERED,$WS_EX_MDICHILD),$hMainGUI)
    $Ret[1] = GUICtrlCreateLabel("",0,0,$iW,$iH)
    SetBitmap($Ret[0],$hImage)
    GUISetState(@SW_SHOW,$Ret[0])
    _GDIPlus_ImageDispose($hImage)

    Return $Ret

EndFunc


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