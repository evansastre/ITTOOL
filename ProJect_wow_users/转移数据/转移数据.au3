#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\转移数据.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>
#include <Excel.au3>
#include <Array.au3>
#include <GUIToolTip.au3>
#include "backup.au3"
#include "Recovery.au3"
#include "Sync.au3"
#include "runBat.au3"

MainWindow()
Func MainWindow()
	Opt("GUIOnEventMode", 1)
	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("用户数据转移工具", 521, 150, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetState(@SW_SHOW)

	$Button1 = GUICtrlCreateButton("备份", 46, 36, 90, 65)
    GUICtrlSetOnEvent($Button1,"backup")
	Local $hButton1 = GUICtrlGetHandle($Button1)
    Local $hToolTip1 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip1, 0, "重装系统时，备份本机用户数据到E盘，E盘空间不足时可选其他盘符", $hButton1)

	$Button2 = GUICtrlCreateButton("恢复", 198, 36, 90, 65)
	GUICtrlSetOnEvent($Button2,"Recovery")
	Local $hButton2 = GUICtrlGetHandle($Button2)
    Local $hToolTip2 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip2, 0, "从历史的备份中恢复用户的数据", $hButton2)
	
	$Button3 = GUICtrlCreateButton("新机器同步", 350, 36, 90, 65)
	GUICtrlSetOnEvent($Button3,"Sync")
	Local $hButton3 = GUICtrlGetHandle($Button3)
    Local $hToolTip3 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip3, 0, "从原主机中完整拷贝数据到新机", $hButton3)
	
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	
	While 1
		Sleep(100) ; 休眠, 以降低 CPU 使用率
	WEnd
	;以下是消息模式实现，当前使用事件模式。如使用消息模式，需要注释掉上方 Opt("GUIOnEventMode", 1) 以及每个GUISetOnEvent(), sleep循环
;~ 	While 1
;~ 		$nMsg = GUIGetMsg()
;~ 		Switch $nMsg
;~ 			Case $Button1
;~ 				backup()
;~ 				;ExitLoop
;~ 			Case $Button2
;~ 				Recovery()
;~ 				;ExitLoop
;~ 			Case $Button3
;~ 				Sync()
;~ 				;ExitLoop
;~ 			Case $GUI_EVENT_CLOSE
;~ 				ExitLoop
;~ 		EndSwitch
;~ 	WEnd
;~ 	
;~ 	_GUIToolTip_Destroy($hToolTip1)
;~ 	_GUIToolTip_Destroy($hToolTip2)
;~ 	_GUIToolTip_Destroy($hToolTip3)
;~     GUIDelete($Form1)

EndFunc

Func CLOSEButton()
    Exit
EndFunc 

Func WO_rec($myRec) ;ticket record
	
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\' & $myRec &'.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec


