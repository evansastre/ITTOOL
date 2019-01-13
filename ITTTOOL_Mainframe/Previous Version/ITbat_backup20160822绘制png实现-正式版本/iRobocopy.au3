#NoTrayIcon
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_Icon=itbat_materials\iRobocopy.ico
#AccAu3Wrapper_OutFile=iRobocopy.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Process.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>

;~ Opt("TrayIconHide",1)
If _Singleton("iRobocopy.exe",1)=0 Then 	;Prevent repeated opening of the program
;~ 	ProcessClose("irobocopy.exe")
	MsgBox(0,"","��ǰ�пͻ���ͬ��������������"& @LF & "����ɺ�����",3)
	Exit
EndIf

Global $ParaNum=$CmdLine[0]

If $ParaNum<2 Then
	MsgBox(0,"","�����������")
	Exit
ElseIf $ParaNum==2 Then
	Global $Paras[3]=[' "' & $CmdLine[1] & '" ',' "' & $CmdLine[2] & '" '," /mir "]
ElseIf $ParaNum>=3 Then
	Global $Paras[0]
	_ArrayAdd($Paras,' "' & $CmdLine[1] & '" ')
	_ArrayAdd($Paras,' "' & $CmdLine[2] & '" ')
	For $i=3 To $ParaNum
		_ArrayAdd($Paras,$CmdLine[$i])
	Next
EndIf
;~ _ArrayDisplay($Paras)

;�Ǳ�tip
Opt("TrayOnEventMode", 1) ; �������� OnEvent �¼�����֪ͨ.
Opt("TrayMenuMode", 3) ; Ĭ�����̲˵���Ŀ��������ʾ, ��ѡ����ĿʱҲ�����. TrayMenuMode ������ѡ��Ϊ 1, 2.
TrayCreateItem("����...")
TrayItemSetOnEvent(-1, "show_Info")
TrayCreateItem("") ; �����ָ���.
TrayCreateItem("�˳�")
TrayItemSetOnEvent(-1, "CLOSEButton")
TraySetState($TRAY_ICONSTATE_SHOW) ; ��ʾ���̲˵�.




Global $server=$CmdLine[1];����ͬ����ԴĿ¼
Global $local_dir=$CmdLine[2];���ص�Ŀ��Ŀ¼


Func show_Info()
	MsgBox(0,"","����ͬ��:"& $local_dir)
EndFunc



Global $sCommand = 'robocopy '  
For $item In $Paras
	$sCommand&=' ' & $item & ' '
Next
;~ MsgBox(0,"",$sCommand)
;~ Exit

If Not FileExists($server) Then 
	MsgBox(0,"",$server &" ��ǰ���ڲ�����״̬�����Ժ����Ի���ϵIT") 
	Exit
EndIf


Func Init()
	Global $percent = 0    ;���Ȱٷֱ�
	Global $stdread=0  ;��ǰ��ȡ�ֽ���Y:\Robocopy_bliz_client
	Global $server_area = "" 
	;������robocopy����
	If ProcessExists("robocopy.exe") Then
		$res=MsgBox(1,"","��ǰ��ͬ�����̴��ڣ��Ƿ�ǿ�ƽ�����")
		If $res==1 Then
			While ProcessExists("robocopy.exe")
				ProcessClose("robocopy.exe")
			WEnd
		ElseIf $res==2 Then
			MsgBox(0,"","��ѡ���˲�����ͬ�����̣���ǰ������ֹ")
			Exit
		EndIf
	EndIf
	
	;���������½�����ȷ��ͬ��ʱû�н��̱�ռ��
;~ 	Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
;~ 	For $item In $list
;~ 		While ProcessExists($item)
;~ 			ProcessClose($item)
;~ 		WEnd
;~ 	Next
EndFunc


Func robocopy_from_server($server)
	$serverfolder = $server   ;ԴĿ¼��
	
	$Tip = "tip"
	TrayTip($Tip, "�ͻ���ͬ���У������ĵ���", "", 1)
	
	readstdout($serverfolder,$local_dir)  ;ͬ���ͻ���
EndFunc  

Init()
robocopy_from_server($server)


Func readstdout($my_folder,$my_local_dir)
	TrayTip("tip","����ͬ������" & $my_local_dir,10)

	Global $dirsize=Round(DirGetSize($my_folder)/1024/1024,1) ; & " MB"
;~ 	MsgBox(0,"",$my_folder)

;~ 	$show_info=StringMid($my_folder,17)
	
	#include <GUIConstantsEx.au3>
	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)
	

	$hMainGUI = GUICreate("ս���ͻ���ͬ������", 400, 100,-1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetIcon(@TempDir & "\button_icons\Battle.net.ico")
	
;~ 	$show_info=StringMid($my_folder,19)
	$show_info=$my_local_dir
;~ 	MsgBox(0,"",$show_info)
	Global $idLabel2=GUICtrlCreateLabel("����ͬ��:"& $show_info,0,0,400,30)
	Global $idLabel1=GUICtrlCreateLabel(" ",0,80,400,30)
	Global $idProgressbar1=GUICtrlCreateProgress(-1,40,400,30)
	GUISetState(@SW_SHOW)

	Local $iWait = 250; Ϊ��һ�����ȵȴ� 250 ����
;~ 	Local $iSavPos = 0; �������λ��
	
;~  	$sCommand = 'robocopy "'&  $my_folder & '"  "'& $my_local_dir &'"  /mir'
 	Run( $sCommand,@SystemDir,@SW_HIDE )

;~ 	Sleep(1000)
	While 1
		showProgress()
		Sleep($iWait)
		If Not ProcessExists("robocopy.exe") Then 
			GUICtrlSetData($idLabel1, $local_dir&"ͬ������ɡ�ͬ����������"& $stdread & "MB")
			TrayTip("tip",$local_dir & "ͬ������ɡ�ͬ����������"& $stdread & "MB",3,1)
	
			Sleep(2000)
			Return
		EndIf
	WEnd
EndFunc

Func showProgress()
	If Not ProcessExists("robocopy.exe") Then Return
	
	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"

	$percent = Round($stdread/$dirsize,3)*100
	If ProcessExists("robocopy.exe") And $percent>=99.999 then
		GUICtrlSetData($idLabel1, " ������ɣ�����ر�")
	Else
		GUICtrlSetData($idLabel1, "����ͬ���У������ĵȴ�����ǰͬ���������� " & $stdread & "MB" )
	EndIf
	
	GUICtrlSetData($idProgressbar1, $percent)
EndFunc   ;==>showProgress

Func CLOSEButton()
	While ProcessExists("robocopy.exe")
		ProcessClose("robocopy.exe")
	WEnd
	MsgBox(0,"","��������ͬ�����̣�" & @LF &"��������ͬ�����̿��ܵ��¿ͻ����޷���������",5)
	Exit
EndFunc   ;==>CLOSEButton

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\wowgametestdc\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc

Func runBat($cmd);$cmd must be array
    Local $sFilePath =_TempFile(Default,Default,".bat")
	

	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc   ;==>runBat

