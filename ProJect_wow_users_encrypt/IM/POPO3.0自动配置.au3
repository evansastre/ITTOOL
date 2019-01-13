#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\POPO自动配置.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <Crypt.au3>
#include <Excel.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>


If _Singleton("POPO自动配置", 1) = 0 Then
    MsgBox(0, "警告","程序已经运行")
    Exit
EndIf


MsgBox(0,"","密码会自动填写，请勿操作。如登录失败，请联系IT")
;~ Global $account2=False
loginPOPO()

Func loginPOPO()

	While ProcessExists("MyPopo.exe") ;检测当前的outlook进程是否存在
			ProcessClose("MyPopo.exe")
	WEnd
	
	$POPO = "C:\Program Files (x86)\corpname\POPO\Start.exe"
	If Not FileExists($POPO) Then
		$POPO = "C:\Program Files\corpname\POPO\Start.exe"
	EndIf
	FileCreateShortcut($POPO, @DesktopDir & "\网易POPO.lnk")
	ShellExecute($POPO,"")
	
	TrayTip("tips","请稍等",5)
	$Title_old = "网易POPO"
	$Title_new = "[Class:LoginForm]"
	Global $Title
	
	Local $info[2] 
	$info = getCorpPSW()
	Global $mypopoAccount= $info[0] & "@corp.corpname.com"
	Global $mypopoPassword= $info[1]
	
	
	While 1
		If WinActivate($Title_new,"")<>0 Then
			$Title=$Title_new
;~ 			MsgBox(0,"","new")
			autoLogin_new()
			ExitLoop
		ElseIf  WinActivate($Title_old,"")<>0 Then
			$Title=$Title_old
;~ 			MsgBox(0,"","old")
			autoLogin_old()
			ExitLoop
		EndIf
		Sleep(250)
	
	WEnd


EndFunc


Func autoLogin_old()
	$Pos=WinGetPos($Title,"") ;获得POPO软件界面框架的起始坐标
	Global $x=$pos[0]
	Global $y=$pos[1]
	
	ControlSetText($Title,"","Edit2",$mypopoAccount) ;填写帐号
	ControlSetText($Title,"","Edit1",$mypopoPassword) ;填写密码

	MouseMove($x+78,$y+280)
	MouseClick("left",$x+78,$y+280)  ;点击一下密码框 ，因为在填写密码时会出现明文，点击后会变成×××××
	MouseClick("left",$x+78,$y+302)  ;保存密码选项
	
	
	MouseClick("left",$x+145,$y+430)  ;点击“登录”
	
	WO_rec("POPO自动配置")
	WinWait($Title,"搜索好友",30)
	WinActive($Title,"搜索好友")
;~ 	MouseClick("left",$x+210,$y+15)  ;点击“最小化”
EndFunc


Func autoLogin_new()
	$Pos=WinGetPos($Title,"") ;获得POPO软件界面框架的起始坐标
	Global $x=$pos[0]
	Global $y=$pos[1]
	
	MouseMove($x+78,$y+220)
	MouseClick("left",$x+78,$y+220,2)  ;双击一下用户名框 ，
	Send("^a")
	Send($mypopoAccount) ;发送用户名
	
	MouseMove($x+78,$y+270)
	MouseClick("left",$x+78,$y+270,2)
	Send("^a")
	Send($mypopoPassword) ;发送密码
;~ 	
	MouseMove($x+165,$y+390)
	MouseClick("left",$x+165,$y+390);点击拓展部分，用于勾选记住密码
;~ 	
	MouseMove($x+72,$y+425)
	MouseClick("left",$x+72,$y+425) ;勾选记住密码
	
	
	MouseMove($x+158,$y+330)
	MouseClick("left",$x+158,$y+330) ;点击登录
	
	WO_rec("POPO自动配置")
EndFunc


Func getCorpPSW()
			
	$sFilePath="\\ITTOOL_node1\ITTOOLS\Conf\corp.xlsx"
	Local $oAppl = _Excel_Open(False)
	$oExcel=_Excel_BookOpen($oAppl,$sFilePath,True,False,"Password@2")
	
	$usr_arr=_Excel_RangeFind($oExcel,@UserName) 
	Static $arr=0
	$usr= $usr_arr[$arr][2] ;位置	

	
	If $usr=="" Then
		MsgBox(0,"","没有corp邮箱信息,请手动配置或联系IT")
		Exit
	EndIf
	
	$row_arr=StringSplit($usr,"B$",1)
	$row=$row_arr[2]  ;所在行数
	
	Global $corp=_Excel_RangeRead($oExcel,Default,"C"& $row,1) ;读取表中corp邮箱地址

	$Mycorp=$corp

	If  UBound($usr_arr)==2 Then    ;判断数组，行数 。1个账号为1，2个账号为2
		$usr2= $usr_arr[$arr+1][2] ;位置	
		$row_arr=StringSplit($usr2,"B$",1)
		$row2=$row_arr[2]  ;所在行数
		
		Global $corp2=_Excel_RangeRead($oExcel,Default,"C"& $row2,1)
		
;~ 		MsgBox(0,"",$corp2)
;~ 		Exit

		$Mycorp=""
		chooseCorp($Mycorp)
		If $Mycorp==$corp2 Then 
			$row=$row2
		EndIf
		

	EndIf
	


	$psw=_Excel_RangeRead($oExcel,Default,"E"& $row,1)  ;读取密码字段

	If $psw=="" Then 
		MsgBox(0,"","没有您的密码信息，请自行填写或联系IT") 
	EndIf

	
	$psw= My_Decrypt($psw)   ;解码

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
	$FORM1 = GUICreate("corp账号自动登录网站", 303, 110, 385, 240)
	GUISetIcon(@TempDir & "\corpname.ico")
	$LABEL1 = GUICtrlCreateLabel("请选择要登录的地址", 8, 8, 500, 23)
	
	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")
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
	;$normalString = InputBox("解密器","自此输入需要被解密的字符串")
    Local $aStringsToEncrypt[1] = [$normalString]
	Local $sOutput = ""
	Local $decryptData = "" ;解密后明文
	#cs
	[Key]
	#ce
	Local Const $sUserKey = "zM861bFc1q5GtBLf" ; 声明用于解密/加密数据的密码字符串
	
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
	$res=FileWriteLine($rec_file,$rec)
EndFunc