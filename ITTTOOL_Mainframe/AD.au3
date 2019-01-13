#Tidy_Parameters= /gd 1 /gds 1 /nsdp
#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#Obfuscator_Ignore_Funcs=_AD_FixSpecialChars
#include-once
#include <Array.au3>
#include <Date.au3>

; #INDEX# =======================================================================================================================
; Title .........: Active Directory Function Library
; AutoIt Version : 3.3.12.0
; UDF Version ...: 1.4.1.1
; Language ......: English
; Description ...: A collection of functions for accessing and manipulating Microsoft Active Directory
; Author(s) .....: Jonathan Clelland, water
; Modified.......: 20140611 (YYYMMDD)
; Remarks .......: Please read the ReadMe.txt file for information about installing and using this UDF!
; Contributors ..: feeks, KenE, Sundance, supersonic, Talder, Joe2010, Suba, Ethan Turk, Jerold Schulman, Stephane, card0384
; Resources .....: http://www.wisesoft.co.uk/scripts
;                  http://gallery.technet.microsoft.com/ScriptCenter/en-us
;                  http://www.rlmueller.net/
;                  http://www.activxperts.com/activmonitor/windowsmanagement/scripts/activedirectory/
;
;                  Well known SIDs: http://technet.microsoft.com/en-us/library/cc978401.aspx
;                  AD Schema: http://msdn.microsoft.com/en-us/library/ms675085(VS.85).aspx
;                  Win32 error codes: http://msdn.microsoft.com/en-us/library/ms681381(v=VS.85).aspx
;                  HRESULT values: http://msdn.microsoft.com/en-us/library/cc704587.aspx
;                  ADSI: http://msdn.microsoft.com/en-us/library/aa772170(v=VS.85).aspx
;                  LDAP: http://msdn.microsoft.com/en-us/library/aa367008(v=VS.85).aspx
;                        http://www.petri.co.il/ldap_search_samples_for_windows_2003_and_exchange.htm
; ===============================================================================================================================

#Region #VARIABLES#
; #VARIABLES# ===================================================================================================================
Global $__iAD_Debug = 0 ; Debug level. 0 = no debug information, 1 = Debug info to console, 2 = Debug info to MsgBox, 3 = Debug Info to File
Global $__sAD_DebugFile = @ScriptDir & "\AD_Debug.txt" ; Debug file if $__iAD_Debug is set to 3
Global $__oAD_MyError ; COM Error handler
Global $__oAD_Connection
Global $__oAD_OpenDS
Global $__oAD_RootDSE
Global $__oAD_Command
Global $__oAD_Bind ; Reference to hold the bind cache
Global $__bAD_BindFlags ; Bind flags
Global $sAD_DNSDomain
Global $sAD_HostServer
Global $sAD_Configuration
Global $sAD_UserId = ""
Global $sAD_Password = ""
; ===============================================================================================================================
#EndRegion #VARIABLES#

