#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=play_backgroundmusic.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <Sound.au3>
#include <Date.au3>

;~ play_backgroundmusic()
Func play_backgroundmusic()
		
	$mp3=@TempDir&"\Merry Christmas Mr.Lawrence.mp3"
	FileInstall("Merry Christmas Mr.Lawrence.mp3",$mp3)
	Global $aSound=_SoundOpen ($mp3)

	If @error = 2 Then
		MsgBox($MB_SYSTEMMODAL, "错误", "该文件不存在")
		Exit
	ElseIf @extended <> 0 Then
		Local $iExtended = @extended ; DllCall 之后将为 @extended 赋值.
		Local $tText = DllStructCreate("char[128]")
		DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
		MsgBox($MB_SYSTEMMODAL, "错误", "打开文件失败." & @CRLF & "错误号码: " & $iExtended & @CRLF & "错误描述: " & DllStructGetData($tText, 1) & @CRLF & "请注意: 声音文件仍然可以正常播放.")
	EndIf
	;~     MsgBox($MB_SYSTEMMODAL, "成功", "成功打开该文件")
	$lenth=_SoundLength($aSound);得到 hour:min:sec
	$tmp_arr=StringSplit($lenth,":") ;切割数组，以:分割
	Global $play_time = _TimeToTicks($tmp_arr[1], $tmp_arr[2], $tmp_arr[3]) ;转换成秒数

	_SoundPlay($aSound);开始播放
;~ 	Sleep($play_time) ;脚本暂停歌的长度
;~ 	_SoundClose($aSound);退出播放
	
EndFunc





