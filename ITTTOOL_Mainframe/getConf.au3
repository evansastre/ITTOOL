#include <AD.au3>
#include <Array.au3>
#include <Math.au3>
#include <Timers.au3> ;��������ʱ��



;~ getConf()
Func getConf()
	
	get_MyADPriv()
	get_AccessTools()
;~ 	Sleep(2000);������ʾ���붯��
	
EndFunc

Func get_MyADPriv() ;��ȡ����Ȩ��,��ȡ����ǰ�û��İ�ȫ�顢IP���û���
	
	Global $myGgroup[1]=["DOMAIN USERS"]  ;�·��ĺ������Ὣdomain users��Ϊ�����飬���Գ�ʼ��ʱֱ�Ӹ�ֵһ��
	Global $ip=@IPAddress1
	Global $username=StringUpper(@UserName)

	_AD_Open()
	If @error Then Exit MsgBox(16, "����", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended & @LF & "��ǰ��¼�˺ſ��ܲ������˺ţ����˺�״̬�쳣")

	; �����û���������
	Global $aUser = _AD_RecursiveGetMemberOf(@UserName, 10, 1)
	If @error > 0 Then
		MsgBox(64, "", "�û� '" & @UserName & "' �������κ����ڰ�ȫ��")
		Exit
	Else
;~ 		_ArrayDisplay($aUser, "Active Directory Functions - Example 1 - Group names user '" & @UserName & "' is a member of")
		$NUM=$aUser[0]
		
		For $i=1 To $NUM 
			;��DN���д���ȡ��group���ֶ�
			$tmp_arr=StringSplit($aUser[$i],",",1)
			$group=$tmp_arr[1]
			$tmp_arr2=StringSplit($group,"=",1)
			$group=$tmp_arr2[2]
			_ArrayAdd($myGgroup,StringUpper($group))  ;ע��ͳһΪ��д
;~ 				MsgBox(0,"",$group)
		Next
	EndIf
	; �ر�AD
	_AD_Close()
;~ 	_ArrayDisplay($myGgroup)
;~ 	MsgBox(0,"",$ip&@LF&@UserName)
EndFunc

Func judgeLocation()
	
	Local $location
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
	EndIf
	
	Return $location
EndFunc


Func get_AccessTools() ;��ȡ���ù����б�
	
	Global $mylocation=judgeLocation()
	Global $server_itbat_dir
	
	If $mylocation=='HZ' Then
		$server_itbat_dir = "\\ITTOOL_node1\ITTOOLS\Conf\ITbat\"
	ElseIf $mylocation=='SH' Then
		$server_itbat_dir = "\\ITTOOL_node2\ITTOOLS\Conf\ITbat\"
	EndIf
	
	
	Global $PROFILEPATH = $server_itbat_dir & "ITTOOL.ini"
	$aArray = IniReadSectionNames($PROFILEPATH) ;��ȡ���еĹ�����
	If @error<>0 Then 
		MsgBox(0,"","�����ļ��д�����ϵIT����")
		Return -1
	EndIf



	Global  $TotalNum = $aArray[0] ; ��������
	Global  $ToolNames[$TotalNum];�������ƣ���ÿ���ֶ�����
	Global  $AccesstoolsNum=0 ;�û���Ȩ�޷��ʵĹ��߼�
	Global  $AccessTools[0] ;�û���Ȩ�޷��ʵĹ��߼�
	Global  $AccessIco[0] ;�û���Ȩ�޷��ʵĹ���ͼ��
	Global  $AccessCommandText[0] ;�û���Ȩ�޷��ʵĹ�������
	Global  $AccessDescribe[0] ;�û���Ȩ�޷��ʵĹ�������
	Global  $AccessCategory[0] ;�û���Ȩ�޷��ʵĹ�������
	
	Local $aArrayUnique[0] ;�����洢Ψһ�Ĺ���������ʱ����ظ���
	For $i = 1 To $TotalNum
		_ArrayFindAll ($aArrayUnique,$aArray[$i])
		If @error<>0 Then
			_ArrayAdd($aArrayUnique,$aArray[$i])
		Else
			MsgBox(0,"",$aArray[$i]&"���߶���������")
			Exit
		EndIf
		
