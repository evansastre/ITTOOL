#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\代理开关\代理开关.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
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

$ScrtiptDir = "\\ITTOOL_node1\ITTOOLS\Scripts\代理开关\"

$UserConf="\\ITTOOL_node1\Ini\代理原状态记录\" & @UserName & ".ini" ;个人的代理状态文件
$ProxyServer = IniRead($ScrtiptDir & "WebProxyInternational.ini","ProxyServer","ProxyServer","NotSet")   ;此翻墙代理服务器地址
$RunDir = "\\ITTOOL_node1\ITTOOLS\Scripts\代理开关\开机脚本关闭代理.exe" ;开机脚本，只在未正常关闭状态运行

If $ProxyServer =="NotSet" Then ;如果用户的主机因为网络等原因不能成功connect到ITTOOL_node1或者设置的字符有错等，将会给出错误tip
	MsgBox(0,"","代理服务器地址未发现，请稍后再试或联系IT")
	Exit
EndIf

;~ $Webproxy01="webproxy01.CorpDomain.internal:9000" 
;~ $Webproxy02="webproxy02.CorpDomain.internal:9000" 


MainWindow()

Func MainWindow()
	_Singleton("代理开关") ;Prevent repeated opening of the program
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	Opt("GUIOnEventMode", 1)
	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
		
	Global $Form1 = GUICreate("", 150, 100, -1, -1)
	;Global $Form1 = GUICreate("", 150, 100, -1, -1, $WS_POPUP, $WS_EX_LAYERED, WinGetHandle(AutoItWinGetTitle()))
	
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	
	GUISetState(@SW_SHOW)

	$Button1 = GUICtrlCreateButton("开启代理", 30, 20, 90, 50)
    GUICtrlSetOnEvent($Button1,"Switch_On")
	Local $hButton1 = GUICtrlGetHandle($Button1)
	_GUICtrlButton_SetFocus($hButton1)
    Local $hToolTip1 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip1, 0, "开启后，能访问国际域名", $hButton1)

		
	GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
	Global $mainwinOn=True
	While True
		If $mainwinOn==False Then ExitLoop
		Sleep(100) ; 休眠, 以降低 CPU 使用率
	WEnd
EndFunc

;~ StatWin()
Func StatWin() 
	Opt("GUIOnEventMode", 0) ;必须关闭一次之前的窗口事件模式
	
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
;~ 	Opt("GUIOnEventMode", 1)
;~ 	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
	Global $Form2 = GUICreate("", 50, 50, @DesktopWidth-300, 0,$WS_EX_APPWINDOW);原设置×××××××××××
;~ 	Global $Form2 = GUICreate("", 50, 50, @DesktopWidth-300, 0,$WS_EX_LAYERED & $WS_EX_APPWINDOW , WinGetHandle(AutoItWinGetTitle()))
	GUISetIcon(@TempDir & "\corpname.ico")
;~ 	_WinAPI_SetLayeredWindowAttributes($Form2, 0xABCDEF) ;设置透明,故不想有任务栏图标
	GUISetState(@SW_SHOW)
	
	$label= GUICtrlCreateLabel("Status:On", 25, 10, 60, 10)    ;原设置×××××××××××
;~ 	$label= GUICtrlCreateLabel("Status:On", 0, 0, 10, 10)
	Local $hlabel = GUICtrlGetHandle($label)
    Local $hToolTip = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip, 0, "关闭后，恢复成原来的设置", $hlabel)
		
	GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

	While 1
		$iMsg = GUIGetMsg()
		Switch $iMsg
			Case $label
				$res=MsgBox(4,"", "翻墙代理正在使用中，如需退出请选择“是”，继续使用请选择“否”。");&@LF&"是否继续使用代理？")
;~ 				$res=MsgBox(4,"", "翻墙代理正在使用中，继续使用请选择“是”，如需退出请选择“否”。");&@LF&"是否继续使用代理？")
				If $res==7 Then
					ContinueLoop
				ElseIf $res==6 Then
					GUIDelete($Form2)
					CLOSEButton() 
					ExitLoop
				EndIf
			Case $GUI_EVENT_CLOSE
				;MsgBox(0,"tip", "您选择了关闭窗口!"&@LF&"即将关闭代理……")
				GUIDelete($Form2)
				CLOSEButton() 
				ExitLoop
		EndSwitch
	WEnd
