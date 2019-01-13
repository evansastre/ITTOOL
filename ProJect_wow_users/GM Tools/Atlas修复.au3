#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Atlas修复.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <InetConstants.au3>
#include <Date.au3>

;time_out()
Func time_out()
	$End_year=2015
	$End_mon=8
	$End_day=30
	$End_hour=12
	$End_min=0
	$End_sec=0
	
	$tFileTime1 = _Date_Time_GetSystemTimeAsFileTime()  ;获取当前时间
	;MsgBox(0,"系统时间 .: " , _Date_Time_FileTimeToStr($tFileTime1))
	$tFileTime2 = _Date_Time_EncodeFileTime($End_mon,$End_day,$End_year,$End_hour,$End_min,$End_sec) 
	;MsgBox(0,"中止时间 .: " , _Date_Time_FileTimeToStr($tFileTime2))
	
	$pFileTime1 = DllStructGetPtr($tFileTime1)
	$pFileTime2 = DllStructGetPtr($tFileTime2)
	
	$result=_Date_Time_CompareFileTime($pFileTime1, $pFileTime2)
	;MsgBox(0,"",$result)
	
	If $result=1 Then
		MsgBox(0,"警告","程序已失效，请联系IT获取最新版本")
		Exit
	EndIf
EndFunc

;结束掉以下进程以确保同步时没有进程被占用
Local $list[4]= ["BN_EasyTool.exe","Atlas.exe","supportcommander.exe","BBSA.exe"]
For $item In $list
	While ProcessExists($item)
		ProcessClose($item)
	WEnd
Next
;关闭atlas和ET工具
Sleep(1000)


$appdir=@UserProfileDir & "\AppData\Local\Apps\"
If Not FileExists($appdir) Then
	MsgBox(0,"警告","目录不存在，将为您atlas安装工具")
	
	$Tip = "tip"
	TrayTip($Tip,"下载中，请耐心等耐","",1)
	Atlas_install() ;下载并安装atlas
	
	Exit
EndIf

;删除过程的气泡tip
$Tip = "tip"
TrayTip($Tip,"旧配置文件删除中，请耐心等耐","",1)

;RunAsWait("wow",@ComputerName,"Password@2",0,@ComSpec & " /c " & " rd  " & $appdir & " /q /s")
RunAsWait("wow",@ComputerName,"Password@2",0,DirRemove($appdir,1))



TrayTip($Tip,"完成","",1)
Sleep(1000)


If FileExists($appdir) Then
	MsgBox(0,"警告","删除旧配置文件失败，请重启电脑重试或联系IT")
	Exit
Else
	MsgBox(0,"tip","已删除成功")
	Atlas_install() ;下载并安装atlas
	WO_rec() ;ticket record
EndIf
	
	

Func Atlas_install()  ;下载并安装atlas
	
	; 下载的文件保存到临时文件夹.
    Local $sFilePath = @TempDir & "\setup.exe"
    ; 在后台按选定的选项下载文件, 并强制从远程站点重新加载.'
    Local $hDownload = InetGet("http://10.19.128.203:8090/Atlas/Production/CN/setup.exe", @TempDir & "\setup.exe", $INET_FORCERELOAD, $INET_DOWNLOADWAIT)
    ; 关闭 InetGet 返回的句柄.
    InetClose($hDownload)
	;运行安装atlas
	RunWait($sFilePath)
	
	
	If WinWaitActive("应用程序安装 - 安全警告","安装(&I)")  Then ;Or WinActivate("Application Install - Security Warning","&Install") Then
		Send("!i")
	EndIf
	
	;等待atlas进程出现，即等待安装完成
	ProcessWait("atlas.exe")
	MsgBox(0,"","atlas安装成功",3)
	
	$netuse="net use \\ITTOOL_node1\ITTOOLS"
	Global $command_netuse[1]=[$netuse]
	runBat($command_netuse)
	
;~ 	ShellExecuteWait("\\ITTOOL_node1\ITTOOLS\Conf\atlas\EasyTool.appref-ms")
;~ 	
;~ 	
;~ 	If WinWaitActive("应用程序安装 - 安全警告","tableLayoutPanelQuestion")  Or WinActivate("Application Install - Security Warning","tableLayoutPanelQuestion") Then
;~ 		Send("!i")
;~ 	EndIf
	;删除atlas安装包.
    FileDelete($sFilePath)
	
EndFunc   ;==>Example

Func WO_rec() ;ticket record
	
	
	
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\atlas修复.txt"'
	$cur_Time=@YEAR &'-'&@MON &'-'& @MDAY &' '& @HOUR & ':' & @MIN & ':' & @SEC 
	$rec='echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'


    Global $command_rec[3]=[$netuse,$rec_file,$rec]  

	runBat($command_rec)
	
EndFunc




Func runBat($cmd);$cmd must be array
	;MsgBox(0,"",$cmd[2])
	
	Local $sFilePath = @TempDir & "\tmp_wow.bat"
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	;Run(@ComSpec & " /c "& "explorer " &@TempDir)
	RunWait($sFilePath,"",@SW_DISABLE)
	
	
	FileDelete($sFilePath)
EndFunc








