#include <Crypt.CC.au3>
#include <Excel.CC.au3>


;~ If $CmdLine[1] == 0 Then 
;~ 	MsgBox(0,"","û�д������")
;~ 	Exit 
;~ EndIf


;~ $EMAIL=$Cmdline[1]  ;�����⴫�����
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
	$usr= $usr_arr[0][2] ;λ��
	
	If $usr=="" Then
		MsgBox(0,"","û��corp������Ϣ,���ֶ����û���ϵIT"& @error & @LF & @extended)
		Exit
	EndIf
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;��������
	$corp=_Excel_RangeRead($oExcel,Default,"C"& $row,1) ;��ȡ����corp�����ַ
	If $username <> $corp Then   ;�Աȱ��еĵ�ַ���û�����ĵ�ַ�Ƿ�һ��
		MsgBox(0,"","corp�����ַ�뵱ǰ�û����˻�����,�����������������")
		Exit
	EndIf
	
	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)
	
	If $psw=="" Then 
		MsgBox(0,"","û������������Ϣ����������д����ϵIT") 
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
	;$normalString = InputBox("������","�Դ�������Ҫ�����ܵ��ַ���")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;���ܺ�����
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; �������ڽ���/�������ݵ������ַ���
	
    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $CALG_RC4))
        $sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next


	;ClipPut($decryptData)
	
	Return $decryptData
EndFunc   


;\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx


