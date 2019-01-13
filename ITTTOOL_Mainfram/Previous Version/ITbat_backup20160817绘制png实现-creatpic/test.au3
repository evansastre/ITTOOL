#include <APIConstants.au3>
#include <WinAPIEx.au3>
#include <GDIPlus.au3>
;~ #include <GDIPlusEx.au3>
#include <GuiSlider.au3>
Global $alphaOfBack = 0, $alphaOfRed = 0x80, $alphaOfGreen = 0x80
GUICreate("第十七讲 GDI+混合模式透明度", 300, 300)
$nCtrlId = GUICtrlCreatePic("", 0, 0, 300, 200)
$hPicWnd = GUICtrlGetHandle($nCtrlId)
 
Global $rect[3][2]
init()
GUIRegisterMsg($WM_HSCROLL, "onHSCROLL")
GUISetState()
 
update()
 
While 1
        $Msg = GUIGetMsg()
        Switch $Msg
                Case -3
                        ExitLoop
 
        EndSwitch
WEnd
 
GUIDelete()
Exit
 
Func init()
        GUICtrlCreateLabel("黄色透明度", 5, 205)
        $rect[0][0] = GUICtrlCreateSlider(65, 205, 100)
        GUICtrlSetLimit(-1, 0xFF, 0)
        GUICtrlSetData(-1, $alphaOfBack)
        _GUICtrlSlider_SetTicFreq(-1, 16)
        $rect[0][1] = GUICtrlCreateLabel("", 175, 205, 40, 25)
        GUICtrlSetData(-1, $alphaOfBack)
 
        GUICtrlCreateLabel("红色透明度", 5, 235)
        $rect[1][0] = GUICtrlCreateSlider(65, 235, 100)
        GUICtrlSetLimit(-1, 0xFF, 0)
        GUICtrlSetData(-1, $alphaOfRed)
        _GUICtrlSlider_SetTicFreq(-1, 16)
        $rect[1][1] = GUICtrlCreateLabel("", 175, 235, 40, 25)
        GUICtrlSetData(-1, $alphaOfRed)
 
        GUICtrlCreateLabel("绿色透明度", 5, 265)
        $rect[2][0] = GUICtrlCreateSlider(65, 265, 100)
        GUICtrlSetLimit(-1, 0xFF, 0)
        GUICtrlSetData(-1, $alphaOfGreen)
        _GUICtrlSlider_SetTicFreq(-1, 16)
        $rect[2][1] = GUICtrlCreateLabel("", 175, 265, 40, 25)
        GUICtrlSetData(-1, $alphaOfGreen)
EndFunc   ;==>init
 
Func onHSCROLL($hWnd, $iMsg, $wParam, $lParam)
        Switch _WinAPI_GetDlgCtrlID($lParam)
                Case $rect[0][0]
                        $alphaOfBack = GUICtrlRead($rect[0][0])
                        GUICtrlSetData($rect[0][1], $alphaOfBack)
                Case $rect[1][0]
                        $alphaOfRed = GUICtrlRead($rect[1][0])
                        GUICtrlSetData($rect[1][1], $alphaOfRed)
                Case $rect[2][0]
                        $alphaOfGreen = GUICtrlRead($rect[2][0])
                        GUICtrlSetData($rect[2][1], $alphaOfGreen)
        EndSwitch
        update()
EndFunc   ;==>onHSCROLL
 
Func update()
        Local $HWND_CX = _WinAPI_GetWindowWidth($hPicWnd)
        Local $HWND_CY = _WinAPI_GetWindowHeight($hPicWnd)
        _GDIPlus_Startup()
        Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hPicWnd)
        Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics($HWND_CX, $HWND_CY, $hGraphics)
        Local $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
        _GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)
        DoubleDraw($hBackbuffer)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $HWND_CX, $HWND_CY)
        _GDIPlus_BitmapDispose($hBitmap)
        _GDIPlus_GraphicsDispose($hBackbuffer)
        _GDIPlus_GraphicsDispose($hGraphics)
        _GDIPlus_Shutdown()
EndFunc   ;==>update
 
Func DoubleDraw($hGraphics)
        Local $hBitmap
        BackColor($hGraphics);绘制背景竖条纹
        
