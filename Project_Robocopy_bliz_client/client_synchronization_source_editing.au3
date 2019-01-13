#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=Y:\Robocopy_bliz_client\client_synchronization_source_editing.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include "choose.au3"

;~ $PROFILEPATH="\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\"& $now_choose_tool &".ini"
;~ FileCopy($PROFILEPATH,'"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\Diablo III CN.ini"',1)
;~ Exit

InputWindow()

$PROFILEPATH="\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\"& $now_choose_tool &".ini"





$pid=Run("notepad "& $PROFILEPATH)


If $now_choose_tool=="all" Then

	While ProcessExists($pid)
		Sleep(1000)
	WEnd


	FileCopy($PROFILEPATH,"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\Diablo III CN.ini",1)
	FileCopy($PROFILEPATH,"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\Hearthstone.ini",1)
	FileCopy($PROFILEPATH,"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\Heroes of the Storm.ini",1)
	FileCopy($PROFILEPATH,"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\Overwatch.ini",1)
	FileCopy($PROFILEPATH,"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\StarCraft_II.ini",1)
	FileCopy($PROFILEPATH,"\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\World of Warcraft.ini",1)

	Run(@ComSpec & " /c "& "robocopy \\ITTOOL_node1\Ini\Battle.net_client_synchronization_source  \\ITTOOL_node2\Ini\Battle.net_client_synchronization_source  /mir",@SW_HIDE)
EndIf
