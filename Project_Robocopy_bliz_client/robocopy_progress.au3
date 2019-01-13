#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\Robocopy_bliz_client\robocopy_progress.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****


#include <Process.au3>
#include <Math.au3>
#include <Misc.au3>
#include <Array.au3>
#include <AD.au3>
#include <file.au3>

;Y:\Robocopy_bliz_client\robocopy_progress.exe
;  test     \\192.168.116.1\E$\robocopy_progress.exe
Opt("TrayIconHide",1)

If $CmdLine[0]<> 1 Then
		MsgBox(0,"","传入参数错误，请确认配置")
		Exit
EndIf
Global $game=$CmdLine[1]    ;传入游戏名
	
If _Singleton("战网客户端多源同步.exe",1)=0 Then 	;Prevent repeated opening of the program
	
	MsgBox(0,"", "有客户端正在同步，请等待完成")
	Exit
EndIf


Func Init()
	

	
	
	Global $location="";定义所在地
	Global $server="";定义同步的源服务器

	Global $percent = 0    ;进度百分比
	Global $stdread=0  ;当前读取字节组Y:\Robocopy_bliz_client
	Global $local_dir="D:\" & $game
;~ 	If Not FileExists("D:\") Then
;~ 		MsgBox(0,"","D盘不存在或无法使用")
;~ 		Exit
;~ 	EndIf
	
	
	Global $server_area = "" 

	;结束掉robocopy进程
	If ProcessExists("robocopy.exe") Then
		$res=MsgBox(1,"","当前有同步进程存在，是否强制结束？")
		If $res==1 Then
			While ProcessExists("robocopy.exe")
				ProcessClose("robocopy.exe")
			WEnd 
		ElseIf $res==2 Then
			MsgBox(0,"","您选择了不结束同步进程，当前任务中止")
			Exit
		EndIf
	EndIf
	
	
	Switch $game
		Case "World of Warcraft"
			Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
		Case "Diablo III CN"
			Local $list[3]= ["Diablo III.exe","battle.net.exe","agent.exe"]
		Case "Heroes of the Storm"
			Local $list[4]= ["HeroesOfTheStorm_x64.exe","Heroes of the Storm.exe","battle.net.exe","agent.exe"]
		Case "Hearthstone"
			Local $list[3]= ["Hearthstone.exe","battle.net.exe","agent.exe"]
		Case "Overwatch"
			Local $list[3]= ["Overwatch.exe","battle.net.exe","agent.exe"]
		Case "StarCraft_II"
			Local $list[4]= ["SC2_x64.exe","StarCraft II.exe","battle.net.exe","agent.exe"]
	EndSwitch
	
	;结束掉以下进程以确保同步时没有进程被占用
;~ 	Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
	For $item In $list
		While ProcessExists($item)
			ProcessClose($item)
		WEnd
	Next
EndFunc



Func judgeLocation()
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		judgeLocationJV()
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
	EndIf
EndFunc

Func judgeLocationJV()
	Local $myip=@IPAddress1
	Local $tmp_arr=StringSplit($myip,".",1)
	$IP_area=$tmp_arr[3]
	If $IP_area=="105" Then
		$location = 'JV'
;~ 		MsgBox(0,"","area:"&$IP_area)
	EndIf
	
	Return
;~ 	Exit
EndFunc

	

Func chooseServer($location)	
	$dir = "\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\"
	Global $PROFILEPATH = $dir & $game & ".ini"
	$aArray = IniReadSectionNames($PROFILEPATH)
	If @error<>0 Then 
		MsgBox(0,"","配置文件有错，请联系IT处理")
		Return -1
	EndIf
	
	Local $TotalNum = $aArray[0] ; 同步源总数
	
	
	$get_min_links=False
	For $i = 1  To  $TotalNum
		$this_location=IniRead($PROFILEPATH,$aArray[$i],"location","")
		
		
		If $this_location=="" Then ContinueLoop ;如果location的定义读取到为空，则跳过当前服务源，进行下一趟循环
		If $this_location==$location Then ;读取的源服务器与当前用户所在地相同
			If Not $get_min_links Then 
				$min_links=IniRead($PROFILEPATH,$aArray[$i],"links",0) ;将最小connect数初始化为首个源的connect数*******
				If $min_links=="" Then $min_links=0 
				$server=$aArray[$i]
;~ 				MsgBox(0,"", "当前服务器： "&$server)
				$get_min_links=True
				ContinueLoop
			EndIf
			
;~ 			MsgBox(0,"","i="& $i& "  "& $this_location)
			$this_links=IniRead($PROFILEPATH,$aArray[$i],"links","定义不存在") ;读取links的值
			If $this_links=="" Then $this_links=0 ;如果没有读到定义值，则认为它当前为0
			If $this_links==0 Then $min_links=$this_links  ;当前服务器connect数为0时，重新定义它为最小connect数服务器
			If $this_links <= $min_links Then 
				$min_links=$this_links ; 将当前的服务器connect数定义为最小connect数
				$server=$aArray[$i]
;~ 				MsgBox(0,"", "当前服务器： "&$server)
			EndIf
			
		EndIf
	Next
;~ 	MsgBox(0,"",$location &@LF& $server)
	
;****************************清除异常断开connect状况******************************
	
	For $i = 1  To  $TotalNum
		Local $this_server=$aArray[$i]
		Local $this_user=IniRead($PROFILEPATH,$this_server,"users","")
		If $this_user=="" Then ContinueLoop
		Local $this_ips=IniRead($PROFILEPATH,$this_server,"ips","")
		
		If StringInStr($this_user,StringUpper(@UserName)) And StringInStr($this_ips,@IPAddress1)  Then ;如果用户名已经在，说明有历史的异常connect没断开或者在另一台电脑上开了同步 。同一台电脑（IP）和同一用户，视作是上次异常断开。
					
			$this_user=StringReplace($this_user , StringUpper(@UserName) & "|","")
			IniWrite($PROFILEPATH,$this_server,"users",$this_user) ;写入减除自身用户名的字符串
			
			$this_ips=StringReplace($this_ips , @IPAddress1 & "|","")
			IniWrite($PROFILEPATH,$this_server,"ips",$this_ips) ;写入减除自身IP地址的字符串
			
			Local $this_links=IniRead($PROFILEPATH,$this_server,"links","定义不存在") ;读取links的值
			IniWrite($PROFILEPATH,$this_server,"links",$this_links-1)  ; 结束后将connect数记录减1
		EndIf
	Next
	
;****************************写connect状况******************************
	IniWrite($PROFILEPATH,$server,"links",$min_links+1)  ;connect数 +1
	Local $users=IniRead($PROFILEPATH,$server,"users","")
	If Not StringInStr($users,StringUpper(@UserName)) Then IniWrite($PROFILEPATH,$server,"users",$users & StringUpper(@UserName) & "|") ;写入用户名
	
	Local $ips=IniRead($PROFILEPATH,$server,"ips","")
	If Not StringInStr($ips,@IPAddress1) Then IniWrite($PROFILEPATH,$server,"ips",$ips & @IPAddress1 & "|") ;写入IP地址

EndFunc   

Init()
judgeLocation()
chooseServer($location)
robocopy_from_server($server)


Func robocopy_from_server($server)
	
	

	$myfolder = '\\' & $server & '\' & $game ;源目录名

	
	If Not FileExists($myfolder) Then 
		MsgBox(0,"","服务器 " &$server &" 当前处于不可用状态，可能正在进行版本升级维护，请稍后再试或联系IT") 
		Exit
	EndIf
	
	$Tip = "tip"
	TrayTip($Tip, "客户端同步中，请耐心等耐", "", 1)
	
	Global $dirsize=Round(DirGetSize($myfolder)/1024/1024,1) ; & " MB"
	
	
	
	;战网客户端
	Global $battlenet1='robocopy.exe  "\\' & $server & '\phoenix\Program Files (x86)\Battle.net"  "%programfiles(X86)%\Battle.net"  /mir '
	Global $battlenet2='robocopy.exe  "\\' & $server & '\phoenix\ProgramData\Battle.net"  "C:\ProgramData\Battle.net"  /mir '
	Global $battlenet3='robocopy.exe  "\\' & $server & '\phoenix\Roaming\Battle.net"   "%userprofile%\AppData\Roaming\Battle.net"   /mir '
	Global $battlenet4='robocopy.exe  "\\' & $server & '\Phoenix\Local\Battle.net"     "%userprofile%\AppData\Local\Battle.net"  /mir '
	Global $battlenet5='robocopy.exe  "\\' & $server & '\Phoenix\战网游戏_快捷方式"     "%userprofile%\desktop\战网游戏_快捷方式"  /mir '
	
;~ 	Global $wtf='echo .'

	If $game== "World of Warcraft" Then 
		$battlenet5='echo .'  ;为wow时不拷贝快捷方式
		$local_dir="D:\CMOP5"
		
		$IsCross=IsCross()
		If  $IsCross  Then ;当用户在GM_list里时
			$wowclient='%temp%\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'" '

		Else 
			;wow客户端
			$wowclient='%temp%\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'"  /mir /XF *WowGM* /XD Interface WTF '
			If Not FileExists($local_dir & "\WTF\Config.wtf") Then FileCopy($myfolder & "\WTF\Config.wtf",$local_dir & "\WTF\Config.wtf",1+8)
;~ 			$wtf='copy  "'& $myfolder & '\WTF\Config.wtf"  "'& $local_dir &'\WTF\Config.wtf"   '
	;~ 		$wowclient='D:\IT部署的工具\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'"   /XF *WowGM* /XD Interface  '
	
		EndIf
		
		
	
	Else
		$wowclient='%temp%\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'" '
	EndIf
	
	
	

	Global $cmd[6]=[$wowclient,$battlenet1,$battlenet2,$battlenet3,$battlenet4,$battlenet5]

	
	runBatWait($cmd)
;~ 	
	
	;****************************ticket record******************************
	If $location == 'HZ' Then ;记录操作
		WO_rec($game&"客户端更新_杭州")
	ElseIf $location == 'SH' Then 
		WO_rec($game&"客户端更新_上海")
	EndIf
;~ 	
	TrayTip($Tip, "完成", "", 1)
	Sleep(1000)
	
	
	;****************************恢复connect状况******************************
	Local $this_links=IniRead($PROFILEPATH,$server,"links","定义不存在") ;读取links的值
	If $this_links=="" Then
		$this_links=0 ;如果没有读到定义值，则认为它当前为0
		IniWrite($PROFILEPATH,$server,"links",$this_links)  ;
	Else
		IniWrite($PROFILEPATH,$server,"links",$this_links-1)  ; 结束后将connect数记录减1
	EndIf
	
	
	Local $users=IniRead($PROFILEPATH,$server,"users","")
	If StringInStr($users,StringUpper(@UserName)) Then 
		$users=StringReplace($users , StringUpper(@UserName) & "|","")
		IniWrite($PROFILEPATH,$server,"users",$users) ;写入减除自身用户名的字符串
	EndIf
	
	Local $ips=IniRead($PROFILEPATH,$server,"ips","")
	If StringInStr($ips,@IPAddress1) Then 
		$ips=StringReplace($ips , @IPAddress1 & "|","")
		IniWrite($PROFILEPATH,$server,"ips",$ips) ;写入减除自身IP地址的字符串
	EndIf
		
	If $game== "World of Warcraft" Then
		If Not FileExists(@DesktopDir & "\战网游戏_快捷方式") Then DirCreate(@DesktopDir & "\战网游戏_快捷方式")
		
		If Not $IsCross Then
			DirRemove("D:\CMOP5\Interface\AddOns\GM++",1)
			DirRemove("D:\CMOP5\Interface\AddOns\DebugMenu",1)
			FileDelete("D:\CMOP5\WowGM.exe")
			FileDelete("D:\CMOP5\WowGM.pdb")
			FileDelete("D:\CMOP5\WowGM-64.exe")
			FileDelete("D:\CMOP5\WowGM-64.pdb")
			
			FileCreateShortcut("D:\CMOP5\Wow.exe",@DesktopDir & "\战网游戏_快捷方式\Wow.lnk")
			$res=MsgBox(1,"","同步完成，是否打开客户端?") ;
			If $res==1 Then Run("D:\CMOP5\Wow-64.exe") 
		Else 
			FileCreateShortcut("D:\CMOP5\WowGM-64.exe",@DesktopDir & "\战网游戏_快捷方式\WowGM-64.lnk")
			$res=MsgBox(1,"","同步完成，是否打开GM客户端?") ;
			If $res==1 Then Run("D:\CMOP5\WowGM-64.exe") ;*********************** GM客户端	
		EndIf
	Else
		$res=MsgBox(1,"","同步完成，是否打开战网客户端?") ;
		If $res==1 Then  Run("C:\Program Files (x86)\Battle.net\Battle.net.exe")
	EndIf
	
	
	
EndFunc  


Func get_member_of()
	Global $GM_list=StringUpper("ITbat_client_wowGM")
	
	Global $myGgroup[0]	
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; 返回用户所属的组
	Global $aUser = _AD_RecursiveGetMemberOf(@UserName, 10, 1)
	If @error > 0 Then
		MsgBox(64, "", "用户 '" & StringUpper(@UserName) & "' 不属于任何域内安全组")
		Exit
	Else
		$NUM=$aUser[0]
		For $i=1 To $NUM 
			;对DN进行处理，取出group的字段
			$tmp_arr=StringSplit($aUser[$i],",",1)
			$group=$tmp_arr[1]
			$tmp_arr2=StringSplit($group,"=",1)
			$group=$tmp_arr2[2]
			_ArrayAdd($myGgroup,StringUpper($group))    ;注意统一为大写
		Next
	EndIf
	; 关闭AD
	_AD_Close()
;~ 	_ArrayDisplay($myGgroup)
;~ 	Exit
EndFunc

Func IsCross()
	get_member_of()  ;获取自身所在安全组
	$res=_ArraySearch($myGgroup,$GM_list)
	If $res<>-1 Then 
;~ 		MsgBox(0,"","True")
		Return True
	EndIf
;~ 	MsgBox(0,"","False")
	Return False			
EndFunc



Func runBatWait($cmd);$cmd must be array
	
    Local $sFilePath =_TempFile(Default,Default,".bat")
	For $i In $cmd 
;~ 		MsgBox(0,"",$i)
		FileWriteLine($sFilePath,$i)
	Next
;~ 	MsgBox(0,"",$cmd)
	FileWriteLine($sFilePath,"del %0")
	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)
;~ 	MsgBox(0,"","done")
EndFunc



Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  StringUpper(@UserName) & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc







