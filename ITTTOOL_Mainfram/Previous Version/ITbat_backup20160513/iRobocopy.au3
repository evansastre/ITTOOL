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

;~ Opt("TrayIconHide",1)
If _Singleton("iRobocopy.exe",1)=0 Then 	;Prevent repeated opening of the program
;~ 	ProcessClose("irobocopy.exe")
	MsgBox(0,"","��ǰ�пͻ���ͬ��������������"& @LF & "����ɺ�����",3)
	Exit
EndIf


If $CmdLine[0]<>2 Then
	MsgBox(0,"","�����������")
	Exit
EndIf

Global $server=$CmdLine[1];����ͬ����ԴĿ¼
Global $local_dir=$CmdLine[2];���ص�Ŀ��Ŀ¼

;~ $server="\\192.168.105.179\CMOP5"
;~ $local_dir="D:\CMOP5"


;~ #include <NetShare.au3>
;~ $res=_Net_Share_ShareCheck()

;~ $res=_Net_Share_ConnectionEnum  ("hzcdn01.CorpDomain.internal","ħ�����Թٷ���սƽ̨�ڲ�")
;~ $res=_Net_Share_ConnectionEnum  ("192.168.112.241","Overwatch")
;~ $res=_Net_Share_ConnectionEnum  ("192.168.105.179","CMOP5")


;~ $res=_Net_Share_ShareGetInfo(@ComputerName,"Oct")




;~ If UBound($res)>0 Then
;~ 	MsgBox(0,"",$res[0])
;~ Else
;~ 	MsgBox(0,"",$res)
;~ EndIf

;~ MsgBox(0,"",@error)

;~ Local Const $sShareName="OCT"
;~ $res=_Net_Share_ShareCheck(@ComputerName,$sShareName)

;~ #include <WinAPIFiles.au3>
;~ $res=_WinAPI_PathIsDirectory  ("\\hzcdn01\Overwatch" )
;~ 
#include <WinAPIFiles.au3>
#include<WinAPIEx.au3>
;~ $res=_WinAPI_IsPathShared("\\192.168.112.241\Overwatch")
;~ $res=_WinAPI_IsPathShared("\\localhost\OCT")
;~ MsgBox(0,"",$res)
;~ MsgBox(0,"",@error)



;~ $res=_WinAPI_IsPathShared($server )

;~ MsgBox(0,"",$res)
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
	Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
	For $item In $list
		While ProcessExists($item)
			ProcessClose($item)
		WEnd
	Next
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
;~ 	MsgBox(0,"",$dirsize)
;~ 	$show_info=StringMid($my_folder,17)
	
	#include <GUIConstantsEx.au3>
	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)

	$hMainGUI = GUICreate("ս���ͻ���ͬ������", 400, 100,-1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetIcon(@TempDir & "\button_icons\Battle.net.ico")
	
	$show_info=StringMid($my_folder,19)
	Global $idLabel2=GUICtrlCreateLabel("����ͬ��:"& $show_info,0,0,400,30)
	Global $idLabel1=GUICtrlCreateLabel(" ",0,80,400,30)
	Global $idProgressbar1=GUICtrlCreateProgress(-1,40,400,30)
	GUISetState(@SW_SHOW)

	Local $iWait = 250; Ϊ��һ�����ȵȴ� 250 ����
;~ 	Local $iSavPos = 0; �������λ��
	
 	$sCommand = 'robocopy "'&  $my_folder & '"  "'& $my_local_dir &'"  /mir'
 	Run( $sCommand,@SystemDir,@SW_HIDE )

;~ 	Sleep(1000)
	While 1
		showProgress()
		Sleep($iWait)
		If Not ProcessExists("robocopy.exe") Then 
			GUICtrlSetData($idLabel1, "�����")
			Sleep(1000)
			TrayTip("tip","ͬ�����",10)
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
		GUICtrlSetData($idLabel1, $stdread & "MB/" & $dirsize & "MB")
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




