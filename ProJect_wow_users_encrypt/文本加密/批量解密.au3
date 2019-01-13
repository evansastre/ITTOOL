#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=批量解密.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <Crypt.au3>
#include <Excel.au3>


$respon=MsgBox(1,"","密文文本置于E列，解密文本将写至F列，是否继续？" )
If $respon ==2 Then Exit 

Global $myStartRow=InputBox("","请输入开始行数")
Global $myEndRow=InputBox("","请输入结束行数")
;$myStartRow=2 ;从第二行开始，第一行为类别信息
Decrypt_all()

Func Decrypt_all()
	$sFilePath=@ScriptDir & "\corp邮箱密码记录.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,False,False) 
	

	
	While ($myStartRow <= $myEndRow)
		$EncryptData=_Excel_RangeRead($oExcel,Default,"E"& $myStartRow,1) ;从E列读取加密文本
		;MsgBox(0,"",$EncryptData)
		$password = My_Decrypt(String($EncryptData))  ;解密
		$respon=_Excel_RangeWrite($oExcel,"Sheet1",$password,"F"& $myStartRow)  	 ;在F列写入解密后数据
		TrayTip("tip","","正在解码第"& $myStartRow& "行")
		$myStartRow = $myStartRow +1
	WEnd
	

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	MsgBox(0,"","done" )

	
EndFunc

Func My_Decrypt($normalString)
	
	Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData ="" ;解密后的字符串
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf"  ; 声明用于解密/加密数据的密码字符串
	Local Const $way2encrypt = $CALG_RC4  ;加密算法。 $CALS_RC4定义在默认头文件Crypt.au3中，其他加密算法可直接参看其中的定义名称

    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $way2encrypt))  ;此处的CALG_RC4是加密算法，可根据需求改
        ;$sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; 使用加密密钥加密文本.
    Next

	Return String($decryptData)

EndFunc   




