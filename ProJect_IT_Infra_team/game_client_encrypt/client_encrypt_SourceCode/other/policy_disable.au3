#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=policy_disable.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****


;快捷方式拷贝到user桌面
RunWait(@ComSpec & " /c Robocopy.exe D:\client\shortcut   C:\Users\newUser\desktop /mir")


;执行策略限制(包括开机脚本、策略限定、user降权 )
RunWait(@ComSpec & " /c C:\common\degrade\Policy_disable.bat")


Shutdown(6)

