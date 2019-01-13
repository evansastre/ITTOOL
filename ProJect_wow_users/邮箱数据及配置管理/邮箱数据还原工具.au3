#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\邮箱数据还原工具.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <Process.au3>
#include <Math.au3>
Global $i = 0    ;进度百分比
Global $stdread=0  ;当前读取字节组
Global $mail_local_dir="E:\mail_recovery"
Global $server_area = ""

While ProcessExists("robocopy.exe") 
	ProcessClose("robocopy.exe")
WEnd

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

mails_recovery($server_area)

Func mails_recovery($server)
	
	$Tip = "tip"
	TrayTip($Tip, "邮件数据下载中，请耐心等耐", "", 1)
	$myfolder = '\\' & $server & '\mails_backup\' & @UserName
	If Not FileExists($myfolder) Then 
		MsgBox(0,"","历史备份不存在") 
		Exit
	EndIf
	

	
	
	Global $dirsize=Round(DirGetSize($myfolder)/1024/1024,1) 

	
	readstdout($myfolder)
	
	If $server == 'ITTOOL_node1' Then ;记录操作
		WO_rec("邮箱数据还原_杭州")
	Else
		WO_rec("邮箱数据还原_上海")
	EndIf
	
	TrayTip($Tip, "完成", "", 1)
	Sleep(1000)
	
	
	;规则及其他备份
	$outlook1 = @UserProfileDir & "\AppData\Local\Microsoft\Outlook"    
    $outlook2 = @UserProfileDir & "\AppData\Roaming\Microsoft\Outlook" 
	DirCopy("E:\mail_recovery" & "\AppData\Local\Microsoft\Outlook",$outlook1,1)
	DirCopy("E:\mail_recovery" & "\AppData\Roaming\Microsoft\Outlook",$outlook2,1 )
	
	;--------------------------------
	
	MsgBox(0, "", "下载完成"& @LF & "邮件数据已下载到E:\mail_recovery," & @LF &"请先行对照后，替换E:\mail内的邮件数据文件")
	
	If FileExists("E:\mail_recovery\outlook_prf.reg") Then
		$choose=MsgBox(1,"","是否导入原账号配置信息 ？" & @LF & "注：导入备份的账号配置信息会立即覆盖当前配置，请谨慎选择")
		If $choose==1 Then
			$reg_import ="reg import E:\mail_recovery\outlook_prf.reg"
			Global $command_reg_import[1] = [$reg_import]
			;runBat($command_$reg_import)
			RunAs("ITSuperAdmin","CorpDomain","Password@4",4,runBat($command_reg_import)) 
		EndIf
	EndIf
	
	$res=MsgBox(1,"","是否需要自动填写corp邮箱密码?" & @LF & "只对密码由IT托管的账号生效。")
	If $res==1 Then
		Run("\\ITTOOL_node1\ITTOOLS\Scripts\corp邮箱密码填写器.exe")
	Else
		Exit
	EndIf
	
		
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
	ProgressOn("进度条", "下载进度", "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
	AdlibRegister("showProgress", 250)
 	;$sCommand = 'robocopy "E:\mail" '& $my_folder &' /mir'
 	$sCommand = 'robocopy '&  $my_folder & ' '& $mail_local_dir &' /mir'
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


