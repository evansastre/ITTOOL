#include <GUI_EnableDragAndResize.au3>
;~ Global $GLOBAL_MAIN_GUI, $Win_Min_ResizeX = 145, $Win_Min_ResizeY = 45


#region Example
FileInstall(".\ITbat.ico", @TempDir & "\ITbat.ico", 1)
$Form1 = GUICreate("Example GUI", 800, 600, -1, -1, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))
GUISetIcon(@TempDir & "\ITbat.ico")
GUISetBkColor(0x282828, $Form1) ;黑色
;~ GUISetBkColor(0x6495ED, $Form1)

_GUI_EnableDragAndResize($Form1,300, 150)


$Button1 = GUICtrlCreateButton("Exit", 30, 30, 120, 30)

Local $idProgress = GUICtrlCreateProgress(150, 250, 500, 20, $PBS_MARQUEE)
GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 1, 50) ; 发送 $PBM_SETMARQUEE 消息和 wParam 为 1 开始进度条滚动.

Local $idStart = GUICtrlCreateButton("开始 &S", 10, 60, 70, 25)
Local $idStop = GUICtrlCreateButton("停止 &t", 85, 60, 70, 25)

GUICtrlSetResizing($Form1, 802 )
GUISetState(@SW_SHOW)

While 1
    $Msg = GUIGetMsg()
    Switch $Msg
         Case -3, $Button1
            Exit
;~ 		Case $idStart
;~ 			GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 1, 50) ; 发送 $PBM_SETMARQUEE 消息和 wParam 为 1 开始进度条滚动.

;~ 		Case $idStop
;~ 			GUICtrlSendMsg($idProgress, $PBM_SETMARQUEE, 0, 50) ; 发送 $PBM_SETMARQUEE 消息和 wParam 为 0 停止进度条滚动.
;~ 			GUIDelete($idProgress)
;~ 			ContinueLoop
    EndSwitch
    #cs uncomment this if you have a very large listview or any other control that is very close to the gui borders, this makes sure the resize cursor gets reset properly.
        If WinActive($Form1) Then
        Local $mgetinfo = MouseGetCursor(), $aMouseInfo = GUIGetCursorInfo($Form1)
        If ($mgetinfo = 12) Or ($mgetinfo = 11) Or ($mgetinfo = 10) Or ($mgetinfo = 13) Then
        If Not ($aMouseInfo[4] = 0) Then GUISetCursor(2, 1)
        EndIf
        EndIf
    #ce
WEnd
Sleep(3000)
GUIDelete($idProgress)
#endregion Example

