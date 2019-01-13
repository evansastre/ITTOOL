#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\PS_CS5.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <Math.au3>

Install()

Func Install()
	
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")

	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$dir="\\ITTOOL_node2\ITTOOLS\SoftwareDeploy\Adobe Photoshop CS5 Extended 12.0.3.0"
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$dir="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\Adobe Photoshop CS5 Extended 12.0.3.0"
	EndIf
	
	
;~ 	If @OSArch<>"X64" Then ;-------------------------------------------------------------------
;~ 		MsgBox(0,"","暂时只支持64位")
;~ 		Exit
;~ 	EndIf
	
	$PS="@快速安装.exe"
	;$software = $dir & "\" & $PS
	Global $PSsize=Round(DirGetSize($dir)/1024/1024,2)  ;MB
		
	ProgressOn("正在下载",  "Adobe Photoshop CS5 Extended 12.0.3.0" , "0 %", -1, -1, 16) ;-1代表中间坐标，16为可拖动
	AdlibRegister("showProgress", 250)
	ShellExecuteWait("robocopy",'"' & $dir & '"  ' & '"' &  'E:\Adobe Photoshop CS5 Extended 12.0.3.0' & '"  ' & '/E' , "", "",@SW_HIDE)
	AdlibUnRegister("showProgress")
	ProgressSet(100, "完成", "进度状态:")
	ProgressOff()
	
	TrayTip("tip","下载完成，正在安装",30)
	$install='"E:\Adobe Photoshop CS5 Extended 12.0.3.0\' & $PS & '"  i'

	Global $command_install[1] = [$install]
	runBat($command_install)
	
	
	$timeout=0
	$link="C:\Users\Public\Desktop\Adobe Photoshop CS5.lnk" ;此ps的快捷方式放在公共桌面
	While (Not FileExists($link) And $timeout <20 )
		Sleep(1000)
		$timeout = $timeout +1
	WEnd
	If Not FileExists($link) Then   
		MsgBox(0,"","安装失败")
		Exit
	EndIf
	
	TrayTip("tip","安装完成",2)
	MsgBox(0,"","安装已完成。请使用桌面快捷方式打开")
	ShellExecute($link)
	
	WO_rec("部署photoshop")

EndFunc





Func showProgress()
	
	If Not ProcessExists("robocopy.exe") Then Return

	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
	$i = Round($stdread/$PSsize,3)*100
	If ProcessExists("robocopy.exe") And $i>=99.999 then
		ProgressSet($i, " 即将完成，请勿关闭")
	Else
		ProgressSet($i, $stdread & "MB/" & $PSsize & "MB")
	EndIf

EndFunc   ;==>showProgress

Func runBat($cmd);$cmd must be array
	
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

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc