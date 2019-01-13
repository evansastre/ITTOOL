#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#PRE_OutFile=Y:\�������\PingTest.exe
#PRE_UseX64=n
#PRE_Res_Language=2052
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#Region ;**** ���������� ACNWrapper_GUI ****
#EndRegion ;**** ���������� ACNWrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <String.au3>
#include <Inet.au3>
#include <File.au3>
#include <Array.au3>
;~ #include <ColorConstants.au3>
;~ #include <GUIConstantsEx.au3>

InputWindow()

Func InputWindow()
	Opt("GUIOnEventMode", 1)

	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1);����ͼ��
	FileInstall(".\tcping.exe",@UserProfileDir & "\tcping.exe")
	FileInstall(".\wtee.exe",@UserProfileDir & "\wtee.exe")
	
	$tool=""
	$ipaddress=""
	Global $Addrs = "\\ITTOOL_node1\ITTOOLS\Scripts\�������\ips.ini"
	Global $ping_parameter = "\\ITTOOL_node1\ITTOOLS\Scripts\�������\ping_parameter.ini"
;~ 	Global $tracert_parameter = "\\ITTOOL_node1\ITTOOLS\Scripts\�������\tracert_parameter.ini"
	Global $ports = "\\ITTOOL_node1\ITTOOLS\Scripts\�������\ports.ini"
	Global $iniInfo_arr[0]
	Global $iniInfo_PS_arr[0]
	
	Init_iniInfo_arr($Addrs)   ;��ʼ��˵������
	Init_iniInfo_arr($ping_parameter)
;~ 	Init_iniInfo_arr($tracert_parameter)
	Init_iniInfo_arr($ports)
	
	#region ### START Koda GUI section ### Form=

	Global $FORM1 = GUICreate("������·���Թ���", 500, 200, -1 , -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")
	
	$TIP_LABEL = GUICtrlCreateLabel("��ѡ�񹤾ߺ�Ŀ�ĵ�ַ", 8, 8, 130, 23) ;��̬tip��
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")
	
;~ 	Global $mytool = GUICtrlCreateCombo("", 190, 8, 160, 120,2) 
;~ 	GUICtrlSetOnEvent($mytool ,"change_select")
;~ 	GUICtrlSetData(-1, "ping|tracert -d|telnet|tcping", "ping")
;~ 	
	Global $mytool = GUICtrlCreateCombo("", 54, 45, 100, 120)  ;����ѡ���
	GUICtrlSetOnEvent($mytool ,"change_select")
	GUICtrlSetData(-1, "ping|tracert -d|telnet|tcping", "ping")
	Global $LABEL1 = GUICtrlCreateLabel("", 54, 75, 100, 60);��̬tip��
	
	
;~ 	FileReadLine()
;~ 	Global $myipaddress = GUICtrlCreateInput("", 190, 45, 160, 20) ;��ַ�����
	Global $myipaddress = GUICtrlCreateCombo("", 180, 45, 170, 20) ;��ַ�����
	GUICtrlSetOnEvent($myipaddress ,"change_select_addrs")
	GUICtrlSetData(-1,getAvailableParameter($Addrs), "")
	Global $LABEL2 = GUICtrlCreateLabel(@LF & @LF &"���� [��ַ]  "&@LF&"��ַ����Ϊip������" , 180, 75, 170, 60);��̬tip��	
	Global $TopTip = GUICtrlCreateLabel("" , 180, 20, 170, 20);��̬tip��	
	
	Global $myport = GUICtrlCreateCombo("", 370, 45, 80, 20) ;�˿ڡ�������
	GUICtrlSetOnEvent($myport ,"change_select_ports")
	GUICtrlSetData(-1, getAvailableParameter($ping_parameter), "")
	Global $LABEL3 = GUICtrlCreateLabel("", 370, 75, 80, 60);��̬tip��
	
    Global $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 132, 152, 73, 25) ;ConfirmButton
	GUICtrlSetOnEvent($CONFIRMBUTTON ,"Confirm")
	
	
	Global $CANCELBUTTON = GUICtrlCreateButton("Cancel", 278, 152, 73, 25) ;CancelButton
	GUICtrlSetOnEvent($CANCELBUTTON ,"Cancel")
	
	change_select() ;�˴����ʼ������tip����
;~ 	change_select_addrs()
;~ 	change_select_ports()
	
	GUISetState(@SW_SHOW)