#Region #CONSTANTS#
; #CONSTANTS# ===================================================================================================================
; ADS_RIGHTS_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772285(VS.85).aspx
Global Const $ADS_FULL_RIGHTS = 0xF01FF
Global Const $ADS_USER_UNLOCKRESETACCOUNT = 0x100
Global Const $ADS_OBJECT_READWRITE_ALL = 0x30
; ADS_AUTHENTICATION_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772247(VS.85).aspx
Global Const $ADS_SECURE_AUTH = 0x1
Global Const $ADS_USE_SSL = 0x2
Global Const $ADS_SERVER_BIND = 0x200
; ADS_USER_FLAG_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772300(VS.85).aspx
Global Const $ADS_UF_ACCOUNTDISABLE = 0x2
Global Const $ADS_UF_PASSWD_NOTREQD = 0x20
Global Const $ADS_UF_WORKSTATION_TRUST_ACCOUNT = 0x1000
Global Const $ADS_UF_DONT_EXPIRE_PASSWD = 0x10000
; ADS_GROUP_TYPE_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772263(VS.85).aspx
Global Const $ADS_GROUP_TYPE_GLOBAL_GROUP = 0x2
Global Const $ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP = 0x4
Global Const $ADS_GROUP_TYPE_UNIVERSAL_GROUP = 0x8
Global Const $ADS_GROUP_TYPE_SECURITY_ENABLED = 0x80000000
Global Const $ADS_GROUP_TYPE_GLOBAL_SECURITY = BitOR($ADS_GROUP_TYPE_GLOBAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
Global Const $ADS_GROUP_TYPE_UNIVERSAL_SECURITY = BitOR($ADS_GROUP_TYPE_UNIVERSAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
Global Const $ADS_GROUP_TYPE_LOCAL_SECURITY = BitOR($ADS_GROUP_TYPE_DOMAIN_LOCAL_GROUP, $ADS_GROUP_TYPE_SECURITY_ENABLED)
; ADS_ACETYPE_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772244(VS.85).aspx
Global Const $ADS_ACETYPE_ACCESS_ALLOWED = 0
Global Const $ADS_ACETYPE_ACCESS_DENIED = 0x1
Global Const $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT = 0x5
Global Const $ADS_ACETYPE_ACCESS_DENIED_OBJECT = 0x6
; ADS_ACEFLAG_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772242(VS.85).aspx
Global Const $ADS_ACEFLAG_INHERITED_ACE = 0x10
; Global Const $ADS_FLAGTYPE_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772259(VS.85).aspx
Global Const $ADS_FLAG_OBJECT_TYPE_PRESENT = 0x1
; ADS_RIGHTS_ENUM Enumeration. See: http://msdn.microsoft.com/en-us/library/aa772285(VS.85).aspx
Global Const $ADS_RIGHT_DS_SELF = 0x8
Global Const $ADS_RIGHT_DS_WRITE_PROP = 0x20
Global Const $ADS_RIGHT_DS_CONTROL_ACCESS = 0x100
Global Const $ADS_RIGHT_GENERIC_READ = 0x80000000
; GUIDs - LOWER CASE!
Global Const $USER_CHANGE_PASSWORD = "{ab721a53-1e2f-11d0-9819-00aa0040529b}" ; See: http://msdn.microsoft.com/en-us/library/cc223637(PROT.13).aspx
Global Const $SELF_MEMBERSHIP = "{bf9679c0-0de6-11d0-a285-00aa003049e2}" ; See: http://msdn.microsoft.com/en-us/library/cc223513(PROT.10).aspx
Global Const $ALLOWED_TO_AUTHENTICATE = "{68B1D179-0D15-4d4f-AB71-46152E79A7BC}" ; See: http://msdn.microsoft.com/en-us/library/ms684300(VS.85).aspx
Global Const $RECEIVE_AS = "{AB721A56-1E2f-11D0-9819-00AA0040529B}" ; See: http://msdn.microsoft.com/en-us/library/ms684402(VS.85).aspx
Global Const $SEND_AS = "{AB721A54-1E2f-11D0-9819-00AA0040529B}" ; See: http://msdn.microsoft.com/en-us/library/ms684406(VS.85).aspx
Global Const $USER_FORCE_CHANGE_PASSWORD = "{00299570-246D-11D0-A768-00AA006E0529}" ; See: http://msdn.microsoft.com/en-us/library/ms684414(VS.85).aspx
Global Const $USER_ACCOUNT_RESTRICTIONS = "{4C164200-20C0-11D0-A768-00AA006E0529}" ; See: http://msdn.microsoft.com/en-us/library/ms684412(VS.85).aspx
Global Const $VALIDATED_DNS_HOST_NAME = "{72E39547-7B18-11D1-ADEF-00C04FD8D5CD}" ; See: http://msdn.microsoft.com/en-us/library/ms684331(VS.85).aspx
Global Const $VALIDATED_SPN = "{F3A64788-5306-11D1-A9C5-0000F80367C1}" ; See: http://msdn.microsoft.com/en-us/library/ms684417(VS.85).aspx
; ===============================================================================================================================
#EndRegion #CONSTANTS#

; #CURRENT# =====================================================================================================================
;_AD_Open
;_AD_Close
;_AD_ErrorNotify
;_AD_SamAccountNameToFQDN
;_AD_FQDNToSamAccountName
;_AD_FQDNToDisplayname
;_AD_ObjectExists
;_AD_GetSchemaAttributes
;_AD_GetObjectAttribute
;_AD_IsMemberOf
;_AD_HasFullRights
;_AD_HasUnlockResetRights
;_AD_HasRequiredRights
;_AD_HasGroupUpdateRights
;_AD_GetObjectClass
;_AD_GetUserGroups
;_AD_GetUserPrimaryGroup
;_AD_SetUserPrimaryGroup
;_AD_RecursiveGetMemberOf
;_AD_GetGroupMembers
;_AD_RecursiveGetGroupMembers
;_AD_GetGroupMemberOf
;_AD_GetObjectsInOU
;_AD_GetAllOUs
;_AD_ListDomainControllers
;_AD_ListRootDSEAttributes
;_AD_ListRoleOwners
;_AD_GetLastLoginDate
;_AD_IsObjectDisabled
;_AD_IsObjectLocked
;_AD_IsPasswordExpired
;_AD_GetObjectsDisabled
;_AD_GetObjectsLocked
;_AD_GetPasswordExpired
;_AD_GetPasswordDontExpire
;_AD_GetObjectProperties
;_AD_CreateOU
;_AD_CreateUser
;_AD_SetPassword
;_AD_ChangePassword
;_AD_CreateGroup
;_AD_AddUserToGroup
;_AD_RemoveUserFromGroup
;_AD_CreateComputer
;_AD_ModifyAttribute
;_AD_RenameObject
;_AD_MoveObject
;_AD_DeleteObject
;_AD_SetAccountExpire
;_AD_DisablePasswordExpire
;_AD_EnablePasswordExpire
;_AD_EnablePasswordChange
;_AD_DisablePasswordChange
;_AD_UnlockObject
;_AD_DisableObject
;_AD_EnableObject
;_AD_GetPasswordInfo
;_AD_ListExchangeServers
;_AD_ListExchangeMailboxStores
;_AD_GetSystemInfo
;_AD_GetManagedBy
;_AD_GetManager
;_AD_GetGroupAdmins
;_AD_GroupManagerCanModify
;_AD_ListPrintQueues
;_AD_SetGroupManagerCanModify
;_AD_GroupAssignManager
;_AD_GroupRemoveManager
;_AD_AddEmailAddress
;_AD_JoinDomain
;_AD_UnjoinDomain
;_AD_SetPasswordExpire
;_AD_CreateMailbox
;_AD_DeleteMailbox
;_AD_MailEnableGroup
;_AD_IsAccountExpired
;_AD_GetAccountsExpired
;_AD_ListSchemaVersions
;_AD_ObjectExistsInSchema
;_AD_FixSpecialChars
;_AD_GetLastADSIError
;_AD_GetADOProperties
;_AD_SetADOProperties
;_AD_VersionInfo
; ===============================================================================================================================
; #INTERNAL_USE_ONLY#============================================================================================================
;__AD_Int8ToSec
;__AD_LargeInt2Double
;__AD_ObjGet
;__AD_ErrorHandler
;__AD_ReorderACE
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_Open
; Description ...: Opens a connection to Active Directory.
; Syntax.........: _AD_Open([$sUserIdParam = "", $sPasswordParam = ""[, $sDNSDomainParam = "", $sHostServerParam = "", $sConfigurationParam = ""[, $iSecurity = 0]]])
; Parameters ....: $sUserIdParam - Optional: UserId credential for authentication. This has to be a valid domain user
;                  $sPasswordParam - Optional: Password for authentication
;                  $sDNSDomainParam - Optional: Active Directory domain name if you want to connect to an alternate domain e.g. DC=microsoft,DC=com
;                  $sHostServerParam - Optional: Name of Domain Controller if you want to connect to a different domain e.g. DC-Server1.microsoft.com
;                  |If you want to connect to a Global Catalog append port 3268 e.g. DC-Server1.microsoft.com:3268
;                  |You can omit the servername e.g. only specify microsoft.com if you want to access the domain root
;                  $sConfigurationParam - Optional: Configuration naming context if you want to connect to a different domain e.g. CN=Configuration,DC=microsoft,DC=com
;                  $iSecurity - Optional: Specifies the security settings to be used. Can be a combination of the following:
;                  |0: No security settings are used (default)
;                  |1: Sets the connection property "Encrypt Password" to True to encrypt userid and password
;                  |2: The channel is encrypted using Secure Sockets Layer (SSL). AD requires that the Certificate Server be installed to support SSL
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - (No longer used)
;                  |2 - Creation of the COM object to the AD failed. @extended returns error code from ObjCreate
;                  |3 - Open the connection to AD failed. @extended returns error code of the COM error handler.
;                  |    Generated if the User doesn't have query / modify access
;                  |4 - Creation of the RootDSE object failed. @extended returns the error code received by the COM error handler.
;                  |    Generated when connection to the domain isn't successful. @extended returns -2147023541 (0x8007054B)
;                  |5 - Creation of the DS object failed. @extended returns the error code received by the COM error handler
;                  |6 - Parameter $sHostServerParam and $sConfigurationParam are required when $sDNSDomainParam is specified
;                  |7 - Parameter $sPasswordParam is required when $sUserIdParam is specified
;                  |8 - OpenDSObject method failed. @extended set to error code received from the OpenDSObject method.
;                  |    On Windows XP or lower this shows that $sUserIdParam and/or $sPasswordParam are invalid
;                  |x - For Windows Vista and later: Win32 error code (decimal). To get detailed error information call function _AD_GetLastADSIError
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: To close the connection to the Active Directory, use the _AD_Close function.
;+
;                  _AD_Open will use the alternative credentials $sUserIdParam and $sPasswordParam if passed as parameters.
;                  $sUserIdParam has to be in one of the following forms (assume the samAccountName = DJ)
;                  * Windows Login Name   e.g. "DJ"
;                  * NetBIOS Login Name   e.g. "<DOMAIN>\DJ"
;                  * User Principal Name  e.g. "DJ@domain.com"
;                  All other name formats have NOT been successfully tested (see section "Link").
;+
;                  Connection to an alternate domain (not the domain your computer is a member of) or if your computer is not a domain member
;                  requires $sDNSDomainParam, $sHostServerParam and $sConfigurationParam as FQDN as well as $sUserIdParam and $sPasswordParam.
;                  Example:
;                  $sDNSDomainParam = "DC=subdomain,DC=example,DC=com"
;                  $sHostServerParam = "servername.subdomain.example.com"
;                  $sConfigurationParam = "CN=Configuration,DC=subdomain,DC=example,DC=com"
;+
;                  The COM error handler will be initialized only if there doesn't already exist another error handler.
;+
;                  If you specify $sUserIdParam as NetBIOS Login Name or User Principal Name and the OS is Windows Vista or later then _AD_Open will try to
;                  verify the userid/password.
;                  @error will be set to the Win32 error code (decimal). To get detailed error information please call _AD_GetlastADSIError.
;                  For all other OS or if userid is specified as Windows Login Name @error=8.
;                  This is OS dependant because Windows XP doesn't return useful error information.
;                  For Windows Login Name all OS return success even when an error occures. This seems to be caused by secure authentification.
;+
;                  $iSecurity = 2 activates LDAP/SSL. LDAP/SSL uses port 636 by default.
;                  Note that an SSL server certificate must be configured properly in order to use SSL.
;+
;                  If you want to connect to a specific DC in the current domain then just provide $sHostServerParam and let $sDNSDomainParam and $sConfigurationParam be blank.
; Related .......: _AD_Close
; Link ..........: http://msdn.microsoft.com/en-us/library/cc223499(PROT.10).aspx (Simple Authentication), http://msdn.microsoft.com/en-us/library/aa746471(VS.85).aspx (ADO)
; Example .......: Yes
; ===============================================================================================================================
Func _AD_Open($sUserIdParam = "", $sPasswordParam = "", $sDNSDomainParam = "", $sHostServerParam = "", $sConfigurationParam = "", $iSecurity = 0)

	$__oAD_Connection = ObjCreate("ADODB.Connection") ; Creates a COM object to AD
	If @error Or Not IsObj($__oAD_Connection) Then Return SetError(2, @error, 0)
	; Activate the COM error handler for older AutoIt versions
	If $__iAD_Debug = 0 And Number(StringReplace(@AutoItVersion, ".", "")) < 3392 Then
		_AD_ErrorNotify(1)
		SetError(0) ; Reset @error which is returned by _AD_ErrorNotify if a COM error handler has already been set up by the user
	EndIf
	; ConnectionString Property (ADO): http://msdn.microsoft.com/en-us/library/ms675810.aspx
	$__oAD_Connection.ConnectionString = "Provider=ADsDSOObject" ; Sets Service providertype
	If $sUserIdParam <> "" Then
		If $sPasswordParam = "" Then Return SetError(7, 0, 0)
		$__oAD_Connection.Properties("User ID") = $sUserIdParam ; Authenticate User
		$__oAD_Connection.Properties("Password") = $sPasswordParam ; Authenticate User
		If BitAND($iSecurity, 1) = 1 Then $__oAD_Connection.Properties("Encrypt Password") = True ; Encrypts userid and password
		$__bAD_BindFlags = $ADS_SERVER_BIND
		If BitAND($iSecurity, 2) = 2 Then $__bAD_BindFlags = BitOR($__bAD_BindFlags, $ADS_USE_SSL)
		; If userid is the Windows login name then set the flag for secure authentification
		If StringInStr($sUserIdParam, "\") = 0 And StringInStr($sUserIdParam, "@") = 0 Then _
				$__bAD_BindFlags = BitOR($__bAD_BindFlags, $ADS_SECURE_AUTH)
		$__oAD_Connection.Properties("ADSI Flag") = $__bAD_BindFlags
		$sAD_UserId = $sUserIdParam
		$sAD_Password = $sPasswordParam
	EndIf
	; ADO Open Method: http://msdn.microsoft.com/en-us/library/ms676505.aspx
	$__oAD_Connection.Open() ; Open connection to AD
	If @error Then Return SetError(3, @error, 0)
	; Connect to another Domain if the Domain parameter is provided
	If $sDNSDomainParam <> "" Then
		If $sHostServerParam = "" Or $sConfigurationParam = "" Then Return SetError(6, 0, 0)
		$__oAD_RootDSE = ObjGet("LDAP://" & $sHostServerParam & "/RootDSE")
		If @error Or Not IsObj($__oAD_RootDSE) Then Return SetError(4, @error, 0)
		$sAD_DNSDomain = $sDNSDomainParam
		$sAD_HostServer = $sHostServerParam
		$sAD_Configuration = $sConfigurationParam
	ElseIf $sHostServerParam <> "" Then ;=> allows to connect to a specific DC in the current domain
		$__oAD_RootDSE = ObjGet("LDAP://" & $sHostServerParam & "/RootDSE")
		If @error Or Not IsObj($__oAD_RootDSE) Then Return SetError(4, @error, 0)
		$sAD_DNSDomain = $__oAD_RootDSE.Get("defaultNamingContext")
		$sAD_HostServer = $sHostServerParam
		$sAD_Configuration = $__oAD_RootDSE.Get("ConfigurationNamingContext")
	Else
		$__oAD_RootDSE = ObjGet("LDAP://RootDSE")
		If @error Or Not IsObj($__oAD_RootDSE) Then Return SetError(4, @error, 0)
		$sAD_DNSDomain = $__oAD_RootDSE.Get("defaultNamingContext") ; Retrieve the current AD domain name
		$sAD_HostServer = $__oAD_RootDSE.Get("dnsHostName") ; Retrieve the name of the connected DC
		$sAD_Configuration = $__oAD_RootDSE.Get("ConfigurationNamingContext") ; Retrieve the Configuration naming context
		$__oAD_RootDSE = ObjGet("LDAP://" & $sAD_HostServer & "/RootDSE") ; To guarantee a persistant binding
	EndIf
	; Check userid/password if provided
	If $sUserIdParam <> "" Then
		$__oAD_OpenDS = ObjGet("LDAP:")
		If @error Or Not IsObj($__oAD_OpenDS) Then Return SetError(5, @error, 0)
		$__oAD_Bind = $__oAD_OpenDS.OpenDSObject("LDAP://" & $sAD_HostServer, $sUserIdParam, $sPasswordParam, $__bAD_BindFlags)
		If @error Or Not IsObj($__oAD_Bind) Then ; login error occurred - get extended information
			Local $iError = @error
			Local $sHive = "HKLM"
			If @OSArch = "IA64" Or @OSArch = "X64" Then $sHive = "HKLM64"
			Local $sOSVersion = RegRead($sHive & "\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentVersion")
			$sOSVersion = StringSplit($sOSVersion, ".")
			If Int($sOSVersion[1]) >= 6 Then ; Delivers detailed error information for Windows Vista and later if debugging is activated
				Local $aErrors = _AD_GetLastADSIError()
				If $aErrors[4] <> 0 Then
					If $__iAD_Debug = 1 Then ConsoleWrite("_AD_Open: " & _ArrayToString($aErrors, @CRLF, 1) & @CRLF)
					If $__iAD_Debug = 2 Then MsgBox(64, "Active Directory Functions - Debug Info - _AD_Open", _ArrayToString($aErrors, @CRLF, 1))
					If $__iAD_Debug = 3 Then FileWrite($__sAD_DebugFile, @YEAR & "." & @MON & "." & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @CRLF & _
							"-------------------" & @CRLF & "_AD_Open: " & _ArrayToString($aErrors, @CRLF, 1) & @CRLF & _
							"========================================================" & @CRLF)
					Return SetError(Dec($aErrors[4]), 0, 0)
				EndIf
				Return SetError(8, $iError, 0)
			Else
				Return SetError(8, $iError, 0)
			EndIf
		EndIf
	EndIf
	; ADO Command object as global
	$__oAD_Command = ObjCreate("ADODB.Command")
	$__oAD_Command.ActiveConnection = $__oAD_Connection
	$__oAD_Command.Properties("Page Size") = 1000
	Return 1

EndFunc   ;==>_AD_Open

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_Close
; Description ...: Closes the connection established to Active Directory by _AD_Open.
; Syntax.........: _AD_Close()
; Parameters ....: None
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - Closing the connection to the AD failed. @extended returns the error code received by the COM error handler
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Even if closing the connection wasn't successfull and @error is set all used variables have been reset.
; Related .......: _AD_Open
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_Close()

	$__oAD_Connection.Close() ; Close Connection
	; Reset all Global Variables
	$__iAD_Debug = 0
	$__sAD_DebugFile = @ScriptDir & "\AD_Debug.txt"
	$__oAD_MyError = 0
	$__oAD_Connection = 0
	$sAD_DNSDomain = ""
	$sAD_HostServer = ""
	$sAD_Configuration = ""
	$__oAD_OpenDS = 0
	$__oAD_RootDSE = 0
	$sAD_UserId = ""
	$sAD_Password = ""
	If @error Then Return SetError(1, @error, 0) ; Error returned by connection close
	Return 1

EndFunc   ;==>_AD_Close

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ErrorNotify
; Description ...: Set or query the debug level.
; Syntax.........: _AD_ErrorNotify($iDebug[, $sDebugFile = @ScriptDir & "\AD_Debug.txt"])
; Parameters ....: $iDebug - Debug level. Allowed values are:
;                  |-1 - Return the current settings
;                  |0  - Disable debugging
;                  |1  - Enable debugging. Output the debug info to the console
;                  |2  - Enable Debugging. Output the debug info to a MsgBox
;                  |3  - Enable Debugging. Output the debug info to a file defined by $sDebugFile
;                  |4  - Enable Debugging. The COM errors will be handled (the script no longer crashes) without any output
;                  $sDebugFile - Optional: File to write the debugging info to if $iDebug = 3 (Default = @ScriptDir & "\AD_Debug.txt")
; Return values .: Success (for $iDebug = -1) - one based one-dimensional array with the following elements:
;                  |1 - Debug level. Value from 0 to 3. Check parameter $iDebug for details
;                  |2 - Debug file. File to write the debugging info to as defined by parameter $sDebugFile
;                  |3 - True if the COM error handler has beend set for this UDF. False if debugging is set off or another COM error handler was already stt
;                  Success (for $iDebug = 0) - 1
;                  Success (for $iDebug => 0) - 1, sets @extended to:
;                  |0 - The COM error handler for this UDF was already active
;                  |1 - A COM error handler has successfully been initialized for this UDF
;                  Failure - 0, sets @error to:
;                  |1 - $iDebug is not an integer or < -1 or > 4
;                  |2 - Installation of the custom error handler failed. @extended is set to the error code returned by ObjEvent
;                  |3 - COM error handler already set to another function
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ErrorNotify($iDebug, $sDebugFile = "")

	If Not IsInt($iDebug) Or $iDebug < -1 Or $iDebug > 4 Then Return SetError(1, 0, 0)
	If $sDebugFile = "" Then $sDebugFile = @ScriptDir & "\AD_Debug.txt"
	Switch $iDebug
		Case -1
			Local $avDebug[4] = [3]
			$avDebug[1] = $__iAD_Debug
			$avDebug[2] = $__sAD_DebugFile
			$avDebug[3] = IsObj($__oAD_MyError)
			Return $avDebug
		Case 0
			$__iAD_Debug = 0
			$__sAD_DebugFile = ""
			$__oAD_MyError = 0
		Case Else
			$__iAD_Debug = $iDebug
			$__sAD_DebugFile = $sDebugFile
			; A COM error handler will be initialized only if one does not exist
			If ObjEvent("AutoIt.Error") = "" Then
				$__oAD_MyError = ObjEvent("AutoIt.Error", "__AD_ErrorHandler") ; Creates a custom error handler
				If @error Then Return SetError(2, @error, 0)
				Return SetError(0, 1, 1)
			ElseIf ObjEvent("AutoIt.Error") = "__AD_ErrorHandler" Then
				Return SetError(0, 0, 1) ; COM error handler already set by a call to this function
			Else
				Return SetError(3, 0, 0) ; COM error handler already set by another function
			EndIf
	EndSwitch
	Return 1

EndFunc   ;==>_AD_ErrorNotify

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_SamAccountNameToFQDN
; Description ...: Returns a Fully Qualified Domain Name (FQDN) from a SamAccountName.
; Syntax.........: _AD_SamAccountNameToFQDN([$sSamAccountName = @UserName])
; Parameters ....: $sSamAccountName - Optional: Security Accounts Manager (SAM) account name (default = @UserName)
; Return values .: Success - Fully Qualified Domain Name (FQDN)
;                  Failure - "", sets @error to:
;                  |1 - No record returned from Active Directory. $sSamAccountName not found
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: A $ sign must be appended to the computer name to generate the FQDN for a sAMAccountName e.g. @ComputerName & "$".
;                  The function escapes the following special characters (# and /). Commas in CN= or OU= have to be escaped by you.
;                  If $sSamAccountName is already a FQDN then the function returns $sSamAccountName unchanged and without raising an error.
; Related .......: _AD_FQDNToSamAccountName
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SamAccountNameToFQDN($sSamAccountName = @UserName)

	If StringMid($sSamAccountName, 3, 1) = "=" Then Return $sSamAccountName ; already a FQDN. Return unchanged
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(sAMAccountName=" & $sSamAccountName & ");distinguishedName;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	Local $sFQDN = $oRecordSet.fields(0).value
	Return _AD_FixSpecialChars($sFQDN, 0, "/#")

EndFunc   ;==>_AD_SamAccountNameToFQDN

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_FQDNToSamAccountName
; Description ...: Returns the SamAccountName of a Fully Qualified Domain Name (FQDN).
; Syntax.........: _AD_FQDNToSamAccountName($sFQDN)
; Parameters ....: $sFQDN - Fully Qualified Domain Name (FQDN)
; Return values .: Success - SamAccountName
;                  Failure - "", sets @error to:
;                  |1 - No record returned from Active Directory. $sFQDN not found
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: You have to escape commas in $sFQDN with a backslash. E.g. "CN=Lastname\, Firstname,OU=..."
;                  All other special characters (# and /) are escaped by the function.
;                  If $sFQDN is already a SamAccountName then the function returns $sFQDN unchanged and without raising an error.
; Related .......: _AD_SamAccountNameToFQDN, _AD_FQDNToDisplayname
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_FQDNToSamAccountName($sFQDN)

	If StringMid($sFQDN, 3, 1) <> "=" Then Return $sFQDN ; already a SamAccountName. Return unchanged
	$sFQDN = _AD_FixSpecialChars($sFQDN, 0, "/#") ; Escape special characters in the FQDN
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sFQDN)
	If @error Or Not IsObj($oObject) Or $oObject = 0 Then Return SetError(1, @error, "")
	Local $sResult = $oObject.sAMAccountName
	Return $sResult

EndFunc   ;==>_AD_FQDNToSamAccountName

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_FQDNToDisplayname
; Description ...: Returns the Display Name of a Fully Qualified Domain Name (FQDN) object.
; Syntax.........: _AD_FQDNToDisplayname($sFQDN)
; Parameters ....: $sFQDN - Fully Qualified Domain Name (FQDN)
; Return values .: Success - Display Name
;                  Failure - "", sets @error to:
;                  |x - @error as set by function _AD_GetObjectAttribute
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: You must escape commas in $sFQDN with a backslash. E.g. "CN=Lastname\, Firstname,OU=..."
;                  All other special characters (# and /) are escaped by the function.
;                  The function removes all escape characters (\) from the returned value.
; Related .......: _AD_FQDNToSamAccountName
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_FQDNToDisplayname($sFQDN)

	Local $sName = _AD_GetObjectAttribute($sFQDN, "displayname")
	If @error Then Return SetError(@error, @extended, "")
	Return _AD_FixSpecialChars($sName, 1)

EndFunc   ;==>_AD_FQDNToDisplayname

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ObjectExists
; Description ...: Returns 1 if exactly one object exists for the given property in the local Active Directory Tree.
; Syntax.........: _AD_ObjectExists([$sObject = @UserName[, $sProperty = ""]])
; Parameters ....: $sObject   - Optional: Object (user, computer, group, OU) to check (default = @UserName)
;                  $sProperty - Optional: Property to check. If omitted the function tries to determine whether to use sAMAccountname or FQDN
; Return values .: Success - 1, Exactly one object exists for the given property in the local Active Directory Tree
;                  Failure - 0, sets @error to:
;                  |1 - No object found for the specified property
;                  |x - More than one object found for the specified property. x is the number of objects found
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Checking on a computer account requires a "$" (dollar) appended to the sAMAccountName.
;                  To check the existence of an OU use the FQDN of the OU as first parameter because an OU has no SamAccountName.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ObjectExists($sObject = @UserName, $sProperty = "")

	If $sProperty = "" Then
		$sProperty = "samAccountName"
		If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName"
	EndIf
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object, if it exists
	If IsObj($oRecordSet) Then
		If $oRecordSet.RecordCount = 1 Then
			Return 1
		ElseIf $oRecordSet.RecordCount > 1 Then
			Return SetError($oRecordSet.RecordCount, 0, 0)
		Else
			Return SetError(1, 0, 0)
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf

EndFunc   ;==>_AD_ObjectExists

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetSchemaAttributes
; Description ...: Enumerates attributes from the AD Schema (those replicated to the Global Catalog, indexed attributes or all).
; Syntax.........: _AD_GetSchemaAttributes([$iSelect = 1])
; Parameters ....: $iSelect - Optional: Specifies the attributes to be returned:
;                  |1 - Return all attributes (default)
;                  |2 - Return all attributes that are replicated to the Global Catalog
;                  |3 - Return all attributes that are indexed
; Return values .: Success - One-based two dimensional array with the following information for all selected attributes:
;                  |0 - ldapDisplayName of the attribute
;                  |1 - True if the attribute is replicated to the Global Catalog, False or "" of not
;                  |2 - True if the attribute is indexed. Indexed attributes give better performance
;                  Failure - "", sets @error to:
;                  |1 - The LDAP query returned no records or another error occurred
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetSchemaAttributes($iSelect = 1)

	Local $aBool[2] = [False, True]
	Local Const $IS_INDEXED = 1
	Local $sQuery
	Local $sSchemaNamingContext = $__oAD_RootDSE.Get("SchemaNamingContext")
	If $iSelect > 3 Or $iSelect < 1 Then $iSelect = 1
	If $iSelect = 1 Then $sQuery = "(objectClass=attributeSchema)" ; all attributes
	If $iSelect = 2 Then $sQuery = "(&(objectClass=attributeSchema)(isMemberOfPartialAttributeSet=TRUE))" ; attributes replicated to the GC
	If $iSelect = 3 Then $sQuery = "(&(objectClass=attributeSchema)(searchFlags:1.2.840.113556.1.4.803:=1))" ; indexed attributes
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sSchemaNamingContext & ">;" & $sQuery & ";lDAPDisplayName,isMemberOfPartialAttributeSet,searchFlags;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Then Return SetError(1, @error, "")
	Local $aAttributes[$oRecordSet.RecordCount + 1][3] = [[$oRecordSet.RecordCount, 3]]
	Local $iIndex = 1
	$oRecordSet.MoveFirst
	While Not $oRecordSet.EOF
		$aAttributes[$iIndex][0] = $oRecordSet.Fields("lDAPDisplayName").Value
		$aAttributes[$iIndex][1] = $oRecordSet.Fields("isMemberOfPartialAttributeSet").Value
		$aAttributes[$iIndex][2] = $aBool[BitAND($oRecordSet.Fields("searchFlags").Value, $IS_INDEXED)]
		$iIndex = $iIndex + 1
		$oRecordSet.MoveNext
	WEnd
	Return $aAttributes

EndFunc   ;==>_AD_GetSchemaAttributes

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetObjectAttribute
; Description ...: Returns the specified attribute for the named object.
; Syntax.........: _AD_GetObjectAttribute($sObject, $sAttribute)
; Parameters ....: $sObject - sAMAccountName or FQDN of the object the attribute should be retrieved from
;                  $sAttribute - Attribute to be retrieved
; Return values .: Success - Value for the given attribute
;                  Failure - "", sets @error to:
;                  |1 - $sObject does not exist
;                  |2 - $sAttribute does not exist for $sObject. @Extended is set to the error returned by LDAP
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: If the attribute is a single-value the function returns a string otherwise it returns an array.
;                  To get decrypted attributes (GUID, SID, dates etc.) please see _AD_GetObjectProperties.
; Related .......: _AD_ModifyAttribute, _AD_GetObjectProperties
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetObjectAttribute($sObject, $sAttribute)

	Local $sProperty = "sAMAccountName"
	If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName" ; FQDN provided
	If _AD_ObjectExists($sObject, $sProperty) = 0 Then Return SetError(1, 0, "")
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(2, @error, "")
	Local $sLDAPEntry = $oRecordSet.fields(0).value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	Local $sResult = $oObject.Get($sAttribute)
	If @error Then Return SetError(2, @error, "")
	$oObject.PurgePropertyList
	If IsArray($sResult) Then _ArrayInsert($sResult, 0, UBound($sResult, 1))
	Return $sResult

EndFunc   ;==>_AD_GetObjectAttribute

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_IsMemberOf
; Description ...: Returns 1 if the object (user, group, computer) is a member of the specified group or any contained group.
; Syntax.........: _AD_IsMemberOf($sGroup[, $sObject = @Username[, $bIncludePrimaryGroup = False[, $bRecursive = False[, $iDepth = 10]]]])
; Parameters ....: $sGroup - Group to be checked for membership. Can be specified as sAMAccountName or Fully Qualified Domain Name (FQDN)
;                  $sObject - Optional: Object type (user, group, computer) to check for membership of $sGroup. Can be specified as sAMAccountName or Fully Qualified Domain Name (FQDN) (default = @UserName)
;                  $bIncludePrimaryGroup - Optional: Additionally checks the primary group for object membership (default = False)
;                  $bRecursive - Optional: Recursively check all groups of $sGroup up to the depth defined by $iDepth (default = False)
;                  $iDepth - Optional: Maximum depth of recursion (default = 10)
; Return values .: Success - 1, Specified object (user, group, computer) is a member of the specified group
;                  Failure - 0, @error set
;                  |0 - $sObject is not a member of $sGroup
;                  |1 - $sGroup does not exist
;                  |2 - $sObject does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Determines if the object is an immediate member of the group. This function does not verify membership in any nested groups.
; Related .......: _AD_GetUserGroups, _AD_GetUserPrimaryGroup, _AD_RecursiveGetMemberOf
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_IsMemberOf($sGroup, $sObject = @UserName, $bIncludePrimaryGroup = False, $bRecursive = False, $iDepth = 10)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, 0)
	If _AD_ObjectExists($sObject) = 0 Then Return SetError(2, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup)
	Local $iResult = $oGroup.IsMember("LDAP://" & $sAD_HostServer & "/" & $sObject)
	If $iResult = 0 And $bRecursive = True Then
		For $oMember In $oGroup.Members
			If StringLower($oMember.Class) = 'group' Then
				If $iDepth > 0 Then
					If _AD_IsMemberOf($oMember.distinguishedName, $sObject, $bIncludePrimaryGroup, True, $iDepth - 1) Then Return 1
				EndIf
			Else
				If StringLower($oMember.distinguishedName) = $sObject Then Return 1
			EndIf
		Next
	EndIf
	; Check Primary Group if $sObject isn't a member of the specified group and the flag is set
	If $iResult = 0 And $bIncludePrimaryGroup Then $iResult = (_AD_GetUserPrimaryGroup($sObject) = $sGroup)
	; Abs is necessary to make it work for AutoIt versions < 3.3.2.0 with bug #1068
	Return Abs($iResult)

EndFunc   ;==>_AD_IsMemberOf

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_HasFullRights
; Description ...: Returns 1 if the given user has full rights over the given group or user.
; Syntax.........: _AD_HasFullRights($sObject[, $sUser = @UserName])
; Parameters ....: $sObject - Group or User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $sUser - Optional: User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or SamAccountName (default = @UserName)
; Return values .: Success - 1, Specified user has full rights over the given group or user
;                  Failure - 0, @error set
;                  |0 - $sUser does not have full rights over $sObject
;                  |1 - $sUser does not exist
;                  |2 - $sObject does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_HasUnlockResetRights, _AD_HasRequiredRights, _AD_HasGroupUpdateRights
; Link ..........: http://msdn.microsoft.com/en-us/library/aa772285(VS.85).aspx (ADS_RIGHTS_ENUM Enumeration)
; Example .......: Yes
; ===============================================================================================================================
Func _AD_HasFullRights($sObject, $sUser = @UserName)

	Local $iResult = _AD_HasRequiredRights($sObject, $ADS_FULL_RIGHTS, $sUser)
	Return SetError(@error, @extended, $iResult)

EndFunc   ;==>_AD_HasFullRights

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_HasUnlockResetRights
; Description ...: Returns 1 if the given user has unlock and password reset rights on the object.
; Syntax.........: _AD_HasUnlockResetRights($sObject[, $sUser = @UserName])
; Parameters ....: $sObject - Group or User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $sUser - Optional: User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or SamAccountName (default = @UserName)
; Return values .: Success - 1, Specified user has unlock and password reset rights over the given group or user
;                  Failure - 0, @error set
;                  |0 - $sUser does not have unlock and password reset rights over $sObject
;                  |1 - $sUser does not exist
;                  |2 - $sObject does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_HasFullRights, _AD_HasRequiredRights, _AD_HasGroupUpdateRights
; Link ..........: http://msdn.microsoft.com/en-us/library/aa772285(VS.85).aspx (ADS_RIGHTS_ENUM Enumeration)
; Example .......: Yes
; ===============================================================================================================================
Func _AD_HasUnlockResetRights($sObject, $sUser = @UserName)

	Local $iResult = _AD_HasRequiredRights($sObject, $ADS_USER_UNLOCKRESETACCOUNT, $sUser)
	Return SetError(@error, @extended, $iResult)

EndFunc   ;==>_AD_HasUnlockResetRights

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_HasRequiredRights
; Description ...: Returns 1 if the given user has the required rights on the object.
; Syntax.........: _AD_HasRequiredRights($sObject[, $iRight = $ADS_FULL_RIGHTS[, $sUser = @UserName]])
; Parameters ....: $sObject - Group or User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $sRight - Optional: Access mask constant to be checked (default = $ADS_FULL_RIGHTS (Full rights)).
;                  |Full rights is the combination of the following rights:
;                  |ADS_RIGHT_DELETE                   = 0x10000
;                  |ADS_RIGHT_READ_CONTROL             = 0x20000
;                  |ADS_RIGHT_WRITE_DAC                = 0x40000
;                  |ADS_RIGHT_WRITE_OWNER              = 0x80000
;                  |ADS_RIGHT_DS_CREATE_CHILD          = 0x1
;                  |ADS_RIGHT_DS_DELETE_CHILD          = 0x2
;                  |ADS_RIGHT_ACTRL_DS_LIST            = 0x4
;                  |ADS_RIGHT_DS_SELF                  = 0x8
;                  |ADS_RIGHT_DS_READ_PROP             = 0x10
;                  |ADS_RIGHT_DS_WRITE_PROP            = 0x20
;                  |ADS_RIGHT_DS_DELETE_TREE           = 0x40
;                  |ADS_RIGHT_DS_LIST_OBJECT           = 0x80
;                  |ADS_RIGHT_DS_CONTROL_ACCESS        = 0x100
;                  $sUser - Optional: User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or SamAccountName (default = @UserName)
; Return values .: Success - 1, Specified user has the required rights over the given group or user
;                  Failure - 0, @error set
;                  |0 - $sUser does not have the required rights over $sObject
;                  |1 - $sUser does not exist
;                  |2 - $sObject does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_HasFullRights, _AD_HasUnlockResetRights, _AD_HasGroupUpdateRights
; Link ..........: http://msdn.microsoft.com/en-us/library/aa772285(VS.85).aspx (ADS_RIGHTS_ENUM Enumeration)
; Example .......: Yes
; ===============================================================================================================================
Func _AD_HasRequiredRights($sObject, $iRight = $ADS_FULL_RIGHTS, $sUser = @UserName)

	If _AD_ObjectExists($sUser) = 0 Then Return SetError(1, 0, 0)
	If _AD_ObjectExists($sObject) = 0 Then Return SetError(2, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $aMemberOf, $aTrusteeArray, $sTrusteeGroup
	$aMemberOf = _AD_GetUserGroups($sUser, 1)
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	If IsObj($oObject) Then
		Local $oSecurity = $oObject.Get("ntSecurityDescriptor")
		Local $oDACL = $oSecurity.DiscretionaryAcl
		For $oACE In $oDACL
			$aTrusteeArray = StringSplit($oACE.Trustee, "\")
			$sTrusteeGroup = $aTrusteeArray[$aTrusteeArray[0]]
			For $iCount1 = 0 To UBound($aMemberOf) - 1
				If StringInStr($aMemberOf[$iCount1], "CN=" & $sTrusteeGroup & ",") And _
						BitAND($oACE.AccessMask, $iRight) = $iRight Then Return 1
			Next
		Next
	EndIf
	Return 0

EndFunc   ;==>_AD_HasRequiredRights

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_HasGroupUpdateRights
; Description ...: Returns 1 if the given user has rights to update the group membership of the object.
; Syntax.........: _AD_HasGroupUpdateRights($sObject[, $sUser = @UserName])
; Parameters ....: $sObject - Group to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $sUser - Optional: User to be checked. Can be specified as Fully Qualified Domain Name (FQDN) or SamAccountName (default = @UserName)
; Return values .: Success - 1, Specified user has the rights to update the group membership on the given group
;                  Failure - 0, @error set
;                  |0 - $sUser does not have the rights to update the group membership on $sObject
;                  |1 - $sUser does not exist
;                  |2 - $sObject does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_HasFullRights, _AD_HasUnlockResetRights, _AD_HasRequiredRights
; Link ..........: http://msdn.microsoft.com/en-us/library/aa772285(VS.85).aspx (ADS_RIGHTS_ENUM Enumeration)
; Example .......: Yes
; ===============================================================================================================================
Func _AD_HasGroupUpdateRights($sObject, $sUser = @UserName)

	Local $iResult = _AD_HasRequiredRights($sObject, $ADS_OBJECT_READWRITE_ALL, $sUser)
	Return SetError(@error, @extended, $iResult)

EndFunc   ;==>_AD_HasGroupUpdateRights

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetObjectClass
; Description ...: Returns the main class (also called structural class) of an object ("user", "group" etc.).
; Syntax.........: _AD_GetObjectClass($sObject[, $bAll = False])
; Parameters ....: $sObject - Object for which the main class should be returned. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $bAll    - Optional: Returns the main class plus the superior classes from which the main class is deduced hierarchically (default = False)
; Return values .: Success - Main class of the specified object if $bAll = False or an zero-based array of the main plus the superior classes if $bAll = True
;                  Failure - "", sets @error to:
;                  |1 - Specified object does not exist
;                  |2 - The LDAP query returned no record. @extended is set to the error returned by LDAP
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetObjectClass($sObject, $bAll = False)

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, "")
	Local $sProperty = "sAMAccountName"
	If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName" ; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	If @error Or Not IsObj($oRecordSet) Then Return SetError(2, @error, "")
	Local $sLDAPEntry = $oRecordSet.fields(0).value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	If $bAll Then Return $oObject.ObjectClass
	Return $oObject.Class

EndFunc   ;==>_AD_GetObjectClass

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetUserGroups
; Description ...: Returns an array of group names that the user is immediately a member of.
; Syntax.........: _AD_GetUserGroups([$sUser = @UserName[, $bIncludePrimaryGroup = False]])
; Parameters ....: $sUser                - Optional: User for which the group membership is to be returned (default = @Username). Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $bIncludePrimaryGroup - Optional: include the primary group to the returned list (default = False)
; Return values .: Success - Returns an one-based one dimensional array of group names (FQDN) the user is a member of
;                  Failure - "", sets @error to:
;                  |1 - Specified user does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Works for computers or groups as well.
; Related .......: _AD_IsMemberOf, _AD_GetUserPrimaryGroup, _AD_RecursiveGetMemberOf
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetUserGroups($sUser = @UserName, $bIncludePrimaryGroup = False)

	If _AD_ObjectExists($sUser) = 0 Then Return SetError(1, 0, "")
	Local $sProperty = "sAMAccountName"
	If StringMid($sUser, 3, 1) = "=" Then $sProperty = "distinguishedName" ; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sUser & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the FQDN for the logged on user
	Local $sLDAPEntry = $oRecordSet.fields(0).value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the logged on user
	Local $aGroups = $oObject.GetEx("memberof")
	If IsArray($aGroups) Then
		If $bIncludePrimaryGroup Then _ArrayAdd($aGroups, _AD_GetUserPrimaryGroup($sUser))
		_ArrayInsert($aGroups, 0, UBound($aGroups))
	Else
		Local $aGroups[1] = [0]
		If $bIncludePrimaryGroup Then _ArrayAdd($aGroups, _AD_GetUserPrimaryGroup($sUser))
		$aGroups[0] = UBound($aGroups) - 1
	EndIf
	Return $aGroups

EndFunc   ;==>_AD_GetUserGroups

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetUserPrimaryGroup
; Description ...: Returns the primary group the user is assigned to.
; Syntax.........: _AD_GetUserPrimaryGroup([$sUser = @UserName])
; Parameters ....: $sUser - Optional: User for which the primary group is to be returned (default = @Username). Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - Primary group (FQDN) the user is assigned to.
;                  Failure - "", sets @error to:
;                  |1 - Specified user does not exist
;                  |2 - A primary group couldn't be found for the specified user
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsMemberOf, _AD_GetUserGroups, _AD_RecursiveGetMemberOf, _AD_SetUserPrimaryGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetUserPrimaryGroup($sUser = @UserName)

	If _AD_ObjectExists($sUser) = 0 Then Return SetError(1, 0, "")
	Local $sProperty = "samAccountName"
	If StringMid($sUser, 3, 1) = "=" Then $sProperty = "distinguishedName"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sUser & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the FQDN for the logged on user
	Local $sLDAPEntry = $oRecordSet.fields(0).value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the logged on user
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(objectCategory=group);cn,primaryGroupToken,DistinguishedName;subtree"
	$oRecordSet = $__oAD_Command.Execute
	While Not $oRecordSet.EOF
		If $oRecordSet.Fields("primaryGroupToken").Value = $oObject.primaryGroupID Then _
				Return $oRecordSet.Fields("DistinguishedName").Value
		$oRecordSet.MoveNext
	WEnd
	Return SetError(2, 0, "")

EndFunc   ;==>_AD_GetUserPrimaryGroup

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_SetUserPrimaryGroup
; Description ...: Sets the users primary group.
; Syntax.........: _AD_SetUserPrimaryGroup($sUser, $sGroup)
; Parameters ....: $sUser - User for which the primary group is to be set. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $sGroup - Group to be set as the primary group for the specified user. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sUser does not exist
;                  |2 - $sGroup does not exist
;                  |3 - $sUser must be a member of $sGroup
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Talder
; Modified.......:
; Remarks .......:
; Related .......: _AD_AddUserToGroup, _AD_GetUserPrimaryGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SetUserPrimaryGroup($sUser, $sGroup)

	If Not _AD_ObjectExists($sUser) Then Return SetError(1, 0, 0)
	If Not _AD_ObjectExists($sGroup) Then Return SetError(2, 0, 0)
	If Not _AD_IsMemberOf($sGroup, $sUser) Then Return SetError(3, 0, 0)
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMACccountName provided
	If StringMid($sUser, 3, 1) <> "=" Then $sUser = _AD_SamAccountNameToFQDN($sUser) ; sAMACccountName provided
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sUser) ; Retrieve the COM Object for the user
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup) ; Retrieve the COM Object for the group
	Local $aTemp[1] = ["primaryGroupToken"]
	$oGroup.GetInfoEx($aTemp, 0)
	$oUser.primaryGroupID = $oGroup.primaryGroupToken
	$oUser.SetInfo()
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_SetUserPrimaryGroup

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_RecursiveGetMemberOf
; Description ...: Takes a group, user or computer and recursively returns a list of groups the object is a member of.
; Syntax.........: _AD_RecursiveGetMemberOf($sObject[, $iDepth = 10[, $bListInherited = True[, $bFQDN = True]]])
; Parameters ....: $sObject - User, group or computer for which the group membership is to be returned. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $iDepth - Optional: Maximum depth of recursion (default = 10)
;                  $bListInherited - Optional: Defines if the function returns the group(s) it was inherited from (default = True)
;                  $bFQDN - Optional: Specifies the attribute to be returned. True = distinguishedName (FQDN), False = SamAccountName (default = True)
; Return values .: Success - Returns an one-based one dimensional array of group names (FQDN or sAMAccountName) the user or group is a member of
;                  Failure - "", sets @error to:
;                  |1 - Specified user, group or computer does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This function traverses the groups that the object is immediately a member of while also checking its group membership.
;                  For groups that are inherited, the return is the FQDN or sAMAccountname of the group, user or computer, and the FQDN(s) or sAMAccountname(s) of the group(s) it
;                  was inherited from, seperated by '|'(s) if flag $bListInherited is set to True.
;+
;                  If flag $bListInherited is set to False then the group names are sorted and only unique groups are returned.
; Related .......: _AD_IsMemberOf, _AD_GetUserGroups, _AD_GetUserPrimaryGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_RecursiveGetMemberOf($sObject, $iDepth = 10, $bListInherited = True, $bFQDN = True)

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, "")
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	$sObject = _AD_FixSpecialChars($sObject, 1, '"\/#+<>;=') ; the object needs to be unescaped (except a comma) for the LDAP query but the result might be escaped
	Local $iCount1, $iCount2
	Local $sField = "distinguishedName"
	If Not $bFQDN Then $sField = "samaccountname"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(member=" & $sObject & ");" & $sField & ";subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	Local $aGroups[$oRecordSet.RecordCount + 1] = [0]
	If $oRecordSet.RecordCount = 0 Then Return $aGroups
	$oRecordSet.MoveFirst
	$iCount1 = 1
	Local $aTempMemberOf[1]
	Do
		$aGroups[$iCount1] = $oRecordSet.Fields(0).Value
		If $iDepth > 0 Then
			$aTempMemberOf = _AD_RecursiveGetMemberOf($aGroups[$iCount1], $iDepth - 1, $bListInherited, $bFQDN)
			If $bListInherited Then
				For $iCount2 = 1 To $aTempMemberOf[0]
					$aTempMemberOf[$iCount2] &= "|" & $aGroups[$iCount1]
				Next
			EndIf
			_ArrayDelete($aTempMemberOf, 0)
			_ArrayConcatenate($aGroups, $aTempMemberOf)
		EndIf
		$iCount1 += 1
		$oRecordSet.MoveNext
	Until $oRecordSet.EOF
	$oRecordSet.Close
	If $bListInherited = False Then
		_ArraySort($aGroups, 0, 1)
		$aGroups = _ArrayUnique($aGroups, 0, 1)
	EndIf
	$aGroups[0] = UBound($aGroups) - 1
	Return $aGroups

EndFunc   ;==>_AD_RecursiveGetMemberOf

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetGroupMembers
; Description ...: Returns an array of group members.
; Syntax.........: _AD_GetGroupMembers($sFQDN)
; Parameters ....: $sGroup - Group to retrieve members from. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - Returns an one-based one dimensional array of names (FQDN) that are members of the specified group
;                  Failure - "", sets @error to:
;                  |1 - Specified group does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: If the group has no members, _AD_GetGroupMembers returns an array with one element (row count) set to 0
; Related .......: _AD_GetGroupMemberOf, _AD_RecursiveGetGroupMembers
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetGroupMembers($sGroup)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, "")
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	Local $sRange, $iRangeModifier, $oRecordSet
	Local $aMembers[1]
	Local $iCount1 = 0
	Local $aMembersadd[1]
	While 1
		$iRangeModifier = $iCount1 * 1000
		$sRange = "Range=" & $iRangeModifier & "-" & $iRangeModifier + 999
		$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sGroup & ">;;member;" & $sRange & ";base"
		$oRecordSet = $__oAD_Command.Execute
		$aMembersadd = $oRecordSet.fields(0).Value
		If $aMembersadd = Null Then ExitLoop
		ReDim $aMembers[UBound($aMembers) + 1000]
		For $iCount2 = $iRangeModifier + 1 To $iRangeModifier + 1000
			$aMembers[$iCount2] = $aMembersadd[$iCount2 - $iRangeModifier - 1]
		Next
		$iCount1 += 1
		$oRecordSet.Close
		$oRecordSet = 0
	WEnd
	$iRangeModifier = $iCount1 * 1000
	$sRange = "Range=" & $iRangeModifier & "-*"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sGroup & ">;;member;" & $sRange & ";base"
	$oRecordSet = $__oAD_Command.Execute
	$aMembersadd = $oRecordSet.fields(0).Value
	ReDim $aMembers[UBound($aMembers) + UBound($aMembersadd)]
	For $iCount2 = $iRangeModifier + 1 To $iRangeModifier + UBound($aMembersadd)
		$aMembers[$iCount2] = $aMembersadd[$iCount2 - $iRangeModifier - 1]
	Next
	$oRecordSet.Close
	$aMembers[0] = UBound($aMembers) - 1
	Return $aMembers

EndFunc   ;==>_AD_GetGroupMembers

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_RecursiveGetGroupMembers
; Description ...: Takes a group and recursively returns a list of groups and members of the group.
; Syntax.........: _AD_RecursiveGetGroupMembers($sGroup[, $iDepth = 10[, $bListInherited = True[, $bFQDN = True]]])
; Parameters ....: $sGroup         - Group for which the members should to be returned. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
;                  $iDepth         - Optional: Maximum depth of recursion (default = 10)
;                  $bListInherited - Optional: Defines if the function returns the group it is a member of (default = True)
;                  $bFQDN          - Optional: Specifies the attribute to be returned. True = distinguishedName (FQDN), False = SamAccountName (default = True)
; Return values .: Success - Returns an one-based one dimensional array of group or member names (FQDN or sAMAccountName)
;                  Failure - "", sets @error to:
;                  |1 - Specified group does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This function traverses the groups in the specified group until the maximum depth is reached.
;                  if $bListInherited = True the return is the FQDN or sAMAccountname of the group or member and the FQDN(s) or sAMAccountname(s) of the group it
;                  is a member of, seperated by '|'(s) if flag $bListInherited is set to True.
;+
;                  If flag $bListInherited is set to False then the group/member names are sorted and only unique entries are returned.
; Related .......: _AD_GetGroupMembers
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_RecursiveGetGroupMembers($sGroup, $iDepth = 10, $bListInherited = True, $bFQDN = True)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, "")
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup)
	Local $iCount1, $iCount2
	Local $sField = "distinguishedName"
	If Not $bFQDN Then $sField = "samaccountname"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(memberof=" & $sGroup & ");" & $sField & ";subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	Local $aMembers[$oRecordSet.RecordCount + 1] = [0]
	If $oRecordSet.RecordCount = 0 Then Return $aMembers
	$oRecordSet.MoveFirst
	$iCount1 = 1
	Local $aTempMembers[1]
	Do
		$aMembers[$iCount1] = $oRecordSet.Fields(0).Value
		If $iDepth > 0 Then
			$aTempMembers = _AD_RecursiveGetGroupMembers($aMembers[$iCount1], $iDepth - 1, $bListInherited, $bFQDN)
			If $bListInherited Then
				For $iCount2 = 1 To $aTempMembers[0]
					$aTempMembers[$iCount2] &= "|" & $aMembers[$iCount1]
				Next
			EndIf
			_ArrayDelete($aTempMembers, 0)
			_ArrayConcatenate($aMembers, $aTempMembers)
		EndIf
		$iCount1 += 1
		$oRecordSet.MoveNext
	Until $oRecordSet.EOF
	$oRecordSet.Close
	If $bListInherited = False Then
		_ArraySort($aMembers, 0, 1)
		$aMembers = _ArrayUnique($aMembers, 0, 1)
	EndIf
	$aMembers[0] = UBound($aMembers) - 1
	Return $aMembers

EndFunc   ;==>_AD_RecursiveGetGroupMembers

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetGroupMemberOf
; Description ...: Returns an array of group membership.
; Syntax.........: _AD_GetGroupMemberOf($sGroup)
; Parameters ....: $sGroup - Group for which membership in other groups is to be retrieved. Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - Returns an one-based one dimensional array of group names (FQDN) that the specified group is a member of
;                  Failure - "", sets @error to:
;                  |1 - Specified group does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_GetGroupMembers, _AD_RecursiveGetGroupMembers
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetGroupMemberOf($sGroup)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, "")
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	Local $iRangeModifier, $sRange, $oRecordSet, $aMembersadd
	Local $aMemberOf[1]
	Local $iCount1 = 0
	While 1
		$iRangeModifier = $iCount1 * 1000
		$sRange = "Range=" & $iRangeModifier & "-" & $iRangeModifier + 999
		$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sGroup & ">;;memberof;" & $sRange & ";base"
		$oRecordSet = $__oAD_Command.Execute
		$aMembersadd = $oRecordSet.fields(0).Value
		If $aMembersadd = Null Then ExitLoop
		ReDim $aMemberOf[UBound($aMemberOf) + 1000]
		For $iCount2 = $iRangeModifier + 1 To $iRangeModifier + 1000
			$aMemberOf[$iCount2] = $aMembersadd[$iCount2 - $iRangeModifier - 1]
		Next
		$iCount1 += 1
		$oRecordSet.Close
	WEnd
	$iRangeModifier = $iCount1 * 1000
	$sRange = "Range=" & $iRangeModifier & "-*"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sGroup & ">;;memberof;" & $sRange & ";base"
	$oRecordSet = $__oAD_Command.Execute
	$aMembersadd = $oRecordSet.fields(0).Value
	ReDim $aMemberOf[UBound($aMemberOf) + UBound($aMembersadd)]
	For $iCount2 = $iRangeModifier + 1 To $iRangeModifier + UBound($aMembersadd)
		$aMemberOf[$iCount2] = $aMembersadd[$iCount2 - $iRangeModifier - 1]
	Next
	$oRecordSet.Close
	$aMemberOf[0] = UBound($aMemberOf) - 1
	Return $aMemberOf

EndFunc   ;==>_AD_GetGroupMemberOf

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetObjectsInOU
; Description ...: Returns a filtered array of objects and attributes for a given OU or just the number of records if $bCount is True.
; Syntax.........: _AD_GetObjectsInOU($sOU[, $sFilter = "(name=*)"[, $iSearchScope = 2[, $sDataToRetrieve =  "sAMAccountName"[, $sSortBy = "sAMAccountName"[, $bCount = False]]]]])
; Parameters ....: $sOU - The OU to retrieve from (FQDN) (default = "", equals "search the whole AD tree")
;                  $sFilter - Optional: An additional LDAP filter if required (default = "(name=*)")
;                  $iSearchScope - Optional: 0 = base, 1 = one-level, 2 = sub-tree (default)
;                  $sDataToRetrieve - Optional: A comma-seperated list of attributes to retrieve (default = "sAMAccountName").
;                  |More than one attribute will create a 2-dimensional array
;                  $sSortBy - Optional: name of the attribute the resulting array will be sorted upon (default = "sAMAccountName").
;                  |To completely suppress sorting (even the default sort) set this parameter to "". This improves performance when doing large queries
;                  $bCount - Optional: If set to True only returns the number of records returned by the query (default = "False")
; Return values .: Success - Number of records retrieved or a one or two dimensional array of objects and attributes in the given OU. First entry is for the given OU itself
;                  Failure - "", sets @error to:
;                  |1 - Specified OU does not exist
;                  |2 - No records returned from Active Directory. $sDataToRetrieve is invalid (attribute may not exist). @extended is set to the error returned by LDAP
;                  |3 - No records returned from Active Directory. $sFilter didn't return a record
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Multi-value attributes are returned as string with the pipe character (|) as separator.
;+
;                  The default filter returns an array including one record for the OU itself. To exclude the OU use a different filter that doesn't include the OU
;                  e.g. "(&(objectcategory=person)(objectclass=user)(name=*))"
;+
;                  To make sure that all properties you specify in $sDataToRetrieve exist in the AD you can use _AD_ObjectExistsInSchema.
;+
;                  The following examples illustrate the use of the escaping mechanism in the LDAP filter:
;                    (o=Parens R Us \28for all your parenthetical needs\29)
;                    (cn=*\2A*)
;                    (filename=C:\5cMyFile)
;                    (bin=\00\00\00\04)
;                    (sn=Lu\c4\8di\c4\87)
;                  The first example shows the use of the escaping mechanism to represent parenthesis characters.
;                  The second shows how to represent a "*" in a value, preventing it from being interpreted as a substring indicator.
;                  The third illustrates the escaping of the backslash character.
;                  The fourth example shows a filter searching for the four-byte value 0x00000004, illustrating the use of the escaping mechanism to
;                  represent arbitrary data, including NUL characters.
;                  The final example illustrates the use of the escaping mechanism to represent various non-ASCII UTF-8 characters.
; Related .......: _AD_GetAllOUs
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetObjectsInOU($sOU = "", $sFilter = "(name=*)", $iSearchScope = 2, $sDataToRetrieve = "sAMAccountName", $sSortBy = "sAMAccountName", $bCount = False)

	If $sOU = "" Then
		$sOU = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sOU, "distinguishedName") = 0 Then Return SetError(1, 0, "")
	EndIf
	Local $iCount2, $aDataToRetrieve, $aTemp
	If $sDataToRetrieve = "" Then $sDataToRetrieve = "sAMAccountName"
	$sDataToRetrieve = StringStripWS($sDataToRetrieve, 8)
	$__oAD_Command.Properties("Searchscope") = $iSearchScope
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sOU & ">;" & $sFilter & ";" & $sDataToRetrieve
	$__oAD_Command.Properties("Sort On") = $sSortBy
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Then Return SetError(2, @error, "")
	Local $iCount1 = $oRecordSet.RecordCount
	If $iCount1 = 0 Then
		If $bCount Then Return SetError(3, 0, 0)
		Return SetError(3, 0, "")
	EndIf
	If $bCount Then Return $iCount1
	If StringInStr($sDataToRetrieve, ",") Then
		$aDataToRetrieve = StringSplit($sDataToRetrieve, ",")
		Local $aObjects[$iCount1 + 1][$aDataToRetrieve[0]]
		$aObjects[0][0] = $iCount1
		$aObjects[0][1] = $aDataToRetrieve[0]
		$iCount2 = 1
		$oRecordSet.MoveFirst
		Do
			For $iCount1 = 1 To $aDataToRetrieve[0]
				If IsArray($oRecordSet.Fields($aDataToRetrieve[$iCount1]).Value) Then
					$aTemp = $oRecordSet.Fields($aDataToRetrieve[$iCount1]).Value
					$aObjects[$iCount2][$iCount1 - 1] = _ArrayToString($aTemp)
				Else
					$aObjects[$iCount2][$iCount1 - 1] = $oRecordSet.Fields($aDataToRetrieve[$iCount1]).Value
				EndIf
			Next
			$oRecordSet.MoveNext
			$iCount2 += 1
		Until $oRecordSet.EOF
	Else
		Local $aObjects[$iCount1 + 1]
		$aObjects[0] = UBound($aObjects) - 1
		$iCount2 = 1
		$oRecordSet.MoveFirst
		Do
			If IsArray($oRecordSet.Fields($sDataToRetrieve).Value) Then
				$aTemp = $oRecordSet.Fields($sDataToRetrieve).Value
				$aObjects[$iCount2] = _ArrayToString($aTemp)
			Else
				$aObjects[$iCount2] = $oRecordSet.Fields($sDataToRetrieve).Value
			EndIf
			$oRecordSet.MoveNext
			$iCount2 += 1
		Until $oRecordSet.EOF
	EndIf
	$__oAD_Command.Properties("Sort On") = "" ; Reset sort property
	Return $aObjects

EndFunc   ;==>_AD_GetObjectsInOU

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetAllOUs
; Description ...: Retrieves an array of OUs. The paths are separated by the '\' character.
; Syntax.........: _AD_GetAllOUs([$sRoot = ""[, $sSeparator = "\"[, $iSelect = 0]]])
; Parameters ....: $sRoot      - Optional: OU (FQDN) where to start in the AD tree (default = "", equals "start at the AD root")
;                  $sSeparator - Optional: Single character to separate the OU names (default = "\")
;                  $iSelect    - Optional: Which objects should be returned in the result (default = 0)
;                  |0 - Return OUs (Organizational Units) (default)
;                  |1 - Return CNs (Containers)
;                  |2 - Return OUs + CNs
; Return values .: Success - One-based two dimensional array of OUs starting with the given OU. The paths are separated by "\"
;                  |0 - ... \name of grandfather OU\name of father OU\name of son OU
;                  |1 - Distinguished Name (FQDN) of the son OU
;                  Failure - "", sets @error to:
;                  |1 - No OUs found
;                  |2 - Specified $sRoot does not exist
;                  |3 - $iSelect is not an integer or < 0 or > 2
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: If an OU contains spaces the sorting is wrong and might lead to problems in further processing.
;                  Please have a look at http://www.autoitscript.com/forum/topic/106163-active-directory-udf/page__view__findpost__p__943892
; Related .......: _AD_GetObjectsInOU
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetAllOUs($sRoot = "", $sSeparator = "\", $iSelect = 0)

	If $sRoot = "" Then
		$sRoot = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sRoot, "distinguishedName") = 0 Then Return SetError(2, 0, "")
	EndIf
	If Not IsInt($iSelect) Or $iSelect < 0 Or $iSelect > 2 Then Return SetError(3, 0, "")
	If $sSeparator <= " " Or StringLen($sSeparator) > 1 Then $sSeparator = "\"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sRoot & ">;"
	Switch $iSelect
		Case 0
			$__oAD_Command.CommandText = $__oAD_Command.CommandText & "(objectCategory=organizationalUnit);distinguishedName;subtree"
		Case 1
			$__oAD_Command.CommandText = $__oAD_Command.CommandText & "(objectCategory=container);distinguishedName;subtree"
		Case 2
			$__oAD_Command.CommandText = $__oAD_Command.CommandText & "(|(objectCategory=organizationalUnit)(objectCategory=container));distinguishedName;subtree"
	EndSwitch
	Local $oRecordSet = $__oAD_Command.Execute
	Local $iCount1 = $oRecordSet.RecordCount
	If $iCount1 = 0 Then Return SetError(1, 0, "")
	Local $aOUs[$iCount1 + 1][2]
	Local $iCount2 = 1, $aTempOU
	$oRecordSet.MoveFirst
	Do
		$aOUs[$iCount2][1] = $oRecordSet.Fields("distinguishedName").Value
		$aOUs[$iCount2][0] = "," & StringTrimRight($aOUs[$iCount2][1], StringLen($sAD_DNSDomain) + 1)
		$aTempOU = StringSplit($aOUs[$iCount2][0], "," & StringLeft($aOUs[$iCount2][1], 3), 1) ; Split at ",OU=" or ",CN="
		_ArrayReverse($aTempOU)
		$aOUs[$iCount2][0] = StringTrimRight(_ArrayToString($aTempOU, $sSeparator), 3)
		$iCount2 += 1
		$oRecordSet.MoveNext
	Until $oRecordSet.EOF
	_ArraySort($aOUs)
	$aOUs[0][0] = UBound($aOUs, 1) - 1
	$aOUs[0][1] = 2
	Return $aOUs

EndFunc   ;==>_AD_GetAllOUs

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListDomainControllers
; Description ...: Enumerates all Domain Controllers (returns information about: Domain Controller, site, subnet and Global Catalog).
; Syntax.........: _AD_ListDomainControllers([$bListRO = False[, $bListGC = False]])
; Parameters ....: $bListRO - Optional: If set to True only returns RODC (read only domain controllers) (default = False)
;                  $bListGC - Optional: If set to True queries the DC for a Global Catalog. Disabled for performance reasons (default = False)
; Return values .: Success - One-based two dimensional array with the following information:
;                  |0 - Domain Controller: Name
;                  |1 - Domain Controller: Distinguished Name (FQDN)
;                  |2 - Domain Controller: DNS host name
;                  |3 - Site: Name
;                  |4 - Site: Distinguished Name (FQDN)
;                  |5 - Site: List of subnets that can connect to the site using this DC in the format x.x.x.x/mask - multiple subnets are separated by comma
;                  |6 - Global Catalog: Set to True if the DC is a Global Catalog (only if flag $bListGC = True. If False then "" is returned)
;                  Failure - "", sets @error to:
;                  |1 - No Domain Controllers found. @extended is set to the error returned by LDAP
; Author ........: water (based on VB functions by Richard L. Mueller)
; Modified.......:
; Remarks .......: This function only lists writeable DCs (default). To list RODC (read only DCs) use parameter $bListRO
; Related .......:
; Link ..........: http://www.rlmueller.net/Enumerate%20DCs.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListDomainControllers($bListRO = False, $bListGC = False)

	Local $oDC, $oSite, $oResult
	Local Const $NTDSDSA_OPT_IS_GC = 1
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_Configuration & ">;(objectClass=nTDSDSA);ADsPath;subtree"
	If $bListRO Then $__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_Configuration & ">;(objectClass=nTDSDSARO);ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	; The parent object of each object with objectClass=nTDSDSA is a Domain
	; Controller. The parent of each Domain Controller is a "Servers"
	; container, and the parent of this container is the "Site" container.
	$oRecordSet.MoveFirst
	Local $aResult[1][7], $iCount1 = 1, $aSubNet, $aTemp, $sTemp
	Do
		ReDim $aResult[$iCount1 + 1][7]
		$oResult = __AD_ObjGet($oRecordSet.Fields("AdsPath").Value)
		$oDC = __AD_ObjGet($oResult.Parent)
		$aResult[$iCount1][0] = $oDC.Get("Name")
		$aResult[$iCount1][1] = $oDC.serverReference
		$aResult[$iCount1][2] = $oDC.DNSHostName
		$oResult = __AD_ObjGet($oDC.Parent)
		$oSite = __AD_ObjGet($oResult.Parent)
		$aResult[$iCount1][3] = StringMid($oSite.Name, 4)
		$aResult[$iCount1][4] = $oSite.distinguishedName
		$aSubNet = $oSite.GetEx("siteObjectBL")
		For $iCount2 = 0 To UBound($aSubNet) - 1
			$aTemp = StringSplit($aSubNet[$iCount2], ",")
			$sTemp = StringMid($aTemp[1], 4)
			If $iCount2 = 0 Then
				$aResult[$iCount1][5] = $sTemp
			Else
				$aResult[$iCount1][5] = $aResult[$iCount1][5] & "," & $sTemp
			EndIf
		Next
		If $bListGC Then
			; Is the DC a GC? Taken from: http://www.activexperts.com/activmonitor/windowsmanagement/adminscripts/computermanagement/ad/
			Local $oDCRootDSE = __AD_ObjGet("LDAP://" & $oDC.DNSHostName & "/rootDSE")
			Local $sDsServiceDN = $oDCRootDSE.Get("dsServiceName")
			Local $oDsRoot = __AD_ObjGet("LDAP://" & $oDC.DNSHostName & "/" & $sDsServiceDN)
			Local $iDCOptions = $oDsRoot.Get("options")
			If BitAND($iDCOptions, $NTDSDSA_OPT_IS_GC) = 1 Then
				$aResult[$iCount1][6] = True
			Else
				$aResult[$iCount1][6] = False
			EndIf
		EndIf
		$oRecordSet.MoveNext
		$iCount1 += 1
	Until $oRecordSet.EOF
	$oRecordSet.Close
	$aResult[0][0] = UBound($aResult, 1) - 1
	$aResult[0][1] = UBound($aResult, 2)
	Return $aResult

EndFunc   ;==>_AD_ListDomainControllers

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListRootDSEAttributes
; Description ...: Returns a one-based array of the RootDSE Atributes.
; Syntax.........: _AD_ListRootDSEAttributes()
; Parameters ....:
; Return values .: Success - Returns an one-based one dimensional array of the following RootDSE attributes. Multi-valued attributes are as multiple lines.
;                  |1 - configurationNamingContext: Specifies the distinguished name for the configuration container.
;                  |2 - currentTime: Specifies the current time set on this directory server in Coordinated Universal Time format.
;                  |3 - defaultNamingContext: Specifies the distinguished name of the domain that this directory server is a member.
;                  |4 - dnsHostName: Specifies the DNS address for this directory server.
;                  |5 - domainControllerFunctionality: Specifies the functional level of this domain controller. Values can be:
;                       0 - Windows 2000 Mode
;                       2 - Windows Server 2003 Mode
;                       3 - Windows Server 2008 Mode
;                       4 - Windows Server 2008 R2 Mode
;                       5 - Windows Server 2012 Mode
;                       6 - Windows Server 2012 R2 Mode
;                  |6 - domainFunctionality: Specifies the functional level of the domain. Values can be:
;                       0 - Windows 2000 Domain Mode
;                       1 - Windows Server 2003 Interim Domain Mode
;                       2 - Windows Server 2003 Domain Mode
;                       3 - Windows Server 2008 Domain Mode
;                       4 - Windows Server 2008 R2 Domain Mode
;                       5 - Windows Server 2012 Domain Mode
;                       6 - Windows Server 2012 R2 Domain Mode
;                  |7 - dsServiceName: Specifies the distinguished name of the NTDS settings object for this directory server.
;                  |8 - forestFunctionality: Specifies the functional level of the forest. Values can be:
;                       0 - Windows 2000 Forest Mode
;                       1 - Windows Server 2003 Interim Forest Mode
;                       2 - Windows Server 2003 Forest Mode
;                       3 - Windows Server 2008 Forest Mode
;                       4 - Windows Server 2008 R2 Forest Mode
;                       5 - Windows Server 2012 Forest Mode
;                       6 - Windows Server 2012 R2 Forest Mode
;                  |9 - highestCommittedUSN: Specifies the highest update sequence number (USN) on this directory server. Used by directory replication.
;                  |10 - isGlobalCatalogReady: Specifies Global Catalog operational status. Values can be either "True" or "False".
;                  |11 - isSynchronized: Specifies directory server synchronisation status. Values can be either "True" or "False".
;                  |12 - LDAPServiceName: Specifies the Service Principal Name (SPN) for the LDAP server. Used for mutual authentication.
;                  |13 - namingContexts: A multi-valued attribute that specifies the distinguished names for all naming contexts stored on this directory server.
;                  +By default, a Windows 2000 domain controller has at least three naming contexts: Schema, Configuration, and the domain which the server is a member of.
;                  |14 - rootDomainNamingContext: Specifies the distinguished name for the first domain in the forest that this directory server is a member of.
;                  |15 - schemaNamingContext: Specifies the distinguished name for the schema container.
;                  |16 - serverName: Specifies the distinguished name of the server object for this directory server in the configuration container.
;                  |17 - subschemaSubentry: Specifies the distinguished name for the subSchema object. The subSchema object specifies properties that expose the supported attributes
;                  +(in the attributeTypes property) and classes (in the objectClasses property).
;                  |18 - supportedCapabilities: multi-valued attribute that specifies the capabilities supported by this directory server.
;                  |19 - supportedControl: A multi-valued attribute that specifies the extension control OIDs supported by this directory server.
;                  |20 - supportedLDAPPolicies: A multi-valued attribute that specifies the names of the supported LDAP management policies.
;                  |21 - supportedLDAPVersion: A multi-valued attribute that specifies the LDAP versions (specified by major version number) supported by this directory server.
;                  |22 - supportedSASLMechanisms: Specifies the security mechanisms supported for SASL negotiation (see LDAP RFCs). By default, GSSAPI is supported.
; Author ........: water
; Modified.......:
; Remarks .......: In LDAP 3.0, rootDSE is defined as the root of the directory data tree on a directory server.
;                  The rootDSE is not part of any namespace. The purpose of the rootDSE is to provide data about the directory server.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/cc223254(v=PROT.13).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListRootDSEAttributes()

	Return _AD_GetObjectProperties($__oAD_RootDSE)

EndFunc   ;==>_AD_ListRootDSEAttributes

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListRoleOwners
; Description ...: Returns a one-based array of FSMO (Flexible Single Master Operation) Role Owners.
; Syntax.........: _AD_ListRoleOwners()
; Parameters ....:
; Return values .: Success - Returns an one-based one dimensional array of FSMO Role Owners. The array contains:
;                  |1 - Domain PDC FSMO
;                  |2 - Domain Rid FSMO
;                  |3 - Domain Infrastructure FSMO
;                  |4 - Forest-wide Schema FSMO
;                  |5 - Forest-wide Domain naming FSMO
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.tools4net.de/doc/ad2.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListRoleOwners()

	Local $aRoles[6]

	; PDC FSMO
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(&(objectClass=domainDNS)(fSMORoleOwner=*));adsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	Local $oFSM = ObjGet($oRecordSet.fields(0).Value)
	Local $oCompNTDS = ObjGet("LDAP://" & $sAD_HostServer & "/" & $oFSM.FSMORoleOwner)
	Local $oComp = ObjGet($oCompNTDS.Parent)
	$aRoles[1] = $oComp.dnsHostname

	; Rid FSMO
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(&(objectClass=rIDManager) (fSMORoleOwner=*));adsPath;subtree"
	$oRecordSet = $__oAD_Command.Execute
	$oFSM = ObjGet($oRecordSet.fields(0).Value)
	$oCompNTDS = ObjGet("LDAP://" & $sAD_HostServer & "/" & $oFSM.FSMORoleOwner)
	$oComp = ObjGet($oCompNTDS.Parent)
	$aRoles[2] = $oComp.dnsHostname

	; Infrastructure FSMO
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(&(objectClass=infrastructureUpdate) (fSMORoleOwner=*));adsPath;subtree"
	$oRecordSet = $__oAD_Command.Execute
	$oFSM = ObjGet($oRecordSet.fields(0).Value)
	$oCompNTDS = ObjGet("LDAP://" & $sAD_HostServer & "/" & $oFSM.FSMORoleOwner)
	$oComp = ObjGet($oCompNTDS.Parent)
	$aRoles[3] = $oComp.dnsHostname

	; Schema FSMO
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $__oAD_RootDSE.Get("schemaNamingContext") & ">;(&(objectClass=dMD) (fSMORoleOwner=*));adsPath;subtree"
	$oRecordSet = $__oAD_Command.Execute
	$oFSM = ObjGet($oRecordSet.fields(0).Value)
	$oCompNTDS = ObjGet("LDAP://" & $sAD_HostServer & "/" & $oFSM.FSMORoleOwner)
	$oComp = ObjGet($oCompNTDS.Parent)
	$aRoles[4] = $oComp.dnsHostname

	; Domain Naming FSMO
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $__oAD_RootDSE.Get("configurationNamingContext") & ">;(&(objectClass=crossRefContainer)(fSMORoleOwner=*));adsPath;subtree"
	$oRecordSet = $__oAD_Command.Execute
	$oFSM = ObjGet($oRecordSet.fields(0).Value)
	$oCompNTDS = ObjGet("LDAP://" & $sAD_HostServer & "/" & $oFSM.FSMORoleOwner)
	$oComp = ObjGet($oCompNTDS.Parent)
	$aRoles[5] = $oComp.dnsHostname

	$aRoles[0] = 5
	Return $aRoles

EndFunc   ;==>_AD_ListRoleOwners

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetLastLoginDate
; Description ...: Returns the lastlogin information for user and computer accounts from all DCs using the SamAccountName.
; Syntax.........: _AD_GetLastLoginDate([$sObject = @Username[, $sSite = ""[, $aDCList = ""]]])
; Parameters ....: $sObject - Optional: SamAccountName of a user or computer account to get the last login date (default = @Username).
;                  $sSite   - Optional: Only query DCs that belong to this site(s) (default = all sites).
;                  +This can be a single site or a list of sites separated by commas
;                  $aDCList - Optional: one-based two dimensional array of Domain Controllers as returned by function _AD_ListDomainControllers (default = "")
; Return values .: Success - Last login date returned as YYYYMMDDHHMMSS. @extended is set to the total number of Domain Controllers.
;                  +@error could be > 0 and contains the number of DCs that could not be reached or returns no data
;                  Failure - 0, sets @error to:
;                  |1 - $sObject could not be found. @extended = 0
;                  |2 - $sObject has never logged in to the domain. @extended = 0
;                  |3 - $aDCList has to be an array or blank
;                  |4 - $aDCList has to be a 2-dimensional array
;                  Warning - Last login date returned as YYYYMMDDHHMMSS (see Success), sets @error and @extended to:
;                  |x - Number of DCs which could not be reached. Result is returned from all available DCs. @extended is set to the total number of Domain Controllers
; Author ........: Jonathan Clelland
; Modified.......: water, Stephane
; Remarks .......: If it takes (too) long to get a result either some DCs are down or you have too many DCs in your AD.
;                  +Case one: Please check @error and @extended as described above
;                  +Case two: Specify parameter $sSite to reduce the number of DCs to query and/or retrieve the list of DCs yourself and pass the array as parameter 3
; Related .......:
; Link ..........: http://blogs.technet.com/b/askds/archive/2009/04/15/the-lastlogontimestamp-attribute-what-it-was-designed-for-and-how-it-works.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetLastLoginDate($sObject = @UserName, $sSite = "", $aDCList = "")

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, 0)
	If Not IsArray($aDCList) And $aDCList <> "" Then Return SetError(3, 0, 0)
	If IsArray($aDCList) And UBound($aDCList, 0) <> 2 Then Return SetError(4, 0, 0)
	If $aDCList = "" Then $aDCList = _AD_ListDomainControllers()
	Local $aSite, $sSingleDC, $bWasIn
	; Delete all DCs not belonging to the specified site
	$aSite = StringSplit($sSite, ",", 2)
	If UBound($aSite) > 0 And $aSite[0] <> "" Then
		For $iCount1 = $aDCList[0][0] To 1 Step -1
			$bWasIn = False
			For $sSingleDC In $aSite
				If $aDCList[$iCount1][3] = $sSingleDC Then $bWasIn = True
			Next
			If Not $bWasIn Then _ArrayDelete($aDCList, $iCount1)
		Next
		$aDCList[0][0] = UBound($aDCList, 1) - 1
	EndIf
	; Get LastLogin from all DCs
	Local $aResult[$aDCList[0][0] + 1]
	Local $sLDAPEntry, $oObject, $oRecordSet
	Local $iError1 = 0, $iError2 = 0
	For $iCount1 = 1 To $aDCList[0][0]
		If Ping($aDCList[$iCount1][2]) = 0 Then
			$iError1 += 1
			ContinueLoop
		EndIf
		$__oAD_Command.CommandText = "<LDAP://" & $aDCList[$iCount1][2] & "/" & $sAD_DNSDomain & ">;(sAMAccountName=" & $sObject & ");ADsPath;subtree"
		$oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
		; -2147352567 or 0x80020009 is returned when the service is not operational
		If @error = -2147352567 Or $oRecordSet.RecordCount = 0 Then
			$iError1 += 1
		Else
			$sLDAPEntry = $oRecordSet.fields(0).Value
			$oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
			$aResult[$iCount1] = $oObject.LastLogin
			; -2147352567 or 0x80020009 is returned when the attribute "LastLogin" isn't defined on this DC
			If @error = -2147352567 Then $iError2 += 1
			$oObject.PurgePropertyList
		EndIf
	Next
	_ArraySort($aResult, 1, 1)
	; If error count equals the number of DCs then the user has never logged in
	If $iError2 = $aDCList[0][0] Then Return SetError(2, 0, 0)
	Return SetError($iError1, $aDCList[0][0], $aResult[1])

EndFunc   ;==>_AD_GetLastLoginDate

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_IsObjectDisabled
; Description ...: Returns 1 if the object (user account, computer account) is disabled.
; Syntax.........: _AD_IsObjectDisabled([$sObject = @Username])
; Parameters ....: $sObject - Optional: Object to check (default = @Username). Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - 1, Specified object is disabled
;                  Failure - 0, sets @error to:
;                  |0 - $sObject is not disabled
;                  |1 - $sObject could not be found
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: A $ sign must be appended to the computer name to create a correct sAMAccountName e.g. @ComputerName & "$"
; Related .......: _AD_DisableObject, _AD_EnableObject, _AD_GetObjectsDisabled
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_IsObjectDisabled($sObject = @UserName)

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, 0)
	Local $iUAC = _AD_GetObjectAttribute($sObject, "userAccountControl")
	If BitAND($iUAC, $ADS_UF_ACCOUNTDISABLE) = $ADS_UF_ACCOUNTDISABLE Then Return 1
	Return 0

EndFunc   ;==>_AD_IsObjectDisabled

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_IsObjectLocked
; Description ...: Returns 1 if the object (user account, computer account) is locked.
; Syntax.........: _AD_IsObjectLocked([$sObject = @Username])
; Parameters ....: $sObject - Optional: Object to check (default = @Username). Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - 1, Specified object is locked, sets @error to:
;                  |x - number of minutes till the account is unlocked. -1 means the account has to be unlocked manually by an admin
;                  Failure - 0, sets @error to:
;                  |0 - $sObject is not locked
;                  |1 - $sObject could not be found
; Author ........: water
; Modified.......:
; Remarks .......: A $ sign must be appended to the computer name to create a correct sAMAccountName e.g. @ComputerName & "$"
;                  LockoutTime contains the timestamp when the object was locked. This value is not reset until the user/computer logs on again.
;                  LockoutTime could be > 0 even when the lockout already has expired.
; Related .......: _AD_GetObjectsLocked, _AD_UnlockObject
; Link ..........: http://www.pcreview.co.uk/forums/thread-1350048.php, http://www.rlmueller.net/IsUserLocked.htm, http://technet.microsoft.com/en-us/library/cc780271%28WS.10%29.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_IsObjectLocked($sObject = @UserName)

	;-------------------------------------------------------------
	; HINT: To enhance performance this can also be written as:
	; 	$oUser = ObjGet("WinNT://<Domain>/<User>")
	;	ConsoleWrite("Locked: " & $oUser.IsAccountLocked & @CRLF)
	;-------------------------------------------------------------
	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	Local $sProperty = "sAMAccountName"
	If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	Local $oLockoutTime = $oObject.LockoutTime
	; Object is not locked out
	If Not IsObj($oLockoutTime) Then Return
	; Calculate lockout time (UTC)
	Local $sLockoutTime = _DateAdd("s", Int(__AD_LargeInt2Double($oLockoutTime.LowPart, $oLockoutTime.HighPart) / (10000000)), "1601/01/01 00:00:00")
	; Object is not locked out
	If $sLockoutTime = "1601/01/01 00:00:00" Then Return
	; Get password info - Account Lockout Duration
	Local $aTemp = _AD_GetPasswordInfo($sObject)
	; if lockout duration is 0 (= unlock manually by admin needed) then no calculation is necessary. Set @error to -1 (minutes till the account is unlocked)
	If $aTemp[5] = 0 Then Return SetError(-1, 0, 1)
	; Calculate when the lockout will be reset
	Local $sResetLockoutTime = _DateAdd("n", $aTemp[5], $sLockoutTime)
	; Compare to current date/time (UTC)
	Local $sNow = _Date_Time_GetSystemTime()
	$sNow = _Date_Time_SystemTimeToDateTimeStr($sNow, 1)
	If $sResetLockoutTime >= $sNow Then Return SetError(_DateDiff("n", $sNow, $sResetLockoutTime), 0, 1)
	Return

EndFunc   ;==>_AD_IsObjectLocked

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_IsPasswordExpired
; Description ...: Returns 1 if the password of the user or computer account has expired.
; Syntax.........: _AD_IsPasswordExpired([$sAccount = @Username])
; Parameters ....: $sAccount - Optional: User or computer account to check (default = @Username). Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - 1, The password of the specified account has expired
;                  Failure - 0, sets @error to:
;                  |0 - Password for $sAccount has not expired
;                  |1 - $sAccount could not be found
;                  |x - Error as returned by function _AD_GetPasswordInfo
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_IsPasswordExpired($sAccount = @UserName)

	If Not _AD_ObjectExists($sAccount) Then Return SetError(1, 0, 0)
	Local $aTemp = _AD_GetPasswordInfo($sAccount)
	If @error Then SetError(@error, 0, 0)
	If $aTemp[11] <= _NowCalc() Then Return 1
	Return

EndFunc   ;==>_AD_IsPasswordExpired

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetObjectsDisabled
; Description ...: Returns an array with FQDNs of disabled objects (user accounts, computer accounts).
; Syntax.........: _AD_GetObjectsDisabled([$sClass = "user"[, $sRoot = ""]])
; Parameters ....: $sClass - Optional: Specifies if disabled user accounts or computer accounts should be returned (default = "user").
;                  |"user"     - Returns objects of category "user"
;                  |"computer" - Returns objects of category "computer"
;                  $sRoot  - Optional: FQDN of the OU where the search should start (default = "" = search the whole tree)
; Return values .: Success - array of user or computer account FQDNs
;                  Failure - "", sets @error to:
;                  |1 - $sClass is invalid. Values can be "computer" or "user"
;                  |2 - Specified $sRoot does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsObjectDisabled, _AD_DisableObject, _AD_EnableObject
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetObjectsDisabled($sClass = "user", $sRoot = "")

	If $sClass <> "user" And $sClass <> "computer" Then Return SetError(1, 0, "")
	If $sRoot = "" Then
		$sRoot = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sRoot, "distinguishedName") = 0 Then Return SetError(2, 0, "")
	EndIf
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sRoot & ">;(&(objectcategory=" & $sClass & ")(userAccountControl:1.2.840.113556.1.4.803:=" & _
			$ADS_UF_ACCOUNTDISABLE & "));distinguishedName,objectcategory;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	Local $aFQDN[$oRecordSet.RecordCount + 1]
	$aFQDN[0] = $oRecordSet.RecordCount
	Local $iCount1 = 1
	While Not $oRecordSet.EOF
		$aFQDN[$iCount1] = $oRecordSet.Fields(0).Value
		$iCount1 += 1
		$oRecordSet.MoveNext
	WEnd
	Return $aFQDN

EndFunc   ;==>_AD_GetObjectsDisabled

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetObjectsLocked
; Description ...: Returns an array of FQDNs of locked (user and/or, computer accounts), lockout time and minutes remaining in locked state.
; Syntax.........: _AD_GetObjectsLocked([$sClass = "user"[, $sRoot = ""]])
; Parameters ....: $sClass - Optional: Specifies if locked user accounts or computer accounts should be returned (default = "user").
;                  |"user" - Returns objects of category "user"
;                  |"computer" - Returns objects of category "computer"
;                  $sRoot  - Optional: FQDN of the OU where the search should start (default = "" = search the whole tree)
; Return values .: Success - Returns a one-based two dimensional array with the following information:
;                  |0 - FQDN of the locked object
;                  |1 - lockout time YYYY/MM/DD HH:MM:SS in local time of the calling user
;                  |2 - Minutes until the object will be unlocked
;                  Failure - "", sets @error to:
;                  |1 - $sClass is invalid. Should be "computer" or "user"
;                  |2 - No locked objects found
;                  |3 - Specified $sRoot does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: LockoutTime contains the timestamp when the object was locked. This value is not reset until the user/computer logs on again.
;                  LockoutTime could be > 0 even when the lockout has already expired.
; Related .......: _AD_IsObjectLocked, _AD_UnlockObject
; Link ..........: http://technet.microsoft.com/en-us/library/cc780271%28WS.10%29.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetObjectsLocked($sClass = "user", $sRoot = "")

	If $sClass <> "user" And $sClass <> "computer" Then Return SetError(1, 0, "")
	If $sRoot = "" Then
		$sRoot = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sRoot, "distinguishedName") = 0 Then Return SetError(3, 0, "")
	EndIf
	; Get all objects with lockouttime>=1
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sRoot & ">;(&(objectcategory=" & $sClass & ")(lockouttime>=1));distinguishedName;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(2, @error, "")
	Local $aFQDN[$oRecordSet.RecordCount + 1][3] = [[$oRecordSet.RecordCount, 3]]
	Local $iCount1 = 1
	Local $aResult
	While Not $oRecordSet.EOF
		$aFQDN[$iCount1][0] = $oRecordSet.Fields(0).Value
		$iCount1 += 1
		$oRecordSet.MoveNext
	WEnd
	; check if lockouttime has expired. If yes, delete from table
	For $iCount1 = $aFQDN[0][0] To 1 Step -1
		If Not _AD_IsObjectLocked($aFQDN[$iCount1][0]) Then
			_ArrayDelete($aFQDN, $iCount1)
		Else
			$aFQDN[$iCount1][2] = @error
			$aResult = _AD_GetObjectProperties($aFQDN[$iCount1][0], "lockouttime")
			$aFQDN[$iCount1][1] = $aResult[1][1]
		EndIf
	Next
	$aFQDN[0][0] = UBound($aFQDN) - 1
	If $aFQDN[0][0] = 0 Then Return SetError(2, 0, "")
	Return $aFQDN

EndFunc   ;==>_AD_GetObjectsLocked

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetPasswordExpired
; Description ...: Returns an array of FQDNs of user or computer accounts with expired passwords.
; Syntax.........: _AD_GetPasswordExpired([$sRoot = ""[, $bNeverChanged = False]])
; Parameters ....: $sRoot         - Optional: FQDN of the OU where the search should start (default = "" = search the whole tree)
;                  $bNeverChanged - Optional: If set to True returns all accounts who have never changed their password as well (default = False)
;                  $iPasswordAge  - Optional: Takes the max. password age from the AD or uses this value if > 0
;                  $bComputer     - Optional: If True queries computer accounts, if False queries user accounts (default = False)
; Return values .: Success - One-based two dimensional array of FQDNs of accounts with expired passwords
;                  |0 - FQDNs of accounts with expired password
;                  |1 - password last set YYYY/MM/DD HH:NMM:SS UTC
;                  |2 - password last set YYYY/MM/DD HH:NMM:SS local time of calling user
;                  Failure - "", sets @error to:
;                  |1 - No expired passwords found. @extended is set to the error returned by LDAP
;                  |2 - Specified $sRoot does not exist
;                  |3 - $iPasswordAge is not numeric
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetPasswordExpired($sRoot = "", $bNeverChanged = False, $iPasswordAge = 0, $bComputer = False)

	If $sRoot = "" Then
		$sRoot = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sRoot, "distinguishedName") = 0 Then Return SetError(2, 0, "")
	EndIf
	If $iPasswordAge <> 0 And Not IsNumber($iPasswordAge) Then Return SetError(3, 0, "")
	Local $aTemp = _AD_GetPasswordInfo()
	Local $sDTExpire = _Date_Time_GetSystemTime() ; Get current date/time
	$sDTExpire = _Date_Time_SystemTimeToDateTimeStr($sDTExpire, 1) ; convert to system time
	If $iPasswordAge <> 0 Then
		$sDTExpire = _DateAdd("D", $iPasswordAge * -1, $sDTExpire) ; substract maximum password age
	Else
		$sDTExpire = _DateAdd("D", $aTemp[1] * -1, $sDTExpire) ; substract maximum password age
	EndIf
	Local $iDTExpire = _DateDiff("s", "1601/01/01 00:00:00", $sDTExpire) * 10000000 ; convert to Integer8
	Local $sDTStruct = DllStructCreate("dword low;dword high")
	Local $sTemp, $iTemp, $iLowerDate = 110133216000000001 ; 110133216000000001 = 01/01/1959 00:00:00 UTC
	If $bNeverChanged = True Then $iLowerDate = 0
	Local $sCategory = "(objectCategory=Person)(objectClass=User)"
	If $bComputer = True Then $sCategory = "(objectCategory=computer)"
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sRoot & ">;(&" & $sCategory & _
			"(pwdLastSet<=" & Int($iDTExpire) & ")(pwdLastSet>=" & $iLowerDate & "));distinguishedName,pwdlastset,useraccountcontrol;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	Local $aFQDN[$oRecordSet.RecordCount + 1][3]
	$aFQDN[0][0] = $oRecordSet.RecordCount
	Local $iCount = 1
	While Not $oRecordSet.EOF
		$aFQDN[$iCount][0] = $oRecordSet.Fields(0).Value
		$iTemp = $oRecordSet.Fields(1).Value
		If BitAND($oRecordSet.Fields(2).Value, $ADS_UF_DONT_EXPIRE_PASSWD) <> $ADS_UF_DONT_EXPIRE_PASSWD Then
			DllStructSetData($sDTStruct, "Low", $iTemp.LowPart)
			DllStructSetData($sDTStruct, "High", $iTemp.HighPart)
			$sTemp = _Date_Time_FileTimeToSystemTime(DllStructGetPtr($sDTStruct))
			$aFQDN[$iCount][1] = _Date_Time_SystemTimeToDateTimeStr($sTemp, 1)
			$sTemp = _Date_Time_SystemTimeToTzSpecificLocalTime(DllStructGetPtr($sTemp))
			$aFQDN[$iCount][2] = _Date_Time_SystemTimeToDateTimeStr($sTemp, 1)
		EndIf
		$iCount += 1
		$oRecordSet.MoveNext
	WEnd
	; Delete records with UAC set to password not expire
	$aFQDN[0][0] = UBound($aFQDN) - 1
	For $iCount = $aFQDN[0][0] To 1 Step -1
		If $aFQDN[$iCount][1] = "" Then _ArrayDelete($aFQDN, $iCount)
	Next
	$aFQDN[0][0] = UBound($aFQDN) - 1
	Return $aFQDN

EndFunc   ;==>_AD_GetPasswordExpired

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetPasswordDontExpire
; Description ...: Returns an array of user account FQDNs where the password does not expire.
; Syntax.........: _AD_GetPasswordDontExpire([$sRoot = ""])
; Parameters ....: $sRoot - Optional: FQDN of the OU where the search should start (default = "" = search the whole tree)
; Return values .: Success - Array with FQDNs of user accounts for which the password does not expire
;                  Failure - "", sets @error to:
;                  |1 - No user accounts for which the password does not expire. @extended is set to the error returned by LDAP
;                  |2 - Specified $sRoot does not exist
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_SetPassword, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetPasswordDontExpire($sRoot = "")

	If $sRoot = "" Then
		$sRoot = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sRoot, "distinguishedName") = 0 Then Return SetError(2, 0, "")
	EndIf
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sRoot & ">;(&(objectcategory=user)(userAccountControl:1.2.840.113556.1.4.803:=" & _
			$ADS_UF_DONT_EXPIRE_PASSWD & "));distinguishedName;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	Local $aFQDN[$oRecordSet.RecordCount + 1]
	$aFQDN[0] = $oRecordSet.RecordCount
	Local $iCount1 = 1
	While Not $oRecordSet.EOF
		$aFQDN[$iCount1] = $oRecordSet.Fields(0).Value
		$iCount1 += 1
		$oRecordSet.MoveNext
	WEnd
	Return $aFQDN

EndFunc   ;==>_AD_GetPasswordDontExpire

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetObjectProperties
; Description ...: Returns a two-dimensional array of all or selected properties and their values of an object in readable form.
; Syntax.........: _AD_GetObjectProperties([$sObject = @UserName[, $sProperties = ""]])
; Parameters ....: $sObject - Optional: SamAccountName or FQDN of the object properties from (e.g. computer, user, group ...) (default = @Username)
;                  |Can be of type object as well. Useful to get properties for a schema or configuration object (see _AD_ListRootDSEAttributes)
;                  $sProperties - Optional: Comma separated list of properties to return (default = "" = return all properties)
; Return values .: Success - Returns a two-dimensional array with all properties and their values of an object in readable form
;                  Failure - "" or property name, sets @error to:
;                  |1 - $sObject could not be found
;                  |2 - No values for the specified property. The property in error is returned as the function result
; Author ........: Sundance
; Modified.......: water
; Remarks .......: Dates are returned in format: YYYY/MM/DD HH:MM:SS local time of the calling user (AD stores all dates in UTC - Universal Time Coordinated)
;                  Exception: AD internal dates like "whenCreated", "whenChanged" and "dSCorePropagationData". They are returned as UTC
;                  NT Security Descriptors are returned as: Control:nn, Group:Domain\Group, Owner:Domain\Group, Revision:nn
;                  No error is returned if there are properties in $sProperties that are not available for the selected object
;+
;                  Properties are returned in alphabetical order. If $sProperties is set to "samaccountname,displayname" the returned array will contain
;                  displayname as the first and samaccountname as the second row.
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/index.php?showtopic=49627&view=findpost&p=422402, http://msdn.microsoft.com/en-us/library/ms675090(VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetObjectProperties($sObject = @UserName, $sProperties = "")

	Local $aObjectProperties[1][2], $oObject
	Local $oItem, $oPropertyEntry, $oValue, $iCount3, $xAD_Dummy
	; Data Type Mapping between Active Directory and LDAP
	; http://msdn.microsoft.com/en-us/library/aa772375(VS.85).aspx
	Local Const $ADSTYPE_DN_STRING = 1
	Local Const $ADSTYPE_CASE_IGNORE_STRING = 3
	Local Const $ADSTYPE_BOOLEAN = 6
	Local Const $ADSTYPE_INTEGER = 7
	Local Const $ADSTYPE_OCTET_STRING = 8
	Local Const $ADSTYPE_UTC_TIME = 9
	Local Const $ADSTYPE_LARGE_INTEGER = 10
	Local Const $ADSTYPE_NT_SECURITY_DESCRIPTOR = 25
	Local Const $ADSTYPE_UNKNOWN = 26
	Local $aSAMAccountType[12][2] = [["DOMAIN_OBJECT", 0x0],["GROUP_OBJECT", 0x10000000],["NON_SECURITY_GROUP_OBJECT", 0x10000001], _
			["ALIAS_OBJECT", 0x20000000],["NON_SECURITY_ALIAS_OBJECT", 0x20000001],["USER_OBJECT", 0x30000000],["NORMAL_USER_ACCOUNT", 0x30000000], _
			["MACHINE_ACCOUNT", 0x30000001],["TRUST_ACCOUNT", 0x30000002],["APP_BASIC_GROUP", 0x40000000],["APP_QUERY_GROUP", 0x40000001], _
			["ACCOUNT_TYPE_MAX", 0x7fffffff]]
	Local $aUAC[21][2] = [[0x00000001, "SCRIPT"],[0x00000002, "ACCOUNTDISABLE"],[0x00000008, "HOMEDIR_REQUIRED"],[0x00000010, "LOCKOUT"],[0x00000020, "PASSWD_NOTREQD"], _
			[0x00000040, "PASSWD_CANT_CHANGE"],[0x00000080, "ENCRYPTED_TEXT_PASSWORD_ALLOWED"],[0x00000100, "TEMP_DUPLICATE_ACCOUNT"],[0x00000200, "NORMAL_ACCOUNT"], _
			[0x00000800, "INTERDOMAIN_TRUST_ACCOUNT"],[0x00001000, "WORKSTATION_TRUST_ACCOUNT"],[0x00002000, "SERVER_TRUST_ACCOUNT"],[0x00010000, "DONT_EXPIRE_PASSWD"], _
			[0x00020000, "MNS_LOGON_ACCOUNT"],[0x00040000, "SMARTCARD_REQUIRED"],[0x00080000, "TRUSTED_FOR_DELEGATION"],[0x00100000, "NOT_DELEGATED"], _
			[0x00200000, "USE_DES_KEY_ONLY"],[0x00400000, "DONT_REQUIRE_PREAUTH"],[0x00800000, "PASSWORD_EXPIRED"],[0x01000000, "TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION"]]

	$sProperties = "," & StringReplace($sProperties, " ", "") & ","
	If Not IsObj($sObject) Then
		If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, "")
		Local $sProperty = "sAMAccountName"
		If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
		$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
		Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
		Local $sLDAPEntry = $oRecordSet.fields(0).Value
		$oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object
	Else
		$oObject = $sObject
	EndIf
	$oObject.GetInfo()
	Local $iCount1 = $oObject.PropertyCount()
	For $iCount2 = 0 To $iCount1 - 1
		$oItem = $oObject.Item($iCount2)
		If Not ($sProperties = ",," Or StringInStr($sProperties, "," & $oItem.Name & ",") > 0) Then ContinueLoop
		$oPropertyEntry = $oObject.GetPropertyItem($oItem.Name, $ADSTYPE_UNKNOWN)
		If Not IsObj($oPropertyEntry) Then
			Return SetError(2, 0, $oItem.Name)
		Else
			For $vPropertyValue In $oPropertyEntry.Values
				ReDim $aObjectProperties[UBound($aObjectProperties, 1) + 1][2]
				$iCount3 = UBound($aObjectProperties, 1) - 1
				$aObjectProperties[$iCount3][0] = $oItem.Name
				If $oItem.ADsType = $ADSTYPE_CASE_IGNORE_STRING Then
					$aObjectProperties[$iCount3][1] = $vPropertyValue.CaseIgnoreString
				ElseIf $oItem.ADsType = $ADSTYPE_INTEGER Then
					If $oItem.Name = "sAMAccountType" Then
						For $iCount4 = 0 To 11
							If $vPropertyValue.Integer = $aSAMAccountType[$iCount4][1] Then
								$aObjectProperties[$iCount3][1] = $aSAMAccountType[$iCount4][0]
								ExitLoop
							EndIf
						Next
					ElseIf $oItem.Name = "userAccountControl" Then
						$aObjectProperties[$iCount3][1] = $vPropertyValue.Integer & " = "
						For $iCount4 = 0 To 20
							If BitAND($vPropertyValue.Integer, $aUAC[$iCount4][0]) = $aUAC[$iCount4][0] Then
								$aObjectProperties[$iCount3][1] &= $aUAC[$iCount4][1] & " - "
							EndIf
						Next
						If StringRight($aObjectProperties[$iCount3][1], 3) = " - " Then $aObjectProperties[$iCount3][1] = StringTrimRight($aObjectProperties[$iCount3][1], 3)
					Else
						$aObjectProperties[$iCount3][1] = $vPropertyValue.Integer
					EndIf
				ElseIf $oItem.ADsType = $ADSTYPE_LARGE_INTEGER Then
					If $oItem.Name = "pwdLastSet" Or $oItem.Name = "accountExpires" Or $oItem.Name = "lastLogonTimestamp" Or $oItem.Name = "badPasswordTime" Or $oItem.Name = "lastLogon" Or $oItem.Name = "lockoutTime" Then
						If $vPropertyValue.LargeInteger.LowPart = 0 And $vPropertyValue.LargeInteger.HighPart = 0 Then
							$aObjectProperties[$iCount3][1] = "1601/01/01 00:00:00"
						Else
							Local $sTemp = DllStructCreate("dword low;dword high")
							DllStructSetData($sTemp, "Low", $vPropertyValue.LargeInteger.LowPart)
							DllStructSetData($sTemp, "High", $vPropertyValue.LargeInteger.HighPart)
							Local $sTemp2 = _Date_Time_FileTimeToSystemTime(DllStructGetPtr($sTemp))
							Local $sTemp3 = _Date_Time_SystemTimeToTzSpecificLocalTime(DllStructGetPtr($sTemp2))
							$aObjectProperties[$iCount3][1] = _Date_Time_SystemTimeToDateTimeStr($sTemp3, 1)
						EndIf
					Else
						$aObjectProperties[$iCount3][1] = __AD_LargeInt2Double($vPropertyValue.LargeInteger.LowPart, $vPropertyValue.LargeInteger.HighPart)
					EndIf
				ElseIf $oItem.ADsType = $ADSTYPE_OCTET_STRING Then
					$xAD_Dummy = DllStructCreate("byte[56]")
					DllStructSetData($xAD_Dummy, 1, $vPropertyValue.OctetString)
					; objectSID etc. See: http://msdn.microsoft.com/en-us/library/aa379597(VS.85).aspx
					; objectGUID etc. See: http://www.autoitscript.com/forum/index.php?showtopic=106163&view=findpost&p=767558
					If _Security__IsValidSid(DllStructGetPtr($xAD_Dummy)) Then
						$aObjectProperties[$iCount3][1] = _Security__SidToStringSid(DllStructGetPtr($xAD_Dummy)) ; SID
					Else
						$aObjectProperties[$iCount3][1] = _WinAPI_StringFromGUID(DllStructGetPtr($xAD_Dummy)) ; GUID
					EndIf
				ElseIf $oItem.ADsType = $ADSTYPE_DN_STRING Then
					$aObjectProperties[$iCount3][1] = $vPropertyValue.DNString
				ElseIf $oItem.ADsType = $ADSTYPE_UTC_TIME Then
					Local $iDateTime = $vPropertyValue.UTCTime
					$aObjectProperties[$iCount3][1] = StringLeft($iDateTime, 4) & "/" & StringMid($iDateTime, 5, 2) & "/" & StringMid($iDateTime, 7, 2) & _
							" " & StringMid($iDateTime, 9, 2) & ":" & StringMid($iDateTime, 11, 2) & ":" & StringMid($iDateTime, 13, 2)
				ElseIf $oItem.ADsType = $ADSTYPE_BOOLEAN Then
					If $vPropertyValue.Boolean = 0 Then
						$aObjectProperties[$iCount3][1] = "False"
					Else
						$aObjectProperties[$iCount3][1] = "True"
					EndIf
				ElseIf $oItem.ADsType = $ADSTYPE_NT_SECURITY_DESCRIPTOR Then
					$oValue = $vPropertyValue.SecurityDescriptor
					$aObjectProperties[$iCount3][1] = "Control:" & $oValue.Control & ", " & _
							"Group:" & $oValue.Group & ", " & _
							"Owner:" & $oValue.Owner & ", " & _
							"Revision:" & $oValue.Revision
				Else
					$aObjectProperties[$iCount3][1] = "Has the unknown ADsType: " & $oItem.ADsType
				EndIf
			Next
		EndIf
	Next
	$aObjectProperties[0][0] = UBound($aObjectProperties, 1) - 1
	$aObjectProperties[0][1] = UBound($aObjectProperties, 2)
	_ArraySort($aObjectProperties, 0, 1)
	Return $aObjectProperties

EndFunc   ;==>_AD_GetObjectProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_CreateOU
; Description ...: Creates a child OU in the specified parent OU.
; Syntax.........: _AD_CreateOU($sParentOU, $sOU)
; Parameters ....: $sParentOU - Parent OU where the new OU will be created (FQDN)
;                  $sOU - OU to create in the the parent OU (Name without leading "OU=")
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sParentOU does not exist
;                  |2 - $sOU in $sParentOU already exists
;                  |3 - $sOU is missing
;                  |x - Error returned by Create or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This does not create any attributes for the OU. Use function _AD_ModifyAttribute.
; Related .......: _AD_CreateUser, _AD_CreateGroup, _AD_AddUserToGroup, _AD_RemoveUserFromGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_CreateOU($sParentOU, $sOU)

	If Not _AD_ObjectExists($sParentOU, "distinguishedName") Then Return SetError(1, 0, 0)
	If _AD_ObjectExists("OU=" & $sOU & "," & $sParentOU, "distinguishedName") Then Return SetError(2, 0, 0)
	If $sOU = "" Then Return SetError(3, 0, 0)
	Local $oParentOU = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sParentOU)
	Local $oOU = $oParentOU.Create("organizationalUnit", "OU=" & $sOU)
	If @error Then Return SetError(@error, 0, 0)
	$oOU.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_CreateOU

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_CreateUser
; Description ...: Creates and activates a user in the specified OU.
; Syntax.........: _AD_CreateUser($sOU, $sUser, $sCN)
; Parameters ....: $sOU - OU to create the user in. Form is "OU=sampleou,OU=sampleparent,DC=sampledomain1,DC=sampledomain2"
;                  $sUser - Username, form is SamAccountName without leading 'CN='
;                  $sCN - Common Name (without CN=) or RDN (Relative Distinguished Name) like "Lastname Firstname"
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sUser already exists
;                  |2 - $sOU does not exist
;                  |3 - $sCN is missing
;                  |4 - $sUser is missing
;                  |5 - $sUser could not be created. @extended is set to the error returned by LDAP
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This function only sets sAMAccountName (= $sUser) and userPrincipalName (e.g. $sUser@microsoft.com).
;                  All other attributes have to be set using function _AD_ModifyAttribute
; Related .......: _AD_CreateOU, _AD_CreateGroup, _AD_AddUserToGroup, _AD_RemoveUserFromGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_CreateUser($sOU, $sUser, $sCN)

	If _AD_ObjectExists($sUser) Then Return SetError(1, 0, 0)
	If Not _AD_ObjectExists($sOU, "distinguishedName") Then Return SetError(2, 0, 0)
	If $sCN = "" Then Return SetError(3, 0, 0)
	$sCN = _AD_FixSpecialChars($sCN)
	If $sUser = "" Then Return SetError(4, 0, 0)
	Local $oOU = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sOU)
	Local $oUser = $oOU.Create("User", "CN=" & $sCN)
	If @error Or Not IsObj($oUser) Then Return SetError(5, @error, 0)
	$oUser.sAMAccountName = $sUser
	$oUser.userPrincipalName = $sUser & "@" & StringTrimLeft(StringReplace($sAD_DNSDomain, ",DC=", "."), 3)
	$oUser.pwdLastSet = -1 ; Set password to not expired
	$oUser.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	$oUser.AccountDisabled = False ; Activate User
	$oUser.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_CreateUser

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_SetPassword
; Description ...: Sets or clears the password for a user or computer.
; Syntax.........: _AD_SetPassword($sObject[, $sAD_Password=""[, $iExpired = 0]])
; Parameters ....: $sObject - User or computer for which to set the password (FQDN or sAMAccountName)
;                  $sAD_Password - Optional: Password to be set for $sObject. If $sAD_Password is "" then the password will be cleared (default)
;                  $iExpired - Optional: 1 = the password has to be changed at next logon (Default = 0)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetPassword or SetInfo method (Missing permission etc.)
; Author ........: KenE
; Modified.......: water
; Remarks .......: Changing the password for a computer does a "reset" so the computer can be rejoined to the domain with the same SID.
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo, _AD_ChangePassword
; Link ..........: http://answers.yahoo.com/question/index?qid=20070105110051AAib6G7
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SetPassword($sObject, $sAD_Password = "", $iExpired = 0)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMACccountName provided
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	$oUser.SetPassword($sAD_Password)
	If @error Then Return SetError(@error, 0, 0)
	If $iExpired Then $oUser.Put("pwdLastSet", 0)
	$oUser.SetInfo()
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_SetPassword

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ChangePassword
; Description ...: Changes the password for the currently logged on user.
; Syntax.........: _AD_ChangePassword($sOldPW, $sNewPW)
; Parameters ....: $sOldPW - Old password of the user
;                  $sNewPW - New password to be set for the user
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - Error accessing the current user object
;                  |2 - Error returned by ChangePassword method (Missing permission etc.)
; Author ........: water
; Modified.......:
; Remarks .......: This allows a logged on user without elevated permissions to change his password.
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo, _AD_SetPassword
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ChangePassword($sOldPW, $sNewPW)

	Local $oUsr = ObjGet("WinNT://" & @LogonDomain & "/" & @UserName & ",user")
	If @error Then Return SetError(1, @error, 0)
	$oUsr.ChangePassword($sOldPW, $sNewPW)
	If @error Then Return SetError(2, @error, 0)
	Return 1

