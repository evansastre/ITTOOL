#include <Excel.au3>
deal_the_csv()

Func deal_the_csv()
	
;~ 	$sFilePath=@ScriptDir & "\test.xlsx"

    Global $filename="\email2.csv"
	$sFilePath=@ScriptDir & $filename
;~ 	Local $oAppl = _Excel_Open(False)
;~ 	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,False,False) 
		
;~ 	_Excel_RangeWrite($oExcel,"email1","DN","B1")


	$file=FileOpen($sFilePath)
    $array=FileReadToArray($file)
	MsgBox(0,"",@error & @LF & @extended)
	For $i In $array 
		MsgBox(0,"",$i)
	Next
	
	$myEndRow=UBound($array,1)
	MsgBox(0,"",$myEndRow)
	Exit
	
;~ 	$myEndRow = $oExcel.ActiveSheet.Range("A1").SpecialCells($xlCellTypeLastCell).Row	
	$myStartRow=2 
	;
	
	ProgressOn("����ִ��",  "" , "0 %", -1, -1, 16) ;-1�����м����꣬16Ϊ���϶�
	;AdlibRegister("showProgress", 250)
	
	While ($myStartRow <= $myEndRow)
		$i= Round($myStartRow/$myEndRow*100,2) 
		ProgressSet($i, $myStartRow & "/" & $myEndRow )
;~ 		Sleep(500)
;~ 		$contact= _Excel_RangeRead($oExcel,$filename,"A"& $myStartRow,1) ;��A�ж�ȡ���˵�ȫ������
;~ 		$array1=StringSplit($contact,"DC=internal,",1)
;~ 		$DN=_Excel_RangeWrite($oExcel,$filename,$array1[1]&"DC=internal","B"& $myStartRow)  	 ;��B��д�봦�������
;~ 		$Info=_Excel_RangeWrite($oExcel,$filename,$array1[2],"C"& $myStartRow)  	 ;��B��д�봦�������
;~ 		 
		 
		 
;~ 		$array2=StringSplit($array1[2],",")
;~ 		$name=_Excel_RangeWrite($oExcel,"email1",$array2[1],"C"& $myStartRow)
;~ 		$userPrincipalName=_Excel_RangeWrite($oExcel,"email1",$array2[2],"D"& $myStartRow)
;~ 		$department=_Excel_RangeWrite($oExcel,"email1",$array2[3],"E"& $myStartRow)
;~ 		$mail=_Excel_RangeWrite($oExcel,"email1",$array2[4],"F"& $myStartRow)

		$myStartRow = $myStartRow +1
	WEnd
	
	;AdlibUnRegister("showProgress")
	ProgressSet(100, "���", "����״̬:")
	ProgressOff()
	Sleep(3000) ;��������ɺ��ͣ��ʱ��
	

;~ 	_Excel_BookClose($oExcel,True)
;~ 	_Excel_Close($oAppl,True)
	
	MsgBox(0,"","done" )

	
EndFunc


Func getContact($oExcel,$myStartRow)
	Return _Excel_RangeRead($oExcel,$filename,"A"& $myStartRow,1) ;��A�ж�ȡ���˵�ȫ������
EndFunc




