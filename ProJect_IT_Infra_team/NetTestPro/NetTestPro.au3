#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=G:\D.网络相关\3.网络相关诊断工具\NetTestPro\NetTestPro.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****


#include <process.au3>
#include <Misc.au3>
#include <File.au3>
#include "Choose.au3"

If _Singleton("NetTestPro",1) = 0 Then
		MsgBox(0,"","Test already running");Prevent repeated opening of the program
		Exit
EndIf



If Ping("www.163.com")==0 Then
	MsgBox(0,"","当前计算机无法与互联网通讯，请检查链接或防火墙状态")
	Exit
EndIf


;结束掉以下进程以确保同步时没有进程被占用
Local $list[4]= ["getmyip.exe","sendmail.exe","speedtest_cli_py.exe","WinMTRCmd.exe"]
For $item In $list
	While ProcessExists($item)
		ProcessClose($item)
	WEnd
Next

;删除旧的记录文件
Local $cmd[1]=["del %temp%\winMTR*.txt"]
runBat($cmd)


;解压工具程序到temp目录
FileInstall(".\tools\getmyip.exe",@TempDir&"\getmyip.exe",1)
FileInstall(".\tools\sendmail.exe",@TempDir&"\sendmail.exe",1)
FileInstall(".\tools\speedtest_cli_py.exe",@TempDir&"\speedtest_cli_py.exe",1)
FileInstall(".\tools\WinMTRCmd.exe",@TempDir&"\WinMTRCmd.exe",1)
FileInstall(".\tools\tcping.exe",@TempDir&"\tcping.exe",1)
FileInstall(".\tools\iperf3\cygwin1.dll",@TempDir&"\cygwin1.dll",1)
FileInstall(".\tools\iperf3\iperf3.exe",@TempDir&"\iperf3.exe",1)


If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then
	MsgBox(0,"","解压工具不成功")
	Exit
EndIf

;~ ShellExecute("explorer",@TempDir)




;~ TrayTip("","正在运行winmtrcmd -c 10 122.198.64.133......",20)
;~ TraySetToolTip("在运行winmtrcmd -c 10 122.198.64.133.......请勿关闭")
;~ _RunDos("set path=%temp%;%path% && winmtrcmd -c 10  -r -f %temp%\winMTRresulttmp.txt  122.198.64.133")
;~ _FileWriteToLine(@TempDir & '\winMTRresulttmp.txt',1,"mtr检测：" &@LF& "winmtrcmd -c 10 122.198.64.133");写入首行
;~ FileWriteLine(@TempDir & '\winMTRresulttmp.txt'," ") ;写入空行
;~ FileWriteLine(@TempDir & '\winMTRresulttmp.txt',"===================================================================================================") ;
;~ FileWriteLine(@TempDir & '\winMTRresulttmp.txt'," ") ;写入空行

;~ $hFileOpen=FileOpen(@TempDir & '\winMTRresulttmp.txt')
;~ Local $sFileRead = FileRead($hFileOpen)
;~ FileClose($hFileOpen)
;~ FileWriteLine(@TempDir & '\winMTRresult.txt',$sFileRead) ;写入读取的内容


;~ For $i=0 To 3 
;~ 	Local $ip_addr="122.198.64.13" & $i 
;~ 	Local $mycmd[1]= ["set path=%temp%;%path% && winmtrcmd -c 10  -r -f %temp%\winMTR"& $i &".txt "& $ip_addr]
;~ 	runBat($mycmd)
;~ Next





InputWindow()

$tmp_arr_addr=StringSplit($ChosenAddress,".")
If @error==1 Then
	MsgBox(0,"","地址无效")
	Exit
EndIf



MsgBox(0,"","即将开始网路测试，执行过程中无需操作",3)

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
	TrayTip("","正在运行winmtrcmd -c 10 "& $ChosenAddress &" ......",20)
	TraySetToolTip("在运行winmtrcmd -c 10 "&$ChosenAddress &".......请勿关闭")
