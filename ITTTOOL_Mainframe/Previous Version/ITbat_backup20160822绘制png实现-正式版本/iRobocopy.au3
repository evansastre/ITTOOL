#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=itbat_materials\iRobocopy.ico
#AccAu3Wrapper_OutFile=iRobocopy.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <Process.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>

;~ Opt("TrayIconHide",1)
If _Singleton("iRobocopy.exe",1)=0 Then 	;Prevent repeated opening of the program
;~ 	ProcessClose("irobocopy.exe")
	MsgBox(0,"","当前有客户端同步程序正在运行"& @LF & "请完成后再试",3)
	Exit
EndIf

Global $ParaNum=$CmdLine[0]

If $ParaNum<2 Then
	MsgBox(0,"","传入参数不足")
	Exit
ElseIf $ParaNum==2 Then
	Global $Paras[3]=[' "' & $CmdLine[1] & '" ',' "' & $CmdLine[2] & '" '," /mir "]
ElseIf $ParaNum>=3 Then
	Global $Paras[0]
	_ArrayAdd($Paras,' "' & $CmdLine[1] & '" ')
	_ArrayAdd($Paras,' "' & $CmdLine[2] & '" ')
	For $i=3 To $ParaNum
		_ArrayAdd($Paras,$CmdLine[$i])
	Next
EndIf
;~ _ArrayDisplay($Paras)

;角标tip
Opt("TrayOnEventMode", 1) ; 启用托盘 OnEvent 事件函数通知.
Opt("TrayMenuMode", 3) ; 默认托盘菜单项目将不会显示, 当选定项目时也不检查. TrayMenuMode 的其它选项为 1, 2.
TrayCreateItem("关于...")
TrayItemSetOnEvent(-1, "show_Info")
TrayCreateItem("") ; 创建分隔线.
TrayCreateItem("退出")
TrayItemSetOnEvent(-1, "CLOSEButton")
TraySetState($TRAY_ICONSTATE_SHOW) ; 显示托盘菜单.




Global $server=$CmdLine[1];定义同步的源目录
Global $local_dir=$CmdLine[2];本地的目标目录


Func show_Info()
	MsgBox(0,"","正在同步:"& $local_dir)
EndFunc



Global $sCommand = 'robocopy '  
For $item In $Paras
	$sCommand&=' ' & $item & ' '
Next
;~ MsgBox(0,"",$sCommand)
;~ Exit

If Not FileExists($server) Then 
	MsgBox(0,"",$server &" 当前处于不可用状态，请稍后再试或联系IT") 
	Exit
EndIf


Func Init()
	Global $percent = 0    ;进度百分比
	Global $stdread=0  ;当前读取字节组Y:\Robocopy_bliz_client
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
	
	;结束掉以下进程以确保同步时没有进程被占用
;~ 	Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
;~ 	For $item In $list
;~ 		While ProcessExists($item)
;~ 			ProcessClose($item)
;~ 		WEnd
;~ 	Next
EndFunc


Func robocopy_from_server($server)
	$serverfolder = $server   ;源目录名
	
	$Tip = "tip"
	TrayTip($Tip, "客户端同步中，请耐心等耐", "", 1)
	
	readstdout($serverfolder,$local_dir)  ;同步客户端
EndFunc  

Init()
robocopy_from_server($server)


Func readstdout($my_folder,$my_local_dir)
	TrayTip("tip","即将同步至：" & $my_local_dir,10)

	Global $dirsize=Round(DirGetSize($my_folder)/1024/1024,1) ; & " MB"
;~ 	MsgBox(0,"",$my_folder)

;~ 	$show_info=StringMid($my_folder,17)
	
	#include <GUIConstantsEx.au3>
	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)
	

	$hMainGUI = GUICreate("战网客户端同步进度", 400, 100,-1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetIcon(@TempDir & "\button_icons\Battle.net.ico")
	
;~ 	$show_info=StringMid($my_folder,19)
	$show_info=$my_local_dir
;~ 	MsgBox(0,"",$show_info)
	Global $idLabel2=GUICtrlCreateLabel("正在同步:"& $show_info,0,0,400,30)
	Global $idLabel1=GUICtrlCreateLabel(" ",0,80,400,30)
	Global $idProgressbar1=GUICtrlCreateProgress(-1,40,400,30)
	GUISetState(@SW_SHOW)

	Local $iWait = 250; 为下一个进度等待 250 毫秒
;~ 	Local $iSavPos = 0; 保存进度位置
	
;~  	$sCommand = 'robocopy "'&  $my_folder & '"  "'& $my_local_dir &'"  /mir'
 	Run( $sCommand,@SystemDir,@SW_HIDE )

;~ 	Sleep(1000)
	While 1
		showProgress()
		Sleep($iWait)
		If Not ProcessExists("robocopy.exe") Then 
			GUICtrlSetData($idLabel1, $local_dir&"同步已完成。同步数据量："& $stdread & "MB")
			TrayTip("tip",$local_dir & "同步已完成。同步数据量："& $stdread & "MB",3,1)
	
			Sleep(2000)
			Return
		EndIf
	WEnd
EndFunc

Func showProgress()
	If Not ProcessExists("robocopy.exe") Then Return
	
	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"

	$percent = Round($stdread/$dirsize,3)*100
	If ProcessExists("robocopy.exe") And $percent>=99.999 then
		GUICtrlSetData($idLabel1, " 即将完成，请勿关闭")
	Else
		GUICtrlSetData($idLabel1, "正在同步中，请耐心等待。当前同步数据量： " & $stdread & "MB" )
	EndIf
	
	GUICtrlSetData($idProgressbar1, $percent)
EndFunc   ;==>showProgress

Func CLOSEButton()
	While ProcessExists("robocopy.exe")
		ProcessClose("robocopy.exe")
	WEnd
	MsgBox(0,"","您结束了同步过程，" & @LF &"不完整的同步过程可能导致客户端无法正常运行",5)
	Exit
EndFunc   ;==>CLOSEButton

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\wowgametestdc\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc

Func runBat($cmd);$cmd must be array
    Local $sFilePath =_TempFile(Default,Default,".bat")
	

	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc   ;==>runBat

