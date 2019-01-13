#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\donet4.6\dotNET4.6部署_manual.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

;~ MsgBox(0,"","即将安装dotNET 4.6.2。请点击『Confirm』开始安装。" & @LF & "安装过程中请勿开启任何软件，大约需要3分钟左右，请耐心等待安装完成。")
;~ Exit
;\\ITTOOL_node1\donet4.6\dotNET4.6部署.exe
#include <TrayConstants.au3>
#include <File.au3>
$res=RegRead("HKLM\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v4\Full\","Version")

;角标tip
Opt("TrayOnEventMode", 1) ; 启用托盘 OnEvent 事件函数通知.
Opt("TrayMenuMode", 3) ; 默认托盘菜单项目将不会显示, 当选定项目时也不检查. TrayMenuMode 的其它选项为 1, 2.
TrayCreateItem("说明")
TrayItemSetOnEvent(-1, "show_Info")
TrayCreateItem("") ; 创建分隔线.

TraySetState($TRAY_ICONSTATE_SHOW) ; 显示托盘菜单.





If $res<>"4.6.01590" Then
	MsgBox(0,"","即将安装dotNET 4.6.2。请点击『Confirm』开始安装。" & @LF & "安装过程中请勿开启任何软件，大约需要3分钟左右，请耐心等待安装完成。")
	
	$robocopy="robocopy \\ITTOOL_node1\donet4.6  %temp%  /XF dotNET4.6部署.exe /E"
	$NDP462= "%temp%\NDP462.exe  /Q /NORESTART /lcid 1033"
	$NDP462CHS= "%temp%\NDP462CHS.exe  /Q /NORESTART /lcid 1033"

	Local $cmd[3]=[$robocopy,$NDP462,$NDP462CHS]
	
	TraySetToolTip("正在安装 .NET 请勿关闭")
	TrayTip("tip","正在安装 .NET 请勿关闭",240)
	
	runBat($cmd)
	
	MsgBox(0,"","dotNET4.6.2 安装完成")
Else
	MsgBox(0,"","已安装.NET4.6.2,无需重复部署")
	Exit
EndIf


	
	
Func show_Info()
	MsgBox(0,"","正在安装.NET4.6.2 请耐心等待")
EndFunc


Func runBat($mycmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $mycmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

	Sleep(1000)
EndFunc