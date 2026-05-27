; UIService.ahk

; --------------------
; Globals
; --------------------

global overlayVisible := false
global overlayEnabled := true

global widgetWidth := 801
global widgetHeight := 475

global x := 0
global currentY := -475

global targetY := 0
global hiddenY := -475
global slideSpeed := 35

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
