#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\�������ù���.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

;~ #include <Array.au3>
;~ #include <Memory.au3>
;~ #include <WinAPI.au3>
;~ #include <Security.au3>
;~ #include <SecurityConstants.au3>
;~ #include <SendMessage.au3>
;~ #include <Date.au3>
;~ #include <File.au3>
;#include <AD_custom.au3>
;~ #include <FTPEx.au3>
#include <GUIConstantsEx.au3>

#Include "Func_getCorpPSW.au3"

$G_OUTLOOKPATH = ""  ;outlook·��
$G_OUTLOOKVER = ""    ;outlook�汾
Func OACSETUP(Const $SERVERTYPE)
	While ProcessExists("outlook.exe") ;��⵱ǰ��outlook�����Ƿ����
		$BUTTONPRESSED = MsgBox(5, "���棡", "���ȹر�outlook���������ù���")
		If $BUTTONPRESSED = 4 Then
			ContinueLoop
		ElseIf $BUTTONPRESSED = 2 Then
			Exit
		EndIf
	WEnd
	$G_OUTLOOKPATH = GETOUTLOOKINSTALLPATH() ;outlook��װ·��
	$G_OUTLOOKVER = GETOUTLOOKVERSION()      ;outlook�汾

	If $G_OUTLOOKPATH = "" Or $G_OUTLOOKVER = "" Or (Not FileExists($G_OUTLOOKPATH)) Then 
		MsgBox(0, "���棡", "��û����ȷ�ذ�װOutlook��")
		Exit
	EndIf
	
	;�ʼ����շ��������ã����ݷ���������ѡ�����շ�ʽ
	If $SERVERTYPE = "pop3" Then
		FileDelete(@TempDir & "\ap_2010.PRF")
		FileDelete(@TempDir & "\ap_2007.PRF")
		FileDelete(@TempDir & "\ap_2003.PRF")
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
		FileInstall(".\pop3_2007.PRF", @TempDir & "\ap_2007.PRF", 1)
		FileInstall(".\pop3_2003.PRF", @TempDir & "\ap_2003.PRF", 1)
;~ 	Else
;~ 		FileInstall(".\imap_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
;~ 		FileInstall(".\imap_2007.PRF", @TempDir & "\ap_2007.PRF", 1)
;~ 		FileInstall(".\imap_2003.PRF", @TempDir & "\ap_2003.PRF", 1)
	EndIf

	;����ͼ��
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	
	$PSTFILEDIR = "E:\mail"  ;�����ʼ����ݴ洢��Ĭ��·��
	If DriveStatus("E:\") <> "READY" Then ;���E�̲����ڣ�������C��
		$PSTFILEDIR = "C:\mail"
	EndIf
	
	$PRODUCTVER = GETOUTLOOKPRODUCTVERSION() ;�汾�ţ�2010��Ϊ14��2007Ϊ12
	

	;�޸�ע����ֵ��ָ�������ļ��洢·��
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	
	
	$EMAIL = ""          ;�ʼ���ַ
	$DISPLAYNAME = ""   ;��ʾ��������
	$EMAILDOMAIN = ""   ;�ʼ��� @mail.CorpDomain
	If (@LogonDNSDomain = "CorpDomain.internal") And (Ping("dc5") <> "0" ) = True Then ;�ж��û������У����ܺ����������ͨ
		
;~ 		_AD_OPEN() ;���²������ڻ�ȡ �ʼ���ַ����ʾ�����ʼ���
;~ 		
;~ 		$EMAIL = _AD_GETOBJECTATTRIBUTE(@UserName, "mail")
;~ 		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;~ 		
;~ 		$DISPLAYNAME = _AD_GETOBJECTATTRIBUTE(@UserName, "displayname")
;~ 		$EMAILTOKENS = StringSplit($EMAIL, "@", 1)
;~ 		

;~ 		
;~ 		
;~ 		If UBound($EMAILTOKENS) >= 2 Then
;~ 			$EMAILDOMAIN = $EMAILTOKENS[2]
;~ 		EndIf
;~ 		
;~ 		_AD_CLOSE()
		Exit

	Else
		If GETMANUALINPUT($DISPLAYNAME, $EMAILDOMAIN) = False Then ;����û�������жϵ��û���ͨ�����������ֶ�ѡ������û�δ�����˺���Ϣ�����˳�
			Exit
		EndIf
		$EMAIL = $DISPLAYNAME & "@" & $EMAILDOMAIN
	EndIf
	
	SETPROFILEPROPERTY($EMAIL, $DISPLAYNAME) ;
	RUN_OUTLOOK() ;����outlook
	
	
	
	$Time_Start=1
	$Time_End=60
	
	If $G_OUTLOOKVER == "2010" Then
		$Title="Internet �����ʼ�"
	ElseIf	$G_OUTLOOKVER =="2007" Then
		$Title="������������"
	EndIf
	
	$waitRes=WinWait($Title,"corp.corpname.com",30)
	If ($waitRes <> 0 ) And   ($EMAILDOMAIN == "corp.corpname.com") ==True Then
		WinActive($Title,$EMAIL)
		ControlSetText($Title,$EMAIL,"RichEdit20WPT2",getCorpPSW($EMAIL)) ;��д����
		;ControlSetText($Title,$EMAIL,"RichEdit20WPT2","Dcacdsj1989") ;��д����
		ControlClick($Title,$EMAIL,"Button1")
		ControlClick($Title,$EMAIL,"Button2")
	EndIf
	 
	
	;������־�ļ�
	;$LOGFILEPATH = @AppDataDir & "\" & $DISPLAYNAME & ".log"
	;_FileCreate($LOGFILEPATH)	
	;FileCopy($LOGFILEPATH, "\\nas\Alibaba\B2B\Public\Drivers\ITOAC\")  ;�˴���Ҫ����־�ļ���nas��
EndFunc   ;==>OACSETUP

;~ Func getCorpPSW()
;~ 	
;~ 	Return "Dcacdsj1989"
;~ EndFunc


;���봰��
Func GETMANUALINPUT(ByRef $USERDISPLAYNAME, ByRef $USEREMAILDOMAIN)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("�������ù���", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("����������E-Mail��ַ", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")
	$USERNAMEEDIT = GUICtrlCreateInput("", 16, 32, 97, 21)
	$LABEL2 = GUICtrlCreateLabel("@", 120, 32, 20, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$DOMAINCOMBO = GUICtrlCreateCombo("", 144, 32, 137, 25, 3)
	GUICtrlSetData(-1, "mail.CorpDomain|corp.corpname.com|163.com|qq.com", "mail.CorpDomain")
;~ 	$CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 0x00000020, 0x00000048, 0x00000049, 0x00000019, $WS_GROUP)
;~ 	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 0x000000A8, 0x00000048, 0x00000049, 0x00000019, $WS_GROUP)
    $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 32, 72, 73, 25)
	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 168, 72, 73, 25)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	While 1
		$NMSG = GUIGetMsg()
		Select
			Case $NMSG = $CONFIRMBUTTON
				$USERDISPLAYNAME = GUICtrlRead($USERNAMEEDIT)
				$USEREMAILDOMAIN = GUICtrlRead($DOMAINCOMBO)
				If $USERDISPLAYNAME = "" Then
					MsgBox(0x00000000, "tip", "�����������������ַ")
				Else
					ExitLoop
				EndIf
			Case $NMSG = $CANCELBUTTON Or $NMSG = $GUI_EVENT_CLOSE
				GUIDelete()
				Return False
		EndSelect
	WEnd
	GUIDelete()
	Return True
EndFunc   ;==>GETMANUALINPUT

Func GETOUTLOOKINSTALLPATH()   ;����outlook��װ·��
	Return RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE", "path") & "outlook.exe"
EndFunc   ;==>GETOUTLOOKINSTALLPATH
Func GETOUTLOOKPRODUCTVERSION()  ;���ذ汾��
	$VERSIONSTRING = RegRead("HKEY_CLASSES_ROOT\Outlook.Application\CurVer", "")
	If $VERSIONSTRING = "" Or StringLen($VERSIONSTRING) <= 2 Then Return ""
	$VERSIONTOKEN = StringRight($VERSIONSTRING, 2)
	Return $VERSIONTOKEN
EndFunc   ;==>GETOUTLOOKPRODUCTVERSION

Func GETOUTLOOKVERSION() ;���ذ汾���
	$VERSIONTOKEN = GETOUTLOOKPRODUCTVERSION()
	
	If $VERSIONTOKEN = "" Then Return ""
	Select
		Case $VERSIONTOKEN = "11"
			Return "2003"
		Case $VERSIONTOKEN = "12"
			Return "2007"
		Case $VERSIONTOKEN = "14"
			Return "2010"
		Case $VERSIONTOKEN = "15"
			Return "2013"
	EndSelect
	
	Return "2007_compatible"
EndFunc   ;==>GETOUTLOOKVERSION
Func GETLOCALPROFILEPATH()   ;���������ļ�·��
	If $G_OUTLOOKVER = "2003" Then
		Return @TempDir & "\ap_2003.PRF"
	ElseIf $G_OUTLOOKVER = "2007" Then
		Return @TempDir & "\ap_2007.PRF"
	ElseIf $G_OUTLOOKVER = "2010" Then
		Return @TempDir & "\ap_2010.PRF"
	EndIf
EndFunc   ;==>GETLOCALPROFILEPATH
Func SETPROFILEPROPERTY(Const ByRef $USEREMAIL, Const ByRef $USERDISPLAYNAME)
	$PROFILEPATH = GETLOCALPROFILEPATH()
	If IniRead($PROFILEPATH, "Account1", "POP3UserName", "") <> "" Then
		IniWrite($PROFILEPATH, "Account1", "POP3UserName", $USEREMAIL)      ;POP3UserNameֵ�޸�Ϊ�û��趨������ֵ
	EndIf
	If IniRead($PROFILEPATH, "Account1", "IMAPUserName", "") <> "" Then
		IniWrite($PROFILEPATH, "Account1", "IMAPUserName", $USEREMAIL)
	EndIf
	;IniWrite($PROFILEPATH, "Service1", "UserName", $USEREMAIL)
	IniWrite($PROFILEPATH, "Account1", "EmailAddress", $USEREMAIL)
	IniWrite($PROFILEPATH, "Account1", "DisplayName", $USERDISPLAYNAME)
	IniWrite($PROFILEPATH, "Account1", "ReplyEMailAddress", $USEREMAIL)
	
	
	$USEREMAILDOMAIN_arr=StringSplit($USEREMAIL,"@",1)   ;��ȡ������74
	$USEREMAILDOMAIN=$USEREMAILDOMAIN_arr[2]

	;IniWrite($PROFILEPATH, "Service1", "ServerName", $USEREMAILDOMAIN)
	;IniWrite($PROFILEPATH, "Service1", "DisplayName", $USEREMAIL)
	IniWrite($PROFILEPATH, "Service2", "Name", $USEREMAIL)
	IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & $USEREMAIL & ".pst")
	IniWrite($PROFILEPATH, "Account1", "AccountName", $USEREMAIL)
	IniWrite($PROFILEPATH, "Account1", "POP3Server", $USEREMAILDOMAIN)
	IniWrite($PROFILEPATH, "Account1", "SMTPServer", $USEREMAILDOMAIN)
	
	If ($USEREMAILDOMAIN <>"mail.CorpDomain" And $USEREMAILDOMAIN <> "corp.corpname.com" ) Then   ; �ǹ�˾�ڲ�������һ���շ���������ַ���� 
		IniWrite($PROFILEPATH, "Account1", "POP3Server", "pop." & $USEREMAILDOMAIN)
		IniWrite($PROFILEPATH, "Account1", "SMTPServer", "smtp." & $USEREMAILDOMAIN)
	EndIf
	
	If $USEREMAILDOMAIN <>"mail.CorpDomain" Then             ;�� mail.CorpDomain ����Ҫ��ѡ������֤
		IniWrite($PROFILEPATH, "Account1", "SMTPUseAuth", "1")
		If $USEREMAILDOMAIN =="qq.com" Then            ;QQ ��pop��Ҫssl��ѡ
			IniWrite($PROFILEPATH, "Account1", "POP3UseSSL", "1")
			IniWrite($PROFILEPATH, "Account1", "POP3Port", "995")
		EndIf
	EndIf
	
	
	
	
	
EndFunc   ;==>SETPROFILEPROPERTY
Func RUN_OUTLOOK()
	$OUTLOOKPATH = $G_OUTLOOKPATH
	$OUTLOOKVER = $G_OUTLOOKVER

	If $OUTLOOKVER = "2003" Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
	ElseIf $OUTLOOKVER = "2007" Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
	ElseIf $OUTLOOKVER = "2010" Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
	EndIf
	Run($OUTLOOKPATH & " /importprf " & GETLOCALPROFILEPATH())

EndFunc   ;==>RUN_OUTLOOK


RunAs("TestUser1","CorpDomain","Dcacdsj1989",4,OACSETUP("pop3"),@SystemDir)


