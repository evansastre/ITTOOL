#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

$Form1 = GUICreate("Form1", 625, 443, -1, -1)
$Button1 = GUICtrlCreateButton("X", 528, 40, 75, 25, $WS_GROUP)
GUICtrlSetBkColor(-1,0x75b2de)
GUICtrlSetColor(-1,0xe3ebee)
GUICtrlSetFont(-1,12,600,"Î¢ÈíÑÅºÚ")
;~ GUICtrlSetOnEvent(-1)

$Button2 = GUICtrlCreateButton("´°¿Ú2", 528, 88, 75, 25, $WS_GROUP)
$Button3 = GUICtrlCreateButton("´°¿Ú3", 528, 136, 75, 25, $WS_GROUP)

$Form2 = GUICreate("Choices Dialog", 345, 252, 30, 30, $WS_CHILD,"", $Form1)
$bListBox1 = GUICtrlCreateList("", 8, 8, 137, 201)
GUICtrlSetData(-1, "Item1|Item2|Item3|Item4|Item5")
$bButton1 = GUICtrlCreateButton(">", 156, 15, 30, 25, $WS_GROUP)
$bButton2 = GUICtrlCreateButton(">>", 156, 48, 31, 25, $WS_GROUP)
$bButton3 = GUICtrlCreateButton("<", 157, 81, 31, 25, $WS_GROUP)
GUICtrlSetState(-1, $GUI_DISABLE)
$bButton4 = GUICtrlCreateButton("<<", 157, 114, 32, 25, $WS_GROUP)
$bListBox2 = GUICtrlCreateList("", 200, 8, 137, 201)
$bButton5 = GUICtrlCreateButton("&OK", 104, 225, 75, 25, $WS_GROUP)
$bButton6 = GUICtrlCreateButton("&Cancel", 184, 225, 75, 25, $WS_GROUP)
$bButton7 = GUICtrlCreateButton("&Help", 264, 225, 75, 25, $WS_GROUP)

$Form3 = GUICreate("Tabbed Notebook Dialog", 420, 320, 30, 30, $WS_CHILD,"", $Form1)
$cPageControl1 = GUICtrlCreateTab(8, 8, 396, 256)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$cTabSheet1 = GUICtrlCreateTabItem("TabSheet1")
$cTabSheet2 = GUICtrlCreateTabItem("TabSheet2")
$cTabSheet3 = GUICtrlCreateTabItem("TabSheet3")
GUICtrlCreateTabItem("")
$cButton1 = GUICtrlCreateButton("&OK", 166, 272, 75, 25, $WS_GROUP)
$cButton2 = GUICtrlCreateButton("&Cancel", 246, 272, 75, 25, $WS_GROUP)
$cButton3 = GUICtrlCreateButton("&Help", 328, 272, 75, 25, $WS_GROUP)

$Form4 = GUICreate("About", 340, 253, 30, 30, $WS_CHILD,"", $Form1)
$dGroupBox1 = GUICtrlCreateGroup("", 8, 8, 305, 185)
$dLabel1 = GUICtrlCreateLabel("Product Name", 152, 24, 72, 17, $WS_GROUP)
$dLabel2 = GUICtrlCreateLabel("Version", 152, 48, 39, 17, $WS_GROUP)
$dLabel4 = GUICtrlCreateLabel("Comments", 16, 160, 53, 17, $WS_GROUP)
$dLabel3 = GUICtrlCreateLabel("Copyright", 16, 136, 48, 17, $WS_GROUP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$dButton1 = GUICtrlCreateButton("&OK", 112, 208, 75, 25)

Local $Current = ""

GUISetState(@SW_SHOW, $Form1)


While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
                Case $GUI_EVENT_CLOSE
                        Exit
                Case $Button1
                        If $Current <> "" Then GUISetState(@SW_HIDE, $Current)
                        GUISetState(@SW_SHOW, $Form2)
                        $Current = $Form2
                Case $Button2
                        If $Current <> "" Then GUISetState(@SW_HIDE, $Current)
                        GUISetState(@SW_SHOW, $Form3)
                        $Current = $Form3                        
                Case $Button3
                        If $Current <> "" Then GUISetState(@SW_HIDE, $Current)
                        GUISetState(@SW_SHOW, $Form4)
                        $Current = $Form4                        
        EndSwitch
WEnd