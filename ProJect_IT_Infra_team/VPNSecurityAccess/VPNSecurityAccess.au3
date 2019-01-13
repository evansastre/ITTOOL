#RequireAdmin
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=corpname.ico
#AccAu3Wrapper_OutFile=VPNSecurityAccess.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include<array.au3>


FileDelete(@UserProfileDir&"\Documents\Default.rdp")


RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU0")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU1")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU2")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU3")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU4")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU5")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU6")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU7")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU8")
RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default","MRU9")


RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Server")


$file=@UserProfileDir & '\cmdkeys.ini'
RunWait(@ComSpec & ' /c '& ' echo [keys]  > ' &  $file,"",@SW_HIDE)
RunWait(@ComSpec & ' /c '& 'cmdkey /list | find "target" >> ' & $file,"",@SW_HIDE)
$line2=FileReadLine($file,2)
If  StringInStr($line2,"target") Then

	Local $array_ksys=IniReadSection($file,"keys")
	$num=$array_ksys[0][0]
	Local $i
	For $i=1 To $num  Step 1 
		RunWait(@ComSpec & ' /c '& 'cmdkey /delete:' &$array_ksys[$i][1] ,"",@SW_HIDE)
	Next
EndIf

FileDelete($file)
;~ _ArrayDisplay($array_ksys)

Run('"' & @ComSpec & '" /c explorer.exe https://203.*.*.*/', '', @SW_HIDE)
Run("C:\Windows\System32\mstsc.exe /prompt")
