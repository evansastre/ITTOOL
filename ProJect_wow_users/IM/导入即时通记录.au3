#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\即时通\导入即时通记录.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <File.au3>
#include <Math.au3>

While ProcessExists("eim-intra.exe") 
	ProcessClose("eim-intra.exe");关闭即时通
WEnd



Global $location
judgeLocation()
Func judgeLocation()
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
	EndIf
EndFunc

Global $cw_server
If $location=="HZ" Then 
	$cw_server="hzcw01"
ElseIf  $location=="SH" Then 
	$cw_server="shcw01"
EndIf

$Install_EIM='robocopy  "\\'& $cw_server& '\corpname EIM"   "C:\Program Files (x86)\corpname\corpname EIM"    /mir'

;~ MsgBox(0,"",$Install_EIM)
;~ ClipPut($Install_EIM)

Local Const $sFilePath = @TempDir & "\user_data.conf"  ;在临时目录建立conf文件
Local Const $confPath= @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\" ;conf文件所在路径
Local $source = @DesktopDir& "\"&@UserName & "@battlenet.im" 

If Not FileExists($source) Then   
	$res=MsgBox(1,"","您的桌面未放置之前导出的即时通记录，"& @LF &"继续执行将以空记录替换当前聊天记录，是否继续？")
	If $res==2 Then
		MsgBox(0,"","您中止了执行")
		Exit
	EndIf
EndIf


If FileExists($confPath) Then
	RunAsWait("wow",@ComputerName,"Password@2",1,DirRemove($confPath,1))
EndIf
;不存在配置文件的时候拷贝，否则不做此操作    ×存在时无法覆盖×

$netuse1='net use \\'& $cw_server &'\Popoem-Intra'
$mkdir='mkdir ' & $confPath 
$xcopy='robocopy \\' & $cw_server & '\Popoem-Intra ' & $confPath &  ' /mir '
Global $command_copy[4]=[$netuse1,$Install_EIM,$mkdir,$xcopy]  
runBat($command_copy) ;拷贝服务器上的配置文件到本地
;DirCopy("\\192.168.109.200\Popoem-Intra",$confPath,1) ;拷贝配置文件


FileWrite($sFilePath,"user_data_path = "& $confPath);配置文件中的用户文件夹指向配置
FileCopy($sFilePath,$confPath,1+8);替换现有conf文件
FileDelete($sFilePath);删除在临时目录建立的conf文件



If FileExists($source) Then
	$des= $confPath &"\users\" &@UserName & "@battlenet.im"
	DirCopy($source,$des,1) ;拷贝用户记录到定义位置  
EndIf

If FileExists(@DesktopDir&"\网易即时通.lnk") Then
	FileDelete(@DesktopDir&"\网易即时通*") ; *为通配符，删除其他的快捷方式
EndIf


$path="C:\Program Files (x86)\corpname\corpname EIM\Start.exe"
If Not FileExists($path) Then 
	$path="C:\Program Files\corpname\corpname EIM\Start.exe"
EndIf

FileCreateShortcut($path,@DesktopDir &"\网易即时通")

Run($path)

$Title= "网易即时通"
WinWaitActive($Title,"")
ControlSetText($Title,"","Edit2",@UserName&"@battlenet.im")
ControlClick($Title,"","Edit1","left")




WO_rec()
Func WO_rec() ;ticket record
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\即时通聊天记录转移.txt"'
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

