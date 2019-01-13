#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#Include <Misc.au3>
#include <WindowsConstants.au3>

;Opt("MustDeclareVars", 1)

; ===============================================================================================================================
; Description ...: Shows how to display a PNG image
; Author ........: Andreas Klein
; Notes .........:
; ===============================================================================================================================

; ===============================================================================================================================
; Global variables
; ===============================================================================================================================
Global $hGUI, $hImage1, $hImage2, $hGraphic, $label_cursorinfo, $cursorinfo, $mousepos

; Create GUI
$hGUI = GUICreate("Show PNG", 350, 350)

$label_cursorinfo = GUICtrlCreateLabel(" ",10,300,50,50)
$label_bgimage = GUICtrlCreateLabel("", 0, 0, 300, 300)
$label_fgimage = GUICtrlCreateLabel("", 10, 10, 200, 200)
GUICtrlSetState($label_cursorinfo,@SW_HIDE)

GUISetState()

; Load PNG image
_GDIPlus_StartUp()
$hImage1   = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\win7.png")
$hImage2  = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Rainbow_trout_transparent.png")

; Draw PNG image
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

; Loop until user exits
WM_PAINT()
GUIRegisterMsg($WM_PAINT, "WM_PAINT")

$handle_image1 = _GDIPlus_ImageGetGraphicsContext($hImage1)
$handle_image2 = _GDIPlus_ImageGetGraphicsContext($hImage2)

While 1
    $aCtrlHover = GUIGetCursorInfo($hGUI)
    Switch $aCtrlHover[4]
    Case $label_cursorinfo
        ToolTip("Label hovered!" & @CRLF & "ID: " & $label_cursorinfo)
    Case $label_bgimage
        ToolTip("Image1 hovered!" & @CRLF & "ID: " & $handle_image1)
    Case $label_fgimage
        ToolTip("Image2 hovered!" & @CRLF & "ID: " & $handle_image2)
    Case 0
        ToolTip("No Control hovered" & @CRLF & $aCtrlHover[4])
    EndSwitch

    Sleep(50)
    Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
    EndSwitch
WEnd

Func WM_PAINT()
    _WinAPI_RedrawWindow($hGUI, "", "", BitOR($RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME));
    _GDIPlus_GraphicsDrawImageRect($hGraphic,$hImage2,0,0,300,300)
    _GDIPlus_GraphicsDrawImageRect($hGraphic,$hImage1,10,10,200,200)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_PAINT

; Clean up resources
_GDIPlus_GraphicsDispose($hGraphic)
_GDIPlus_ImageDispose($hImage1)
_GDIPlus_ImageDispose($hImage2)
_GDIPlus_ShutDown() 