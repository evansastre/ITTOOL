#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=G:\D.�������\3.���������Ϲ���\NetTestPro\NetTestPro.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****


#include <process.au3>
#include <Misc.au3>
#include <File.au3>
#include "Choose.au3"

If _Singleton("NetTestPro",1) = 0 Then
		MsgBox(0,"","Test already running");Prevent repeated opening of the program
		Exit
EndIf



If Ping("www.163.com")==0 Then
	MsgBox(0,"","��ǰ������޷��뻥����ͨѶ���������ӻ����ǽ״̬")
	Exit
EndIf


;���������½�����ȷ��ͬ��ʱû�н��̱�ռ��
Local $list[4]= ["getmyip.exe","sendmail.exe","speedtest_cli_py.exe","WinMTRCmd.exe"]
For $item In $list
	While ProcessExists($item)
		ProcessClose($item)
	WEnd
Next

;ɾ���ɵļ�¼�ļ�
Local $cmd[1]=["del %temp%\winMTR*.txt"]
runBat($cmd)


;��ѹ���߳���tempĿ¼
FileInstall(".\tools\getmyip.exe",@TempDir&"\getmyip.exe",1)
FileInstall(".\tools\sendmail.exe",@TempDir&"\sendmail.exe",1)
FileInstall(".\tools\speedtest_cli_py.exe",@TempDir&"\speedtest_cli_py.exe",1)
FileInstall(".\tools\WinMTRCmd.exe",@TempDir&"\WinMTRCmd.exe",1)
FileInstall(".\tools\tcping.exe",@TempDir&"\tcping.exe",1)
FileInstall(".\tools\iperf3\cygwin1.dll",@TempDir&"\cygwin1.dll",1)
FileInstall(".\tools\iperf3\iperf3.exe",@TempDir&"\iperf3.exe",1)


If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then
	MsgBox(0,"","��ѹ���߲��ɹ�")
	Exit
EndIf

;~ ShellExecute("explorer",@TempDir)




;~ TrayTip("","��������winmtrcmd -c 10 122.198.64.133......",20)
;~ TraySetToolTip("������winmtrcmd -c 10 122.198.64.133.......����ر�")
;~ _RunDos("set path=%temp%;%path% && winmtrcmd -c 10  -r -f %temp%\winMTRresulttmp.txt  122.198.64.133")
;~ _FileWriteToLine(@TempDir & '\winMTRresulttmp.txt',1,"mtr��⣺" &@LF& "winmtrcmd -c 10 122.198.64.133");д������
;~ FileWriteLine(@TempDir & '\winMTRresulttmp.txt'," ") ;д�����
;~ FileWriteLine(@TempDir & '\winMTRresulttmp.txt',"===================================================================================================") ;
;~ FileWriteLine(@TempDir & '\winMTRresulttmp.txt'," ") ;д�����

;~ $hFileOpen=FileOpen(@TempDir & '\winMTRresulttmp.txt')
;~ Local $sFileRead = FileRead($hFileOpen)
;~ FileClose($hFileOpen)
;~ FileWriteLine(@TempDir & '\winMTRresult.txt',$sFileRead) ;д���ȡ������


;~ For $i=0 To 3 
;~ 	Local $ip_addr="122.198.64.13" & $i 
;~ 	Local $mycmd[1]= ["set path=%temp%;%path% && winmtrcmd -c 10  -r -f %temp%\winMTR"& $i &".txt "& $ip_addr]
;~ 	runBat($mycmd)
;~ Next





InputWindow()

$tmp_arr_addr=StringSplit($ChosenAddress,".")
If @error==1 Then
	MsgBox(0,"","��ַ��Ч")
	Exit
EndIf



MsgBox(0,"","������ʼ��·���ԣ�ִ�й������������",3)

If Int($tmp_arr_addr[1])<>0 Then 
	Global $ip_last=Int($tmp_arr_addr[4])
	$ip_head=$tmp_arr_addr[1]&"."&$tmp_arr_addr[2]&"."&$tmp_arr_addr[3]&"."
	Global $mtr_plustimes=0
	For $i=$ip_last To $ip_last+$mtr_plustimes
		Local $ip_addr=$ip_head & String($i) 
;~ 		MsgBox(0,"",$i)
		Local $mycmd[1]= ["set path=%temp%;%path% && winmtrcmd -c 20  -r -f %temp%\winMTR"& $i &".txt "& $ip_addr]
		runBat($mycmd)
	Next
	TrayTip("","��������winmtrcmd -c 10 "& $ChosenAddress &" ......",20)
	TraySetToolTip("������winmtrcmd -c 10 "&$ChosenAddress &".......����ر�")
;~ 	
;~ Else ;����ѡ��
	
EndIf




