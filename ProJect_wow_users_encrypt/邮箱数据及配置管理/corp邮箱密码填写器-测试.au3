#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\corp����������д��.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Crypt.au3>
#include <Excel.au3>


FillThePSW()
Func FillThePSW()
	While ProcessExists("outlook.exe") ;��⵱ǰ��outlook�����Ƿ����
			$BUTTONPRESSED = MsgBox(5, "���棡", "�����ֶ��ر�outlook")
			If $BUTTONPRESSED = 4 Then
				ContinueLoop
			ElseIf $BUTTONPRESSED = 2 Then
				Exit
			EndIf
	WEnd


	If Not ProcessExists("outlook.exe") Then ;��⵱ǰ��outlook�����Ƿ����
		Run(GETOUTLOOKINSTALLPATH())
		WinWaitActive("Microsoft Outlook","")   ;
		Send("{F9}")
	Else
		WinActivate("Microsoft Outlook","")
		Send("{F9}")
	EndIf

	$G_OUTLOOKVER= GETOUTLOOKVERSION()
	If $G_OUTLOOKVER == "2010" Then
		$Title="Internet �����ʼ�"
	ElseIf	$G_OUTLOOKVER =="2007" Then
		$Title="������������"
	EndIf
	$waitRes=WinWait($Title,"corp.corpname.com",30)

	If $waitRes <> 0   ==True Then
		WinActive($Title,"")
		ControlSetText($Title,"","RichEdit20WPT2",getCorpPSW()) ;��д����
		ControlClick($Title,"","Button1")
		ControlClick($Title,"","Button2")
	EndIf
	
	WO_rec("corp����������д��")

EndFunc

Func GETOUTLOOKINSTALLPATH()   ;����outlook��װ·��
	Return RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE", "path") & "outlook.exe"
EndFunc   ;==>GETOUTLOOKINSTALLPATH

Func getCorpPSW()
	
	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False,"Password@2")
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName)
	$usr= $usr_arr[0][2] ;λ��
	
	If $usr=="" Then
		MsgBox(0,"","û��corp������Ϣ,���ֶ����û���ϵIT"& @error & @LF & @extended)
		Exit
	EndIf
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;��������
	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)
	
	If $psw=="" Then 
		MsgBox(0,"","û������������Ϣ����������д����ϵIT") 
		Exit
	EndIf
	
	$psw= My_Decrypt($psw)

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	MsgBox(0,"",$psw)
	Return $psw 
	
EndFunc

Func My_Decrypt($normalString)
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;���ܺ�����
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM731bFc1q5GtBTT" ; �������ڽ���/�������ݵ������ַ���
	
    For $iWord In $aStringsToEncrypt
		$decryptData = BinaryToString( _Crypt_DecryptData(String($iWord), $sUserKey, $CALG_RC4))
        $sOutput &= $iWord & @TAB & " = " & $decryptData & @CRLF ; ʹ�ü�����Կ�����ı�.
    Next
	
	Return $decryptData
EndFunc   


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


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
