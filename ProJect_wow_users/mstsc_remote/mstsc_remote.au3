#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile_x64=\\ITTOOL_node1\ITTOOLS\Scripts\mstsc_remote\mstsc_remote.exe
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#include <Array.au3>
#include <file.au3>
$all_users = "\\dc1\SYSVOL\CorpDomain.internal\scripts\All_remote_users.ini"
$user=@UserName
$aArray = IniReadSectionNames($all_users)

If @error<>0 Then 
	MsgBox(0,"","�����ļ��д�����ϵIT����")
;~ 	Return 
EndIf

Global  $UsersNum = $aArray[0] ; �û�����
Global  $UsersNames[0];�û�����
Global  $UsersIP[0] ;IP

;~ MsgBox(0,"",$aArray[0])
;~ MsgBox(0,"",$aArray[1])
;~ MsgBox(0,"",$aArray[2])
;~ MsgBox(0,"",$aArray[3])
;~ MsgBox(0,"",$aArray[4])

Local $aArrayUnique[0]
For $i = 1 To $UsersNum
		_ArrayFindAll ($aArrayUnique,$aArray[$i])
		If @error<>0 Then
			_ArrayAdd($aArrayUnique,$aArray[$i])
		Else
			MsgBox(0,"",$aArray[$i]&"�û��������ظ���")
			Exit
		EndIf
		$this_user=$aArray[$i]
		$this_IP=IniRead ( $all_users, $aArray[$i], "IP", "0" )
		If $this_IP=="0" Then
			MsgBox(0,"",$aArray[$i]&"��IP����Ϊ��")
			Exit
		EndIf
		;~ 		_ArrayAdd($UsersIP,$this_IP)
		
		
		If $this_user=="" Then
			MsgBox(0,"","��"&$i&"���û�����Ϊ��")
			Exit
		ElseIf StringUpper($this_user)==StringUpper($user) Then
			Local $cmd[1]=["mstsc /f /v:" & $this_IP]
;~ 			_ArrayDisplay($cmd)
			runBat($cmd)
			Exit
		EndIf
;~ 		_ArrayAdd($UsersNames,$aArray[$i])

;~ 		MsgBox(0,"",$this_IP)
		
Next
;~ _ArrayDisplay($UsersNames)
;~ _ArrayDisplay($UsersIP)


Func runBat($mycmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $mycmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecute($sFilePath,"","","open",@SW_HIDE)

EndFunc