#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=Y:\\skype�޸�.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****

main()

Func main()
	closeSkype()
	$romPath=@AppDataDir&"\skype"
	RunWait(DirRemove($romPath,1))
	MsgBox(0,"","�޸�����ɡ��볢�����µ�¼skype")
EndFunc


Func closeSkype()
	If ProcessExists("skype.exe") Then 
		$res=MsgBox(1,"","��Confirmskype�ѹر�")
		If $res==1 Then
			closeSkype()
			Return
		ElseIf $res==2 Then
			Exit
		EndIf
	EndIf
EndFunc






