#Region ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
#AccAu3Wrapper_OutFile=fix_network_card_driver_au3.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** �� AccAu3Wrapper_GUI ����ָ�� ****
$prog=  @TempDir & "\fix_network_card_driver.exe"
$driver = @TempDir & "\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE"
Func main()
	;FileInstall(".\fix_network_card_driver.exe",$prog, 1)
	;FileInstall(".\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE",$driver, 1)
	FileCopy("\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\��������\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE",@TempDir)
	FileCopy("\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\��������\fix_network_card_driver.exe",@TempDir)
	RunAsWait("ITSuperAdmin","CorpDomain","Password@4",4,$prog,@SystemDir)
EndFunc

RunAs("ITSuperAdmin","CorpDomain","Password@4",4,main(),@SystemDir)
FileDelete($prog)
FileDelete($driver)