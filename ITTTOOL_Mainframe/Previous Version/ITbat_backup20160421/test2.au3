#include <GUIConstantsEx.au3>

Example()

Func Example()
    GUICreate(" ͼ��ؼ� GUI", 250, 250)

;~     $button1=GUICtrlCreateIcon("shell32.dll", 10, 20, 20)
    $button1=GUICtrlCreateButton("ħ������", 20, 20,100,60)
	GUICtrlSetImage($button1,"shell32.dll",10,1)
;~ 	"shell32.dll"
;~     GUICtrlCreateIcon(@ScriptDir & '\Extras\horse.ani', -1, 20, 40, 32, 32)
;~     GUICtrlCreateIcon(@ScriptDir & '\Extras\horse.ani', -1, 20, 40, 32, 32)
    $button2=GUICtrlCreateIcon("shell32.dll", 7, 20, 75, 32, 32)
    GUISetState(@SW_SHOW)

    ; ѭ�����û��˳�.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
			Case $button1
				MsgBox(0,"","button1")
			Case $button2
				MsgBox(0,"","button2")
				
        EndSwitch
    WEnd

    GUIDelete()
EndFunc   ;==>Example
