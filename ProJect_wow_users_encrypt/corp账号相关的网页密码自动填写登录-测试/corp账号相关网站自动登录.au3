#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\corp�˺������վ�Զ���¼.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <Crypt.au3>
#include <Excel.au3>

Global $webaddress=""
;$webaddress="ks.corpname.com"
GETMANUALINPUT($webaddress)

Local $info[2] 
$info = getCorpPSW() ;��ȡ�˺ź�����
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
	Local $oIE =_IECreate($addr)                 ;�򿪵�¼��ַ
	;Local $oIE =_IECreate("https://login.corpname.com/accounts/login/")
	
	
	$FORM = _IETagNameGetCollection($oIE,"input") ;��ȡ����input��ǩ
	;$FORM.uin.value=$mypopoAccount        ;��д�˺ſ�
	$FORM.uin.value="test"        ;��д�˺ſ�
	;$FORM.upass.value=$mypopoPassword       ;��д�����
	
	_IELinkClickByText($oIE,"OpenId��¼")

EndFunc


Func Login_doc_hz($addr)
	
	Local $oIE =_IECreate($addr)                 ;�򿪵�¼��ַ
	Sleep(3000)

	$FORM = _IETagNameGetCollection($oIE,"input") ;��ȡ����input��ǩ
	$FORM.os_username.value=$mypopoAccount        ;��д�˺ſ�
	$FORM.os_password.value=$mypopoPassword       ;��д�����
	
;~ 	MsgBox(0,"",$mypopoAccount&@LF&$mypopoPassword)
	
	Local $oForm =_IEFormGetCollection($oIE)    ;ץȡ������
	For $i In $oForm 
		_IEFormElementCheckBoxSelect($i, "os_cookie", "", 1, "byIndex")  ;��ѡ��ס��¼������ֱ�ӹ�ѡ���м�ס��     1����ѡ����byIndex������ҳ�������ֳ���
	Next
	
;~ 	_IEFormSubmit ($FORM)
	$submit = _IEGetObjById ($oIE, "loginButton")
	 _IEAction ($submit, "click")
EndFunc

Func Login($addr)
	
   ;��½
	Local $oIE =_IECreate($addr)                 ;�򿪵�¼��ַ
	_IECreate($addr)    
	MsgBox(0,"",$addr)
	Exit
	
	
	$FORM = _IETagNameGetCollection($oIE,"input") ;��ȡ����input��ǩ
	$FORM.corpid.value=$mypopoAccount        ;��д�˺ſ�
	$FORM.corppw.value=$mypopoPassword       ;��д�����
	
	
	Local $oForm =_IEFormGetCollection($oIE)    ;ץȡ������
	For $i In $oForm 
		_IEFormElementCheckBoxSelect($i, "remember", "", 1, "byIndex")  ;��ѡ��ס��¼������ֱ�ӹ�ѡ���м�ס��     1����ѡ����byIndex������ҳ�������ֳ���
	Next

	Local $login =_IETagNameGetCollection($oIE, "button")
	
	If $webaddress == "1.163.com" Then
		$des_but=3 ;������button��־��1.163.com�ġ���¼��Button
	ElseIf $webaddress == "ks.corpname.com" Then
		$des_but=2 	;�ڶ���button��־��ks.corpname.com�ġ���¼��Button
	ElseIf $webaddress == "e-benefits.blz.corpname.com" Then
		$des_but=1 ;��һ��button��־��e-benefits.blz.corpname.com�ġ���¼��Button
	EndIf
		
	$i=1
	For $elem In $login 
		If $i==$des_but Then	_IEAction($elem, "click")   
		$i=$i+1
	Next
	
	MsgBox(0,"","�˵�¼�������ڱ��������ҳ��¼���룬���ѱ���ɹ���"&@LF& "��ʹ��IE�����������Ҫ���ʵ���ҳ���������¼��"&@LF&"�����Զ��������ѱ����corp�˺����롣")
	WO_rec("corp�˺������վ�Զ���¼")

EndFunc


Func GETMANUALINPUT(ByRef $webaddress) 
	
	;����ͼ��
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("corp�˺��Զ���¼��վ", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("��ѡ��Ҫ��¼�ĵ�ַ", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")
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
	$usr= $usr_arr[0][2] ;λ��
	
	If $usr=="" Then
		MsgBox(0,"","û��corp������Ϣ,���ֶ����û���ϵIT")
		Exit
	EndIf
	
	
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;��������
	$corp=_Excel_RangeRead($oExcel,Default,"C"& $row,1) ;��ȡ����corp�����ַ

	
	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)  ;��ȡ�����ֶ�

	If $psw=="" Then 
		MsgBox(0,"","û������������Ϣ����������д����ϵIT") 
	EndIf
	
	$psw= My_Decrypt($psw)   ;����

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	Local $myReturn[2]
	Local $myReturn[]= [$corp,$psw]

	
	Return $myReturn
	
EndFunc


Func My_Decrypt($normalString)
	;$normalString = InputBox("������","�Դ�������Ҫ�����ܵ��ַ���")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;���ܺ�����
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM731bFc1q5GtBTT" ; (α)�������ڽ���/�������ݵ������ַ���
	
    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $CALG_RC4))
        $sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next


	
	Return $decryptData
EndFunc   

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
