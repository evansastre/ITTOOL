Local Const $username = "ITSuperAdmin", $password = "Password@2"
Local $server, $socket = -1
$server = "192.168.112.172";������IP
Local $buff = "", $buffSize = 500 ;for receiving ack
;~ OnAutoItExitRegister("_CleanOnExit")

Init()
Func Init()
	Opt("TCPTimeout",1000)  ;���ó�ʱ
	
	TCPStartup()
	$socket = TCPConnect($server, 23) ; 23 - telnet port
	If @error Then
		MsgBox(0, "", "connect������")
		Return
	Else
;~ 		MsgBox(0,"","connect�ɹ�")
	EndIf


	
	
	; Verify if it's login request
	If WaitFor("login") == -1 Then
		MsgBox(0, "", "û���ҵ��û��������")
		Return 
	Else
;~ 		MsgBox(0,"","����login")
	EndIf
	
	
	;Send username
	If SendLine($username) == -1 Then 
		MsgBox(0, "", "�û������ͳ���")
		Return -1
	EndIf
	
	$needPW=True
	If WaitFor("password") == -1 Then
		;Handle the case that password is removed
		If StringInStr($buff, "> ") == 0 Then
			$needPW = False
			MsgBox(0, "", "����Ҫ����")
		Else
			MsgBox(0, "", "û���ҵ����������")
			Return -1
		EndIf
	Else
;~ 		MsgBox(0,"","����password")
		
	EndIf
	
	If $needPW Then
		;Send password
		If SendLine($password) == -1 Then 
			MsgBox(0, "", "���뷢��ʧ��")
			Return -1
		EndIf
		If WaitFor(">") == 0 Then 
;~ 			MsgBox(0, "", "��¼�ɹ�")
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
	MsgBox(0, "", "���telnet���ز���-1,�͹ر�tcpconnect")
	TCPShutdown()
EndFunc   ;==>_CleanOnExit