;~ 	ControlFocus("������·���Թ���","","Edit1") ;���ñ༭����
	GUICtrlSetState($myipaddress,$GUI_FOCUS  )
	#endregion ### END Koda GUI section ###

	While 1
		Sleep(100) ; ����, �Խ��� CPU ʹ����
	WEnd

EndFunc  

Func getAvailableParameter($filename)
;~ 	$filename="\\ITTOOL_node1\ITTOOLS\Scripts\�������\parameter.ini"
		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "��ȡ�ļ�ʱ���ִ���. @error: " & @error) ; ��ȡ��ǰ�ű��ļ�ʱ��������.
	Else
		For $i = 0 To UBound($aArray) - 1 ; ѭ����������.
			
			$tmparr=StringSplit($aArray[$i],"ps:",1)
			If UBound($tmparr)>1 Then
				$item=StringStripWS($tmparr[1],2);stringstripws����ɾ���ַ����ұߵĿո�
			Else
				$item=$aArray[$i]
			EndIf
;~ 			MsgBox(0,"",$item)
			$String_AvailableAddrs= $String_AvailableAddrs & "|" & $item 
		Next
	EndIf
;~ 	$String_AvailableAddrs = StringLeft($String_AvailableAddrs,StringLen($String_AvailableAddrs)-1) ; ȥ�����һ�� | ����
	Return $String_AvailableAddrs
EndFunc


Func Init_iniInfo_arr($filename)		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "��ȡ�ļ�ʱ���ִ���. @error: " & @error) ; ��ȡ��ǰ�ű��ļ�ʱ��������.
	Else
		For $i = 0 To UBound($aArray) - 1 ; ѭ����������.
			$tmparr=StringSplit($aArray[$i],"ps:",1)
			If UBound($tmparr)>1 Then
				$info=StringStripWS($tmparr[1],2);stringstripws����ɾ���ַ����ұߵĿո�
				_ArrayAdd($iniInfo_arr,$info)
				$info_PS=StringStripWS($tmparr[2],2);stringstripws����ɾ���ַ����ұߵĿո�
				_ArrayAdd($iniInfo_PS_arr,$info_PS)
			EndIf
		Next
	EndIf

EndFunc




Func Confirm()
	$tool = GUICtrlRead($mytool)
	$ipaddress = GUICtrlRead($myipaddress)
	$port=GUICtrlRead($myport)
	change_select_addrs() ; ip������ʾ
	GUICtrlSetData($TopTip,"����ִ�С������Ե�") ;ִ�й����иı���ʾ
	_GUICtrlButton_Enable($CONFIRMBUTTON,False) ;forbidȷ��Button
	
	If $tool=="telnet" Then ;telnet��������
		;��telnetʹ��Ȩ		
		$open_telnet_client='pkgmgr /iu:"TelnetClient"'
		Global $command_cmd[1] = [$open_telnet_client]
		runBat($command_cmd,@SW_DISABLE)
		
		$cmd = $tool & " " & $ipaddress & " " & $port
		$pause="pause>>nul"
		Global $command_cmd[2] = [$cmd,$pause]
		runBat($command_cmd,@SW_MAXIMIZE)

		GUICtrlSetData($TopTip,"") ;�Ļ�lable��ʾ
		_GUICtrlButton_Enable($CONFIRMBUTTON,True) ;�ָ�ȷ��Button
		Return
	EndIf
	
	If $tool=="tracert -d" Then $port=" "  ; ��ʹ��tracertʱ����ʹ��ĩβ����
	
	Local $outputfile = @TempDir & "\output.txt"
	If FileExists($outputfile) Then
		FileDelete($outputfile)
	EndIf
	$resultFile=@DesktopDir & "\PingResult.txt"
	$starttime = "start time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
                 "  ��������IP:" & @IPAddress1 
	
	$cmd_show = $tool & " " & $ipaddress  & " " & $port 
	FileWriteLine($resultFile,$starttime)
	FileWriteLine($resultFile,$cmd_show)
	
;~ 	$endrow="echo  -------------------------------------------------------------------------�ָ��� >> "& $resultFile
	$cmd = $tool & " " & $ipaddress & " " & $port & " | wtee "& $outputfile
	$pause="pause>>nul"
	Global $command_cmd[2] = [$cmd,$pause]
	runBat($command_cmd,@SW_MAXIMIZE)
	
	
	$outputFileRead=FileRead($outputfile)
