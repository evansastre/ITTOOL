#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\jre�޸�-���������޷�ǩ������beta.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <IE.au3>
#include<date.au3>

;time_out()
;~ Func time_out()
;~ 	$End_year = 2015
;~ 	$End_mon = 8
;~ 	$End_day = 30
;~ 	$End_hour = 12
;~ 	$End_min = 0
;~ 	$End_sec = 0
;~ 	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime() ;��ȡ��ǰʱ��
;~ 	;MsgBox(0,"ϵͳʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime1))
;~ 	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon, $End_day, $End_year, $End_hour, $End_min, $End_sec)
;~ 	;MsgBox(0,"��ֹʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime2))

;~ 	$pFileTime1 = DllStructGetPtr($tFileTime1)
;~ 	$pFileTime2 = DllStructGetPtr($tFileTime2)

;~ 	$result = _Date_Time_CompareFileTime($pFileTime1, $pFileTime2)
;~ 	;MsgBox(0,"",$result)

;~ 	If $result = 1 Then
;~ 		MsgBox(0, "����", "������ʧЧ������ϵIT��ȡ���°汾")
;~ 		Exit
;~ 	EndIf
;~ EndFunc   ;==>time_out


;~ ;�ر�IE
$res=MsgBox(4,"tip","�����ر�����IE��������Ƿ������")
If $res==7 Then
	Exit
EndIf




Func ProcessCloseAll($process)
	While ProcessExists($process) 
		ProcessClose($process)
	WEnd
EndFunc
ProcessCloseAll("iexplore.exe")
ProcessCloseAll("MyPopo.exe")
;~ ProcessCloseAll("iexplore.exe")


;~ ProcessClose("explorer.exe")
Sleep(1000)

$choose = MsgBox(3, "����", "�״�������ע��һ��,���µ�¼���ȴ򿪱���������޸����̡�" & @LF & @LF & "ѡ���ǡ���ʼע��" & @LF & "ѡ�񡮷񡯡�����ʼ�޸�" & @LF & "ѡ��Cancel���������κβ���")
If $choose = "6" Then
	Shutdown(0) ;�Ƿ���6���񷵻�7��Cancel����2
	Exit
ElseIf $choose = "2" Then
	Exit
EndIf


$ie_dir1 = FileGetShortName(@UserProfileDir & "\appdata\Local\Microsoft\Internet Explorer") ;�Ժ��пո��·�����ö����ǱȽϺõĴ�����
$ie_dir2 = FileGetShortName(@UserProfileDir & "\AppData\LocalLow\Microsoft\Internet Explorer")
;~ $ie_dir3=FileGetShortName(@UserProfileDir &"\AppData\Roaming\Microsoft\Internet Explorer")
$dir_to = @UserProfileDir & "\AppData\LocalLow\Sun" ;JRE�����ļ�����·��

Global $message = "" ;�洢ɾ���������Ϣ

Global $dir_to_del[3] = [$ie_dir1, $ie_dir2, $dir_to]
For $i In $dir_to_del
	Del_IE($i)
Next


Func Del_IE($ie_dir)
	
;~ 	RunAsWait("wow",@ComputerName,"Password@2", 0, DirRemove($ie_dir, 1)) ;�����ԱȨ�ޱ���
	RunAsWait("itbat","CorpDomain","Password@4",0, DirRemove($ie_dir, 1)) ;�����ԱȨ�ޱ���
	
	Global $time=1
	While($time<4) 
;~ 		MsgBox(0,"","time: " & $time)
		Select
			Case Not FileExists($ie_dir)
				$message = $message & $ie_dir & " ɾ���ɹ�" & @LF
				
;~ 				MsgBox(0,"","success "&$time)
				$time=4
				ContinueLoop
			Case FileExists($ie_dir) And $time<3
				Sleep(1000)
				
;~ 				MsgBox(0,"","continue "&$time)
				$time+=1
				ContinueLoop
			Case FileExists($ie_dir) And $time==3
				$message = $message & $ie_dir & " ɾ��ʧ��,��ע��������������" & @LF
				
;~ 				MsgBox(0,"","fail "&$time)
				$time+=1
				ContinueLoop
				
		EndSelect
		
	WEnd
	

EndFunc   ;==>Del_IE

MsgBox(0, "", $message)

netuse() ;
Func netuse()
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS '
	Global $command_netuse[1] = [$netuse]
	runBat($command_netuse)
EndFunc   ;==>netuse


$Tip = "tip"
TrayTip($Tip,"�����ļ������У������ĵ���","",1)

$dir_from1 = "\\ITTOOL_node1\ITTOOLS\Conf\Java�޸�" ;JRE�����ļ�·��
$dir_to1 = @UserProfileDir & "\AppData"
RunAsWait("wow", @ComputerName, "Password@2", 0, DirCopy($dir_from1, $dir_to1, 1 + 8)) ;1+8= �������򴴽��������򸲸ǣ�;�����������������ļ�������

;~ $dir_from2 = "\\ITTOOL_node1\ITTOOLS\Conf\Java�޸�\Locallow" ;JRE�����ļ�·��
;~ $dir_to2 = @UserProfileDir & "\AppData\LocalLow"
;~ RunAsWait("wow", @ComputerName, "Password@2", 0, DirCopy($dir_from2, $dir_to2, 1 + 8)) ;1+8= �������򴴽��������򸲸ǣ�;�����������������ļ�������



TrayTip($Tip,"���","",1)
Sleep(1000)


If Not FileExists($dir_to) Then
	MsgBox(0, "tip", "�����������ļ�ʧ��,����ϵIT������������")
	Exit
Else
	WO_rec("JRE�޸�")
	
	
	MsgBox(0, "tip", "�޸���ɣ������µ�¼��������",3)
EndIf

Local $oIE = _IECreate("http://call.wow:1081/login.action",0,1,0)

;~ ;Cancel�˶�ע�ͣ������ڲ���
;~ Local $oForm = _IEFormGetObjByName($oIE, "loginFrom") ; ��ȡ����longin
;~ Local $account = _IEFormElementGetObjByName($oForm, "username")
;~ _IEFormElementSetValue($account, "H0616")
;~ Local $password = _IEFormElementGetObjByName($oForm, "password")
;~ _IEFormElementSetValue($password, "123456")
;~ Local $callnum = _IEFormElementGetObjByName($oForm, "extnum")
;~ _IEFormElementSetValue($callnum, "5666")
;~ _IEFormImageClick($oIE, "images/button-login.gif", "src")



;�Զ���ѡJRE����ѡ��
WinWait("��ȫ����", "", 60)
WinActivate("��ȫ����", "")
If WinActive("��ȫ����", "") Then
	;MsgBox(0, "", "������")
	Send("!d")
	Sleep(100)
	Send("!i")
	Sleep(2000)
	Send("!r")
Else
	MsgBox(0, "", "��ע�������µ�¼��������")
EndIf


;_IELinkClickByText($oIE, "��ͨ��ϯ")
;$login_page = _IECreate("http://call.wow:1081/agent/client/common.action")

;~ Send("^t")
;~ Sleep(200)
;~ Send("http://call.wow:1081/agent/client/common.action")
;~ Sleep(200)
;~ Send("{enter}")
;~ ;
WinWait("������ҳ����Ϣ","Confirm",10)
WinActivate("������ҳ����Ϣ","Confirm")
ControlClick("������ҳ����Ϣ","Confirm","Button1","left")

;_IELoadWait($login_page)

;���ǩ��
;~ Local $login_button = _IEGetObjByName($login_page, "login_button")
;~ _IEAction($login_button, "click")


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc

Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
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


;H0616 123456   5666

