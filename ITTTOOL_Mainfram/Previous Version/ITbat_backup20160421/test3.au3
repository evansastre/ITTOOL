#include <GUIConstantsEx.au3>

Example()

Func Example()
    Local $hGUIParent1 = GUICreate("���� 1")
    GUICtrlCreateTab(10, 10)
    Local $idTabItem = GUICtrlCreateTabItem("��ǩҳ 1")
    GUICtrlCreateTabItem("��ǩҳ 2")
    GUICtrlCreateTabItem("")

    Local $hGUIParent2 = GUICreate("���� 2", -1, -1, 100, 100)

    GUISwitch($hGUIParent2)
    GUISetState(@SW_SHOW)

    ; ѭ�����û��˳�.
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
