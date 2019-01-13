#Include <GUIConstantsEx.au3>

#Include <UDFs\GUICtrlSetOnHover.au3>
#Include <UDFs\Icons.au3>

Opt('MustDeclareVars', 0)
Opt("GUIOnEventMode", 1)

Global $Hold = False

$hForm = GUICreate('GUICtrlSetOnHover & Icons UDFs Demonstration', 1050, 500)
$Back = GUICtrlCreatePic(@ScriptDir & '\Images\background.bmp', 0, 0, 1050, 500)
GUICtrlSetState(-1, $GUI_DISABLE)

$ButtonPrev = GUICtrlCreatePic('', 452, 370, 64, 64)
GUICtrlSetOnEvent(-1,"_exit")
GUICtrlSetOnHover(-1, '_Hover', '_Leave', '_Down', '_Up')
$ButtonNext = GUICtrlCreatePic('', 535, 370, 64, 64)
GUICtrlSetOnHover(-1, '_Hover', '_Leave', '_Down', '_Up')


$Pic1 = GUICtrlCreatePic('', 82, 70, 256, 256)
GUICtrlSetOnEvent(-1,"Pic1")
GUICtrlSetOnHover(-1, '_Hover', '_Leave')


$Pic2 = GUICtrlCreatePic('', 397, 70, 256, 256)
GUICtrlSetOnHover(-1, '_Hover', '_Leave')
$Pic3 = GUICtrlCreatePic('', 712, 70, 256, 256)
GUICtrlSetOnHover(-1, '_Hover', '_Leave')

For $i = $ButtonPrev To $Pic3
	_Leave($i)
Next

GUISetState()

While 1
	Sleep(100)
WEnd

Func _exit()
	Exit
EndFunc

Func Pic1()
	$File = 'pic1_hover.png'
	_SetImage($Pic1, @ScriptDir & '\Images\' & $File, $Back)
EndFunc


Func _Down($CtrlID)

	If $Hold Then
		Return
	Else
		$Hold = True
	EndIf

	Local $File

	Switch $CtrlID
		Case $ButtonPrev
			$File = 'button_prev_down.png'
		Case $ButtonNext
			$File = 'button_next_down.png'
	EndSwitch
	_SetImage($CtrlID, @ScriptDir & '\Images\' & $File, $Back)
EndFunc   ;==>_Down

Func _Leave($CtrlID)

	Local $File

	Switch $CtrlID
		Case $ButtonPrev
			$File = 'button_prev.png'
		Case $ButtonNext
			$File = 'button_next.png'
		Case $Pic1
			$File = 'pic1.png'
		Case $Pic2
			$File = 'pic2.png'
		Case $Pic3
			$File = 'pic3.png'
	EndSwitch
	_SetImage($CtrlID, @ScriptDir & '\Images\' & $File, $Back)
	$Hold = False
EndFunc   ;==>_Leave

Func _Hover($CtrlID)

	Local $File

	Switch $CtrlID
		Case $ButtonPrev
			$File = 'button_prev_hover.png'
		Case $ButtonNext
			$File = 'button_next_hover.png'
		Case $Pic1
			$File = 'pic1_hover.png'
		Case $Pic2
			$File = 'pic2_hover.png'
		Case $Pic3
			$File = 'pic3_hover.png'
	EndSwitch
	_SetImage($CtrlID, @ScriptDir & '\Images\' & $File, $Back)
	$Hold = False
EndFunc   ;==>_Hover

Func _Up($CtrlID)
	_Hover($CtrlID)
EndFunc   ;==>_Up
