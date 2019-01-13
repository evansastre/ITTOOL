#include <Excel.au3>
Sync()

;~ Func showProgress()
;~ 	

;~ 	If Not ProcessExists("robocopy.exe") Then Return

;~ 	$arr=ProcessGetStats("robocopy.exe",1)
;~ 	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
;~ 	;$stdread = $arr[3]  ;& " MB"
;~ 	$i = Round($stdread/$item_dirSize,3)*100
;~ 	If ProcessExists("robocopy.exe") And $i>=99.999 then
;~ 		ProgressSet($i, " 即将完成，请勿关闭")
;~ 	Else
;~ 		ProgressSet($i, $stdread & "MB/" & $item_dirSize & "MB")
;~ 	EndIf

;~ EndFunc   ;==>showProgress

Func Sync()
	Static $time=1
	If $time > 3 Then
		MsgBox(0,"","错误次数太多，请确认后重启程序")
		Return
	EndIf
	$old=InputBox("tip","请输入原主机编号")
	;判断用户所输入的主机号是他自己的
	If $old=="" Then Return
	If Not IsMyComputer($old) Then
		$time += 1
		Sync()
		Return
	EndIf
	
	;重要提醒

	$choose=MsgBox(1,"","请确认当前程序在新机中使用，且还未存放【任何有用数据】在本机。" & _
						@LF&"从旧主机同步数据的操作会【完全】 覆盖当前新机的数据。" & _
						@LF & @LF & "是否继续？")
	If $choose==2 Then Return

	
	;获取到旧机器上的所有盘符，除C盘，因为C盘的同步内容需要单独定义
	Local $old_disk_array[0]
	For $item = Asc("D") To Asc("Z") Step 1
		$old_disk = "\\"& $old &"\" & Chr($item) &"$"  
		If FileExists($old_disk) Then
			_ArrayAdd($old_disk_array,$old_disk)
		EndIf
	Next
	_ArrayDisplay($old_disk_array)
	

		
	
;~ 	$dirsize=Round(DirGetSize("\\"& $old &"\E$")/1024/1024/1024,1)   ;当前位置的总量
;~ 	$driverDpaceFree=Round(DriveSpaceFree("E:\")/1024,1)  ;盘符剩余空间
;~ 	MsgBox(0,"","原磁盘：" &$dirsize & " GB" &  @LF & "当前E盘剩余空间" & $driverDpaceFree & " GB")
;~ 	
	;ShellExecute("robocopy","D:\games\Hearthstone E:\Hearthstone /mir")
	
	
	
;~ 	Sleep(1000)
;~ 	WO_rec("dataTrans_Recovery")
;~ 	MsgBox(0,"","同步已完成，请确认数据完整性")
EndFunc

Func IsMyComputer($num)

	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\资产\资产表.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False)
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName)
	$usr= $usr_arr[0][2] ;位置
	
	If $usr=="" Then
		MsgBox(0,"","没有您的原主机资产信息，请联系IT")
		Return False
	EndIf
	
	$row=StringRight($usr,1)  ;所在行数
	$Num_in_sheet=_Excel_RangeRead($oExcel,Default,"B"& $row,1) ;读取表中资产编号

	If $Num_in_sheet <> $num Then 
		MsgBox(0,"","输入的旧主机编号不与当前用户匹配，请重新输入") 
		Return False
	EndIf
	
	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	Return True
	
EndFunc




