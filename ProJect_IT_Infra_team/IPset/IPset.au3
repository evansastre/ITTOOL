#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\wow_hz_IP�����޸�.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#Region ;**** ���������� ACNWrapper_GUI ****
#EndRegion ;**** ���������� ACNWrapper_GUI ****
; ��ȡ��ǰIP����ȡǰ��λ���û��������λ
#include <Array.au3>
#include <String.au3>
#include <Date.au3>



time_start() ;����ʧЧʱ��
Func time_start()
	$End_year = 2015
	$End_mon = 6
	$End_day = 16
	$End_hour = 12
	$End_min = 0
	$End_sec = 0
	
	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime() ;��ȡ��ǰʱ��
	;MsgBox(0,"ϵͳʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime1))
	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon, $End_day, $End_year, $End_hour, $End_min, $End_sec)
	;MsgBox(0,"��ֹʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime2))
	
	$pFileTime1 = DllStructGetPtr($tFileTime1)
	$pFileTime2 = DllStructGetPtr($tFileTime2)
	
	$result = _Date_Time_CompareFileTime($pFileTime2,$pFileTime1)
	;MsgBox(0,"",$result)
	
	If $result = 1 Then
		MsgBox(0, "����", "����6��16�ź�����")
		Exit
	EndIf
EndFunc   ;==>time_out




time_out() ;����ʧЧʱ��
Func time_out()
	$End_year = 2015
	$End_mon = 10
	$End_day = 10
	$End_hour = 12
	$End_min = 0
	$End_sec = 0
	
	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime() ;��ȡ��ǰʱ��
	;MsgBox(0,"ϵͳʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime1))
	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon, $End_day, $End_year, $End_hour, $End_min, $End_sec)
	;MsgBox(0,"��ֹʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime2))
	
	$pFileTime1 = DllStructGetPtr($tFileTime1)
	$pFileTime2 = DllStructGetPtr($tFileTime2)
	
	$result = _Date_Time_CompareFileTime($pFileTime1, $pFileTime2)
	;MsgBox(0,"",$result)
	
	If $result = 1 Then
		MsgBox(0, "����", "������ʧЧ������ϵIT��ȡ���°汾")
		Exit
	EndIf
EndFunc   ;==>time_out



Global $special[] = ["109.52", "109.53", "109.105", "108.68"]
IsSpecial() ;�ж�����IP��tip�����޸�, ��������ʵ�ʲ����У��û������ߺ��޷���ȡ����ǰIP
Func IsSpecial()
	For $elem In $special
		If @IPAddress1 == "192.168." & $elem Then
			MsgBox(0, "", "����IP�������")
			Exit
		EndIf
	Next
EndFunc   ;==>IsSpecial


;�ж��û��Ƿ�Ӿ������Ͽ�
If Ping("192.168.112.151") Then
	MsgBox(0, "����", "��ε����ߺ����д˳��򣬵�ǰ������ֹ")
	Exit
EndIf



GetInput()
Func GetInput() ;��ȡ�û����룬�������
	;�û����룻������ת��Ϊ��д ������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������
	Local $sText = StringUpper(InputBox("tip", "���뵱ǰ�������ڵ�<!����!>��λ��ţ��磺4F-A001"))
	;Local $sText = StringUpper("5f-a090")
	;��FΪ��־�ָ��ַ���
	Local $aArray = _StringExplode($sText, "F", 2)
	;¥��
	Global $floor = StringRight($aArray[0], 1)
	;����
	$a1 = StringRight($aArray[1], 4)
	Global $area = StringLeft($a1, 1)
	;���
	Global $number = Int(StringRight($a1, 3))
EndFunc   ;==>GetInput



;�����õ���ȷIP
Switch $floor
	Case 5
		Global $gateway = "192.168.109.254" ;��¥ͳһΪ109������
		Switch $area
			
			Case "A" ;�ܹ�133̨������108��
				Global $ip3 = 108
				Global $ip4 = $number
				If $number == 68 Then ;��108.68 ��Ϊ 109.112
					$ip3 = 109
					$ip4 = 112
				EndIf
				
				For $i = 81 To 95 ;������monitor��ʹ�ã���Ҫ����ַ +53
					If $i == $number Then
						$ip4 = $number + 53
					EndIf
				Next
				
			Case "B" ;�ܹ�108̨������109��
				Global $ip3 = 109
				Global $ip4 = $number
				
				Switch $number
					Case 52 ;��109.52 ��Ϊ 109.109
						$ip4 = 109
					Case 53 ;��109.53 ��Ϊ 109.110
						$ip4 = 110
					Case 105 ;��109.105 ��Ϊ 109.111
						$ip4 = 111
				EndSwitch
		EndSwitch
		
	Case 4
		Global $gateway = "192.168.117.254" ;��¥Ϊ117������
		Global $ip3 = 117
		Switch $area
			Case "A" ;�ܹ�129̨,����117��
				Global $ip4 = $number
			Case "B" ;�ܹ�43̨,����117�κ󲿷�
				Global $ip4 = $number + 129
		EndSwitch
		
EndSwitch

Global $ip = "192.168." & $ip3 & "." & $ip4
Global $mask = "255.255.254.0" ;����
Global $DNS_prim = "192.168.112.151" ;��dns
Global $DNS_second = "192.168.112.152";��dns

;MsgBox(0,"",$ip&@LF&$gateway)
;Exit
;********************




setStaticIP()

TrayTip("tip", "���", "", 1)
Sleep(1000)
MsgBox(0, "", "�޸�����ɣ��������߲���¼ʹ��")

WO_rec() ;��¼���޸ĵ�

Func setStaticIP()
	$s1 = 'netsh interface ip set address name="����connect" source=static addr=' & $ip & ' mask=' & $mask & ' gateway=' & $gateway & '  gwmetric=0 '
	$s2 = 'netsh interface ip set dns name="����connect" source=static addr=' & $DNS_prim & ' register=PRIMARY  '
	$s3 = 'netsh interface ip add dns name="����connect" addr=' & $DNS_second
	$s4 = 'netsh interface ip set wins name="����connect" source=static addr=none'
	Global $command[4] = [$s1, $s2, $s3, $s4]
	
	
	TrayTip("tip", "�޸�ִ���У������ĵ���", "", 1)
	
	runBat($command);����bat �޸�IP
	
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










