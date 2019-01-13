#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#PRE_OutFile=Y:\网络测试\PingTest.exe
#PRE_UseX64=n
#PRE_Res_Language=2052
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
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

	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1);附带图标
	FileInstall(".\tcping.exe",@UserProfileDir & "\tcping.exe")
	FileInstall(".\wtee.exe",@UserProfileDir & "\wtee.exe")
	
	$tool=""
	$ipaddress=""
	Global $Addrs = "\\ITTOOL_node1\ITTOOLS\Scripts\网络测试\ips.ini"
	Global $ping_parameter = "\\ITTOOL_node1\ITTOOLS\Scripts\网络测试\ping_parameter.ini"
;~ 	Global $tracert_parameter = "\\ITTOOL_node1\ITTOOLS\Scripts\网络测试\tracert_parameter.ini"
	Global $ports = "\\ITTOOL_node1\ITTOOLS\Scripts\网络测试\ports.ini"
	Global $iniInfo_arr[0]
	Global $iniInfo_PS_arr[0]
	
	Init_iniInfo_arr($Addrs)   ;初始化说明文字
	Init_iniInfo_arr($ping_parameter)
;~ 	Init_iniInfo_arr($tracert_parameter)
	Init_iniInfo_arr($ports)
	
	#region ### START Koda GUI section ### Form=

	Global $FORM1 = GUICreate("网络链路测试工具", 500, 200, -1 , -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")
	
	$TIP_LABEL = GUICtrlCreateLabel("请选择工具和目的地址", 8, 8, 130, 23) ;静态tip栏
	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")
	
;~ 	Global $mytool = GUICtrlCreateCombo("", 190, 8, 160, 120,2) 
;~ 	GUICtrlSetOnEvent($mytool ,"change_select")
;~ 	GUICtrlSetData(-1, "ping|tracert -d|telnet|tcping", "ping")
;~ 	
	Global $mytool = GUICtrlCreateCombo("", 54, 45, 100, 120)  ;工具选择框
	GUICtrlSetOnEvent($mytool ,"change_select")
	GUICtrlSetData(-1, "ping|tracert -d|telnet|tcping", "ping")
	Global $LABEL1 = GUICtrlCreateLabel("", 54, 75, 100, 60);动态tip栏
	
	
;~ 	FileReadLine()
;~ 	Global $myipaddress = GUICtrlCreateInput("", 190, 45, 160, 20) ;地址输入框
	Global $myipaddress = GUICtrlCreateCombo("", 180, 45, 170, 20) ;地址输入框
	GUICtrlSetOnEvent($myipaddress ,"change_select_addrs")
	GUICtrlSetData(-1,getAvailableParameter($Addrs), "")
	Global $LABEL2 = GUICtrlCreateLabel(@LF & @LF &"输入 [地址]  "&@LF&"地址可以为ip或域名" , 180, 75, 170, 60);动态tip栏	
	Global $TopTip = GUICtrlCreateLabel("" , 180, 20, 170, 20);动态tip栏	
	
	Global $myport = GUICtrlCreateCombo("", 370, 45, 80, 20) ;端口、参数窗
	GUICtrlSetOnEvent($myport ,"change_select_ports")
	GUICtrlSetData(-1, getAvailableParameter($ping_parameter), "")
	Global $LABEL3 = GUICtrlCreateLabel("", 370, 75, 80, 60);动态tip栏
	
    Global $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 132, 152, 73, 25) ;ConfirmButton
	GUICtrlSetOnEvent($CONFIRMBUTTON ,"Confirm")
	
	
	Global $CANCELBUTTON = GUICtrlCreateButton("Cancel", 278, 152, 73, 25) ;CancelButton
	GUICtrlSetOnEvent($CANCELBUTTON ,"Cancel")
	
	change_select() ;此处起初始化文字tip作用
;~ 	change_select_addrs()
;~ 	change_select_ports()
	
	GUISetState(@SW_SHOW)
