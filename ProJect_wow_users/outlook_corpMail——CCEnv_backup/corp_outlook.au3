#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\邮箱配置工具.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

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
	$G_OUTLOOKPATH = GETOUTLOOKINSTALLPATH() ;outlook安装路径
	$G_OUTLOOKVER = GETOUTLOOKVERSION()      ;outlook版本

	If $G_OUTLOOKPATH = "" Or $G_OUTLOOKVER = "" Or (Not FileExists($G_OUTLOOKPATH)) Then 
		MsgBox(0, "警告！", "您没有正确地安装Outlook！")
		Exit
	EndIf
	
	;邮件接收服务器设置，根据服务器类型选定接收方式
	If $SERVERTYPE = "pop3" Then
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2007.PRF", 1)
		FileInstall(".\pop3_2010.PRF", @TempDir & "\ap_2003.PRF", 1)
;~ 	Else
;~ 		FileInstall(".\imap_2010.PRF", @TempDir & "\ap_2010.PRF", 1)
;~ 		FileInstall(".\imap_2007.PRF", @TempDir & "\ap_2007.PRF", 1)
;~ 		FileInstall(".\imap_2003.PRF", @TempDir & "\ap_2003.PRF", 1)
	EndIf

	;附带图标
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	
	$PSTFILEDIR = "E:\mail"  ;设置邮件数据存储的默认路径
	If DriveStatus("E:\") <> "READY" Then ;如果E盘不存在，则建立在C盘
		MsgBox(0,"","E盘不存在，数据文件将建立在 C:\mail")
		$PSTFILEDIR = "C:\mail"
	EndIf
		
	$PRODUCTVER = GETOUTLOOKPRODUCTVERSION() ;版本号，2010版为14，2007为12

	;修改注册表键值，指定数据文件存储路径
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\" & $PRODUCTVER & ".0\Outlook", "abcd", "REG_EXPAND_SZ", $PSTFILEDIR)
	
	
	Global $EMAIL = ""          ;邮件地址
	Global $DISPLAYNAME = ""   ;显示名，中文
	Global $EMAILDOMAIN = ""   ;邮件域 @mail.CorpDomain 、 @corp.corpname.com
	If (@LogonDNSDomain = "CorpDomain.internal") And (Ping("dc1") <> "0" ) = True Then ;判断用户在域中，且能和域服务器相通
		
		_AD_OPEN() ;以下操作用于获取 邮件地址、显示名、邮件域	
		
		$DISPLAYNAME = _AD_GETOBJECTATTRIBUTE(@UserName, "displayname")
		
;~ 		$EMAIL = _AD_GETOBJECTATTRIBUTE(@UserName, "mail")
;~ 		$EMAILTOKENS = StringSplit($EMAIL, "@", 1)	
;~ 		If UBound($EMAILTOKENS) >= 2 Then
;~ 			$EMAILDOMAIN = $EMAILTOKENS[2]
;~ 		EndIf

		_AD_CLOSE()

	EndIf

	Global $ACCOUNTNAME  ;用户名
	If GETMANUALINPUT($ACCOUNTNAME, $EMAILDOMAIN) = False Then ;对于没有满足判断的用户，通过弹窗界面手动选择，如果用户未输入账号信息，则退出
		Exit
	EndIf
	
	$EMAIL = $ACCOUNTNAME & "@" & $EMAILDOMAIN
	
	
;~ 	MsgBox(0,"",$DISPLAYNAME)
;~ 	MsgBox(0,"",$EMAIL)
;~ 	Exit

	
	SETPROFILEPROPERTY($EMAIL, $ACCOUNTNAME) ;
	
	RUN_OUTLOOK() ;运行outlook
	
	
	If $EMAILDOMAIN =="mail.CorpDomain" Then ;只在配置内邮时出现这LDAP目录
		
		$Title="Microsoft LDAP 目录"
		$waitRes=WinWait($Title,"",10)
		$Pos=WinGetPos($Title,"") 
		$x=$pos[0]
		$y=$pos[1]
		MouseMove($x+178,$y+180)
		MouseClick("left",$x+178,$y+180)  
	EndIf
	;Send("Dcacdsj1989")
	
	;MouseClick("left",$x+78,$y+302)  ;保存密码选项
	;MouseClick("left",$x+145,$y+430)  ;点击“登录”
	;Exit

	If $EMAILDOMAIN=="corp.corpname.com" Then  ;只有当配置corp邮箱时才有自动填写的一系列操作
		If $G_OUTLOOKVER == "2010" Then
			$Title="Internet 电子邮件"
		ElseIf	$G_OUTLOOKVER =="2007" Then
			$Title="输入网络密码"
		EndIf
		Sleep(2000)
		Send("{F9}")
		$waitRes=WinWait($Title,"corp.corpname.com",10)
		If $waitRes <> 0  ==True Then
			WinActive($Title,$EMAIL)
			ControlSetText($Title,$EMAIL,"RichEdit20WPT2",getCorpPSW($EMAIL)) ;填写密码
			ControlClick($Title,$EMAIL,"Button1")
			ControlClick($Title,$EMAIL,"Button2")
		EndIf
	EndIf
		 
	
	;建立日志文件
	;$LOGFILEPATH = @AppDataDir & "\" & $DISPLAYNAME & ".log"
	;_FileCreate($LOGFILEPATH)	
	;FileCopy($LOGFILEPATH, "\\nas\Alibaba\B2B\Public\Drivers\ITOAC\")  ;此处是要靠日志文件到nas上
EndFunc   ;==>OACSETUP


;输入窗口
Func GETMANUALINPUT(ByRef $USERACCOUNTNAME, ByRef $USEREMAILDOMAIN)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("邮箱配置工具", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("请输入您的E-Mail地址", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")
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
					MsgBox(0, "tip", "请输入完整的邮箱地址")
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

Func GETOUTLOOKINSTALLPATH()   ;返回outlook安装路径
	Return RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE", "path") & "outlook.exe"
EndFunc   ;==>GETOUTLOOKINSTALLPATH

Func GETOUTLOOKPRODUCTVERSION()  ;返回版本号
	$VERSIONSTRING = RegRead("HKEY_CLASSES_ROOT\Outlook.Application\CurVer", "")
	If $VERSIONSTRING = "" Or StringLen($VERSIONSTRING) <= 2 Then Return ""
	$VERSIONTOKEN = StringRight($VERSIONSTRING, 2)
	Return $VERSIONTOKEN
EndFunc   ;==>GETOUTLOOKPRODUCTVERSION

Func GETOUTLOOKVERSION() ;返回版本年份
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
Func GETLOCALPROFILEPATH()   ;返回配置文件路径
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
	;清空outlook用户配置文件
	$res= MsgBox(4,"","是否清空当前outlook配置信息？"& @LF & "只在首次或重新配置时选'是' " & @LF &"在当前存在邮箱且需要添加新邮箱帐号时选 '否'  ")
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
;~ 		IniWrite($PROFILEPATH, "Account1", "DisplayName", "内邮")
;~ 	EndIf
	
	;;;;;;;;;;;;;;;;;;;;;;;  
	
	;service1 LDAP
	If $EMAILDOMAIN =="mail.CorpDomain" Then 
		IniWrite($PROFILEPATH, "Service1", "UserName","CorpDomain\" & @UserName )
		$DC=getMyDC()
		IniWrite($PROFILEPATH, "Service1", "ServerName", $DC)
		IniWrite($PROFILEPATH, "Service1", "DisplayName", "内邮通讯录LDAP")
	EndIf
		
;~ 	
	
	IniWrite($PROFILEPATH, "Service2", "Name", $USEREMAIL)   ;边栏的邮箱名称，mail.CorpDomain名称强制为"内邮"，corp强制为“企业邮箱”
	IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & $USEREMAIL & ".pst") ; 数据文件名称, wow和corp邮箱用专有名字
	
	If $EMAILDOMAIN =="mail.CorpDomain" Then
		IniWrite($PROFILEPATH, "Service2", "Name", "内邮")
		IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & @UserName & "wow.pst") 
	ElseIf $EMAILDOMAIN =="corp.corpname.com" Then
		IniWrite($PROFILEPATH, "Service2", "Name", "企业邮箱")
		IniWrite($PROFILEPATH, "Service2", "PathAndFilenameToPersonalFolders", "E:\mail\" & @UserName & "corp.pst") 
	EndIf
	
	IniWrite($PROFILEPATH, "Account1", "AccountName", $USEREMAIL) ;帐户信息处显示的名称，一般不修改此项，用邮件地址作为名称即可
	
	IniWrite($PROFILEPATH, "Account1", "DisplayName", $DISPLAYNAME) ;用户信息————姓名，中文
	IniWrite($PROFILEPATH, "Account1", "EmailAddress", $USEREMAIL)      ;用户信息————邮件地址
	IniWrite($PROFILEPATH, "Account1", "ReplyEMailAddress", $USEREMAIL) ;回复地址
	
	IniWrite($PROFILEPATH, "Account1", "POP3Server", $EMAILDOMAIN) ;服务器信息————接收邮件服务器
	IniWrite($PROFILEPATH, "Account1", "SMTPServer", $EMAILDOMAIN)      ;服务器信息————发送邮件服务器
	If ($EMAILDOMAIN <>"mail.CorpDomain" And $EMAILDOMAIN <> "corp.corpname.com" ) Then   ; 非公司内部的邮箱一般收发服务器地址名规则 
		IniWrite($PROFILEPATH, "Account1", "POP3Server", "pop." & $EMAILDOMAIN)
		IniWrite($PROFILEPATH, "Account1", "SMTPServer", "smtp." & $EMAILDOMAIN)
	EndIf
	
	
	If IniRead($PROFILEPATH, "Account1", "POP3UserName", "") <> "" Then
		IniWrite($PROFILEPATH, "Account1", "POP3UserName", $USEREMAIL)      ;登录信息————用户名  pop
	EndIf
	If IniRead($PROFILEPATH, "Account1", "IMAPUserName", "") <> "" Then    ;登录信息————用户名   imap
		IniWrite($PROFILEPATH, "Account1", "IMAPUserName", $USEREMAIL)
	EndIf
	
	
	If $EMAILDOMAIN <>"mail.CorpDomain" Then             ;非 mail.CorpDomain 都需要勾选发送验证
		IniWrite($PROFILEPATH, "Account1", "SMTPUseAuth", "1")
		If $EMAILDOMAIN =="qq.com"  Then            ;QQ 的pop需要ssl勾选
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
WO_rec("邮箱配置工具")


