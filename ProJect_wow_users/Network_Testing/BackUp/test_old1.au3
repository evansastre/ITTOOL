Local Const $username = "ITSuperAdmin", $password = "Password@2"
Local $server, $socket = -1
$server = "192.168.112.192";������IP
Local $buff = "", $buffSize = 500  ;for receiving ack
OnAutoItExitRegister("_CleanOnExit")

Init()
Func Init()
	TCPStartup()
	$socket = TCPConnect($server, 23) ; 23 - telnet port
	If @error Then 
		MsgBox(0,"","������connect����")
		Return 
	EndIf

	Exit
        ; Verify if it's login request
	If WaitFor("login") = -1 Then Return -1
			MsgBox(0,"","û���ҵ��û��������")

	;Send username
	If SendLine($username) = -1 Then Return -1
			MsgBox(0,"","�û������ͳ���")
			
	If WaitFor("password") = -1 Then
			;Handle the case that password is removed
			If StringInStr($buff, "# ") = 0 Then
					$needPW = False
											MsgBox(0,"","����Ҫ����")

					   Else
					Return -1
											MsgBox(0,"","û���ҵ����������")
								EndIf
	EndIf
	
	If $needPW Then
			;Send password
			If SendLine($password) = -1 Then Return -1
											MsgBox(0,"","���뷢��ʧ��")
			If WaitFor("# ") = -1 Then Return -1        
															MsgBox(0,"","�����Ǹ�ʲô?????????")
	EndIf
	Return 0
                

                
EndFunc
 
 
Global $buff  ; to hold the received content
 $string="ps"
;=================================================================
; Name: SendLine
; Description: Send one command line (@CRLF added automatically)
; Return value: 0 - Success
;         -1 - Failure
;=================================================================
Func SendLine($string)
	TCPSend($socket, $string & @CRLF)
	If @error Then
			;Local $result = DllCall("Ws2_32.dll", "int", "WSAGetLastError")
			;Return $result[0]
			 Return -1
	EndIf
	Return 0
EndFunc
  
;=================================================================
; Name: WaitFor
; Description: Wait for desired output. Use it after each TCPSend() to make
;       buff always hold the latest content
; Return value: 0 - Success
;       -1 - Failure
;=================================================================
Func WaitFor($string, $timeout=2000)
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
EndFunc

 
Func _CleanOnExit()
	If $socket <> -1 Then TCPCloseSocket($socket)
	MsgBox(0,"","���telnet���ز���-1,�͹ر�tcpconnect")
	TCPShutdown()
EndFunc