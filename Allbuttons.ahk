;Allbuttons.ahk
#MaxThreadsPerHotkey 1
#MaxThreadsBuffer Off
#Persistent         ; This keeps the script running permanently.
#SingleInstance Force     ; Only allows one instance of the script to run.
FileEncoding, UTF-8

;Modifiers: ; + = shift ; ! = alt ; ^ = ctrl

;--------------------
; Globals
;--------------------
ahkExe := "C:\Program Files\AutoHotkey\AutoHotkey.exe"
commandScript := A_ScriptDir . "\Commands.ahk"

SetBatchLines, -1

IsGameActive()
{ 
    if WinActive("ahk_exe StarCraft.exe")
        return true
    if WinActive("ahk_exe Wow.exe")
        return true
    if WinActive("ahk_exe Warcraft III.exe")
        return true

    return false
}

; Register GUI helper
global guiBlacklist := []

; default state for audio
device := "Speakers"

;--------------------
; Functions
;--------------------

soundToggleClose()
{
    Gui, 1:Hide
}

__soundToggleCloseTimer()
{
    soundToggleClose()
}

; Display sound toggle GUI
soundToggleBox(device)
{

    ; always rebuild cleanly (no conditional destroy)
    Gui, 1:Destroy

    Gui, 1:+ToolWindow -Caption +AlwaysOnTop +E0x20
    Gui, 1:Color, 202020
    Gui, 1:Font, s10, Segoe UI

    Gui, 1:Add, Text, x35 y8 cWhite, Default sound: %device%

    SysGet, screenx, 0
    SysGet, screeny, 1

    xpos := screenx - 275
    ypos := screeny - 100

    Gui, 1:Show, NoActivate x%xpos% y%ypos% h30 w200, soundToggleWin

    Gui, 1:+LastFound
    hwnd := WinExist()
    RegisterGUI(hwnd)

    SetTimer, __soundToggleCloseTimer, -2000
}

soundToggleState(state)
{
    SoundPlay, C:\Users\Siavash Gosheh\Music\%state%.wav
}

RegisterGUI(hwnd)
{
    global guiBlacklist
    guiBlacklist.Push(hwnd)
}

RunCommand(id)
{
    global ahkExe, commandScript

    cmd := """" ahkExe """ """ commandScript """ " id

    RunWait, %cmd%
}
; --------------------
; PERSISTENT LISTENERS
; --------------------

; -----------------------------
; INIT (RUNS ONCE)
; -----------------------------

OverlayShow() {
    global x, currentY, overlayVisible

    overlayVisible := true

    Gui, 2:Show, % "NoActivate x" x " y" currentY, OverlayWidget
}

OverlayHide() {
    global overlayVisible

    overlayVisible := false
    Gui, 2:Hide
}


OverlaySlideIn() {
    global currentY, x, targetY, slideSpeed

    currentY += slideSpeed

    if (currentY >= targetY) {
        currentY := targetY
        SetTimer, OverlaySlideIn, Off
    }

    Gui, 2:Show, % "NoActivate x" x " y" currentY, OverlayWidget
}

OverlaySlideOut() {
    global currentY, x, hiddenY, slideSpeed, overlayVisible

    currentY -= slideSpeed

    if (currentY <= hiddenY) {
        currentY := hiddenY
        SetTimer, OverlaySlideOut, Off
        Gui, 2:Hide
        overlayVisible := false
        return
    }

    Gui, 2:Show, % "NoActivate x" x " y" currentY, OverlayWidget
}

 
global overlayVisible := false
global overlayEnabled := true

global widgetWidth := 801
global widgetHeight := 475

global x := 0
global currentY := -475

global targetY := 0
global hiddenY := -475
global slideSpeed := 35

; -----------------------------
; UI SETUP (ONE TIME ONLY)
; -----------------------------
SysGet, wa, MonitorWorkArea

x := waRight - widgetWidth - 10
currentY := hiddenY

Gui, 2:+AlwaysOnTop -Caption +ToolWindow +E0x20
Gui, 2:Color, 000000
Gui, 2:Add, Picture, x0 y0 w801 h475, C:\Users\Siavash Gosheh\OneDrive\Pictures\Command Map.png

Gui, 2:Show, % "Hide x" x " y" currentY, OverlayWidget
Gui, 2:+LastFound
hwnd := WinExist()
RegisterGUI(hwnd)


SetTimer, CheckModifiersFn, 50

CheckModifiersFn() {
    global overlayVisible

    ctrl  := GetKeyState("Ctrl", "P")
    shift := GetKeyState("Shift", "P")
    alt   := GetKeyState("Alt", "P")

    if (ctrl && shift && alt)
    {
        if (!overlayVisible)
        {
            OverlayShow()
            SetTimer, OverlaySlideIn, 10
        }
    }
    else
    {
        if (overlayVisible)
        {
            SetTimer, OverlaySlideOut, 10
        }
    }
}

; --------------------
; HOTKEYS
; --------------------

!^E::
RunCommand("minimize_all")
return

!^+Z::
RunCommand("max_all")
return 


!^+X::
RunCommand("horizontal_tile_windows")
return


!^+C::
RunCommand("cascade_windows")
return

!^+V::
RunCommand("vertical_tile_windows")
return

; Empty trash
#Del::
RunCommand("file_recycle_empty")
return

