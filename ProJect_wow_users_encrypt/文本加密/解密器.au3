#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Crypt.au3>

My_Decrypt()

Func My_Decrypt()
	$password="Password@22"
	$password_input=InputBox("������","�������������")
	If $password<>$password_input Then
		MsgBox(0,"","�����ȷ")
		Exit
	EndIf
	
	ShellExecute("\\ITTOOL_node1\ITTOOLS\Conf\Corp.xlsx","open")
	
	$normalString = InputBox("������","�Դ�������Ҫ�����ܵ��ַ���")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;���ܺ�����
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; �������ڽ���/�������ݵ������ַ���
	Local Const $way2encrypt = $CALG_RC4  ;�����㷨�� $CALS_RC4������Ĭ��ͷ�ļ�Crypt.au3�У����������㷨��ֱ�Ӳο����еĶ�������
	
    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $way2encrypt))
        ;$sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next

	
	ClipPut(String($decryptData))
;~ 	My_Decrypt()
EndFunc   

