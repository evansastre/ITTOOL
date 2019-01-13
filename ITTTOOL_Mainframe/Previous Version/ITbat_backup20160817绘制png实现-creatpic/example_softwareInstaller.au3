#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <File.au3>

Global $iniFile = @ScriptDir & "Config.ini"
Global $scriptDir = @ScriptDir

; Main GUI
$Form1 = GUICreate("Software Installer", 633, 451)

$Tab1 = GUICtrlCreateTab(16, 8, 601, 377)
$TabSheet1 = GUICtrlCreateTabItem("Audio/Video/Photo")
$ListView1 = GUICtrlCreateListView("Software Name|Description", 24, 40, 582, 334)
_GUICtrlListView_SetExtendedListViewStyle($ListView1, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, 0x101E, 0, 200)
GUICtrlSendMsg(-1, 0x101E, 1, 375)
$TabSheet2 = GUICtrlCreateTabItem("Computer Maintenance")
$ListView2 = GUICtrlCreateListView("Software Name|Description", 24, 40, 578, 334)
_GUICtrlListView_SetExtendedListViewStyle($ListView2, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, 0x101E, 0, 200)
GUICtrlSendMsg(-1, 0x101E, 1, 375)
$TabSheet3 = GUICtrlCreateTabItem("Internet")
$ListView3 = GUICtrlCreateListView("Software Name|Description", 24, 40, 578, 334)
_GUICtrlListView_SetExtendedListViewStyle($ListView3, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, 0x101E, 0, 200)
GUICtrlSendMsg(-1, 0x101E, 1, 375)
$TabSheet4 = GUICtrlCreateTabItem("Games")
$ListView4 = GUICtrlCreateListView("Software Name|Description", 24, 40, 578, 334)
_GUICtrlListView_SetExtendedListViewStyle($ListView4, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, 0x101E, 0, 200)
GUICtrlSendMsg(-1, 0x101E, 1, 375)
$TabSheet5 = GUICtrlCreateTabItem("Miscellaneous")
$ListView5 = GUICtrlCreateListView("Software Name|Description", 24, 40, 578, 334)
_GUICtrlListView_SetExtendedListViewStyle($ListView5, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, 0x101E, 0, 200)
GUICtrlSendMsg(-1, 0x101E, 1, 375)
$TabSheet6 = GUICtrlCreateTabItem("Productivity")
$ListView6 = GUICtrlCreateListView("Software Name|Description", 24, 40, 578, 334)
_GUICtrlListView_SetExtendedListViewStyle($ListView6, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, 0x101E, 0, 200)
GUICtrlSendMsg(-1, 0x101E, 1, 375)
GUICtrlCreateTabItem("") ; This ends the tab item creation
$Button1 = GUICtrlCreateButton("Install Selected Software", 398, 395, 219, 25, 0)
$MenuItem1 = GUICtrlCreateMenu("File")
$MenuItem2 = GUICtrlCreateMenuItem("Unselect All", $MenuItem1)
$MenuItem3 = GUICtrlCreateMenuItem("Exit", $MenuItem1)
$MenuItem4 = GUICtrlCreateMenu("Help")
$MenuItem5 = GUICtrlCreateMenuItem("Help Topics", $MenuItem4)
$MenuItem6 = GUICtrlCreateMenuItem("About", $MenuItem4)
_Populate()
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button1
            _InstallSelectedSoftware()
        Case $MenuItem2
            _UnselectAll()
        Case $MenuItem3
            Exit
        Case $MenuItem5
            _HelpTopics()
        Case $MenuItem6
            _AboutProject()
    EndSwitch
WEnd

