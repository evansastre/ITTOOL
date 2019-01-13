#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\FirefoxProxySwitch\FirefoxProxySwitch_YW.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <File.au3>
#include <Math.au3>
#include <InetConstants.au3>


Global $setup_dir=judgeLocation() ;  '\\ITTOOL_node1\ITTOOLS\'

Global $firefox_path=GETFIREFOXINSTALLPATH() ;判断firefox是否存在于本机，不存在则给予安装选项，存在则返回程序安装路径
Func GETFIREFOXINSTALLPATH()   ;返回outlook安装路径
	RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\FIREFOX.EXE", "path")
;~ 	MsgBox(0,"","请在安装完成后重启本程序进行firefox代理配置")
	If @error<>0 Then  ;;; 0
		$res=MsgBox(1,"","当前可能没有安装Firefox，是否安装？")
		If $res==1 Then
			; 下载的文件保存到临时文件夹.
			Local $sFilePath = @TempDir & "\Firefox-latest.exe"
			
			
			FileCopy($setup_dir&"SoftwareDeploy\Firefox-full-latest.exe",$sFilePath)
			

			;运行安装firefox
;~ 			Local $cmd[1]=[$sFilePath & "  /silent"] 
			Local $cmd[1]=[$sFilePath ] 
			runBatWait($cmd)
			
			$timeout=0
			While $timeout<=30
				If $timeout==30 Then
					MsgBox(0,"","配置超时，请重启本配置程序")
					Exit
				EndIf
				
				RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\FIREFOX.EXE", "path")
				If @error<>0 Then
					$timeout+=1
					Sleep(1000)
				Else
					$timeout=31
				EndIf
			WEnd
			
			Sleep(2000)
		ElseIf $res==2 Then
			MsgBox(0,"","firefox代理配置过程已中断")
			Exit
		EndIf
	EndIf		
	
	Local $path=RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\FIREFOX.EXE", "path")
	Return  $path & "\firefox.exe"
EndFunc   ;==>GETOUTLOOKINSTALLPATH



Func findprefs_dir()
	Global $prefs_dir=@AppDataDir&"\Mozilla\Firefox\Profiles"
	Global $hSearch=FileFindFirstFile($prefs_dir&"\*.default")
	If $hSearch== -1 Then ;未找到配置文件的文件夹
		
;~ 		MsgBox(0,"",$setup_dir&"Scripts\FirefoxProxySwitch\Mozilla"&@LF&@AppDataDir&"\Mozilla")

		
		Local $from=$setup_dir&"Scripts\FirefoxProxySwitch\Mozilla"
		Local $to=@AppDataDir&"\Mozilla"
		TrayTip("tip","正在更新配置",5)
		DirCopy($from,$to ,1)
		TrayTip("tip","更新配置已完成",5)
		$size_from =DirGetSize($from)
		While $size_from<> DirGetSize($to)
			Sleep(500)
		WEnd
		
		$hSearch=FileFindFirstFile($prefs_dir&"\*.default")
;~ 		MsgBox(0,"","done")
		

	EndIf
EndFunc

	


setPrefs()
Func setPrefs()
	
	findprefs_dir()
;~ 	findprefs()
	
	Global $default_folder=$prefs_dir&"\"& FileFindNextFile($hSearch)
	Global $prefsJs=$default_folder&"\prefs.js"
	
;~ 	MsgBox(0,"",$prefsJs)
;~ 	ClipPut($default_folder)


	$fileopen=FileOpen($prefsJs)
;~ 	MsgBox(0,"","fileopen:"&$fileopen)
	
	$fileReadToArray=FileReadToArray($fileopen)
	$totalLineNUM=UBound($fileReadToArray) ;总的行数
;~ 	MsgBox(0,"",$totalLineNUM)

	Local $lineNUM=1
	Local $delnum=0
	Local $startSetLine
;~ 	Local $line
	
	For $line In $fileReadToArray 
		If StringInStr($line,"network.predictor.cleaned-up") Then 
			$startSetLine=$lineNUM+1
;~ 			MsgBox(0,"","search")
		EndIf
		
		If StringInStr($line,"proxy") Then 
			_FileWriteToLine($prefsJs,$lineNUM-$delnum,"",1) 
			$delnum+=1
		EndIf
			
		$lineNUM+=1
		
	Next
	
