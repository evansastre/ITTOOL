#include<Array.au3>
Global $Addrs = "battlenet.ini"
Global $iniInfo_arr[0]
Global $iniInfo_PS_arr[0]



Example()

Func Example()
    ; 将字符串转换到一个 ASCII 数组.
	$centence="This is a sentence  with 	 whit		 espace."
	Local $RegExp = StringRegExpReplace($centence,"\s+","|") ;将所有空格、TAB符号转换成|
	Local $aArray = StringSplit($RegExp,"|",1) ;以|为分隔符将元素数组化
    _ArrayDisplay($aArray)

	Exit


EndFunc   ;==>Example

;~ 114.113.218.135  1119   炉石传说
;~ 122.198.64.131	1119	Agent1 
;~ 114.113.217.71	1119	Agent2
;~ 122.198.64.138	1119	魔兽世界

Init_iniInfo_arr($Addrs)
;~ getAvailableParameter($Addrs)

Func Init_iniInfo_arr($filename)		
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. @error: " & @error) ; 读取当前脚本文件时发生错误.
	Else
	
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			$tmparr=StringSplit($aArray[$i]," 	")
;~ 			$tmparr=StringSplit($aArray[$i]," ",1)
			MsgBox(0,"",UBound($tmparr))
			MsgBox(0,"",$tmparr[0])
			MsgBox(0,"",$tmparr[1])
			MsgBox(0,"",$tmparr[2])
			MsgBox(0,"",$tmparr[3])
			MsgBox(0,"",$tmparr[4])
			MsgBox(0,"",$tmparr[5])
			Exit
;~ 			If UBound($tmparr)>1 Then
;~ 				$info=StringStripWS($tmparr[1],2);stringstripws用于删除字符串右边的空格
;~ 				_ArrayAdd($iniInfo_arr,$info)
;~ 				$info_PS=StringStripWS($tmparr[2],2);stringstripws用于删除字符串右边的空格
;~ 				_ArrayAdd($iniInfo_PS_arr,$info_PS)
;~ 			EndIf
		Next
		
	EndIf

EndFunc
Func getAvailableParameter($filename)
	$aArray=FileReadToArray($filename)
	$String_AvailableAddrs=""
	If @error Then
		MsgBox(0, "", "读取文件时出现错误. @error: " & @error) ; 读取当前脚本文件时发生错误.
	Else
		For $i = 0 To UBound($aArray) - 1 ; 循环遍历数组.
			$tmparr=StringSplit($aArray[$i],"pss:",1)
			If UBound($tmparr)>1 Then
				$item=StringStripWS($tmparr[1],2);stringstripws用于删除字符串右边的空格
			Else
				$item=$aArray[$i]
			EndIf
			$String_AvailableAddrs= $String_AvailableAddrs & "|" & $item 
		Next
	EndIf
	Return $String_AvailableAddrs
EndFunc
