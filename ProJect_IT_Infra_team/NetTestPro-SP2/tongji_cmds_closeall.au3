#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile_x64=Release\cmds_closeall_x64.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
While ProcessExists("tcping.exe") Or ProcessExists("cmd.exe") Or ProcessExists("ping.exe")
	ProcessClose("tcping.exe")
	ProcessClose("ping.exe")
	ProcessClose("cmd.exe")
WEnd


FileDelete(@ScriptDir&"\wtee.exe")
FileDelete(@ScriptDir&"\tcping.exe")