;~ 	MsgBox(0,"",$startSetLine&@LF&$lineNUM)
	
	;PAC
	_FileWriteToLine($prefsJs,$startSetLine,'user_pref("network.proxy.autoconfig_url", "file://///bnportal/PAC_YW/proxy.pac");',0) 
	_FileWriteToLine($prefsJs,$startSetLine,'user_pref("network.proxy.type", 2);',0) 

	
	
	
	If ProcessExists("firefox.exe") Then
		$res=MsgBox(1,"","需要重启Firefox才能生效配置，是否现在重启？")
		If $res==1 Then
			While ProcessExists("firefox.exe")
				ProcessClose("firefox.exe")
			WEnd 
		ElseIf $res==2 Then
			Exit
		EndIf
	EndIf
	
	
	ShellExecute($firefox_path,"https://www.twitter.com")
			
EndFunc




Func runBatWait($cmd);$cmd must be array
	

    Local $sFilePath =_TempFile(Default,Default,".bat")
	
	
	For $i In $cmd 
		FileWriteLine($sFilePath,$i)
	Next
	FileWriteLine($sFilePath,"del %0")

	ShellExecuteWait($sFilePath,"","","open",@SW_HIDE)

EndFunc


Func judgeLocation()
	
	Local $location
	$sh=Ping("dc1")
	If $sh==0 Then  $sh=Ping("dc2")
	$hz=Ping("dc3")
	If $hz==0 Then  $hz=Ping("dc4")

	If $sh==_Min( $sh, $hz ) Then  ;  The smaller the value, the faster, that is, the closer
		$location = 'SH'
		$file_server='\\ITTOOL_node2\ITTOOLS\'
	ElseIf $hz==_Min ( $sh, $hz ) Then 
		$location = 'HZ'
		$file_server='\\ITTOOL_node1\ITTOOLS\'
	EndIf
	
	Return $file_server
EndFunc

;~ 'user_pref("network.proxy.type", 2);'

;~ ClipPut($default_folder)



;~ text_sreach = 'user_pref("network.proxy.http", "proxy.old.domain");'
;~ text_replace = 'user_pref("network.proxy.http", "proxy.yourdomain.com");'
;~ text_sreach2 = 'user_pref("network.proxy.backup.ftp", "proxy.old.domain");'
;~ text_replace2 = 'user_pref("network.proxy.backup.ftp", "proxy.yourdomain.com");'
;~ text_sreach3 = 'user_pref("network.proxy.backup.socks", "proxy.old.domain");'
;~ text_replace3 = 'user_pref("network.proxy.backup.socks", "proxy.yourdomain.com");'
;~ text_sreach4 = 'user_pref("network.proxy.ftp", "proxy.old.domain");'
;~ text_replace4 = 'user_pref("network.proxy.ftp", "proxy.yourdomain.com");'
;~ text_sreach5 = 'user_pref("network.proxy.socks", "proxy.old.domain");'
;~ text_replace5 = 'user_pref("network.proxy.socks", "proxy.yourdomain.com");'
;~ text_sreach6 = 'user_pref("network.proxy.ssl", "proxy.old.domain");'
;~ text_replace6 = 'user_pref("network.proxy.ssl", "proxy.yourdomain.com");'
;~ text_sreach7 = 'user_pref("network.proxy.backup.ssl", "proxy.old.domain");'
;~ text_replace7 = 'user_pref("network.proxy.backup.ssl", "proxy.yourdomain.com");'
;~ text_sreach8 = 'user_pref("network.proxy.type", 0);'
;~ text_replace8 = 'user_pref("network.proxy.type", 1);'
;~ filedata = None
;~ with open(file_final , 'r') as file :
;~   filedata = file.read()
;~ filedata = filedata.replace(text_sreach, text_replace)
;~ filedata = filedata.replace(text_sreach2, text_replace2)
;~ filedata = filedata.replace(text_sreach3, text_replace3)
;~ filedata = filedata.replace(text_sreach4, text_replace4)
;~ filedata = filedata.replace(text_sreach5, text_replace5)
;~ filedata = filedata.replace(text_sreach6, text_replace6)
;~ filedata = filedata.replace(text_sreach7, text_replace7)
;~ filedata = filedata.replace(text_sreach8, text_replace8)
;~ with open(file_final, 'w') as file:
;~   file.write(filedata)

;~ 