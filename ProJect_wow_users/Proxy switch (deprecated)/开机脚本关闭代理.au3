#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������\�����ű��رմ���.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

$ScrtiptDir = "\\ITTOOL_node1\ITTOOLS\Scripts\������\"
$UserConf=$ScrtiptDir & "����ԭ״̬��¼\" & @UserName & ".ini" ;���˵Ĵ���״̬�ļ�

While True
	$ProxyServer = IniRead($ScrtiptDir & "WebProxyInternational.ini","ProxyServer","ProxyServer","NotSet")   ;�˷�ǽ�����������ַ
	If $ProxyServer =="NotSet" Then ;����û���������Ϊ�����ԭ���ܳɹ�connect��ITTOOL_node1�������õ��ַ��д�ȣ������������tip
		Sleep(3000)
		ContinueLoop
	Else
		ExitLoop
	EndIf
WEnd

Switch_Off()
Func Switch_Off()
	$origin_ProxyEnable=IniRead($UserConf,"conf","ProxyEnable","") ;��ȡԭʼ״̬
	$origin_ProxyServer=IniRead($UserConf,"conf","ProxyServer","");��ȡԭʼ������
	
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD",$origin_ProxyEnable) ; ����ԭʼ״̬
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$origin_ProxyServer);����ԭʼ������
	IniWrite($UserConf,"conf","NowStat","Off") ;״̬��Ϊ Off
	Wait_Off_Done();������ر����
EndFunc


Func Wait_Off_Done()
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;�����Ƿ����
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");��ǰ�����������ַ
	If $ProxyEnable==1 And $MyProxyServer==$ProxyServer Then
		Sleep(1000)
		Wait_Off_Done()
		Return
	EndIf
EndFunc

RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy")
