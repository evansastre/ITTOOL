#RequireAdmin
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=copyWow.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****



;copy game client to D:\
If Not FileExists("D:\client\") Then DirCreate("D:\client")
RunWait(@ComSpec & " /c " & @ScriptDir &"\client\iRobocopy.exe "& @ScriptDir&"\client\game_client   D:\client")

;copy other scripts to folder common
RunWait(@ComSpec & " /c  Robocopy.exe "& @ScriptDir&"\common  C:\common /mir")

;copy backgroud image
RunWait(@ComSpec & " /c  Robocopy.exe "& @ScriptDir&"\desktopImages  C:\desktopImages /mir")

;copy policy scripts
FileCopy(@ScriptDir&"\other\policy_disable.exe","C:\")

 #include <File.au3>
_FileWriteToLine("C:\common\other\createAccount.bat",1,"net user "& @UserName& "  Password@3")
;createAccount
RunWait(@ComSpec & " /c " & "C:\common\other\createAccount.bat")
;delete scripts
FileDelete("C:\common\other\createAccount.bat")

;tip
MsgBox(0,"","Copy done")



