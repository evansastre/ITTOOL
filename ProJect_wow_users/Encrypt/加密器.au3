#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=加密器.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <Crypt.au3>

My_Encrypt()

Func My_Encrypt()
	$normalString = InputBox("加密器","自此输入需要被加密的字符串")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $encryptData ="" ;加密后的字符串
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; 声明用于解密/加密数据的密码字符串
	Local Const $way2encrypt = $CALG_RC4  ;加密算法。 $CALS_RC4定义在默认头文件Crypt.au3中，其他加密算法可直接参看其中的定义名称

    For $iWord In $aStringsToEncrypt
		$encryptData =  _Crypt_EncryptData(String($iWord), $sUserKey, $way2encrypt)
        ;$sOutput &= $iWord & @TAB & " = " & $encryptData & @CRLF ; 使用加密密钥加密文本.
    Next


	ClipPut(String($encryptData))
	MsgBox(0,"","已复制到剪贴板，直接粘贴即可用")

EndFunc   


