#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\wowGMclientUpdate\GM�ͻ����ϴ�SH.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Array.au3>
#include <FileConstants.au3>
#include <Misc.au3>


$HZcdn="\\shcw01\World of Warcraft oringin\"
;~ $HZcdn="\\hzcw01\World of Warcraft oringin\"
;~ $HZcdn=@ScriptDir&"\WoW 6.2.3 20726\"


Local $Update_files[4]=["WowGM.exe" ,  "WowGM-64.exe"  ,  "WowGM.pdb" ,  "WowGM-64.pdb"]
$a = FileOpenDialog("ѡ���ϴ��ļ�", @DesktopDir, "�����ļ�(*.*)",4)

If $a = "" Then
	MsgBox(16, "����", "û���ļ���ѡ��", 6)
	Exit
EndIf


$tmp_arr=StringSplit($a,"|",1)


If @error==1 Then  ;��|�����ڣ�˵��֮ѡ��һ��Ԫ�ء�
	$tmp_arr=StringSplit($a,"\",1)
	$num=$tmp_arr[0]
	Local $this_file=$tmp_arr[$num]
	
	
	If _ArraySearch($Update_files,$this_file)<> -1 Then
		$filelocal=$a
		$filecdn=$HZcdn&$this_file
		TrayTip("","�����ϴ�" & $this_file,5)
		RunWait(FileCopy($filelocal,$filecdn,1))
		
;~ 		MsgBox(0,"",$this_file & @LF & $filelocal & @LF &$filecdn  )
		
		TrayTip("","����ϴ�:" & $this_file,5)
		MsgBox(0,"","����ϴ�:" & $this_file,1)
	Else
		MsgBox(0,"","��GM�ͻ����ļ�:" & $this_file)
	EndIf
	
	MsgBox(0,"","�ϴ����")
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
		
		TrayTip("","�����ϴ�" & $this_file,5)
		RunWait(FileCopy($filelocal,$filecdn,1))
		
;~ 		MsgBox(0, "", $filelocal&@LF&$filecdn)
		TrayTip("","����ϴ�:" & $this_file,5)
		MsgBox(0,"","����ϴ�:" & $this_file,1)

	Else
		MsgBox(0,"","��GM�ͻ����ļ�:" & $this_file)
	EndIf
Next

MsgBox(0,"","�ϴ����")

		
