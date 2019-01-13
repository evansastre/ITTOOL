#include <AD.au3>
#include <Array.au3>
#include <Math.au3>
#include <Timers.au3> ;计算运行时间



;~ getConf()
Func getConf()
	
	get_MyADPriv()
	get_AccessTools()
;~ 	Sleep(2000);留作显示载入动画
	
EndFunc

Func get_MyADPriv() ;读取个人权限,获取到当前用户的安全组、IP、用户名
	
	Global $myGgroup[1]=["DOMAIN USERS"]  ;下方的函数不会将domain users作为所属组，所以初始化时直接赋值一下
	Global $ip=@IPAddress1
	Global $username=StringUpper(@UserName)

	_AD_Open()
	If @error Then Exit MsgBox(16, "警告", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended & @LF & "当前登录账号可能并非域账号，或账号状态异常")

	; 返回用户所属的组
	Global $aUser = _AD_RecursiveGetMemberOf(@UserName, 10, 1)
	If @error > 0 Then
		MsgBox(64, "", "用户 '" & @UserName & "' 不属于任何域内安全组")
		Exit
	Else
;~ 		_ArrayDisplay($aUser, "Active Directory Functions - Example 1 - Group names user '" & @UserName & "' is a member of")
		$NUM=$aUser[0]
		
		For $i=1 To $NUM 
			;对DN进行处理，取出group的字段
			$tmp_arr=StringSplit($aUser[$i],",",1)
			$group=$tmp_arr[1]
			$tmp_arr2=StringSplit($group,"=",1)
			$group=$tmp_arr2[2]
			_ArrayAdd($myGgroup,StringUpper($group))  ;注意统一为大写
;~ 				MsgBox(0,"",$group)
		Next
	EndIf
	; 关闭AD
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


Func get_AccessTools() ;获取可用工具列表
	
	Global $mylocation=judgeLocation()
	Global $server_itbat_dir
	
	If $mylocation=='HZ' Then
		$server_itbat_dir = "\\ITTOOL_node1\ITTOOLS\Conf\ITbat\"
	ElseIf $mylocation=='SH' Then
		$server_itbat_dir = "\\ITTOOL_node2\ITTOOLS\Conf\ITbat\"
	EndIf
	
	
	Global $PROFILEPATH = $server_itbat_dir & "ITTOOL.ini"
	$aArray = IniReadSectionNames($PROFILEPATH) ;读取所有的工具名
	If @error<>0 Then 
		MsgBox(0,"","配置文件有错，请联系IT处理")
		Return -1
	EndIf



	Global  $TotalNum = $aArray[0] ; 工具总数
	Global  $ToolNames[$TotalNum];工具名称，即每个字段名称
	Global  $AccesstoolsNum=0 ;用户有权限访问的工具集
	Global  $AccessTools[0] ;用户有权限访问的工具集
	Global  $AccessIco[0] ;用户有权限访问的工具图标
	Global  $AccessCommandText[0] ;用户有权限访问的工具命令
	Global  $AccessDescribe[0] ;用户有权限访问的工具描述
	Global  $AccessCategory[0] ;用户有权限访问的工具类型
	
	Local $aArrayUnique[0] ;用来存储唯一的工具名，临时检测重复用
	For $i = 1 To $TotalNum
		_ArrayFindAll ($aArrayUnique,$aArray[$i])
		If @error<>0 Then
			_ArrayAdd($aArrayUnique,$aArray[$i])
		Else
			MsgBox(0,"",$aArray[$i]&"工具定义重名了")
			Exit
		EndIf
		
;~ 		$ToolNames[$i-1] = $aArray[$i];工具名称，即每个字段名称
;~ 		MsgBox(0,"",$aArray[$i])%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		If $aArray[$i]=="" Then
			MsgBox(0,"","第"&$i&"个工具没有定义名称")
			Exit
		EndIf
		
		
		
		;
		Global $atool = IniReadSection($PROFILEPATH,$aArray[$i])
		Global $keynum= $atool[0][0] ; 元素总数
		
;~ 		Local $keynames[$keynum]
		Global $item_GroupList[0]  
		Global $item_AllowIP[0]    
		Global $item_Users[0]       
		Global $item_Logic[0]    
		
		;;;;;;;;;单个元素数组需要被判断非空
		
		
		;先进行逻辑运算
		Global $this_tool=$aArray[$i] ;当前的工具名
		Global $this_logic=IniRead($PROFILEPATH,$this_tool,"Logic","non-existent")
		If $this_logic=="" Then 
			MsgBox(0,"",$this_tool &"不存在逻辑定义")
			ContinueLoop ;为否后直接跳出本次循环
		EndIf
	
		;**************************************************************************************************
		$Logic_result=Do_logic($this_logic,$this_tool)
;~ 		MsgBox(0,"",$this_tool & "逻辑运算结果"& $Logic_result)
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
;~ 	_ArrayDisplay($AccessTools) ;显示所有用户可访问的工具
;~ 	_ArrayDisplay($AccessCommandText) ;显示所有用户可访问的命令
;~ 	_ArrayDisplay($AccessDescribe) ;显示所有用户可访问的描述
EndFunc   


Func Read_Ico_CommandText_Describe_Category(ByRef $this_Ico , ByRef $this_CommandText , ByRef $this_Describe , ByRef $this_Category)
	For $j=1  To $keynum
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		
		If  StringInStr($keyname,"ico") And $keyvalue<>"" Then $this_Ico=$keyvalue
		If  StringInStr($keyname,"CommandText") And $keyvalue<>"" Then $this_CommandText=$this_CommandText&$keyvalue&"***thisisanotherline***"
;~ 			If StringInStr($keyvalue,"\n") Then
;~ 				MsgBox(0,"","定义中forbid出现\n字符，请联系修改此条定义！")
;~ 				Exit
;~ 			Else
;~ 				$this_CommandText=$this_CommandText&$keyvalue&"|thisisanotherline|"
;~ 			EndIf
;~ 		EndIf
		
		If  StringInStr($keyname,"Describe") And $keyvalue<>"" Then $this_Describe=$this_Describe&$keyvalue&"***thisisanotherline***"
;~ 			If StringInStr($keyvalue,"\n") Then
;~ 				MsgBox(0,"","定义中forbid出现\n字符，请联系修改此条定义！")
;~ 				Exit
;~ 			Else
;~ 				$this_Describe=$this_Describe&$keyvalue&"|thisisanotherline|"
;~ 			EndIf
;~ 		EndIf
		
		If  StringInStr($keyname,"Category") And $keyvalue<>"" And $this_Category==""  Then  
			$this_Category=$keyvalue
		ElseIf StringInStr($keyname,"Category") And $keyvalue<>"" And $this_Category<>"" Then
			MsgBox(0,"",$this_tool&"处Categoty重复定义")
			Exit
		EndIf
		

	Next
	
	
EndFunc

Func Do_logic($this_logic,$this_tool)
	; ~非  &与  |或
	Local $tmp_arr=StringSplit($this_logic,"&|")  
	
	;处理单挑定义的逻辑字符串，将单条功能的逻辑关键字放入一维数组，并去除空格
	Local $item_Logic_arr[0] ;将logic串拆分放到此数组中，初始个数0
	
	
	For  $i=1 To $tmp_arr[0] 			
		$item=StringStripWS($tmp_arr[$i],8);8代表删除所有空格
		If $item <> "" Then _ArrayAdd($item_Logic_arr,$item) ;判断单一关键字非空，将单一的关键字放入一维数组
		
	Next
	
;~ 	MsgBox(0,"",UBound($item_Logic_arr,1)) ;
	
;~ 	_ArrayDisplay($item_Logic_arr) ;显示单条关键字组
	Local $Logic_returns[0] ;定义逻辑运算的返回值
	
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
				MsgBox(0,"",$this_tool&"处逻辑关键词定义错误")
				Exit
		EndSwitch
	Next
	;**************************************************************************************************
;~ 	_ArrayDisplay($Logic_returns)
	;**************************************************************************************************
	
	$item_Logic_arr_lenth=UBound($item_Logic_arr,1)
	Switch $item_Logic_arr_lenth ;对logic的元素个数进行判断
		Case 1
			Return $Logic_returns[0] 
		Case 2
			Local $tmp_arr_operator=StringSplit($this_logic,$tmp_arr[1] ,1) ;以第一个关键词为分割
			$operator=StringLeft(StringStripWS($tmp_arr_operator[2],8),1);8代表删除所有空格 ,取第二即右半边的首字母
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
			Local $tmp_arr_operator=StringSplit($this_logic,$tmp_arr[1] ,1) ;以第一个关键词为分割
			$operator=StringLeft(StringStripWS($tmp_arr_operator[2],8),1);8代表删除所有空格 ,取第二即右半边的首字母
			If $operator=="&" Then
				$step1_result= $Logic_returns[0] And $Logic_returns[1]
			ElseIf $operator=="|" Then
				$step1_result= ($Logic_returns[0] Or $Logic_returns[1])
			EndIf
			
			Local $tmp_arr_operator=StringSplit($this_logic,$tmp_arr[2] ,1) ;以第二个关键词为分割
			$operator=StringLeft(StringStripWS($tmp_arr_operator[2],8),1);8代表删除所有空格 ,取第二即右半边的首字母
			If $operator=="&" Then
				Return $step1_result And $Logic_returns[2]
			ElseIf $operator=="|" Then
				Return ($step1_result Or $Logic_returns[2])
			EndIf
		Case Else
			MsgBox(0,"",$this_tool &"逻辑判断元素过多")
			Exit
	EndSwitch

EndFunc

Func Do_logic_GroupList()

	For $j=1  To $keynum
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		If  StringInStr($keyname,"GroupList") And $keyvalue<>"" Then _ArrayAdd($item_GroupList,StringUpper($keyvalue))
	Next
	
	If UBound($item_GroupList,1)==0 Then Return False ;Exit MsgBox(0,"","["& $this_tool & "]下的GroupList定义为空")
	$GroupList=$item_GroupList
	For $i In $GroupList 
		For $j In $myGgroup
			If $i==$j Then Return True  ;如果有交集，即返回真。说明用户在定义的组内
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


Func IP2Long($this_ip) ;IP转换为整型数
	Local $ip_arr=StringSplit($this_ip,".",1)
	Local $ip_num=0
	
	For $i=$ip_arr[0] To 1  Step -1
		$ip_num+= Mod(Int($ip_arr[$i]),256)  * Pow(256,(4-$i))
	Next
	Return $ip_num
EndFunc


Func Do_logic_AllowIP()
	;将条件元素放入数组
	For $j=1  To $keynum
;~ 			_ArrayAdd($keynames,$atool)
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		If  StringInStr($keyname,"AllowIP") And $keyvalue<>"" Then _ArrayAdd($item_AllowIP,$keyvalue)
	Next
	;判断IP允许的数组非空
	If UBound($item_AllowIP,1)==0 Then Return False ;Exit MsgBox(0,"","["& $this_tool & "]下的AllowIP定义为空")
	$AllowIP=$item_AllowIP
	
	;和本机IP进行逻辑对比运算
	$ip_arr=StringSplit($ip,".",1)
	For $item In $AllowIP 
		$item_tmp_arr=StringSplit($item,"-")
		$left=$item_tmp_arr[1]
		$right=$item_tmp_arr[2]
		
		If $left==$right And $left==$ip   Then Return True  ;如果限定为单IP，且符合则返回真
		
		If IP2Long($left)<=IP2Long($ip) And IP2Long($ip)<=IP2Long($right) Then Return True  ;如果限定为范围IP，且当前IP在范围内则返回真
		
	Next
	
	Return False
EndFunc


Func Do_logic_Users()
	
	For $j=1  To $keynum
		$keyname=$atool[$j][0]
		$keyvalue=$atool[$j][1]
		If  StringInStr($keyname,"Users") And $keyvalue<>"" Then _ArrayAdd($item_Users,StringUpper($keyvalue))		
	Next
	
	If UBound($item_Users,1)==0 Then Return False ;Exit MsgBox(0,"","["& $this_tool & "]下的Users定义为空")
	$Users=$item_Users 
	
	
	For $item In $Users 
		$item=StringUpper($item)
;~ 		MsgBox(0,"","item:"&$item)
		If $item==$username Then  Return True
	Next
	
	Return False
EndFunc


