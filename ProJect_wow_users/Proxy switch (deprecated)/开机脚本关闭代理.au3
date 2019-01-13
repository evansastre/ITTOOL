#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\代理开关\开机脚本关闭代理.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

$ScrtiptDir = "\\ITTOOL_node1\ITTOOLS\Scripts\代理开关\"
$UserConf=$ScrtiptDir & "代理原状态记录\" & @UserName & ".ini" ;个人的代理状态文件

While True
	$ProxyServer = IniRead($ScrtiptDir & "WebProxyInternational.ini","ProxyServer","ProxyServer","NotSet")   ;此翻墙代理服务器地址
	If $ProxyServer =="NotSet" Then ;如果用户的主机因为网络等原因不能成功connect到ITTOOL_node1或者设置的字符有错等，将会给出错误tip
		Sleep(3000)
		ContinueLoop
	Else
		ExitLoop
	EndIf
WEnd

Switch_Off()
Func Switch_Off()
	$origin_ProxyEnable=IniRead($UserConf,"conf","ProxyEnable","") ;读取原始状态
	$origin_ProxyServer=IniRead($UserConf,"conf","ProxyServer","");读取原始服务器
	
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD",$origin_ProxyEnable) ; 设置原始状态
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$origin_ProxyServer);设置原始服务器
	IniWrite($UserConf,"conf","NowStat","Off") ;状态改为 Off
	Wait_Off_Done();检测代理关闭完成
EndFunc


Func Wait_Off_Done()
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;代理是否代开
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");当前代理服务器地址
	If $ProxyEnable==1 And $MyProxyServer==$ProxyServer Then
		Sleep(1000)
		Wait_Off_Done()
		Return
	EndIf
EndFunc

RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy")
