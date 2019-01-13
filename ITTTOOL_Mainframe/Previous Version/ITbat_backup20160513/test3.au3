#NoTrayIcon
#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIScroll.au3>
#include <SendMessage.au3>
Opt("GUIResizeMode", 802)

Global $parentgui_w = 880, $parentgui_h = 810, $childgui_w = $parentgui_w - 2, $childgui_h = $parentgui_h - 292

$parentgui = GUICreate("Scrollbar resize problem", $parentgui_w, $parentgui_h, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SIZEBOX))
GUISetBkColor(0xFFFFFF, $parentgui)

$childgui = GUICreate("", $childgui_w, $childgui_h, -5, 263, $WS_POPUP, $WS_EX_MDICHILD, $parentgui)
GUISetBkColor(0xFFF123, $childgui)
Dim $buttons[25]

For $i = 0 to 24
    If $i > 0 Then
        $cPos = ControlGetPos($childgui, "", $buttons[$i - 1])
        $buttons[$i] = GUICtrlCreateButton("Button " & $i + 1, ($childgui_w - 200) / 2, $cPos[1] + $cPos[3] + 50, 200, 80)
    Else
        $buttons[$i] = GUICtrlCreateButton("Button " & $i + 1, ($childgui_w - 200) / 2, 20, 200, 80)
    EndIf
Next

Scrollbar_Create($childgui, $SB_VERT, 130 * 25)
Scrollbar_Step(15, $childgui, $SB_VERT)

GUIRegisterMsg($WM_SIZE, "WM_SIZE")
GUIRegisterMsg($WM_NCACTIVATE, "WM_NCACTIVATE")
GUIRegisterMsg($WM_MOUSEWHEEL, "WM_MOUSEWHEEL")

GUISetState(@SW_SHOW, $parentgui)
GUISetState(@SW_SHOWNOACTIVATE, $childgui)

While 1
    $msg = GUIGetMsg(1)
    Switch $msg[1]
        Case $parentgui
            Switch $msg[0]
                Case $GUI_EVENT_CLOSE
                    Exit
                Case $GUI_EVENT_RESTORE
                    $pPos = WinGetPos($parentgui)
                    WinMove($parentgui, "", Default, Default, $pPos[2]+1, $pPos[3]+1)
                    WinMove($parentgui, "", Default, Default, $pPos[2]-1, $pPos[3]-1)
            EndSwitch
    EndSwitch
WEnd

Func WM_MOUSEWHEEL($hWnd, $iMsg, $wParam, $lParam)
    Local $iMw = BitShift($wParam, 16)
    $scroll_lines = 5

    If $iMw > 0 Then
        For $i = 0 to $scroll_lines
            _SendMessage($childgui, $WM_VSCROLL, $SB_LINEUP)
        Next
    Else
        For $i = 0 to $scroll_lines
            _SendMessage($childgui, $WM_VSCROLL, $SB_LINEDOWN)
        Next
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc

Func WM_SIZE($hwnd, $uMsg, $wParam, $lParam)
    If $hwnd = $parentgui Then
        $wPos = WinGetPos($parentgui)
        $pgui_wdiff = ($wPos[2] - $parentgui_w) / 2
        $pgui_hdiff = ($wPos[3] - $parentgui_h) / 2
        If $pgui_wdiff > 7 Then
            If $pgui_hdiff <> 0 Then
                If $wPos[2] > $parentgui_w Then
                    WinMove($childgui, "", $wPos[0] + 2 + $pgui_wdiff, Default, $parentgui_w - 2, $wPos[3] - 306)
                Else
                    WinMove($childgui, "", $wPos[0] + 2 + $pgui_wdiff, Default, $wPos[2] - 16, $wPos[3] - 306)
                EndIf
            Else
                WinMove($childgui, "", $wPos[0] + 2 + $pgui_wdiff, Default)
            EndIf
        ElseIf $pgui_wdiff < 7 Then
            If $wPos[0] <> -32000 Then
                WinMove($childgui, "", $wPos[0] + 8, Default, $wPos[2] - 16, $wPos[3] - 306)
            EndIf
        ElseIf $pgui_hdiff > 42 Then
            WinMove($childgui, "", Default, Default, Default, $wPos[3] - 306)
        EndIf
    EndIf
    Return 0
EndFunc

Func WM_NCACTIVATE($hwnd, $imsg, $wparam)
    If $hwnd = $parentgui Then
        If NOT $wparam Then Return 1
    EndIf
    Return $gui_rundefmsg
EndFunc