#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\ITTOOLS\Conf\ITbat\itbatConfEditor.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
$cur_Time=@YEAR &@MON & @MDAY &'-'& @HOUR  & @MIN  & @SEC 

$from="\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ITbat.ini"
$bk_sh="\\ITTOOL_node2\ITTOOLS\Conf\ITbat\ITbat.ini"
;~ $from=@ScriptDir&"\ITbat.ini"
$desthz="\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ITbatConfbakcup\ITbat" &'-'&  $cur_Time &'-'& @UserName &".ini"
$destsh="\\ITTOOL_node2\ITTOOLS\Conf\ITbat\ITbatConfbakcup\ITbat" &'-'&  $cur_Time &'-'& @UserName &".ini"
;~ $dest=@ScriptDir&"\ITbatConfbakcup\ITbat" &'-'&  $cur_Time &'-'& @UserName &".ini"
FileCopy($from,$desthz,1+8)
FileCopy($from,$destsh,1+8)
$pid=Run("notepad "& $from)


While ProcessExists($pid)
	Sleep(1000)
WEnd


FileCopy($from,$bk_sh,1)


;~ MsgBox(0,"","��������")