EndFunc   ;==>_AD_ChangePassword

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_CreateGroup
; Description ...: Creates a group in the specified OU.
; Syntax.........: _AD_CreateGroup($sOU, $sGroup[, $iType = $ADS_GROUP_TYPE_GLOBAL_SECURITY])
; Parameters ....: $sOU - OU to create the group in. Form is "OU=sampleou,OU=sampleparent,DC=sampledomain1,DC=sampledomain2" (FQDN)
;                  $sGroup - Groupname, form is SamAccountName without leading 'CN='
;                  $iType - Optional: Group type (default = $ADS_GROUP_TYPE_GLOBAL_SECURITY). NOTE: Global security must be 'BitOr'ed with a scope.
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sGroup already exists
;                  |2 - $sOU does not exist
;                  |x - Error returned by Create or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This function only sets sAMAccountName and grouptype. All other attributes have to be set using
;                  function _AD_ModifyAttribute
; Related .......: _AD_CreateOU, _AD_CreateUser, _AD_AddUserToGroup, _AD_RemoveUserFromGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_CreateGroup($sOU, $sGroup, $iType = $ADS_GROUP_TYPE_GLOBAL_SECURITY)

	If _AD_ObjectExists($sGroup) Then Return SetError(1, 0, 0)
	If Not _AD_ObjectExists($sOU, "distinguishedName") Then Return SetError(2, 0, 0)

	Local $sCN = "CN=" & _AD_FixSpecialChars($sGroup)
	Local $oOU = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sOU)
	Local $oGroup = $oOU.Create("Group", $sCN)
	If @error Then Return SetError(@error, 0, 0)
	Local $sSamAccountName = StringReplace($sGroup, ",", "")
	$sSamAccountName = StringReplace($sSamAccountName, "#", "")
	$sSamAccountName = StringReplace($sSamAccountName, "/", "")
	$oGroup.sAMAccountName = $sSamAccountName
	$oGroup.grouptype = $iType
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_CreateGroup

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_AddUserToGroup
; Description ...: Adds a user or computer to the specified group.
; Syntax.........: _AD_AddUserToGroup($sGroup, $sUser)
; Parameters ....: $sGroup - Groupname (FQDN or sAMAccountName)
;                  $sUser - Username or computername to be added to the group (FQDN or sAMAccountName)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sGroup does not exist
;                  |2 - $sUser (user or computer) does not exist
;                  |3 - $sUser (user or computer) is already a member of $sGroup
;                  |x - Error returned by Add or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Works for both computers and groups. The sAMAccountname of a computer requires a trailing "$" before converting it to a FQDN.
; Related .......: _AD_CreateOU, _AD_CreateUser, _AD_CreateGroup, _AD_RemoveUserFromGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_AddUserToGroup($sGroup, $sUser)

	If Not _AD_ObjectExists($sGroup) Then Return SetError(1, 0, 0)
	If Not _AD_ObjectExists($sUser) Then Return SetError(2, 0, 0)
	If _AD_IsMemberOf($sGroup, $sUser) Then Return SetError(3, 0, 0)
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMACccountName provided
	If StringMid($sUser, 3, 1) <> "=" Then $sUser = _AD_SamAccountNameToFQDN($sUser) ; sAMACccountName provided
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sUser) ; Retrieve the COM Object for the user
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup) ; Retrieve the COM Object for the group
	$oGroup.Add($oUser.AdsPath)
	If @error Then Return SetError(@error, 0, 0)
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_AddUserToGroup

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_RemoveUserFromGroup
; Description ...: Removes a user or computer from the specified group.
; Syntax.........: _AD_RemoveUserFromGroup($sGroup, $sUser)
; Parameters ....: $sGroup - Groupname (FQDN or sAMAccountName)
;                  $sUser - Username (FQDN or sAMAccountName)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sGroup does not exist
;                  |2 - $sUser does not exist
;                  |3 - $sUser is not a member of $sGroup
;                  |x - Error returned by Remove or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Works for computer objects as well. Remember that the sAMAccountname of a computer needs a trailing "$" before converting it to a FQDN.
; Related .......: _AD_CreateOU, _AD_CreateUser, _AD_CreateGroup, _AD_AddUserToGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_RemoveUserFromGroup($sGroup, $sUser)

	If Not _AD_ObjectExists($sGroup) Then Return SetError(1, 0, 0)
	If Not _AD_ObjectExists($sUser) Then Return SetError(2, 0, 0)
	If Not _AD_IsMemberOf($sGroup, $sUser) Then Return SetError(3, 0, 0)
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMACccountName provided
	If StringMid($sUser, 3, 1) <> "=" Then $sUser = _AD_SamAccountNameToFQDN($sUser) ; sAMACccountName provided
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sUser) ; Retrieve the COM Object for the user
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup) ; Retrieve the COM Object for the group
	$oGroup.Remove($oUser.AdsPath)
	If @error Then Return SetError(@error, 0, 0)
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_RemoveUserFromGroup

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_CreateComputer
; Description ...: Creates and enables a computer account. A specific, authenticated user/group can then use this account to add his or her workstation to the domain.
; Syntax.........: _AD_CreateComputer($sOU, $sComputer, $sUser)
; Parameters ....: $sOU - OU to create the computer in. Form is "OU=sampleou,OU=sampleparent,DC=sampledomain1,DC=sampledomain2" (FQDN)
;                  $sComputer - Computername, form is SamAccountName without trailing "$"
;                  $sUser - User or group that will be allowed to add the computer to the domain (SamAccountName)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sOU does not exist
;                  |2 - $sComputer already defined in $sOU
;                  |3 - $sUser does not exist
;                  |x - Error returned by Create or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: By default, any authenticated user can create up to 10 computer accounts in the domain (machine account quota).
;                  (see: http://technet.microsoft.com/en-us/library/cc780195(WS.10).aspx)
;                  To create the Access Control List you need certain permissions. If this permissions are missing you might be able to add the
;                  computer to the domain but the function will exit with failure and the ACL is not set.
;+
;                  Creating a computer object in AD does not permit a user to join a computer to the domain.
;                  Certain permissions have to be granted so that the user has rights to modify the computer object.
;                  When you create a computer account using the ADUC snap-in you have the option to select a
;                  user or group to manage the computer object and join a computer to the domain using that object.
;+
;                  When you use that method, the following access control entries (ACEs) are added to the
;                  access control list (ACL) of the computer object:
;                  * List Contents, Read All Properties, Delete, Delete Subtree, Read Permissions, All
;                    Extended Rights (i.e., Allowed to Authenticate, Change Password, Send As, Receive As, Reset Password)
;                  * Write Property for description
;                  * Write Property for sAMAccountName
;                  * Write Property for displayName
;                  * Write Property for Logon Information
;                  * Write Property for Account Restrictions
;                  * Validate write to DNS host name
;                  * Validated write for service principal name
; Related .......: _AD_CreateOU, _AD_JoinDomain
; Link ..........: http://www.wisesoft.co.uk/scripts/vbscript_create_a_computer_account_for_a_specific_user.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_CreateComputer($sOU, $sComputer, $sUser)

	If Not _AD_ObjectExists($sOU) Then Return SetError(1, 0, 0)
	If _AD_ObjectExists("CN=" & $sComputer & "," & $sOU) Then Return SetError(2, 0, 0)
	If Not _AD_ObjectExists($sUser) Then Return SetError(3, 0, 0)
	If StringMid($sOU, 3, 1) <> "=" Then $sOU = _AD_SamAccountNameToFQDN($sOU) ; sAMACccountName provided
	If StringMid($sUser, 3, 1) = "=" Then $sUser = _AD_FQDNToSamAccountName($sUser) ; FQDN provided
	Local $oContainer = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sOU)
	Local $oComputer = $oContainer.Create("Computer", "cn=" & $sComputer)
	If @error Then Return SetError(@error, 0, 0)
	$oComputer.Put("sAMAccountName", $sComputer & "$")
	$oComputer.Put("userAccountControl", BitOR($ADS_UF_PASSWD_NOTREQD, $ADS_UF_WORKSTATION_TRUST_ACCOUNT))
	$oComputer.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Local $oSD = $oComputer.Get("ntSecurityDescriptor")
	Local $oDACL = $oSD.DiscretionaryAcl
	Local $oACE1 = ObjCreate("AccessControlEntry")
	$oACE1.Trustee = $sUser
	$oACE1.AccessMask = $ADS_RIGHT_GENERIC_READ
	$oACE1.AceFlags = 0
	$oACE1.AceType = $ADS_ACETYPE_ACCESS_ALLOWED
	Local $oACE2 = ObjCreate("AccessControlEntry")
	$oACE2.Trustee = $sUser
	$oACE2.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$oACE2.AceFlags = 0
	$oACE2.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE2.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE2.ObjectType = $ALLOWED_TO_AUTHENTICATE
	Local $oACE3 = ObjCreate("AccessControlEntry")
	$oACE3.Trustee = $sUser
	$oACE3.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$oACE3.AceFlags = 0
	$oACE3.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE3.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE3.ObjectType = $RECEIVE_AS
	Local $oACE4 = ObjCreate("AccessControlEntry")
	$oACE4.Trustee = $sUser
	$oACE4.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$oACE4.AceFlags = 0
	$oACE4.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE4.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE4.ObjectType = $SEND_AS
	Local $oACE5 = ObjCreate("AccessControlEntry")
	$oACE5.Trustee = $sUser
	$oACE5.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$oACE5.AceFlags = 0
	$oACE5.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE5.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE5.ObjectType = $USER_CHANGE_PASSWORD
	Local $oACE6 = ObjCreate("AccessControlEntry")
	$oACE6.Trustee = $sUser
	$oACE6.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
	$oACE6.AceFlags = 0
	$oACE6.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE6.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE6.ObjectType = $USER_FORCE_CHANGE_PASSWORD
	Local $oACE7 = ObjCreate("AccessControlEntry")
	$oACE7.Trustee = $sUser
	$oACE7.AccessMask = $ADS_RIGHT_DS_WRITE_PROP
	$oACE7.AceFlags = 0
	$oACE7.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE7.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE7.ObjectType = $USER_ACCOUNT_RESTRICTIONS
	Local $oACE8 = ObjCreate("AccessControlEntry")
	$oACE8.Trustee = $sUser
	$oACE8.AccessMask = $ADS_RIGHT_DS_SELF
	$oACE8.AceFlags = 0
	$oACE8.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE8.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE8.ObjectType = $VALIDATED_DNS_HOST_NAME
	Local $oACE9 = ObjCreate("AccessControlEntry")
	$oACE9.Trustee = $sUser
	$oACE9.AccessMask = $ADS_RIGHT_DS_SELF
	$oACE9.AceFlags = 0
	$oACE9.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE9.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE9.ObjectType = $VALIDATED_SPN
	$oDACL.AddAce($oACE1)
	$oDACL.AddAce($oACE2)
	$oDACL.AddAce($oACE3)
	$oDACL.AddAce($oACE4)
	$oDACL.AddAce($oACE5)
	$oDACL.AddAce($oACE6)
	$oDACL.AddAce($oACE7)
	$oDACL.AddAce($oACE8)
	$oDACL.AddAce($oACE9)
	$oSD.DiscretionaryAcl = $oDACL
	$oComputer.Put("ntSecurityDescriptor", $oSD)
	$oComputer.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_CreateComputer

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ModifyAttribute
; Description ...: Modifies an attribute of the given object to the value specified.
; Syntax.........: _AD_ModifyAttribute($sObject, $sAttribute[, $sValue = ""[, $iOption = 1]])
; Parameters ....: $sObject - Object (user, group ...) to add/delete/modify an attribute (sAMAccountName or FQDN)
;                  $sAttribute - Attribute to add/delete/modify
;                  $sValue - Optional: Value to modify the attribute to. Use a blank string ("") to delete the attribute (default).
;                  +$sValue can be a single value (as a string) or a multi-value (as a one-dimensional array)
;                  $iOption - Optional: Indicates the mode of modification: Append, Replace, Remove, and Delete
;                  |1 - CLEAR: remove all the property value(s) from the object (default when $svalue = "")
;                  |2 - UPDATE: replace the current value(s) with the specified value(s)
;                  |3 - APPEND: append the specified value(s) to the existing values(s)
;                  |4 - DELETE: delete the specified value(s) from the object
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_GetObjectAttribute, _AD_GetObjectProperties
; Link ..........: http://msdn.microsoft.com/en-us/library/aa746353(VS.85).aspx (ADS_PROPERTY_OPERATION_ENUM Enumeration)
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ModifyAttribute($sObject, $sAttribute, $sValue = "", $iOption = 1)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	Local $sProperty = "sAMAccountName"
	If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	$oObject.GetInfo
	If $sValue = "" Then
		$oObject.PutEx(1, $sAttribute, 0) ; CLEAR: remove all the property value(s) from the object
	ElseIf $iOption = 3 Then
		$oObject.PutEx(3, $sAttribute, $sValue) ; APPEND: append the specified value(s) to the existing values(s)
	ElseIf IsArray($sValue) Then
		$oObject.PutEx(2, $sAttribute, $sValue) ; UPDATE: replace the current value(s) with the specified value(s)
	Else
		$oObject.Put($sAttribute, $sValue) ; sets the value(s) of an attribute
	EndIf
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_ModifyAttribute

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_RenameObject
; Description ...: Renames an object within an OU.
; Syntax.........: _AD_RenameObject($sObject, $sCN)
; Parameters ....: $sObject - Object (user, group, computer) to rename (FQDN or sAMAccountName)
;                  $sCN - New Name (relative name) of the object in the current OU without CN=
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by MoveHere function (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Renames an object within the same OU. You can not move objects to another OU with this function.
; Related .......: _AD_MoveObject, _AD_DeleteObject
; Link ..........: http://msdn.microsoft.com/en-us/library/aa705991(v=VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_RenameObject($sObject, $sCN)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $oOU = __AD_ObjGet($oObject.Parent) ; Get the object of the OU/CN where the object resides
	$sCN = "CN=" & _AD_FixSpecialChars($sCN) ; escape all special characters
	$oOU.MoveHere("LDAP://" & $sAD_HostServer & "/" & $sObject, $sCN)
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_RenameObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_MoveObject
; Description ...: Moves an object to another OU.
; Syntax.........: _AD_MoveObject($sOU, $sObject[, $sDisplayName = ""])
; Parameters ....: $sOU - Target OU for the object move (FQDN)
;                  $sObject - Object (user, group, computer) to move (FQDN or sAMAccountName)
;                  $sCN - Optional: New Name of the object in the target OU. Common Name or RDN (Relative Distinguished Name) like "Lastname Firstname" without leading "CN="
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sOU does not exist
;                  |2 - $sObject does not exist
;                  |3 - Object already exists in the target OU
;                  |x - Error returned by MoveHere function (Missing permission etc.)
; Author ........: water
; Modified.......:
; Remarks .......: You must escape commas in $sObject with a backslash. E.g. "CN=Lastname\, Firstname,OU=..."
; Related .......: _AD_RenameObject, _AD_DeleteObject
; Link ..........: http://msdn.microsoft.com/en-us/library/aa705991(v=VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_MoveObject($sOU, $sObject, $sCN = "")

	If Not _AD_ObjectExists($sOU, "distinguishedName") Then Return SetError(1, 0, 0)
	If Not _AD_ObjectExists($sObject) Then Return SetError(2, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	If $sCN = "" Then
		$sCN = "CN=" & _AD_FixSpecialChars(_AD_GetObjectAttribute($sObject, "cn"))
	Else
		$sCN = "CN=" & _AD_FixSpecialChars($sCN) ; escape all special characters
	EndIf
	If _AD_ObjectExists($sCN & "," & $sOU, "distinguishedName") Then Return SetError(3, 0, 0)
	Local $oOU = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sOU) ; Pointer to the destination container
	$oOU.MoveHere("LDAP://" & $sAD_HostServer & "/" & $sObject, $sCN)
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_MoveObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_DeleteObject
; Description ...: Deletes the specified object.
; Syntax.........: _AD_DeleteObject($sObject, $sClass)
; Parameters ....: $sObject - Object (user, group, computer etc.) to delete (FQDN or sAMAccountName)
;                  $sClass - The schema class object to delete ("user", "computer", "group", "contact" etc). Can be derived using _AD_GetObjectClass().
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by Delete function (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_RenameObject, _AD_MoveObject
; Link ..........: http://msdn.microsoft.com/en-us/library/aa705988(v=VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_DeleteObject($sObject, $sClass)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	Local $sCN
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $oOU = __AD_ObjGet($oObject.Parent) ; Get the object of the OU/CN where the object resides
	If $sClass = "organizationalUnit" Then
		$sCN = "OU=" & _AD_FixSpecialChars(_AD_GetObjectAttribute($sObject, "ou"))
	Else
		$sCN = "CN=" & _AD_FixSpecialChars(_AD_GetObjectAttribute($sObject, "cn"))
	EndIf
	$oOU.Delete($sClass, $sCN)
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_DeleteObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_SetAccountExpire
; Description ...: Modifies the specified user or computer account expiration date/time or sets the account to never expire.
; Syntax.........: _AD_SetAccountExpire($sObject, $sDateTime)
; Parameters ....: $sObject - User or computer account to set expiration date/time (sAMAccountName or FQDN)
;                  $sDateTime - Expiration date/time in format: yyyy-mm-dd hh:mm:ss (local time) or "01/01/1970" to never expire
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: KenE
; Modified.......: water
; Remarks .......: Use the following syntax for the date/time:
;                  01/01/1970 = never expire
;                  yyyy-mm-dd hh:mm:ss= "international format" - always works
;                  xx/xx/xx <time> = "localized format" - the format depends on the local date/time settings
;+
;                  Richard L. Mueller:
;                  "In Active Directory Users and Computers you can specify the date when a user account expires on the "Account"
;                  tab of the user properties dialog. This date is stored in the accountExpires attribute of the user object.
;                  There is also a property method called AccountExpirationDate, exposed by the IADsUser interface, that can be
;                  used to display and set this date. If you've ever compared accountExpires and AccountExpirationDate with the
;                  date shown in ADUC, you may have wondered what's going on. It is common for the values to differ by a day,
;                  sometimes even two days."
; Related .......:
; Link ..........: http://www.rlmueller.net/AccountExpires.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SetAccountExpire($sObject, $sDateTime)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	$oObject.AccountExpirationDate = $sDateTime
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_SetAccountExpire

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_DisablePasswordExpire
; Description ...: Modifies specified users password to not expire.
; Syntax.........: _AD_DisablePasswordExpire($sObject)
; Parameters ....: $sObject - User account to disable password expiration (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by Put or SetInfo method (Missing permission etc.)
; Author ........: KenE
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo, _AD_EnablePasswordExpire
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_DisablePasswordExpire($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $iUAC = $oObject.Get("userAccountControl")
	$oObject.Put("userAccountControl", BitOR($iUAC, $ADS_UF_DONT_EXPIRE_PASSWD))
	If @error Then Return SetError(@error, 0, 0)
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_DisablePasswordExpire

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_EnablePasswordExpire
; Description ...: Sets users password to expire.
; Syntax.........: _AD_EnablePasswordExpire($sObject)
; Parameters ....: $sObject - User account to enable password expiration (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Joe2010
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_EnablePasswordChange,  _AD_DisablePasswordChange, _AD_GetPasswordInfo, _AD_DisablePasswordExpire
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_EnablePasswordExpire($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $iUAC = $oObject.Get("userAccountControl")
	$oObject.Put("userAccountControl", BitAND($iUAC, BitNOT($ADS_UF_DONT_EXPIRE_PASSWD)))
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_EnablePasswordExpire

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_EnablePasswordChange
; Description ...: Disables the 'User Cannot Change Password' option, allowing the user to change their password.
; Syntax.........: _AD_EnablePasswordChange($sObject)
; Parameters ....: $sObject - User account to enable changing the password (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: KenE
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_DisablePasswordChange, _AD_GetPasswordInfo
; Link ..........: Example VBS see: http://gallery.technet.microsoft.com/ScriptCenter/en-us/ced14c6c-d16a-4cd8-b7d1-90d716c0445f or How to use Visual Basic and ADsSecurity.dll to properly order ACEs in an ACL. See: http://support.microsoft.com/kb/269159/en-us -
; Example .......: Yes
; ===============================================================================================================================
Func _AD_EnablePasswordChange($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $bSelf, $bEveryone, $bModified, $sSelf = "NT AUTHORITY\SELF", $sEveryone = "EVERYONE", $aTemp
	; Get the language dependant well known accounts for SELF and EVERYONE
	$aTemp = _Security__LookupAccountSid("S-1-5-10")
	If IsArray($aTemp) Then $sSelf = $aTemp[1] & "\" & $aTemp[0]
	$aTemp = _Security__LookupAccountSid("S-1-1-0")
	If IsArray($aTemp) Then $sEveryone = $aTemp[0]
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $oSD = $oObject.Get("nTSecurityDescriptor")
	Local $oDACL = $oSD.DiscretionaryAcl
	; Search for ACE's for Change Password and modify
	$bSelf = False
	$bEveryone = False
	$bModified = False
	For $oACE In $oDACL
		If StringUpper($oACE.ObjectType) = StringUpper($USER_CHANGE_PASSWORD) Then
			If StringUpper($oACE.Trustee) = $sSelf Then
				If $oACE.AceType = $ADS_ACETYPE_ACCESS_DENIED_OBJECT Then
					$oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
					$bModified = True
				EndIf
				$bSelf = True
			EndIf
			If StringUpper($oACE.Trustee) = $sEveryone Then
				If $oACE.AceType = $ADS_ACETYPE_ACCESS_DENIED_OBJECT Then
					$oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
					$bModified = True
				EndIf
				$bEveryone = True
			EndIf
		EndIf
	Next
	; If ACE's found and modified, save changes and return
	If $bSelf And $bEveryone Then
		If $bModified Then
			$oSD.DiscretionaryAcl = __AD_ReorderACE($oDACL)
			$oObject.Put("ntSecurityDescriptor", $oSD)
			$oObject.SetInfo
		EndIf
	Else
		; If ACE's not found, add to DACL
		If $bSelf = False Then
			; Create the ACE for Self
			Local $oACESelf = ObjCreate("AccessControlEntry")
			$oACESelf.Trustee = $sSelf
			$oACESelf.AceFlags = 0
			$oACESelf.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
			$oACESelf.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
			$oACESelf.ObjectType = $USER_CHANGE_PASSWORD
			$oACESelf.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
			$oDACL.AddAce($oACESelf)
		EndIf
		If $bEveryone = False Then
			; Create the ACE for Everyone
			Local $oACEEveryone = ObjCreate("AccessControlEntry")
			$oACEEveryone.Trustee = $sEveryone
			$oACEEveryone.AceFlags = 0
			$oACEEveryone.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
			$oACEEveryone.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
			$oACEEveryone.ObjectType = $USER_CHANGE_PASSWORD
			$oACEEveryone.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
			$oDACL.AddAce($oACEEveryone)
		EndIf
		$oSD.DiscretionaryAcl = __AD_ReorderACE($oDACL)
		; Update the user object
		$oObject.Put("ntSecurityDescriptor", $oSD)
		$oObject.SetInfo
	EndIf
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_EnablePasswordChange

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_DisablePasswordChange
; Description ...: Enables the 'User Cannot Change Password' option, preventing the user from changing their password.
; Syntax.........: _AD_DisablePasswordChange($sObject)
; Parameters ....: $sObject - User account to disallow changing his password (SAMAccountNmae or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: KenE
; Modified.......: water
; Remarks .......:
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange, _AD_GetPasswordInfo
; Link ..........: How to set the "User Cannot Change Password" option by using a program. See: http://support.microsoft.com/kb/301287/en-us -
; Example .......: Yes
; ===============================================================================================================================
Func _AD_DisablePasswordChange($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $bSelf, $bEveryone, $bModified, $sSelf = "NT AUTHORITY\SELF", $sEveryone = "EVERYONE", $aTemp
	; Get the language dependant well known accounts for SELF and EVERYONE
	$aTemp = _Security__LookupAccountSid("S-1-5-10")
	If IsArray($aTemp) Then $sSelf = $aTemp[1] & "\" & $aTemp[0]
	$aTemp = _Security__LookupAccountSid("S-1-1-0")
	If IsArray($aTemp) Then $sEveryone = $aTemp[0]
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $oSD = $oObject.Get("nTSecurityDescriptor")
	Local $oDACL = $oSD.DiscretionaryAcl
	; Search for ACE's for Change Password and modify
	$bSelf = False
	$bEveryone = False
	$bModified = False
	For $oACE In $oDACL
		If StringUpper($oACE.ObjectType) = StringUpper($USER_CHANGE_PASSWORD) Then
			If StringUpper($oACE.Trustee) = $sSelf Then
				If $oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT Then
					$oACE.AceType = $ADS_ACETYPE_ACCESS_DENIED_OBJECT
					$bModified = True
				EndIf
				$bSelf = True
			EndIf
			If StringUpper($oACE.Trustee) = $sEveryone Then
				If $oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT Then
					$oACE.AceType = $ADS_ACETYPE_ACCESS_DENIED_OBJECT
					$bModified = True
				EndIf
				$bEveryone = True
			EndIf
		EndIf
	Next
	; If ACE's found and modified, save changes and return
	If $bSelf And $bEveryone Then
		If $bModified Then
			$oSD.DiscretionaryAcl = __AD_ReorderACE($oDACL)
			$oObject.Put("ntSecurityDescriptor", $oSD)
			$oObject.SetInfo
		EndIf
	Else
		; If ACE's not found, add to DACL
		If $bSelf = False Then
			; Create the ACE for Self
			Local $oACESelf = ObjCreate("AccessControlEntry")
			$oACESelf.Trustee = $sSelf
			$oACESelf.AceFlags = 0
			$oACESelf.AceType = $ADS_ACETYPE_ACCESS_DENIED_OBJECT
			$oACESelf.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
			$oACESelf.ObjectType = $USER_CHANGE_PASSWORD
			$oACESelf.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
			$oDACL.AddAce($oACESelf)
		EndIf
		If $bEveryone = False Then
			; Create the ACE for Everyone
			Local $oACEEveryone = ObjCreate("AccessControlEntry")
			$oACEEveryone.Trustee = $sEveryone
			$oACEEveryone.AceFlags = 0
			$oACEEveryone.AceType = $ADS_ACETYPE_ACCESS_DENIED_OBJECT
			$oACEEveryone.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
			$oACEEveryone.ObjectType = $USER_CHANGE_PASSWORD
			$oACEEveryone.AccessMask = $ADS_RIGHT_DS_CONTROL_ACCESS
			$oDACL.AddAce($oACEEveryone)
		EndIf
		$oSD.DiscretionaryAcl = __AD_ReorderACE($oDACL)
		; Update the user object
		$oObject.Put("ntSecurityDescriptor", $oSD)
		$oObject.SetInfo
	EndIf
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_DisablePasswordChange

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_UnlockObject
; Description ...: Unlocks an AD object (user account, computer account).
; Syntax.........: _AD_UnlockObject($sObject)
; Parameters ....: $sObject - User account or computer account to unlock (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_IsObjectLocked, _AD_GetObjectsLocked
; Link ..........: http://www.rlmueller.net/Programs/IsUserLocked.txt
; Example .......: Yes
; ===============================================================================================================================
Func _AD_UnlockObject($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	$oObject.IsAccountLocked = False
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_UnlockObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_DisableObject
; Description ...: Disables an AD object (user account, computer account).
; Syntax.........: _AD_DisableObject($sObject)
; Parameters ....: $sObject - User account or computer account to disable (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_IsObjectDisabled, _AD_EnableObject, _AD_GetObjectsDisabled
; Link ..........: http://www.wisesoft.co.uk/scripts/vbscript_enable-disable_user_account_1.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_DisableObject($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $iUAC = $oObject.Get("userAccountControl")
	$oObject.Put("userAccountControl", BitOR($iUAC, $ADS_UF_ACCOUNTDISABLE))
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_DisableObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_EnableObject
; Description ...: Enables an AD object (user account, computer account).
; Syntax.........: _AD_EnableObject($sObject)
; Parameters ....: $sObject - User account or computer account to enable (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sObject does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_IsObjectDisabled, _AD_DisableObject, _AD_GetObjectsDisabled
; Link ..........: http://www.wisesoft.co.uk/scripts/vbscript_enable-disable_user_account_1.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_EnableObject($sObject)

	If Not _AD_ObjectExists($sObject) Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $iUAC = $oObject.Get("userAccountControl")
	$oObject.Put("userAccountControl", BitAND($iUAC, BitNOT($ADS_UF_ACCOUNTDISABLE)))
	$oObject.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_EnableObject

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetPasswordInfo
; Description ...: Returns password information retrieved from the domain policy and the specified user or computer account.
; Syntax.........: _AD_GetPasswordInfo([$sSamAccountName = @UserName])
; Parameters ....: $sObject - Optional: User or computer account to get password info for (default = @UserName). Format is sAMAccountName or FQDN
; Return values .: Success - Returns a one-based array with the following information:
;                  |1 - Maximum Password Age (days)
;                  |2 - Minimum Password Age (days)
;                  |3 - Enforce Password History (# of passwords remembered)
;                  |4 - Minimum Password Length
;                  |5 - Account Lockout Duration (minutes). 0 means the account has to be unlocked manually by an administrator
;                  |6 - Account Lockout Threshold (invalid logon attempts)
;                  |7 - Reset account lockout counter after (minutes)
;                  |8 - Password last changed (YYYY/MM/DD HH:MM:SS in local time of the calling user) or "1601/01/01 00:00:00" (means "Password has never been set")
;                  |9 - Password expires (YYYY/MM/DD HH:MM:SS in local time of the calling user) or empty when password has not been set before or never expires
;                  |10 - Password last changed (YYYY/MM/DD HH:MM:SS in UTC) or "1601/01/01 00:00:00" (means "Password has never been set")
;                  |11 - Password expires (YYYY/MM/DD HH:MM:SS in UTC) or empty when password has not been set before or never expires
;                  |12 - Password properties. Part of Domain Policy. A bit field to indicate complexity / storage restrictions
;                  |      1 - DOMAIN_PASSWORD_COMPLEX
;                  |      2 - DOMAIN_PASSWORD_NO_ANON_CHANGE
;                  |      4 - DOMAIN_PASSWORD_NO_CLEAR_CHANGE
;                  |      8 - DOMAIN_LOCKOUT_ADMINS
;                  |     16 - DOMAIN_PASSWORD_STORE_CLEARTEXT
;                  |     32 - DOMAIN_REFUSE_PASSWORD_CHANGE
;                  Failure - "", sets @error to:
;                  |1 - $sObject not found
;                  Warning - Returns a one-based array (see Success), sets @error to:
;                  |2 - Password does not expire (User Access Control - UAC - is set)
;                  |3 - Password has never been set
;                  |4 - The Maximum Password Age is set to 0 in the domain. Therefore, the password does not expire
;                  |The @error value can be a combination of the above values e.g. 5 = 2 (Password does not expire) + 3 (Password has never been set)
; Author ........: water
; Modified.......:
; Remarks .......: For details about password properties please check: http://msdn.microsoft.com/en-us/library/aa375371(v=vs.85).aspx
; Related .......: _AD_IsPasswordExpired, _AD_GetPasswordExpired, _AD_GetPasswordDontExpire, _AD_SetPassword, _AD_DisablePasswordExpire, _AD_EnablePasswordExpire, _AD_EnablePasswordChange,  _AD_DisablePasswordChange
; Link ..........: http://www.autoitscript.com/forum/index.php?showtopic=86247&view=findpost&p=619073, http://windowsitpro.com/article/articleid/81412/jsi-tip-8294-how-can-i-return-the-domain-password-policy-attributes.html
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetPasswordInfo($sObject = @UserName)

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, "")
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $iError = 0
	Local $aPwdInfo[13] = [12]
	Local $oObject = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain)
	$aPwdInfo[1] = Int(__AD_Int8ToSec($oObject.Get("maxPwdAge"))) / 86400 ; Convert to Days
	$aPwdInfo[2] = __AD_Int8ToSec($oObject.Get("minPwdAge")) / 86400 ; Convert to Days
	$aPwdInfo[3] = $oObject.Get("pwdHistoryLength")
	$aPwdInfo[4] = $oObject.Get("minPwdLength")
	; Account lockout duration: http://msdn.microsoft.com/en-us/library/ms813429.aspx
	Local $oTemp = $oObject.Get("lockoutDuration")
	If $oTemp.HighPart = 0x7FFFFFFF And $oTemp.LowPart = 0xFFFFFFFF Then
		$aPwdInfo[5] = 0 ; Account has to be unlocked manually by an admin
	Else
		$aPwdInfo[5] = __AD_Int8ToSec($oTemp) / 60 ; Convert to Minutes
	EndIf
	$aPwdInfo[6] = $oObject.Get("lockoutThreshold")
	$aPwdInfo[7] = __AD_Int8ToSec($oObject.Get("lockoutObservationWindow")) / 60 ; Convert to Minutes
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $sPwdLastChanged = $oUser.Get("PwdLastSet")
	Local $iUAC = $oUser.userAccountControl
	; Has user account password been changed before?
	If $sPwdLastChanged.LowPart = 0 And $sPwdLastChanged.HighPart = 0 Then
		$iError += 3
		$aPwdInfo[8] = "1601/01/01 00:00:00"
		$aPwdInfo[10] = "1601/01/01 00:00:00"
	Else
		Local $sTemp = DllStructCreate("dword low;dword high")
		DllStructSetData($sTemp, "Low", $sPwdLastChanged.LowPart)
		DllStructSetData($sTemp, "High", $sPwdLastChanged.HighPart)
		; Have to convert to SystemTime because _Date_Time_FileTimeToStr has a bug (#1638)
		Local $sTemp2 = _Date_Time_FileTimeToSystemTime(DllStructGetPtr($sTemp))
		$aPwdInfo[10] = _Date_Time_SystemTimeToDateTimeStr($sTemp2, 1)
		; Convert PwdlastSet from UTC to Local Time
		$sTemp2 = _Date_Time_SystemTimeToTzSpecificLocalTime(DllStructGetPtr($sTemp2))
		$aPwdInfo[8] = _Date_Time_SystemTimeToDateTimeStr($sTemp2, 1)
		; Is user account password set to expire?
		If BitAND($iUAC, $ADS_UF_DONT_EXPIRE_PASSWD) = $ADS_UF_DONT_EXPIRE_PASSWD Or $aPwdInfo[1] = 0 Then
			If BitAND($iUAC, $ADS_UF_DONT_EXPIRE_PASSWD) = $ADS_UF_DONT_EXPIRE_PASSWD Then $iError += 2
			If $aPwdInfo[1] = 0 Then $iError += 4 ; The Maximum Password Age is set to 0 in the domain. Therefore, the password does not expire
		Else
			$aPwdInfo[11] = _DateAdd("d", $aPwdInfo[1], $aPwdInfo[10])
			$sTemp2 = _Date_Time_EncodeSystemTime(StringMid($aPwdInfo[11], 6, 2), StringMid($aPwdInfo[11], 9, 2), StringMid($aPwdInfo[11], 1, 4), StringMid($aPwdInfo[11], 12, 2), StringMid($aPwdInfo[11], 15, 2), StringMid($aPwdInfo[11], 18, 2))
			; Convert PasswordExpires from UTC to Local Time
			$sTemp2 = _Date_Time_SystemTimeToTzSpecificLocalTime(DllStructGetPtr($sTemp2))
			$aPwdInfo[9] = _Date_Time_SystemTimeToDateTimeStr($sTemp2, 1)
		EndIf
	EndIf
	$aPwdInfo[12] = $oObject.Get("pwdProperties")
	Return SetError($iError, 0, $aPwdInfo)

EndFunc   ;==>_AD_GetPasswordInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListExchangeServers
; Description ...: Enumerates all Exchange Servers in the Forest.
; Syntax.........: _AD_ListExchangeServers()
; Parameters ....:
; Return values .: Success - Returns an one-based one dimensional array with the names of the Exchange Servers
;                  Failure - "", sets @error to:
;                  |1 - No Exchange Servers found. @extended is set to the error returned by LDAP
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_ListExchangeMailboxStores
; Link ..........: http://www.wisesoft.co.uk/scripts/vbscript_list_exchange_servers.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListExchangeServers()

	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_Configuration & ">;(objectCategory=msExchExchangeServer);name;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	$oRecordSet.MoveFirst
	Local $aResult[1]
	Local $iCount1 = 1
	Do
		ReDim $aResult[$iCount1 + 1]
		$aResult[$iCount1] = $oRecordSet.Fields("name").Value
		$oRecordSet.MoveNext
		$iCount1 += 1
	Until $oRecordSet.EOF
	$oRecordSet.Close
	$aResult[0] = UBound($aResult, 1) - 1
	Return $aResult

EndFunc   ;==>_AD_ListExchangeServers

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListExchangeMailboxStores
; Description ...: Enumerates all Exchange Mailbox Stores in the Forest.
; Syntax.........: _AD_ListExchangeMailboxStores()
; Parameters ....:
; Return values .: Success - Returns a one-based two dimensional array with the following information:
;                  |0 - name
;                  |1 - cn
;                  |2 - distinguishedName
;                  Failure - "", sets @error to:
;                  |1 - No Exchange Mailbox Stores found. @extended is set to the error returned by LDAP
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_ListExchangeServers
; Link ..........: http://www.wisesoft.co.uk/scripts/vbscript_list_exchange_mailbox_stores.aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListExchangeMailboxStores()

	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_Configuration & ">;(objectCategory=msExchPrivateMDB);name,cn,distinguishedName;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	$oRecordSet.MoveFirst
	Local $aResult[1][3]
	Local $iCount1 = 1
	Do
		ReDim $aResult[$iCount1 + 1][3]
		$aResult[$iCount1][0] = $oRecordSet.Fields("name").Value
		$aResult[$iCount1][1] = $oRecordSet.Fields("cn").Value
		$aResult[$iCount1][2] = $oRecordSet.Fields("distinguishedName").Value
		$oRecordSet.MoveNext
		$iCount1 += 1
	Until $oRecordSet.EOF
	$oRecordSet.Close
	$aResult[0][0] = UBound($aResult, 1) - 1
	$aResult[0][1] = UBound($aResult, 2)
	Return $aResult

EndFunc   ;==>_AD_ListExchangeMailboxStores

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetSystemInfo
; Description ...: Retrieves data describing the local computer if it is a member of a (at least) Windows 2000 domain.
; Syntax.........: _AD_GetSystemInfo()
; Parameters ....:
; Return values .: Success - Returns an one-based one dimensional array with the following information:
;                  |1 - distinguished name of the local computer
;                  |2 - DNS name of the local computer domain
;                  |3 - short name of the local computer domain
;                  |4 - DNS name of the local computer forest
;                  |5 - Local computer domain status: native mode (True) or mixed mode (False)
;                  |6 - distinguished name of the NTDS-DSA object for the DC that owns the primary domain controller role in the local computer domain
;                  |7 - distinguished name of the NTDS-DSA object for the DC that owns the schema role in the local computer forest
;                  |8 - site name of the local computer
;                  |9 - distinguished name of the current user
;                  Failure - "", sets @error to:
;                  |1 - Creation of object "ADSystemInfo" returned an error. See @extended
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa705962(VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetSystemInfo()

	Local $aResult[10]
	Local $oSystemInfo = ObjCreate("ADSystemInfo")
	If @error Or Not IsObj($oSystemInfo) Then Return SetError(1, @error, "")
	$aResult[1] = $oSystemInfo.ComputerName
	$aResult[2] = $oSystemInfo.DomainDNSName
	$aResult[3] = $oSystemInfo.DomainShortName
	$aResult[4] = $oSystemInfo.ForestDNSName
	$aResult[5] = $oSystemInfo.IsNativeMode
	$aResult[6] = $oSystemInfo.PDCRoleOwner
	$aResult[7] = $oSystemInfo.SchemaRoleOwner
	$aResult[8] = $oSystemInfo.SiteName
	$aResult[9] = $oSystemInfo.UserName
	$aResult[0] = 9
	Return $aResult

EndFunc   ;==>_AD_GetSystemInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetManagedBy
; Description ...: Retrieves all groups that are managed by any or the specified user.
; Syntax.........: _AD_GetManagedBy([$sManagedBy = "*"])
; Parameters ....: $sManagedBy - Optional: Manager to filter the list of groups (default = *). Can be a SAMAccountname or a FQDN
; Return values .: Success - Returns a one-based two dimensional array with the following information:
;                  |0 - distinguished name of the group
;                  |1 - distinguished name of the manager for this group
;                  Failure - "", sets @error to:
;                  |1 - $sManagedBy is unknown
;                  |2 - No groups found. @extended is set to the error returned by LDAP
; Author ........: water
; Modified.......:
; Remarks .......: This query returns all groups that have the attribute "managedBy" set or set to the specified manager.
;+
;                  To get a list of all groups that manager x manages (by querying just the user object) use:
;                    $Result = _AD_GetObjectAttribute("samAccountName of the manager","managedObjects")
;                    _ArrayDisplay($Result)
;+
;                  To return managers for OUs change "objectCategory=group" to "objectClass=organizationalUnit".
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetManagedBy($sManagedBy = "*")

	If $sManagedBy <> "*" Then
		If _AD_ObjectExists($sManagedBy) = 0 Then Return SetError(1, 0, "")
		If StringMid($sManagedBy, 3, 1) <> "=" Then $sManagedBy = _AD_SamAccountNameToFQDN($sManagedBy) ; sAMAccountName provided
	EndIf
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(&(objectCategory=group)(managedby=" & $sManagedBy & "))" & ";distinguishedName,managedby;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(2, @error, "")
	$oRecordSet.MoveFirst
	Local $aResult[1][2], $iCount1 = 1
	Do
		ReDim $aResult[$iCount1 + 1][2]
		$aResult[$iCount1][0] = $oRecordSet.Fields("distinguishedName").Value
		$aResult[$iCount1][1] = $oRecordSet.Fields("managedBy").Value
		$oRecordSet.MoveNext
		$iCount1 += 1
	Until $oRecordSet.EOF
	$oRecordSet.Close
	$aResult[0][0] = UBound($aResult, 1) - 1
	$aResult[0][1] = UBound($aResult, 2)
	Return $aResult

EndFunc   ;==>_AD_GetManagedBy

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetManager
; Description ...: Retrieves all users that are managed by any or the specified user.
; Syntax.........: _AD_GetManager([$sManager = "*"])
; Parameters ....: $sManager - Optional: Manager to filter the list of users (default = *). Can be sAMAccountName or FQDN
; Return values .: Success - Returns a one-based two dimensional array with the following information:
;                  |0 - distinguished name of the user
;                  |1 - distinguished name of the manager for this user
;                  Failure - "", sets @error to:
;                  |1 - $sManager is unknown
;                  |2 - No users found. @extended is set to the error returned by LDAP
; Author ........: water
; Modified.......:
; Remarks .......: This query returns all users that have the attribute "Manager" set or set to the specified manager.
;+
;                  To get a list of all users that manager x manages (by querying just the user object) use:
;                    $Result = _AD_GetObjectAttribute("samAccountName of the manager","directReports")
;                    _ArrayDisplay($Result)
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetManager($sManager = "*")

	If $sManager <> "*" Then
		If _AD_ObjectExists($sManager) = 0 Then Return SetError(1, 0, "")
		If StringMid($sManager, 3, 1) <> "=" Then $sManager = _AD_SamAccountNameToFQDN($sManager) ; sAMAccountName provided
	EndIf
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(&(objectCategory=user)(manager=" & $sManager & "))" & ";distinguishedName,Manager;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(2, @error, "")
	$oRecordSet.MoveFirst
	Local $aResult[1][2], $iCount1 = 1
	Do
		ReDim $aResult[$iCount1 + 1][2]
		$aResult[$iCount1][0] = $oRecordSet.Fields("distinguishedName").Value
		$aResult[$iCount1][1] = $oRecordSet.Fields("Manager").Value
		$oRecordSet.MoveNext
		$iCount1 += 1
	Until $oRecordSet.EOF
	$oRecordSet.Close
	$aResult[0][0] = UBound($aResult, 1) - 1
	$aResult[0][1] = UBound($aResult, 2)
	Return $aResult

EndFunc   ;==>_AD_GetManager

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetGroupAdmins
; Description ...: Returns an array of the administrator sAMAccountNames for the specified group (not including the group owner/manager).
; Syntax.........: _AD_GetGroupAdmins($sObject)
; Parameters ....: $sObject - group name. Can be SAMaccountName or FQDN
; Return values .: Success - Returns an one-based one dimensional array with the sAMAccountNames of the administrators for the specified group
;                  +(not including the group owner/manager)
;                  Failure - "", sets @error to:
;                  |1 - Group could not be found
;                  |2 - No administrators found
; Author ........: John Clelland
; Modified.......: water
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetGroupAdmins($sObject)

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, "")
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $sManagedBy = $oGroup.Get("managedBy")
	Local $oSD = $oGroup.Get("ntSecurityDescriptor")
	Local $oDACL = $oSD.DiscretionaryAcl
	Local $aAdmins[1] = [0], $ssamID, $sManagedBy_samID
	For $oACE In $oDACL
		If $oACE.ObjectType = $SELF_MEMBERSHIP And $oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT And _
				BitAND($oACE.AccessMask, $ADS_RIGHT_DS_WRITE_PROP) = $ADS_RIGHT_DS_WRITE_PROP Then
			$ssamID = StringTrimLeft($oACE.Trustee, StringInStr($oACE.Trustee, "\"))
			; S-1-5-21: SECURITY_NT_NON_UNIQUE - See: http://msdn.microsoft.com/en-us/library/aa379649(VS.85).aspx
			If Not StringInStr($ssamID, "S-1-5-21") And Not StringInStr($ssamID, "Account Operator") Then _ArrayAdd($aAdmins, $ssamID)
		EndIf
	Next
	If $sManagedBy <> "" Then
		$sManagedBy_samID = _AD_FQDNToSamAccountName($sManagedBy)
		Local $iCount1
		Local $iOwner = -1
		For $iCount1 = 1 To UBound($aAdmins) - 1
			If $aAdmins[$iCount1] = $sManagedBy_samID Then $iOwner = $iCount1
		Next
		If $iOwner <> -1 Then
			_ArrayDelete($aAdmins, $iOwner)
		EndIf
	EndIf
	$aAdmins[0] = UBound($aAdmins) - 1
	If $aAdmins[0] = 0 Then Return SetError(2, 0, "")
	Return $aAdmins

EndFunc   ;==>_AD_GetGroupAdmins

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GroupManagerCanModify
; Description ...: Returns 1 if the manager of the group can modify the member list.
; Syntax.........: _AD_GroupManagerCanModify($sObject)
; Parameters ....: $sObject - FQDN of the group
; Return values .: Success - 1, Specified user can modify the member list
;                  Failure - 0, @error set
;                  |1 - Group does not exist
;                  |2 - The group manager can not modify the member list
;                  |3 - There is no manager assigned to the group
; Author ........: John Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_GroupAssignManager, _AD_GroupRemoveManager, _AD_SetGroupManagerCanModify
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GroupManagerCanModify($sObject)

	If _AD_ObjectExists($sObject) = 0 Then Return SetError(1, 0, 0)
	If StringMid($sObject, 3, 1) <> "=" Then $sObject = _AD_SamAccountNameToFQDN($sObject) ; sAMAccountName provided
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sObject)
	Local $sManagedBy = $oGroup.Get("managedBy")
	If $sManagedBy = "" Then Return SetError(3, 0, 0)
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sManagedBy)
	Local $aUserFQDN = StringSplit($sManagedBy, "DC=", 1)
	Local $sDomain = StringTrimRight($aUserFQDN[2], 1)
	Local $sSamAccountName = $oUser.Get("sAMAccountName")
	Local $oSD = $oGroup.Get("ntSecurityDescriptor")
	Local $oDACL = $oSD.DiscretionaryAcl
	Local $bMatch = False
	For $oACE In $oDACL
		If StringLower($oACE.Trustee) = StringLower($sDomain & "\" & $sSamAccountName) And _
				$oACE.ObjectType = $SELF_MEMBERSHIP And _
				$oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT And _
				BitAND($oACE.AccessMask, $ADS_RIGHT_DS_WRITE_PROP) = $ADS_RIGHT_DS_WRITE_PROP Then $bMatch = True
	Next
	If $bMatch Then
		Return 1
	Else
		Return SetError(2, 0, 0)
	EndIf

EndFunc   ;==>_AD_GroupManagerCanModify

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListPrintQueues
; Description ...: Enumerates all PrintQueues in the AD tree or for the specified spool server.
; Syntax.........: _AD_ListPrintQueues([$sServername=*])
; Parameters ....: $sServername - Optional: Short name of the spool server to process
; Return values .: Success - One-based two dimensional array with the following information:
;                  |0 - PrinterName: Short name of the PrintQueue
;                  |1 - ServerName: SpoolServerName.Domain
;                  |2 - DistinguishedName: FQDN of the PrintQueue
;                  Failure - "", @error set
;                  |1 - There is no PrintQueue available. @extended is set to the error returned by LDAP
; Author ........: water
; Modified.......:
; Remarks .......: To get more (including multi-valued) attributes of a printqueue use _AD_GetObjectProperties
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa706091(VS.85).aspx, http://www.activxperts.com/activmonitor/windowsmanagement/scripts/printing/printerport/#LAPP.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListPrintQueues($sServername = "*")

	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(&(objectclass=printQueue)(shortservername=" & $sServername & "));distinguishedName,PrinterName,ServerName;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	Local $aPrinterList[$oRecordSet.RecordCount + 1][3] = [[0, 3]]
	$oRecordSet.MoveFirst
	Do
		$aPrinterList[0][0] += 1
		$aPrinterList[$aPrinterList[0][0]][0] = $oRecordSet.Fields("printerName").Value
		$aPrinterList[$aPrinterList[0][0]][1] = $oRecordSet.Fields("serverName").Value
		$aPrinterList[$aPrinterList[0][0]][2] = $oRecordSet.Fields("distinguishedName").Value
		$oRecordSet.MoveNext
	Until $oRecordSet.EOF
	$oRecordSet.Close
	Return $aPrinterList

EndFunc   ;==>_AD_ListPrintQueues

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_SetGroupManagerCanModify
; Description ...: Sets the Group manager to be able to modify the member list.
; Syntax.........: _AD_SetGroupManagerCanModify($sGroup)
; Parameters ....: $sGroup - Groupname (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, @error set
;                  |1 - $sGroup does not exist
;                  |2 - Group manager can already modify the member list
;                  |3 - $sGroup has no manager assigned
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_GroupAssignManager, _AD_GroupManagerCanModify, _AD_GroupRemoveManager
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SetGroupManagerCanModify($sGroup)

	Local Const $ADS_OPTION_SECURITY_MASK = 3 ; See: http://msdn.microsoft.com/en-us/library/windows/desktop/aa772273(v=vs.85).aspx
	Local Const $ADS_SECURITY_INFO_DACL = 0x4 ; See: http://msdn.microsoft.com/en-us/library/windows/desktop/aa772293(v=vs.85).aspx
	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, 0)
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	If _AD_GroupManagerCanModify($sGroup) = 1 Then Return SetError(2, 0, 0)
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup)
	Local $sManagedBy = $oGroup.Get("managedBy")
	If $sManagedBy = "" Then Return SetError(3, 0, 0)
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sManagedBy)
	Local $aUserFQDN = StringSplit($sManagedBy, "DC=", 1)
	Local $sDomain = StringTrimRight($aUserFQDN[2], 1)
	Local $sSamAccountName = $oUser.Get("sAMAccountName")
	Local $oSD = $oGroup.Get("ntSecurityDescriptor")
	$oSD.Owner = $sDomain & "\" & @UserName
	Local $oDACL = $oSD.DiscretionaryAcl
	Local $oACE = ObjCreate("AccessControlEntry")
	$oACE.Trustee = $sDomain & "\" & $sSamAccountName
	$oACE.AccessMask = $ADS_RIGHT_DS_WRITE_PROP
	$oACE.AceFlags = 0
	$oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
	$oACE.Flags = $ADS_FLAG_OBJECT_TYPE_PRESENT
	$oACE.ObjectType = $SELF_MEMBERSHIP
	$oDACL.AddAce($oACE)
	$oSD.DiscretionaryAcl = __AD_ReorderACE($oDACL)
	; Set options to only update the DACL. See: http://www.activedir.org/ListArchives/tabid/55/view/topic/postid/28231/Default.aspx
	$oGroup.Setoption($ADS_OPTION_SECURITY_MASK, $ADS_SECURITY_INFO_DACL)
	$oGroup.Put("ntSecurityDescriptor", $oSD)
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_SetGroupManagerCanModify

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GroupAssignManager
; Description ...: Assigns the user as group manager.
; Syntax.........: _AD_GroupAssignManager($sGroup, $sUser)
; Parameters ....: $sGroup - Groupname (sAMAccountName or FQDN)
;                  $sUser - User to assign as manager (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, @error set
;                  |1 - $sGroup does not exist
;                  |2 - $sUser does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_SetGroupManagerCanModify, _AD_GroupManagerCanModify, _AD_GroupRemoveManager
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GroupAssignManager($sGroup, $sUser)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, 0)
	If _AD_ObjectExists($sUser) = 0 Then Return SetError(2, 0, 0)
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	If StringMid($sUser, 3, 1) <> "=" Then $sUser = _AD_SamAccountNameToFQDN($sUser) ; sAMAccountName provided
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup)
	$oGroup.Put("managedBy", $sUser)
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_GroupAssignManager

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GroupRemoveManager
; Description ...: Remove the group manager from a group or only remove the manager's modify permission.
; Syntax.........: _AD_GroupRemoveManager($sGroup[, $bFlag = False])
; Parameters ....: $sGroup - Groupname (sAMAccountName or FQDN)
;                  $bFlag  - Optional: if True the function only removes the manager's modify permission
; Return values .: Success - 1
;                  Failure - 0, @error set
;                  |1 - $sGroup does not exist
;                  |2 - $sGroup does not have a manager assigned
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......: _AD_SetGroupManagerCanModify, _AD_GroupManagerCanModify, _AD_GroupAssignManager
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GroupRemoveManager($sGroup, $bFlag = False)

	If _AD_ObjectExists($sGroup) = 0 Then Return SetError(1, 0, 0)
	If StringMid($sGroup, 3, 1) <> "=" Then $sGroup = _AD_SamAccountNameToFQDN($sGroup) ; sAMAccountName provided
	Local $oGroup = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sGroup)
	Local $sManagedBy = $oGroup.Get("managedBy")
	If $sManagedBy = "" Then Return SetError(2, 0, 0)
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sManagedBy)
	Local $aUserFQDN = StringSplit($sManagedBy, "DC=", 1)
	Local $sDomain = StringTrimRight($aUserFQDN[2], 1)
	Local $sSamAccountName = $oUser.Get("sAMAccountName")
	Local $oSD = $oGroup.Get("ntSecurityDescriptor")
	$oSD.Owner = $sDomain & "\" & @UserName
	Local $oDACL = $oSD.DiscretionaryAcl
	For $oACE In $oDACL
		If StringLower($oACE.Trustee) = StringLower($sDomain & "\" & $sSamAccountName) And _
				$oACE.ObjectType = $SELF_MEMBERSHIP And _
				$oACE.AceType = $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT And _
				$oACE.AccessMask = $ADS_RIGHT_DS_WRITE_PROP Then _
				$oDACL.RemoveAce($oACE)
	Next
	$oSD.DiscretionaryAcl = $oDACL
	$oGroup.Put("ntSecurityDescriptor", $oSD)
	If Not $bFlag Then $oGroup.PutEx(1, "managedBy", 0)
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_GroupRemoveManager

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_AddEmailAddress
; Description ...: Appends an SMTP email address to the 'Email Addresses' tab of an Exchange-enabled AD account.
; Syntax.........: _AD_AddEmailAddress($sUser, $sNewEmail[, $bPrimary = False])
; Parameters ....: $sUser - User account (sAMAccountName or FQDN)
;                  $sNewEmail - Email address to add to the account
;                  $bPrimary - Optional: if True the new email address will be set as primary address
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sUser does not exist
;                  |2 - Could not connect to $sUser. @extended is set to the error returned by LDAP
;                  |x - Error returned by GetEx or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_AddEmailAddress($sUser, $sNewEmail, $bPrimary = False)

	If _AD_ObjectExists($sUser) = 0 Then Return SetError(1, 0, 0)
	If StringMid($sUser, 3, 1) <> "=" Then $sUser = _AD_SamAccountNameToFQDN($sUser) ; sAMAccountName provided
	Local $oUser = __AD_ObjGet("LDAP://" & $sAD_HostServer & "/" & $sUser)
	If @error Or Not IsObj($oUser) Then Return SetError(2, @error, 0)
	Local $aProxyAddresses = $oUser.GetEx("proxyaddresses")
	If @error Then Return SetError(@error, 0, 0)
	If $bPrimary Then
		For $iCount1 = 0 To UBound($aProxyAddresses) - 1
			If StringInStr($aProxyAddresses[$iCount1], "SMTP:", 1) Then
				$aProxyAddresses[$iCount1] = StringReplace($aProxyAddresses[$iCount1], "SMTP:", "smtp:", 0, 1)
			EndIf
		Next
		_ArrayAdd($aProxyAddresses, "SMTP:" & $sNewEmail)
		$oUser.Put("mail", $sNewEmail)
	Else
		_ArrayAdd($aProxyAddresses, "smtp:" & $sNewEmail)
	EndIf
	$oUser.PutEx(2, "proxyaddresses", $aProxyAddresses)
	$oUser.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_AddEmailAddress

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_JoinDomain
; Description ...: Joins the computer to an already created computer account in a domain.
; Syntax.........: _AD_JoinDomain($sComputer[, $sUserParam = "", $sPasswordParam = ""])
; Parameters ....: $sComputer - Computername to join to the domain
;                  $sUserParam - Optional: User with admin rights to join the computer to the domain (NetBIOSName (domain\user) or user principal name (user@domain))
;                  +(Default = credentials under which the script is run or from _AD_Open are used)
;                  $sPasswordParam - Optional: Password for $sUserParam. (Default = credentials under which the script is run are used)
; Return values .: Success - 1
;                  Failure - 0, @error set
;                  |1 - $sComputer account does not exist in the domain
;                  |2 - $sUserParam does not exist in the domain
;                  |3 - WMI object could not be created. See @extended for error code. See remarks for further information
;                  |4 - The computer is already a member of the domain
;                  |5 - Joining the domain was not successful. @extended holds the Win32 error code (see: http://msdn.microsoft.com/en-us/library/ms681381(v=VS.85).aspx)
; Author ........: water
; Modified.......:
; Remarks .......: The domain to which the computer is joined to is the domain the user logged on to using AD_Open.
;                  If no credentials are passed to this function but have been used with _AD_Open() then the _AD_Open credentials will be used for this function.
;                  You have to reboot the computer after a successful join to the domain.
;                  The JoinDomainOrWorkgroup method is available only on Windows XP computer and Windows Server 2003 or later.
; Related .......: _AD_CreateComputer
; Link ..........: http://technet.microsoft.com/en-us/library/ee692588.aspx, http://msdn.microsoft.com/en-us/library/aa392154(VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_JoinDomain($sComputer, $sUserParam = "", $sPasswordParam = "")

	If _AD_ObjectExists($sComputer & "$") = 0 Then Return SetError(1, 0, 0)
	If $sUserParam <> "" And _AD_ObjectExists($sUserParam) = 0 Then Return SetError(2, 0, 0)
	Local $iResult
	Local $sDomainName = StringReplace(StringReplace($sAD_DNSDomain, "DC=", ""), ",", ".")
	; Create WMI object
	Local $oComputer = ObjGet("winmgmts:{impersonationLevel=Impersonate}!\\" & $sComputer & "\root\cimv2:Win32_ComputerSystem.Name='" & $sComputer & "'")
	If @error Or Not IsObj($oComputer) Then Return SetError(3, @error, 0)
	If $oComputer.Domain = $sDomainName Then Return SetError(4, 0, 0)
	; Join domain. Use credentials passed as parameters to this function or those used at _AD_Open, if any
	If $sUserParam <> "" Then
		$iResult = $oComputer.JoinDomainOrWorkGroup($sDomainName, $sPasswordParam, $sDomainName & "\" & $sUserParam, Default, 1)
	ElseIf $sAD_UserId <> "" Then
		; Domain NetBIOS name and user account (domain\user) or user principal name (user@domain) is supported
		Local $sTemp = $sAD_UserId
		If StringInStr($sAD_UserId, "\") = 0 And StringInStr($sAD_UserId, "@") = 0 Then $sTemp = $sDomainName & "\" & $sAD_UserId
		$iResult = $oComputer.JoinDomainOrWorkGroup($sDomainName, $sAD_Password, $sDomainName & "\" & $sTemp, Default, 1)
	Else
		$iResult = $oComputer.JoinDomainOrWorkGroup($sDomainName, Default, Default, Default, 1)
	EndIf
	If $iResult <> 0 Then Return SetError(5, $iResult, 0)
	Return 1

EndFunc   ;==>_AD_JoinDomain

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_UnJoinDomain
; Description ...: Unjoins the computer from its current domain and disables the computer account.
; Syntax.........: _AD_UnJoinDomain($sComputer[, $sWorkgroup [,$sUserParam, $sPasswordParam]])
; Parameters ....: $sComputer - Computername to unjoin from the domain
;                  $sWorkgroup - Optional: Workgroup the unjoined computer is assigned to (Default = Domain the computer was unjoined from)
;                  $sUserParam - Optional: User with admin rights to unjoin the computer from the domain (NetBIOSName)
;                  +(Default = credentials under which the script is run or from _AD_Open are used)
;                  $sPasswordParam - Optional: Password for $sUserParam. (Default = credentials under which the script is run are used)
; Return values .: Success - 1
;                  Failure - 0, @error set
;                  |1 - $sComputer account does not exist in the domain
;                  |2 - $sUserParam does not exist in the domain
;                  |3 - WMI object could not be created. See @extended for error code. See remarks for further information
;                  |4 - The computer is a member of another or no domain
;                  |5 - Unjoining the domain was not successful. See @extended for error code. See remarks for further information
;                  |6 - Joining the Computer to the specified workgroup was not successful. See @extended for error code
; Author ........: water
; Modified.......:
; Remarks .......: The domain from which the computer is unjoined from has to be the domain the user logged on to using AD_Open.
;                  If no credentials are passed to this function but have been used with _AD_Open() then the _AD_Open credentials will be used for this function.
;                  If no workgroup is specified then the computer is assigned to a workgroup named like the domain the computer was unjoined from.
;                  You have to reboot the computer after a successful unjoin from the domain.
;                  The UnjoinDomainOrWorkgroup method is available only on Windows XP computer and Windows Server 2003 or later.
;                  A script using this function needs to be run with the #RequireAdmin directive.
; Related .......:
; Link ..........: http://gallery.technet.microsoft.com/ScriptCenter/en-us/c2025ace-cb51-4136-9de9-db8871f79f62, http://technet.microsoft.com/en-us/library/ee692588.aspx, http://msdn.microsoft.com/en-us/library/aa393942(VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_UnJoinDomain($sComputer, $sWorkgroup = "", $sUserParam = "", $sPasswordParam = "")

	Local $NETSETUP_ACCT_DELETE = 4 ; According to MS it should be 2 but only 4 works
	If _AD_ObjectExists($sComputer & "$") = 0 Then Return SetError(1, 0, 0)
	If $sUserParam <> "" And _AD_ObjectExists($sUserParam) = 0 Then Return SetError(2, 0, 0)
	Local $iResult
	Local $sDomainName = StringReplace(StringReplace($sAD_DNSDomain, "DC=", ""), ",", ".")
	; Create WMI object
	Local $oComputer = ObjGet("winmgmts:{impersonationLevel=Impersonate}!\\" & $sComputer & "\root\cimv2:Win32_ComputerSystem.Name='" & $sComputer & "'")
	If @error Or Not IsObj($oComputer) Then Return SetError(3, @error, 0)
	If $oComputer.Domain <> $sDomainName Then Return SetError(4, 0, 0)
	; UnJoin domain. Use credentials passed as parameters to this function or those used at _AD_Open, if any
	If $sUserParam <> "" Then
		$iResult = $oComputer.UnjoinDomainOrWorkGroup($sPasswordParam, $sDomainName & "\" & $sUserParam, $NETSETUP_ACCT_DELETE)
	ElseIf $sAD_UserId <> "" Then
		; Domain NetBIOS name and user account (domain\user) or user principal name (user@domain) is supported
		Local $sTemp = $sAD_UserId
		If StringInStr($sAD_UserId, "\") = 0 And StringInStr($sAD_UserId, "@") = 0 Then $sTemp = $sDomainName & "\" & $sAD_UserId
		$iResult = $oComputer.UnjoinDomainOrWorkGroup($sAD_Password, $sTemp, $NETSETUP_ACCT_DELETE)
	Else
		$iResult = $oComputer.UnjoinDomainOrWorkGroup(Default, Default, $NETSETUP_ACCT_DELETE)
	EndIf
	If $iResult <> 0 Then Return SetError(5, $iResult, 0)
	; Move unjoined computer to another workgroup
	If $sWorkgroup <> "" Then
		$iResult = $oComputer.JoinDomainOrWorkGroup($sWorkgroup, Default, Default, Default, Default)
		If $iResult <> 0 Then Return SetError(6, $iResult, 0)
	EndIf
	Return 1

EndFunc   ;==>_AD_UnJoinDomain

; #FUNCTION#====================================================================================================================
; Name...........: _AD_SetPasswordExpire
; Description ...: Sets user's password as expired or not expired.
; Syntax.........: _AD_SetPasswordExpire($sUser[, $iFlag = 0])
; Parameters ....: $sUser - User account (sAMAccountName or FQDN)
;                  $iFlag - Optional: Sets the user's password as expired ($iFlag = 0) or as not expired ($iFlag = -1) (Default = 0)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sUser does not exist
;                  |2 - $iFlag has an invalid value
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Ethan Turk
; Modified.......:
; Remarks .......: When the user's password is set to expired he has to change the password at next logon
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SetPasswordExpire($sUser, $iFlag = 0)

	If Not _AD_ObjectExists($sUser) Then Return SetError(1, 0, 0)
	If $iFlag <> 0 And $iFlag <> -1 Then Return SetError(2, 0, 0)
	Local $sProperty = "sAMAccountName"
	If StringMid($sUser, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sUser & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	$oObject.Put("pwdLastSet", $iFlag)
	$oObject.SetInfo()
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_SetPasswordExpire

; #FUNCTION#====================================================================================================================
; Name...........: _AD_CreateMailbox
; Description ...: Creates a mailbox for a user.
; Syntax.........: _AD_CreateMailbox($sUser, $sStoreName[, $sStore[, $sEMailServer[, $sAdminGroup[, $sEmailDomain]]]])
; Parameters ....: $sUser - User account (sAMAccountName or FQDN) to add mailbox to
;                  $sStoreName - Mailbox storename
;                  $sStore - Optional: Information store (Default = "First Storage Group")
;                  $sEmailServer - Optional: Email server (Default = First server returned by _AD_ListExchangeServers())
;                  $sAdminGroup - Optional: Administrative group in Exchange (Default= "First Administrative Group")
;                  $sEmailDomain - Optional: Exchange Server Group name e.g. "My Company" (Default = Text after first DC= in $sAD_DNSDomain)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sUser does not exist
;                  |2 - $sUser already has a mailbox
;                  |3 - _AD_ListExchangeServers() returned an error. Please see @extended for _AD_ListExchangeServers() return code
;                  |x - Error returned by CreateMailbox or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: The mailbox is created using CDOEXM. For this function to work the Exchange administration tools have to be installed on the
;                  computer running the script.
;                  To set rights on the mailbox you have to run at least Exchange 2000 SP2.
;+
;                  If the Exchange administration tools are not installed on the PC running the script you could use an ADSI only solution.
;                  Set the mailNickname and displayName properties of the user and at least one of this: homeMTA, homeMDB or msExchHomeServerName and
;                  the RUS (Recipient Update Service) of Exchange 2000/2003 will create the mailbox for you.
;                  Be aware that this no longer works for Exchange 2007 and later.
; Related .......:
; Link ..........: http://www.msxfaq.de/code/makeuser.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_CreateMailbox($sUser, $sStoreName, $sStore = "First Storage Group", $sEMailServer = "", $sAdminGroup = "First Administrative Group", $sEmailDomain = "")

	If Not _AD_ObjectExists($sUser) Then Return SetError(1, 0, 0)
	Local $sProperty = "sAMAccountName"
	If StringMid($sUser, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sUser & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oUser = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	If $oUser.HomeMDB <> "" Then Return SetError(2, 0, 0)
	Local $aTemp
	If $sEmailDomain = "" Then
		$aTemp = StringSplit($sAD_DNSDomain, ",")
		$sEmailDomain = StringMid($aTemp[1], 4)
	EndIf
	If $sEMailServer = "" Then
		$aTemp = _AD_ListExchangeServers()
		If @error Then Return SetError(3, @error, 0)
		$sEMailServer = $aTemp[1]
	EndIf
	Local $sMailboxpath = "LDAP://CN="
	$sMailboxpath &= $sStoreName
	$sMailboxpath &= ",CN="
	$sMailboxpath &= $sStore
	$sMailboxpath &= ",CN=InformationStore"
	$sMailboxpath &= ",CN="
	$sMailboxpath &= $sEMailServer
	$sMailboxpath &= ",CN=Servers,CN="
	$sMailboxpath &= $sAdminGroup
	$sMailboxpath &= ",CN=Administrative Groups,CN=" & $sEmailDomain & ",CN=Microsoft Exchange,CN=Services,CN=Configuration,"
	$sMailboxpath &= $sAD_DNSDomain
	$oUser.CreateMailbox($sMailboxpath)
	If @error Then Return SetError(@error, 0, 0)
	$oUser.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_CreateMailbox

; #FUNCTION#====================================================================================================================
; Name...........: _AD_DeleteMailbox
; Description ...: Deletes a users mailbox.
; Syntax.........: _AD_DeleteMailbox($sUser)
; Parameters ....: $sUser - User account (sAMAccountName or FQDN) to delete mailbox from
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sUser does not exist
;                  |2 - $sUser doesn't have a mailbox
;                  |x - Error returned by DeleteMailbox or SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_DeleteMailbox($sUser)

	Local $sProperty = "sAMAccountName"
	If StringMid($sUser, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sUser & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oUser = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	If $oUser.HomeMDB = "" Then Return SetError(2, 0, 0)
	$oUser.DeleteMailbox
	If @error Then Return SetError(@error, 0, 0)
	$oUser.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_DeleteMailbox

; #FUNCTION#====================================================================================================================
; Name...........: _AD_MailEnableGroup
; Description ...: Mail-enables a Group.
; Syntax.........: _AD_MailEnableGroup($sGroup)
; Parameters ....: $sGroup - Groupname (sAMAccountName or FQDN)
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sGroup does not exist
;                  |x - Error returned by SetInfo method (Missing permission etc.)
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_MailEnableGroup($sGroup)

	If Not _AD_ObjectExists($sGroup) Then Return SetError(1, 0, 0)
	Local $sProperty = "sAMAccountName"
	If StringMid($sGroup, 3, 1) = "=" Then $sProperty = "distinguishedName"; FQDN provided
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sGroup & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oGroup = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	$oGroup.MailEnable
	$oGroup.Put("grouptype", $ADS_GROUP_TYPE_UNIVERSAL_SECURITY)
	$oGroup.SetInfo
	If @error Then Return SetError(@error, 0, 0)
	Return 1

EndFunc   ;==>_AD_MailEnableGroup

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_IsAccountExpired
; Description ...: Returns 1 if the account (user, computer) has expired.
; Syntax.........: _AD_IsAccountExpired([$sObject = @Username])
; Parameters ....: $sObject - Optional: Account (User, computer) to check (default = @Username). Can be specified as Fully Qualified Domain Name (FQDN) or sAMAccountName
; Return values .: Success - 1, The specified account has expired
;                  Failure - 0, sets @error to:
;                  |0 - Account has not expired
;                  |1 - $sObject could not be found
;                  |2 - An error occurred when accessing property AccountExpirationDate. @extended is set to the error returned by LDAP
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_GetAccountsExpired, _AD_SetAccountExpire
; Link ..........: http://www.rlmueller.net/AccountExpires.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_IsAccountExpired($sObject = @UserName)

	Local $sProperty = "sAMAccountName"
	If StringMid($sObject, 3, 1) = "=" Then $sProperty = "distinguishedName" ; FQDN provided
	If _AD_ObjectExists($sObject, $sProperty) = 0 Then Return SetError(1, 0, 0)
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sAD_DNSDomain & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	Local $sLDAPEntry = $oRecordSet.fields(0).Value
	Local $oObject = __AD_ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
	Local $sAccountExpires = $oObject.AccountExpirationDate
	If @error Then Return SetError(2, @error, 0)
	If $sAccountExpires <> "19700101000000" And StringLeft($sAccountExpires, 8) <> "16010101" And $sAccountExpires < @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC Then Return 1
	Return

EndFunc   ;==>_AD_IsAccountExpired

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetAccountsExpired
; Description ...: Returns an array with FQDNs of expired accounts (user, computer).
; Syntax.........: _AD_GetAccountsExpired([$sClass = "user"[ ,$sDTEExpire = ""[ ,$sDTSExpire = ""[, $sRoot = ""]]]])
; Parameters ....: $sClass - Optional: Specifies if expired user accounts or computer accounts should be returned (default = "user").
;                  |"user" - Returns objects of category "user"
;                  |"computer" - Returns objects of category "computer"
;                  $sDTEExpire - YYYY/MM/DD HH:MM:SS (local time) returns all accounts that expire between $sDTSExpire and the specified date/time (default = "" = Now)
;                  $sDTSExpire - YYYY/MM/DD HH:MM:SS (local time) returns all accounts that expire between the specified date/time and $sDTEExpire (default = "1601/01/01 00:00:00)
;                  $sRoot - Optional: FQDN of the OU where the search should start (default = "" = search the whole tree)
; Return values .: Success - One-based two dimensional array of FQDNs of expired accounts
;                  |0 - FQDNs of expired accounts
;                  |1 - account expired YYYY/MM/DD HH:NMM:SS UTC
;                  |2 - account expired YYYY/MM/DD HH:NMM:SS local time of calling user
;                  Failure - "", sets @error to:
;                  |1 - No expired accounts found. @extended is set to the error returned by LDAP
;                  |2 - Specified date/time is invalid
;                  |3 - Invalid value for $sClass. Has to be "user" or "computer"
;                  |4 - Specified $sRoot does not exist
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......: _AD_IsAccountExpired, _AD_SetAccountExpire
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetAccountsExpired($sClass = "user", $sDTEExpire = "", $sDTSExpire = "", $sRoot = "")

	If $sClass <> "user" And $sClass <> "computer" Then Return SetError(3, 0, 0)
	If $sRoot = "" Then
		$sRoot = $sAD_DNSDomain
	Else
		If _AD_ObjectExists($sRoot, "distinguishedName") = 0 Then Return SetError(4, 0, "")
	EndIf
	; process end date/time
	If $sDTEExpire = "" Then
		$sDTEExpire = _Date_Time_GetSystemTime() ; Get current date/time (UTC)
		$sDTEExpire = _Date_Time_SystemTimeToDateTimeStr($sDTEExpire, 1) ; convert to format yyyy/mm/dd hh:mm:ss
	ElseIf Not _DateIsValid($sDTEExpire) Then
		Return SetError(2, 0, 0)
	Else
		$sDTEExpire = _Date_Time_EncodeSystemTime(StringMid($sDTEExpire, 6, 2), StringMid($sDTEExpire, 9, 2), StringLeft($sDTEExpire, 4), _ ; encode input
				StringMid($sDTEExpire, 12, 2), StringMid($sDTEExpire, 15, 2), StringMid($sDTEExpire, 18, 2))
		Local $sDTEExpireUTC = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($sDTEExpire)) ; convert local time to UTC
		$sDTEExpire = _Date_Time_SystemTimeToDateTimeStr($sDTEExpireUTC, 1) ; convert to format yyyy/mm/dd hh:mm:ss
	EndIf
	; process start date/time
	If $sDTSExpire = "" Then $sDTSExpire = "1600/01/01 00:00:00"
	If Not _DateIsValid($sDTSExpire) Then
		Return SetError(2, 0, 0)
	Else
		$sDTSExpire = _Date_Time_EncodeSystemTime(StringMid($sDTSExpire, 6, 2), StringMid($sDTSExpire, 9, 2), StringLeft($sDTSExpire, 4), _ ; encode input
				StringMid($sDTSExpire, 12, 2), StringMid($sDTSExpire, 15, 2), StringMid($sDTSExpire, 18, 2))
		Local $sDTSExpireUTC = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($sDTSExpire)) ; convert local time to UTC
		$sDTSExpire = _Date_Time_SystemTimeToDateTimeStr($sDTSExpireUTC, 1) ; convert to format yyyy/mm/dd hh:mm:ss
	EndIf
	Local $iDTEExpire = _DateDiff("s", "1601/01/01 00:00:00", $sDTEExpire) * 10000000 ; convert end date/time to Integer8
	Local $iDTSExpire = _DateDiff("s", "1601/01/01 00:00:00", $sDTSExpire) * 10000000 ; convert start date/time to Integer8
	Local $iTemp, $sTemp
	Local $sDTStruct = DllStructCreate("dword low;dword high")
	; -1 to remove rounding errors
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sRoot & ">;(&(objectCategory=person)(objectClass=" & $sClass & ")" & _
			"(!accountExpires=0)(accountExpires<=" & Int($iDTEExpire) - 1 & ")(accountExpires>=" & Int($iDTSExpire) - 1 & "));distinguishedName,accountExpires;subtree"
	Local $oRecordSet = $__oAD_Command.Execute
	If @error Or Not IsObj($oRecordSet) Or $oRecordSet.RecordCount = 0 Then Return SetError(1, @error, "")
	Local $aFQDN[$oRecordSet.RecordCount + 1][3]
	$aFQDN[0][0] = $oRecordSet.RecordCount
	Local $iCount = 1
	While Not $oRecordSet.EOF
		$aFQDN[$iCount][0] = $oRecordSet.Fields(0).Value ; distinguishedName
		$iTemp = $oRecordSet.Fields(1).Value ; accountExpires
		DllStructSetData($sDTStruct, "Low", $iTemp.LowPart)
		DllStructSetData($sDTStruct, "High", $iTemp.HighPart)
		$sTemp = _Date_Time_FileTimeToSystemTime(DllStructGetPtr($sDTStruct))
		$aFQDN[$iCount][1] = _Date_Time_SystemTimeToDateTimeStr($sTemp, 1) ; accountExpires as UTC
		$sTemp = _Date_Time_SystemTimeToTzSpecificLocalTime(DllStructGetPtr($sTemp))
		$aFQDN[$iCount][2] = _Date_Time_SystemTimeToDateTimeStr($sTemp, 1) ; accountExpires as local time
		$iCount += 1
		$oRecordSet.MoveNext
	WEnd
	$aFQDN[0][0] = UBound($aFQDN) - 1
	Return $aFQDN

EndFunc   ;==>_AD_GetAccountsExpired

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ListSchemaVersions
; Description ...: Returns information about the AD Schema versions.
; Syntax.........: _AD_ListSchemaVersions()
; Parameters ....: None
; Return values .: Success - Returns an one-based one dimensional array of the following Schema versions.
;                  |1 - Active Directory Schema version. This can be one of the following values:
;                       13 - Windows 2000 Server
;                       30 - Windows Server 2003 RTM / Service Pack 1 / Service Pack 2
;                       31 - Windows Server 2003 R2
;                       44 - Windows Server 2008 RTM
;                       47 - Windows Server 2008 R2
;                  |2 - Exchange Schema version. This can be one of the following values:
;                       4397 - Exchange Server 2000 RTM
;                       4406 - Exchange Server 2000 With Service Pack 3
;                       6870 - Exchange Server 2003 RTM
;                       6936 - Exchange Server 2003 With Service Pack 3
;                       10628 - Exchange Server 2007
;                       11116 - Exchange 2007 With Service Pack 1
;                       14622 - Exchange 2007 With Service Pack 2, Exchange 2010 RTM
;                       14625 - Exchange 2007 SP3
;                       14720 - Exchange 2010 SP1 (beta)
;                       14726 - Exchange 2010 SP1
;                  |3 - Exchange 2000 Active Directory Connector version. This can be one of the following values:
;                       4197 - Exchange Server 2000 RTM
;                  |4 - Office Communications Server Schema version. This can be one of the following values:
;                       1006 - LCS 2005 SP1
;                       1007 - OCS 2007
;                       1008 - OCS 2007 R2
;                       1100 - Lync Server 2010
; Author ........: water
; Modified.......:
; Remarks .......: RTM stands for "Release to Manufacturing"
; Related .......:
; Link ..........: http://blog.dikmenoglu.de/Die+AD+Und+Exchange+Schemaversion+Abfragen.aspx, http://www.msxfaq.de/admin/build.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ListSchemaVersions()

	Local $aResult[5] = [4]
	Local $sLDAPEntry
	; Active Directory Schema Version
	Local $sSchemaNamingContext = $__oAD_RootDSE.Get("SchemaNamingContext")
	Local $oObject = __AD_ObjGet("LDAP://" & $sSchemaNamingContext) ; Retrieve the COM Object for the object
	$aResult[1] = $oObject.Get("objectVersion")
	; Exchange Schema version
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sSchemaNamingContext & ">;(name=ms-Exch-Schema-Version-Pt);ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	If IsObj($oRecordSet) And $oRecordSet.RecordCount > 0 Then
		$sLDAPEntry = $oRecordSet.fields(0).Value
		$oObject = ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
		$aResult[2] = $oObject.Get("rangeUpper")
	EndIf
	; Exchange 2000 Active Directory Connector version
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sSchemaNamingContext & ">;(name=ms-Exch-Schema-Version-Adc);ADsPath;subtree"
	$oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	If IsObj($oRecordSet) And $oRecordSet.RecordCount > 0 Then
		$sLDAPEntry = $oRecordSet.fields(0).Value
		$oObject = ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
		$aResult[3] = $oObject.Get("rangeUpper")
	EndIf
	; Office Communications Server Schema version
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sSchemaNamingContext & ">;(name=ms-RTC-SIP-SchemaVersion);ADsPath;subtree"
	$oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object
	If IsObj($oRecordSet) And $oRecordSet.RecordCount > 0 Then
		$sLDAPEntry = $oRecordSet.fields(0).Value
		$oObject = ObjGet($sLDAPEntry) ; Retrieve the COM Object for the object
		$aResult[4] = $oObject.Get("rangeUpper")
	EndIf

	Return $aResult

EndFunc   ;==>_AD_ListSchemaVersions

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_ObjectExistsInSchema
; Description ...: Returns 1 if exactly one object exists for the given property in the Active Directory Schema.
; Syntax.........: _AD_ObjectExistsInSchema($sObject [, $sProperty = "LDAPDisplayName"])
; Parameters ....: $sObject   - Optional: Object to check
;                  $sProperty - Optional: Property to check (default = LDAPDisplayName)
; Return values .: Success - 1, Exactly one object exists for the given property in the Active Directory Schema
;                  Failure - 0, sets @error to:
;                  |1 - No object found for the specified property
;                  |x - More than one object found for the specified property. x is the number of objects found
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_ObjectExistsInSchema($sObject, $sProperty = "LDAPDisplayName")

	Local $sSchemaNamingContext = $__oAD_RootDSE.Get("SchemaNamingContext")
	$__oAD_Command.CommandText = "<LDAP://" & $sAD_HostServer & "/" & $sSchemaNamingContext & ">;(" & $sProperty & "=" & $sObject & ");ADsPath;subtree"
	Local $oRecordSet = $__oAD_Command.Execute ; Retrieve the ADsPath for the object, if it exists
	If IsObj($oRecordSet) Then
		If $oRecordSet.RecordCount = 1 Then
			Return 1
		ElseIf $oRecordSet.RecordCount > 1 Then
			Return SetError($oRecordSet.RecordCount, 0, 0)
		Else
			Return SetError(1, 0, 0)
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf

EndFunc   ;==>_AD_ObjectExistsInSchema

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_FixSpecialChars
; Description ...: Escapes or unescapes special characters in Distinguished Names or LDAP filters.
; Syntax.........: _AD_FixSpecialChars($sText[, $iOption = 0[, $sEscapeChar = '"\/#,+<>;=']])
; Parameters ....: $sText - Text to add / remove escape characters
;                  $iOption - Optional: Defines whether to escape (Default) or unescape special characters for DN or LDAP filters.
;                                0 = Escape special characters in a Distinguished Name (default)
;                                1 = Unescape special characters in a Distinguished Name
;                                3 = Escape special characters in a LDAP filter
;                  $sEscapeChar - Optional: List of characters to escape or unescape in a DN (default = '"\/#,+<>;=')
; Return values .: $sText with escaped or unescaped special characters
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: Leading or trailing spaces have to be escaped by the user.
;                  $sEscapeChar is ignored when $iOption = 3.
; Related .......:
; Link ..........: http://www.rlmueller.net/CharactersEscaped.htm
; Example .......: Yes
; ===============================================================================================================================
Func _AD_FixSpecialChars($sText, $iOption = 0, $sEscapeChar = '"\/#,+<>;=')

	If $iOption = 0 Then
		; "?<!" means: Lookbehind assertion (negative) - see: http://www.autoitscript.com/forum/index.php?showtopic=112674&view=findpost&p=789310
		$sText = StringRegExpReplace($sText, "(?<!\\)([" & $sEscapeChar & "])", "\\$1")
	ElseIf $iOption = 1 Then
		If StringInStr($sEscapeChar, '"') Then $sText = StringReplace($sText, '\"', '"')
		If StringInStr($sEscapeChar, '/') Then $sText = StringReplace($sText, '\/', '/')
		If StringInStr($sEscapeChar, '#') Then $sText = StringReplace($sText, '\#', '#')
		If StringInStr($sEscapeChar, ',') Then $sText = StringReplace($sText, '\,', ',')
		If StringInStr($sEscapeChar, '+') Then $sText = StringReplace($sText, '\+', '+')
		If StringInStr($sEscapeChar, '<') Then $sText = StringReplace($sText, '\<', '<')
		If StringInStr($sEscapeChar, '>') Then $sText = StringReplace($sText, '\>', '>')
		If StringInStr($sEscapeChar, ';') Then $sText = StringReplace($sText, '\;', ';')
		If StringInStr($sEscapeChar, '=') Then $sText = StringReplace($sText, '\=', '=')
		If StringInStr($sEscapeChar, '\') Then $sText = StringReplace($sText, '\\', '\')
	Else
		; Taken from: http://www.autoitscript.com/forum/topic/156987-escape-special-characters/#entry1136636
		$sText = StringRegExpReplace(Execute('"' & StringRegExpReplace($sText, '(\*|\(|\)|\\(?![[:xdigit:]]{2}))', '" & "\\" & hex(ascw("$1"),2) &  "') & '"'), '(NUL)', "\\00")
	EndIf
	Return $sText

EndFunc   ;==>_AD_FixSpecialChars

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetLastADSIError
; Description ...: Retrieve the calling thread's last ADSI error code value.
; Syntax.........: _AD_GetLastADSIError()
; Parameters ....: None
; Return values .: Success - A one-based array containing the following values:
;                  |1 - ADSI error code (decimal)
;                  |2 - Unicode string that describes the error
;                  |3 - name of the provider that raised the error
;                  |4 - Win32 error code extracted from element[2]
;                  |5 - description of the Win32 error code as returned by _WinAPI_FormatMessage
;                  Failure - "", sets @error to the return value of DLLCall
; Author ........: water, card0384
; Modified.......:
; Remarks .......: This and more errors will be handled (error codes are in hex):
;                  525 - user not found
;                  52e - invalid credentials
;                  530 - not permitted to logon at this time
;                  532 - password expired
;                  533 - account disabled
;                  701 - account expired
;                  773 - user must reset password
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/cc231199(PROT.10).aspx (Win32 Error Codes), http://forums.sun.com/thread.jspa?threadID=703398
; Example .......:
; ===============================================================================================================================
Func _AD_GetLastADSIError()

	Local $aLastError[6] = [5]
	Local $EC = DllStructCreate("DWord")
	Local $ED = DllStructCreate("wchar[256]")
	Local $PN = DllStructCreate("wchar[256]")
	Local Const $__WINAPICONSTANT_FORMAT_MESSAGE_FROM_SYSTEM = 0x1000
	; ADsGetLastError: http://msdn.microsoft.com/en-us/library/aa772183(VS.85).aspx
	DllCall("Activeds.dll", "DWORD", "ADsGetLastError", "ptr", DllStructGetPtr($EC), "ptr", DllStructGetPtr($ED), "DWORD", 256, "ptr", DllStructGetPtr($PN), "DWORD", 256)
	If @error Then Return SetError(@error, @extended, "")
	$aLastError[1] = DllStructGetData($EC, 1) ; error code (decimal)
	$aLastError[2] = DllStructGetData($ED, 1) ; Unicode string that describes the error
	$aLastError[3] = DllStructGetData($PN, 1) ; name of the provider that raised the error
	; Old version to set element 4
	;	Local $sError = StringTrimLeft($aLastError[2], StringInStr($aLastError[2], "AcceptSecurityContext", 2))
	;	$sError = StringTrimLeft($sError, StringInStr($sError, " data", 2) + 5)
	;	$aLastError[4] = StringTrimRight($sError, StringLen($sError) - StringInStr($sError, ", vece", 2) + 1)
	If $aLastError[2] <> "" Then
		Local $aTempError = StringSplit($aLastError[2], ",")
		$aTempError = StringSplit(StringStripWS($aTempError[3], 7), " ")
		$aLastError[4] = $aTempError[2]
	EndIf
	_WinAPI_FormatMessage($__WINAPICONSTANT_FORMAT_MESSAGE_FROM_SYSTEM, 0, Dec($aLastError[4]), 0, $aLastError[5], 4096, 0)
	Return $aLastError

EndFunc   ;==>_AD_GetLastADSIError

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_GetADOProperties
; Description ...: Retrieves all properties of an ADO object (Connection, Command).
; Syntax.........: _AD_GetADOProperties($sADOobject[, $sProperties = ""])
; Parameters ....: $sADOobject - ADO object for which to retrieve the properties. Can be either "Connection" or "Command"
;                  $sProperties - Optional: Comma separated list of properties to return (default = "" = return all properties)
; Return values .: Success - Returns a one based two-dimensional array with all properties and their values of the specified object
;                  Failure - "", sets @error to:
;                  |1 - $sADOObject is invalid. Should either be "Command" or "Connection"
; Author ........: water
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: ADO Command: http://msdn.microsoft.com/en-us/library/ms675022(v=VS.85).aspx, ADO Connection: http://msdn.microsoft.com/en-us/library/ms681546(v=VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_GetADOProperties($sADOObject, $sProperties = "")

	Local $oObject
	If StringLeft($sADOObject, 3) = "Com" Then
		$oObject = $__oAD_Command
	ElseIf StringLeft($sADOObject, 3) = "Con" Then
		$oObject = $__oAD_Connection
	Else
		Return SetError(1, 0, "")
	EndIf
	$sProperties = "," & $sProperties & ","
	Local $aProperties[$oObject.Properties.Count + 1][2] = [[$oObject.Properties.Count, 2]], $iIndex = 1
	For $oProperty In $oObject.Properties
		If Not ($sProperties = ",," Or StringInStr($sProperties, "," & $oProperty.Name & ",") > 0) Then ContinueLoop
		$aProperties[$iIndex][0] = $oProperty.Name
		$aProperties[$iIndex][1] = $oProperty.Value
		$iIndex += 1
	Next
	ReDim $aProperties[$iIndex][2]
	$aProperties[0][0] = $iIndex - 1
	Return $aProperties

EndFunc   ;==>_AD_GetADOProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_SetADOProperties
; Description ...: Sets properties of an ADO command object.
; Syntax.........: _AD_SetADOProperties($sP1 = ""[, $sP2 = ""[, $sP3 = ""[, $sP4 = ""[, $sP5 = ""[, $sP6 = ""[, $sP7 = ""[, $sP8 = ""[, $sP9 = ""[, $sP10 = ""]]]]]]]]])
; Parameters ....: $sP1        - Property to set. This can be a string with the format propertyname=value OR
;                  +a zero based one-dimensional array with unlimited number of strings in the format propertyname=value
;                  $sP2        - Optional: Same as $sP1 but no array is allowed
;                  $sP3        - Optional: Same as $sP2
;                  $sP4        - Optional: Same as $sP2
;                  $sP5        - Optional: Same as $sP2
;                  $sP6        - Optional: Same as $sP2
;                  $sP7        - Optional: Same as $sP2
;                  $sP8        - Optional: Same as $sP2
;                  $sP9        - Optional: Same as $sP2
;                  $sP10       - Optional: Same as $sP2
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - Invalid format of the parameter. Has to be propertyname=value. @extended = number of the invalid parameter (zero based)
;                  |x - Error setting the specified property. @extended = number of the invalid parameter (zero based)
; Author ........: water
; Modified.......:
; Remarks .......: You can query the properties of the ADO connection and command object but you can only set the properties of the command object.
;                  +After the connection is opened by _AD_Open the properties of the connection object are read only.
; Related .......:
; Link ..........: ADO Command: http://msdn.microsoft.com/en-us/library/ms675022(v=VS.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _AD_SetADOProperties($sP1 = "", $sP2 = "", $sP3 = "", $sP4 = "", $sP5 = "", $sP6 = "", $sP7 = "", $sP8 = "", $sP9 = "", $sP10 = "")

	Local $aProperties[10]
	; Move properties into an array
	If Not IsArray($sP1) Then
		$aProperties[0] = $sP1
		$aProperties[1] = $sP2
		$aProperties[2] = $sP3
		$aProperties[3] = $sP4
		$aProperties[4] = $sP5
		$aProperties[5] = $sP6
		$aProperties[6] = $sP7
		$aProperties[7] = $sP8
		$aProperties[8] = $sP9
		$aProperties[9] = $sP10
	Else
		$aProperties = $sP1
	EndIf
	; set properties
	For $iIndex = 0 To UBound($aProperties) - 1
		If $aProperties[$iIndex] = "" Then ContinueLoop
		Local $aTemp = StringSplit($aProperties[$iIndex], "=")
		If @error = 1 Then Return SetError(1, $iIndex, 0)
		$aTemp[1] = StringStripWS($aTemp[1], 7)
		$__oAD_Command.Properties($aTemp[1]) = $aTemp[2]
		If @error Then Return SetError(@error, $iIndex, 0)
	Next
	Return 1

EndFunc   ;==>_AD_SetADOProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _AD_VersionInfo
; Description ...: Returns an array of information about the AD.au3 UDF.
; Syntax.........: _AD_VersionInfo()
; Parameters ....: None
; Return values .: Success - one-dimensional one based array with the following information:
;                  |1 - Release Type (T=Test or V=Production)
;                  |2 - Major Version
;                  |3 - Minor Version
;                  |4 - Sub Version
;                  |5 - Release Date (YYYYMMDD)
;                  |6 - AutoIt version required
;                  |7 - List of authors separated by ","
;                  |8 - List of contributors separated by ","
; Author ........: water
; Modified.......:
; Remarks .......: Based on function _IE_VersionInfo written bei Dale Hohm
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _AD_VersionInfo()

	Local $aOL_VersionInfo[9] = [8, "V", 1, 4, 1.1, "20140611", "3.3.12.0", "Jonathan Clelland, water", _
			"feeks, KenE, Sundance, supersonic, Talder, Joe2010, Suba, Ethan Turk, Jerold Schulman, Stephane, card0384"]
	Return $aOL_VersionInfo

EndFunc   ;==>_AD_VersionInfo

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __AD_Int8ToSec
; Description ...: Function to convert Integer8 attributes from 64-bit numbers to seconds.
; Syntax.........: __AD_Int8ToSec($iLow, $iHigh)
; Parameters ....: $iLow - Lower Part of the Large Integer
;                  $iHigh - Higher Part of the Large Integer
; Return values .: Integer (Double Word) value
; Author ........: Jerold Schulman
; Modified.......: water
; Remarks .......: This function is used internally
;                  Many attributes in Active Directory have a data type (syntax) called Integer8.
;                  These 64-bit numbers (8 bytes) often represent time in 100-nanosecond intervals. If the Integer8 attribute is a date,
;                  the value represents the number of 100-nanosecond intervals since 12:00 AM January 1, 1601.
; Related .......:
; Link ..........: http://www.rlmueller.net/Integer8Attributes.htm, http://msdn.microsoft.com/en-us/library/cc208659.aspx
; Example .......:
; ===============================================================================================================================
Func __AD_Int8ToSec($oInt8)

	Local $lngHigh, $lngLow
	$lngHigh = $oInt8.HighPart
	$lngLow = $oInt8.LowPart
	If $lngLow < 0 Then
		$lngHigh = $lngHigh + 1
	EndIf
	Return -($lngHigh * (2 ^ 32) + $lngLow) / (10000000)

EndFunc   ;==>__AD_Int8ToSec

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __AD_LargeInt2Double
; Description ...: Converts a large Integer value to an Integer (Double Word) value.
; Syntax.........: __AD_LargeInt2Double($iLow, $iHigh)
; Parameters ....: $iLow - Lower Part of the Large Integer
;                  $iHigh - Higher Part of the Large Integer
; Return values .: Integer (Double Word) value
; Author ........: Sundance
; Modified.......: water
; Remarks .......: This function is used internally
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/index.php?showtopic=49627&view=findpost&p=422402
; Example .......:
; ===============================================================================================================================
Func __AD_LargeInt2Double($iLow, $iHigh)

	Local $iResultLow, $iResultHigh
	If $iLow < 0 Then
		$iResultLow = 2 ^ 32 + $iLow
	Else
		$iResultLow = $iLow
	EndIf
	If $iHigh < 0 Then
		$iResultHigh = 2 ^ 32 + $iHigh
	Else
		$iResultHigh = $iHigh
	EndIf
	Return $iResultLow + $iResultHigh * 2 ^ 32

EndFunc   ;==>__AD_LargeInt2Double

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __AD_ObjGet
; Description ...: Returns an LDAP object from a FQDN.
;                  Will use the alternative credentials $sAD_UserId/$sAD_Password if they are set.
; Syntax.........: __AD_ObjGet($sFQDN)
; Parameters ....: $sFQDN - Fully Qualified Domain name of the object for which the LDAP object will be returned.
; Return values .: LDAP object
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This function is used internally
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa772247(VS.85).aspx (ADS_AUTHENTICATION_ENUM Enumeration)
; Example .......:
; ===============================================================================================================================
Func __AD_ObjGet($sFQDN)

	If $sAD_UserId = "" Then
		Return ObjGet($sFQDN)
	Else
		Return $__oAD_OpenDS.OpenDSObject($sFQDN, $sAD_UserId, $sAD_Password, $__bAD_BindFlags)
	EndIf

EndFunc   ;==>__AD_ObjGet

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __AD_ErrorHandler
; Description ...: Internal Error event handler for COM errors.
; Syntax.........: __AD_ErrorHandler()
; Parameters ....: None
; Return values .: @error is set to the COM error by AutoIt
; Author ........: Jonathan Clelland
; Modified.......: water
; Remarks .......: This function is used internally
;                  0x80005xxx - ADSI error codes
;                  0x80007xxx - LDAP error codes for ADSI
;
;                  ADSI Error Codes:
;                  Code        Symbol                        Description
;                  -----------------------------------------------------
;                  0x80005000  E_ADS_BAD_PATHNAME            An invalid ADSI path name was passed
;                  0x80005001  E_ADS_INVALID_DOMAIN_OBJECT   An unknown ADSI domain object was requested
;                  0x80005002  E_ADS_INVALID_USER_OBJECT     An unknown ADSI user object was requested
;                  0x80005003  E_ADS_INVALID_COMPUTER_OBJECT An unknown ADSI computer object was requested
;                  0x80005004  E_ADS_UNKNOWN_OBJECT          An unknown ADSI object was requested
;                  0x80005005  E_ADS_PROPERTY_NOT_SET        The specified ADSI property was not set
;                  0x80005006  E_ADS_PROPERTY_NOT_SUPPORTED  The specified ADSI property is not supported
;                  0x80005007  E_ADS_PROPERTY_INVALID        The specified ADSI property is invalid
;                  0x80005008  E_ADS_BAD_PARAMETER           One or more input parameters are invalid
;                  0x80005009  E_ADS_OBJECT_UNBOUND          The specified ADSI object is not bound to a remote resource
;                  0x8000500A  E_ADS_PROPERTY_NOT_MODIFIED   The specified ADSI object has not been modified
;                  0x8000500B  E_ADS_PROPERTY_MODIFIED       The specified ADSI object has been modified
;                  0x8000500C  E_ADS_CANT_CONVERT_DATATYPE   The ADSI data type cannot be converted to/from a native DS data type
;                  0x8000500D  E_ADS_PROPERTY_NOT_FOUND      The ADSI property cannot be found in the cache
;                  0x8000500E  E_ADS_OBJECT_EXISTS           The ADSI object exists
;                  0x8000500F  E_ADS_SCHEMA_VIOLATION        The attempted action violates the directory service schema rules
;                  0x80005010  E_ADS_COLUMN_NOT_SET          The specified column in the ADSI was not set
;                  0x00005011  S_ADS_ERRORSOCCURRED          One or more errors occurred
;                  0x00005012  S_ADS_NOMORE_ROWS             The search operation has reached the last row
;                  0x00005013  S_ADS_NOMORE_COLUMNS          The search operation has reached the last column for the current row
;                  0x80005014  E_ADS_INVALID_FILTER          The specified search filter is invalid
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa772195(VS.85).aspx (Active Directory Services Interface Error Codes)
;                  http://msdn.microsoft.com/en-us/library/cc704587(PROT.10).aspx (HRESULT Values)
; Example .......:
; ===============================================================================================================================
Func __AD_ErrorHandler()

	Local $bHexNumber = Hex($__oAD_MyError.number, 8)
	Local $aVersionInfo = _AD_VersionInfo()
	Local $sError = "COM Error Encountered in " & @ScriptName & @CRLF & _
			"AD UDF version = " & $aVersionInfo[2] & "." & $aVersionInfo[3] & "." & $aVersionInfo[4] & @CRLF & _
			"@AutoItVersion = " & @AutoItVersion & @CRLF & _
			"@AutoItX64 = " & @AutoItX64 & @CRLF & _
			"@Compiled = " & @Compiled & @CRLF & _
			"@OSArch = " & @OSArch & @CRLF & _
			"@OSVersion = " & @OSVersion & @CRLF & _
			"Scriptline = " & $__oAD_MyError.scriptline & @CRLF & _
			"NumberHex = " & $bHexNumber & @CRLF & _
			"Number = " & $__oAD_MyError.number & @CRLF & _
			"WinDescription = " & StringStripWS($__oAD_MyError.WinDescription, 2) & @CRLF & _
			"Description = " & StringStripWS($__oAD_MyError.description, 2) & @CRLF & _
			"Source = " & $__oAD_MyError.Source & @CRLF & _
			"HelpFile = " & $__oAD_MyError.HelpFile & @CRLF & _
			"HelpContext = " & $__oAD_MyError.HelpContext & @CRLF & _
			"LastDllError = " & $__oAD_MyError.LastDllError
	If $__iAD_Debug > 0 Then
		If $__iAD_Debug = 1 Then ConsoleWrite($sError & @CRLF & "========================================================" & @CRLF)
		If $__iAD_Debug = 2 Then MsgBox(64, "Active Directory Functions - Debug Info", $sError)
		If $__iAD_Debug = 3 Then FileWrite($__sAD_DebugFile, @YEAR & "." & @MON & "." & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @CRLF & _
				"-------------------" & @CRLF & $sError & @CRLF & "========================================================" & @CRLF)
	EndIf

EndFunc   ;==>__AD_ErrorHandler

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __AD_ReorderACE
; Description ...: Reorders the ACEs in a DACL to meet MS recommandations.
; Syntax.........: __AD_ReorderACE($oDACL)
; Parameters ....: $oDACL - Discretionary Access Control List
; Return values .: A reordered DACL according to MS recommandation
; Author ........: water (based on VB code by Richard L. Mueller)
; Modified.......:
; Remarks .......: This function is used internally
;+
;                  The Active Directory Service Interfaces (ADSI) property cache on Microsoft Windows Server 2003 and on Microsoft Windows XP
;                  will correctly order the DACL before writing it back to the object. Reordering is only required on Microsoft Windows 2000.
;                  The proper order of ACEs in an ACL is as follows:
;                    Access-denied ACEs that apply to the object itself
;                    Access-denied ACEs that apply to a child of the object, such as a property set or property
;                    Access-allowed ACEs that apply to the object itself
;                    Access-allowed ACEs that apply to a child of the object, such as a property set or property
;                    All inherited ACEs
; Related .......:
; Link ..........: http://support.microsoft.com/kb/269159/en-us
; Example .......:
; ===============================================================================================================================
Func __AD_ReorderACE($oDACL)

	; Reorder ACE's in DACL
	Local $oNewDACL, $oInheritedDACL, $oAllowDACL, $oDenyDACL, $oAllowObjectDACL, $oDenyObjectDACL, $oACE

	$oNewDACL = ObjCreate("AccessControlList")
	$oInheritedDACL = ObjCreate("AccessControlList")
	$oAllowDACL = ObjCreate("AccessControlList")
	$oDenyDACL = ObjCreate("AccessControlList")
	$oAllowObjectDACL = ObjCreate("AccessControlList")
	$oDenyObjectDACL = ObjCreate("AccessControlList")

	For $oACE In $oDACL
		If ($oACE.AceFlags And $ADS_ACEFLAG_INHERITED_ACE) = $ADS_ACEFLAG_INHERITED_ACE Then
			$oInheritedDACL.AddAce($oACE)
		Else
			Switch $oACE.AceType
				Case $ADS_ACETYPE_ACCESS_ALLOWED
					$oAllowDACL.AddAce($oACE)
				Case $ADS_ACETYPE_ACCESS_DENIED
					$oDenyDACL.AddAce($oACE)
				Case $ADS_ACETYPE_ACCESS_ALLOWED_OBJECT
					$oAllowObjectDACL.AddAce($oACE)
				Case $ADS_ACETYPE_ACCESS_DENIED_OBJECT
					$oDenyObjectDACL.AddAce($oACE)
				Case Else
			EndSwitch
		EndIf
	Next
	For $oACE In $oDenyDACL
		$oNewDACL.AddAce($oACE)
	Next
	For $oACE In $oDenyObjectDACL
		$oNewDACL.AddAce($oACE)
	Next
	For $oACE In $oAllowDACL
		$oNewDACL.AddAce($oACE)
	Next
	For $oACE In $oAllowObjectDACL
		$oNewDACL.AddAce($oACE)
	Next
	For $oACE In $oInheritedDACL
		$oNewDACL.AddAce($oACE)
	Next
	$oNewDACL.ACLRevision = $oDACL.ACLRevision
	Return $oNewDACL

EndFunc   ;==>__AD_ReorderACE
