#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=.\NetTestPro-SP_Release\NetTestPro_speed.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
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
	;起始时间
	Global $starttime = "start time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  本机内网IP:" & @IPAddress1  & @lf


	If Ping("www.163.com")==0 Then
		MsgBox(0,"","当前计算机无法与互联网通讯，请检查链接或防火墙状态")
		Exit
	EndIf


	;结束掉以下进程以确保同步时没有进程被占用
	Local $list[3]= ["getmyip.exe","sendmail_speed.exe","speedtest_cli_py.exe"]
	For $item In $list
		While ProcessExists($item)
			ProcessClose($item)
		WEnd
	Next

	;删除旧的记录文件
	Local $tempfiles[4]=["iperf3.txt","SpeedResulttmp.txt","NetTestPro_speed.txt","Info.txt"]
	For $i In  $tempfiles 
		If FileExists(@TempDir&"\"& $i) Then FileDelete(@TempDir&"\"& $i)
	Next
	


	;解压工具程序到temp目录
	FileInstall(".\tools\getmyip.exe",@TempDir&"\getmyip.exe",1)
	FileInstall(".\tools\speedtest_cli_py.exe",@TempDir&"\speedtest_cli_py.exe",1)
;~ 	FileInstall(".\tools\iperf3\cygwin1.dll",@TempDir&"\cygwin1.dll",1)
;~ 	FileInstall(".\tools\iperf3\iperf3.exe",@TempDir&"\iperf3.exe",1)
	FileInstall(".\tools\sendmail_speed.exe",@TempDir&"\sendmail_speed.exe",1)


	
	MsgBox(0,"","即将开始速度测试，执行过程中无需操作",3)
EndFunc


IPandLocation()
Func IPandLocation()

	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"当前网络公网IP和所在地：")
	TrayTip("","正在检测地区和IP......",20)
	TraySetState(1) ; 显示托盘菜单.
	TraySetToolTip("正在检测地区和IP......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
	Local $getIP[1]=["set path=%temp%;%path% && getmyip.exe"]
	runBat($getIP)
;~ 	_RunDos("set path=%temp%;%path% && getmyip.exe")
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"===================================================================================================") ;
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"") ;写入空行
EndFunc

SpeedTest()
Func SpeedTest()
	
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"speedtest.com测速：" &@LF) 
	$times=0
	While $times<10  ;调用speedtest.com来测速
		TrayTip("","正在运行speedtest......",20)
		TraySetToolTip("正在运行speedtest......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
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
			MsgBox(0,"","获取最大速度失败，正在重试",2)
		Else

			FileWriteLine(@TempDir & '\NetTestPro_speed.txt',$fileread)
			FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"分析：" & @LF & _
															"1.显示当前IP、测速点、测速点距离、到测速点的返回值、下载、上传。" & @LF & _   
															"2.根据现场的理论带宽，结合得到的上传下载值进行宽带质量预估。" & @LF & _
															"3.最好在直接出口结点进行测试，排除其他因素影响。"&@LF ) 

			$times=10
		EndIf
				
	WEnd
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"===================================================================================================") ;写入空行
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt'," ") ;写入空行


;~ 	Iperf()
EndFunc


Func Iperf()
	;调用iperf3来测速
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"iperf测速：" &@LF)
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
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',$new) ;写入读取的内容
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"===================================================================================================") ;写入空行
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt'," ") ;写入空行

EndFunc

Logs()
Func Logs()
	If Not FileExists(@TempDir & '\NetTestPro_speed.txt') Then FileWriteLine(@TempDir & '\NetTestPro_speed.txt',"for test") 
	
	;结束时间
	$endtime = "end   time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  本机内网IP:" & @IPAddress1  & @lf
					 
	_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,"===================================================================================================") ;写入空行
	_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,$endtime) ;写入读取
	_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,$starttime) ;写入读取
;~ 	FileWriteLine(@TempDir & '\NetTestPro_speed.txt'," ") ;写入空行

	;写入备注
	If Not FileExists(@ScriptDir&"\Info.txt") Then
		FileWriteLine(@ScriptDir&"\Info.txt"," ") 
	ElseIf FileExists(@ScriptDir&"\Info.txt") Then
		$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
		Local $sFileRead = FileRead($hFileOpen)
		_FileWriteToLine(@TempDir & '\NetTestPro_speed.txt',1,$sFileRead) ;写入读取的内容
		FileClose($hFileOpen)
		FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
	EndIf
EndFunc

Ipconfig()
Func Ipconfig()
	TrayTip("","正在运行ipconfig......",20)
	TraySetToolTip("正在运行ipconfig......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
	_RunDos("set path=%temp%;%path% && ipconfig /all >> %temp%\NetTestPro_speed.txt")
	FileWriteLine(@TempDir & '\NetTestPro_speed.txt',@LF & "分析：大概查看网卡情况，如果是多网卡，是否受限于不同的网络设备，进行单一设备测试。" & @LF) ;

	
EndFunc

sendmail()
Func sendmail()
	TrayTip("","正在发送邮件......",20)
	TraySetToolTip("正在发送邮件......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
	_RunDos("set path=%temp%;%path% && sendmail_speed.exe")
EndFunc


DeleteAll()
Func DeleteAll()
	
	

	$timemark = '-' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & '-' & @MIN & '-' & @SEC 
	Local $copytxt[1]=['copy %temp%\NetTestPro_speed.txt  "' & @ScriptDir&'\NetTestPro_speed'  & $timemark &  '.txt"' ]
	runBat($copytxt)
	ShellExecute(@ScriptDir&"\NetTestPro_speed"  & $timemark &  ".txt","open") ;结果展示



	FileDelete(@TempDir&"\sendmail_speed.exe")
	FileDelete(@TempDir&"\getmyip.exe")
	FileDelete(@TempDir&"\speedtest_cli_py.exe")
	FileDelete(@TempDir&"\cygwin1.dll")
;~ 	FileDelete(@TempDir&"\iperf3.exe")
;~ 	FileDelete(@TempDir&"\iperf3.txt")
	FileDelete(@TempDir&"\SpeedResulttmp.txt")
	FileDelete(@TempDir&"\Info.txt")
	
	MsgBox(0,"","速度测试已完成")
EndFunc


Func runBat($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc
