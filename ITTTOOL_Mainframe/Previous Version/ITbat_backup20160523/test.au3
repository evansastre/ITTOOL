#include <GUIConstantsEx.au3>
#include <GuiTab.au3>

Example()

Func Example()
    Local $idTab

    ; ���� GUI
    GUICreate("���ñ�ǩ��Ŀ����", 400, 300)
    $idTab = GUICtrlCreateTab(2, 2, 396, 296, $TCS_BUTTONS)
    GUISetState(@SW_SHOW)

    ; ���ѡ���ǩ
    _GUICtrlTab_InsertItem($idTab, 0, "ѡ���ǩ 1")
    _GUICtrlTab_InsertItem($idTab, 1, "ѡ���ǩ 2")
    _GUICtrlTab_InsertItem($idTab, 2, "ѡ���ǩ 3")

    ; ������ʾ��ǩ 2
    _GUICtrlTab_HighlightItem($idTab, 1)

    ; ѭ�����û��˳�.
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE
    GUIDelete()
EndFunc   ;==>Example
