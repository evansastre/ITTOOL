#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\��ʱͨ\���뼴ʱͨ��¼.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <File.au3>
#include <Math.au3>

While ProcessExists("eim-intra.exe") 
	ProcessClose("eim-intra.exe");�رռ�ʱͨ
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

Local Const $sFilePath = @TempDir & "\user_data.conf"  ;����ʱĿ¼����conf�ļ�
Local Const $confPath= @UserProfileDir&"\AppData\Roaming\corpname\Popoem-Intra\" ;conf�ļ�����·��
Local $source = @DesktopDir& "\"&@UserName & "@battlenet.im" 

If Not FileExists($source) Then   
	$res=MsgBox(1,"","��������δ����֮ǰ�����ļ�ʱͨ��¼��"& @LF &"����ִ�н��Կռ�¼�滻��ǰ�����¼���Ƿ������")
	If $res==2 Then
		MsgBox(0,"","����ֹ��ִ��")
		Exit
	EndIf
EndIf


If FileExists($confPath) Then
	RunAsWait("wow",@ComputerName,"Password@2",1,DirRemove($confPath,1))
EndIf
;�����������ļ���ʱ�򿽱����������˲���    ������ʱ�޷����ǡ�

$netuse1='net use \\'& $cw_server &'\Popoem-Intra'
$mkdir='mkdir ' & $confPath 
$xcopy='robocopy \\' & $cw_server & '\Popoem-Intra ' & $confPath &  ' /mir '
Global $command_copy[4]=[$netuse1,$Install_EIM,$mkdir,$xcopy]  
runBat($command_copy) ;�����������ϵ������ļ�������
;DirCopy("\\192.168.109.200\Popoem-Intra",$confPath,1) ;���������ļ�


FileWrite($sFilePath,"user_data_path = "& $confPath);�����ļ��е��û��ļ���ָ������
FileCopy($sFilePath,$confPath,1+8);�滻����conf�ļ�
FileDelete($sFilePath);ɾ������ʱĿ¼������conf�ļ�



If FileExists($source) Then
	$des= $confPath &"\users\" &@UserName & "@battlenet.im"
	DirCopy($source,$des,1) ;�����û���¼������λ��  
EndIf

If FileExists(@DesktopDir&"\���׼�ʱͨ.lnk") Then
	FileDelete(@DesktopDir&"\���׼�ʱͨ*") ; *Ϊͨ�����ɾ�������Ŀ�ݷ�ʽ
EndIf


$path="C:\Program Files (x86)\corpname\corpname EIM\Start.exe"
If Not FileExists($path) Then 
	$path="C:\Program Files\corpname\corpname EIM\Start.exe"
EndIf

FileCreateShortcut($path,@DesktopDir &"\���׼�ʱͨ")

Run($path)

$Title= "���׼�ʱͨ"
WinWaitActive($Title,"")
ControlSetText($Title,"","Edit2",@UserName&"@battlenet.im")
ControlClick($Title,"","Edit1","left")




WO_rec()
Func WO_rec() ;ticket record
	$netuse='net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file='set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\��ʱͨ�����¼ת��.txt"'
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

