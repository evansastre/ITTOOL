#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\ET安装.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
ShellExecuteWait("\\ITTOOL_node1\ITTOOLS\Conf\atlas\EasyTool.appref-ms")


If WinWaitActive("应用程序安装 - 安全警告","tableLayoutPanelQuestion",20)  Or WinWaitActive("Application Install - Security Warning","tableLayoutPanelQuestion",20) Then
	Send("!i")
EndIf

