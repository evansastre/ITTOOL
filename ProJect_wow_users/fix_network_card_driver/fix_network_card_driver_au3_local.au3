#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_OutFile=fix_network_card_driver_au3_local.exe
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

$prog=  @TempDir & "\fix_network_card_driver.exe"
$driver = @TempDir & "\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE"

Func main()
	FileInstall(".\fix_network_card_driver.exe",$prog, 1)
	FileInstall(".\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE",$driver, 1)
;~ 	FileCopy("\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\网卡驱动\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE",@TempDir)
;~ 	FileCopy("\\ITTOOL_node1\ITTOOLS\SoftwareDeploy\网卡驱动\fix_network_card_driver.exe",@TempDir)
	RunAsWait("TestUser1","CorpDomain","Dcacdsj1989",4,$prog,@SystemDir)
EndFunc


main()

;~ RunAs("TestUser1","CorpDomain","Dcacdsj1989",4,main(),@SystemDir)
FileDelete($prog)
FileDelete($driver)