;~ 	
;~ Else ;官网选项
	
EndIf




FileWriteLine(@TempDir & '\winMTRresult.txt',"当前网络公网IP和所在地：")
TrayTip("","正在检测地区和IP......",20)
TraySetState(1) ; 显示托盘菜单.
TraySetToolTip("正在检测地区和IP......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
_RunDos("set path=%temp%;%path% && getmyip.exe")
FileWriteLine(@TempDir & '\winMTRresult.txt',"===================================================================================================") ;
FileWriteLine(@TempDir & '\winMTRresult.txt',"") ;写入空行


FileWriteLine(@TempDir & '\winMTRresult.txt',"speedtest.com测速：" &@LF) 
$times=0
While $times<10  ;调用speedtest.com来测速
	TrayTip("","正在运行speedtest......",20)
	TraySetToolTip("正在运行speedtest......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
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
		MsgBox(0,"","获取最大速度失败，正在重试",2)
	Else
;~ 		MsgBox(0,"","OK")
;~ 		$file=FileOpen(@TempDir & "\winMTRresulttmp.txt")
;~ 		$fileread=FileRead($file)
;~ 		MsgBox(0,"",$fileread)
		FileWriteLine(@TempDir & '\winMTRresult.txt',$fileread)
		FileWriteLine(@TempDir & '\winMTRresult.txt',"分析：" & @LF & _
														"1.显示当前IP、测速点、测速点距离、到测速点的返回值、下载、上传。" & @LF & _   
														"2.根据现场的理论带宽，结合得到的上传下载值进行宽带质量预估。" & @LF & _
														"3.最好在直接出口结点进行测试，排除其他因素影响。"&@LF ) 

		$times=10
	EndIf
			
WEnd
FileWriteLine(@TempDir & '\winMTRresult.txt',"===================================================================================================") ;写入空行
FileWriteLine(@TempDir & '\winMTRresult.txt'," ") ;写入空行


;调用iperf3来测速
FileWriteLine(@TempDir & '\winMTRresult.txt',"iperf测速：" &@LF)
TrayTip("","正在运行iperf3......",20)
TraySetToolTip("正在运行iperf3......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
_RunDos('echo Download:  >> %temp%\iperf3.txt')
_RunDos('echo iperf3.exe  -c 114.113.197.233 -R  >> %temp%\iperf3.txt')
_RunDos('set path=%temp%;%path% && iperf3.exe  -c 114.113.197.233 -R  --logfile %temp%\iperf3.txt')

_RunDos('echo  .  >> %temp%\iperf3.txt') ;空行

_RunDos('echo Upload:  >> %temp%\iperf3.txt')
_RunDos('echo  iperf3.exe  -c 114.113.197.233  >> %temp%\iperf3.txt')
_RunDos('set path=%temp%;%path% && iperf3.exe  -c 114.113.197.233  --logfile %temp%\iperf3.txt')
FileWriteLine(@TempDir & '\iperf3.txt',"分析："&@LF &	"另一种测速方式，根据现场的理论带宽，结合得到的上传下载值进行宽带质量预估。"&@LF ) 



$filepath=@TempDir & "\iperf3.txt"
$file=FileOpen( $filepath)
$fileread=FileRead($file)
$new=StringAddCR($fileread)
FileClose($file)
FileDelete($filepath)
;~ _FileCreate($filepath)
;~ FileWriteLine($filepath,$new) ;写入读取的内容
FileWriteLine(@TempDir & '\winMTRresult.txt',$new) ;写入读取的内容
FileWriteLine(@TempDir & '\winMTRresult.txt',"===================================================================================================") ;写入空行
FileWriteLine(@TempDir & '\winMTRresult.txt'," ") ;写入空行




While 1 ;循环检测winMTR是否执行完成，完成则写入到正式的结果文档，并删除临时文档
	Sleep(2000)
	Local $logic=True
	For $i=$ip_last To $ip_last+$mtr_plustimes ;
		$logic=BitAND(FileExists(@TempDir&"\winMTR"& $i &".txt "),$logic)
	Next
	
	If $logic Then
;~ 		MsgBox(0,"","true",1)
		
		If Not FileExists(@TempDir & '\winMTRresult.txt') Then FileWriteLine(@TempDir & '\winMTRresult.txt'," ") ;写入空行
		For $i=$ip_last To $ip_last+$mtr_plustimes
			Local $ip_addr=$ip_head & String($i) 
			_FileWriteToLine(@TempDir & '\winMTR'& $i &'.txt',1,$now_choose_tool&"mtr检测：" &@LF& "winmtrcmd -c 20 "&$ip_addr );写入首行
			FileWriteLine(@TempDir & '\winMTR'& $i &'.txt'," ") ;写入空行
			FileWriteLine(@TempDir & '\winMTR'& $i &'.txt'," ") ;写入空行
			
			If $i==$ip_last Then
				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',"分析："&@LF )
				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',	"查看最后能到达的一跳，一般丢包率20%以下，Avg(平均返回值)30以下，判定为网络状况良好。"&@LF )
;~ 				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',	"2.中间节点的丢包率不做为参考。"&@LF )
;~ 				FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',	"3.检测将产生4次结果，根据4次的结果酌情判断。"&@LF ) ;写入空行
			EndIf
			
			FileWriteLine(@TempDir & '\winMTR'& $i &'.txt',"===================================================================================================") ;
			

			$hFileOpen=FileOpen(@TempDir & '\winMTR'& $i &'.txt')
			Local $sFileRead = FileRead($hFileOpen)
			_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$sFileRead) ;写入读取的内容
			FileClose($hFileOpen)
			FileDelete(@TempDir&"\winMTR"& $i &".txt ")
		Next
		
		
		ExitLoop ;退出while循环
	Else
;~ 		MsgBox(0,"","false",1)
		ContinueLoop
	EndIf
WEnd



;~ MsgBox(0,"",$ChosenAddress)


_RunDos("set path=%temp%;%path% && tcping -n 10 " & $ChosenAddress  & "  " & $myports & ">> %temp%\tcpingRresult.txt")
FileWriteLine(@TempDir & '\tcpingRresult.txt',@LF & "分析：返回10个结果。一般我们认为返回时间平均在30ms以下、无过高峰值判定为良好。" & @LF) ;
FileWriteLine(@TempDir & '\tcpingRresult.txt',"===================================================================================================") ;
$hFileOpen=FileOpen(@TempDir & '\tcpingRresult.txt')
Local $sFileRead = FileRead($hFileOpen)
_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$sFileRead) ;写入读取的内容
FileClose($hFileOpen)
_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,"==================================================================================================="&@LF & "tcping测试：" )


;时间
$starttime = "start time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
                 "  本机内网IP:" & @IPAddress1  & @lf
				 
_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$starttime) ;写入读取
FileWriteLine(@TempDir & 'winMTRresult.txt'," ") ;写入空行

;写入备注
If FileExists(@ScriptDir&"\Info.txt") Then
	$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\winMTRresult.txt',1,$sFileRead) ;写入读取的内容
	FileClose($hFileOpen)
	FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
EndIf


TrayTip("","正在运行ipconfig......",20)
TraySetToolTip("正在运行ipconfig......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
_RunDos("set path=%temp%;%path% && ipconfig /all >> %temp%\winMTRresult.txt")
FileWriteLine(@TempDir & '\winMTRresult.txt',@LF & "分析：大概查看网卡情况，如果是多网卡，是否受限于不同的网络设备，进行单一设备测试。" & @LF) ;

TrayTip("","正在发送邮件......",20)
TraySetToolTip("正在发送邮件......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
_RunDos("set path=%temp%;%path% && sendmail.exe")


ShellExecute(@TempDir&"\winMTRresult.txt","open") ;结果展示
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


MsgBox(0,"","网路测试已完成")


Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc
