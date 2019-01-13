#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile_x64=Y:\DirectX_Repair.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include<math.au3>
judgeLocation()

Func judgeLocation()
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		ShellExecute("\\ITTOOL_node2\ITTOOLS\SoftwareDeploy\DirectX Repair V3.3 (Enhanced Edition)\DirectX Repair.exe","open" )
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
		ShellExecute("\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\DirectX Repair V3.3 (Enhanced Edition)\DirectX Repair.exe","open" )
	EndIf
	
;~ 	MsgBox(0,"",$location)
EndFunc







#CS

['    DirectX Repair']
ico = 
Describe = 修复因缺少系统组件导致的战网游戏客户端无法运行问题。windows组件补丁集合。
Category = 战网客户端同步
CommandText  = "\\ITTOOL_node2\ITTOOLS\SoftwareDeploy\DirectX Repair V3.3 (Enhanced Edition)\DirectX Repair.exe"  

Logic=  GroupList 
GroupList = ITBAT_CLIENT_WOWGM
GroupList = ITBAT_CLIENT_WOWNORMAL
GroupList = ITBAT_CLIENT_OW
GroupList = ITBAT_CLIENT_D3
GroupList = ITBAT_CLIENT_HEROES
GroupList = ITBAT_CLIENT_HEARTHSTONE
GroupList = ITBAT_CLIENT_SC2

#CE

;