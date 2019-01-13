#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Release\cmds_tcping_games_x64.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <File.au3>


$timenow = @YEAR & '' & @MON & '' & @MDAY & '-' & @HOUR & '' & @MIN & '' & @SEC &  "-"

If Not FileExists(@ScriptDir &"\wtee.exe") Then FileInstall(".\wtee.exe",@ScriptDir &"\wtee.exe")
If Not FileExists(@ScriptDir &"\tcping.exe") Then FileInstall(".\tcping.exe",@ScriptDir &"\tcping.exe")
If Not FileExists(@ScriptDir &"\games") Then DirCreate(@ScriptDir &"\games")

$Width=@DesktopWidth 
$Height=@DesktopHeight 
$cmd_W=$Width/3
$cmd_H=$Height/2



While ProcessExists("tcping.exe") ;Or ProcessExists("cmd.exe")
	ProcessClose("tcping.exe")
;~ 	ProcessClose("cmd.exe")
WEnd


Local $pingtimes=1000

Global $Addrs[0] ;地址参数，由文本读入
Global $ports[0] ;端口参数，由文本读入
Global $names[0] ;游戏名称，由文本读入
Global $addr_file = @ScriptDir & "\conf_battlenet.ini"
getAvailableParameter($addr_file)


Func getAvailableParameter($filename)
	
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. "  & @LF & "conf_battlenet不存在") ; 读取当前脚本文件时发生错误.
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


$cmd1=Run(@ComSpec & " /k " & " title " & $names[0] & " && tcping " &  " -n " & $pingtimes & " " &$Addrs[0] & " " & $ports[0] & " | wtee " & @ScriptDir &"\games\"& $timenow & $names[0] &".log ")
;~ MsgBox(0,"",@ComSpec & " /k " & " title " & $Addrs[0] & " && tcping " &  " -n " & $pingtimes &" " & $Addrs[0] & " " &$ports[0] & " | wtee " & @ScriptDir &"\games\"& $timenow & $names[0] &".log ")
;~ Exit
WinWaitActive("管理员:  "& $names[0] )
WinMove(WinGetTitle("[ACTIVE]"), "",0,0,$cmd_W,$cmd_H)


$cmd2=Run(@ComSpec & " /k "&" title " & $names[1] & " && tcping "& " -n " & $pingtimes & " " & $Addrs[1]& " " & $ports[1] & " | wtee " & @ScriptDir &"\games\"& $timenow & $names[1] &".log ")
WinWaitActive("管理员:  "& $names[1] )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3,0,$cmd_W,$cmd_H )


$cmd3=Run(@ComSpec & " /k "&" title " & $names[2] &" && tcping "& " -n " & $pingtimes & " " & $Addrs[2]& " " & $ports[2] &" | wtee " & @ScriptDir &"\games\"& $timenow &  $names[2] &".log ")
WinWaitActive("管理员:  "& $names[2] )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3*2,0,$cmd_W,$cmd_H )


$cmd4=Run(@ComSpec & " /k "&" title " & $names[3]  &" && tcping "& " -n " & $pingtimes & " " &$Addrs[3] & " " & $ports[3] & "  | wtee " & @ScriptDir &"\games\"& $timenow & $names[3]  &".log ")
WinWaitActive("管理员:  "& $names[3] )
WinMove(WinGetTitle("[ACTIVE]"), "",0,$Height/2-5,$cmd_W,$cmd_H )



$cmd5=Run(@ComSpec & " /k "&" title "  & $names[4] &" && tcping "&  " -n " & $pingtimes & " " &$Addrs[4] & " " & $ports[4] &"  | wtee " & @ScriptDir &"\games\"& $timenow & $names[4] &".log ")
WinWaitActive("管理员:  "& $names[4] )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3,$Height/2-5,$cmd_W,$cmd_H )



$cmd6=Run(@ComSpec & " /k "&" title " & $names[5] &" && tcping "&  " -n " & $pingtimes &  " " &$Addrs[5] & " " & $ports[5] & "  | wtee " & @ScriptDir &"\games\"& $timenow & $names[5] &".log ")
WinWaitActive("管理员:  "& $names[5] )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3*2,$Height/2-5,$cmd_W,$cmd_H )


;~ Global $Addrs[6]=["send1.doyu.com","ps8.live.panda.tv","yfrtmpup.cdn.zhanqi.tv","push.v.cc.163.com","203.156.252.216","59.111.198.163"]

#CS
While 1
	
	
	For $item In $Addrs 
		
		Local $pingbk=Ping($item)
		If $pingbk>30 Then
;~ 			MsgBox(0,"","time: " & $pingbk,1)
			Local $timenow = "record time  " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC &  @CRLF
					   
		   Local $thisfile=@ScriptDir & '\' & $item & '_告警记录.log'
			If Not FileExists($thisfile) Then FileWriteLine($thisfile," ") ;写入空行FileWrite($thisfile,$timenow)
			FileWrite($thisfile,"返回时长： " & $pingbk &@CRLF )
		ElseIf $pingbk==0 Then
;~ 			MsgBox(0,"","time: " & $pingbk & @CRLF & "Error: " & @error,1)
			Local $timenow = "record time  " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC &  @CRLF
			Local $thisfile=@ScriptDir & '\' & $item & '_告警记录.log'
			If Not FileExists($thisfile) Then FileWriteLine($thisfile," ") ;写入空行
			FileWrite($thisfile,$timenow)
			FileWrite($thisfile,"返回时长： " & $pingbk  &@CRLF)
		EndIf
	Next
		
	Sleep(250)
WEnd

#CE

;~ FileDelete(@ScriptDir &"\wtee.exe")
	