;~ ;========================生成混合模式为合成的图片，并与背景竖条纹分别用合成和覆盖方式，在左侧显示===================================================
        $hBitmap = myImage($hGraphics, 0)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "图片合成背景", 5, 80)
        _GDIPlus_GraphicsTranslateTransform($hGraphics, 0, 100)
        
        _GDIPlus_GraphicsSetCompositingMode($hGraphics, 1)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "图片覆盖背景", 5, 80)
        _GDIPlus_BitmapDispose($hBitmap)
;~ ;========================左侧显示结束===================================================
 
;~ ;========================生成混合模式为覆盖的图片，并与背景竖条纹分别用合成和覆盖方式，在右侧显示===================================================
        $hBitmap = myImage($hGraphics, 1)
        _GDIPlus_GraphicsResetTransform($hGraphics)
        _GDIPlus_GraphicsTranslateTransform($hGraphics, 150, 0)
        _GDIPlus_GraphicsSetCompositingMode($hGraphics, 0)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "图片合成背景", 5, 80)
        
        _GDIPlus_GraphicsTranslateTransform($hGraphics, 0, 100)
        _GDIPlus_GraphicsSetCompositingMode($hGraphics, 1)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "图片覆盖背景", 5, 80)
        _GDIPlus_BitmapDispose($hBitmap)
;~ ;========================右侧显示结束===================================================
EndFunc   ;==>DoubleDraw
 
Func myImage($hGraphics, $i)
        Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics(100, 80, $hGraphics)
        Local $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
        _GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)
        _GDIPlus_GraphicsClear($hBackbuffer, BitOR(BitShift($alphaOfBack, -24), 0xFFFF00))
        Local $hBrushback = _GDIPlus_BrushCreateSolid(BitOR(BitShift($alphaOfGreen, -24), 0x00FF00))
        Local $hBrushtop = _GDIPlus_BrushCreateSolid(BitOR(BitShift($alphaOfRed, -24), 0xFF0000))
        _GDIPlus_GraphicsSetCompositingMode($hBackbuffer, $i)
        _GDIPlus_GraphicsFillEllipse($hBackbuffer, 0, 0, 100, 80, $hBrushback)
        _GDIPlus_GraphicsFillEllipse($hBackbuffer, 20, 10, 50, 60, $hBrushtop)
        If $i = 0 Then
                _GraphicsDrawString($hBackbuffer, "图片合成模式", 5, 40)
        Else
                _GraphicsDrawString($hBackbuffer, "图片覆盖模式", 5, 40)
        EndIf
        ;释放画笔
        _GDIPlus_BrushDispose($hBrushback)
        _GDIPlus_BrushDispose($hBrushtop)
        _GDIPlus_GraphicsDispose($hBackbuffer)
        Return $hBitmap
EndFunc   ;==>myImage
 
Func BackColor($hGraphics)
        Local $hPen = _GDIPlus_PenCreate(0xFF000000)
        Local $r, $g, $b, $color
        For $i = 0 To 300
                $r = Random(0, 255)
                $g = Random(0, 255)
                $b = Random(0, 255)
                $color = BitOR(0xFF000000, _;Alpha
                                BitShift($r, -16), _;Red
                                BitShift($g, -8), _;Green
                                $b);Blue
                _GDIPlus_PenSetColor($hPen, $color)
                _GDIPlus_GraphicsDrawLine($hGraphics, $i, 0, $i, 200, $hPen)
        Next
        ;释放画笔
        _GDIPlus_PenDispose($hPen)
EndFunc   ;==>BackColor
 
Func _GraphicsDrawString($hGraphics, $sString, $nX, $nY, $hBrush = 0, $sFont = "Arial", $nSize = 10, $iFormat = 0)
        Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
        Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
        Local $hFont = _GDIPlus_FontCreate($hFamily, $nSize)
        Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0, 0)
        Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
        __GDIPlus_BrushDefCreate($hBrush)
        Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
        Local $iError = @error
        __GDIPlus_BrushDefDispose()
        _GDIPlus_FontDispose($hFont)
        _GDIPlus_FontFamilyDispose($hFamily)
        _GDIPlus_StringFormatDispose($hFormat)
        Return SetError($iError, 0, $aResult)
EndFunc   ;==>_GraphicsDrawString
