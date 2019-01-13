; Script Name	: logoff.au3
; Author		: Craig Richards
; Created		: 6th February 2012
; Last Modified	:
; Version		: 1.0

; Modifications	:

; Description	: This is a simple splash screen to wrap around my logoff.bat incase someone presses my logoff button by mistake (New Microsoft Keyboard)

#Include <GuiConstants.au3>							; Include the GuiConstants Header File
#Include <StaticConstants.au3>						; Include the StaticConstants Header File

Opt('GuiOnEventMode', 1)							; Set the Option, and enable GuiOnEventMode
GUICreate ("Logoff Warning", 750, 750)				; Create a simple window
;GUISetIcon("icon.ico")								; Give it an icon
GUISetOnEvent($GUI_EVENT_CLOSE, 'GUIExit')			; Close the Window if the program is quit
GUICtrlCreatePic("1280.jpg",0,0,750,680)			; Put a picture in the background of the splash screen
GUICtrlCreateLabel("Please Choose an Option Below:", 220, 680, 300, 15, $SS_CENTER)	; A simple label on the screen
GUICtrlSetColor(-1,0xFF0000);						; Text of the label will be Red
GUICtrlCreateButton("Logoff", 170, 700, 200, 30)	; Create a simple button to run the logoff script
GUICTrlSetOnEvent(-1, 'logoff')						; If pressed run the logoff function
GUICtrlCreateButton("Cancel", 375, 700, 200, 30)	; Create a simple button to quit the program
GUICTrlSetOnEvent(-1, 'cancel')						; If pressed run the cancel function

Func logoff()				; Start of the logoff function
	GUISetState(@SW_HIDE)	; Hide the Window
	Run("u:\logoff.bat")	; Run the logoff batch file
	Exit					; Quit the program
EndFunc						; End of the logoff Function

Func cancel()				; Start of the cancel function
	GUISetState(@SW_HIDE)	; Hide the Window
	Exit					; Quit the program
EndFunc						; End of the cancel Function

GUISetState(@SW_SHOW)		; Show the application Windows

While 1						; A simple while loop
	Sleep(500)				; Sleep to keep the window running
WEnd						; End of the While loop

Func GUIExit()				; Start of the GUIExit function
	Exit					; Quit the program
EndFunc						; End of the GUIExit Function