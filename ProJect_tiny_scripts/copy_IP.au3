#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\copy_IP.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <WinAPISys.au3>
#include <Clipboard.au3>

If _ClipBoard_Open(0) Then
	; Empty clipboard
	If _ClipBoard_Empty() Then
		; Create global memory buffer (show why using _ClipBoard_SetData is MUCH easier!)
		$sData = @IPAddress1 &" "&@ComputerName  &" "& @UserName ;& @LF & @ComputerName
		$iSize = StringLen($sData) + 1
		$hMemory = _MemGlobalAlloc($iSize, $GHND)
		If $hMemory <> 0 Then
			$hLock = _MemGlobalLock($hMemory)
			If $hLock = 0 Then _WinAPI_ShowError("_Mem_GlobalLock failed")
			$tData = DllStructCreate("char Text[" & $iSize & "]", $hLock)
			DllStructSetData($tData, "Text", $sData)
			_MemGlobalUnlock($hMemory)
			; Write clipboard text
			If Not _ClipBoard_SetDataEx($hMemory, $CF_TEXT) Then _WinAPI_ShowError("_ClipBoard_SetDataEx failed")
		Else
			_WinAPI_ShowError("_Mem_GlobalAlloc failed")
		EndIf
		; Close clipboard
		_ClipBoard_Close()
	Else
		; Close clipboard
		_ClipBoard_Close()
		_WinAPI_ShowError("_ClipBoard_Empty failed")
	EndIf
Else
	_WinAPI_ShowError("_ClipBoard_Open failed")
EndIf

MsgBox(0,"","您的IP地址："& @IPAddress1 & @LF & "   计算机名："&@ComputerName & @LF & "      用户名："& @UserName & @LF & "已为您复制到粘贴板，点击Ctrl+V给IT即可",10)


WO_rec("查看IP")


Func WO_rec($rec_name) ;ticket record
	$rec_file = '\\ITTOOL_node1\ITTOOLS_WO_rec\' & $rec_name & '.txt'
	$cur_Time = @YEAR & '-' & @MON & '-' & @MDAY & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
	$rec =  @UserName & "   " & @ComputerName & "   " & $cur_Time 
	RunWait(FileWriteLine($rec_file,$rec))
EndFunc