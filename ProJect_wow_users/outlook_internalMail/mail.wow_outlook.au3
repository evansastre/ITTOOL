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

$G_OUTLOOKPATH = ""  ;outlook路径
$G_OUTLOOKVER = ""    ;outlook版本
Func OACSETUP(Const $SERVERTYPE)
	While ProcessExists("outlook.exe") ;检测当前的outlook进程是否存在
		$BUTTONPRESSED = MsgBox(5, "警告！", "请先关闭outlook再运行配置工具")
		If $BUTTONPRESSED = 4 Then
			ContinueLoop
		ElseIf $BUTTONPRESSED = 2 Then
			Exit
		EndIf
	WEnd
	$G_OUTLOOKPATH = GETOUTLOOKINSTALLPATH() ;outlook路径
	$G_OUTLOOKVER = GETOUTLOOKVERSION()      ;outlook版本

	If $G_OUTLOOKPATH = "" Or $G_OUTLOOKVER = "" Or (Not FileExists($G_OUTLOOKPATH)) Then 
		MsgBox(0x00000000, "警告！", "您没有正确地安装Outlook！")
		Exit
	EndIf
	
	;邮件接收服务器设置，根据服务器类型选定接收方式
	If $SERVERTYPE = "pop3" Then
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
		FileInstall(".\pop3_2007.PRF", @TempDir & "\ap_2007.PRF", 1)
		FileInstall(".\pop3_2003.PRF", @TempDir & "\ap_2003.PRF", 1)
;~ 	Else
;~ 		FileInstall(".\imap_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
;~ 		FileInstall(".\imap_2007.PRF", @TempDir & "\ap_2007.PRF", 1)
;~ 		FileInstall(".\imap_2003.PRF", @TempDir & "\ap_2003.PRF", 1)
	EndIf

	;附带图标
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	
	FileCreateShortcut("http://mail.CorpDomain/", @DesktopDir & "\CorpMail.lnk", "", "", "CorpMail快捷方式", @TempDir & "\corpname.ico", "", "0", @SW_MINIMIZE)
	$PSTFILEDIR = "E:\mail"  ;设置邮件数据存储的默认路径
	If DriveStatus("E:\") <> "READY" Then ;如果E盘不存在，则建立在C盘
		$PSTFILEDIR = "C:\mail"
	EndIf
	
	$PRODUCTVER = GETOUTLOOKPRODUCTVERSION() ;版本号，2010版为14，2007为12
	;修改注册表键值，指定数据文件存储路径

	
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	
	
	$EMAIL = ""          ;邮件地址
	$DISPLAYNAME = ""   ;显示名，中文
	$EMAILDOMAIN = ""   ;邮件域 @mail.CorpDomain
	If (@LogonDNSDomain = "CorpDomain.internal") And (Ping("dc1") <> "0" ) = True Then ;判断用户在域中，且能和域服务器相通
		
		_AD_OPEN() ;以下操作用于获取 邮件地址、显示名、邮件域
		
		$EMAIL = _AD_GETOBJECTATTRIBUTE(@UserName, "mail")
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		$DISPLAYNAME = _AD_GETOBJECTATTRIBUTE(@UserName, "displayname")
		$EMAILTOKENS = StringSplit($EMAIL, "@", 1)
		
		
		
		If UBound($EMAILTOKENS) >= 2 Then
			$EMAILDOMAIN = $EMAILTOKENS[2]
		EndIf
		
		_AD_CLOSE()
	Else
		If GETMANUALINPUT($DISPLAYNAME, $EMAILDOMAIN) = False Then ;对于没有满足判断的用户，通过弹窗界面手动选择，如果用户未输入账号信息，则退出
			Exit
		EndIf
		$EMAIL = $DISPLAYNAME & "@" & $EMAILDOMAIN
	EndIf
	SETPROFILEPROPERTY($EMAIL, $DISPLAYNAME) ;
	RUN_OUTLOOK() ;运行outlook
	;建立日志文件
	$LOGFILEPATH = @AppDataDir & "\" & $DISPLAYNAME & ".log"
	_FileCreate($LOGFILEPATH)	
	;FileCopy($LOGFILEPATH, "\\nas\Alibaba\B2B\Public\Drivers\ITOAC\")  ;此处是要靠日志文件到nas上
EndFunc   ;==>OACSETUP

;输入窗口
Func GETMANUALINPUT(ByRef $USERDISPLAYNAME, ByRef $USEREMAILDOMAIN)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("邮箱配置工具", 0x0000012F, 0x0000006E, 0x00000181, 0x000000F0)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("请输入您的E-Mail地址", 0x00000008, 0x00000008, 0x000001F4, 0x00000017)
	GUICtrlSetFont(-1, 0x0000000A, 0x00000320, 0x00000000, "微软雅黑")
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
					MsgBox(0x00000000, "tip", "请输入完整的邮箱地址")
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
Func GETOUTLOOKPRODUCTVERSION()  ;返回版本号
	$VERSIONSTRING = RegRead("HKEY_CLASSES_ROOT\Outlook.Application\CurVer", "")
	If $VERSIONSTRING = "" Or StringLen($VERSIONSTRING) <= 2 Then Return ""
	$VERSIONTOKEN = StringRight($VERSIONSTRING, 2)
	Return $VERSIONTOKEN
EndFunc   ;==>GETOUTLOOKPRODUCTVERSION

Func GETOUTLOOKVERSION() ;返回版本数
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
Func GETLOCALPROFILEPATH()   ;返回配置文件路径
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
$continue=MsgBox(1,"","1.在全新配置或者迁移邮箱时使用，如果本机outlook已有其他邮箱配置，此工具会覆盖当前配置，请慎重使用" & @LF & "2.邮件数据文件默认路径在E:\mail下，转移的原数据请放到此目录"& @LF & "是否继续？")
If $continue==1 Then
	OACSETUP("pop3")
Else
	Exit
EndIf

