#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=.\NetTestPro-SP_Release\NetTestPro_TV.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

#include <process.au3>
#include <Misc.au3>
#include <File.au3>

If _Singleton("NetTestPro_TV",1) = 0 Then
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

	;~ MTR("send3a.douyu.com","80","����")  ;
	;~ MTR("ps8.live.panda.tv","80","��è")  ;
	;~ MTR("dlrtmpup.cdn.zhanqi.tv","80","ս��")  ;
	;~ MTR("push.v.cc.163.com","80","CC")  ;
	;~ MTR("up.quanmin.tv","80","ȫ��")  ;
	;~ MTR("rtmp.huya.com","80","����")  ;
	;~ MTR("fengyunzhibo.com","80","����")  ;
	Global $Addrs[7]=["send1.douyu.com","ps8.live.panda.tv","yfrtmpup.cdn.zhanqi.tv","push.v.cc.163.com","up.quanmin.tv","rtmp.huya.com","fengyunzhibo.com"]
	Global $ports[7]=["80","80","80","80","80","80","80"]
	Global $names[7]=["����","��è","ս��","CC","ȫ��","����","����"]
	Global $check[7]=[False,False,False,False,False,False,False]
	Global $lenth= UBound($Addrs)
	Global $MTRtimes=20;����
	Global $TCPingtimes=20 ;����
	
	;ɾ���ɵļ�¼�ļ�
	For $i In  $Addrs 
		If FileExists(@TempDir&"\mtr_"& $i &".txt ") Then FileDelete(@TempDir&"\mtr_"& $i &".txt ")
		If FileExists(@TempDir&"\tcping_"& $i &".txt ") Then FileDelete(@TempDir&"\tcping_"& $i &".txt ")
	Next

	;ɾ���ɵļ�¼�ļ�
	FileDelete(@TempDir & '\NetTestPro_TV.txt')
	
	
	;��ѹ���߳���tempĿ¼
	If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then  FileInstall(".\tools\WinMTRCmd.exe",@TempDir&"\WinMTRCmd.exe" ,1)
	If Not FileExists(@TempDir&"\tcping.exe") Then  FileInstall(".\tools\tcping.exe",@TempDir&"\tcping.exe" ,1)
	If Not FileExists(@TempDir&"\sendmail_TV.exe") Then  FileInstall(".\tools\sendmail_TV.exe",@TempDir&"\sendmail_TV.exe" ,1)
	


	If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then
		MsgBox(0,"","��ѹ���߲��ɹ�")
		Exit
	EndIf
	
	MsgBox(0,"","������ʼֱ��ƽ̨��·���ԣ�ִ�й������������",3)
	
	TrayTip("","��������ֱ��ƽ̨��·����  ......����ر�",20)
	TraySetToolTip("������ֱ��ƽ̨��·����.......����ر�")
	If Not FileExists(@TempDir & '\NetTestPro_TV.txt') Then FileWriteLine(@TempDir & '\NetTestPro_TV.txt'," ") ;д�����
	
EndFunc

For $i=0 To   $lenth-1 ;ִ�м��
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
;~ 		MsgBox(0,"",$i& @LF & $checkResult & @LF &  $check[$i],1 )
		If $check[$i]==True Then ContinueLoop
		
		If FileExists(@TempDir&"\mtr_"& $Addrs[$i] &".txt ") And FileExists(@TempDir&"\tcping_"& $Addrs[$i] &".txt ")  Then
			write_mtr_result($Addrs[$i],$names[$i])
			write_tcping_result($Addrs[$i],$names[$i])
			$check[$i]=True
		EndIf
	Next
	If Not $checkResult Then
		Sleep(500)
;~ 		MsgBox(0,"",$checkResult)
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
	_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',1,$sFileRead) ;д���ȡ������
	FileClose($hFileOpen)
	FileDelete(@TempDir&'\mtr_' &   $ChosenAddress  &'.txt ')
EndFunc

Func write_tcping_result($ChosenAddress,$now_choose_tool)
 	FileWriteLine(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt',@LF & "����������20�������һ��������Ϊ����ʱ��ƽ����30ms���¡��޹��߷�ֵ�ж�Ϊ���á�" & @LF) ;
	FileWriteLine(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt',"===================================================================================================") ;
	$hFileOpen=FileOpen(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',1,$sFileRead) ;д���ȡ������
	FileClose($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',1,"===================================================================================================" )
	_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',2,$now_choose_tool & "  tcping���ԣ�" )
	
	FileDelete(@TempDir & '\tcping_' & $ChosenAddress  & '.txt')
EndFunc



Logs()
Func Logs()
	
;~ 	MsgBox(0,"","log")
;~     Exit
	
	If Not FileExists(@TempDir & '\NetTestPro_TV.txt') Then FileWriteLine(@TempDir & '\NetTestPro_TV.txt',"for test") 
	
	;����ʱ��
	$endtime = "end   time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  ��������IP:" & @IPAddress1  & @lf
					 

	_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',1,$endtime) ;д���ȡ
	FileWriteLine(@TempDir & 'NetTestPro_TV.txt'," ") ;д�����

	_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',1,$starttime) ;д���ȡ
	FileWriteLine(@TempDir & 'NetTestPro_TV.txt'," ") ;д�����

	;д�뱸ע
	If Not FileExists(@ScriptDir&"\Info.txt") Then
		FileWriteLine(@ScriptDir&"\Info.txt"," ") 
	ElseIf FileExists(@ScriptDir&"\Info.txt") Then
		$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
		Local $sFileRead = FileRead($hFileOpen)
		_FileWriteToLine(@TempDir & '\NetTestPro_TV.txt',1,$sFileRead) ;д���ȡ������
		FileClose($hFileOpen)
		FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
	EndIf
EndFunc

sendmail()
Func sendmail()
	TrayTip("","���ڷ����ʼ�......",20)
	TraySetToolTip("���ڷ����ʼ�......����ر�") ; ��������̲˵�ͼ����ʾ֮ǰ����һЩ����.
	_RunDos("set path=%temp%;%path% && sendmail_TV.exe")
;~ 	MsgBox(0,"","�ʼ��ѷ���")
EndFunc


DeleteAll()
Func DeleteAll()
	
;~ 	ShellExecute(@TempDir&"\NetTestPro_TV.txt","open") ;���չʾ
;~ 	If FileExists(@ScriptDir&"\NetTestPro_TV.txt") Then
	$timemark = '-' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & '-' & @MIN & '-' & @SEC 
;~ 	Local $copytxt[1]=['copy %temp%\NetTestPro_TV.txt  "' & @ScriptDir&'\NetTestPro_TV'  & $timemark &  '.txt"' ]
;~ 	runBatWait($copytxt
	_RunDos('copy %temp%\NetTestPro_TV.txt  "' & @ScriptDir&'\NetTestPro_TV'  & $timemark &  '.txt"' )

	ShellExecute(@ScriptDir&"\NetTestPro_TV"  & $timemark &  ".txt","open") ;���չʾ

;~ 	EndIf
	

	FileDelete(@TempDir&"\WinMTRCmd.exe")
	FileDelete(@TempDir&"\tcping.exe")
	FileDelete(@TempDir&"\sendmail_TV.exe")


	MsgBox(0,"","ֱ��ƽ̨��·���������")
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
