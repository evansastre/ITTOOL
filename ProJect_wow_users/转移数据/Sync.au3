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
;~ 		ProgressSet($i, " ������ɣ�����ر�")
;~ 	Else
;~ 		ProgressSet($i, $stdread & "MB/" & $item_dirSize & "MB")
;~ 	EndIf

;~ EndFunc   ;==>showProgress

Func Sync()
	Static $time=1
	If $time > 3 Then
		MsgBox(0,"","�������̫�࣬��ȷ�Ϻ���������")
		Return
	EndIf
	$old=InputBox("tip","������ԭ�������")
	;�ж��û�������������������Լ���
	If $old=="" Then Return
	If Not IsMyComputer($old) Then
		$time += 1
		Sync()
		Return
	EndIf
	
	;��Ҫ����

	$choose=MsgBox(1,"","��ȷ�ϵ�ǰ�������»���ʹ�ã��һ�δ��š��κ��������ݡ��ڱ�����" & _
						@LF&"�Ӿ�����ͬ�����ݵĲ����᡾��ȫ�� ���ǵ�ǰ�»������ݡ�" & _
						@LF & @LF & "�Ƿ������")
	If $choose==2 Then Return

	
	;��ȡ���ɻ����ϵ������̷�����C�̣���ΪC�̵�ͬ��������Ҫ��������
	Local $old_disk_array[0]
	For $item = Asc("D") To Asc("Z") Step 1
		$old_disk = "\\"& $old &"\" & Chr($item) &"$"  
		If FileExists($old_disk) Then
			_ArrayAdd($old_disk_array,$old_disk)
		EndIf
	Next
	_ArrayDisplay($old_disk_array)
	

		
	
;~ 	$dirsize=Round(DirGetSize("\\"& $old &"\E$")/1024/1024/1024,1)   ;��ǰλ�õ�����
;~ 	$driverDpaceFree=Round(DriveSpaceFree("E:\")/1024,1)  ;�̷�ʣ��ռ�
;~ 	MsgBox(0,"","ԭ���̣�" &$dirsize & " GB" &  @LF & "��ǰE��ʣ��ռ�" & $driverDpaceFree & " GB")
;~ 	
	;ShellExecute("robocopy","D:\games\Hearthstone E:\Hearthstone /mir")
	
	
	
;~ 	Sleep(1000)
;~ 	WO_rec("dataTrans_Recovery")
;~ 	MsgBox(0,"","ͬ������ɣ���ȷ������������")
EndFunc

Func IsMyComputer($num)

	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\�ʲ�\�ʲ���.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False)
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName)
	$usr= $usr_arr[0][2] ;λ��
	
	If $usr=="" Then
		MsgBox(0,"","û������ԭ�����ʲ���Ϣ������ϵIT")
		Return False
	EndIf
	
	$row=StringRight($usr,1)  ;��������
	$Num_in_sheet=_Excel_RangeRead($oExcel,Default,"B"& $row,1) ;��ȡ�����ʲ����

	If $Num_in_sheet <> $num Then 
		MsgBox(0,"","����ľ�������Ų��뵱ǰ�û�ƥ�䣬����������") 
		Return False
	EndIf
	
	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	Return True
	
EndFunc




