#RequireAdmin
#PRE_UseX64=n

#include <winAPI.au3>
#include <math.au3>
;~ $path="C:\Users\TestUser1\Desktop\WanDrv6_Win10.x64\"


Main()

Func Main()
	Global $path=judgeLocation()
	Exit
		
	If Not ProcessExists("WanDrv6(Win10.x64).exe") Then
		ShellExecute($path&"WanDrv6(Win10.x64).exe")
	Else
		;
		WinSetState ( "万能驱动助理 (Win10.x64 专用) - IT天空出品","",@SW_ENABLE )
		WinActivate("万能驱动助理 (Win10.x64 专用) - IT天空出品","")
	EndIf

	;mainWindow
	WinWaitActive("万能驱动助理 (Win10.x64 专用) - IT天空出品","")
	Local $ProcessId = WinGetHandle("万能驱动助理 (Win10.x64 专用) - IT天空出品", "开始")
	_WinAPI_PostMessage($ProcessId, 256, 13, 0);256按下 13是回车键
	_WinAPI_PostMessage($ProcessId, 257, 13, 0);257弹起 13是回车键

	;Info
	WinWaitActive("信息","Confirm")
	Local $ProcessId_Info = WinGetHandle("信息", "Confirm")
	ControlClick($ProcessId_Info,"","[CLASS:Button; INSTANCE:1]")

	;In case
	Sleep(2000)
	If WinExists("信息","解压目录已存在，是否删除？") Then 
		Local $ProcessId_Info = WinGetHandle("信息", "是(&Y)")
		ControlClick($ProcessId_Info,"","[CLASS:Button; INSTANCE:1]")
	;~ 	MsgBox(0,"","ssss")
	EndIf
EndFunc


Func judgeLocation()
	
	Local $location
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		$file_server='\\shcw01\WanDrv6_Win10.x64\'
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
		$file_server='\\hzcw01\WanDrv6_Win10.x64\'
	EndIf
	
	
	MsgBox(0,"","location:"&$location)
	If FileExists($file_server) Then
		MsgBox(0,"",$file_server&"路径可用")
		Return $file_server
	Else
		MsgBox(0,"",$file_server&"路径不可用")
	EndIf
	
EndFunc

;Reboot
;~ WinWaitActive("信息","某些驱动可能需要重新启动计算机后才会生效")
;~ Local $ProcessId_Info = WinGetHandle("信息", "是(&Y)")
;~ ControlClick($ProcessId_Info,"","[CLASS:Button; INSTANCE:1]")


;~ Local $hWnd=WinWait("万能驱动助理 (Win10.x64 专用) - IT天空出品","")
;~ Local $hWnd=WinWait("万能驱动助理 (Win10.x64 专用) - IT天空出品","")
;~ MsgBox(0,"",$hWnd)
;~ MsgBox(0,"","111")
;~ ControlClick($hWnd,"","[CLASS:Button; INSTANCE:25]")
;~ ControlClick($hWnd,"","Button25")
;~ MsgBox(0,"",$res)