FileWriteLine(@TempDir & '\winMTRresult.txt',"��ǰ���繫��IP�����ڵأ�")
TrayTip("","���ڼ�������IP......",20)
TraySetState(1) ; ��ʾ���̲˵�.
TraySetToolTip("���ڼ�������IP......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
_RunDos("set path=%temp%;%path% && getmyip.exe")
FileWriteLine(@TempDir & '\winMTRresult.txt',"===================================================================================================") ;
FileWriteLine(@TempDir & '\winMTRresult.txt',"") ;д�����


FileWriteLine(@TempDir & '\winMTRresult.txt',"speedtest.com���٣�" &@LF) 
$times=0
While $times<10  ;����speedtest.com������
	TrayTip("","��������speedtest......",20)
	TraySetToolTip("��������speedtest......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
;~ 	_RunDos('set path=%temp%;%path% && speedtest32.exe --server 4672 | find "Ping" | wtee.exe -a %temp%\winMTRresulttmp.txt')
;~ 	_RunDos('set path=%temp%;%path% && speedtest_cli_py.exe --timeout 60 | find "Ping" > %temp%\winMTRresulttmp.txt')
;~ 	_RunDos('set path=%temp%;%path% && speedtest_cli_py.exe --server 5300 --timeout 80  > %temp%\winMTRresulttmp.txt')
	_RunDos('set path=%temp%;%path% && speedtest_cli_py.exe  --timeout 80  > %temp%\winMTRresulttmp.txt')
	$times +=1
	$size=FileGetSize(@TempDir & "\winMTRresulttmp.txt") 
	$file=FileOpen(@TempDir & "\winMTRresulttmp.txt")
	$fileread=FileRead($file)
	$noResult = Not StringInStr($fileread,"Upload:") 
	
	If $size==0 Or $noResult Then
		MsgBox(0,"","��ȡ����ٶ�ʧ�ܣ���������",2)
	Else
;~ 		MsgBox(0,"","OK")
;~ 		$file=FileOpen(@TempDir & "\winMTRresulttmp.txt")
;~ 		$fileread=FileRead($file)
;~ 		MsgBox(0,"",$fileread)
		FileWriteLine(@TempDir & '\winMTRresult.txt',$fileread)
		FileWriteLine(@TempDir & '\winMTRresult.txt',"������" & @LF & _
														"1.��ʾ��ǰIP�����ٵ㡢���ٵ���롢�����ٵ�ķ���ֵ�����ء��ϴ���" & @LF & _   
														"2.�����ֳ������۴�����ϵõ����ϴ�����ֵ���п������Ԥ����" & @LF & _
														"3.�����ֱ�ӳ��ڽ����в��ԣ��ų���������Ӱ�졣"&@LF ) 

		$times=10
	EndIf
			
WEnd
FileWriteLine(@TempDir & '\winMTRresult.txt',"===================================================================================================") ;д�����
FileWriteLine(@TempDir & '\winMTRresult.txt'," ") ;д�����


;����iperf3������
FileWriteLine(@TempDir & '\winMTRresult.txt',"iperf���٣�" &@LF)
TrayTip("","��������iperf3......",20)
TraySetToolTip("��������iperf3......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
_RunDos('echo Download:  >> %temp%\iperf3.txt')
_RunDos('echo iperf3.exe  -c 114.113.197.233 -R  >> %temp%\iperf3.txt')
_RunDos('set path=%temp%;%path% && iperf3.exe  -c 114.113.197.233 -R  --logfile %temp%\iperf3.txt')

_RunDos('echo  .  >> %temp%\iperf3.txt') ;����

_RunDos('echo Upload:  >> %temp%\iperf3.txt')
_RunDos('echo  iperf3.exe  -c 114.113.197.233  >> %temp%\iperf3.txt')
_RunDos('set path=%temp%;%path% && iperf3.exe  -c 114.113.197.233  --logfile %temp%\iperf3.txt')
FileWriteLine(@TempDir & '\iperf3.txt',"������"&@LF &	"��һ�ֲ��ٷ�ʽ�������ֳ������۴�����ϵõ����ϴ�����ֵ���п������Ԥ����"&@LF ) 



$filepath=@TempDir & "\iperf3.txt"
$file=FileOpen( $filepath)
$fileread=FileRead($file)
$new=StringAddCR($fileread)
FileClose($file)
FileDelete($filepath)
;~ _FileCreate($filepath)
;~ FileWriteLine($filepath,$new) ;д���ȡ������
FileWriteLine(@TempDir & '\winMTRresult.txt',$new) ;д���ȡ������
FileWriteLine(@TempDir & '\winMTRresult.txt',"===================================================================================================") ;д�����
FileWriteLine(@TempDir & '\winMTRresult.txt'," ") ;д�����




While 1 ;ѭ�����winMTR�Ƿ�ִ����ɣ������д�뵽��ʽ�Ľ���ĵ�����ɾ����ʱ�ĵ�
	Sleep(2000)
	Local $logic=True
	For $i=$ip_last To $ip_last+$mtr_plustimes ;
		$logic=BitAND(FileExists(@TempDir&"\winMTR"& $i &".txt "),$logic)
	Next
	
	If $logic Then
;~ 		MsgBox(0,"","true",1)
		
		If Not FileExists(@TempDir & '\winMTRresult.txt') Then FileWriteLine(@TempDir & '\winMTRresult.txt'," ") ;д�����
		For $i=$ip_last To $ip_last+$mtr_plustimes
			Local $ip_addr=$ip_head & String($i) 
			_FileWriteToLine(@TempDir & '\winMTR'& $i &'.txt',1,$now_choose_tool&"mtr��⣺" &@LF& "winmtrcmd -c 20 "&$ip_addr );д������
			FileWriteLine(@TempDir & '\winMTR'& $i &'.txt'," ") ;д�����
			FileWriteLine(@TempDir & '\winMTR'& $i &'.txt'," ") ;д�����
			
			If $i==$ip_last Then
				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',"������"&@LF )
				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',	"�鿴����ܵ����һ����һ�㶪����20%���£�Avg(ƽ������ֵ)30���£��ж�Ϊ����״�����á�"&@LF )
;~ 				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',	"2.�м�ڵ�Ķ����ʲ���Ϊ�ο���"&@LF )
;~ 				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',	"3.��⽫����4�ν��������4�εĽ�������жϡ�"&@LF ) ;д�����
			EndIf
			
			FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',"===================================================================================================") ;
			

			$hFileOpen=FileOpen(@TempDir & '\winMTR'& $i &'.txt')
			Local $sFileRead = FileRead($hFileOpen)
			_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$sFileRead) ;д���ȡ������
			FileClose($hFileOpen)
			FileDelete(@TempDir&"\winMTR"& $i &".txt ")
		Next
		
		
		ExitLoop ;�˳�whileѭ��
	Else
;~ 		MsgBox(0,"","false",1)
		ContinueLoop
	EndIf
WEnd



;~ MsgBox(0,"",$ChosenAddress)


_RunDos("set path=%temp%;%path% && tcping -n 10 " & $ChosenAddress  & "  " & $myports & ">> %temp%\tcpingRresult.txt")
FileWriteLine(@TempDir & '\tcpingRresult.txt',@LF & "����������10�������һ��������Ϊ����ʱ��ƽ����30ms���¡��޹��߷�ֵ�ж�Ϊ���á�" & @LF) ;
FileWriteLine(@TempDir & '\tcpingRresult.txt',"===================================================================================================") ;
$hFileOpen=FileOpen(@TempDir & '\tcpingRresult.txt')
Local $sFileRead = FileRead($hFileOpen)
_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$sFileRead) ;д���ȡ������
FileClose($hFileOpen)
_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,"==================================================================================================="&@LF & "tcping���ԣ�" )


