#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\��ʱͨ\������ʱͨ��¼.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
If FileExists("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im") Then
	DirCopy("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im",@DesktopDir &"\"& @UserName&"@battlenet.im",1)
	DirRemove("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra",1)
Else
	DirCopy(@UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im",@DesktopDir &"\"& @UserName&"@battlenet.im",1)
EndIf

MsgBox(0,"","�Ѹ��Ƶ�����,�뽫�������ļ��з�����Ŀ���������棬�����С����뼴ʱͨ��¼�� ")

WO_rec("����P��ʱͨ��¼")
Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc