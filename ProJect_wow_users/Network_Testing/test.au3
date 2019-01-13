Local Const $username = "ITSuperAdmin", $password = "Password@2"
Local $server, $socket = -1
$server = "192.168.112.172";服务器IP
Local $buff = "", $buffSize = 500 ;for receiving ack
;~ OnAutoItExitRegister("_CleanOnExit")

Init()
Func Init()
	Opt("TCPTimeout",1000)  ;设置超时
	
	TCPStartup()
	$socket = TCPConnect($server, 23) ; 23 - telnet port
	If @error Then
		MsgBox(0, "", "connect不可用")
		Return
	Else
;~ 		MsgBox(0,"","connect成功")
	EndIf


	
	
	; Verify if it's login request
	If WaitFor("login") == -1 Then
		MsgBox(0, "", "没有找到用户名输入点")
		Return 
	Else
;~ 		MsgBox(0,"","出现login")
	EndIf
	
	
	;Send username
	If SendLine($username) == -1 Then 
		MsgBox(0, "", "用户名发送出错")
		Return -1
	EndIf
	
	$needPW=True
	If WaitFor("password") == -1 Then
		;Handle the case that password is removed
		If StringInStr($buff, "> ") == 0 Then
			$needPW = False
			MsgBox(0, "", "不需要密码")
		Else
			MsgBox(0, "", "没有找到密码输入点")
			Return -1
		EndIf
	Else
;~ 		MsgBox(0,"","出现password")
		
	EndIf
	
	If $needPW Then
		;Send password
		If SendLine($password) == -1 Then 
			MsgBox(0, "", "密码发送失败")
			Return -1
		EndIf
		If WaitFor(">") == 0 Then 
;~ 			MsgBox(0, "", "登录成功")
		EndIf
	EndIf
	Return 0



EndFunc   ;==>Init


Global $buff ; to hold the received content
$string = "ps"

Func SendLine($string)
	TCPSend($socket, $string & @CRLF)
	If @error Then
		;Local $result = DllCall("Ws2_32.dll", "int", "WSAGetLastError")
		;Return $result[0]
		Return -1
	EndIf
;~ 	Return 0
EndFunc   ;==>SendLine

;=================================================================
; Name: WaitFor
; Description: Wait for desired output. Use it after each TCPSend() to make
;       buff always hold the latest content
; Return value: 0 - Success
;       -1 - Failure
;=================================================================
Func WaitFor($string, $timeout = 2000)
	Local $recv = ""
	$buff = ""
	If $string <> "" Then
		$timer = TimerInit()
		Do
			$recv &= TCPRecv($socket, $buffSize)
			If @error <> 0 Then Return -1
			If $recv == "" Then
				Sleep(20)
			Else
				$buff &= $recv
			EndIf
			If TimerDiff($timer) > $timeout Then Return -1
		Until StringInStr($buff, $string) > 0
	EndIf
	Return 0
EndFunc   ;==>WaitFor


Func _CleanOnExit()
	If $socket <> -1 Then TCPCloseSocket($socket)
	MsgBox(0, "", "如果telnet返回不是-1,就关闭tcpconnect")
	TCPShutdown()
EndFunc   ;==>_CleanOnExit
