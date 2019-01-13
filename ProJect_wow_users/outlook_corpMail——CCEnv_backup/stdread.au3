
Local $foo = Run("sort.exe", @SystemDir, @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD)

StdinWrite($foo, "rat" & @CRLF & "cat" & @CRLF & "bat" & @CRLF)

StdinWrite($foo)



Local $data
While True
    $data &= StdoutRead($foo)
    If @error Then ExitLoop
    Sleep(25)
WEnd
MsgBox(0, "Debug", $data)