#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������\reg��������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
$RunDir = "\\ITTOOL_node1\ITTOOLS\Scripts\������\�����ű��رմ���.exe"
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy", "REG_SZ", $RunDir)




;~ MsgBox(0,"",RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run","CloseProxy"))