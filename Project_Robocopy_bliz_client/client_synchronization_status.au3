#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\Robocopy_bliz_client\client_synchronization_status.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;~ #include <StaticConstants.au3>
#include <GuiEdit.au3>
#include "choose.au3"



InputWindow()
;~ MsgBox(0,'',"111")

show()
Func show()
	Global $PROFILEPATH="\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\"& $now_choose_tool &".ini"
	
	Opt("GUIOnEventMode", 1) 
	
	Global $g_idMemo
    Local $tToday, $idMonthCal

    ; 创建 GUI
    GUICreate($now_choose_tool&"客户端同步状态", 600, 750)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")

	$button_cls=GUICtrlCreateButton("清空状态",4,700,592,50)
	GUICtrlSetOnEvent ($button_cls, "button_cls")
	
    ; 创建展示控件
    $g_idMemo = GUICtrlCreateEdit("", 4, 4, 592, 692, 0)

    GUICtrlSetFont($g_idMemo, 9, 400, 0, "微软雅黑")

    GUISetState(@SW_SHOW)
	_GUICtrlEdit_SetReadOnly($g_idMemo,True) ;设置只读


    ; 循环到用户退出.
	While 1
		
		MemoWrite(read_stat())
		Sleep(1000)		
	WEnd


    GUIDelete()
	
EndFunc   ;==>Example

Func CLOSEButton()
    ; 注意: 这里 @GUI_CtrlId 的值等于 $GUI_EVENT_CLOSE,
    ; 而 @GUI_WinHandle 的值等于 $hMainGUI
;~     MsgBox(0, "", "您选择了关闭窗口! 准备退出...")
    Exit
EndFunc   ;==>CLOSEButton
Func button_cls()
	
	$aArray = IniReadSectionNames($PROFILEPATH)
	If @error<>0 Then 
		MsgBox(0,"","配置文件有错，请联系IT处理")
		Exit
	EndIf

	Global  $TotalNum = $aArray[0] ; 工具总数
	Global  $ToolNames[$TotalNum];工具名称，即每个字段名称

	For $i = 1 To $TotalNum
		IniWrite($PROFILEPATH,$aArray[$i],"links","0")
		IniWrite($PROFILEPATH,$aArray[$i],"users","")
		IniWrite($PROFILEPATH,$aArray[$i],"ips","")
	Next

EndFunc   ;==>CLOSEButton


Func read_stat()
	$file= FileRead($PROFILEPATH)
	
	$tmp_arr= StringSplit($file,"*********************************************************************************",1)
	$Stat=$tmp_arr[2]
	Return $Stat
EndFunc

; 写脚本运行消息到备忘录控件
Func MemoWrite($sMessage)
    _GUICtrlEdit_SetText($g_idMemo, $sMessage & @CRLF)
EndFunc   ;==>MemoWrite