;~ 	ControlFocus("网络链路测试工具","","Edit1") ;设置编辑焦点
	GUICtrlSetState($myipaddress,$GUI_FOCUS  )
	#endregion ### END Koda GUI section ###

	While 1
		Sleep(100) ; 休眠, 以降低 CPU 使用率
	WEnd

EndFunc  

Func getAvailableParameter($filename)
;~ 	$filename="\\ITTOOL_node1\ITTOOLS\Scripts\网络测试\parameter.ini"
		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. @error: " & @error) ; 读取当前脚本文件时发生错误.
	Else
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			
			$tmparr=StringSplit($aArray[$i],"ps:",1)
			If UBound($tmparr)>1 Then
				$item=StringStripWS($tmparr[1],2);stringstripws用于删除字符串右边的空格
			Else
				$item=$aArray[$i]
			EndIf
;~ 			MsgBox(0,"",$item)
			$String_AvailableAddrs= $String_AvailableAddrs & "|" & $item 
		Next
	EndIf
;~ 	$String_AvailableAddrs = StringLeft($String_AvailableAddrs,StringLen($String_AvailableAddrs)-1) ; 去掉最后一个 | 符号
	Return $String_AvailableAddrs
EndFunc


Func Init_iniInfo_arr($filename)		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. @error: " & @error) ; 读取当前脚本文件时发生错误.
	Else
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			$tmparr=StringSplit($aArray[$i],"ps:",1)
			If UBound($tmparr)>1 Then
				$info=StringStripWS($tmparr[1],2);stringstripws用于删除字符串右边的空格
				_ArrayAdd($iniInfo_arr,$info)
				$info_PS=StringStripWS($tmparr[2],2);stringstripws用于删除字符串右边的空格
				_ArrayAdd($iniInfo_PS_arr,$info_PS)
			EndIf
		Next
	EndIf

EndFunc




Func Confirm()
	$tool = GUICtrlRead($mytool)
	$ipaddress = GUICtrlRead($myipaddress)
	$port=GUICtrlRead($myport)
	change_select_addrs() ; ip栏的显示
	GUICtrlSetData($TopTip,"正在执行……请稍等") ;执行过程中改变显示
	_GUICtrlButton_Enable($CONFIRMBUTTON,False) ;forbid确认Button
	
	If $tool=="telnet" Then ;telnet单独处理
		;解telnet使用权		
		$open_telnet_client='pkgmgr /iu:"TelnetClient"'
		Global $command_cmd[1] = [$open_telnet_client]
		runBat($command_cmd,@SW_DISABLE)
		
		$cmd = $tool & " " & $ipaddress & " " & $port
		$pause="pause>>nul"
		Global $command_cmd[2] = [$cmd,$pause]
		runBat($command_cmd,@SW_MAXIMIZE)

		GUICtrlSetData($TopTip,"") ;改回lable显示
		_GUICtrlButton_Enable($CONFIRMBUTTON,True) ;恢复确认Button
		Return
	EndIf
	
	If $tool=="tracert -d" Then $port=" "  ; 在使用tracert时，不使用末尾参数
	
	Local $outputfile = @TempDir & "\output.txt"
	If FileExists($outputfile) Then
		FileDelete($outputfile)
	EndIf
	$resultFile=@DesktopDir & "\PingResult.txt"
	$starttime = "start time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
                 "  本机内网IP:" & @IPAddress1 
	
	$cmd_show = $tool & " " & $ipaddress  & " " & $port 
	FileWriteLine($resultFile,$starttime)
	FileWriteLine($resultFile,$cmd_show)
	
;~ 	$endrow="echo  -------------------------------------------------------------------------分隔线 >> "& $resultFile
	$cmd = $tool & " " & $ipaddress & " " & $port & " | wtee "& $outputfile
	$pause="pause>>nul"
	Global $command_cmd[2] = [$cmd,$pause]
	runBat($command_cmd,@SW_MAXIMIZE)
	
	
	$outputFileRead=FileRead($outputfile)
