#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Crypt.au3>

My_Encrypt()

Func My_Encrypt()
	$normalString = InputBox("������","�Դ�������Ҫ�����ܵ��ַ���")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $encryptData ="" ;���ܺ���ַ���
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; �������ڽ���/�������ݵ������ַ���
	Local Const $way2encrypt = $CALG_RC4  ;�����㷨�� $CALS_RC4������Ĭ��ͷ�ļ�Crypt.au3�У����������㷨��ֱ�Ӳο����еĶ�������

    For $iWord In $aStringsToEncrypt
		$encryptData =  _Crypt_EncryptData(String($iWord), $sUserKey, $way2encrypt)
        ;$sOutput &= $iWord & @TAB & " = " & $encryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next


	ClipPut(String($encryptData))
	MsgBox(0,"","�Ѹ��Ƶ������壬ֱ��ճ��������")

EndFunc   