Func _Populate()
    ; Find all files in the Software folder and populate the tabs with the installers.
    $f = FileFindFirstFile("Software/*.*")
    Dim $array[1]
    $i = 0
    Do
        $s = FileFindNextFile($f)
        If Not @error Then
            $array[$i] = $s
            $i += 1
            ReDim $array[$i + 1]
        EndIf
    Until @error
    ReDim $array[$i]

    For $i = 1 To UBound($array) Step 1
        $category = IniRead($iniFile, $array[$i - 1], "Category", "5")
        $desc = IniRead($iniFile, $array[$i - 1], "Desc", "")
        If $category = 1 Then
            GUICtrlCreateListViewItem($array[$i - 1] & "|" & $desc, $ListView1)
        ElseIf $category = 2 Then
            GUICtrlCreateListViewItem($array[$i - 1] & "|" & $desc, $ListView2)
        ElseIf $category = 3 Then
            GUICtrlCreateListViewItem($array[$i - 1] & "|" & $desc, $ListView3)
        ElseIf $category = 4 Then
            GUICtrlCreateListViewItem($array[$i - 1] & "|" & $desc, $ListView4)
        ElseIf $category = 6 Then
            GUICtrlCreateListViewItem($array[$i - 1] & "|" & $desc, $ListView6)
        Else
            GUICtrlCreateListViewItem($array[$i - 1] & "|" & $desc, $ListView5)
        EndIf
    Next
EndFunc   ;==>_Populate

Func _InstallSelectedSoftware()
    Dim $sArray[1]

    ; Find which items were selected by user on all six tabs
    $count = _GUICtrlListView_GetItemCount($ListView1)
    $aCount = 0
    For $i = 1 To $count Step 1
        If _GUICtrlListView_GetItemChecked($ListView1, $i - 1) = True Then
            $sArray[$aCount] = _GUICtrlListView_GetItemText($ListView1, $i - 1)
            ReDim $sArray[UBound($sArray) + 1]
            $aCount += 1
        EndIf
    Next

    $count = _GUICtrlListView_GetItemCount($ListView2)
    For $i = 1 To $count Step 1
        If _GUICtrlListView_GetItemChecked($ListView2, $i - 1) = True Then
            $sArray[$aCount] = _GUICtrlListView_GetItemText($ListView2, $i - 1)
            ReDim $sArray[UBound($sArray) + 1]
            $aCount += 1
        EndIf
    Next

    $count = _GUICtrlListView_GetItemCount($ListView3)
    For $i = 1 To $count Step 1
        If _GUICtrlListView_GetItemChecked($ListView3, $i - 1) = True Then
            $sArray[$aCount] = _GUICtrlListView_GetItemText($ListView3, $i - 1)
            ReDim $sArray[UBound($sArray) + 1]
            $aCount += 1
        EndIf
    Next

    $count = _GUICtrlListView_GetItemCount($ListView4)
    For $i = 1 To $count Step 1
        If _GUICtrlListView_GetItemChecked($ListView4, $i - 1) = True Then
            $sArray[$aCount] = _GUICtrlListView_GetItemText($ListView4, $i - 1)
            ReDim $sArray[UBound($sArray) + 1]
            $aCount += 1
        EndIf
    Next

    $count = _GUICtrlListView_GetItemCount($ListView5)
    For $i = 1 To $count Step 1
        If _GUICtrlListView_GetItemChecked($ListView5, $i - 1) = True Then
            $sArray[$aCount] = _GUICtrlListView_GetItemText($ListView5, $i - 1)
            ReDim $sArray[UBound($sArray) + 1]
            $aCount += 1
        EndIf
    Next

    $count = _GUICtrlListView_GetItemCount($ListView6)
    For $i = 1 To $count Step 1
        If _GUICtrlListView_GetItemChecked($ListView6, $i - 1) = True Then
            $sArray[$aCount] = _GUICtrlListView_GetItemText($ListView6, $i - 1)
            ReDim $sArray[UBound($sArray) + 1]
            $aCount += 1
        EndIf
    Next

    ; Begin installing selected software
    ProgressOn("Software Installer", "Installing", "", -1, -1, 16)
    For $i = 1 To UBound($sArray) - 1 Step 1
        $fileName = $sArray[$i - 1]
        $switch = IniRead($iniFile, $fileName, "Switch", "")
        Local $szDrive, $szDir, $szFName, $szExt
        $extension = StringRight($fileName, 3)
        If $extension = "msi" Then
            Run("msiexec /i " & '"' & $scriptDir & "Software" & $fileName & '" ' & $switch) ; For MSI type installers
        Else
            RunWait('"' & $scriptDir & "Software" & $fileName & '"' & " " & $switch) ; For EXE installers
        EndIf
        ProgressSet($i / (UBound($sArray) - 1) * 100, Round($i / (UBound($sArray) - 1) * 100, 0) & "%", "Installing " & $i & " of " & UBound($sArray) - 1)
    Next
    ProgressOff()