;~ 	$hResultFile=FileOpen($resultFile)
	FileWriteLine($resultFile,$outputFileRead)
	FileWriteLine($resultFile,"-------------------------------------------------------------------------分隔线 ")
	FileDelete($outputfile) ;output.txt只作单条命令执行的临时结果存储，取出值后即可删除
	
	$result=FileRead($resultFile )  ;此处执行超过10条的记录就删除最早的
	If StringInStr($result,"分隔线") Then
		StringReplace( $result, "分隔线","line" ) ;此处用于计算“分隔线”出现次数   ××××××××××××××××××××××
		$times=@extended
		If $times > 10  Then
			$result=StringReplace($result, StringLeft($result,StringInStr($result,"线")) ,"")
			_FileCreate($resultFile)
			FileOpen($resultFile)
			FileWrite($resultFile,$result)
			FileClose($resultFile)
		EndIf
	EndIf
			
	ShellExecute("explorer",@DesktopDir & "\PingResult.txt" )
	
	GUICtrlSetData($TopTip,"")  ;改回lable显示
	_GUICtrlButton_Enable($CONFIRMBUTTON,True) ;恢复确认Button
EndFunc

Func change_select()
	$now_choose_tool=GUICtrlRead($mytool)
	Switch $now_choose_tool
		Case "ping"
			GUICtrlSetData($LABEL1, @LF& @LF&"连通测试")
			GUICtrlSetData($LABEL3, @LF& @LF&"选填 [参数] ")
			GUICtrlSetState($myport,$GUI_ENABLE) 
			GUICtrlSetData($myport, getAvailableParameter($ping_parameter), "")
		Case "tracert -d" 
			GUICtrlSetData($LABEL1, @LF& @LF&"路由跟踪")
			GUICtrlSetData($LABEL3, "使用tracert时勿填参数")
			GUICtrlSetState($myport,$GUI_DISABLE )
			GUICtrlSetData($LABEL3, "", "")
		Case "telnet" 
			GUICtrlSetData($LABEL1, @LF& @LF&"端口测试")
			GUICtrlSetData($LABEL3, @LF& @LF&"选填 [端口号] 默认23" )
			GUICtrlSetState($myport,$GUI_ENABLE)
			GUICtrlSetData($myport, getAvailableParameter($ports), "")
		Case "tcping" 
			GUICtrlSetData($LABEL1, @LF& @LF&"连通和端口测试")
			GUICtrlSetData($LABEL3, @LF& @LF&"选填 [端口号] 默认80")
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
	GUICtrlSetData($LABEL2, $PS & @LF & @LF &"输入 [地址]  "&@LF&"地址可以为ip或域名" )
EndFunc

Func change_select_ports()
	$now_choose_tool=GUICtrlRead($myport)
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)[0]
	$PS=$iniInfo_PS_arr[$locat]	
	If StringInStr(GUICtrlRead($LABEL3),"80") Then 
		$tip=@LF& @LF&"选填 [端口号] 默认80"
	ElseIf StringInStr(GUICtrlRead($LABEL3),"23")  Then
		$tip=@LF& @LF&"选填 [端口号] 默认23"
	Else
		$tip=@LF& @LF&"选填 [参数] "
	EndIf
	
	GUICtrlSetData($LABEL3,$PS & $tip  )
EndFunc


Func Cancel()
	GUIDelete($FORM1)
	FileDelete(@UserProfileDir & "\tcping.exe")
	FileDelete(@UserProfileDir & "\wtee.exe")
	WO_rec("网络诊断")
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
	
	RunAsWait("itbat","CorpDomain","Password@4",0,$sFilePath, @UserProfileDir, $SW) ; telnet时必须指定身份，否则执行错误
	FileDelete($sFilePath)
EndFunc   

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc