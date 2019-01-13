#include <Array.au3>
#include <Memory.au3>
#include <WinAPI.au3>
#include <Security.au3>
#include <SecurityConstants.au3>
#include <SendMessage.au3>
#include <Date.au3>
#include <File.au3>
#include <AD_custom.au3>
#include <FTPEx.au3>
#include <GUIConstantsEx.au3>

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
	$G_OUTLOOKPATH = GETOUTLOOKINSTALLPATH() ;outlook·��
	$G_OUTLOOKVER = GETOUTLOOKVERSION()      ;outlook�汾

	If $G_OUTLOOKPATH = "" Or $G_OUTLOOKVER = "" Or (Not FileExists($G_OUTLOOKPATH)) Then 
		MsgBox(0x00000000, "���棡", "��û����ȷ�ذ�װOutlook��")
		Exit
	EndIf
	
	;�ʼ����շ��������ã����ݷ���������ѡ�����շ�ʽ
	If $SERVERTYPE = "pop3" Then
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
	
	FileCreateShortcut("http://mail.CorpDomain/", @DesktopDir & "\CorpMail.lnk", "", "", "CorpMail��ݷ�ʽ", @TempDir & "\corpname.ico", "", "0", @SW_MINIMIZE)
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
	If (@LogonDNSDomain = "CorpDomain.internal") And (Ping("dc1") <> "0" ) = True Then ;�ж��û������У����ܺ����������ͨ
		
		_AD_OPEN() ;���²������ڻ�ȡ �ʼ���ַ����ʾ�����ʼ���
		
		$EMAIL = _AD_GETOBJECTATTRIBUTE(@UserName, "mail")
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		$DISPLAYNAME = _AD_GETOBJECTATTRIBUTE(@UserName, "displayname")
		$EMAILTOKENS = StringSplit($EMAIL, "@", 1)
		
		
		
		If UBound($EMAILTOKENS) >= 2 Then
			$EMAILDOMAIN = $EMAILTOKENS[2]
		EndIf
		
		_AD_CLOSE()
	Else
		If GETMANUALINPUT($DISPLAYNAME, $EMAILDOMAIN) = False Then ;����û�������жϵ��û���ͨ�����������ֶ�ѡ������û�δ�����˺���Ϣ�����˳�
			Exit
		EndIf
		$EMAIL = $DISPLAYNAME & "@" & $EMAILDOMAIN
	EndIf
	SETPROFILEPROPERTY($EMAIL, $DISPLAYNAME) ;
	RUN_OUTLOOK() ;����outlook
	;������־�ļ�
	$LOGFILEPATH = @AppDataDir & "\" & $DISPLAYNAME & ".log"
	_FileCreate($LOGFILEPATH)	
	;FileCopy($LOGFILEPATH, "\\nas\Alibaba\B2B\Public\Drivers\ITOAC\")  ;�˴���Ҫ����־�ļ���nas��
EndFunc   ;==>OACSETUP

;���봰��
Func GETMANUALINPUT(ByRef $USERDISPLAYNAME, ByRef $USEREMAILDOMAIN)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("�������ù���", 0x0000012F, 0x0000006E, 0x00000181, 0x000000F0)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("����������E-Mail��ַ", 0x00000008, 0x00000008, 0x000001F4, 0x00000017)
	GUICtrlSetFont(-1, 0x0000000A, 0x00000320, 0x00000000, "΢���ź�")
	$USERNAMEEDIT = GUICtrlCreateInput("", 0x00000010, 0x00000020, 0x00000061, 0x00000015)
	$LABEL2 = GUICtrlCreateLabel("@", 0x00000078, 0x00000020, 0x00000014, 0x00000018)
	GUICtrlSetFont(-1, 0x0000000C, 0x00000190, 0x00000000, "MS Sans Serif")
	$DOMAINCOMBO = GUICtrlCreateCombo("", 0x00000090, 0x00000020, 0x00000089, 0x00000019, 0x00000003)
	GUICtrlSetData(-1, "mail.CorpDomain|163.com|corp.corpname.com", "mail.CorpDomain")
;~ 	$CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 0x00000020, 0x00000048, 0x00000049, 0x00000019, $WS_GROUP)
;~ 	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 0x000000A8, 0x00000048, 0x00000049, 0x00000019, $WS_GROUP)
    $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 0x00000020, 0x00000048, 0x00000049, 0x00000019)
	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 0x000000A8, 0x00000048, 0x00000049, 0x00000019)
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
				Return False
		EndSelect
	WEnd
	Return True
EndFunc   ;==>GETMANUALINPUT
Func GETOUTLOOKINSTALLPATH()
	Return RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE", "path") & "outlook.exe"
EndFunc   ;==>GETOUTLOOKINSTALLPATH
Func GETOUTLOOKPRODUCTVERSION()  ;���ذ汾��
	$VERSIONSTRING = RegRead("HKEY_CLASSES_ROOT\Outlook.Application\CurVer", "")
	If $VERSIONSTRING = "" Or StringLen($VERSIONSTRING) <= 2 Then Return ""
	$VERSIONTOKEN = StringRight($VERSIONSTRING, 2)
	Return $VERSIONTOKEN
EndFunc   ;==>GETOUTLOOKPRODUCTVERSION

Func GETOUTLOOKVERSION() ;���ذ汾��
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
		IniWrite($PROFILEPATH, "Account1", "POP3UserName", $USEREMAIL)
	EndIf
	If IniRead($PROFILEPATH, "Account1", "IMAPUserName", "") <> "" Then
		IniWrite($PROFILEPATH, "Account1", "IMAPUserName", $USEREMAIL)
	EndIf
	IniWrite($PROFILEPATH, "Service1", "UserName", $USEREMAIL)
	IniWrite($PROFILEPATH, "Account1", "EmailAddress", $USEREMAIL)
	IniWrite($PROFILEPATH, "Account1", "DisplayName", $USERDISPLAYNAME)
	IniWrite($PROFILEPATH, "Account1", "ReplyEMailAddress", $USEREMAIL)
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
	;MsgBox(0,"",$OUTLOOKPATH & " /importprf " & GETLOCALPROFILEPATH())
EndFunc   ;==>RUN_OUTLOOK
$continue=MsgBox(1,"","1.��ȫ�����û���Ǩ������ʱʹ�ã��������outlook���������������ã��˹��߻Ḳ�ǵ�ǰ���ã�������ʹ��" & @LF & "2.�ʼ������ļ�Ĭ��·����E:\mail�£�ת�Ƶ�ԭ������ŵ���Ŀ¼"& @LF & "�Ƿ������")
If $continue==1 Then
	OACSETUP("pop3")
Else
	Exit
EndIf

