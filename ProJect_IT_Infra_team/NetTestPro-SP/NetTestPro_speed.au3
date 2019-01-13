#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=.\NetTestPro-SP_Release\NetTestPro_speed.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <process.au3>
#include <Misc.au3>
#include <File.au3>
#include "Choose.au3"


If _Singleton("NetTestPro_speed",1) = 0 Then
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


	;���������½�����ȷ��ͬ��ʱû�н��̱�ռ��
	Local $list[3]= ["getmyip.exe","sendmail_speed.exe","speedtest_cli_py.exe"]
	For $item In $list
		While ProcessExists($item)
			ProcessClose($item)
		WEnd
	Next

	;ɾ���ɵļ�¼�ļ�
	Local $tempfiles[4]=["iperf3.txt","SpeedResulttmp.txt","NetTestPro_speed.txt","Info.txt"]
	For $i In  $tempfiles 
		If FileExists(@TempDir&"\"& $i) Then FileDelete(@TempDir&"\"& $i)
	Next
	


	;��ѹ���߳���tempĿ¼
	FileInstall(".\tools\getmyip.exe",@TempDir&"\getmyip.exe",1)
	FileInstall(".\tools\speedtest_cli_py.exe",@TempDir&"\speedtest_cli_py.exe",1)
;~ 	FileInstall(".\tools\iperf3\cygwin1.dll",@TempDir&"\cygwin1.dll",1)
;~ 	FileInstall(".\tools\iperf3\iperf3.exe",@TempDir&"\iperf3.exe",1)
	FileInstall(".\tools\sendmail_speed.exe",@TempDir&"\sendmail_speed.exe",1)


	
	MsgBox(0,"","������ʼ�ٶȲ��ԣ�ִ�й������������",3)
EndFunc


IPandLocation()
Func IPandLocation()

	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"��ǰ���繫��IP�����ڵأ�")
	TrayTip("","���ڼ�������IP......",20)
	TraySetState(1) ; ��ʾ���̲˵�.
	TraySetToolTip("���ڼ�������IP......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
	Local $getIP[1]=["set path=%temp%;%path% && getmyip.exe"]
	runBat($getIP)
;~ 	_RunDos("set path=%temp%;%path% && getmyip.exe")
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"===================================================================================================") ;
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"") ;д�����
EndFunc

SpeedTest()
Func SpeedTest()
	
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"speedtest.com���٣�" &@LF) 
	$times=0
	While $times<10  ;����speedtest.com������
		TrayTip("","��������speedtest......",20)
		TraySetToolTip("��������speedtest......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
	;~ 	_RunDos('set path=%temp%;%path% && speedtest32.exe --server 4672 | find "Ping" | wtee.exe -a %temp%\SpeedResulttmp.txt')
	;~ 	_RunDos('set path=%temp%;%path% && speedtest_cli_py.exe --timeout 60 | find "Ping" > %temp%\SpeedResulttmp.txt')
	;~ 	_RunDos('set path=%temp%;%path% && speedtest_cli_py.exe --server 5300 --timeout 80  > %temp%\SpeedResulttmp.txt')
		_RunDos('set path=%temp%;%path% && speedtest_cli_py.exe  --timeout 80  > %temp%\SpeedResulttmp.txt')
		$times +=1
		$size=FileGetSize(@TempDir & "\SpeedResulttmp.txt") 
		$file=FileOpen(@TempDir & "\SpeedResulttmp.txt")
		$fileread=FileRead($file)
		$noResult = Not StringInStr($fileread,"Upload:") 
		
		If $size==0 Or $noResult Then
			MsgBox(0,"","��ȡ����ٶ�ʧ�ܣ���������",2)
		Else

			FileWriteLine(@TempDir & '\NetTestPro_speed.txt',$fileread)
			FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"������" & @LF & _
															"1.��ʾ��ǰIP�����ٵ㡢���ٵ���롢�����ٵ�ķ���ֵ�����ء��ϴ���" & @LF & _   
															"2.�����ֳ������۴�����ϵõ����ϴ�����ֵ���п������Ԥ����" & @LF & _
															"3.�����ֱ�ӳ��ڽ����в��ԣ��ų���������Ӱ�졣"&@LF ) 

			$times=10
		EndIf
				
	WEnd
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"===================================================================================================") ;д�����
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt'," ") ;д�����


;~ 	Iperf()
EndFunc


Func Iperf()
	;����iperf3������
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"iperf���٣�" &@LF)
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
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',$new) ;д���ȡ������
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"===================================================================================================") ;д�����
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt'," ") ;д�����

EndFunc

Logs()
Func Logs()
	If Not FileExists(@TempDir & '\NetTestPro_speed.txt') Then FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"for test") 
	
	;����ʱ��
	$endtime = "end   time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  ��������IP:" & @IPAddress1  & @lf
					 
	_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,"===================================================================================================") ;д�����
	_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,$endtime) ;д���ȡ
	_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,$starttime) ;д���ȡ
;~ 	FileWriteLine(@TempDir & '\NetTestPro_speed.txt'," ") ;д�����

	;д�뱸ע
	If Not FileExists(@ScriptDir&"\Info.txt") Then
		FileWriteLine(@ScriptDir&"\Info.txt"," ") 
	ElseIf FileExists(@ScriptDir&"\Info.txt") Then
		$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
		Local $sFileRead = FileRead($hFileOpen)
		_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,$sFileRead) ;д���ȡ������
		FileClose($hFileOpen)
		FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
	EndIf
EndFunc

Ipconfig()
Func Ipconfig()
	TrayTip("","��������ipconfig......",20)
	TraySetToolTip("��������ipconfig......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
	_RunDos("set path=%temp%;%path% && ipconfig /all >> %temp%\NetTestPro_speed.txt")
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',@LF & "��������Ų鿴�������������Ƕ��������Ƿ������ڲ�ͬ�������豸�����е�һ�豸���ԡ�" & @LF) ;

	
EndFunc

sendmail()
Func sendmail()
	TrayTip("","���ڷ����ʼ�......",20)
	TraySetToolTip("���ڷ����ʼ�......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
	_RunDos("set path=%temp%;%path% && sendmail_speed.exe")
EndFunc


DeleteAll()
Func DeleteAll()
	
	

	$timemark = '-' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & '-' & @MIN & '-' & @SEC 
	Local $copytxt[1]=['copy %temp%\NetTestPro_speed.txt  "' & @ScriptDir&'\NetTestPro_speed'  & $timemark &  '.txt"' ]
	runBat($copytxt)
	ShellExecute(@ScriptDir&"\NetTestPro_speed"  & $timemark &  ".txt","open") ;���չʾ



	FileDelete(@TempDir&"\sendmail_speed.exe")
	FileDelete(@TempDir&"\getmyip.exe")
	FileDelete(@TempDir&"\speedtest_cli_py.exe")
	FileDelete(@TempDir&"\cygwin1.dll")
;~ 	FileDelete(@TempDir&"\iperf3.exe")
;~ 	FileDelete(@TempDir&"\iperf3.txt")
	FileDelete(@TempDir&"\SpeedResulttmp.txt")
	FileDelete(@TempDir&"\Info.txt")
	
	MsgBox(0,"","�ٶȲ��������")
EndFunc


Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc
