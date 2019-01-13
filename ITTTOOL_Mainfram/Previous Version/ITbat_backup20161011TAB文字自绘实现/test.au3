






#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
;~ #include <Thread.au3>

;~ _RTEmptyWorkingSet();Thread.au3里的函数，减少内存占用的



Opt("GUIOnEventMode", 1)

Global $hGUIxx
Global $Width = 900, $Height = 600
Global $PanBtnRect[3],$topbutton[3],$topbuttonhoverimg[3],$topbuttondownimg[3],$topbuttontip[3]

_GDIPlus_Startup()

$hGUI = GUICreate("CrossDoor_Player", $Width, $Height, -1, -1, $WS_CAPTION, $WS_EX_LAYERED)

$a_idBtn =GUICtrlCreateButton("te" ,500 , 500 , 115,161)
GUICtrlSetTip(-1, "haaaaaaaaaaaaaaaaaaaaaaaaaa1")



#region 窗体背景
$bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\全背景.jpg")
;~ $bg = _GDIPlus_ImageLoadFromFile("C:\Users\Public\Pictures\Sample Pictures\八仙花.jpg")
;~ $bg = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\魔兽世界hoverButton.png")
$hGraphic = _GDIPlus_ImageGetGraphicsContext($bg)

$Bgbitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphic)
$hGraphic2 = _GDIPlus_ImageGetGraphicsContext($Bgbitmap)
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $bg, 0, 0, $Width, $Height)

$logo = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\IT工具-logo.png")
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $logo,  10, 7, 145, 37)
$mini = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\翻页码1.png")
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $mini, 380, 0, 35, 18)
$max = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\翻页码2.png")
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $max, 408, 0, 35, 18)
$close = _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\魔兽世界hoverButton.png")
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $close, 436, 0, 115,161)

$testB= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\魔兽世界-默认Button.png")
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testB,49.5 +160, 49.5+55, 46,46)

$testA= _GDIPlus_ImageLoadFromFile(@TempDir & "\OW_itbat_materials\BGstyle\魔兽世界hoverButton.png")
_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testA,15 +160, 15+55+3, 115,161)

SetBitmap($hGUI, $Bgbitmap)
GUISetState()







#region 创建控件窗口，所有控件在此窗口建立
;~ $ControlGUI = GUICreate("ControlGUI", 1080, 900, -1, 1, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
$ControlGUI = GUICreate("ControlGUI", 1080, 900, -1, 1, $WS_POPUP, BitOR($WS_EX_LAYERED , $WS_EX_MDICHILD), $hGUI)
GUISetFont(11, 400, -1, "Comic Sans MS")
GUISetBkColor(0x123456, $ControlGUI)

;~ $version_label = GUICtrlCreateLabel("7.000000000000", 835, 575, 50, 22)
$version_label = GUICtrlCreateLabel("7.00000", 15 +160, 15+55+3, 115,161)
GUICtrlSetColor(-1,0xFFFFFF)
;~ GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1,9,"","","微软雅黑")
GUICtrlSetTip(-1, "haaatesttest")
GUICtrlSetOnEvent($version_label,"testfun")


_API_SetLayeredWindowAttributes($ControlGUI, 0x123456, 195)
GUISwitch($ControlGUI)
GUISetState(@SW_SHOW,$ControlGUI)
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
;~ GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
;~ GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")

While 1
        Sleep(1000)
;~ 		MY_FORM_PAINT_CLEAR()	
;~ 		$Pointer =setTagRECT(160,55,900,600) ;整个form区域
;~ 		_WinAPI_RedrawWindow($Bgbitmap, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME, $RDW_ALLCHILDREN));
	
WEnd


#include <WinAPITheme.au3>

Func testfun()
	MsgBox(0,"","111")
	$Pointer =setTagRECT(160,55,900,600) ;整个form区域
	$testC= _GDIPlus_ImageLoadFromFile("C:\Users\TestUser1\AppData\Local\Temp\OW_button_icons\Blank.png")
;~ 	_GDIPlus_GraphicsClear($hGraphic2)
;~ 	_GDIPlus_GraphicsDrawImageRect($hGraphic2, $testC,15 +160, 15+55+3, 115,161)

	_WinAPI_BufferedPaintClear ( $hGraphic2 )
	_WinAPI_BufferedPaintClear ( $hGraphic )
	SetBitmap($hGUI, $Bgbitmap)

	MY_FORM_PAINT_CLEAR()
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
	_WinAPI_RedrawWindow($hGUI, $Pointer, "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
	
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT


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










