#NoTrayIcon
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\donet4.6\dotNET4.6����_manual.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

;~ MsgBox(0,"","������װdotNET 4.6.2��������Confirm����ʼ��װ��" & @LF & "��װ�������������κ��������Լ��Ҫ3�������ң������ĵȴ���װ��ɡ�")
;~ Exit
;\\ITTOOL_node1\donet4.6\dotNET4.6����.exe
#include <TrayConstants.au3>
#include <File.au3>
$res=RegRead("HKLM\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v4\Full\","Version")

;�Ǳ�tip
Opt("TrayOnEventMode", 1) ; �������� OnEvent �¼�����֪ͨ.
Opt("TrayMenuMode", 3) ; Ĭ�����̲˵���Ŀ��������ʾ, ��ѡ����ĿʱҲ�����. TrayMenuMode ������ѡ��Ϊ 1, 2.
TrayCreateItem("˵��")
TrayItemSetOnEvent(-1, "show_Info")
TrayCreateItem("") ; �����ָ���.

TraySetState($TRAY_ICONSTATE_SHOW) ; ��ʾ���̲˵�.





If $res<>"4.6.01590" Then
	MsgBox(0,"","������װdotNET 4.6.2��������Confirm����ʼ��װ��" & @LF & "��װ�������������κ��������Լ��Ҫ3�������ң������ĵȴ���װ��ɡ�")
	
	$robocopy="robocopy \\ITTOOL_node1\donet4.6  %temp%  /XF dotNET4.6����.exe /E"
	$NDP462= "%temp%\NDP462.exe  /Q /NORESTART /lcid 1033"
	$NDP462CHS= "%temp%\NDP462CHS.exe  /Q /NORESTART /lcid 1033"

	Local $cmd[3]=[$robocopy,$NDP462,$NDP462CHS]
	
	TraySetToolTip("���ڰ�װ .NET ����ر�")
	TrayTip("tip","���ڰ�װ .NET ����ر�",240)
	
	runBat($cmd)
	
	MsgBox(0,"","dotNET4.6.2 ��װ���")
Else
	MsgBox(0,"","�Ѱ�װ.NET4.6.2,�����ظ�����")
	Exit
EndIf


	
	
Func show_Info()
	MsgBox(0,"","���ڰ�װ.NET4.6.2 �����ĵȴ�")
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