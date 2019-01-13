#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\PS_CS5.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

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
;~ 		MsgBox(0,"","��ʱֻ֧��64λ")
;~ 		Exit
;~ 	EndIf
	
	$PS="@���ٰ�װ.exe"
	;$software = $dir & "\" & $PS
	Global $PSsize=Round(DirGetSize($dir)/1024/1024,2)  ;MB
		
	ProgressOn("��������",  "Adobe Photoshop CS5 Extended 12.0.3.0" , "0 %", -1, -1, 16) ;-1�����м����꣬16Ϊ���϶�
	AdlibRegister("showProgress", 250)
	ShellExecuteWait("robocopy",'"' & $dir & '"  ' & '"' &  'E:\Adobe Photoshop CS5 Extended 12.0.3.0' & '"  ' & '/E' , "", "",@SW_HIDE)
	AdlibUnRegister("showProgress")
	ProgressSet(100, "���", "����״̬:")
	ProgressOff()
	
	TrayTip("tip","������ɣ����ڰ�װ",30)
	$install='"E:\Adobe Photoshop CS5 Extended 12.0.3.0\' & $PS & '"  i'

	Global $command_install[1] = [$install]
	runBat($command_install)
	
	
	$timeout=0
	$link="C:\Users\Public\Desktop\Adobe Photoshop CS5.lnk" ;��ps�Ŀ�ݷ�ʽ���ڹ�������
	While (Not FileExists($link) And $timeout <20 )
		Sleep(1000)
		$timeout = $timeout +1
	WEnd
	If Not FileExists($link) Then   
		MsgBox(0,"","��װʧ��")
		Exit
	EndIf
	
	TrayTip("tip","��װ���",2)
	MsgBox(0,"","��װ����ɡ���ʹ�������ݷ�ʽ��")
	ShellExecute($link)
	
	WO_rec("����photoshop")

EndFunc





Func showProgress()
	
	If Not ProcessExists("robocopy.exe") Then Return

	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
	$i = Round($stdread/$PSsize,3)*100
	If ProcessExists("robocopy.exe") And $i>=99.999 then
		ProgressSet($i, " ������ɣ�����ر�")
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