EndFunc   ;==>_InstallSelectedSoftware

Func _UnselectAll()
    $count = _GUICtrlListView_GetItemCount($ListView1)
    For $i = 1 To $count Step 1
        _GUICtrlListView_SetItemChecked($ListView1, $i - 1, False)
    Next

    $count = _GUICtrlListView_GetItemCount($ListView2)
    For $i = 1 To $count Step 1
        _GUICtrlListView_SetItemChecked($ListView2, $i - 1, False)
    Next

    $count = _GUICtrlListView_GetItemCount($ListView3)
    For $i = 1 To $count Step 1
        _GUICtrlListView_SetItemChecked($ListView3, $i - 1, False)
    Next

    $count = _GUICtrlListView_GetItemCount($ListView4)
    For $i = 1 To $count Step 1
        _GUICtrlListView_SetItemChecked($ListView4, $i - 1, False)
    Next

    $count = _GUICtrlListView_GetItemCount($ListView5)
    For $i = 1 To $count Step 1
        _GUICtrlListView_SetItemChecked($ListView5, $i - 1, False)
    Next

    $count = _GUICtrlListView_GetItemCount($ListView6)
    For $i = 1 To $count Step 1
        _GUICtrlListView_SetItemChecked($ListView6, $i - 1, False)
    Next
EndFunc   ;==>_UnselectAll

Func _HelpTopics()
    $Form2 = GUICreate("Help Topics", 633, 447)
    $Label1 = GUICtrlCreateLabel("", 8, 16, 612, 425)
    GUICtrlSetData(-1, "This program uses silent switches to install software without user interaction. To use this functionality, you can edit the Config.ini file to add software and their switches. Example: " & @CRLF & @CRLF & "[7zip.exe]" & @CRLF & "Switch=/S" & @CRLF & "Desc=A zip file utility" & @CRLF & "Category=5" & @CRLF & @CRLF & "The name of the file is the first line in the brackets. The line with Switch= is the section for the unattended switch. The Desc= is the description for the program. The Category= is the tab you want the program to show up on the interface." & @CRLF & @CRLF & "Here are some common switches for various installers:" & @CRLF & @CRLF & "/silent used for Inno Setup installers" & @CRLF & "/verysilent used for Inno Setup installers" & @CRLF & "/S used for Nullsoft (aka NSIS) installers" & @CRLF & "/s used for Wise installers" & @CRLF & "-s used for Ghost installers" & @CRLF & "-ms used for Mozilla installers" & @CRLF & "/quiet used for Microsoft installers" & @CRLF & "/qb used for Microsoft installers" & @CRLF & "/qn used for Microsoft installers" & @CRLF & "/passive used for Microsoft installers" & @CRLF & "/Q used for Microsoft installers" & @CRLF & @CRLF & "Note: Some installers are case sensitive (Ghost and Nullsoft for sure).")
    GUISetState(@SW_SHOW)

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($Form2)
                ExitLoop
        EndSwitch
    WEnd
EndFunc   ;==>_HelpTopics

Func _AboutProject()
    $Form3 = GUICreate("About", 413, 196)
    $Label1a = GUICtrlCreateLabel("", 24, 64, 364, 113)
    $Label2a = GUICtrlCreateLabel("Software Installer 1.0", 24, 8, 375, 41)
    GUICtrlSetFont(-1, 24, 800, 2, "MS Sans Serif")
    GUICtrlSetColor(-1, 0x000080)
    GUISetState(@SW_SHOW)
    $aboutData = "This program was written|in a programming language called Autoit||Brought to you by abberration"
    $sData = StringSplit($aboutData, "|", 2)
    $string = ""
    For $i = 1 To UBound($sData) Step 1
        $string = $string & @CRLF & $sData[$i - 1] & @CRLF
        GUICtrlSetData($Label1a, $string)
        Sleep(1000)
    Next

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($Form3)
                ExitLoop
        EndSwitch
    WEnd
EndFunc   ;==>_AboutProject