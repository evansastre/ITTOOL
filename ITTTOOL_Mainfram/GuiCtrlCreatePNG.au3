#include <GDIPlus.au3>
#include <GuiConstantsex.au3>
#include <WindowsConstants.au3>



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