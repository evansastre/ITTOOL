#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\Robocopy_bliz_client\client_synchronization_status.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
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

    ; ���� GUI
    GUICreate($now_choose_tool&"�ͻ���ͬ��״̬", 600, 750)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")

	$button_cls=GUICtrlCreateButton("���״̬",4,700,592,50)
	GUICtrlSetOnEvent ($button_cls, "button_cls")
	
    ; ����չʾ�ؼ�
    $g_idMemo = GUICtrlCreateEdit("", 4, 4, 592, 692, 0)

    GUICtrlSetFont($g_idMemo, 9, 400, 0, "΢���ź�")

    GUISetState(@SW_SHOW)
	_GUICtrlEdit_SetReadOnly($g_idMemo,True) ;����ֻ��


    ; ѭ�����û��˳�.
	While 1
		
		MemoWrite(read_stat())
		Sleep(1000)		
	WEnd


    GUIDelete()
	
EndFunc   ;==>Example

Func CLOSEButton()
    ; ע��: ���� @GUI_CtrlId ��ֵ���� $GUI_EVENT_CLOSE,
    ; �� @GUI_WinHandle ��ֵ���� $hMainGUI
;~     MsgBox(0, "", "��ѡ���˹رմ���! ׼���˳�...")
    Exit
EndFunc   ;==>CLOSEButton
Func button_cls()
	
	$aArray = IniReadSectionNames($PROFILEPATH)
	If @error<>0 Then 
		MsgBox(0,"","�����ļ��д�����ϵIT����")
		Exit
	EndIf

	Global  $TotalNum = $aArray[0] ; ��������
	Global  $ToolNames[$TotalNum];�������ƣ���ÿ���ֶ�����

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

; д�ű�������Ϣ������¼�ؼ�
Func MemoWrite($sMessage)
    _GUICtrlEdit_SetText($g_idMemo, $sMessage & @CRLF)
EndFunc   ;==>MemoWrite

