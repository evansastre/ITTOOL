#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile_x64=Y:\POPO����.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <InetConstants.au3>
#include <Misc.au3>

If _Singleton("POPO����", 1) = 0 Then
	MsgBox(0, "", "POPO��������Ѿ�����");Prevent repeated opening of the program
	Exit
EndIf


;���������½�����ȷ��ͬ��ʱû�н��̱�ռ��
Local $list[1]= ["MyPopo.exe"]
For $item In $list
	While ProcessExists($item)
		ProcessClose($item)
	WEnd
Next

TrayTip("tip","�������ذ�װ��,���Ե�",10)

;�ر�atlas��ET����
Sleep(1000)

PoPo_install()
WO_rec()

Func PoPo_install()  ;���ز���װatlas
	
	; ���ص��ļ����浽��ʱ�ļ���.
    Local $sFilePath = @TempDir & "\POPO-setup.exe"
    ; �ں�̨��ѡ����ѡ�������ļ�, ��ǿ�ƴ�Զ��վ�����¼���.'
    Local $hDownload = InetGet("http://popo.corpname.com/file/popowin/POPO-setup_3_0_2.exe", @TempDir & "\POPO-setup.exe", $INET_FORCERELOAD, $INET_DOWNLOADWAIT)
    ; �ر� InetGet ���صľ��.
    InetClose($hDownload)
	;���а�װatlas
	Run($sFilePath)
	
EndFunc   ;==>Example

Func WO_rec() ;ticket record
	
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\POPO����.txt"'
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