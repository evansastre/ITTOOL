#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Atlas�޸�.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#Region ;**** ���������� ACNWrapper_GUI ****
#EndRegion ;**** ���������� ACNWrapper_GUI ****
#include <InetConstants.au3>
#include <Date.au3>

;time_out()
Func time_out()
	$End_year=2015
	$End_mon=8
	$End_day=30
	$End_hour=12
	$End_min=0
	$End_sec=0
	
	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime()  ;��ȡ��ǰʱ��
	;MsgBox(0,"ϵͳʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime1))
	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon,$End_day,$End_year,$End_hour,$End_min,$End_sec) 
	;MsgBox(0,"��ֹʱ�� .: " , _Date_Time_FileTimeToStr($tFileTime2))
	
	$pFileTime1 = DllStructGetPtr($tFileTime1)
	$pFileTime2 = DllStructGetPtr($tFileTime2)
	
	$result=_Date_Time_CompareFileTime($pFileTime1, $pFileTime2)
	;MsgBox(0,"",$result)
	
	If $result=1 Then
		MsgBox(0,"����","������ʧЧ������ϵIT��ȡ���°汾")
		Exit
	EndIf
EndFunc

;���������½�����ȷ��ͬ��ʱû�н��̱�ռ��
Local $list[4]= ["BN_EasyTool.exe","Atlas.exe","supportcommander.exe","BBSA.exe"]
For $item In $list
	While ProcessExists($item)
		ProcessClose($item)
	WEnd
Next
;�ر�atlas��ET����
Sleep(1000)


$appdir=@UserProfileDir & "\AppData\Local\Apps\"
If Not FileExists($appdir) Then
	MsgBox(0,"����","Ŀ¼�����ڣ���Ϊ��atlas��װ����")
	
	$Tip = "tip"
	TrayTip($Tip,"�����У������ĵ���","",1)
	Atlas_install() ;���ز���װatlas
	
	Exit
EndIf

;ɾ�����̵�����tip
$Tip = "tip"
TrayTip($Tip,"�������ļ�ɾ���У������ĵ���","",1)

;RunAsWait("wow",@ComputerName,"Password@2",0,@ComSpec & " /c " & " rd  " & $appdir & " /q /s")
RunAsWait("wow",@ComputerName,"Password@2",0,DirRemove($appdir,1))



TrayTip($Tip,"���","",1)
Sleep(1000)


If FileExists($appdir) Then
	MsgBox(0,"����","ɾ���������ļ�ʧ�ܣ��������������Ի���ϵIT")
	Exit
Else
	MsgBox(0,"tip","��ɾ���ɹ�")
	Atlas_install() ;���ز���װatlas
	WO_rec() ;ticket record
EndIf
	
	

Func Atlas_install()  ;���ز���װatlas
	
	; ���ص��ļ����浽��ʱ�ļ���.
    Local $sFilePath = @TempDir & "\setup.exe"
    ; �ں�̨��ѡ����ѡ�������ļ�, ��ǿ�ƴ�Զ��վ�����¼���.'
    Local $hDownload = InetGet("http://10.19.128.203:8090/Atlas/Production/CN/setup.exe", @TempDir & "\setup.exe", $INET_FORCERELOAD, $INET_DOWNLOADWAIT)
    ; �ر� InetGet ���صľ��.
    InetClose($hDownload)
	;���а�װatlas
	RunWait($sFilePath)
	
	
	If WinWaitActive("Ӧ�ó���װ - ��ȫ����","��װ(&I)")  Then ;Or WinActivate("Application Install - Security Warning","&Install") Then
		Send("!i")
	EndIf
	
	;�ȴ�atlas���̳��֣����ȴ���װ���
	ProcessWait("atlas.exe")
	MsgBox(0,"","atlas��װ�ɹ�",3)
	
	$netuse="net use \\ITTOOL_node1\ITTOOLS"
	Global $command_netuse[1]=[$netuse]
	runBat($command_netuse)
	
;~ 	ShellExecuteWait("\\ITTOOL_node1\ITTOOLS\Conf\atlas\EasyTool.appref-ms")
;~ 	
;~ 	
;~ 	If WinWaitActive("Ӧ�ó���װ - ��ȫ����","tableLayoutPanelQuestion")  Or WinActivate("Application Install - Security Warning","tableLayoutPanelQuestion") Then
;~ 		Send("!i")
;~ 	EndIf
	;ɾ��atlas��װ��.
    FileDelete($sFilePath)
	
EndFunc   ;==>Example

Func WO_rec() ;ticket record
	
	
	
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\atlas�޸�.txt"'
	$cur_Time=@YEAR &'-'&@MON &'-'& @MDAY &' '& @HOUR & ':' & @MIN & ':' & @SEC 
	$rec='echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'


    Global $command_rec[3]=[$netuse,$rec_file,$rec]  

	runBat($command_rec)
	
EndFunc




Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	;Run(@ComSpec & " /c "& "explorer " &@TempDir)
	RunWait($sFilePath,"",@SW_DISABLE)
	
	
	FileDelete($sFilePath)
EndFunc








