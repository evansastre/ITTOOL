#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\ET��װ.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
ShellExecuteWait("\\ITTOOL_node1\ITTOOLS\Conf\atlas\EasyTool.appref-ms")


If WinWaitActive("Ӧ�ó���װ - ��ȫ����","tableLayoutPanelQuestion",20)  Or WinWaitActive("Application Install - Security Warning","tableLayoutPanelQuestion",20) Then
	Send("!i")
EndIf

