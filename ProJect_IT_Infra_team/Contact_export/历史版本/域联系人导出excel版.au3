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
	
	ProgressOn("正在执行",  "" , "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
	;AdlibRegister("showProgress", 250)
	
	While ($myStartRow <= $myEndRow)
		$i= Round($myStartRow/$myEndRow*100,2) 
		ProgressSet($i, $myStartRow & "/" & $myEndRow )
;~ 		Sleep(500)
;~ 		$contact= _Excel_RangeRead($oExcel,$filename,"A"& $myStartRow,1) ;从A列读取单人的全部数据
;~ 		$array1=StringSplit($contact,"DC=internal,",1)
;~ 		$DN=_Excel_RangeWrite($oExcel,$filename,$array1[1]&"DC=internal","B"& $myStartRow)  	 ;在B列写入处理后数据
;~ 		$Info=_Excel_RangeWrite($oExcel,$filename,$array1[2],"C"& $myStartRow)  	 ;在B列写入处理后数据
;~ 		 
		 
		 
;~ 		$array2=StringSplit($array1[2],",")
;~ 		$name=_Excel_RangeWrite($oExcel,"email1",$array2[1],"C"& $myStartRow)
;~ 		$userPrincipalName=_Excel_RangeWrite($oExcel,"email1",$array2[2],"D"& $myStartRow)
;~ 		$department=_Excel_RangeWrite($oExcel,"email1",$array2[3],"E"& $myStartRow)
;~ 		$mail=_Excel_RangeWrite($oExcel,"email1",$array2[4],"F"& $myStartRow)

		$myStartRow = $myStartRow +1
	WEnd
	
	;AdlibUnRegister("showProgress")
	ProgressSet(100, "完成", "进度状态:")
	ProgressOff()
	Sleep(3000) ;进度条完成后的停留时间
	

;~ 	_Excel_BookClose($oExcel,True)
;~ 	_Excel_Close($oAppl,True)
	
	MsgBox(0,"","done" )

	
EndFunc


Func getContact($oExcel,$myStartRow)
	Return _Excel_RangeRead($oExcel,$filename,"A"& $myStartRow,1) ;从A列读取单人的全部数据
EndFunc




