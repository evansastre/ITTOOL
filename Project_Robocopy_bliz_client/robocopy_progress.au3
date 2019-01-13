#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\Robocopy_bliz_client\robocopy_progress.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****


#include <Process.au3>
#include <Math.au3>
#include <Misc.au3>
#include <Array.au3>
#include <AD.au3>
#include <file.au3>

;Y:\Robocopy_bliz_client\robocopy_progress.exe
;  test     \\192.168.116.1\E$\robocopy_progress.exe
Opt("TrayIconHide",1)

If $CmdLine[0]<> 1 Then
		MsgBox(0,"","�������������ȷ������")
		Exit
EndIf
Global $game=$CmdLine[1]    ;������Ϸ��
	
If _Singleton("ս���ͻ��˶�Դͬ��.exe",1)=0 Then 	;Prevent repeated opening of the program
	
	MsgBox(0,"", "�пͻ�������ͬ������ȴ����")
	Exit
EndIf


Func Init()
	

	
	
	Global $location="";�������ڵ�
	Global $server="";����ͬ����Դ������

	Global $percent = 0    ;���Ȱٷֱ�
	Global $stdread=0  ;��ǰ��ȡ�ֽ���Y:\Robocopy_bliz_client
	Global $local_dir="D:\" & $game
;~ 	If Not FileExists("D:\") Then
;~ 		MsgBox(0,"","D�̲����ڻ��޷�ʹ��")
;~ 		Exit
;~ 	EndIf
	
	
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
	
	
	Switch $game
		Case "World of Warcraft"
			Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
		Case "Diablo III CN"
			Local $list[3]= ["Diablo III.exe","battle.net.exe","agent.exe"]
		Case "Heroes of the Storm"
			Local $list[4]= ["HeroesOfTheStorm_x64.exe","Heroes of the Storm.exe","battle.net.exe","agent.exe"]
		Case "Hearthstone"
			Local $list[3]= ["Hearthstone.exe","battle.net.exe","agent.exe"]
		Case "Overwatch"
			Local $list[3]= ["Overwatch.exe","battle.net.exe","agent.exe"]
		Case "StarCraft_II"
			Local $list[4]= ["SC2_x64.exe","StarCraft II.exe","battle.net.exe","agent.exe"]
	EndSwitch
	
	;���������½�����ȷ��ͬ��ʱû�н��̱�ռ��
;~ 	Local $list[6]= ["Wow-64.exe","WowGM-64.exe","Wow.exe","WowGM.exe","battle.net.exe","agent.exe"]
	For $item In $list
		While ProcessExists($item)
			ProcessClose($item)
		WEnd
	Next
EndFunc



Func judgeLocation()
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		judgeLocationJV()
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
	EndIf
EndFunc

Func judgeLocationJV()
	Local $myip=@IPAddress1
	Local $tmp_arr=StringSplit($myip,".",1)
	$IP_area=$tmp_arr[3]
	If $IP_area=="105" Then
		$location = 'JV'
;~ 		MsgBox(0,"","area:"&$IP_area)
	EndIf
	
	Return
;~ 	Exit
EndFunc

	

Func chooseServer($location)	
	$dir = "\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\"
	Global $PROFILEPATH = $dir & $game & ".ini"
	$aArray = IniReadSectionNames($PROFILEPATH)
	If @error<>0 Then 
		MsgBox(0,"","�����ļ��д�����ϵIT����")
		Return -1
	EndIf
	
	Local $TotalNum = $aArray[0] ; ͬ��Դ����
	
	
	$get_min_links=False
	For $i = 1  To  $TotalNum
		$this_location=IniRead($PROFILEPATH,$aArray[$i],"location","")
		
		
		If $this_location=="" Then ContinueLoop ;���location�Ķ����ȡ��Ϊ�գ���������ǰ����Դ��������һ��ѭ��
		If $this_location==$location Then ;��ȡ��Դ�������뵱ǰ�û����ڵ���ͬ
			If Not $get_min_links Then 
				$min_links=IniRead($PROFILEPATH,$aArray[$i],"links",0) ;����Сconnect����ʼ��Ϊ�׸�Դ��connect��*******
				If $min_links=="" Then $min_links=0 
				$server=$aArray[$i]
;~ 				MsgBox(0,"", "��ǰ�������� "&$server)
				$get_min_links=True
				ContinueLoop
			EndIf
			
;~ 			MsgBox(0,"","i="& $i& "  "& $this_location)
			$this_links=IniRead($PROFILEPATH,$aArray[$i],"links","���岻����") ;��ȡlinks��ֵ
			If $this_links=="" Then $this_links=0 ;���û�ж�������ֵ������Ϊ����ǰΪ0
			If $this_links==0 Then $min_links=$this_links  ;��ǰ������connect��Ϊ0ʱ�����¶�����Ϊ��Сconnect��������
			If $this_links <= $min_links Then 
				$min_links=$this_links ; ����ǰ�ķ�����connect������Ϊ��Сconnect��
				$server=$aArray[$i]
;~ 				MsgBox(0,"", "��ǰ�������� "&$server)
			EndIf
			
		EndIf
	Next
;~ 	MsgBox(0,"",$location &@LF& $server)
	
;****************************����쳣�Ͽ�connect״��******************************
	
	For $i = 1  To  $TotalNum
		Local $this_server=$aArray[$i]
		Local $this_user=IniRead($PROFILEPATH,$this_server,"users","")
		If $this_user=="" Then ContinueLoop
		Local $this_ips=IniRead($PROFILEPATH,$this_server,"ips","")
		
		If StringInStr($this_user,StringUpper(@UserName)) And StringInStr($this_ips,@IPAddress1)  Then ;����û����Ѿ��ڣ�˵������ʷ���쳣connectû�Ͽ���������һ̨�����Ͽ���ͬ�� ��ͬһ̨���ԣ�IP����ͬһ�û����������ϴ��쳣�Ͽ���
					
			$this_user=StringReplace($this_user , StringUpper(@UserName) & "|","")
			IniWrite($PROFILEPATH,$this_server,"users",$this_user) ;д����������û������ַ���
			
			$this_ips=StringReplace($this_ips , @IPAddress1 & "|","")
			IniWrite($PROFILEPATH,$this_server,"ips",$this_ips) ;д���������IP��ַ���ַ���
			
			Local $this_links=IniRead($PROFILEPATH,$this_server,"links","���岻����") ;��ȡlinks��ֵ
			IniWrite($PROFILEPATH,$this_server,"links",$this_links-1)  ; ������connect����¼��1
		EndIf
	Next
	
;****************************дconnect״��******************************
	IniWrite($PROFILEPATH,$server,"links",$min_links+1)  ;connect�� +1
	Local $users=IniRead($PROFILEPATH,$server,"users","")
	If Not StringInStr($users,StringUpper(@UserName)) Then IniWrite($PROFILEPATH,$server,"users",$users & StringUpper(@UserName) & "|") ;д���û���
	
	Local $ips=IniRead($PROFILEPATH,$server,"ips","")
	If Not StringInStr($ips,@IPAddress1) Then IniWrite($PROFILEPATH,$server,"ips",$ips & @IPAddress1 & "|") ;д��IP��ַ

EndFunc   

Init()
judgeLocation()
chooseServer($location)
robocopy_from_server($server)


Func robocopy_from_server($server)
	
	

	$myfolder = '\\' & $server & '\' & $game ;ԴĿ¼��

	
	If Not FileExists($myfolder) Then 
		MsgBox(0,"","������ " &$server &" ��ǰ���ڲ�����״̬���������ڽ��а汾����ά�������Ժ����Ի���ϵIT") 
		Exit
	EndIf
	
	$Tip = "tip"
	TrayTip($Tip, "�ͻ���ͬ���У������ĵ���", "", 1)
	
	Global $dirsize=Round(DirGetSize($myfolder)/1024/1024,1) ; & " MB"
	
	
	
	;ս���ͻ���
	Global $battlenet1='robocopy.exe  "\\' & $server & '\phoenix\Program Files (x86)\Battle.net"  "%programfiles(X86)%\Battle.net"  /mir '
	Global $battlenet2='robocopy.exe  "\\' & $server & '\phoenix\ProgramData\Battle.net"  "C:\ProgramData\Battle.net"  /mir '
	Global $battlenet3='robocopy.exe  "\\' & $server & '\phoenix\Roaming\Battle.net"   "%userprofile%\AppData\Roaming\Battle.net"   /mir '
	Global $battlenet4='robocopy.exe  "\\' & $server & '\Phoenix\Local\Battle.net"     "%userprofile%\AppData\Local\Battle.net"  /mir '
	Global $battlenet5='robocopy.exe  "\\' & $server & '\Phoenix\ս����Ϸ_��ݷ�ʽ"     "%userprofile%\desktop\ս����Ϸ_��ݷ�ʽ"  /mir '
	
;~ 	Global $wtf='echo .'

	If $game== "World of Warcraft" Then 
		$battlenet5='echo .'  ;Ϊwowʱ��������ݷ�ʽ
		$local_dir="D:\CMOP5"
		
		$IsCross=IsCross()
		If  $IsCross  Then ;���û���GM_list��ʱ
			$wowclient='%temp%\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'" '

		Else 
			;wow�ͻ���
			$wowclient='%temp%\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'"  /mir /XF *WowGM* /XD Interface WTF '
			If Not FileExists($local_dir & "\WTF\Config.wtf") Then FileCopy($myfolder & "\WTF\Config.wtf",$local_dir & "\WTF\Config.wtf",1+8)
;~ 			$wtf='copy  "'& $myfolder & '\WTF\Config.wtf"  "'& $local_dir &'\WTF\Config.wtf"   '
	;~ 		$wowclient='D:\IT����Ĺ���\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'"   /XF *WowGM* /XD Interface  '
	
		EndIf
		
		
	
	Else
		$wowclient='%temp%\iRobocopy.exe  "'& $myfolder & '"  "'& $local_dir &'" '
	EndIf
	
	
	

	Global $cmd[6]=[$wowclient,$battlenet1,$battlenet2,$battlenet3,$battlenet4,$battlenet5]

	
	runBatWait($cmd)
;~ 	
	
	;****************************ticket record******************************
	If $location == 'HZ' Then ;��¼����
		WO_rec($game&"�ͻ��˸���_����")
	ElseIf $location == 'SH' Then 
		WO_rec($game&"�ͻ��˸���_�Ϻ�")
	EndIf
;~ 	
	TrayTip($Tip, "���", "", 1)
	Sleep(1000)
	
	
	;****************************�ָ�connect״��******************************
	Local $this_links=IniRead($PROFILEPATH,$server,"links","���岻����") ;��ȡlinks��ֵ
	If $this_links=="" Then
		$this_links=0 ;���û�ж�������ֵ������Ϊ����ǰΪ0
		IniWrite($PROFILEPATH,$server,"links",$this_links)  ;
	Else
		IniWrite($PROFILEPATH,$server,"links",$this_links-1)  ; ������connect����¼��1
	EndIf
	
	
	Local $users=IniRead($PROFILEPATH,$server,"users","")
	If StringInStr($users,StringUpper(@UserName)) Then 
		$users=StringReplace($users , StringUpper(@UserName) & "|","")
		IniWrite($PROFILEPATH,$server,"users",$users) ;д����������û������ַ���
	EndIf
	
	Local $ips=IniRead($PROFILEPATH,$server,"ips","")
	If StringInStr($ips,@IPAddress1) Then 
		$ips=StringReplace($ips , @IPAddress1 & "|","")
		IniWrite($PROFILEPATH,$server,"ips",$ips) ;д���������IP��ַ���ַ���
	EndIf
		
	If $game== "World of Warcraft" Then
		If Not FileExists(@DesktopDir & "\ս����Ϸ_��ݷ�ʽ") Then DirCreate(@DesktopDir & "\ս����Ϸ_��ݷ�ʽ")
		
		If Not $IsCross Then
			DirRemove("D:\CMOP5\Interface\AddOns\GM++",1)
			DirRemove("D:\CMOP5\Interface\AddOns\DebugMenu",1)
			FileDelete("D:\CMOP5\WowGM.exe")
			FileDelete("D:\CMOP5\WowGM.pdb")
			FileDelete("D:\CMOP5\WowGM-64.exe")
			FileDelete("D:\CMOP5\WowGM-64.pdb")
			
			FileCreateShortcut("D:\CMOP5\Wow.exe",@DesktopDir & "\ս����Ϸ_��ݷ�ʽ\Wow.lnk")
			$res=MsgBox(1,"","ͬ����ɣ��Ƿ�򿪿ͻ���?") ;
			If $res==1 Then Run("D:\CMOP5\Wow-64.exe") 
		Else 
			FileCreateShortcut("D:\CMOP5\WowGM-64.exe",@DesktopDir & "\ս����Ϸ_��ݷ�ʽ\WowGM-64.lnk")
			$res=MsgBox(1,"","ͬ����ɣ��Ƿ��GM�ͻ���?") ;
			If $res==1 Then Run("D:\CMOP5\WowGM-64.exe") ;*********************** GM�ͻ���	
		EndIf
	Else
		$res=MsgBox(1,"","ͬ����ɣ��Ƿ��ս���ͻ���?") ;
		If $res==1 Then  Run("C:\Program Files (x86)\Battle.net\Battle.net.exe")
	EndIf
	
	
	
EndFunc  


Func get_member_of()
	Global $GM_list=StringUpper("ITbat_client_wowGM")
	
	Global $myGgroup[0]	
	_AD_Open()
	If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	; �����û���������
	Global $aUser = _AD_RecursiveGetMemberOf(@UserName, 10, 1)
	If @error > 0 Then
		MsgBox(64, "", "�û� '" & StringUpper(@UserName) & "' �������κ����ڰ�ȫ��")
		Exit
	Else
		$NUM=$aUser[0]
		For $i=1 To $NUM 
			;��DN���д���ȡ��group���ֶ�
			$tmp_arr=StringSplit($aUser[$i],",",1)
			$group=$tmp_arr[1]
			$tmp_arr2=StringSplit($group,"=",1)
			$group=$tmp_arr2[2]
			_ArrayAdd($myGgroup,StringUpper($group))    ;ע��ͳһΪ��д
		Next
	EndIf
	; �ر�AD
	_AD_Close()
;~ 	_ArrayDisplay($myGgroup)
;~ 	Exit
EndFunc

Func IsCross()
	get_member_of()  ;��ȡ�������ڰ�ȫ��
	$res=_ArraySearch($myGgroup,$GM_list)
	If $res<>-1 Then 
;~ 		MsgBox(0,"","True")
		Return True
	EndIf
;~ 	MsgBox(0,"","False")
	Return False			
EndFunc



Func runBatWait($cmd);$cmd must be array
	
    Local $sFilePath =_TempFile(Default,Default,".bat")
	For $i In $cmd 
;~ 		MsgBox(0,"",$i)
		FileWriteLine($sFilePath,$i)
	Next
;~ 	MsgBox(0,"",$cmd)
	FileWriteLine($sFilePath,"del %0")
	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)
;~ 	MsgBox(0,"","done")
EndFunc



Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  StringUpper(@UserName) & "   " & @ComputerName & "   " & $cur_Time 
	$res=FileWriteLine($rec_file,$rec)
EndFunc







