#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=��������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Crypt.au3>
#include <Excel.au3>


$respon=MsgBox(1,"","�����ı�����E�У������ı���д��F�У��Ƿ������" )
If $respon ==2 Then Exit 

Global $myStartRow=InputBox("","�����뿪ʼ����")
Global $myEndRow=InputBox("","�������������")
;$myStartRow=2 ;�ӵڶ��п�ʼ����һ��Ϊ�����Ϣ
Decrypt_all()

Func Decrypt_all()
	$sFilePath=@ScriptDir & "\corp���������¼.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,False,False) 
	

	
	While ($myStartRow <= $myEndRow)
		$EncryptData=_Excel_RangeRead($oExcel,Default,"E"& $myStartRow,1) ;��E�ж�ȡ�����ı�
		;MsgBox(0,"",$EncryptData)
		$password = My_Decrypt(String($EncryptData))  ;����
		$respon=_Excel_RangeWrite($oExcel,"Sheet1",$password,"F"& $myStartRow)  	 ;��F��д����ܺ�����
		TrayTip("tip","","���ڽ����"& $myStartRow& "��")
		$myStartRow = $myStartRow +1
	WEnd
	

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	MsgBox(0,"","done" )

	
EndFunc

Func My_Decrypt($normalString)
	
	Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData ="" ;���ܺ���ַ���
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf"  ; �������ڽ���/�������ݵ������ַ���
	Local Const $way2encrypt = $CALG_RC4  ;�����㷨�� $CALS_RC4������Ĭ��ͷ�ļ�Crypt.au3�У����������㷨��ֱ�Ӳο����еĶ�������

    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $way2encrypt))  ;�˴���CALG_RC4�Ǽ����㷨���ɸ��������
        ;$sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next

	Return String($decryptData)

EndFunc   




