#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\webchat_au3.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Math.au3>
#include <TrayConstants.au3>

Install()

Func Install()
	TrayTip("tip","�������ذ�װ��,���Ե�",30)
	$dir="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy"
	$lync="webchat����.exe"
	$software = $dir & "\" & $lync
	Global $lyncsize=Round(FileGetSize ($software)/1024/1024,2)  ;MB
	
	ShellExecute($software)
	WO_rec("����webchat")

EndFunc


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc


