#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AutoIt3Wrapper_OutFile=Y:\IGSA����.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Language=2052
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#Region ;**** ���������� ACNWrapper_GUI ****
#EndRegion ;**** ���������� ACNWrapper_GUI ****
While ProcessExists("IGSA.exe") 
	ProcessClose("IGSA.exe");�رռ�ʱͨ
WEnd


DirRemove("D:\IGSA20120510",1); ɾ����ʷ�汾


DirRemove("D:\IGSA",1)
If FileExists("D:\IGSA") Then
	MsgBox(0,"","ɾ���ɰ汾ʧ�ܣ������Ի���ϵIT")
EndIf


$Tip = "tip"
TrayTip($Tip,"IGSA�����У������ĵ���","",1)

$netuse='net use \\ITTOOL_node1\ITTOOLS '

$robo_IGSA="robocopy \\ITTOOL_node1\ITTOOLS\Scripts\IGSA D:\IGSA /mir "
Global $command_rec[2]=[$netuse,$robo_IGSA]  
runBat($command_rec)

TrayTip($Tip,"���","",1)
Sleep(1000)

FileDelete(@DesktopDir&"\IGSA*") ; *Ϊͨ�����ɾ�������Ŀ�ݷ�ʽ
FileCreateShortcut("D:\IGSA\IGSA.exe",@DesktopDir & "\IGSA.exe.lnk","D:\IGSA")

SendKeepActive("Program Manager") ;ˢ������k
For $i = 1 to 5;How many times
    Sleep(100)
    Send("{F5}")
Next
MsgBox(0,"","IGSA���������")
ShellExecute("D:\IGSA\IGSA.exe","","D:\IGSA")
WO_rec("����IGSA")

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



Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
