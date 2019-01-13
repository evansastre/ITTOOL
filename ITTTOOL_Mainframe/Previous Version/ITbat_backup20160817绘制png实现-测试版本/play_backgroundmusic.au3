#include <Sound.au3>
#include <Date.au3>


#include <File.au3>;;;
;~ play_backgroundmusic();;;


Func play_backgroundmusic()
	Global $play_label
	$BGmusic_path=@TempDir&"\itbat_materials\BGmusic\"
	Local $music_files=_FileListToArray($BGmusic_path,"*",1)
;~ 	If @error = 1 Then
;~         MsgBox($MB_SYSTEMMODAL, "", "·����Ч.")
;~         Exit
;~     EndIf
;~     If @error = 4 Then
;~         MsgBox($MB_SYSTEMMODAL, "", "δ�����ļ�.")
;~         Exit
;~     EndIf
    ; ��ʾ _FileListToArray() �ķ��ؽ��.
;~     _ArrayDisplay($music_files, "�ļ��嵥")

	$random_music_num=Random(1,$music_files[0],1)
	$random_music_file=$music_files[$random_music_num]
	Global $mp3=$BGmusic_path & $random_music_file ;"OwlCity - Victory Theme.mp3"
	
	Global $aSound=_SoundOpen ($mp3)

	If @error = 2 Then
		MsgBox($MB_SYSTEMMODAL, "����", "���ļ�������")
		Return
	ElseIf @extended <> 0 Then
		Local $iExtended = @extended ; DllCall ֮��Ϊ @extended ��ֵ.
		Local $tText = DllStructCreate("char[128]")
		DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
;~ 		MsgBox($MB_SYSTEMMODAL, "����", "���ļ�ʧ��." & @CRLF & "�������: " & $iExtended & @CRLF & "��������: " & DllStructGetData($tText, 1) & @CRLF & "��ע��: �����ļ������޷���������.")
		Return 
	EndIf

	Global $soundlenth=_SoundLength($aSound,2);��������
;~ 	MsgBox(0,"",$soundlenth)
;~ 	$tmp_arr=StringSplit($lenth,":") ;�и����飬��:�ָ�
;~ 	Global $play_time = _TimeToTicks($tmp_arr[1], $tmp_arr[2], $tmp_arr[3]) ;ת��������

	_SoundPlay($aSound);��ʼ����
	
	GUICtrlSetData($play_label,StringLeft($random_music_file,StringLen($random_music_file)-4)) ;��������label

EndFunc





