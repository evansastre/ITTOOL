$Width=@DesktopWidth 
$Height=@DesktopHeight 
$cmd_W=$Width/3
$cmd_H=$Height/2



While ProcessExists("cmd.exe")
	ProcessClose("cmd.exe")
WEnd



$cmd1=Run(@ComSpec & " /k "&" title cmd1 && ping dc1 -t ")
WinWaitActive("管理员:  cmd1")
$title_cmd1=WinGetTitle("[ACTIVE]")
WinMove($title_cmd1, "",0,0,$cmd_W,$cmd_H)




$cmd2=Run(@ComSpec & " /k "&" title cmd2 && ping dc2 -t ")
WinWaitActive("管理员:  cmd2")
$title_cmd2=WinGetTitle("[ACTIVE]")
WinMove($title_cmd2, "",$Width/3,0,$cmd_W,$cmd_H )


$cmd3=Run(@ComSpec & " /k "&" title cmd3 && ping dc3 -t ")
WinWaitActive("管理员:  cmd3")
$title_cmd3=WinGetTitle("[ACTIVE]")
WinMove($title_cmd3, "",$Width/3*2,0,$cmd_W,$cmd_H )


$cmd4=Run(@ComSpec & " /k "&" title cmd4 && ping dc4 -t ")
WinWaitActive("管理员:  cmd4")
;~ WinWaitActive($cmd4)
$title_cmd4=WinGetTitle("[ACTIVE]")
WinMove($title_cmd4, "",0,$Height/2,$cmd_W,$cmd_H )


$cmd5=Run(@ComSpec & " /k "&" title cmd5 && tracert -d dc1 ")
WinWaitActive("管理员:  cmd5")
$title_cmd5=WinGetTitle("[ACTIVE]")
WinMove($title_cmd5, "",$Width/3,$Height/2,$cmd_W,$cmd_H )


$cmd6=Run(@ComSpec & " /k "&" title cmd6 && tracert  -d dc1  ")
WinWaitActive("管理员:  cmd6")
$title_cmd6=WinGetTitle("[ACTIVE]")
WinMove($title_cmd6, "",$Width/3*2,$Height/2,$cmd_W,$cmd_H )





;~ While 1 
	
