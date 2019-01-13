$popo_dir="C:\Program Files (x86)\corpname\POPO\users"
If FileExists($popo_dir) Then
	DirCopy($popo_dir,@DesktopDir,1)
Else
	MsgBox(0,"",$popo_dir&" 不存在聊天记录")
EndIf

MsgBox(0,"","已复制到桌面,请将导出的文件夹放置于目标计算机桌面，再运行“导入popo记录” ")
WO_rec("导出POPO记录")
Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc