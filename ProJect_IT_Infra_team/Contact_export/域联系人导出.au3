#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=域联系人导出.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <Excel.au3>
#include <File.au3>
deal_the_csv()

Func deal_the_csv()
    $filename="\email.csv"
	$sFilePath=@ScriptDir & $filename
	$sFilePath_new=@ScriptDir & "\Contact.csv"
	FileCopy($sFilePath,$sFilePath_new,1)
	
	$hFile=FileOpen($sFilePath_new)
    $array=FileReadToArray($hFile)	
	$myEndRow=UBound($array,1);总行数
	
	_FileWriteToLine($sFilePath_new,1,"name,userPrincipalName,department,mail",1)
	$myStartRow=2 
	
	ProgressOn("正在执行",  "" , "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
	$delLine = 0 ;被删除的行数
	While ($myStartRow <= $myEndRow)
		$i= Round($myStartRow/$myEndRow*100,2) 
		ProgressSet($i, $myStartRow & "/" & $myEndRow )
		Local $contact = $array[$myStartRow-1+$delLine]
		
		If  delSpecial($contact)  Then
			_FileWriteToLine($sFilePath_new,$myStartRow,"",1)
			$myEndRow = $myEndRow -1
			$delLine = $delLine + 1 
			ContinueLoop
		EndIf
		
		$contact_arr = StringSplit($contact, 'DC=internal",',1)
		Local $i_contact = $contact_arr[2]
		_FileWriteToLine($sFilePath_new,$myStartRow,$i_contact,1)
		
		$myStartRow = $myStartRow +1
	WEnd
	
	ProgressSet(100, "完成", "进度状态:")
	ProgressOff()
	Sleep(3000) ;进度条完成后的停留时间
	
	;MsgBox(0,"","done" )
	FileClose($sFilePath_new)
	
	_Excel_BookSave ( $sFilePath_new )

	FileCopy($sFilePath_new,"\\ITTOOL_node1\ITTOOLS\Scripts\邮件联系人\",8+1)
EndFunc


Func delSpecial($contact)
	Local $special=["robot"]  ;"wowadmin","jira","auth","ogoss","wowpct","扫描仪","HR打字","bnoa","remote"]
	For $item In $special 
		If StringInStr($contact,$item) Then Return True
	Next
	
	If StringInStr($contact,"@mail.CorpDomain") Or  StringInStr($contact,"@corp.corpname.com") Then 
		Return False
	Else
		Return True 
	EndIf
EndFunc




