#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\Tools_Support_Interior.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
;DirRemove(@DesktopDir & "\Tools_Support Interior",1)
DirCopy("\\ITTOOL_node1\ITTOOLS\Scripts\Tools_Support Interior",@DesktopDir & "\Tools_Support Interior",1)
ShellExecute("explorer",@DesktopDir & "\Tools_Support Interior")
MsgBox(0,"","��������ɣ�������� Tools_Support Interior �ļ���")

WO_rec("����Tools_Support Interior")


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc