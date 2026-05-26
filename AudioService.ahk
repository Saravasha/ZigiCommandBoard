;Zigiface.ahk
#NoTrayIcon
#SingleInstance Force
SetBatchLines, -1

; Register GUI helper
global guiBlacklist := []

; default state for audio
device := "Speakers"

;--------------------
; Functions
;--------------------

soundToggleClose() {
    Gui, 1: Hide
}

__soundToggleCloseTimer() {
    soundToggleClose()
}

; Display sound toggle GUI
soundToggleBox(device) {

    ; always rebuild cleanly (no conditional destroy)
    Gui, 1: Destroy

    Gui, 1: +ToolWindow - Caption + AlwaysOnTop + E0x20
    Gui, 1: Color, 202020
    Gui, 1: Font, s10, Segoe UI

    Gui, 1: Add, Text, x35 y8 cWhite, Default sound: %device%

    SysGet, screenx, 0
    SysGet, screeny, 1

    xpos := screenx - 275
    ypos := screeny - 100

    Gui, 1: Show, NoActivate x%xpos% y%ypos% h30 w200, soundToggleWin

    Gui, 1: +LastFound
    hwnd := WinExist()
    RegisterGUI(hwnd)

    SetTimer, __soundToggleCloseTimer, -2000
}

soundToggleState(state) {
    SoundPlay, C: \Users\Siavash Gosheh\Music\%state%.wav
}

RegisterGUI(hwnd) {
    global guiBlacklist
    guiBlacklist.Push(hwnd)
}

; -----------------------------
; INIT (RUNS ONCE)
; -----------------------------

OverlayShow() {
    global x, currentY, overlayVisible

    overlayVisible := true

    Gui, 2: Show, %"NoActivate x" x " y" currentY, OverlayWidget
}

OverlayHide() {
    global overlayVisible

    overlayVisible := false
    Gui, 2: Hide
}

OverlaySlideIn() {
    global currentY, x, targetY, slideSpeed

    currentY += slideSpeed

    if (currentY >= targetY) {
        currentY := targetY
        SetTimer, OverlaySlideIn, Off
    }

    Gui, 2: Show, %"NoActivate x" x " y" currentY, OverlayWidget
}

OverlaySlideOut() {
    global currentY, x, hiddenY, slideSpeed, overlayVisible

    currentY -= slideSpeed

    if (currentY <= hiddenY) {
        currentY := hiddenY
        SetTimer, OverlaySlideOut, Off
        Gui, 2: Hide
        overlayVisible := false
        return
    }

    Gui, 2: Show, %"NoActivate x" x " y" currentY, OverlayWidget
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

Gui, 2: +AlwaysOnTop - Caption + ToolWindow + E0x20
Gui, 2: Color, 000000
Gui, 2: Add, Picture, x0 y0 w801 h475, C: \Users\Siavash Gosheh\OneDrive\Pictures\Command Map.png

Gui, 2: Show, %"Hide x" x " y" currentY, OverlayWidget
Gui, 2: +LastFound
hwnd := WinExist()
RegisterGUI(hwnd)

SetTimer, CheckModifiersFn, 50

CheckModifiersFn() {
    global overlayVisible

    ctrl := GetKeyState("Ctrl", "P")
    shift := GetKeyState("Shift", "P")
    alt := GetKeyState("Alt", "P")

    if (ctrl && shift && alt) {
        if (!overlayVisible) {
            OverlayShow()
            SetTimer, OverlaySlideIn, 10
        }
    }
    else {
        if (overlayVisible) {
            SetTimer, OverlaySlideOut, 10
        }
    }
}

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

