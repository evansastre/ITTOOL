#include <Math.au3>
$sh=Ping("dc1")
If $sh==0 Then  $sh=Ping("dc2")

$hz=Ping("dc3")
If $hz==0 Then  $hz=Ping("dc4")
$dc5=Ping("dc5")

If $sh==_Min( $sh, $hz ) Then 
	$server="Shanghai"
ElseIf $hz==_Min ( $sh, $hz ) Then 
	$server="Hangzhou"
EndIf

	

MsgBox(0,"",$server)


;MsgBox(0,"",$sh & @LF & $hz & @LF & $dc5) 