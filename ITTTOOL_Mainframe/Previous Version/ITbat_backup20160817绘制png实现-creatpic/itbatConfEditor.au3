#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ittoolConfEditor.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
$cur_Time=@YEAR &@MON & @MDAY &'-'& @HOUR  & @MIN  & @SEC 

$from="\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ITTOOL.ini"
$bk_sh="\\ITTOOL_node2\ITTOOLS\Conf\ITbat\ITTOOL.ini"
;~ $from=@ScriptDir&"\ITbat.ini"
$desthz="\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ITbatConfbakcup\ITTOOL" &'-'&  $cur_Time &'-'& @UserName &".ini"
$destsh="\\ITTOOL_node2\ITTOOLS\Conf\ITbat\ITbatConfbakcup\ITTOOL" &'-'&  $cur_Time &'-'& @UserName &".ini"
;~ $dest=@ScriptDir&"\ITbatConfbakcup\ITbat" &'-'&  $cur_Time &'-'& @UserName &".ini"
FileCopy($from,$desthz,1+8)
FileCopy($from,$destsh,1+8)
$pid=Run("notepad "& $from)


While ProcessExists($pid)
	Sleep(1000)
WEnd


FileCopy($from,$bk_sh,1)

Run(@ComSpec & " /c "& "robocopy \\ITTOOL_node1\ITTOOLS \\ITTOOL_node2\ITTOOLS /mir",@SW_HIDE)

;~ MsgBox(0,"","结束运行")



