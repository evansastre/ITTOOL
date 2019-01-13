#include <Crypt.CC.au3>
#include <Excel.CC.au3>


;~ If $CmdLine[1] == 0 Then 
;~ 	MsgBox(0,"","没有传入参数")
;~ 	Exit 
;~ EndIf


;~ $EMAIL=$Cmdline[1]  ;程序外传入参数
;~ $EMAIL="hzhuangshilei@corp.corpname.com"

;$Password=getCorpPSW($EMAIL)

;~ MsgBox(0,"Email",$EMAIL)
;~ MsgBox(0,"password",$Password)
;Exit MsgBox(0,"","1010")
;Exit  (2)    MsgBox(0,"",@EXITCODE)
;MsgBox(0,"",$Password)

Func getCorpPSW($EMAIL)
	
	$username=StringSplit($EMAIL,"@",1)[1]
			
	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False,"Password@2")
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName)
	$usr= $usr_arr[0][2] ;位置
	
	If $usr=="" Then
		MsgBox(0,"","没有corp邮箱信息,请手动配置或联系IT"& @error & @LF & @extended)
		Exit
	EndIf
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;所在行数
	$corp=_Excel_RangeRead($oExcel,Default,"C"& $row,1) ;读取表中corp邮箱地址
	If $username <> $corp Then   ;对比表中的地址和用户输入的地址是否一致
		MsgBox(0,"","corp邮箱地址与当前用户的账户不符,请重启程序进行配置")
		Exit
	EndIf
	
	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)
	
	If $psw=="" Then 
		MsgBox(0,"","没有您的密码信息，请自行填写或联系IT") 
		Exit
	EndIf
	
	$psw= My_Decrypt($psw)

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	;MsgBox(0,"",$psw )
	Return $psw 
	
EndFunc

;0xBD84C0B2A44E


Func My_Decrypt($normalString)
	;$normalString = InputBox("解密器","自此输入需要被解密的字符串")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;解密后明文
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; 声明用于解密/加密数据的密码字符串
	
    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $CALG_RC4))
        $sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; 使用加密密钥加密文本.
    Next


	;ClipPut($decryptData)
	
	Return $decryptData
EndFunc   


;\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx


