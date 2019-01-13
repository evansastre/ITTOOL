#include <GUIConstantsEx.au3>

Example()

Func Example()
    Local $hGUIParent1 = GUICreate("父窗 1")
    GUICtrlCreateTab(10, 10)
    Local $idTabItem = GUICtrlCreateTabItem("标签页 1")
    GUICtrlCreateTabItem("标签页 2")
    GUICtrlCreateTabItem("")

    Local $hGUIParent2 = GUICreate("父窗 2", -1, -1, 100, 100)

    GUISwitch($hGUIParent2)
    GUISetState(@SW_SHOW)

    ; 循环到用户退出.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

        EndSwitch
    WEnd

    GUISwitch($hGUIParent1, $idTabItem)
	GUICtrlCreateGroup("",10,10,50,50)
    GUICtrlCreateButton("Confirm", 50, 50, 50)
    GUICtrlCreateTabItem("")

    GUISetState(@SW_SHOW, $hGUIParent1)
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
        EndSwitch
    WEnd

    GUIDelete($hGUIParent1)
    GUIDelete($hGUIParent2)
EndFunc   ;==>Example