EndFunc

		
	

 
Func Switch_On()
	GUIDelete($Form1) ;关闭首个窗口
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;代理是否代开
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");当前代理服务器地址
	
	
	If Not FileExists($UserConf) Then   ;首次生成配置文件
		FileWriteLine($UserConf,"[conf]")
		FileWriteLine($UserConf,"ProxyEnable=")
		FileWriteLine($UserConf,"ProxyServer=")
		FileWriteLine($UserConf,"NowStat=")
	EndIf
	$NowStat=IniRead($UserConf,"conf","NowStat","")

	Select  ;此排序是根据使用情景的频繁度来罗列的，从性能优化角度有必要，但鉴于此处的逻辑判断并不复杂，所以并无卵用
		Case $NowStat=="On"
			MsgBox(0,"","上次代理未正常关闭，即将重新开启……")
			If  $ProxyEnable==0 Or $MyProxyServer<>$ProxyServer Then ;如果是我们设定的代理服务器地址变化，那么直接修改，但不修改原始状态值
				RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1") ;开启代理
				RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer);设置服务器
				Wait_On_Done();检测代理开启完成
			EndIf
							
		Case $ProxyEnable==0 Or $MyProxyServer <> $ProxyServer ;原来未使用代理或使用其他代理的服务器的情况
			IniWrite($UserConf,"conf","ProxyEnable",$ProxyEnable) ;写入原始状态
			IniWrite($UserConf,"conf","ProxyServer",$MyProxyServer);写入原始服务器
			IniWrite($UserConf,"conf","NowStat","On") ;状态改为 On
			
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1") ;开启代理
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$ProxyServer);设置服务器
			Wait_On_Done();检测代理开启完成
			
		Case $ProxyEnable==1 And $MyProxyServer == $ProxyServer ;代理已打开的情形,可能为用户已经手动设置过开启
			IniWrite($UserConf,"conf","NowStat","On") ;状态改为 On
			MsgBox(0,"","代理已开启，无需再次打开")
	EndSelect
	
	StatWin() ;打开状态窗
	
	Return
EndFunc

Func Switch_Off()

	$origin_ProxyEnable=IniRead($UserConf,"conf","ProxyEnable","") ;读取原始状态
	$origin_ProxyServer=IniRead($UserConf,"conf","ProxyServer","");读取原始服务器
	
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD",$origin_ProxyEnable) ; 设置原始状态
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$origin_ProxyServer);设置原始服务器
	IniWrite($UserConf,"conf","NowStat","Off") ;状态改为 Off
	Wait_Off_Done();检测代理关闭完成
EndFunc


Func Wait_On_Done()
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;代理是否代开
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");当前代理服务器地址
	If $ProxyEnable==0 Or $MyProxyServer<>$ProxyServer Then
		Sleep(1000)
		Wait_On_Done()
		Return
	EndIf
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy", "REG_SZ", $RunDir);加入开机脚本用于关闭代理
	MsgBox(0,"","开启代理 成功")
EndFunc

Func Wait_Off_Done()
	$ProxyEnable = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable")  ;代理是否代开
	$MyProxyServer = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer");当前代理服务器地址
	If $ProxyEnable==1 And $MyProxyServer==$ProxyServer Then
		Sleep(1000)
		Wait_Off_Done()
		Return
	EndIf
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy") ; 正常关闭，则删除关闭代理的开机脚本
	MsgBox(0,"","关闭代理 成功")
	WO_rec("代理开关")
EndFunc

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc

Func CLOSEButton()
	If FileExists($UserConf) And IniRead($UserConf,"conf","NowStat","")=="On" Then 
;~ 		MsgBox(0,"","上次未正常关闭代理，即将执行关闭……")
		Switch_Off()
	EndIf
    Exit
EndFunc 
