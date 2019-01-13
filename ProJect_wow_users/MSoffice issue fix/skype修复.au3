#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\\skype修复.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

main()

Func main()
	closeSkype()
	$romPath=@AppDataDir&"\skype"
	RunWait(DirRemove($romPath,1))
	MsgBox(0,"","修复已完成。请尝试重新登录skype")
EndFunc


Func closeSkype()
	If ProcessExists("skype.exe") Then 
		$res=MsgBox(1,"","请Confirmskype已关闭")
		If $res==1 Then
			closeSkype()
			Return
		ElseIf $res==2 Then
			Exit
		EndIf
	EndIf
EndFunc






