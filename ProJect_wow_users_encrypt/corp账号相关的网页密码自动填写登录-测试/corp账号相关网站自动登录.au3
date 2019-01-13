#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\corp账号相关网站自动登录.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <Crypt.au3>
#include <Excel.au3>

Global $webaddress=""
;$webaddress="ks.corpname.com"
GETMANUALINPUT($webaddress)

Local $info[2] 
$info = getCorpPSW() ;获取账号和密码
Global $mypopoAccount= $info[0] ;& "@corp.corpname.com"
Global $mypopoPassword= $info[1]


;~ MsgBox(0,"",$mypopoAccount &@LF &$mypopoPassword )
;~ 


If $webaddress == "ks.corpname.com" Then
	Login("ks.corpname.com")
ElseIf $webaddress == "doc.hz.corpname.com" Then
	Login_doc_hz("http://doc.hz.corpname.com/login.action?os_destination=%2Fhomepage.action")
;~ 	Login_doc_hz("http://doc.hz.corpname.com")
ElseIf $webaddress == "e-benefits.blz.corpname.com" Then
	Login("http://e-benefits.blz.corpname.com/e-benefits/main/eLeave.do")

EndIf

;http://e-benefits.blz.corpname.com/
Func KS($addr)
	Local $oIE =_IECreate($addr)                 ;打开登录地址
	;Local $oIE =_IECreate("https://login.corpname.com/accounts/login/")
	
	
	$FORM = _IETagNameGetCollection($oIE,"input") ;获取所有input标签
	;$FORM.uin.value=$mypopoAccount        ;填写账号框
	$FORM.uin.value="test"        ;填写账号框
	;$FORM.upass.value=$mypopoPassword       ;填写密码框
	
	_IELinkClickByText($oIE,"OpenId登录")

EndFunc


Func Login_doc_hz($addr)
	
	Local $oIE =_IECreate($addr)                 ;打开登录地址
	Sleep(3000)

	$FORM = _IETagNameGetCollection($oIE,"input") ;获取所有input标签
	$FORM.os_username.value=$mypopoAccount        ;填写账号框
	$FORM.os_password.value=$mypopoPassword       ;填写密码框
	
;~ 	MsgBox(0,"",$mypopoAccount&@LF&$mypopoPassword)
	
	Local $oForm =_IEFormGetCollection($oIE)    ;抓取表单集合
	For $i In $oForm 
		_IEFormElementCheckBoxSelect($i, "os_cookie", "", 1, "byIndex")  ;勾选记住登录，这里直接勾选所有记住项     1代表勾选，“byIndex”是在页面上体现出来
	Next
	
;~ 	_IEFormSubmit ($FORM)
	$submit = _IEGetObjById ($oIE, "loginButton")
	 _IEAction ($submit, "click")
EndFunc

Func Login($addr)
	
   ;登陆
	Local $oIE =_IECreate($addr)                 ;打开登录地址
	_IECreate($addr)    
	MsgBox(0,"",$addr)
	Exit
	
	
	$FORM = _IETagNameGetCollection($oIE,"input") ;获取所有input标签
	$FORM.corpid.value=$mypopoAccount        ;填写账号框
	$FORM.corppw.value=$mypopoPassword       ;填写密码框
	
	
	Local $oForm =_IEFormGetCollection($oIE)    ;抓取表单集合
	For $i In $oForm 
		_IEFormElementCheckBoxSelect($i, "remember", "", 1, "byIndex")  ;勾选记住登录，这里直接勾选所有记住项     1代表勾选，“byIndex”是在页面上体现出来
	Next

	Local $login =_IETagNameGetCollection($oIE, "button")
	
	If $webaddress == "1.163.com" Then
		$des_but=3 ;第三个button标志是1.163.com的“登录”Button
	ElseIf $webaddress == "ks.corpname.com" Then
		$des_but=2 	;第二个button标志是ks.corpname.com的“登录”Button
	ElseIf $webaddress == "e-benefits.blz.corpname.com" Then
		$des_but=1 ;第一个button标志是e-benefits.blz.corpname.com的“登录”Button
	EndIf
		
	$i=1
	For $elem In $login 
		If $i==$des_but Then	_IEAction($elem, "click")   
		$i=$i+1
	Next
	
	MsgBox(0,"","此登录过程用于保存你的网页登录密码，现已保存成功。"&@LF& "请使用IE浏览器打开你需要访问的网页，并点击登录。"&@LF&"将会自动关联到已保存的corp账号密码。")
	WO_rec("corp账号相关网站自动登录")

EndFunc


Func GETMANUALINPUT(ByRef $webaddress) 
	
	;附带图标
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("corp账号自动登录网站", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("请选择要登录的地址", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")
	;$USERNAMEEDIT = GUICtrlCreateInput(@UserName, 16, 32, 97, 21)
	;$LABEL2 = GUICtrlCreateLabel("@", 120, 32, 20, 24)$webaddress
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$DOMAINCOMBO = GUICtrlCreateCombo("", 74, 35, 137, 40, 3)
	GUICtrlSetData(-1, "ks.corpname.com|doc.hz.corpname.com|e-benefits.blz.corpname.com", "ks.corpname.com")
    $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 32, 72, 73, 25)
	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 168, 72, 73, 25)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	While 1
		$NMSG = GUIGetMsg()
		Select
			Case $NMSG = $CONFIRMBUTTON
				;$USERDISPLAYNAME = GUICtrlRead($USERNAMEEDIT)
				$webaddress = GUICtrlRead($DOMAINCOMBO)
				GUIDelete()
				Return False
			Case $NMSG = $CANCELBUTTON Or $NMSG = $GUI_EVENT_CLOSE
				GUIDelete()
				Return False
		EndSelect
	WEnd
	GUIDelete()
	Return True
EndFunc   ;==>GETMANUALINPUT



Func getCorpPSW()
	
	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False,"Password@2")
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName)
	$usr= $usr_arr[0][2] ;位置
	
	If $usr=="" Then
		MsgBox(0,"","没有corp邮箱信息,请手动配置或联系IT")
		Exit
	EndIf
	
	
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;所在行数
	$corp=_Excel_RangeRead($oExcel,Default,"C"& $row,1) ;读取表中corp邮箱地址

	
	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)  ;读取密码字段

	If $psw=="" Then 
		MsgBox(0,"","没有您的密码信息，请自行填写或联系IT") 
	EndIf
	
	$psw= My_Decrypt($psw)   ;解码

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	Local $myReturn[2]
	Local $myReturn[]= [$corp,$psw]

	
	Return $myReturn
	
EndFunc


Func My_Decrypt($normalString)
	;$normalString = InputBox("解密器","自此输入需要被解密的字符串")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;解密后明文
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM731bFc1q5GtBTT" ; (伪)声明用于解密/加密数据的密码字符串
	
    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $CALG_RC4))
        $sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; 使用加密密钥加密文本.
    Next


	
	Return $decryptData
EndFunc   

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
