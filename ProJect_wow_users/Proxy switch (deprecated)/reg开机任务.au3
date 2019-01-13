#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\代理开关\reg开机任务.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
$RunDir = "\\ITTOOL_node1\ITTOOLS\Scripts\代理开关\开机脚本关闭代理.exe"
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy", "REG_SZ", $RunDir)




;~ MsgBox(0,"",RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy"))