;~ 	$hResultFile=FileOpen($resultFile)
	FileWriteLine($resultFile,$outputFileRead)
	FileWriteLine($resultFile,"-------------------------------------------------------------------------�ָ��� ")
	FileDelete($outputfile) ;output.txtֻ����������ִ�е���ʱ����洢��ȡ��ֵ�󼴿�ɾ��
	
	$result=FileRead($resultFile )  ;�˴�ִ�г���10���ļ�¼��ɾ�������
	If StringInStr($result,"�ָ���") Then
		StringReplace( $result, "�ָ���","line" ) ;�˴����ڼ��㡰�ָ��ߡ����ִ���   ��������������������������������������������
		$times=@extended
		If $times > 10  Then
			$result=StringReplace($result, StringLeft($result,StringInStr($result,"��")) ,"")
			_FileCreate($resultFile)
			FileOpen($resultFile)
			FileWrite($resultFile,$result)
			FileClose($resultFile)
		EndIf
	EndIf
			
	ShellExecute("explorer",@DesktopDir & "\PingResult.txt" )
	
	GUICtrlSetData($TopTip,"")  ;�Ļ�lable��ʾ
	_GUICtrlButton_Enable($CONFIRMBUTTON,True) ;�ָ�ȷ��Button
EndFunc

Func change_select()
	$now_choose_tool=GUICtrlRead($mytool)
	Switch $now_choose_tool
		Case "ping"
			GUICtrlSetData($LABEL1, @LF& @LF&"��ͨ����")
			GUICtrlSetData($LABEL3, @LF& @LF&"ѡ�� [����] ")
			GUICtrlSetState($myport,$GUI_ENABLE) 
			GUICtrlSetData($myport, getAvailableParameter($ping_parameter), "")
		Case "tracert -d" 
			GUICtrlSetData($LABEL1, @LF& @LF&"·�ɸ���")
			GUICtrlSetData($LABEL3, "ʹ��tracertʱ�������")
			GUICtrlSetState($myport,$GUI_DISABLE )
			GUICtrlSetData($LABEL3, "", "")
		Case "telnet" 
			GUICtrlSetData($LABEL1, @LF& @LF&"�˿ڲ���")
			GUICtrlSetData($LABEL3, @LF& @LF&"ѡ�� [�˿ں�] Ĭ��23" )
			GUICtrlSetState($myport,$GUI_ENABLE)
			GUICtrlSetData($myport, getAvailableParameter($ports), "")
		Case "tcping" 
			GUICtrlSetData($LABEL1, @LF& @LF&"��ͨ�Ͷ˿ڲ���")
			GUICtrlSetData($LABEL3, @LF& @LF&"ѡ�� [�˿ں�] Ĭ��80")
			GUICtrlSetState($myport,$GUI_ENABLE)
			GUICtrlSetData($myport, getAvailableParameter($ports), "")
	EndSwitch
EndFunc

Func change_select_addrs()
	$now_choose_tool=GUICtrlRead($myipaddress)
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)
	If @error <> 0 Then 
		$PS=$now_choose_tool 
	Else
		$PS=$iniInfo_PS_arr[$locat[0]]	
	EndIf
	GUICtrlSetData($LABEL2, $PS & @LF & @LF &"���� [��ַ]  "&@LF&"��ַ����Ϊip������" )
EndFunc

Func change_select_ports()
	$now_choose_tool=GUICtrlRead($myport)
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)[0]
	$PS=$iniInfo_PS_arr[$locat]	
	If StringInStr(GUICtrlRead($LABEL3),"80") Then 
		$tip=@LF& @LF&"ѡ�� [�˿ں�] Ĭ��80"
	ElseIf StringInStr(GUICtrlRead($LABEL3),"23")  Then
		$tip=@LF& @LF&"ѡ�� [�˿ں�] Ĭ��23"
	Else
		$tip=@LF& @LF&"ѡ�� [����] "
	EndIf
	
	GUICtrlSetData($LABEL3,$PS & $tip  )
EndFunc


Func Cancel()
	GUIDelete($FORM1)
	FileDelete(@UserProfileDir & "\tcping.exe")
	FileDelete(@UserProfileDir & "\wtee.exe")
	WO_rec("�������")
	Exit
EndFunc

Func runBat($cmd,$SW);$cmd must be array
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd
		FileWriteLine($sFilePath, $i)
	Next
	
	RunAsWait("itbat","CorpDomain","Password@4",0,$sFilePath, @UserProfileDir, $SW) ; telnetʱ����ָ����ݣ�����ִ�д���
	FileDelete($sFilePath)
EndFunc   

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc