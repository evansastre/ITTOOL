#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\邮箱数据备份工具.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <Process.au3>
#include <Math.au3>

main()

Func main()
	Global $i = 0    ;进度百分比
	Global $stdread=0  ;当前读取字节组
	Global $dirsize=Round(DirGetSize("E:\mail")/1024/1024,1) 
	Global $mail_local_dir="E:\mail"
	While ProcessExists("robocopy.exe") 
		ProcessClose("robocopy.exe")
	WEnd
	
	While ProcessExists("outlook.exe") 
		$respon= MsgBox(1,"","请关闭outlook后开始备份")
		If $respon == 2 Then
			Exit
		EndIf
	WEnd
	
	MsgBox(0,"","备份过程中请勿开启outlook，开启会导致备份错误")

	Global $server_area = ""

	;~ $area = StringSplit(@IPAddress1, ".")[3]
	;~ Local $HZ[5] = ["108", "109", "112", "116", "117"]
	;~ Local $SH[10] = ["98", "99", "100", "101", "102", "103", "104", "105", "106", "107"]
	;~ For $i In $HZ
	;~ 	If $i == $area Then
	;~ 		$server_area = "ITTOOL_node1"
	;~ 	EndIf
	;~ Next
	;~ For $i In $SH
	;~ 	If $i == $area Then
	;~ 		$server_area = "ITTOOL_node2"
	;~ 	EndIf
	;~ Next

	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")

	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")
	;$dc5=Ping("dc5")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$server_area = "ITTOOL_node2"
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$server_area = "ITTOOL_node1"
	EndIf


	mails_backup($server_area)

EndFunc

Func mails_backup($server)
	
	$Tip = "tip"
	TrayTip($Tip, "邮件数据备份中，请耐心等耐", "", 1)
	$myfolder = '\\' & $server & '\mails_backup\' & @UserName
	
	;--------------------------------
	;规则及其他备份
	$outlook1 = @UserProfileDir & "\AppData\Local\Microsoft\Outlook"    
    $outlook2 = @UserProfileDir & "\AppData\Roaming\Microsoft\Outlook" 
	DirCopy($outlook1,"E:\mail" & "\AppData\Local\Microsoft\Outlook",1)
	DirCopy($outlook2,"E:\mail" & "\AppData\Roaming\Microsoft\Outlook",1 )
	;--------------------------------
	
	;-------------------------------------
	;导出outlook用户配置文件（注册表形式）
	$reg_export = 'reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"  E:\mail\outlook_prf.reg /y'
	Global $command_reg_export[1] = [$reg_export]
	runBat($command_reg_export)
	;-----------------------------------

	
	readstdout($myfolder)
	
	If $server == 'ITTOOL_node1' Then ;记录操作
		WO_rec("邮箱数据备份_杭州")
	Else
		WO_rec("邮箱数据备份_上海")
	EndIf
		TrayTip($Tip, "完成", "", 1)
	Sleep(1000)
	MsgBox(0, "", "备份完成")
EndFunc   ;==>mails_backup


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


Func readstdout($my_folder)
	
	
	ProgressOn("进度条", "备份进度", "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
	AdlibRegister("showProgress", 250)
 	;$sCommand = 'robocopy "E:\mail" '& $my_folder &' /mir'
 	$sCommand = 'robocopy '& $mail_local_dir & ' '& $my_folder &' /mir'
 	RunWait ( $sCommand,@SystemDir,@SW_HIDE )
;~  	RunWait ( "v.bat","",@SW_HIDE )

	AdlibUnRegister("showProgress")
 	ProgressSet(100, "100 %")
 	Sleep(3000) ;进度条完成后的停留时间
	ProgressOff() ;关闭进度条	
	
EndFunc


Func showProgress()
	

	
	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
	
	If Not ProcessExists("robocopy.exe") Then
		$i=100
		AdlibUnRegister("showProgress")
	EndIf
	
	$i = Round($stdread/$dirsize,2)*100

	If ProcessExists("robocopy.exe") And $i>=99 then
		ProgressSet($i, " 99%")
	Else
		ProgressSet($i, $i & " %")
	EndIf

EndFunc   ;==>showProgress

