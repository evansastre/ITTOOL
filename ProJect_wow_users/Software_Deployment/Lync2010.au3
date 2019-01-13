#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\Lync2010.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <Math.au3>
#include <TrayConstants.au3>

Install()

Func Install()
	
	Global $path=RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\communicator.exe", "Path") & "communicator.exe"
	If @error==0 Then ; 为0时说明已经读取到此值，说明lync已安装，直接跳到配置步骤
		While ProcessExists("communicator.exe") 
			ProcessClose("communicator.exe");关闭LYNC
		WEnd
		$res=MsgBox(4,"","检测到 Lync 已经安装，是否直接打开？"  & @LF & _ 
						  "选 [是] 将直接打开Lync并进行配置，选 [否] 会退出" )
		If $res==6 Then
			ShellExecute($path) ;打开
			set()               ;配置
			Return
		Else 
			Exit			
		EndIf
	EndIf
		
	;判断当前所在地，并下载lync	
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")

	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$dir="\\ITTOOL_node2\ITTOOLS\SoftwareDeploy"
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$dir="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy"
	EndIf
	
	$lync="LyncSetupEval_64.1399432773.exe"
	$software = $dir & "\" & $lync
	Global $lyncsize=Round(FileGetSize ($software)/1024/1024,2)  ;MB
	
	ProgressOn("正在下载",  $lync , "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
	AdlibRegister("showProgress", 250)
	ShellExecuteWait("robocopy",'"' & $dir & '"  ' & '"' &  'E:\Lync' & '"  ' & $lync , "", "",@SW_HIDE)
	AdlibUnRegister("showProgress")
	ProgressSet(100, "完成", "进度状态:")
	ProgressOff()
	
	;
	
    ;安装过程
	ShellExecute("E:\Lync\" & $lync)
	TrayTip("tip","正在检测安装窗口,请勿操作",30)
	$Title="Microsoft Lync 2010 安装程序"
	$time=0
	While True    
		If $time >= 60 Then ;超时30秒 ，如果结束，退出循环
			$choose=MsgBox(1,"","安装过程异常，是否重新安装？")	
			If $choose==1 Then
				Install()
				Return
			ElseIf $choose==2 Then
				Exit
			EndIf
		EndIf
		
		$res=WinExists($Title,"安装(&I)") ;判断窗口是否出现，出现则激活安装窗口，并退出此判断循环
			If $res==0 Then   ;窗口不存在
				Sleep(500) ;停半秒再继续循环
				$time=$time +1 
				ContinueLoop
			elseIf $res==1 Then
				WinActivate($Title,"安装(&I)")
				ExitLoop
			EndIf
	WEnd
	
	
	
	
	ControlClick($Title,"","Button1","left",1) ;点击安装
	TrayTip("tip","正在安装，安装过程将自动完成，请勿进行操作",30)
	While True
		If WinExists($Title,"查看更新时使用 Microsoft Update (推荐)") Then  ;首次安装lync的情形
			WinActivate($Title,"查看更新时使用 Microsoft Update (推荐)")
			ControlClick($Title,"","Button1","left",1)
			ControlClick($Title,"","Button4","left",1)
			WinWaitActive($Title,"已成功安装",20)
			Sleep(2000) ; 暂停一下让最终窗口成形
			ControlClick($Title,"","Button2","left",1) ;关闭
			ExitLoop
		EndIf
		If WinActive($Title,"已成功安装。") Then    ;这是在之前已经安装过lync，卸载后再次安装的情形
;~ 			MsgBox(0,"","出现窗口")
;~ 			$res=ControlGetFocus($Title,"已成功安装。")
;~ 			MsgBox(0,"","出现窗口2")
;~ 			If $res=="" Then
;~ 				MsgBox(0,"","未找到安装成功窗口")
;~ 				ContinueLoop
;~ 			ElseIf $res<>"" Then
;~ 				MsgBox(0,"","找到了结束窗口")
;~ 			EndIf
;~ 			MsgBox(0,"","出现窗口3")
			Sleep(2000) ; 暂停一下让最终窗口成形
			ControlClick($Title,"关闭 (&L)","Button2","left",1) ;点击关闭Button
			ExitLoop
		EndIf
		Sleep(100) ;让循环暂停，减少cpu占用
	WEnd
	; "已成功安装。""安装成功"
	TrayTip("tip","安装完成，即将开始配置",3)
	DirRemove('E:\Lync\',1);删除安装包并开始配置操作
	WO_rec("部署lync2010")
	set()
EndFunc


Func set()
	If Not ProcessExists("communicator.exe") Then ShellExecute($path) ; "没打开时打开一下"
	
	$Title="Microsoft Lync          "
	$res=WinWaitActive($Title,"",20)
	If $res==0 Then 
		MsgBox(0,"","LYNC配置未完成，无法检测到已打开的LYNC，请重新运行本程序")
		Exit
	EndIf

	$Pos=WinGetPos($Title,"") ;获得POPO软件界面框架的起始坐标
	$x=$pos[0]
	$y=$pos[1]

	MouseClick("left",$x+300,$y+60)  ;点击一下配置Button
	$Title="Lync - 选项"
	WinWaitActive($Title,"")
	ControlSetText($Title,"","Edit1","kxu.nbe@blizzard.com") ;填写登录地址
	ControlClick($Title,"","Button2","left",1) ;点击”高级“Button
	;Sleep(1000)
	$Title="高级connect设置"
	WinWaitActive($Title,"")
	ControlClick($Title,"","Button2","left",1) ;点击”手动配置“Button
	ControlSetText($Title,"","Edit1","im.blizzard.com:443") ;填写内部ip地址
	ControlSetText($Title,"","Edit2","im.blizzard.com:443") ;填写外部ip地址
	ControlClick($Title,"","Button5","left",1) ;点击”Confirm“Button
	$Title="Lync - 选项"
	WinActive($Title,"") ;激活之前的主窗口
	ControlClick($Title,"","Button18","left",1) ;点击”Confirm“Button
	
	$Title="Microsoft Lync          "
	WinActive($Title,"") ;激活登录窗口

	MouseClick("left",$x+78,$y+300)  ;点击一下登录Button
	MouseMove($x+98,$y+300)
	
	MsgBox(0,"","LYNC配置已完成，请尝试登录")
EndFunc



Func showProgress()
	
	If Not ProcessExists("robocopy.exe") Then Return

	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
	$i = Round($stdread/$lyncsize,3)*100
	If ProcessExists("robocopy.exe") And $i>=99.999 then
		ProgressSet($i, " 即将完成，请勿关闭")
	Else
		ProgressSet($i, $stdread & "MB/" & $lyncsize & "MB")
	EndIf

EndFunc   ;==>showProgress


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
