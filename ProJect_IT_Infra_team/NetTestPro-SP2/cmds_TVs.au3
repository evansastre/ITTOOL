#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Release\cmds_TVs_x64.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****




FileInstall(".\wtee.exe",@ScriptDir &"\wtee.exe")


$Width=@DesktopWidth 
$Height=@DesktopHeight 
$cmd_W=$Width/3
$cmd_H=$Height/2



While ProcessExists("ping.exe") Or ProcessExists("cmd.exe")
	ProcessClose("ping.exe")
	ProcessClose("cmd.exe")
WEnd


$douyu="send3a.douyu.com"
$cmd1=Run(@ComSpec & " /k " & " title " & $douyu & " && ping " & $douyu & " -t | wtee " & @ScriptDir &"\"& $douyu &".log ")
WinWaitActive("管理员:  "& $douyu )
WinMove(WinGetTitle("[ACTIVE]"), "",0,0,$cmd_W,$cmd_H)



$panda="ps8.live.panda.tv"
$cmd2=Run(@ComSpec & " /k "&" title " & $panda & " && ping "&$panda& " -t | wtee " & @ScriptDir &"\"& $panda &".log ")
WinWaitActive("管理员:  "& $panda )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3,0,$cmd_W,$cmd_H )



$zhanqi="dlrtmpup.cdn.zhanqi.tv"
$cmd3=Run(@ComSpec & " /k "&" title " & $zhanqi &" && ping "&$zhanqi& " -t | wtee " & @ScriptDir &"\"& $zhanqi &".log ")
WinWaitActive("管理员:  "& $zhanqi )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3*2,0,$cmd_W,$cmd_H )

$CC="push.v.cc.163.com"
$cmd4=Run(@ComSpec & " /k "&" title " & $CC  &" && ping "&$CC& " -t | wtee " & @ScriptDir &"\"& $CC &".log ")
WinWaitActive("管理员:  "& $CC )
WinMove(WinGetTitle("[ACTIVE]"), "",0,$Height/2-5,$cmd_W,$cmd_H )


$quanmin="up.quanmin.tv"
$cmd5=Run(@ComSpec & " /k "&" title "  & $quanmin &" && ping "& $quanmin & " -t | wtee " & @ScriptDir &"\"& $quanmin &".log ")
WinWaitActive("管理员:  "& $quanmin )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3,$Height/2-5,$cmd_W,$cmd_H )




$huya="rtmp.huya.com"
$cmd6=Run(@ComSpec & " /k "&" title " & $huya &" && ping "& $huya & " -t | wtee " & @ScriptDir &"\"& $huya &".log ")
WinWaitActive("管理员:  "& $huya )
WinMove(WinGetTitle("[ACTIVE]"), "",$Width/3*2,$Height/2-5,$cmd_W,$cmd_H )


Global $Addrs[8]=["send3a.douyu.com","ps8.live.panda.tv","dlrtmpup.cdn.zhanqi.tv","push.v.cc.163.com","up.quanmin.tv","rtmp.huya.com","fengyunzhibo.com","dc4"]
While 1
	
	
	For $item In $Addrs 
		
		Local $pingbk=Ping($item)
		If $pingbk>30 Then
;~ 			MsgBox(0,"","time: " & $pingbk,1)
			Local $timenow = "record time  " &@YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC &  @CRLF
					   
		   Local $thisfile=@ScriptDir & '\' & $item & '_告警记录.log'
			If Not FileExists($thisfile) Then FileWriteLine($thisfile," ") ;写入空行
			FileWrite($thisfile,$timenow)
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

	
