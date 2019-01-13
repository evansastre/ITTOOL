#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\Lync2010.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

#include <Math.au3>
#include <TrayConstants.au3>

Install()

Func Install()
	
	Global $path=RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\communicator.exe", "Path") & "communicator.exe"
	If @error==0 Then ; Ϊ0ʱ˵���Ѿ���ȡ����ֵ��˵��lync�Ѱ�װ��ֱ���������ò���
		While ProcessExists("communicator.exe") 
			ProcessClose("communicator.exe");�ر�LYNC
		WEnd
		$res=MsgBox(4,"","��⵽ Lync �Ѿ���װ���Ƿ�ֱ�Ӵ򿪣�"  & @LF & _ 
						  "ѡ [��] ��ֱ�Ӵ�Lync���������ã�ѡ [��] ���˳�" )
		If $res==6 Then
			ShellExecute($path) ;��
			set()               ;����
			Return
		Else 
			Exit			
		EndIf
	EndIf
		
	;�жϵ�ǰ���ڵأ�������lync	
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")

	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$dir="\\ITTOOL_node2\ITTOOLS\SoftwareDeploy"
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$dir="\\ITTOOL_node1\ITTOOLS\SoftwareDeploy"
	EndIf
	
	$lync="LyncSetupEval_64.1399432773.exe"
	$software = $dir & "\" & $lync
	Global $lyncsize=Round(FileGetSize ($software)/1024/1024,2)  ;MB
	
	ProgressOn("��������",  $lync , "0 %", -1, -1, 16) ;-1�����м����꣬16Ϊ���϶�
	AdlibRegister("showProgress", 250)
	ShellExecuteWait("robocopy",'"' & $dir & '"  ' & '"' &  'E:\Lync' & '"  ' & $lync , "", "",@SW_HIDE)
	AdlibUnRegister("showProgress")
	ProgressSet(100, "���", "����״̬:")
	ProgressOff()
	
	;
	
    ;��װ����
	ShellExecute("E:\Lync\" & $lync)
	TrayTip("tip","���ڼ�ⰲװ����,�������",30)
	$Title="Microsoft Lync 2010 ��װ����"
	$time=0
	While True    
		If $time >= 60 Then ;��ʱ30�� ������������˳�ѭ��
			$choose=MsgBox(1,"","��װ�����쳣���Ƿ����°�װ��")	
			If $choose==1 Then
				Install()
				Return
			ElseIf $choose==2 Then
				Exit
			EndIf
		EndIf
		
		$res=WinExists($Title,"��װ(&I)") ;�жϴ����Ƿ���֣������򼤻װ���ڣ����˳����ж�ѭ��
			If $res==0 Then   ;���ڲ�����
				Sleep(500) ;ͣ�����ټ���ѭ��
				$time=$time +1 
				ContinueLoop
			elseIf $res==1 Then
				WinActivate($Title,"��װ(&I)")
				ExitLoop
			EndIf
	WEnd
	
	
	
	
	ControlClick($Title,"","Button1","left",1) ;�����װ
	TrayTip("tip","���ڰ�װ����װ���̽��Զ���ɣ�������в���",30)
	While True
		If WinExists($Title,"�鿴����ʱʹ�� Microsoft Update (�Ƽ�)") Then  ;�״ΰ�װlync������
			WinActivate($Title,"�鿴����ʱʹ�� Microsoft Update (�Ƽ�)")
			ControlClick($Title,"","Button1","left",1)
			ControlClick($Title,"","Button4","left",1)
			WinWaitActive($Title,"�ѳɹ���װ",20)
			Sleep(2000) ; ��ͣһ�������մ��ڳ���
			ControlClick($Title,"","Button2","left",1) ;�ر�
			ExitLoop
		EndIf
		If WinActive($Title,"�ѳɹ���װ��") Then    ;������֮ǰ�Ѿ���װ��lync��ж�غ��ٴΰ�װ������
;~ 			MsgBox(0,"","���ִ���")
;~ 			$res=ControlGetFocus($Title,"�ѳɹ���װ��")
;~ 			MsgBox(0,"","���ִ���2")
;~ 			If $res=="" Then
;~ 				MsgBox(0,"","δ�ҵ���װ�ɹ�����")
;~ 				ContinueLoop
;~ 			ElseIf $res<>"" Then
;~ 				MsgBox(0,"","�ҵ��˽�������")
;~ 			EndIf
;~ 			MsgBox(0,"","���ִ���3")
			Sleep(2000) ; ��ͣһ�������մ��ڳ���
			ControlClick($Title,"�ر� (&L)","Button2","left",1) ;����ر�Button
			ExitLoop
		EndIf
		Sleep(100) ;��ѭ����ͣ������cpuռ��
	WEnd
	; "�ѳɹ���װ��""��װ�ɹ�"
	TrayTip("tip","��װ��ɣ�������ʼ����",3)
	DirRemove('E:\Lync\',1);ɾ����װ������ʼ���ò���
	WO_rec("����lync2010")
	set()
EndFunc


Func set()
	If Not ProcessExists("communicator.exe") Then ShellExecute($path) ; "û��ʱ��һ��"
	
	$Title="Microsoft Lync          "
	$res=WinWaitActive($Title,"",20)
	If $res==0 Then 
		MsgBox(0,"","LYNC����δ��ɣ��޷���⵽�Ѵ򿪵�LYNC�����������б�����")
		Exit
	EndIf

	$Pos=WinGetPos($Title,"") ;���POPO��������ܵ���ʼ����
	$x=$pos[0]
	$y=$pos[1]

	MouseClick("left",$x+300,$y+60)  ;���һ������Button
	$Title="Lync - ѡ��"
	WinWaitActive($Title,"")
	ControlSetText($Title,"","Edit1","kxu.nbe@blizzard.com") ;��д��¼��ַ
	ControlClick($Title,"","Button2","left",1) ;������߼���Button
	;Sleep(1000)
	$Title="�߼�connect����"
	WinWaitActive($Title,"")
	ControlClick($Title,"","Button2","left",1) ;������ֶ����á�Button
	ControlSetText($Title,"","Edit1","im.blizzard.com:443") ;��д�ڲ�ip��ַ
	ControlSetText($Title,"","Edit2","im.blizzard.com:443") ;��д�ⲿip��ַ
	ControlClick($Title,"","Button5","left",1) ;�����Confirm��Button
	$Title="Lync - ѡ��"
	WinActive($Title,"") ;����֮ǰ��������
	ControlClick($Title,"","Button18","left",1) ;�����Confirm��Button
	
	$Title="Microsoft Lync          "
	WinActive($Title,"") ;�����¼����

	MouseClick("left",$x+78,$y+300)  ;���һ�µ�¼Button
	MouseMove($x+98,$y+300)
	
	MsgBox(0,"","LYNC��������ɣ��볢�Ե�¼")
EndFunc



Func showProgress()
	
	If Not ProcessExists("robocopy.exe") Then Return

	$arr=ProcessGetStats("robocopy.exe",1)
	$stdread = Round($arr[3]/1024/1024,1) ;& " MB"
	$i = Round($stdread/$lyncsize,3)*100
	If ProcessExists("robocopy.exe") And $i>=99.999 then
		ProgressSet($i, " ������ɣ�����ر�")
	Else
		ProgressSet($i, $stdread & "MB/" & $lyncsize & "MB")
	EndIf

EndFunc   ;==>showProgress


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