+!NumpadSub::
RunCommand("subscript_clipboard")
return

+!NumpadAdd::
RunCommand("superscript_clipboard")
return 

; -- Volume Mixer
^F11::
RunCommand("volume_mixer")
return
 
; -- Run apps Keyboard Shortcuts.
!^C::
RunCommand("calculator")
return

; Open Downloads folder
^!D:: 
RunCommand("downloads")
return

; Google Search clipboarded text
^!+G::
RunCommand("google_search_clipboard")
return

; -- Google Calendar
^!G::
RunCommand("google_calendar")
return

; -- Gmail
^!P:: 
RunCommand("gmail")
return

; -- Programs and Features/Control Panel Submenu
^!+T:: 
RunCommand("programs_and_features")
return

; -- Task Scheduler
^!+U:: 
RunCommand("task_scheduler")
return

; -- Windows Clock App for setting timers and whatnot
^!+I::
RunCommand("clock")
return

; -- Command to open file in Sublime Text 3
#ifWinActive ahk_class CabinetWClass  ; file Explorer
+!S::
RunCommand("open_with_sublime_text")
return
#ifWinActive

; -- Command to open file in Windows Media Player
#ifWinActive ahk_class CabinetWClass  ; file Explorer
+!W::
RunCommand("open_with_windows_media_player")
return
#ifWinActive

; -- AHK Script Toggler
+F5::
Suspend Permit

toggle := !toggle

if (toggle)
{
    overlayEnabled := false

    Suspend On

    Gui, 2:Hide
    overlayVisible := false

    soundToggleState("ahk off")
}
else
{
    overlayEnabled := true

    Suspend Off

    soundToggleState("ahk online")
}

return

; -- AHK reload
#F5::
Suspend Permit
soundToggleState("ahk reloading")
SetTimer, __reloadAHK, -1500
return

__reloadAHK:
Reload
return

+Pause::

    if (device == "Speakers") 
    {   
        device := "Headphones"
        RunWait, nircmd setdefaultsounddevice "Headphones"
        SetTimer, __playHeadphones, -150
    }
    else if (device == "Headphones")
    {
        device := "Ultra-Wide"
        RunWait, nircmd setdefaultsounddevice "Ultra-Wide"
        SetTimer, __playUltraWide, -150
    }
    else
    {
        device := "Speakers"    
        RunWait, nircmd setdefaultsounddevice "Speakers"
        SetTimer, __playSpeakers, -150
    }


    soundToggleBox(device)
return

__playHeadphones:
SoundPlay, %A_WinDir%\Media\Starcrafty\Headphones.wav
return

__playUltraWide:
SoundPlay, %A_WinDir%\Media\Starcrafty\Ultra-Wide.wav
return

__playSpeakers:
SoundPlay, %A_WinDir%\Media\Starcrafty\Speakers.wav
return



; -- Close windows/apps Shortcut. Ctrl+W
#If WinActive("Calculator") or WinActive("Volume Mixer") or WinActive("Clock") or WinActive("Task Manager") or WinActive("Task Scheduler")
^W::
WinClose
return
#If 


#If !IsGameActive()

; -- Win+Arrow Functions
; Win + Up
!NumpadMult::Send, #{Up}
; Win + Lefta
!Numpad7::Send, #{Left}
;Win + Down 
!Numpad8::Send, #{Down}◘
; Win + RightO
!Numpad9::Send, #{Right}
#If 

; -- Window Commands
#If !IsGameActive()
!^Q::Send, +#{m}
return
#If

; -- Reboot and Shutdown Systems

; -- Reboot
!+PgUp::
Run, % A_ScriptDir "\powerAction.ahk reboot 5" device
return

; -- Shutdown
!+PgDn::
Run, % A_ScriptDir "\powerAction.ahk shutdown 5" device
if (device != "Speakers")
{
    device := "Speakers"
    Run, nircmd setdefaultsounddevice "Speakers"
    soundToggleBox("Speakers")
    RunWait, nircmd setdefaultsounddevice "Speakers"
}
return


; ----------------------------
#IfWinActive Warcraft III
; Recommended for performance
#NoEnv

; Better and more reliable
SendMode Input

; Press the < key and click and un-click the left mouse button
+<::
<::
click Down left
click Up left
return

; Press the z key and click and un-click the right mouse button
+Z::
Z::
click Down right
click Up right
return

!^1::
send {F1}
return

!^2::
send {F2}
return

!^3::
send {F3}
return

!^4::
send {F4}
return

;Idle Workers remap to Alt+Q

+!Q::
send +{F8}
return

^!Q::
send ^{F8}
return

!Q::
send {F8}
return

^Q::
click Down left
click Up left
return 

^W::
click Down left
click Up left
return 

^E::
click Down left
click Up left
return 

^R::
click Down left
click Up left
return 

;focus selected unit
^F::
send ^{C}
return

; remap base cycling
SC029::
send {BackSpace}
return

#IfWinActive

#IfWinActive Diablo III

; Recommended for performance
#NoEnv

; Better and more reliable
SendMode Input

; Press the Q key and click and un-click the left mouse button
^Q::
+Q::
Q::
click Down left
keywait Q
click Up left
return

^<::
+<::
<::
click Down left
click Up left
return

; Press the W key and click and un-click the right mouse button
+W::
W::
click Down right
keywait W
click Up right
return

#IfWinActive

