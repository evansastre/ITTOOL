#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=\\ITTOOL_node1\ITTOOLS\Conf\ITbat\itbatConfEditor.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
$cur_Time=@YEAR &@MON & @MDAY &'-'& @HOUR  & @MIN  & @SEC 

;~ $from="\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ITbat.ini"
$from=@ScriptDir&"\ITbat.ini"
;~ $dest="\\ITTOOL_node1\ITTOOLS\Conf\ITbat\ITbatConfbakcup\ITbat" &'-'&  $cur_Time &'-'& @UserName &".ini"
$dest=@ScriptDir&"\ITbatConfbakcup\ITbat" &'-'&  $cur_Time &'-'& @UserName &".ini"
FileCopy($from,$dest,1+8)
Run("notepad "& $from)
