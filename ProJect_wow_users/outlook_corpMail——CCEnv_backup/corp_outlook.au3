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
#include <Math.au3>
#include <AD.au3>

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
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2007.PRF", 1)
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2003.PRF", 1)
;~ 	Else
;~ 		FileInstall(".\imap_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
;~ 		FileInstall(".\imap_2007.PRF", @TempDir & "\ap_2007.PRF", 1)
;~ 		FileInstall(".\imap_2003.PRF", @TempDir & "\ap_2003.PRF", 1)
	EndIf

	;����ͼ��
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	
	$PSTFILEDIR = "E:\mail"  ;�����ʼ����ݴ洢��Ĭ��·��
	If DriveStatus("E:\") <> "READY" Then ;���E�̲����ڣ�������C��
		MsgBox(0,"","E�̲����ڣ������ļ��������� C:\mail")
		$PSTFILEDIR = "C:\mail"
	EndIf
		
	$PRODUCTVER = GETOUTLOOKPRODUCTVERSION() ;�汾�ţ�2010��Ϊ14��2007Ϊ12

	;�޸�ע����ֵ��ָ�������ļ��洢·��
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	
	
	Global $EMAIL = ""          ;�ʼ���ַ
	Global $DISPLAYNAME = ""   ;��ʾ��������
	Global $EMAILDOMAIN = ""   ;�ʼ��� @mail.CorpDomain �� @corp.corpname.com
	If (@LogonDNSDomain = "CorpDomain.internal") And (Ping("dc1") <> "0" ) = True Then ;�ж��û������У����ܺ����������ͨ
		
		_AD_OPEN() ;���²������ڻ�ȡ �ʼ���ַ����ʾ�����ʼ���	
		
		$DISPLAYNAME = _AD_GETOBJECTATTRIBUTE(@UserName, "displayname")
		
;~ 		$EMAIL = _AD_GETOBJECTATTRIBUTE(@UserName, "mail")
;~ 		$EMAILTOKENS = StringSplit($EMAIL, "@", 1)	
;~ 		If UBound($EMAILTOKENS) >= 2 Then
;~ 			$EMAILDOMAIN = $EMAILTOKENS[2]
;~ 		EndIf

		_AD_CLOSE()

	EndIf

	Global $ACCOUNTNAME  ;�û���
	If GETMANUALINPUT($ACCOUNTNAME, $EMAILDOMAIN) = False Then ;����û�������жϵ��û���ͨ�����������ֶ�ѡ������û�δ�����˺���Ϣ�����˳�
		Exit
	EndIf
	
	$EMAIL = $ACCOUNTNAME & "@" & $EMAILDOMAIN
	
	
;~ 	MsgBox(0,"",$DISPLAYNAME)
;~ 	MsgBox(0,"",$EMAIL)
;~ 	Exit

	
	SETPROFILEPROPERTY($EMAIL, $ACCOUNTNAME) ;
	
	RUN_OUTLOOK() ;����outlook
	
	
	If $EMAILDOMAIN =="mail.CorpDomain" Then ;ֻ����������ʱ������LDAPĿ¼
		
		$Title="Microsoft LDAP Ŀ¼"
		$waitRes=WinWait($Title,"",10)
		$Pos=WinGetPos($Title,"") 
		$x=$pos[0]
		$y=$pos[1]
		MouseMove($x+178,$y+180)
		MouseClick("left",$x+178,$y+180)  
	EndIf
	;Send("Dcacdsj1989")
	
	;MouseClick("left",$x+78,$y+302)  ;��������ѡ��
	;MouseClick("left",$x+145,$y+430)  ;�������¼��
	;Exit

	If $EMAILDOMAIN=="corp.corpname.com" Then  ;ֻ�е�����corp����ʱ�����Զ���д��һϵ�в���
		If $G_OUTLOOKVER == "2010" Then
			$Title="Internet �����ʼ�"
		ElseIf	$G_OUTLOOKVER =="2007" Then
			$Title="������������"
		EndIf
		Sleep(2000)
		Send("{F9}")
		$waitRes=WinWait($Title,"corp.corpname.com",10)
		If $waitRes <> 0  ==True Then
			WinActive($Title,$EMAIL)
			ControlSetText($Title,$EMAIL,"RichEdit20WPT2",getCorpPSW($EMAIL)) ;��д����
			ControlClick($Title,$EMAIL,"Button1")
			ControlClick($Title,$EMAIL,"Button2")
		EndIf
	EndIf
		 
	
	;������־�ļ�
	;$LOGFILEPATH = @AppDataDir & "\" & $DISPLAYNAME & ".log"
	;_FileCreate($LOGFILEPATH)	
	;FileCopy($LOGFILEPATH, "\\nas\Alibaba\B2B\Public\Drivers\ITOAC\")  ;�˴���Ҫ����־�ļ���nas��
EndFunc   ;==>OACSETUP


;���봰��
Func GETMANUALINPUT(ByRef $USERACCOUNTNAME, ByRef $USEREMAILDOMAIN)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("�������ù���", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("����������E-Mail��ַ", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")
	$USERNAMEEDIT = GUICtrlCreateInput(@UserName, 16, 32, 97, 21)
	$LABEL2 = GUICtrlCreateLabel("@", 120, 32, 20, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$DOMAINCOMBO = GUICtrlCreateCombo("", 144, 32, 137, 25, 3)
	GUICtrlSetData(-1, "mail.CorpDomain|corp.corpname.com", "mail.CorpDomain")
;~ 	GUICtrlSetData(-1, "mail.CorpDomain|corp.corpname.com|163.com|qq.com", "mail.CorpDomain")
    $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 32, 72, 73, 25)
	$CANCELBUTTON  = GUICtrlCreateButton("Cancel", 168, 72, 73, 25)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	
	While 1
		$NMSG = GUIGetMsg()
		Select
			Case $NMSG = $CONFIRMBUTTON
				$USERACCOUNTNAME = GUICtrlRead($USERNAMEEDIT)
				$USEREMAILDOMAIN = GUICtrlRead($DOMAINCOMBO)
				If $USERACCOUNTNAME = "" Then
					MsgBox(0, "tip", "�����������������ַ")
				Else
					ExitLoop
				EndIf
			Case $NMSG = $CANCELBUTTON Or $NMSG = $GUI_EVENT_CLOSE
				GUIDelete()
				Return False
			Case $NMSG = $DOMAINCOMBO
				If GUICtrlRead($DOMAINCOMBO)=="mail.CorpDomain" Then
					GUICtrlSetData($USERNAMEEDIT,@UserName)
				ElseIf GUICtrlRead($DOMAINCOMBO)=="corp.corpname.com" Then
					GUICtrlSetData($USERNAMEEDIT,"")
				EndIf
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
	Switch $VERSIONTOKEN
		Case "11"
			Return "2003"
		Case  "12"
			Return "2007"
		Case "14"
			Return "2010"
		Case "15"
			Return "2013"
	EndSwitch
	
	Return "2007"
EndFunc   ;==>GETOUTLOOKVERSION
Func GETLOCALPROFILEPATH()   ;���������ļ�·��
	Switch $G_OUTLOOKVER
		Case  "2003" 
			Return @TempDir & "\ap_2003.PRF"
		Case  "2007" 
			Return @TempDir & "\ap_2007.PRF"
		Case  "2010" 
			Return @TempDir & "\ap_2010.PRF"
		Case  "2013" 
			Return @TempDir & "\ap_2013.PRF"
	EndSwitch
EndFunc   ;==>GETLOCALPROFILEPATH

Func getMyDC()
	$DC_SH="dc1"
	$sh=Ping($DC_SH)
	If $sh==0 Then  
		$DC_SH="dc2"
		$sh=Ping($DC_SH)
	EndIf
	
	$DC_HZ="dc3"
	$hz=Ping($DC_HZ)
	If $hz==0 Then  
		$DC_HZ="dc4"
		$hz=Ping($DC_HZ)
	EndIf
	
	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		Return $DC_SH
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		Return $DC_HZ
	EndIf
EndFunc


Func SETPROFILEPROPERTY(Const ByRef $USEREMAIL, Const ByRef $USERACCOUNTNAME)
;~ 	
;~ 	MsgBox(0,"",$DISPLAYNAME)
;~ 	MsgBox(0,"",$EMAIL)
;~ 	Exit
	$PROFILEPATH = GETLOCALPROFILEPATH()
		;-------------------------------------
	;���outlook�û������ļ�
	$res= MsgBox(4,"","�Ƿ���յ�ǰoutlook������Ϣ��"& @LF & "ֻ���״λ���������ʱѡ'��' " & @LF &"�ڵ�ǰ������������Ҫ����������ʺ�ʱѡ '��'  ")
	If $res == 6 Then
		While 1
			RegDelete( "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles" )
			If (@error==1 Or @error==2 ) Then 
;~ 				MsgBox(0,"","done")
				ExitLoop
			EndIf
			
		WEnd
	EndIf
	

;~ 		Then ExitLoop
;~ 		
;~ 		Sleep(1000)
		
	;~ 	If $EMAILDOMAIN =="mail.CorpDomain" Then
;~ 		IniWrite($PROFILEPATH, "Account1", "DisplayName", "����")
;~ 	EndIf
	
	;;;;;;;;;;;;;;;;;;;;;;;  
	
	;service1 LDAP
	If $EMAILDOMAIN =="mail.CorpDomain" Then 
		IniWrite($PROFILEPATH, "Service1", "UserName","CorpDomain\" & @UserName )
		$DC=getMyDC()
		IniWrite($PROFILEPATH, "Service1", "ServerName", $DC)
		IniWrite($PROFILEPATH, "Service1", "DisplayName", "����ͨѶ¼LDAP")
	EndIf
		
;~ 	
	
	IniWrite($PROFILEPATH, "Service2", "Name", $USEREMAIL)   ;�������������ƣ�mail.CorpDomain����ǿ��Ϊ"����"��corpǿ��Ϊ����ҵ���䡱
	IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & $USEREMAIL & ".pst") ; �����ļ�����, wow��corp������ר������
	
	If $EMAILDOMAIN =="mail.CorpDomain" Then
		IniWrite($PROFILEPATH, "Service2", "Name", "����")
		IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & @UserName & "wow.pst") 
	ElseIf $EMAILDOMAIN =="corp.corpname.com" Then
		IniWrite($PROFILEPATH, "Service2", "Name", "��ҵ����")
		IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & @UserName & "corp.pst") 
	EndIf
	
	IniWrite($PROFILEPATH, "Account1", "AccountName", $USEREMAIL) ;�ʻ���Ϣ����ʾ�����ƣ�һ�㲻�޸Ĵ�����ʼ���ַ��Ϊ���Ƽ���
	
	IniWrite($PROFILEPATH, "Account1", "DisplayName", $DISPLAYNAME) ;�û���Ϣ������������������
	IniWrite($PROFILEPATH, "Account1", "EmailAddress", $USEREMAIL)      ;�û���Ϣ���������ʼ���ַ
	IniWrite($PROFILEPATH, "Account1", "ReplyEMailAddress", $USEREMAIL) ;�ظ���ַ
	
	IniWrite($PROFILEPATH, "Account1", "POP3Server", $EMAILDOMAIN) ;��������Ϣ�������������ʼ�������
	IniWrite($PROFILEPATH, "Account1", "SMTPServer", $EMAILDOMAIN)      ;��������Ϣ�������������ʼ�������
	If ($EMAILDOMAIN <>"mail.CorpDomain" And $EMAILDOMAIN <> "corp.corpname.com" ) Then   ; �ǹ�˾�ڲ�������һ���շ���������ַ������ 
		IniWrite($PROFILEPATH, "Account1", "POP3Server", "pop." & $EMAILDOMAIN)
		IniWrite($PROFILEPATH, "Account1", "SMTPServer", "smtp." & $EMAILDOMAIN)
	EndIf
	
	
	If IniRead($PROFILEPATH, "Account1", "POP3UserName", "") <> "" Then
		IniWrite($PROFILEPATH, "Account1", "POP3UserName", $USEREMAIL)      ;��¼��Ϣ���������û���  pop
	EndIf
	If IniRead($PROFILEPATH, "Account1", "IMAPUserName", "") <> "" Then    ;��¼��Ϣ���������û���   imap
		IniWrite($PROFILEPATH, "Account1", "IMAPUserName", $USEREMAIL)
	EndIf
	
	
	If $EMAILDOMAIN <>"mail.CorpDomain" Then             ;�� mail.CorpDomain ����Ҫ��ѡ������֤
		IniWrite($PROFILEPATH, "Account1", "SMTPUseAuth", "1")
		If $EMAILDOMAIN =="qq.com"  Then            ;QQ ��pop��Ҫssl��ѡ
			IniWrite($PROFILEPATH, "Account1", "POP3UseSSL", "1")
			IniWrite($PROFILEPATH, "Account1", "POP3Port", "995")
		EndIf
	EndIf
	
EndFunc   ;==>SETPROFILEPROPERTY
Func RUN_OUTLOOK()
	$OUTLOOKPATH = $G_OUTLOOKPATH
	$OUTLOOKVER = $G_OUTLOOKVER
	
	Switch $OUTLOOKVER
		Case "2003"
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\11.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
		Case "2007"
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
		Case "2010"
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
		Case "2013"
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Outlook\LDAP", "DisableVLVBrowsing", "REG_DWORD", "1")
	EndSwitch
	
	
	FileCreateShortcut($OUTLOOKPATH,@DesktopDir&"\OUTLOOK")
	Run($OUTLOOKPATH & " /importprf " & GETLOCALPROFILEPATH())

EndFunc   ;==>RUN_OUTLOOK

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc


Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd
		FileWriteLine($sFilePath, $i)
	Next
	RunWait($sFilePath, "", @SW_DISABLE)
	FileDelete($sFilePath)
EndFunc   ;==>runBat

OACSETUP("pop3")
WO_rec("�������ù���")


