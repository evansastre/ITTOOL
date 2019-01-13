#include <FileConstants.au3>

While ProcessExists("MyPopo.exe") 
	ProcessClose("MyPopo.exe");关闭即时通
WEnd

FileOpenDialog ( "标题", "C:\","*.*" )



;~ $popo_dir="C:\Program Files (x86)\corpname\POPO\users"
;~ If FileExists($popo_dir) Then
;~ 	Select
;~ 	DirCopy(@DesktopDir,$popo_dir,1)
;~ Else
;~ 	MsgBox(0,"",$popo_dir&" 不存在聊天记录")
;~ EndIf
