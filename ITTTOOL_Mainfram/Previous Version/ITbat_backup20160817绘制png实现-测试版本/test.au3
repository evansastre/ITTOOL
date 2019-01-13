#include <APIConstants.au3>
#include <WinAPIEx.au3>
#include <GDIPlus.au3>
;~ #include <GDIPlusEx.au3>
#include <GuiSlider.au3>
Global $alphaOfBack = 0, $alphaOfRed = 0x80, $alphaOfGreen = 0x80
GUICreate("��ʮ�߽� GDI+���ģʽ͸����", 300, 300)
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
        GUICtrlCreateLabel("��ɫ͸����", 5, 205)
        $rect[0][0] = GUICtrlCreateSlider(65, 205, 100)
        GUICtrlSetLimit(-1, 0xFF, 0)
        GUICtrlSetData(-1, $alphaOfBack)
        _GUICtrlSlider_SetTicFreq(-1, 16)
        $rect[0][1] = GUICtrlCreateLabel("", 175, 205, 40, 25)
        GUICtrlSetData(-1, $alphaOfBack)
 
        GUICtrlCreateLabel("��ɫ͸����", 5, 235)
        $rect[1][0] = GUICtrlCreateSlider(65, 235, 100)
        GUICtrlSetLimit(-1, 0xFF, 0)
        GUICtrlSetData(-1, $alphaOfRed)
        _GUICtrlSlider_SetTicFreq(-1, 16)
        $rect[1][1] = GUICtrlCreateLabel("", 175, 235, 40, 25)
        GUICtrlSetData(-1, $alphaOfRed)
 
        GUICtrlCreateLabel("��ɫ͸����", 5, 265)
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
        BackColor($hGraphics);���Ʊ���������
        
;~ ;========================���ɻ��ģʽΪ�ϳɵ�ͼƬ�����뱳�������Ʒֱ��úϳɺ͸��Ƿ�ʽ���������ʾ===================================================
        $hBitmap = myImage($hGraphics, 0)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "ͼƬ�ϳɱ���", 5, 80)
        _GDIPlus_GraphicsTranslateTransform($hGraphics, 0, 100)
        
        _GDIPlus_GraphicsSetCompositingMode($hGraphics, 1)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "ͼƬ���Ǳ���", 5, 80)
        _GDIPlus_BitmapDispose($hBitmap)
;~ ;========================�����ʾ����===================================================
 
;~ ;========================���ɻ��ģʽΪ���ǵ�ͼƬ�����뱳�������Ʒֱ��úϳɺ͸��Ƿ�ʽ�����Ҳ���ʾ===================================================
        $hBitmap = myImage($hGraphics, 1)
        _GDIPlus_GraphicsResetTransform($hGraphics)
        _GDIPlus_GraphicsTranslateTransform($hGraphics, 150, 0)
        _GDIPlus_GraphicsSetCompositingMode($hGraphics, 0)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "ͼƬ�ϳɱ���", 5, 80)
        
        _GDIPlus_GraphicsTranslateTransform($hGraphics, 0, 100)
        _GDIPlus_GraphicsSetCompositingMode($hGraphics, 1)
        _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 100, 80)
        _GraphicsDrawString($hGraphics, "ͼƬ���Ǳ���", 5, 80)
        _GDIPlus_BitmapDispose($hBitmap)
;~ ;========================�Ҳ���ʾ����===================================================
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
                _GraphicsDrawString($hBackbuffer, "ͼƬ�ϳ�ģʽ", 5, 40)
        Else
                _GraphicsDrawString($hBackbuffer, "ͼƬ����ģʽ", 5, 40)
        EndIf
        ;�ͷŻ���
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
        ;�ͷŻ���
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
