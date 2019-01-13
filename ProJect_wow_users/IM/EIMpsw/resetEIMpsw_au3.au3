RunWait("robocopy \\ITTOOL_node1\ITTOOLS\Scripts\EIM\resetEIMpsw\  %temp%\resetEIMpsw\  /mir")
RunWait("start   %temp%\resetEIMpsw\resetEIMpsw.exe ")
FileDelete()