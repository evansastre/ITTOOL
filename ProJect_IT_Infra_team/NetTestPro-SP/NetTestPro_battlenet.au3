#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=.\NetTestPro-SP_Release\NetTestPro_battlenet.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

#include <process.au3>
#include <Misc.au3>
#include <File.au3>

If _Singleton("NetTestPro_battlenet",1) = 0 Then
		MsgBox(0,"","Test already running");Prevent repeated opening of the program
		Exit
EndIf

init()
Func init()
	;��ʼʱ��
	Global $starttime = "start time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  ��������IP:" & @IPAddress1  & @lf


	If Ping("www.163.com")==0 Then
		MsgBox(0,"","��ǰ������޷��뻥����ͨѶ���������ӻ����ǽ״̬")
		Exit
	EndIf
	
	Global $Addrs[0] ;��ַ���������ı�����
	Global $ports[0] ;�˿ڲ��������ı�����
	Global $names[0] ;��Ϸ���ƣ����ı�����
	Global $addr_file = @ScriptDir & "\battlenet.ini"
	getAvailableParameter($addr_file)
	
;~ 	_ArrayDisplay($Addrs)
;~ 	_ArrayDisplay($ports)
;~ 	_ArrayDisplay($names)

#CS
	Global $Addrs[8]=["122.198.64.131","114.113.217.71", _ ;"Agent1","Agent2"
					  "122.198.64.138","122.198.64.133","223.252.224.243", _  ; "ħ������","�籩Ӣ��4","�����ƻ����"
					  "223.252.251.86","122.198.66.132","114.113.218.136" ] ;   "�����ȷ�","�Ǽ����Ԣ�","¯ʯ��˵"
					  
	Global $ports[8]=["1119","1119", _
					  "1119","1119","3724", _
					  "3724","1119","1119" ]
					  
	Global $names[8]=["Agent1","Agent2", _
					  "ħ������","�籩Ӣ��","�����ƻ����", _
					  "�����ȷ�","�Ǽ����Ԣ�","¯ʯ��˵"]
#CE

	Global $check[8]=[False,False,False,False,False,False,False,False]
	Global $lenth= UBound($Addrs)

	Global $MTRtimes=20;����
	Global $TCPingtimes=20 ;����

	;ɾ���ɵļ�¼�ļ�
	For $i In  $Addrs 
		If FileExists(@TempDir&"\mtr_"& $i &".txt ") Then FileDelete(@TempDir&"\mtr_"& $i &".txt ")
		If FileExists(@TempDir&"\tcping_"& $i &".txt ") Then FileDelete(@TempDir&"\tcping_"& $i &".txt ")
	Next

	;ɾ���ɵļ�¼�ļ�
	FileDelete(@TempDir & '\NetTestPro_battlenet.txt')
	
	;��ѹ���߳���tempĿ¼
	If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then  FileInstall(".\tools\WinMTRCmd.exe",@TempDir&"\WinMTRCmd.exe" ,1)
	If Not FileExists(@TempDir&"\tcping.exe") Then  FileInstall(".\tools\tcping.exe",@TempDir&"\tcping.exe" ,1)
	If Not FileExists(@TempDir&"\sendmail_battlenet.exe") Then  FileInstall(".\tools\sendmail_battlenet.exe",@TempDir&"\sendmail_battlenet.exe" ,1)

			
	If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then
		MsgBox(0,"","��ѹ���߲��ɹ�")
		Exit
	EndIf
	
	MsgBox(0,"","������ʼս����Ϸ�ͻ�����·���ԣ�ִ�й������������",3)
	
	TrayTip("","��������ս����Ϸ�ͻ�����·����  ......����ر�",20)
	TraySetToolTip("������ս����Ϸ�ͻ�����·���� .......����ر�")
	If Not FileExists(@TempDir & '\NetTestPro_battlenet.txt') Then FileWriteLine(@TempDir & '\NetTestPro_battlenet.txt'," ") ;д�����
	
	
