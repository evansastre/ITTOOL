#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������\������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <GUIConstantsEx.au3>
#include <GUIToolTip.au3>
#include <File.au3>

$ScrtiptDir = "\\ITTOOL_node1\ITTOOLS\Scripts\������\"
$ProxyServer = IniRead($ScrtiptDir & "WebProxyInternational.ini","ProxyServer","ProxyServer","NotSet")
If $ProxyServer =="NotSet" Then ;����û���������Ϊ�����ԭ���ܳɹ�connect��ITTOOL_node1�������õ��ַ��д�ȣ������������tip
	MsgBox(0,"","�����������ַδ���֣����Ժ����Ի���ϵIT")
	Exit
EndIf

$Webproxy01="webproxy01.CorpDomain.internal:9000" 
$Webproxy02="webproxy02.CorpDomain.internal:9000" 
$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")
$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer")

MainWindow()
Func MainWindow()
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	Opt("GUIOnEventMode", 1)
	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("������", 300, 100, -1, -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetState(@SW_SHOW)

	$Button1 = GUICtrlCreateButton("��������", 30, 20, 90, 50)
    GUICtrlSetOnEvent($Button1,"Switch_On")
	Local $hButton1 = GUICtrlGetHandle($Button1)
    Local $hToolTip1 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip1, 0, "�������ܷ��ʹ�������", $hButton1)

	$Button2 = GUICtrlCreateButton("�رմ���", 180, 20, 90, 50)
	GUICtrlSetOnEvent($Button2,"Switch_Off")
	Local $hButton2 = GUICtrlGetHandle($Button2)
    Local $hToolTip2 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip2, 0, "�رպ󣬻ָ���ԭ��������", $hButton2)
		
	GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
	While 1
		Sleep(100) ; ����, �Խ��� CPU ʹ����
	WEnd
EndFunc
 
Func Switch_On()
	Select  ;�������Ǹ���ʹ���龰��Ƶ���������еģ��������Ż��Ƕ��б�Ҫ�������ڴ˴����߼��жϲ������ӣ����Բ�������
		Case $ProxyEnable==0 ;û��ʹ�ô�����IT��OT��JV�Ȳ��ܴ���������֯
			;ShellExecuteWait($ScrtiptDir & "WebProxyInternational.bat" ,"open" , "", "",@SW_HIDE)
			_FileWriteLog($ScrtiptDir & "����ԭ״̬��¼\" & @UserName & ".log", "Proxy:No",1)
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1")
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer)
			MsgBox(0,"","�������� �ɹ�")
		Case $ProxyEnable==1 And ($MyProxyServer ==$Webproxy01 Or $MyProxyServer ==$Webproxy02) ;�д����Ҵ���Ϊwebproxy01��02
			_FileWriteLog($ScrtiptDir & "����ԭ״̬��¼\" & @UserName & ".log", "Proxy:" & $MyProxyServer,1)
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer)
			MsgBox(0,"","�������� �ɹ�")
		Case $ProxyEnable==1 And $MyProxyServer == $ProxyServer ;�����Ѵ򿪵�����
			MsgBox(0,"","�����ѿ����������ٴδ�")
		Case $ProxyEnable==1 And $MyProxyServer <> $Webproxy01 And $MyProxyServer<>$Webproxy02 And $MyProxyServer<>$ProxyServer 
			;��ǰ���õĴ������ǹ�˾�ڲ���֪�����������
			;������û������趨�ĵ����������������ӣ�ֱ�����ڲ��ķ�ǽ�����ǣ��ⲿ���û�����Ҳ�������޸ĵ�����
			;��������������趨�Ĵ����������ַ�仯����ôֱ���޸�Ҳ�ǿ��еģ����˴�������ԭ״̬��¼
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer)
			MsgBox(0,"","�������� �ɹ�")
	EndSelect
	Exit
EndFunc

Func Switch_Off()
	Select  ;�������Ǹ���ʹ���龰��Ƶ���������еģ��������Ż��Ƕ��б�Ҫ�������ڴ˴����߼��жϲ������ӣ����Բ�������
		Case $ProxyEnable==0 ;û��ʹ�ô�����IT��OT��JV�Ȳ��ܴ���������֯
			MsgBox(0,"","�����ڹر�״̬�������ٴιر�")
		Case $ProxyEnable==1 And ($MyProxyServer ==$Webproxy01 Or $MyProxyServer ==$Webproxy02);�д����Ҵ���Ϊwebproxy01��02
			MsgBox(0,"","�����ڹر�״̬�������ٴιر�")
		Case $ProxyEnable==1 And $MyProxyServer == $ProxyServer ;�����Ѵ򿪵�����
			Reset()
		Case $ProxyEnable==1 And $MyProxyServer <> $Webproxy01 And $MyProxyServer<>$Webproxy02 And $MyProxyServer<>$ProxyServer ;�����״̬������������ַ�ѱ�
			Reset()
	EndSelect
	Exit
EndFunc

Func Reset()
	$res=FileReadLine($ScrtiptDir & "����ԭ״̬��¼\" & @UserName & ".log",1)
	$tmpArr=StringSplit($res,"Proxy:",1)
	$Proxy = $tmpArr[2]
	If $Proxy == "No" Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","0")
	ElseIf StringInStr($Proxy,"webproxy") Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$Proxy)
	EndIf
	MsgBox(0,"","�رմ��� �ɹ�")
EndFunc

Func CLOSEButton()
    Exit
EndFunc 