;ʱ��
$starttime = "start time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
                 "  ��������IP:" & @IPAddress1  & @lf
				 
_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$starttime) ;д���ȡ
FileWriteLine(@TempDir & 'winMTRresult.txt'," ") ;д�����

;д�뱸ע
If FileExists(@ScriptDir&"\Info.txt") Then
	$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$sFileRead) ;д���ȡ������
	FileClose($hFileOpen)
	FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
EndIf


TrayTip("","��������ipconfig......",20)
TraySetToolTip("��������ipconfig......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
_RunDos("set path=%temp%;%path% && ipconfig /all >> %temp%\winMTRresult.txt")
FileWriteLine(@TempDir & '\winMTRresult.txt',@LF & "��������Ų鿴�������������Ƕ��������Ƿ������ڲ�ͬ�������豸�����е�һ�豸���ԡ�" & @LF) ;

TrayTip("","���ڷ����ʼ�......",20)
TraySetToolTip("���ڷ����ʼ�......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
_RunDos("set path=%temp%;%path% && sendmail.exe")


ShellExecute(@TempDir&"\winMTRresult.txt","open") ;���չʾ
;~ FileDelete(@TempDir&"\winMTRresult.txt")
FileDelete(@TempDir&"\WinMTRCmd.exe")
FileDelete(@TempDir&"\tcping.exe")
FileDelete(@TempDir&"\speedtest_cli_py.exe")
FileDelete(@TempDir&"\sendmail.exe")
FileDelete(@TempDir&"\getmyip.exe")
FileDelete(@TempDir&"\winMTRresulttmp.txt")
FileDelete(@TempDir&"\tcpingRresult.txt")
FileDelete(@TempDir&"\NetTestPro_ips.ini")
FileDelete(@TempDir&"\cygwin1.dll")
FileDelete(@TempDir&"\iperf3.exe")
FileDelete(@TempDir&"\iperf3.txt")


MsgBox(0,"","��·���������")


Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc
