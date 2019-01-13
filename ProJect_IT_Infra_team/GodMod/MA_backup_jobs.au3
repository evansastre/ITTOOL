#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\godmod\MA_backup_jobs.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include<Array.au3>
#include <Process.au3>

If  @LogonDomain<>"CorpDomain" Then
	MsgBox(0,'',"The machine is not in the domain, please run it on the computer in the domain.")
	Exit
EndIf


;ISA rules
;~ TrayTip("","Starting backup ISA",5)
$today=@YEAR&"-"&@MON&"-"&@MDAY
$nowtime=@HOUR&":"&@MIN&":"&@SEC
$logfile="\\dc1\C$\users\ITSuperAdmin\desktop\MA_backup_jobs_record.log"

;~ Local $msg_arr[0]
#CS
$dir01="\\webproxy01\E$\ISARuleBackup\"&$today
$size01=DirGetSize($dir01)
If (Not FileExists($dir01)) Or $size01==0 Then

	_ArrayAdd($msg_arr,"webproxy01")
EndIf

$dir02="\\webproxy02\E$\ISARuleBackup\"&$today
$size02=DirGetSize($dir02)
If (Not FileExists($dir02)) Or $size02==0 Then
	_ArrayAdd($msg_arr,"webproxy02")

EndIf

$dir03="\\webproxy03\D$\ISARuleBackup\"&$today
$size03=DirGetSize($dir03)
If (Not FileExists($dir03)) Or $size03==0 Then
	_ArrayAdd($msg_arr,"webproxy03")
EndIf

If  UBound($msg_arr,1)>0 Then
	$msg_string=""
	For $item In $msg_arr 
		$msg_string&=$item&" "
	Next
	MsgBox(0,"",$msg_string & @LF & "Backup fail,please enter the corresponding server to export the current day strategy and then run the program.")
	Exit
EndIf




RunWait(@ComSpec & " /c "& "robocopy \\webproxy01\E$\ISARuleBackup\"&$today&"  \\ITTOOL_node1\IT_Share\MA_backup_jobs_folder\ISARuleBackup\webproxy01\"&$today&"  /E")
RunWait(@ComSpec & " /c "& "robocopy \\webproxy01\E$\ISARuleBackup\"&$today&"   \\ITTOOL_node2\IT_Share\MA_backup_jobs_folder\ISARuleBackup\webproxy01\"&$today&"   /E")
FileWriteLine($logfile,"webproxy01BackupSuccess "& $today & " "& $nowtime)
RunWait(@ComSpec & " /c "& "robocopy \\webproxy02\E$\ISARuleBackup\"&$today&"     \\ITTOOL_node1\IT_Share\MA_backup_jobs_folder\ISARuleBackup\webproxy02\"&$today&"    /E")
RunWait(@ComSpec & " /c "& "robocopy \\webproxy02\E$\ISARuleBackup\"&$today&"     \\ITTOOL_node2\IT_Share\MA_backup_jobs_folder\ISARuleBackup\webproxy02\"&$today&"    /E")
FileWriteLine($logfile,"webproxy02BackupSuccess "& $today & " "& $nowtime)
RunWait(@ComSpec & " /c "& "robocopy \\webproxy03\D$\ISARuleBackup\"&$today&"     \\ITTOOL_node1\IT_Share\MA_backup_jobs_folder\ISARuleBackup\webproxy03\"&$today&"    /E")
RunWait(@ComSpec & " /c "& "robocopy \\webproxy03\D$\ISARuleBackup\"&$today&"     \\ITTOOL_node2\IT_Share\MA_backup_jobs_folder\ISARuleBackup\webproxy03\"&$today&"    /E")
FileWriteLine($logfile,"webproxy03BackupSuccess "& $today & " "& $nowtime)
#CE

;_____________________________________________________________________


;AD policy
TrayTip("","Starting backup AD policy",5)
RunWait(@ComSpec & " /c " & "robocopy \\CorpDomain.internal\SysVol\CorpDomain.internal \\ITTOOL_node1\IT_Share\MA_backup_jobs_folder\ADRuleBackup\%date:~0,4%%date:~5,2%%date:~8,2%  /E")
RunWait(@ComSpec & " /c " & "robocopy \\CorpDomain.internal\SysVol\CorpDomain.internal \\ITTOOL_node2\IT_Share\MA_backup_jobs_folder\ADRuleBackup\%date:~0,4%%date:~5,2%%date:~8,2%  /E")
FileWriteLine($logfile,"ADRuleBackupSuccess "& $today & " "& $nowtime)
;_____________________________________________________________________

;Huawei Switch
TrayTip("","Starting backup Huawei Switch config file",5)
RunWait(@ComSpec & " /c "& "start /wait \\ITTOOL_node1\ittools\Scripts\godmod\backup_onekey_telnet.exe")
RunWait(@ComSpec & " /c "& "robocopy \\ITTOOL_node2\IT_Share\Huawei_Switch_Conf  \\ITTOOL_node2\IT_Share\MA_backup_jobs_folder\Huawei_Switch_Conf\%date:~0,4%%date:~5,2%%date:~8,2% /E")
RunWait(@ComSpec & " /c "& "robocopy \\ITTOOL_node2\IT_Share\Huawei_Switch_Conf  \\ITTOOL_node1\IT_Share\MA_backup_jobs_folder\Huawei_Switch_Conf\%date:~0,4%%date:~5,2%%date:~8,2% /E")
FileWriteLine($logfile,"Huawei SwitchBackupSuccess "& $today & " "& $nowtime)
FileWriteLine($logfile,"___________________________________________________________________")
;_____________________________________________________________________



Run(@ComSpec & " /c "& "explorer \\ITTOOL_node1\IT_Share\MA_backup_jobs_folder")
Run(@ComSpec & " /c "& "explorer \\ITTOOL_node2\IT_Share\MA_backup_jobs_folder")
MsgBox(0,"","Backup donn")

