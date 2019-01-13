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




Func InputWindow()

	Global $now_choose_tool
	
	Opt("GUIOnEventMode", 1)
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1);附带图标
	

	
	
		#region ### START Koda GUI section ### Form=

	Global $FORM1 = GUICreate("战网客户端同步状态查看", 300, 180, -1 , -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")
	
	$TIP_LABEL = GUICtrlCreateLabel("请选择要查看的客户端同步状态", 8, 8, 220, 23) ;静态tip栏
	GUICtrlSetFont(-1, 10, 800, 0, "微软雅黑")

	
	Global $myipaddress = GUICtrlCreateCombo("", 50, 45, 200, 20,3) ;地址输入框
	GUICtrlSetData(-1, "Diablo III CN|Hearthstone|Heroes of the Storm|Overwatch|StarCraft_II|World of Warcraft|all", "all")

	
	
    Global $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 50, 122, 73, 25) ;ConfirmButton
	GUICtrlSetOnEvent($CONFIRMBUTTON ,"Confirm")
	
	
	Global $CANCELBUTTON = GUICtrlCreateButton("Cancel", 178, 122, 73, 25) ;CancelButton
	GUICtrlSetOnEvent($CANCELBUTTON ,"Cancel")
	
	
	GUISetState(@SW_SHOW)

;~ 	GUICtrlSetState($myipaddress,$GUI_FOCUS  ) ;设置编辑焦点
	#endregion ### END Koda GUI section ###

	Global $stop=False
	While Not $stop
		Sleep(100) ; 休眠, 以降低 CPU 使用率
	WEnd

EndFunc  








Func Confirm()

	$now_choose_tool=GUICtrlRead($myipaddress)
	
	GUIDelete($FORM1)
	$stop=True
	
	Return

EndFunc

Func Cancel()
	GUIDelete($FORM1)
	Exit
EndFunc

Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc
