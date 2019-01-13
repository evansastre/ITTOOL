#include <MsgBoxConstants.au3>
#include <Sound.au3>

Local $aSound = _SoundOpen(@WindowsDir & "\media\tada.wav")
If @error = 2 Then
    MsgBox($MB_SYSTEMMODAL, "����", "���ļ�������")
    Exit
ElseIf @extended <> 0 Then
    Local $iExtended = @extended ; DllCall ֮��Ϊ @extended ��ֵ.
    Local $tText = DllStructCreate("char[128]")
    DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
    MsgBox($MB_SYSTEMMODAL, "����", "���ļ�ʧ��." & @CRLF & "�������: " & $iExtended & @CRLF & "��������: " & DllStructGetData($tText, 1) & @CRLF & "��ע��: �����ļ���Ȼ������������.")
Else
    MsgBox($MB_SYSTEMMODAL, "�ɹ�", "�ɹ��򿪸��ļ�")
EndIf

ConsoleWrite("�������Ժ�: " & _SoundStatus($aSound) & @CRLF)

_SoundPlay($aSound)
ConsoleWrite("���������Ժ�: " & _SoundStatus($aSound) & @CRLF)

Sleep(1000)

_SoundPause($aSound)
ConsoleWrite("������ͣ�Ժ�: " & _SoundStatus($aSound) & @CRLF)

Sleep(1000)
_SoundResume($aSound)

While 1
    Sleep(100)
    If _SoundPos($aSound, 2) = _SoundLength($aSound, 2) Then ExitLoop
WEnd

_SoundClose($aSound)