EndFunc


Func getAvailableParameter($filename)
	
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "��ȡ�ļ�ʱ���ִ���. "  & @LF & "battlenet.ini������") ; ��ȡ��ǰ�ű��ļ�ʱ��������.
		Exit
	Else
		For $i = 0 To UBound($aArray) - 1 ; ѭ����������.
			Local $centence=StringStripWS($aArray[$i],3)
			Local $RegExp = StringRegExpReplace($centence,"\s+","|") ;�����пո�TAB����ת����|
 			Local $thisArray = StringSplit($RegExp,"|",1) ;��|Ϊ�ָ�����Ԫ�����黯
;~ 			_ArrayDisplay($thisArray)
			_ArrayAdd($Addrs,$thisArray[1])
			_ArrayAdd($ports,$thisArray[2])
			_ArrayAdd($names,$thisArray[3])

		Next
	EndIf
	
EndFunc



For $i=0 To  $lenth-1 ;ִ�м��
	MTR($Addrs[$i],$ports[$i],$names[$i])
	TcpingTest($Addrs[$i],$ports[$i],$names[$i])
Next

Func MTR($ChosenAddress,$myports,$now_choose_tool)  ;20
	
;~ 	TrayTip("","��������winmtrcmd -c 20 "& $ChosenAddress &" ......",20)
;~ 	TraySetToolTip("������winmtrcmd -c 20 "&$ChosenAddress &".......����ر�")
	Local $mycmd[1]= ["set path=%temp%;%path% && winmtrcmd -c "& $MTRtimes &"  -r -f %temp%\mtr_" & $ChosenAddress  &".txt "& $ChosenAddress]
	runBat($mycmd)
			
EndFunc

Func TcpingTest($ChosenAddress,$myports,$now_choose_tool)  ;100

;~ 	_RunDos("set path=%temp%;%path% && tcping -n " & $TCPingtimes  & " " &  $ChosenAddress  & "  " & $myports &  ">> %temp%\" & $ChosenAddress & ".txt")
	Local $mycmd[1]=["set path=%temp%;%path% && tcping -n " & $TCPingtimes  & " " &  $ChosenAddress  & "  " & $myports &  ">> %temp%\tcping_" & $ChosenAddress & ".txt"]
	runBat($mycmd)
	
EndFunc

Mtr_Tcping_Result()
Func Mtr_Tcping_Result()
	
	Local $i=0	
	While ($i <= $lenth-1)
		
		If $check[$i]==False Then 
		
			If FileExists(@TempDir&"\mtr_"& $Addrs[$i] &".txt ") And FileExists(@TempDir&"\tcping_"& $Addrs[$i] &".txt ")  Then
				write_mtr_result($Addrs[$i],$names[$i])
				write_tcping_result($Addrs[$i],$names[$i])
				$check[$i]=True
			Else
				Sleep(500)
				ContinueLoop
			EndIf
		EndIf
		$i+=1
	WEnd
		
EndFunc

Func Mtr_Tcping_Result_old()
	
	Local $checkResult=True
	For $i=0 To   $lenth-1  
		$checkResult =$check[$i] And $checkResult
		If $check[$i]==True Then ContinueLoop
		
		If FileExists(@TempDir&"\mtr_"& $Addrs[$i] &".txt ") And FileExists(@TempDir&"\tcping_"& $Addrs[$i] &".txt ")  Then
			write_mtr_result($Addrs[$i],$names[$i])
			write_tcping_result($Addrs[$i],$names[$i])
			$check[$i]=True
		EndIf
	Next
	
	If Not $checkResult Then
		Sleep(1000)
		Mtr_Tcping_Result()
	EndIf
	
EndFunc

Func write_mtr_result($ChosenAddress,$now_choose_tool)
 	_FileWriteToLine(@TempDir & '\mtr_' & $ChosenAddress  &'.txt',1,$now_choose_tool&"  mtr��⣺" &@LF& "winmtrcmd -c 20 " & $ChosenAddress );д������
	FileWriteLine(@TempDir & '\mtr_' &  $ChosenAddress  &'.txt'," ") ;д�����
	FileWriteLine(@TempDir & '\mtr_' &  $ChosenAddress  &'.txt'," ") ;д�����
	
	FileWriteLine(@TempDir & '\mtr_' &  $ChosenAddress  &'.txt',"������"&@LF )
	FileWriteLine(@TempDir & '\mtr_' &   $ChosenAddress  &'.txt',	"�鿴����ܵ����һ����һ�㶪����20%���£�Avg(ƽ������ֵ)30���£��ж�Ϊ����״�����á�"&@LF )

	FileWriteLine(@TempDir & '\mtr_' &   $ChosenAddress  &'.txt',"===================================================================================================") ;
	$hFileOpen=FileOpen(@TempDir & '\mtr_' &   $ChosenAddress  &'.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$sFileRead) ;д���ȡ������
	FileClose($hFileOpen)
	FileDelete(@TempDir&'\mtr_' &   $ChosenAddress  &'.txt ')
EndFunc


Func write_tcping_result($ChosenAddress,$now_choose_tool)
 	FileWriteLine(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt',@LF & "����������20�������һ��������Ϊ����ʱ��ƽ����30ms���¡��޹��߷�ֵ�ж�Ϊ���á�" & @LF) ;
	FileWriteLine(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt',"===================================================================================================") ;
	$hFileOpen=FileOpen(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$sFileRead) ;д���ȡ������
	FileClose($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,"===================================================================================================" )
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',2,$now_choose_tool & "  tcping���ԣ�" )
	
	FileDelete(@TempDir & '\tcping_' & $ChosenAddress  & '.txt')
EndFunc

Logs()
Func Logs()
	If Not FileExists(@TempDir & '\NetTestPro_battlenet.txt') Then FileWriteLine(@TempDir & '\NetTestPro_battlenet.txt',"for test") 
		
	;����ʱ��
	$endtime = "end   time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  ��������IP:" & @IPAddress1  & @lf
					 
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$endtime) ;д���ȡ
	FileWriteLine(@TempDir & 'NetTestPro_battlenet.txt'," ") ;д�����

	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$starttime) ;д���ȡ
	FileWriteLine(@TempDir & 'NetTestPro_battlenet.txt'," ") ;д�����

	;д�뱸ע
	If Not FileExists(@ScriptDir&"\Info.txt") Then
		FileWriteLine(@ScriptDir&"\Info.txt"," ") 
	ElseIf FileExists(@ScriptDir&"\Info.txt") Then
		$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
		Local $sFileRead = FileRead($hFileOpen)
		_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$sFileRead) ;д���ȡ������
		FileClose($hFileOpen)
		
		FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
	EndIf
EndFunc

sendmail()
Func sendmail()
	TrayTip("","���ڷ����ʼ�......",20)
	TraySetToolTip("���ڷ����ʼ�......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
	_RunDos("set path=%temp%;%path% && sendmail_battlenet.exe")
EndFunc

DeleteAll()
Func DeleteAll()
	
	$timemark = '-' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & '-' & @MIN & '-' & @SEC 
	_RunDos('copy %temp%\NetTestPro_battlenet.txt  "' & @ScriptDir&'\NetTestPro_battlenet'  & $timemark &  '.txt"' )

	ShellExecute(@ScriptDir&"\NetTestPro_battlenet"  & $timemark &  ".txt","open") ;���չʾ
	
	FileDelete(@TempDir&"\WinMTRCmd.exe")
	FileDelete(@TempDir&"\tcping.exe")
	FileDelete(@TempDir&"\sendmail_battlenet.exe")


	MsgBox(0,"","ս����Ϸ�ͻ�����·���������")
EndFunc


Func runBat($cmd);$cmd must be array

    Local $sFilePath =_TempFile(Default,Default,".bat")
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc

Func runBatWait($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc
