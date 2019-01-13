#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\即时通\导出即时通记录.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
If FileExists("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im") Then
	DirCopy("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im",@DesktopDir &"\"& @UserName&"@battlenet.im",1)
	DirRemove("C:\Users\h3883\AppData\Roaming\corpname\Popoem-Intra",1)
Else
	DirCopy(@UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\users\"&@UserName&"@battlenet.im",@DesktopDir &"\"& @UserName&"@battlenet.im",1)
EndIf

MsgBox(0,"","已复制到桌面,请将导出的文件夹放置于目标计算机桌面，再运行“导入即时通记录” ")

WO_rec("导出P即时通记录")
Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc