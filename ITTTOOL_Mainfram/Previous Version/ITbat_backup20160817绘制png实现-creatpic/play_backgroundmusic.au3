#include <Sound.au3>
#include <Date.au3>


#include <File.au3>;;;
;~ play_backgroundmusic();;;


Func play_backgroundmusic()
	Global $play_label
	$BGmusic_path=@TempDir&"\itbat_materials\BGmusic\"
	Local $music_files=_FileListToArray($BGmusic_path,"*",1)
;~ 	If @error = 1 Then
;~         MsgBox($MB_SYSTEMMODAL, "", "路径无效.")
;~         Exit
;~     EndIf
;~     If @error = 4 Then
;~         MsgBox($MB_SYSTEMMODAL, "", "未发现文件.")
;~         Exit
;~     EndIf
    ; 显示 _FileListToArray() 的返回结果.
;~     _ArrayDisplay($music_files, "文件清单")

	$random_music_num=Random(1,$music_files[0],1)
	$random_music_file=$music_files[$random_music_num]
	Global $mp3=$BGmusic_path & $random_music_file ;"OwlCity - Victory Theme.mp3"
	
	Global $aSound=_SoundOpen ($mp3)

	If @error = 2 Then
		MsgBox($MB_SYSTEMMODAL, "错误", "该文件不存在")
		Return
	ElseIf @extended <> 0 Then
		Local $iExtended = @extended ; DllCall 之后将为 @extended 赋值.
		Local $tText = DllStructCreate("char[128]")
		DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
;~ 		MsgBox($MB_SYSTEMMODAL, "错误", "打开文件失败." & @CRLF & "错误号码: " & $iExtended & @CRLF & "错误描述: " & DllStructGetData($tText, 1) & @CRLF & "请注意: 声音文件可能无法正常播放.")
		Return 
	EndIf

	Global $soundlenth=_SoundLength($aSound,2);歌曲长度
;~ 	MsgBox(0,"",$soundlenth)
;~ 	$tmp_arr=StringSplit($lenth,":") ;切割数组，以:分割
;~ 	Global $play_time = _TimeToTicks($tmp_arr[1], $tmp_arr[2], $tmp_arr[3]) ;转换成秒数

	_SoundPlay($aSound);开始播放
	
	GUICtrlSetData($play_label,StringLeft($random_music_file,StringLen($random_music_file)-4)) ;歌曲名的label

EndFunc





