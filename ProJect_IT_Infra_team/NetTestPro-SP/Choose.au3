#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������վ\������վ.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <IE.au3>
#include <Array.au3>


;~ InputWindow()

Func InputWindow()
	Global $ChosenAddress
	Global $now_choose_tool
	Global $myports="1119"
	
	FileInstall(".\tools\NetTestPro_ips.ini",@TempDir & "\NetTestPro_ips.ini",1)
	Opt("GUIOnEventMode", 1)
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1);����ͼ��
	
	Global $Addrs =  @TempDir & "\NetTestPro_ips.ini"
	Global $iniInfo_arr[0]
	Global $iniInfo_PS_arr[0]
	
	Init_iniInfo_arr($Addrs)   ;��ʼ��˵������
		#region ### START Koda GUI section ### Form=

	Global $FORM1 = GUICreate("ս����Ϸ����", 300, 180, -1 , -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")
	
	$TIP_LABEL = GUICtrlCreateLabel("��ѡ���������ҪҪ���Եĵ�ַ", 8, 8, 220, 23) ;��̬tip��
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")

	
	Global $myipaddress = GUICtrlCreateCombo("", 50, 45, 200, 20) ;��ַ�����
	GUICtrlSetOnEvent($myipaddress ,"change_select_addrs")
	GUICtrlSetData(-1,getAvailableParameter($Addrs), "")
	Global $LABEL2 = GUICtrlCreateLabel("" , 50, 75, 170, 20);��̬tip��	
	
	
    Global $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 50, 122, 73, 25) ;ConfirmButton
	GUICtrlSetOnEvent($CONFIRMBUTTON ,"Confirm")
	
	
	Global $CANCELBUTTON = GUICtrlCreateButton("Cancel", 178, 122, 73, 25) ;CancelButton
	GUICtrlSetOnEvent($CANCELBUTTON ,"Cancel")
	
;~ 	change_select() ;�˴����ʼ������tip����
	
	GUISetState(@SW_SHOW)

	GUICtrlSetState($myipaddress,$GUI_FOCUS  ) ;���ñ༭����
	#endregion ### END Koda GUI section ###

	Global $stop=False
	While Not $stop
		Sleep(100) ; ����, �Խ��� CPU ʹ����
	WEnd

EndFunc  



Func Init_iniInfo_arr($filename)		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "��ȡ�ļ�ʱ���ִ���. @error: " & @error) ; ��ȡ��ǰ�ű��ļ�ʱ��������.
	Else
		For $i = 0 To UBound($aArray) - 1 ; ѭ����������.
			$tmparr=StringSplit($aArray[$i],"pss:",1)
			If UBound($tmparr)>1 Then
				$info=StringStripWS($tmparr[1],2);stringstripws����ɾ���ַ����ұߵĿո�
				_ArrayAdd($iniInfo_arr,$info)
				$info_PS=StringStripWS($tmparr[2],2);stringstripws����ɾ���ַ����ұߵĿո�
				_ArrayAdd($iniInfo_PS_arr,$info_PS)
			EndIf
		Next
		
	EndIf

EndFunc

Func getAvailableParameter($filename)
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "��ȡ�ļ�ʱ���ִ���. @error: " & @error) ; ��ȡ��ǰ�ű��ļ�ʱ��������.
	Else
		For $i = 0 To UBound($aArray) - 1 ; ѭ����������.
			$tmparr=StringSplit($aArray[$i],"pss:",1)
			If UBound($tmparr)>1 Then
				$item=StringStripWS($tmparr[1],2);stringstripws����ɾ���ַ����ұߵĿո�
			Else
				$item=$aArray[$i]
			EndIf
			$String_AvailableAddrs= $String_AvailableAddrs & "|" & $item 
		Next
	EndIf
	Return $String_AvailableAddrs
EndFunc

Func change_select_addrs()
	$now_choose_tool=GUICtrlRead($myipaddress)
	
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)
	If @error <> 0 Then 
		$PS=$now_choose_tool 
	Else
		$PS=$iniInfo_PS_arr[$locat[0]]	
	EndIf
	GUICtrlSetData($LABEL2, $PS  )
EndFunc


Func Confirm_addrs()
	$now_choose_tool=GUICtrlRead($myipaddress)
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)
	If @error <> 0 Then 
		$PS=$now_choose_tool 
	Else
		$PS=$iniInfo_PS_arr[$locat[0]]	
	EndIf
	
	
	If $now_choose_tool=="¯ʯ��˵" Or $now_choose_tool=="�����ȷ�" Then
		$myports="3724"
	EndIf
	
;~ 	MsgBox(0,"",$myports)
	
   ;¯ʯ�������Ķ˿�Ϊ3724  ����Ϊ1119
	
	Return $PS
EndFunc

Func Confirm()
	$ChosenAddress = Confirm_addrs()
	change_select_addrs() ; ip������ʾ

	GUIDelete($FORM1)
	$stop=True
	
;~ 	MsgBox(0,"",$now_choose_tool)
;~ 	Exit
	
	Return

EndFunc

Func Cancel()
	GUIDelete($FORM1)
	WO_rec("������վ")
	Exit
EndFunc

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
