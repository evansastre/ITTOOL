#include <FileConstants.au3>

While ProcessExists("MyPopo.exe") 
	ProcessClose("MyPopo.exe");�رռ�ʱͨ
WEnd

FileOpenDialog ( "����", "C:\","*.*" )



;~ $popo_dir="C:\Program Files (x86)\corpname\POPO\users"
;~ If FileExists($popo_dir) Then
;~ 	Select
;~ 	DirCopy(@DesktopDir,$popo_dir,1)
;~ Else
;~ 	MsgBox(0,"",$popo_dir&" �����������¼")
;~ EndIf
