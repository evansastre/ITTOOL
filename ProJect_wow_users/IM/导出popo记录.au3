$popo_dir="C:\Program Files (x86)\corpname\POPO\users"
If FileExists($popo_dir) Then
	DirCopy($popo_dir,@DesktopDir,1)
Else
	MsgBox(0,"",$popo_dir&" �����������¼")
EndIf

MsgBox(0,"","�Ѹ��Ƶ�����,�뽫�������ļ��з�����Ŀ���������棬�����С�����popo��¼�� ")
WO_rec("����POPO��¼")
Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc