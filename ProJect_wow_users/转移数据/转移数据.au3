#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\ת������.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <GUIConstantsEx.au3>
#include <Excel.au3>
#include <Array.au3>
#include <GUIToolTip.au3>
#include "backup.au3"
#include "Recovery.au3"
#include "Sync.au3"
#include "runBat.au3"

MainWindow()
Func MainWindow()
	Opt("GUIOnEventMode", 1)
	Opt("GUIResizeMode", 1)
		#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("�û�����ת�ƹ���", 521, 150, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
	GUISetState(@SW_SHOW)

	$Button1 = GUICtrlCreateButton("����", 46, 36, 90, 65)
    GUICtrlSetOnEvent($Button1,"backup")
	Local $hButton1 = GUICtrlGetHandle($Button1)
    Local $hToolTip1 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip1, 0, "��װϵͳʱ�����ݱ����û����ݵ�E�̣�E�̿ռ䲻��ʱ��ѡ�����̷�", $hButton1)

	$Button2 = GUICtrlCreateButton("�ָ�", 198, 36, 90, 65)
	GUICtrlSetOnEvent($Button2,"Recovery")
	Local $hButton2 = GUICtrlGetHandle($Button2)
    Local $hToolTip2 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip2, 0, "����ʷ�ı����лָ��û�������", $hButton2)
	
	$Button3 = GUICtrlCreateButton("�»���ͬ��", 350, 36, 90, 65)
	GUICtrlSetOnEvent($Button3,"Sync")
	Local $hButton3 = GUICtrlGetHandle($Button3)
    Local $hToolTip3 = _GUIToolTip_Create(0)
    _GUIToolTip_AddTool($hToolTip3, 0, "��ԭ�����������������ݵ��»�", $hButton3)
	
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	
	While 1
		Sleep(100) ; ����, �Խ��� CPU ʹ����
	WEnd
	;��������Ϣģʽʵ�֣���ǰʹ���¼�ģʽ����ʹ����Ϣģʽ����Ҫע�͵��Ϸ� Opt("GUIOnEventMode", 1) �Լ�ÿ��GUISetOnEvent(), sleepѭ��
;~ 	While 1
;~ 		$nMsg = GUIGetMsg()
;~ 		Switch $nMsg
;~ 			Case $Button1
;~ 				backup()
;~ 				;ExitLoop
;~ 			Case $Button2
;~ 				Recovery()
;~ 				;ExitLoop
;~ 			Case $Button3
;~ 				Sync()
;~ 				;ExitLoop
;~ 			Case $GUI_EVENT_CLOSE
;~ 				ExitLoop
;~ 		EndSwitch
;~ 	WEnd
;~ 	
;~ 	_GUIToolTip_Destroy($hToolTip1)
;~ 	_GUIToolTip_Destroy($hToolTip2)
;~ 	_GUIToolTip_Destroy($hToolTip3)
;~     GUIDelete($Form1)

EndFunc

Func CLOSEButton()
    Exit
EndFunc 

Func WO_rec($myRec) ;ticket record
	
	$netuse = 'net use \\ITTOOL_node1\ITTOOLS_WO_rec '
	$rec_file = 'set rec="\\ITTOOL_node1\ITTOOLS_WO_rec\' & $myRec &'.txt"'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec = 'echo ' & @UserName & "   " & @ComputerName & "   " & $cur_Time & '>> %rec%'

	Global $command_rec[3] = [$netuse, $rec_file, $rec]
	runBat($command_rec)
	
EndFunc   ;==>WO_rec


