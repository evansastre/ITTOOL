Global Const $OCR_APPSTARTING = 32650
Global Const $OCR_NORMAL = 32512
Global Const $OCR_CROSS = 32515
Global Const $OCR_HAND = 32649
Global Const $OCR_IBEAM = 32513
Global Const $OCR_NO = 32648
Global Const $OCR_SIZEALL = 32646
Global Const $OCR_SIZENESW = 32643
Global Const $OCR_SIZENS = 32645
Global Const $OCR_SIZENWSE = 32642
Global Const $OCR_SIZEWE = 32644
Global Const $OCR_UP = 32516
Global Const $OCR_WAIT = 32514

;~ _SetCursor(@WindowsDir & "\cursors\3dgarro.cur", $OCR_NORMAL)
;~ _SetCursor(@WindowsDir & "\cursors\3dwarro.cur", $OCR_NORMAL)

Global $select_ico=@TempDir & "\itbat_materials\normal select.ani"
_SetCursor($select_ico, $OCR_HAND)

;==================================================================
; $s_file - file to load cursor from
; $i_cursor - system cursor to change
;==================================================================
Func _SetCursor($s_file, $i_cursor)
   Local $newhcurs, $lResult
   $newhcurs = DllCall("user32.dll", "int", "LoadCursorFromFile", "str", $s_file)
   If Not @error Then
      $lResult = DllCall("user32.dll", "int", "SetSystemCursor", "int", $newhcurs[0], "int", $i_cursor)
      If Not @error Then
         $lResult = DllCall("user32.dll", "int", "DestroyCursor", "int", $newhcurs[0])
      Else
         MsgBox(0, "Error", "Failed SetSystemCursor")
      EndIf
   Else
      MsgBox(0, "Error", "Failed LoadCursorFromFile")
   EndIf
EndFunc  ;==>_SetCursor