#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=.\NetTestPro-SP_Release\NetTestPro_battlenet.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <process.au3>
#include <Misc.au3>
#include <File.au3>

If _Singleton("NetTestPro_battlenet",1) = 0 Then
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
	
	Global $Addrs[0] ;地址参数，由文本读入
	Global $ports[0] ;端口参数，由文本读入
	Global $names[0] ;游戏名称，由文本读入
	Global $addr_file = @ScriptDir & "\battlenet.ini"
	getAvailableParameter($addr_file)
	
;~ 	_ArrayDisplay($Addrs)
;~ 	_ArrayDisplay($ports)
;~ 	_ArrayDisplay($names)

#CS
	Global $Addrs[8]=["122.198.64.131","114.113.217.71", _ ;"Agent1","Agent2"
					  "122.198.64.138","122.198.64.133","223.252.224.243", _  ; "魔兽世界","风暴英雄4","暗黑破坏神Ⅲ"
					  "223.252.251.86","122.198.66.132","114.113.218.136" ] ;   "守望先锋","星际争霸Ⅱ","炉石传说"
					  
	Global $ports[8]=["1119","1119", _
					  "1119","1119","3724", _
					  "3724","1119","1119" ]
					  
	Global $names[8]=["Agent1","Agent2", _
					  "魔兽世界","风暴英雄","暗黑破坏神Ⅲ", _
					  "守望先锋","星际争霸Ⅱ","炉石传说"]
#CE

	Global $check[8]=[False,False,False,False,False,False,False,False]
	Global $lenth= UBound($Addrs)

	Global $MTRtimes=20;次数
	Global $TCPingtimes=20 ;次数

	;删除旧的记录文件
	For $i In  $Addrs 
		If FileExists(@TempDir&"\mtr_"& $i &".txt ") Then FileDelete(@TempDir&"\mtr_"& $i &".txt ")
		If FileExists(@TempDir&"\tcping_"& $i &".txt ") Then FileDelete(@TempDir&"\tcping_"& $i &".txt ")
	Next

	;删除旧的记录文件
	FileDelete(@TempDir & '\NetTestPro_battlenet.txt')
	
	;解压工具程序到temp目录
	If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then  FileInstall(".\tools\WinMTRCmd.exe",@TempDir&"\WinMTRCmd.exe" ,1)
	If Not FileExists(@TempDir&"\tcping.exe") Then  FileInstall(".\tools\tcping.exe",@TempDir&"\tcping.exe" ,1)
	If Not FileExists(@TempDir&"\sendmail_battlenet.exe") Then  FileInstall(".\tools\sendmail_battlenet.exe",@TempDir&"\sendmail_battlenet.exe" ,1)

			
	If Not FileExists(@TempDir&"\WinMTRCmd.exe") Then
		MsgBox(0,"","解压工具不成功")
		Exit
	EndIf
	
	MsgBox(0,"","即将开始战网游戏客户端网路测试，执行过程中无需操作",3)
	
	TrayTip("","正在运行战网游戏客户端网路测试  ......请勿关闭",20)
	TraySetToolTip("在运行战网游戏客户端网路测试 .......请勿关闭")
	If Not FileExists(@TempDir & '\NetTestPro_battlenet.txt') Then FileWriteLine(@TempDir & '\NetTestPro_battlenet.txt'," ") ;写入空行
	
	
EndFunc


Func getAvailableParameter($filename)
	
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. "  & @LF & "battlenet.ini不存在") ; 读取当前脚本文件时发生错误.
		Exit
	Else
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			Local $centence=StringStripWS($aArray[$i],3)
			Local $RegExp = StringRegExpReplace($centence,"\s+","|") ;将所有空格、TAB符号转换成|
 			Local $thisArray = StringSplit($RegExp,"|",1) ;以|为分隔符将元素数组化
;~ 			_ArrayDisplay($thisArray)
			_ArrayAdd($Addrs,$thisArray[1])
			_ArrayAdd($ports,$thisArray[2])
			_ArrayAdd($names,$thisArray[3])

		Next
	EndIf
	
EndFunc



For $i=0 To  $lenth-1 ;执行检测
	MTR($Addrs[$i],$ports[$i],$names[$i])
	TcpingTest($Addrs[$i],$ports[$i],$names[$i])
Next

Func MTR($ChosenAddress,$myports,$now_choose_tool)  ;20
	
