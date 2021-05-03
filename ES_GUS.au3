;EARTHSHAKER PC-JAMMA Interface - Game Utility Script (GUS)
;
;by Barito
;last update - april 2021

#Include <Misc.au3>

_Singleton("ES_GUS", 0) ;allows only one instance of the program

Local $hDLL = DllOpen("user32.dll")
Local $iPID
Local $gameRom = "buggyboyjr" ; 									;<-- DEFINE YOUR STARTING GAME ROM HERE
Local $maxRoms = 3;
Local $a = 1
;RandomGame() ;uncomment this if you want a random game on start
GameRun()

While 1
    ShutDownKey()
	GameChange()
	Sleep(200)
WEnd

DllClose($hDLL)

Func GameChange()
If _IsPressed("39", $hDLL) Then ; hex 39 = number "9" (ASCII)  	 ;<-- DEFINE THE GAME CHANGE BUTTON HERE (HEX)
	$a = $a+1
	If $a > $maxRoms Then
		$a = 1
	EndIf
	GameSelect()
	ProcessClose($iPID)
	GameRun()
	Sleep (2000) ; cheap block against multiple presses
EndIf
EndFunc

Func RandomGame()
Local $randNum = Random(1, 3, 1)
$a = $randNum
GameSelect()
EndFunc

Func GameSelect()												 ;<-- DEFINE YOUR GAMES ROMS LIST HERE
If $a == 1 Then
	$gameRom = "buggyboyjr"
ElseIf $a == 2 Then
	$gameRom = "csprint"
Else;If $a == 3 Then
	$gameRom = "polepos"
EndIf
EndFunc

Func GameRun()
$MAMEpath = "C:\Users\marzia\Desktop\EARTHSHAKER\MAME160\"       ;<-- DEFINE YOUR MAME.EXE PATH HERE
$ROMpath = "C:\Users\marzia\Desktop\EARTHSHAKER\MAME160\roms\"   ;<-- DEFINE YOUR MAME ROMS PATH HERE
$iPID = ShellExecute ("mame.exe", $ROMpath&$gameRom, $MAMEpath)
EndFunc

Func ShutDownKey()
If _IsPressed(30, $hDLL) Then ;hex 30 = number "0" (ASCII)       ;<-- DEFINE THE SHUT DOWN BUTTON HERE (HEX)
Shutdown(5); shutdown (1) + force (4)
Sleep (2000) ; cheap block against multiple presses
EndIf
EndFunc


