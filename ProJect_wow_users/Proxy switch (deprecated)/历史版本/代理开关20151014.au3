#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\代理开关\代理开关.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>
#include <GUIToolTip.au3>
#include <File.au3>

$ScrtiptDir = "\\ITTOOL_node1\ITTOOLS\Scripts\代理开关\"
$ProxyServer = IniRead($ScrtiptDir & "WebProxyInternational.ini","ProxyServer","ProxyServer","NotSet")
If $ProxyServer =="NotSet" Then ;如果用户的主机因为网络等原因不能成功connect到ITTOOL_node1或者设置的字符有错等，将会给出错误tip
	MsgBox(0,"","代理服务器地址未发现，请稍后再试或联系IT")
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
	$Form1 = GUICreate("代理开关", 300, 100, -1, -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetState(@SW_SHOW)

	$Button1 = GUICtrlCreateButton("开启代理", 30, 20, 90, 50)
    GUICtrlSetOnEvent($Button1,"Switch_On")
	Local $hButton1 = GUICtrlGetHandle($Button1)
    Local $hToolTip1 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip1, 0, "开启后，能访问国际域名", $hButton1)

	$Button2 = GUICtrlCreateButton("关闭代理", 180, 20, 90, 50)
	GUICtrlSetOnEvent($Button2,"Switch_Off")
	Local $hButton2 = GUICtrlGetHandle($Button2)
    Local $hToolTip2 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip2, 0, "关闭后，恢复成原来的设置", $hButton2)
		
	GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
	While 1
		Sleep(100) ; 休眠, 以降低 CPU 使用率
	WEnd
EndFunc
 
Func Switch_On()
	Select  ;此排序是根据使用情景的频繁度来罗列的，从性能优化角度有必要，但鉴于此处的逻辑判断并不复杂，所以并无卵用
		Case $ProxyEnable==0 ;没有使用代理，如IT、OT、JV等不受代理管理的组织
			;ShellExecuteWait($ScrtiptDir & "WebProxyInternational.bat" ,"open" , "", "",@SW_HIDE)
			_FileWriteLog($ScrtiptDir & "代理原状态记录\" & @UserName & ".log", "Proxy:No",1)
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1")
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer)
			MsgBox(0,"","开启代理 成功")
		Case $ProxyEnable==1 And ($MyProxyServer ==$Webproxy01 Or $MyProxyServer ==$Webproxy02) ;有代理，且代理为webproxy01或02
			_FileWriteLog($ScrtiptDir & "代理原状态记录\" & @UserName & ".log", "Proxy:" & $MyProxyServer,1)
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer)
			MsgBox(0,"","开启代理 成功")
		Case $ProxyEnable==1 And $MyProxyServer == $ProxyServer ;代理已打开的情形
			MsgBox(0,"","代理已开启，无需再次打开")
		Case $ProxyEnable==1 And $MyProxyServer <> $Webproxy01 And $MyProxyServer<>$Webproxy02 And $MyProxyServer<>$ProxyServer 
			;当前设置的代理服务非公司内部已知代理服务器。
			;如果是用户自行设定的第三方代理，可以无视，直接用内部的翻墙代理覆盖，这部分用户本身也有自行修改的条件
			;如果是由于我们设定的代理服务器地址变化，那么直接修改也是可行的，但此处不产生原状态记录
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer)
			MsgBox(0,"","开启代理 成功")
	EndSelect
	Exit
EndFunc

Func Switch_Off()
	Select  ;此排序是根据使用情景的频繁度来罗列的，从性能优化角度有必要，但鉴于此处的逻辑判断并不复杂，所以并无卵用
		Case $ProxyEnable==0 ;没有使用代理，如IT、OT、JV等不受代理管理的组织
			MsgBox(0,"","代理处于关闭状态，无需再次关闭")
		Case $ProxyEnable==1 And ($MyProxyServer ==$Webproxy01 Or $MyProxyServer ==$Webproxy02);有代理，且代理为webproxy01或02
			MsgBox(0,"","代理处于关闭状态，无需再次关闭")
		Case $ProxyEnable==1 And $MyProxyServer == $ProxyServer ;代理已打开的情形
			Reset()
		Case $ProxyEnable==1 And $MyProxyServer <> $Webproxy01 And $MyProxyServer<>$Webproxy02 And $MyProxyServer<>$ProxyServer ;代理打开状态，但服务器地址已变
			Reset()
	EndSelect
	Exit
EndFunc

Func Reset()
	$res=FileReadLine($ScrtiptDir & "代理原状态记录\" & @UserName & ".log",1)
	$tmpArr=StringSplit($res,"Proxy:",1)
	$Proxy = $tmpArr[2]
	If $Proxy == "No" Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","0")
	ElseIf StringInStr($Proxy,"webproxy") Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$Proxy)
	EndIf
	MsgBox(0,"","关闭代理 成功")
EndFunc

Func CLOSEButton()
    Exit
EndFunc 