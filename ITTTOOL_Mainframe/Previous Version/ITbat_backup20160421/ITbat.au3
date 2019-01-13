#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=ITbat.ico
#AccAu3Wrapper_OutFile=ITbatPRO.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3> 
#include <Misc.au3>
#include "OpenInit.au3"
#include "play_backgroundmusic.au3"
#include "GUI_EnableDragAndResize.au3"

If _Singleton("ITbatPRO",1) = 0 Then
		MsgBox(0,"","Test already running");Prevent repeated opening of the program
		Exit
EndIf


OpenInit()
MsgBox(0,"","accesstoolsNum:"&$AccesstoolsNum)
_ArrayDisplay($AccessTools) ;显示所有用户可访问的工具

MsgBox(0,"",$AccessTools[0])
;~ _ArrayDisplay($AccessCommandText) ;显示所有用户可访问的命令
;~ _ArrayDisplay($AccessDescribe) ;显示所有用户可访问的描述
;~ exit

;~ MsgBox(0,"",$PROFILEPATH)


MainWindow()
Func MainWindow()
	Opt("GUIResizeMode", 1)
	;$Form1 = GUICreate("GodMod", 520, 170,-1,-1,$WS_OVERLAPPEDWINDOW +$WS_EX_CLIENTEDGE )
;~ 	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
;~ 	FileInstall(".\ITbat.ico", @TempDir & "\ITbat.ico", 1)
;~ 	$Form0 = GUICreate("mainW", 800, 600,-1,-1,BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))
;———————————————————————————————————————————————————————————————
	;主框架
	$Form1 = GUICreate("ITbatPRO", 800, 600,-1, -1, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX))
	GUISetIcon(@TempDir & "\ITbat.ico")
	GUISetBkColor(0x282828)
	_GUI_EnableDragAndResize($Form1,300, 150)
	
	 ;———————————————————————————————————————————————————————————————
	 ;顶层Button
	$play_ico=@TempDir & "\play.ico"
	$pause_ico=@TempDir & "\pause.ico"
	$close_ico=@TempDir & "\close_ico.ico"
	FileInstall("materials\play.ico", $play_ico, 1)
	FileInstall("materials\pause.ico", $pause_ico, 1)
	FileInstall("materials\close_ico.ico", $close_ico, 1)
	
;~ 	$play_button=GUICtrlCreateButton(".", 700, 10,38,32)
;~ 	GUICtrlSetDefBkColor(0x00C5CD)
;~ 	GUICtrlSetImage($play_button,$play_ico,10,1)

;~ 	GUICtrlSetImage($button1,"shell32.dll",10,1)
;~ 	"shell32.dll"
;~     GUICtrlCreateIcon(@ScriptDir & '\Extras\horse.ani', -1, 20, 40, 32, 32)
    $play_button=GUICtrlCreateIcon($play_ico, -1, 10, 10,38,32)
	GUICtrlSetState($play_button,$GUI_HIDE)
	$pause_button=GUICtrlCreateIcon($pause_ico, -1, 10, 10,38,32)
	GUICtrlSetState($pause_button,$GUI_SHOW )

	$close_button=GUICtrlCreateIcon($close_ico, -1, 750, 10,38,32)
	GUICtrlSetState($close_button,$GUI_SHOW )
				

	;———————————————————————————————————————————————————————————————
	
	;标签页
	Local $idTab = GUICtrlCreateTab(10, 50, 780, 500,$TCS_MULTILINE);$WS_EX_DLGMODALFRAME
	
	For $i=1 To  $AccesstoolsNum 
		GUICtrlCreateTabItem($AccessTools[$i-1])
	Next
	
		
		
	
#CS
	
;~ 	Local $idTab = GUICtrlCreateTab(10, 50, 780, 500,$TCS_MULTILINE,$WS_EX_TRANSPARENT);$WS_EX_DLGMODALFRAME
	
	
;~ 	$Form1 = GUICreate("ITbatPRO", 520, 170,100,300,$Form0 )	
;~ 	GUICtrlSetResizing ($idTab,802)
	
;~ 	$Button1 = GUICtrlCreateButton("mstsc", 46, 36, 90, 65)
;~ 	$Button2 = GUICtrlCreateButton("交换机配置备份", 198, 36, 90, 65)
;~ 	$Button3 = GUICtrlCreateButton("域帐号重置", 350, 36, 90, 65)
	;GUICtrlSetOnEvent($Button1,"mstscq")
;~ 	$Button5 = GUICtrlCreateButton("交换机配置备份", 198, 96, 90, 65)
;~ 	$Button6 = GUICtrlCreateButton("域帐号重置", 350, 96, 90, 65)
;~ 	$Button7 = GUICtrlCreateButton("mstsc", 46, 156, 90, 65)
;~ 	;GUICtrlSetOnEvent($Button1,"mstscq")
;~ 	$Button8 = GUICtrlCreateButton("交换机配置备份", 198, 156, 90, 65)
;~ 	$Button9 = GUICtrlCreateButton("域帐号重置", 350, 156, 90, 65)

	GUICtrlCreateTabItem("同步客户端")
	GUICtrlCreateTabItem("SoftwareDeploy")
    GUICtrlCreateButton("Confirm 0", 20, 100, 50, 20)
    GUICtrlCreateTabItem("corp账号自助管理")    

	$idTabItem=GUICtrlCreateTabItem("桌面工具集")
;~ 	GUICtrlSetState(-1, $GUI_SHOW); 将首先显示
	GUICtrlCreateGroup("", 20, 90, 760, 450)
	GUICtrlCreateButton("buttont",20,100,50,20)
	
	GUICtrlCreateTabItem("IT权限工具")
	GUICtrlCreateTabItem("网络管理工具")
	GUICtrlCreateTabItem("域账号管理")
	GUICtrlCreateTabItem("邮件管理")
	GUICtrlCreateTabItem("网页管理")
	GUICtrlCreateTabItem("测试1管理")
	GUICtrlCreateTabItem("测试2管理")
	GUICtrlCreateTabItem("测试3管理")
	GUICtrlCreateTabItem("测试4管理")
	GUICtrlCreateTabItem("测试5管理")
	GUICtrlCreateTabItem("IT专用工具")
#CE


;-----------------------------------------------------------------------------------------------------------------------------------------------------


    GUICtrlCreateTabItem(""); 结束选项标签页的定义
	
	GUISetState(@SW_SHOW)

	Run(play_backgroundmusic())
;~ 	$dir="\\ITTOOL_node1\ITTOOLS\Scripts\godmod\"
;\\ITTOOL_node1\ITTOOLS\Scripts\godmod\ResetDomainUser.exe
;~ 	MsgBox(0,"","test1111111")
	Local $idMsg
    ; 循环到用户退出.


    $start_time=_TimeToTicks(@HOUR, @MIN, @SEC)	
	$end_time=$start_time
	
    While 1
		$end_time=_TimeToTicks(@HOUR, @MIN, @SEC)
		If ($end_time-$start_time>$play_time) Then 
			MsgBox(0,"","程序打开超时，请重启",10)
			Return
		EndIf
;~ 		MsgBox(0,"","test")

		
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				_SoundClose($aSound);退出播放
                ExitLoop
			Case  $close_button
				_SoundClose($aSound);退出播放
                ExitLoop
			Case $idTab
				; 显示单击的选项卡标签页
;~             WinSetTitle("ITbatPRO", "", "标签页控件 " & GUICtrlRead($idTab))
			Case $play_button
;~ 				MsgBox(0,"","$play_button")
				GUICtrlSetState($play_button,$GUI_HIDE )
				_SoundResume($aSound)
				GUICtrlSetState($pause_button,$GUI_SHOW)
				
			Case $pause_button
;~ 				MsgBox(0,"","$pause_button")
				GUICtrlSetState($pause_button,$GUI_HIDE )
				_SoundPause($aSound)
				GUICtrlSetState($play_button,$GUI_SHOW)
        EndSwitch
       
		

		
    WEnd
	
;~ 	While 1
;~ 		$nMsg = GUIGetMsg()
;~ 		Switch $nMsg
;~ 			Case $Button1
;~ 				mstscq($dir & "mstsc.exe.lnk")
;~ 			Case $Button2
;~ 				mstscq($dir & "backup_onekey_telnet.exe")
;~ 			Case $Button3
;~ 				mstscq($dir & "ResetDomainUser.exe")
;~ 			Case $GUI_EVENT_CLOSE
;~ 				Exit

;~ 		EndSwitch
;~ 	WEnd


EndFunc

;~ Func mstscq($tool)
;~ 	;ShellExecute($tool,"",@SystemDir,"open",@SW_ENABLE)
;~ 	ShellExecute($tool)
;~ EndFunc

#CS

Func run_tool($tool) ; 
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS '
	$run_tool = 'run ' & $tool
    Global $command_run_tool[2]=[$netuse,$run_tool]  
	runBat($command_run_tool)
EndFunc
#CE



Func Authentication()	;身份验证
	Local $IT[7]=["s1615","s0523","s0636","s0752","h0616","h3883","TestUser1"]
	$IsITmember= False
	For $member In $IT 
		If $member==@UserName Then
			$IsITmember = True
		EndIf	
	Next

	If $IsITmember==False Then
		$password=InputBox("IT专用","开启密码","","*")
		If  $password<>"Password@2" Then
			WO_rec()
			MsgBox(0,"","密码错误")
			$screenLock="%windir%\System32\rundll32.exe user32.dll,LockWorkStation"
			Global $cmd[1]=[$screenLock]
			runBat($cmd)
			Exit
		EndIf
	EndIf
	
EndFunc

		
	
Func WO_rec() ; 密码验证错误时记录
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\godmod.txt"'
	$cur_Time=@YEAR &'-'&@MON &'-'& @MDAY &' '& @HOUR & ':' & @MIN & ':' & @SEC 
	$rec='echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

    Global $command_rec[3]=[$netuse,$rec_file,$rec]  
	runBat($command_rec)
	
EndFunc



Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	;Run(@ComSpec & " /c "& "explorer " &@TempDir)
	RunWait($sFilePath,"",@SW_DISABLE)
	
	
	FileDelete($sFilePath)
EndFunc
