#include <GUIConstantsEx.au3>
#include <GuiTab.au3>

Example()

Func Example()
    Local $idTab

    ; 创建 GUI
    GUICreate("设置标签项目高亮", 400, 300)
    $idTab = GUICtrlCreateTab(2, 2, 396, 296, $TCS_BUTTONS)
    GUISetState(@SW_SHOW)

    ; 添加选项标签
    _GUICtrlTab_InsertItem($idTab, 0, "选项标签 1")
    _GUICtrlTab_InsertItem($idTab, 1, "选项标签 2")
    _GUICtrlTab_InsertItem($idTab, 2, "选项标签 3")

    ; 高亮显示标签 2
    _GUICtrlTab_HighlightItem($idTab, 1)

    ; 循环到用户退出.
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE
    GUIDelete()
EndFunc   ;==>Example
