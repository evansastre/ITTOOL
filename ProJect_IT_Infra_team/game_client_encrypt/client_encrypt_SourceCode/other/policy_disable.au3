#RequireAdmin
#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=policy_disable.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****


;��ݷ�ʽ������user����
RunWait(@ComSpec & " /c Robocopy.exe D:\client\shortcut   C:\Users\newUser\desktop /mir")


;ִ�в�������(���������ű��������޶���user��Ȩ )
RunWait(@ComSpec & " /c C:\common\degrade\Policy_disable.bat")


Shutdown(6)