;~ 	TrayTip("","正在运行winmtrcmd -c 20 "& $ChosenAddress &" ......",20)
;~ 	TraySetToolTip("在运行winmtrcmd -c 20 "&$ChosenAddress &".......请勿关闭")
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
 	_FileWriteToLine(@TempDir & '\mtr_' & $ChosenAddress  &'.txt',1,$now_choose_tool&"  mtr检测：" &@LF& "winmtrcmd -c 20 " & $ChosenAddress );写入首行
	FileWriteLine(@TempDir & '\mtr_' &  $ChosenAddress  &'.txt'," ") ;写入空行
	FileWriteLine(@TempDir & '\mtr_' &  $ChosenAddress  &'.txt'," ") ;写入空行
	
	FileWriteLine(@TempDir & '\mtr_' &  $ChosenAddress  &'.txt',"分析："&@LF )
	FileWriteLine(@TempDir & '\mtr_' &   $ChosenAddress  &'.txt',	"查看最后能到达的一跳，一般丢包率20%以下，Avg(平均返回值)30以下，判定为网络状况良好。"&@LF )

	FileWriteLine(@TempDir & '\mtr_' &   $ChosenAddress  &'.txt',"===================================================================================================") ;
	$hFileOpen=FileOpen(@TempDir & '\mtr_' &   $ChosenAddress  &'.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$sFileRead) ;写入读取的内容
	FileClose($hFileOpen)
	FileDelete(@TempDir&'\mtr_' &   $ChosenAddress  &'.txt ')
EndFunc


Func write_tcping_result($ChosenAddress,$now_choose_tool)
 	FileWriteLine(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt',@LF & "分析：返回20个结果。一般我们认为返回时间平均在30ms以下、无过高峰值判定为良好。" & @LF) ;
	FileWriteLine(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt',"===================================================================================================") ;
	$hFileOpen=FileOpen(@TempDir & '\tcping_'&   $ChosenAddress  &'.txt')
	Local $sFileRead = FileRead($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$sFileRead) ;写入读取的内容
	FileClose($hFileOpen)
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,"===================================================================================================" )
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',2,$now_choose_tool & "  tcping测试：" )
	
	FileDelete(@TempDir & '\tcping_' & $ChosenAddress  & '.txt')
EndFunc

Logs()
Func Logs()
	If Not FileExists(@TempDir & '\NetTestPro_battlenet.txt') Then FileWriteLine(@TempDir & '\NetTestPro_battlenet.txt',"for test") 
		
	;结束时间
	$endtime = "end   time   " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC & _
					 "  本机内网IP:" & @IPAddress1  & @lf
					 
	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$endtime) ;写入读取
	FileWriteLine(@TempDir & 'NetTestPro_battlenet.txt'," ") ;写入空行

	_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$starttime) ;写入读取
	FileWriteLine(@TempDir & 'NetTestPro_battlenet.txt'," ") ;写入空行

	;写入备注
	If Not FileExists(@ScriptDir&"\Info.txt") Then
		FileWriteLine(@ScriptDir&"\Info.txt"," ") 
	ElseIf FileExists(@ScriptDir&"\Info.txt") Then
		$hFileOpen=FileOpen(@ScriptDir & '\Info.txt')
		Local $sFileRead = FileRead($hFileOpen)
		_FileWriteToLine(@TempDir & '\NetTestPro_battlenet.txt',1,$sFileRead) ;写入读取的内容
		FileClose($hFileOpen)
		
		FileCopy(@ScriptDir & '\Info.txt',@TempDir & '\Info.txt',1+8)
	EndIf
EndFunc

sendmail()
Func sendmail()
	TrayTip("","正在发送邮件......",20)
	TraySetToolTip("正在发送邮件......请勿关闭") ; 须必在托盘菜单图标显示之前设置一些文字.
	_RunDos("set path=%temp%;%path% && sendmail_battlenet.exe")
EndFunc

DeleteAll()
Func DeleteAll()
	
	$timemark = '-' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & '-' & @MIN & '-' & @SEC 
	_RunDos('copy %temp%\NetTestPro_battlenet.txt  "' & @ScriptDir&'\NetTestPro_battlenet'  & $timemark &  '.txt"' )

	ShellExecute(@ScriptDir&"\NetTestPro_battlenet"  & $timemark &  ".txt","open") ;结果展示
	
	FileDelete(@TempDir&"\WinMTRCmd.exe")
	FileDelete(@TempDir&"\tcping.exe")
	FileDelete(@TempDir&"\sendmail_battlenet.exe")


	MsgBox(0,"","战网游戏客户端网路测试已完成")
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
