#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>

Example()

Func Example()
    GUICreate("�����ʽ������", 290, 90, -1, -1) ; ����/ֹͣ����ʽ��������ʾ��.
    Local $idProgress = GUICtrlCreateProgress(10, 10, 270, 20, $PBS_MARQUEE)
    Local $idStart = GUICtrlCreateButton("��ʼ &S", 10, 60, 70, 25)
    Local $idStop = GUICtrlCreateButton("ֹͣ &t", 85, 60, 70, 25)

    GUISetState(@SW_SHOW)

    ; ѭ�����û��˳�.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

            Case $idStart
                GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 1, 50) ; ���� $PBM_SETMARQUEE ��Ϣ�� wParam Ϊ 1 ��ʼ����������.

            Case $idStop
                GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 0, 50) ; ���� $PBM_SETMARQUEE ��Ϣ�� wParam Ϊ 0 ֹͣ����������.

        EndSwitch
    WEnd
EndFunc   ;==>Example
