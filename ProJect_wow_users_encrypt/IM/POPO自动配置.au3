#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\POPO�Զ�����.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

#include <Crypt.au3>
#include <Excel.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>


If _Singleton("POPO�Զ�����", 1) = 0 Then
    MsgBox(0, "����","�����Ѿ�����")
    Exit
EndIf


MsgBox(0,"","������Զ���д��������������¼ʧ�ܣ�����ϵIT")
;~ Global $account2=False
loginPOPO()

Func loginPOPO()

	$POPO = "C:\Program Files (x86)\corpname\POPO\Start.exe"
	If Not FileExists($POPO) Then
		$POPO = "C:\Program Files\corpname\POPO\Start.exe"
	EndIf
	FileCreateShortcut($POPO, @DesktopDir & "\����POPO.lnk")
	ShellExecute($POPO,"")

	$Title = "����POPO"
	WinWaitActive($Title,"")

	Local $info[2] 
	$info = getCorpPSW()
	$mypopoAccount= $info[0] & "@corp.corpname.com"
	$mypopoPassword= $info[1]

	ControlSetText($Title,"","Edit2",$mypopoAccount) ;��д�ʺ�
	ControlSetText($Title,"","Edit1",$mypopoPassword) ;��д����

	$Pos=WinGetPos($Title,"") ;���POPO��������ܵ���ʼ����
	$x=$pos[0]
	$y=$pos[1]

	MouseMove($x+78,$y+280)
	MouseClick("left",$x+78,$y+280)  ;���һ������� ����Ϊ����д����ʱ��������ģ��������ɡ���������
	MouseClick("left",$x+78,$y+302)  ;��������ѡ��
	MouseClick("left",$x+145,$y+430)  ;�������¼��
	
	WO_rec("POPO�Զ�����")
	WinWait($Title,"��������",30)
	WinActive($Title,"��������")
;~ 	MouseClick("left",$x+210,$y+15)  ;�������С����

EndFunc

Func getCorpPSW()
			
	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False,"Password@2")
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName) 
	Static $arr=0
	$usr= $usr_arr[$arr][2] ;λ��	

	
	If $usr=="" Then
		MsgBox(0,"","û��corp������Ϣ,���ֶ����û���ϵIT")
		Exit
	EndIf
	
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;��������
	
	Global $corp=_Excel_RangeRead($oExcel,Default,"C"& $row,1) ;��ȡ����corp�����ַ

	$Mycorp=$corp

	If  UBound($usr_arr)==2 Then    ;�ж����飬���� ��1���˺�Ϊ1��2���˺�Ϊ2
		$usr2= $usr_arr[$arr+1][2] ;λ��	
		$row_arr=StringSplit($usr2,"B$",1)
		$row2=$row_arr[2]  ;��������
		
		Global $corp2=_Excel_RangeRead($oExcel,Default,"C"& $row2,1)
		
;~ 		MsgBox(0,"",$corp2)
;~ 		Exit

		$Mycorp=""
		chooseCorp($Mycorp)
		If $Mycorp==$corp2 Then 
			$row=$row2
		EndIf
		

	EndIf
	


	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)  ;��ȡ�����ֶ�

	If $psw=="" Then 
		MsgBox(0,"","û������������Ϣ����������д����ϵIT") 
	EndIf

	
	$psw= My_Decrypt($psw)   ;����

	_Excel_BookClose($oExcel,1)
	_Excel_Close($oAppl)
	
	Local $myReturn[2]
	Local $myReturn[]= [$Mycorp,$psw]

	
	Return $myReturn
	
EndFunc


Func chooseCorp(ByRef $choose)
	Local $String_chooses= $corp  &"|" & $corp2 
	Local $String_Available=$corp 
	
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1)
	#region ### START Koda GUI section ### Form=
	$FORM1 = GUICreate("corp�˺��Զ���¼��վ", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("��ѡ��Ҫ��¼�ĵ�ַ", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")
	;$USERNAMEEDIT = GUICtrlCreateInput(@UserName, 16, 32, 97, 21)
	;$LABEL2 = GUICtrlCreateLabel("@", 120, 32, 20, 24)$webaddress
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Mychoose = GUICtrlCreateCombo("", 74, 35, 137, 40, 3)
	GUICtrlSetData(-1, $String_chooses, $String_Available)
    $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 32, 72, 73, 25)
	$CANCELBUTTON = GUICtrlCreateButton("Cancel", 168, 72, 73, 25)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	While 1
		$NMSG = GUIGetMsg()
		Select
			Case $NMSG = $CONFIRMBUTTON
				;$USERDISPLAYNAME = GUICtrlRead($USERNAMEEDIT)
				$choose = GUICtrlRead($Mychoose)
				GUIDelete()
				Return  $choose 
		
			Case $NMSG = $CANCELBUTTON Or $NMSG = $GUI_EVENT_CLOSE
				GUIDelete()
				Exit
		EndSelect
	WEnd
	GUIDelete()
EndFunc



Func My_Decrypt($normalString)
	;$normalString = InputBox("������","�Դ�������Ҫ�����ܵ��ַ���")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;���ܺ�����
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; �������ڽ���/�������ݵ������ַ���
	
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
	$res=FileWriteLine($rec_file,$rec)
EndFunc