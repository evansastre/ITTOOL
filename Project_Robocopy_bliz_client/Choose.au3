#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\������վ\������վ.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <IE.au3>
#include <Array.au3>




Func InputWindow()

	Global $now_choose_tool
	
	Opt("GUIOnEventMode", 1)
	FileInstall(".\corpname.ico", @TempDir & "\corpname.ico", 1);����ͼ��
	

	
	
		#region ### START Koda GUI section ### Form=

	Global $FORM1 = GUICreate("ս���ͻ���ͬ��״̬�鿴", 300, 180, -1 , -1)
	GUISetIcon(@TempDir & "\corpname.ico")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")
	
	$TIP_LABEL = GUICtrlCreateLabel("��ѡ��Ҫ�鿴�Ŀͻ���ͬ��״̬", 8, 8, 220, 23) ;��̬tip��
	GUICtrlSetFont(-1, 10, 800, 0, "΢���ź�")

	
	Global $myipaddress = GUICtrlCreateCombo("", 50, 45, 200, 20,3) ;��ַ�����
	GUICtrlSetData(-1, "Diablo III CN|Hearthstone|Heroes of the Storm|Overwatch|StarCraft_II|World of Warcraft|all", "all")

	
	
    Global $CONFIRMBUTTON = GUICtrlCreateButton("Confirm", 50, 122, 73, 25) ;ConfirmButton
	GUICtrlSetOnEvent($CONFIRMBUTTON ,"Confirm")
	
	
	Global $CANCELBUTTON = GUICtrlCreateButton("Cancel", 178, 122, 73, 25) ;CancelButton
	GUICtrlSetOnEvent($CANCELBUTTON ,"Cancel")
	
	
	GUISetState(@SW_SHOW)

;~ 	GUICtrlSetState($myipaddress,$GUI_FOCUS  ) ;���ñ༭����
	#endregion ### END Koda GUI section ###

	Global $stop=False
	While Not $stop
		Sleep(100) ; ����, �Խ��� CPU ʹ����
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
