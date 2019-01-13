#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\wowGMclientUpdate\GM客户端上传SH.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <Array.au3>
#include <FileConstants.au3>
#include <Misc.au3>


$HZcdn="\\shcw01\World of Warcraft oringin\"
;~ $HZcdn="\\hzcw01\World of Warcraft oringin\"
;~ $HZcdn=@ScriptDir&"\WoW 6.2.3 20726\"


Local $Update_files[4]=["WowGM.exe" ,  "WowGM-64.exe"  ,  "WowGM.pdb" ,  "WowGM-64.pdb"]
$a = FileOpenDialog("选择上传文件", @DesktopDir, "所有文件(*.*)",4)

If $a = "" Then
	MsgBox(16, "错误", "没有文件被选择！", 6)
	Exit
EndIf


$tmp_arr=StringSplit($a,"|",1)


If @error==1 Then  ;“|不存在，说明之选了一个元素”
	$tmp_arr=StringSplit($a,"\",1)
	$num=$tmp_arr[0]
	Local $this_file=$tmp_arr[$num]
	
	
	If _ArraySearch($Update_files,$this_file)<> -1 Then
		$filelocal=$a
		$filecdn=$HZcdn&$this_file
		TrayTip("","正在上传" & $this_file,5)
		RunWait(FileCopy($filelocal,$filecdn,1))
		
;~ 		MsgBox(0,"",$this_file & @LF & $filelocal & @LF &$filecdn  )
		
		TrayTip("","完成上传:" & $this_file,5)
		MsgBox(0,"","完成上传:" & $this_file,1)
	Else
		MsgBox(0,"","非GM客户端文件:" & $this_file)
	EndIf
	
	MsgBox(0,"","上传完成")
	Exit
	
EndIf


$num=$tmp_arr[0]-1
$chosen_path=$tmp_arr[1]

For $i=2 To $num+1

	Local $this_file=$tmp_arr[$i]
	
;~ 	MsgBox(0, "", $this_file)
	
	If _ArraySearch($Update_files,$this_file)<> -1 Then
		$filelocal=$chosen_path&"\"&$this_file
		
		$filecdn=$HZcdn&$this_file
		
;~ 		MsgBox(0,"",$filelocal & @LF &$filecdn  )
		
		TrayTip("","正在上传" & $this_file,5)
		RunWait(FileCopy($filelocal,$filecdn,1))
		
;~ 		MsgBox(0, "", $filelocal&@LF&$filecdn)
		TrayTip("","完成上传:" & $this_file,5)
		MsgBox(0,"","完成上传:" & $this_file,1)

	Else
		MsgBox(0,"","非GM客户端文件:" & $this_file)
	EndIf
Next

MsgBox(0,"","上传完成")

		
