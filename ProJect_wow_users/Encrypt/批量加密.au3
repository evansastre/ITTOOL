#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=��������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Crypt.au3>
#include <Excel.au3>


$respon=MsgBox(1,"","�������ı�����D�У������ı���д��E�У��Ƿ������" )
If $respon ==2 Then Exit 

Global $myStartRow=InputBox("","�����뿪ʼ����")
Global $myEndRow=InputBox("","�������������")

Encrypt_all()

Func Encrypt_all()
	
	$sFilePath=@ScriptDir & "\corp���������¼.xlsx"
	;$sFilePath="E:\MyDoc\ITtools\wow�û���Ŀ\�ı�����\corp���������¼.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,False,False) 
	

	;$myStartRow=2 ;�ӵڶ��п�ʼ����һ��Ϊ�����Ϣ
	While ($myStartRow <= $myEndRow)
		$password=_Excel_RangeRead($oExcel,"Sheet1","D"& $myStartRow,1) ;��D�ж�ȡpassword
		
		$EncryptData = My_Encrypt($password)  ;����

		$respon=_Excel_RangeWrite($oExcel,"Sheet1",$EncryptData,"E"& $myStartRow)  	 ;��E��д����ܺ�����
		

		$myStartRow = $myStartRow +1
	WEnd
	

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	MsgBox(0,"","done" )

	
EndFunc

Func My_Encrypt($normalString)
	
	Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $encryptData ="" ;���ܺ���ַ���
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf"  ; �������ڽ���/�������ݵ������ַ���
	Local Const $way2encrypt = $CALG_RC4  ;�����㷨�� $CALS_RC4������Ĭ��ͷ�ļ�Crypt.au3�У����������㷨��ֱ�Ӳο����еĶ�������

    For $iWord In $aStringsToEncrypt
		$encryptData =  _Crypt_EncryptData(String($iWord), $sUserKey, $way2encrypt)  ;�˴���CALG_RC4�Ǽ����㷨���ɸ��������
        ;$sOutput &= $iWord & @TAB & " = " & $encryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next

	Return String($encryptData)

EndFunc   



