#NoTrayIcon
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������\������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIToolTip.au3>
#include <GuiButton.au3>
#include <File.au3>
#include <Misc.au3>

#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$ScrtiptDir = "\\ITTOOL_node1\ITTOOLS\Scripts\������\"

$UserConf="\\ITTOOL_node1\Ini\����ԭ״̬��¼\" & @UserName & ".ini" ;���˵Ĵ���״̬�ļ�
$ProxyServer = IniRead($ScrtiptDir & "WebProxyInternational.ini","ProxyServer","ProxyServer","NotSet")   ;�˷�ǽ�����������ַ
$RunDir = "\\ITTOOL_node1\ITTOOLS\Scripts\������\�����ű��رմ���.exe" ;�����ű���ֻ��δ�����ر�״̬����

If $ProxyServer =="NotSet" Then ;����û���������Ϊ�����ԭ���ܳɹ�connect��ITTOOL_node1�������õ��ַ��д�ȣ������������tip
	MsgBox(0,"","�����������ַδ���֣����Ժ����Ի���ϵIT")
	Exit
EndIf

;~ $Webproxy01="webproxy01.CorpDomain.internal:9000" 
;~ $Webproxy02="webproxy02.CorpDomain.internal:9000" 


MainWindow()

Func MainWindow()
	_Singleton("������") ;Prevent repeated opening of the program
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	Opt("GUIOnEventMode", 1)
	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
		
	Global $Form1 = GUICreate("", 150, 100, -1, -1)
	;Global $Form1 = GUICreate("", 150, 100, -1, -1, $WS_POPUP, $WS_EX_LAYERED, WinGetHandle(AutoItWinGetTitle()))
	
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	
	GUISetState(@SW_SHOW)

	$Button1 = GUICtrlCreateButton("��������", 30, 20, 90, 50)
    GUICtrlSetOnEvent($Button1,"Switch_On")
	Local $hButton1 = GUICtrlGetHandle($Button1)
	_GUICtrlButton_SetFocus($hButton1)
    Local $hToolTip1 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip1, 0, "�������ܷ��ʹ�������", $hButton1)

		
	GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
	Global $mainwinOn=True
	While True
		If $mainwinOn==False Then ExitLoop
		Sleep(100) ; ����, �Խ��� CPU ʹ����
	WEnd
EndFunc

;~ StatWin()
Func StatWin() 
	Opt("GUIOnEventMode", 0) ;����ر�һ��֮ǰ�Ĵ����¼�ģʽ
	
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
;~ 	Opt("GUIOnEventMode", 1)
;~ 	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
	Global $Form2 = GUICreate("", 50, 50, @DesktopWidth-300, 0,$WS_EX_APPWINDOW);ԭ���á���������������������
;~ 	Global $Form2 = GUICreate("", 50, 50, @DesktopWidth-300, 0,$WS_EX_LAYERED & $WS_EX_APPWINDOW , WinGetHandle(AutoItWinGetTitle()))
	GUISetIcon(@TempDir & "\corpname.ico")
;~ 	_WinAPI_SetLayeredWindowAttributes($Form2, 0xABCDEF) ;����͸��,�ʲ�����������ͼ��
	GUISetState(@SW_SHOW)
	
	$label= GUICtrlCreateLabel("Status:On", 25, 10, 60, 10)    ;ԭ���á���������������������
;~ 	$label= GUICtrlCreateLabel("Status:On", 0, 0, 10, 10)
	Local $hlabel = GUICtrlGetHandle($label)
    Local $hToolTip = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip, 0, "�رպ󣬻ָ���ԭ��������", $hlabel)
		
	GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

	While 1
		$iMsg = GUIGetMsg()
		Switch $iMsg
			Case $label
				$res=MsgBox(4,"", "��ǽ��������ʹ���У������˳���ѡ���ǡ�������ʹ����ѡ�񡰷񡱡�");&@LF&"�Ƿ����ʹ�ô���")
;~ 				$res=MsgBox(4,"", "��ǽ��������ʹ���У�����ʹ����ѡ���ǡ��������˳���ѡ�񡰷񡱡�");&@LF&"�Ƿ����ʹ�ô���")
				If $res==7 Then
					ContinueLoop
				ElseIf $res==6 Then
					GUIDelete($Form2)
					CLOSEButton() 
					ExitLoop
				EndIf
			Case $GUI_EVENT_CLOSE
				;MsgBox(0,"tip", "��ѡ���˹رմ���!"&@LF&"�����رմ�����")
				GUIDelete($Form2)
				CLOSEButton() 
				ExitLoop
		EndSwitch
	WEnd
EndFunc

		
	

 
Func Switch_On()
	GUIDelete($Form1) ;�ر��׸�����
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;�����Ƿ����
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");��ǰ�����������ַ
	
	
	If Not FileExists($UserConf) Then   ;�״����������ļ�
		FileWriteLine($UserConf,"[conf]")
		FileWriteLine($UserConf,"ProxyEnable=")
		FileWriteLine($UserConf,"ProxyServer=")
		FileWriteLine($UserConf,"NowStat=")
	EndIf
	$NowStat=IniRead($UserConf,"conf","NowStat","")

	Select  ;�������Ǹ���ʹ���龰��Ƶ���������еģ��������Ż��Ƕ��б�Ҫ�������ڴ˴����߼��жϲ������ӣ����Բ�������
		Case $NowStat=="On"
			MsgBox(0,"","�ϴδ���δ�����رգ��������¿�������")
			If  $ProxyEnable==0 Or $MyProxyServer<>$ProxyServer Then ;����������趨�Ĵ����������ַ�仯����ôֱ���޸ģ������޸�ԭʼ״ֵ̬
				RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1") ;��������
				RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer);���÷�����
				Wait_On_Done();�����������
			EndIf
							
		Case $ProxyEnable==0 Or $MyProxyServer <> $ProxyServer ;ԭ��δʹ�ô����ʹ����������ķ����������
			IniWrite($UserConf,"conf","ProxyEnable",$ProxyEnable) ;д��ԭʼ״̬
			IniWrite($UserConf,"conf","ProxyServer",$MyProxyServer);д��ԭʼ������
			IniWrite($UserConf,"conf","NowStat","On") ;״̬��Ϊ On
			
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1") ;��������
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer);���÷�����
			Wait_On_Done();�����������
			
		Case $ProxyEnable==1 And $MyProxyServer == $ProxyServer ;�����Ѵ򿪵�����,����Ϊ�û��Ѿ��ֶ����ù�����
			IniWrite($UserConf,"conf","NowStat","On") ;״̬��Ϊ On
			MsgBox(0,"","�����ѿ����������ٴδ�")
	EndSelect
	
	StatWin() ;��״̬��
	
	Return
EndFunc

Func Switch_Off()

	$origin_ProxyEnable=IniRead($UserConf,"conf","ProxyEnable","") ;��ȡԭʼ״̬
	$origin_ProxyServer=IniRead($UserConf,"conf","ProxyServer","");��ȡԭʼ������
	
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD",$origin_ProxyEnable) ; ����ԭʼ״̬
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$origin_ProxyServer);����ԭʼ������
	IniWrite($UserConf,"conf","NowStat","Off") ;״̬��Ϊ Off
	Wait_Off_Done();������ر����
EndFunc


Func Wait_On_Done()
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;�����Ƿ����
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");��ǰ�����������ַ
	If $ProxyEnable==0 Or $MyProxyServer<>$ProxyServer Then
		Sleep(1000)
		Wait_On_Done()
		Return
	EndIf
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy", "REG_SZ", $RunDir);���뿪���ű����ڹرմ���
	MsgBox(0,"","�������� �ɹ�")
EndFunc

Func Wait_Off_Done()
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;�����Ƿ����
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");��ǰ�����������ַ
	If $ProxyEnable==1 And $MyProxyServer==$ProxyServer Then
		Sleep(1000)
		Wait_Off_Done()
		Return
	EndIf
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy") ; �����رգ���ɾ���رմ���Ŀ����ű�
	MsgBox(0,"","�رմ��� �ɹ�")
	WO_rec("������")
EndFunc

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc

Func CLOSEButton()
	If FileExists($UserConf) And IniRead($UserConf,"conf","NowStat","")=="On" Then 
;~ 		MsgBox(0,"","�ϴ�δ�����رմ�������ִ�йرա���")
		Switch_Off()
	EndIf
    Exit
EndFunc 
