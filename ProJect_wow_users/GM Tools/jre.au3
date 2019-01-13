#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\jre修复-呼叫中心无法签入问题beta.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <IE.au3>
#include<date.au3>

;time_out()
;~ Func time_out()
;~ 	$End_year = 2015
;~ 	$End_mon = 8
;~ 	$End_day = 30
;~ 	$End_hour = 12
;~ 	$End_min = 0
;~ 	$End_sec = 0
;~ 	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime() ;获取当前时间
;~ 	;MsgBox(0,"系统时间 .: " , _Date_Time_FileTimeToStr($tFileTime1))
;~ 	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon, $End_day, $End_year, $End_hour, $End_min, $End_sec)
;~ 	;MsgBox(0,"中止时间 .: " , _Date_Time_FileTimeToStr($tFileTime2))

;~ 	$pFileTime1 = DllStructGetPtr($tFileTime1)
;~ 	$pFileTime2 = DllStructGetPtr($tFileTime2)

;~ 	$result = _Date_Time_CompareFileTime($pFileTime1, $pFileTime2)
;~ 	;MsgBox(0,"",$result)

;~ 	If $result = 1 Then
;~ 		MsgBox(0, "警告", "程序已失效，请联系IT获取最新版本")
;~ 		Exit
;~ 	EndIf
;~ EndFunc   ;==>time_out


;~ ;关闭IE
$res=MsgBox(4,"tip","程序会关闭所有IE浏览器，是否继续？")
If $res==7 Then
	Exit
EndIf




Func ProcessCloseAll($process)
	While ProcessExists($process) 
		ProcessClose($process)
	WEnd
EndFunc
ProcessCloseAll("iexplore.exe")
ProcessCloseAll("MyPopo.exe")
;~ ProcessCloseAll("iexplore.exe")


;~ ProcessClose("explorer.exe")
Sleep(1000)

$choose = MsgBox(3, "警告", "首次运行请注销一次,重新登录后先打开本程序进行修复流程。" & @LF & @LF & "选择‘是’开始注销" & @LF & "选择‘否’。将开始修复" & @LF & "选择‘Cancel’将不做任何操作")
If $choose = "6" Then
	Shutdown(0) ;是返回6，否返回7，Cancel返回2
	Exit
ElseIf $choose = "2" Then
	Exit
EndIf


$ie_dir1 = FileGetShortName(@UserProfileDir & "\appdata\Local\Microsoft\Internet Explorer") ;对含有空格的路径，用短名是比较好的处理方法
$ie_dir2 = FileGetShortName(@UserProfileDir & "\AppData\LocalLow\Microsoft\Internet Explorer")
;~ $ie_dir3=FileGetShortName(@UserProfileDir &"\AppData\Roaming\Microsoft\Internet Explorer")
$dir_to = @UserProfileDir & "\AppData\LocalLow\Sun" ;JRE配置文件本地路径

Global $message = "" ;存储删除结果的消息

Global $dir_to_del[3] = [$ie_dir1, $ie_dir2, $dir_to]
For $i In $dir_to_del
	Del_IE($i)
Next


Func Del_IE($ie_dir)
	
;~ 	RunAsWait("wow",@ComputerName,"Password@2", 0, DirRemove($ie_dir, 1)) ;域管理员权限必须
	RunAsWait("itbat","CorpDomain","Password@4",0, DirRemove($ie_dir, 1)) ;域管理员权限必须
	
	Global $time=1
	While($time<4) 
;~ 		MsgBox(0,"","time: " & $time)
		Select
			Case Not FileExists($ie_dir)
				$message = $message & $ie_dir & " 删除成功" & @LF
				
;~ 				MsgBox(0,"","success "&$time)
				$time=4
				ContinueLoop
			Case FileExists($ie_dir) And $time<3
				Sleep(1000)
				
;~ 				MsgBox(0,"","continue "&$time)
				$time+=1
				ContinueLoop
			Case FileExists($ie_dir) And $time==3
				$message = $message & $ie_dir & " 删除失败,请注销或重启后重试" & @LF
				
;~ 				MsgBox(0,"","fail "&$time)
				$time+=1
				ContinueLoop
				
		EndSelect
		
	WEnd
	

EndFunc   ;==>Del_IE

MsgBox(0, "", $message)

netuse() ;
Func netuse()
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS '
	Global $command_netuse[1] = [$netuse]
	runBat($command_netuse)
EndFunc   ;==>netuse


$Tip = "tip"
TrayTip($Tip,"配置文件生成中，请耐心等耐","",1)

$dir_from1 = "\\ITTOOL_node1\ITTOOLS\Conf\Java修复" ;JRE配置文件路径
$dir_to1 = @UserProfileDir & "\AppData"
RunAsWait("wow", @ComputerName, "Password@2", 0, DirCopy($dir_from1, $dir_to1, 1 + 8)) ;1+8= 不存在则创建，存在则覆盖；;拷贝服务器上配置文件到本地

;~ $dir_from2 = "\\ITTOOL_node1\ITTOOLS\Conf\Java修复\Locallow" ;JRE配置文件路径
;~ $dir_to2 = @UserProfileDir & "\AppData\LocalLow"
;~ RunAsWait("wow", @ComputerName, "Password@2", 0, DirCopy($dir_from2, $dir_to2, 1 + 8)) ;1+8= 不存在则创建，存在则覆盖；;拷贝服务器上配置文件到本地



TrayTip($Tip,"完成","",1)
Sleep(1000)


If Not FileExists($dir_to) Then
	MsgBox(0, "tip", "复制新配置文件失败,请联系IT或重启后再试")
	Exit
Else
	WO_rec("JRE修复")
	
	
	MsgBox(0, "tip", "修复完成，请重新登录呼叫中心",3)
EndIf

Local $oIE = _IECreate("http://call.wow:1081/login.action",0,1,0)

;~ ;Cancel此段注释，可用于测试
;~ Local $oForm = _IEFormGetObjByName($oIE, "loginFrom") ; 获取表单名longin
;~ Local $account = _IEFormElementGetObjByName($oForm, "username")
;~ _IEFormElementSetValue($account, "H0616")
;~ Local $password = _IEFormElementGetObjByName($oForm, "password")
;~ _IEFormElementSetValue($password, "123456")
;~ Local $callnum = _IEFormElementGetObjByName($oForm, "extnum")
;~ _IEFormElementSetValue($callnum, "5666")
;~ _IEFormImageClick($oIE, "images/button-login.gif", "src")



;自动勾选JRE警告选项
WinWait("安全警告", "", 60)
WinActivate("安全警告", "")
If WinActive("安全警告", "") Then
	;MsgBox(0, "", "出现了")
	Send("!d")
	Sleep(100)
	Send("!i")
	Sleep(2000)
	Send("!r")
Else
	MsgBox(0, "", "请注销后重新登录呼叫中心")
EndIf


;_IELinkClickByText($oIE, "普通坐席")
;$login_page = _IECreate("http://call.wow:1081/agent/client/common.action")

;~ Send("^t")
;~ Sleep(200)
;~ Send("http://call.wow:1081/agent/client/common.action")
;~ Sleep(200)
;~ Send("{enter}")
;~ ;
WinWait("来自网页的消息","Confirm",10)
WinActivate("来自网页的消息","Confirm")
ControlClick("来自网页的消息","Confirm","Button1","left")

;_IELoadWait($login_page)

;点击签入
;~ Local $login_button = _IEGetObjByName($login_page, "login_button")
;~ _IEAction($login_button, "click")


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


;H0616 123456   5666

