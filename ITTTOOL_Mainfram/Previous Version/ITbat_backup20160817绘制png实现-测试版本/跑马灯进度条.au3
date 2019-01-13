#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>

Example()

Func Example()
    GUICreate("跑马灯式进度条", 290, 90, -1, -1) ; 启动/停止滚动式进度条的示例.
    Local $idProgress = GUICtrlCreateProgress(10, 10, 270, 20, $PBS_MARQUEE)
    Local $idStart = GUICtrlCreateButton("开始 &S", 10, 60, 70, 25)
    Local $idStop = GUICtrlCreateButton("停止 &t", 85, 60, 70, 25)

    GUISetState(@SW_SHOW)

    ; 循环到用户退出.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

            Case $idStart
                GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 1, 50) ; 发送 $PBM_SETMARQUEE 消息和 wParam 为 1 开始进度条滚动.

            Case $idStop
                GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 0, 50) ; 发送 $PBM_SETMARQUEE 消息和 wParam 为 0 停止进度条滚动.

        EndSwitch
    WEnd
EndFunc   ;==>Example
