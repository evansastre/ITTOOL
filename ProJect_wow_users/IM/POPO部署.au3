#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Y:\POPO部署.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <InetConstants.au3>
#include <Misc.au3>

If _Singleton("POPO部署", 1) = 0 Then
	MsgBox(0, "", "POPO部署进程已经运行");Prevent repeated opening of the program
	Exit
EndIf


;结束掉以下进程以确保同步时没有进程被占用
Local $list[1]= ["MyPopo.exe"]
For $item In $list
	While ProcessExists($item)
		ProcessClose($item)
	WEnd
Next

TrayTip("tip","正在下载安装包,请稍等",10)

;关闭atlas和ET工具
Sleep(1000)

PoPo_install()
WO_rec()

Func PoPo_install()  ;下载并安装atlas
	
	; 下载的文件保存到临时文件夹.
    Local $sFilePath = @TempDir & "\POPO-setup.exe"
    ; 在后台按选定的选项下载文件, 并强制从远程站点重新加载.'
    Local $hDownload = InetGet("http://popo.corpname.com/file/popowin/POPO-setup_3_0_2.exe", @TempDir & "\POPO-setup.exe", $INET_FORCERELOAD, $INET_DOWNLOADWAIT)
    ; 关闭 InetGet 返回的句柄.
    InetClose($hDownload)
	;运行安装atlas
	Run($sFilePath)
	
EndFunc   ;==>Example

Func WO_rec() ;ticket record
	
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\POPO部署.txt"'
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