;~ 		$ToolNames[$i-1] = $aArray[$i];�������ƣ���ÿ���ֶ�����
;~ 		MsgBox(0,"",$aArray[$i])%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		If $aArray[$i]=="" Then
			MsgBox(0,"","��"&$i&"������û�ж�������")
			Exit
		EndIf
		
		
		
		;
		Global $atool = IniReadSection($PROFILEPATH,$aArray[$i])
		Global $keynum= $atool[0][0] ; Ԫ������
		
;~ 		Local $keynames[$keynum]
		Global $item_GroupList[0]  
		Global $item_AllowIP[0]    
		Global $item_Users[0]       
		Global $item_Logic[0]    
		
		;;;;;;;;;����Ԫ��������Ҫ���жϷǿ�
		
		
		;�Ƚ����߼�����
		Global $this_tool=$aArray[$i] ;��ǰ�Ĺ�����
		Global $this_logic=IniRead($PROFILEPATH,$this_tool,"Logic","non-existent")
		If $this_logic=="" Then 
			MsgBox(0,"",$this_tool &"�������߼�����")
			ContinueLoop ;Ϊ���ֱ����������ѭ��
		EndIf
	
		;**************************************************************************************************
		$Logic_result=Do_logic($this_logic,$this_tool)
;~ 		MsgBox(0,"",$this_tool & "�߼�������"& $Logic_result)
		If $Logic_result Then  
			$AccesstoolsNum+=1
			_ArrayAdd($AccessTools,$this_tool)
;~ 			MsgBox(0,"",$this_tool)%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;~ 			$this_CommandText=IniRead($PROFILEPATH,$this_tool,"CommandText","non-existent")
;~ 			$this_Describet=IniRead($PROFILEPATH,$this_tool,"Describe","non-existent")

			Global $this_Ico=""
			Global $this_CommandText=""
			Global $this_Describe=""
			Global $this_Category=""
			Read_Ico_CommandText_Describe_Category($this_Ico,$this_CommandText,$this_Describe,$this_Category)


			_ArrayAdd($AccessIco,$this_Ico)
			_ArrayAdd($AccessCommandText,$this_CommandText)
			_ArrayAdd($AccessDescribe,$this_Describe)
			_ArrayAdd($AccessCategory,$this_Category)
		EndIf
		
		;**************************************************************************************************
		Next

;~ 	MsgBox(0,"",$AccesstoolsNum)

    ;^^^^^^^^^
;~ 	_ArrayDisplay($AccessTools) ;��ʾ�����û��ɷ��ʵĹ���
;~ 	_ArrayDisplay($AccessCommandText) ;��ʾ�����û��ɷ��ʵ�����
;~ 	_ArrayDisplay($AccessDescribe) ;��ʾ�����û��ɷ��ʵ�����
EndFunc   


Func Read_Ico_CommandText_Describe_Category(ByRef $this_Ico , ByRef $this_CommandText , ByRef $this_Describe , ByRef $this_Category)
	For $j=1  To $keynum
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		
		If  StringInStr($keyname,"ico") And $keyvalue<>"" Then $this_Ico=$keyvalue
		If  StringInStr($keyname,"CommandText") And $keyvalue<>"" Then $this_CommandText=$this_CommandText&$keyvalue&"***thisisanotherline***"
;~ 			If StringInStr($keyvalue,"\n") Then
;~ 				MsgBox(0,"","������forbid����\n�ַ�������ϵ�޸Ĵ������壡")
;~ 				Exit
;~ 			Else
;~ 				$this_CommandText=$this_CommandText&$keyvalue&"|thisisanotherline|"
;~ 			EndIf
;~ 		EndIf
		
		If  StringInStr($keyname,"Describe") And $keyvalue<>"" Then $this_Describe=$this_Describe&$keyvalue&"***thisisanotherline***"
;~ 			If StringInStr($keyvalue,"\n") Then
;~ 				MsgBox(0,"","������forbid����\n�ַ�������ϵ�޸Ĵ������壡")
;~ 				Exit
;~ 			Else
;~ 				$this_Describe=$this_Describe&$keyvalue&"|thisisanotherline|"
;~ 			EndIf
;~ 		EndIf
		
		If  StringInStr($keyname,"Category") And $keyvalue<>"" And $this_Category==""  Then  
			$this_Category=$keyvalue
		ElseIf StringInStr($keyname,"Category") And $keyvalue<>"" And $this_Category<>"" Then
			MsgBox(0,"",$this_tool&"��Categoty�ظ�����")
			Exit
		EndIf
		

	Next
	
	
EndFunc

Func Do_logic($this_logic,$this_tool)
	; ~��  &��  |��
	Local $tmp_arr=StringSplit($this_logic,"&|")  
	
	;������������߼��ַ��������������ܵ��߼��ؼ��ַ���һά���飬��ȥ���ո�
	Local $item_Logic_arr[0] ;��logic����ַŵ��������У���ʼ����0
	
	
	For  $i=1 To $tmp_arr[0] 			
		$item=StringStripWS($tmp_arr[$i],8);8����ɾ�����пո�
		If $item <> "" Then _ArrayAdd($item_Logic_arr,$item) ;�жϵ�һ�ؼ��ַǿգ�����һ�Ĺؼ��ַ���һά����
		
	Next
	
;~ 	MsgBox(0,"",UBound($item_Logic_arr,1)) ;
	
;~ 	_ArrayDisplay($item_Logic_arr) ;��ʾ�����ؼ�����
	Local $Logic_returns[0] ;�����߼�����ķ���ֵ
	
	For $item In $item_Logic_arr
		Switch $item
			Case "GroupList"
				_ArrayAdd($Logic_returns,Do_logic_GroupList())
			Case "~GroupList" 
				_ArrayAdd($Logic_returns,Not Do_logic_GroupList())
			Case "AllowIP"
				_ArrayAdd($Logic_returns,Do_logic_AllowIP())
			Case "~AllowIP" 
				_ArrayAdd($Logic_returns,Not Do_logic_AllowIP())
			Case "Users"
				_ArrayAdd($Logic_returns,Do_logic_Users())
			Case "~Users" 
				_ArrayAdd($Logic_returns,Not Do_logic_Users())
			Case Else
				MsgBox(0,"",$this_tool&"���߼��ؼ��ʶ������")
				Exit
		EndSwitch
	Next
	;**************************************************************************************************
;~ 	_ArrayDisplay($Logic_returns)
	;**************************************************************************************************
	
	$item_Logic_arr_lenth=UBound($item_Logic_arr,1)
	Switch $item_Logic_arr_lenth ;��logic��Ԫ�ظ��������ж�
		Case 1
			Return $Logic_returns[0] 
		Case 2
			Local $tmp_arr_operator=StringSplit($this_logic,$tmp_arr[1] ,1) ;�Ե�һ���ؼ���Ϊ�ָ�
			$operator=StringLeft(StringStripWS($tmp_arr_operator[2],8),1);8����ɾ�����пո� ,ȡ�ڶ����Ұ�ߵ�����ĸ
			If $operator=="&" Then
				Return $Logic_returns[0] And $Logic_returns[1]
			ElseIf $operator=="|" Then
				;^^^^^^^^^
;~ 				MsgBox(0,"",$Logic_returns[0])
;~ 				MsgBox(0,"",$Logic_returns[1])
				;^^^^^^^^^
				Return ($Logic_returns[0] Or $Logic_returns[1])
			EndIf
		Case 3
			Local $tmp_arr_operator=StringSplit($this_logic,$tmp_arr[1] ,1) ;�Ե�һ���ؼ���Ϊ�ָ�
			$operator=StringLeft(StringStripWS($tmp_arr_operator[2],8),1);8����ɾ�����пո� ,ȡ�ڶ����Ұ�ߵ�����ĸ
			If $operator=="&" Then
				$step1_result= $Logic_returns[0] And $Logic_returns[1]
			ElseIf $operator=="|" Then
				$step1_result= ($Logic_returns[0] Or $Logic_returns[1])
			EndIf
			
			Local $tmp_arr_operator=StringSplit($this_logic,$tmp_arr[2] ,1) ;�Եڶ����ؼ���Ϊ�ָ�
			$operator=StringLeft(StringStripWS($tmp_arr_operator[2],8),1);8����ɾ�����пո� ,ȡ�ڶ����Ұ�ߵ�����ĸ
			If $operator=="&" Then
				Return $step1_result And $Logic_returns[2]
			ElseIf $operator=="|" Then
				Return ($step1_result Or $Logic_returns[2])
			EndIf
		Case Else
			MsgBox(0,"",$this_tool &"�߼��ж�Ԫ�ع���")
			Exit
	EndSwitch

EndFunc

Func Do_logic_GroupList()

	For $j=1  To $keynum
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		If  StringInStr($keyname,"GroupList") And $keyvalue<>"" Then _ArrayAdd($item_GroupList,StringUpper($keyvalue))
	Next
	
	If UBound($item_GroupList,1)==0 Then Return False ;Exit MsgBox(0,"","["& $this_tool & "]�µ�GroupList����Ϊ��")
	$GroupList=$item_GroupList
	For $i In $GroupList 
		For $j In $myGgroup
			If $i==$j Then Return True  ;����н������������档˵���û��ڶ��������
		Next
	Next
	
	Return False			
EndFunc



Func Pow($num,$powTimes)
	$powInt=1
	For $i=1 To $powTimes
		$powInt*=$num
	Next
	Return $powInt
EndFunc


Func IP2Long($this_ip) ;IPת��Ϊ������
	Local $ip_arr=StringSplit($this_ip,".",1)
	Local $ip_num=0
	
	For $i=$ip_arr[0] To 1  Step -1
		$ip_num+= Mod(Int($ip_arr[$i]),256)  * Pow(256,(4-$i))
	Next
	Return $ip_num
EndFunc


Func Do_logic_AllowIP()
	;������Ԫ�ط�������
	For $j=1  To $keynum
;~ 			_ArrayAdd($keynames,$atool)
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		If  StringInStr($keyname,"AllowIP") And $keyvalue<>"" Then _ArrayAdd($item_AllowIP,$keyvalue)
	Next
	;�ж�IP���������ǿ�
	If UBound($item_AllowIP,1)==0 Then Return False ;Exit MsgBox(0,"","["& $this_tool & "]�µ�AllowIP����Ϊ��")
	$AllowIP=$item_AllowIP
	
	;�ͱ���IP�����߼��Ա�����
	$ip_arr=StringSplit($ip,".",1)
	For $item In $AllowIP 
		$item_tmp_arr=StringSplit($item,"-")
		$left=$item_tmp_arr[1]
		$right=$item_tmp_arr[2]
		
		If $left==$right And $left==$ip   Then Return True  ;����޶�Ϊ��IP���ҷ����򷵻���
		
		If IP2Long($left)<=IP2Long($ip) And IP2Long($ip)<=IP2Long($right) Then Return True  ;����޶�Ϊ��ΧIP���ҵ�ǰIP�ڷ�Χ���򷵻���
		
	Next
	
	Return False
EndFunc


Func Do_logic_Users()
	
	For $j=1  To $keynum
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		If  StringInStr($keyname,"Users") And $keyvalue<>"" Then _ArrayAdd($item_Users,StringUpper($keyvalue))		
	Next
	
	If UBound($item_Users,1)==0 Then Return False ;Exit MsgBox(0,"","["& $this_tool & "]�µ�Users����Ϊ��")
	$Users=$item_Users 
	
	
	For $item In $Users 
		$item=StringUpper($item)
;~ 		MsgBox(0,"","item:"&$item)
		If $item==$username Then  Return True
	Next
	
	Return False
EndFunc


