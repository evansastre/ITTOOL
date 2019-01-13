#RequireAdmin
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#PRE_OutFile_x64=DriversInstall_win10.exe
#PRE_Res_Language=2052
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

#include <winAPI.au3>
#include <math.au3>
;~ $path="C:\Users\TestUser1\Desktop\WanDrv6_Win10.x64\"  ; for test


Main()

Func Main()
	Global $path=judgeLocation()
;~ 	$path='\\shcw01\WanDrv6_Win10.x64\'  ; for test
	
	If Not ProcessExists("WanDrv6(Win10.x64).exe") Then
		ShellExecute($path&"WanDrv6(Win10.x64).exe")
	Else
		;
		WinSetState ( "������������ (Win10.x64 ר��) - IT��ճ�Ʒ","",@SW_ENABLE )
		WinActivate("������������ (Win10.x64 ר��) - IT��ճ�Ʒ","")
	EndIf

	;mainWindow
	WinWaitActive("������������ (Win10.x64 ר��) - IT��ճ�Ʒ","")
	Local $ProcessId = WinGetHandle("������������ (Win10.x64 ר��) - IT��ճ�Ʒ", "��ʼ")
	_WinAPI_PostMessage($ProcessId, 256, 13, 0);256���� 13�ǻس���
	_WinAPI_PostMessage($ProcessId, 257, 13, 0);257���� 13�ǻس���

	;Info
	WinWaitActive("��Ϣ","Confirm")
	Local $ProcessId_Info = WinGetHandle("��Ϣ", "Confirm")
	ControlClick($ProcessId_Info,"","[CLASS:Button; INSTANCE:1]")

	;In case
	Sleep(2000)
	If WinExists("��Ϣ","��ѹĿ¼�Ѵ��ڣ��Ƿ�ɾ����") Then 
		Local $ProcessId_Info = WinGetHandle("��Ϣ", "��(&Y)")
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
	
	If FileExists($file_server) Then
;~ 		MsgBox(0,"",$file_server&"·������",1)
		Return $file_server
	Else
		MsgBox(0,"",$file_server&"·��������")
		Exit ;for test 
	EndIf
	
EndFunc

;Reboot
;~ WinWaitActive("��Ϣ","ĳЩ����������Ҫ���������������Ż���Ч")
;~ Local $ProcessId_Info = WinGetHandle("��Ϣ", "��(&Y)")
;~ ControlClick($ProcessId_Info,"","[CLASS:Button; INSTANCE:1]")


;~ Local $hWnd=WinWait("������������ (Win10.x64 ר��) - IT��ճ�Ʒ","")
;~ Local $hWnd=WinWait("������������ (Win10.x64 ר��) - IT��ճ�Ʒ","")
;~ MsgBox(0,"",$hWnd)
;~ MsgBox(0,"","111")
;~ ControlClick($hWnd,"","[CLASS:Button; INSTANCE:25]")
;~ ControlClick($hWnd,"","Button25")
;~ MsgBox(0,"",$res)