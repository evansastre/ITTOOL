#include <MsgBoxConstants.au3>
#include <Sound.au3>

Local $aSound = _SoundOpen(@WindowsDir & "\media\tada.wav")
If @error = 2 Then
    MsgBox($MB_SYSTEMMODAL, "错误", "该文件不存在")
    Exit
ElseIf @extended <> 0 Then
    Local $iExtended = @extended ; DllCall 之后将为 @extended 赋值.
    Local $tText = DllStructCreate("char[128]")
    DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
    MsgBox($MB_SYSTEMMODAL, "错误", "打开文件失败." & @CRLF & "错误号码: " & $iExtended & @CRLF & "错误描述: " & DllStructGetData($tText, 1) & @CRLF & "请注意: 声音文件仍然可以正常播放.")
Else
    MsgBox($MB_SYSTEMMODAL, "成功", "成功打开该文件")
EndIf

ConsoleWrite("声音打开以后: " & _SoundStatus($aSound) & @CRLF)

_SoundPlay($aSound)
ConsoleWrite("声音播放以后: " & _SoundStatus($aSound) & @CRLF)

Sleep(1000)

_SoundPause($aSound)
ConsoleWrite("声音暂停以后: " & _SoundStatus($aSound) & @CRLF)

Sleep(1000)
_SoundResume($aSound)

While 1
    Sleep(100)
    If _SoundPos($aSound, 2) = _SoundLength($aSound, 2) Then ExitLoop
WEnd

_SoundClose($aSound)
