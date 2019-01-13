#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\常用网站\常用网站.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <IE.au3>
#include <Array.au3>


;~ InputWindow()

Func InputWindow()
	Global $ChosenAddress
	Global $now_choose_tool
	Global $myports="1119"
	
	FileInstall(".\tools\NetTestPro_ips.ini",@TempDir & "\NetTestPro_ips.ini",1)
	Opt("GUIOnEventMode", 1)
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1);附带图标
	
	Global $Addrs =  @TempDir & "\NetTestPro_ips.ini"
	Global $iniInfo_arr[0]
	Global $iniInfo_PS_arr[0]
	
	Init_iniInfo_arr($Addrs)   ;初始化说明文字
		#region ### START Koda GUI section ### Form=

	Global $FORM1 = GUICreate("战网游戏测试", 300, 180, -1 , -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")
	
	$TIP_LABEL = GUICtrlCreateLabel("请选择或输入需要要测试的地址", 8, 8, 220, 23) ;静态tip栏
	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")

	
	Global $myipaddress = GUICtrlCreateCombo("", 50, 45, 200, 20) ;地址输入框
	GUICtrlSetOnEvent($myipaddress ,"change_select_addrs")
	GUICtrlSetData(-1,getAvailableParameter($Addrs), "")
	Global $LABEL2 = GUICtrlCreateLabel("" , 50, 75, 170, 20);动态tip栏	
	
	
    Global $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 50, 122, 73, 25) ;ConfirmButton
	GUICtrlSetOnEvent($CONFIRMBUTTON ,"Confirm")
	
	
	Global $CANCELBUTTON = GUICtrlCreateButton("Cancel", 178, 122, 73, 25) ;CancelButton
	GUICtrlSetOnEvent($CANCELBUTTON ,"Cancel")
	
;~ 	change_select() ;此处起初始化文字tip作用
	
	GUISetState(@SW_SHOW)

	GUICtrlSetState($myipaddress,$GUI_FOCUS  ) ;设置编辑焦点
	#endregion ### END Koda GUI section ###

	Global $stop=False
	While Not $stop
		Sleep(100) ; 休眠, 以降低 CPU 使用率
	WEnd

EndFunc  



Func Init_iniInfo_arr($filename)		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. @error: " & @error) ; 读取当前脚本文件时发生错误.
	Else
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			$tmparr=StringSplit($aArray[$i],"pss:",1)
			If UBound($tmparr)>1 Then
				$info=StringStripWS($tmparr[1],2);stringstripws用于删除字符串右边的空格
				_ArrayAdd($iniInfo_arr,$info)
				$info_PS=StringStripWS($tmparr[2],2);stringstripws用于删除字符串右边的空格
				_ArrayAdd($iniInfo_PS_arr,$info_PS)
			EndIf
		Next
		
	EndIf

EndFunc

Func getAvailableParameter($filename)
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. @error: " & @error) ; 读取当前脚本文件时发生错误.
	Else
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			$tmparr=StringSplit($aArray[$i],"pss:",1)
			If UBound($tmparr)>1 Then
				$item=StringStripWS($tmparr[1],2);stringstripws用于删除字符串右边的空格
			Else
				$item=$aArray[$i]
			EndIf
			$String_AvailableAddrs= $String_AvailableAddrs & "|" & $item 
		Next
	EndIf
	Return $String_AvailableAddrs
EndFunc

Func change_select_addrs()
	$now_choose_tool=GUICtrlRead($myipaddress)
	
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)
	If @error <> 0 Then 
		$PS=$now_choose_tool 
	Else
		$PS=$iniInfo_PS_arr[$locat[0]]	
	EndIf
	GUICtrlSetData($LABEL2, $PS  )
EndFunc


Func Confirm_addrs()
	$now_choose_tool=GUICtrlRead($myipaddress)
	$locat=_ArrayFindAll($iniInfo_arr,$now_choose_tool)
	If @error <> 0 Then 
		$PS=$now_choose_tool 
	Else
		$PS=$iniInfo_PS_arr[$locat[0]]	
	EndIf
	
	
	If $now_choose_tool=="炉石传说" Or $now_choose_tool=="守望先锋" Then
		$myports="3724"
	EndIf
	
;~ 	MsgBox(0,"",$myports)
	
   ;炉石和守望的端口为3724  其他为1119
	
	Return $PS
EndFunc

Func Confirm()
	$ChosenAddress = Confirm_addrs()
	change_select_addrs() ; ip栏的显示

	GUIDelete($FORM1)
	$stop=True
	
;~ 	MsgBox(0,"",$now_choose_tool)
;~ 	Exit
	
	Return

EndFunc

Func Cancel()
	GUIDelete($FORM1)
	WO_rec("常用网站")
	Exit
EndFunc

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
