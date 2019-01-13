#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\wow_hz_IP自助修改.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
; 获取当前IP，截取前三位，用户输入第四位
#include <Array.au3>
#include <String.au3>
#include <Date.au3>



time_start() ;程序失效时间
Func time_start()
	$End_year = 2015
	$End_mon = 6
	$End_day = 16
	$End_hour = 12
	$End_min = 0
	$End_sec = 0
	
	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime() ;获取当前时间
	;MsgBox(0,"系统时间 .: " , _Date_Time_FileTimeToStr($tFileTime1))
	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon, $End_day, $End_year, $End_hour, $End_min, $End_sec)
	;MsgBox(0,"中止时间 .: " , _Date_Time_FileTimeToStr($tFileTime2))
	
	$pFileTime1 = DllStructGetPtr($tFileTime1)
	$pFileTime2 = DllStructGetPtr($tFileTime2)
	
	$result = _Date_Time_CompareFileTime($pFileTime2,$pFileTime1)
	;MsgBox(0,"",$result)
	
	If $result = 1 Then
		MsgBox(0, "警告", "请在6月16号后运行")
		Exit
	EndIf
EndFunc   ;==>time_out




time_out() ;程序失效时间
Func time_out()
	$End_year = 2015
	$End_mon = 10
	$End_day = 10
	$End_hour = 12
	$End_min = 0
	$End_sec = 0
	
	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime() ;获取当前时间
	;MsgBox(0,"系统时间 .: " , _Date_Time_FileTimeToStr($tFileTime1))
	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon, $End_day, $End_year, $End_hour, $End_min, $End_sec)
	;MsgBox(0,"中止时间 .: " , _Date_Time_FileTimeToStr($tFileTime2))
	
	$pFileTime1 = DllStructGetPtr($tFileTime1)
	$pFileTime2 = DllStructGetPtr($tFileTime2)
	
	$result = _Date_Time_CompareFileTime($pFileTime1, $pFileTime2)
	;MsgBox(0,"",$result)
	
	If $result = 1 Then
		MsgBox(0, "警告", "程序已失效，请联系IT获取最新版本")
		Exit
	EndIf
EndFunc   ;==>time_out



Global $special[] = ["109.52", "109.53", "109.105", "108.68"]
IsSpecial() ;判断特殊IP，tip无需修改, ××××实际操作中，用户拔网线后无法获取到当前IP
Func IsSpecial()
	For $elem In $special
		If @IPAddress1 == "192.168." & $elem Then
			MsgBox(0, "", "您的IP无需更改")
			Exit
		EndIf
	Next
EndFunc   ;==>IsSpecial


;判断用户是否从局域网断开
If Ping("192.168.112.151") Then
	MsgBox(0, "警告", "请拔掉网线后运行此程序，当前程序将终止")
	Exit
EndIf



GetInput()
Func GetInput() ;获取用户输入，处理变量
	;用户输入；输入结果转换为大写 ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××
	Local $sText = StringUpper(InputBox("tip", "输入当前主机所在的<!完整!>座位编号，如：4F-A001"))
	;Local $sText = StringUpper("5f-a090")
	;以F为标志分割字符串
	Local $aArray = _StringExplode($sText, "F", 2)
	;楼层
	Global $floor = StringRight($aArray[0], 1)
	;区域
	$a1 = StringRight($aArray[1], 4)
	Global $area = StringLeft($a1, 1)
	;编号
	Global $number = Int(StringRight($a1, 3))
EndFunc   ;==>GetInput



;处理并得到正确IP
Switch $floor
	Case 5
		Global $gateway = "192.168.109.254" ;五楼统一为109段网关
		Switch $area
			
			Case "A" ;总共133台，划入108段
				Global $ip3 = 108
				Global $ip4 = $number
				If $number == 68 Then ;将108.68 改为 109.112
					$ip3 = 109
					$ip4 = 112
				EndIf
				
				For $i = 81 To 95 ;此区间monitor在使用，需要跳地址 +53
					If $i == $number Then
						$ip4 = $number + 53
					EndIf
				Next
				
			Case "B" ;总共108台，划入109段
				Global $ip3 = 109
				Global $ip4 = $number
				
				Switch $number
					Case 52 ;将109.52 改为 109.109
						$ip4 = 109
					Case 53 ;将109.53 改为 109.110
						$ip4 = 110
					Case 105 ;将109.105 改为 109.111
						$ip4 = 111
				EndSwitch
		EndSwitch
		
	Case 4
		Global $gateway = "192.168.117.254" ;四楼为117段网关
		Global $ip3 = 117
		Switch $area
			Case "A" ;总共129台,划入117段
				Global $ip4 = $number
			Case "B" ;总共43台,划入117段后部分
				Global $ip4 = $number + 129
		EndSwitch
		
EndSwitch

Global $ip = "192.168." & $ip3 & "." & $ip4
Global $mask = "255.255.254.0" ;掩码
Global $DNS_prim = "192.168.112.151" ;主dns
Global $DNS_second = "192.168.112.152";备dns

;MsgBox(0,"",$ip&@LF&$gateway)
;Exit
;********************




setStaticIP()

TrayTip("tip", "完成", "", 1)
Sleep(1000)
MsgBox(0, "", "修改已完成，请插回网线并登录使用")

WO_rec() ;记录已修改的

Func setStaticIP()
	$s1 = 'netsh interface ip set address name="本地connect" source=static addr=' & $ip & ' mask=' & $mask & ' gateway=' & $gateway & '  gwmetric=0 '
	$s2 = 'netsh interface ip set dns name="本地connect" source=static addr=' & $DNS_prim & ' register=PRIMARY  '
	$s3 = 'netsh interface ip add dns name="本地connect" addr=' & $DNS_second
	$s4 = 'netsh interface ip set wins name="本地connect" source=static addr=none'
	Global $command[4] = [$s1, $s2, $s3, $s4]
	
	
	TrayTip("tip", "修改执行中，请耐心等耐", "", 1)
	
	runBat($command);运行bat 修改IP
	
EndFunc   ;==>setStaticIP

Func WO_rec() ;ticket record
	
	If Not Ping("192.168.112.245") Then
		Sleep(3000)
		WO_rec()
		Exit
	EndIf
	
	Sleep(1000)
	
	
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\IPset.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & @IPAddress1 & "   " & $cur_Time  & '>> %rec%'
	;$echo="echo " & $cur_Time & " " & $rec
	
	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	;RunAs("wow",@ComputerName,"Password@2",0,@ComSpec & " /c " & $command_rec,"",@SW_HIDE)
	runBat($command_rec)
	
EndFunc   ;==>WO_rec

Func runBat($cmd) ;$cmd must be array
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd
		FileWriteLine($sFilePath, $i)
	Next

	
	RunWait($sFilePath, "", @SW_DISABLE)
	
	
	
	FileDelete($sFilePath)
EndFunc   ;==>runBat










