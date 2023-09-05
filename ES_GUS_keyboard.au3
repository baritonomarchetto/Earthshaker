;EARTHSHAKER PC-JAMMA Interface - Game Utility Script (GUS)
;
;by Barito (last update sept 2023)

#Include <Misc.au3>

_Singleton("ES_GUS", 0) ;allows only one instance of the program

Local $hDLL = DllOpen("user32.dll")
Local $iPID
Local $gameRom = "buggyboyjr" ; 									;<-- DEFINE YOUR STARTING GAME ROM HERE
Local $maxRoms = 10;
Local $a = 1
;RandomGame() ;uncomment this if you want a random game on start
GameRun()

While 1
    ShutDownKey()
	GameChange()
	Sleep(30) ;keep CPU cool
WEnd

DllClose($hDLL)

Func GameChange()
If _IsPressed("44", $hDLL) Then ; 44 = D  	 ;<-- DEFINE THE GAME CHANGE BUTTON HERE (HEX)
	$a = $a+1
	If $a > $maxRoms Then
		$a = 1
	EndIf
	GameSelect()
	;ProcessClose($iPID) ;MAME don't save changes if killed this way
    fESC()
	GameRun()
	Sleep (2000) ; cheap block against multiple presses
EndIf
EndFunc

Func RandomGame()
	Local $randNum = Random(1, $maxRoms, 1)
	$a = $randNum
	GameSelect()
EndFunc

Func GameSelect()												 ;<-- DEFINE YOUR GAMES ROMS LIST HERE
If $a == 1 Then
	$gameRom = "buggyboyjr"
ElseIf $a == 2 Then
	$gameRom = "polepos2"
ElseIf $a == 3 Then
	$gameRom = "contcirc"
ElseIf $a == 4 Then
	$gameRom = "roadblst"
ElseIf $a == 5 Then
	$gameRom = "outrun"
ElseIf $a == 6 Then
	$gameRom = "pdrift"
ElseIf $a == 7 Then
	$gameRom = "radm"
ElseIf $a == 8 Then
	$gameRom = "sci"
ElseIf $a == 9 Then
	$gameRom = "wrally"
ElseIf $a == 9 Then
	$gameRom = "chasehq"
Else;If $a == 5 Then
	$gameRom = "csprint"
EndIf
EndFunc

Func GameRun()
	$MAMEpath = "C:\MAME\"       ;<-- DEFINE YOUR MAME.EXE PATH HERE
	$ROMpath = "C:\MAME\roms\"   ;<-- DEFINE YOUR MAME ROMS PATH HERE
	$iPID = ShellExecute ("groovymame.exe", $ROMpath&$gameRom, $MAMEpath)
EndFunc

Func fESC()
	Send("{ESC down}") ;this will let MAME save any modification to games configuration settings and hiscores
	Sleep (100)
	Send("{ESC up}")
	Sleep (400)
EndFunc

Func ShutDownKey()
	If _IsPressed("5A", $hDLL) Then ;5A = Z      ;<-- DEFINE THE SHUT DOWN BUTTON HERE (HEX)
	fESC()
	Shutdown(5); shutdown (1) + force (4)
	Sleep (2000) ; cheap block against multiple presses
	EndIf
EndFunc


