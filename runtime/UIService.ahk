; UIService.ahk

; --------------------
; Globals
; --------------------

; Register GUI helper
global guiBlacklist := []

global overlayVisible := false
global overlayEnabled := true

global widgetWidth := 801
global widgetHeight := 475

global overlay_x := 0
global overlay_y := -475

global overlayTargetY := 0
global overlayHiddenY := -475
global overlaySlideSpeed := 35


;---------------------
; Helper Functions
;---------------------
__BuildOptions(type, params)
{
    if (type = "CommandBoard")
        return "NoActivate x" . params.x . " y" . params.y
    
    if (type = "Notification")
        {
            x := (params.x != "") ? params.x : 0
            y := (params.y != "") ? params.y : 0
            w := (params.w != "") ? params.w : 200
            h := (params.h != "") ? params.h : 30
            
            return "NoActivate x" x " y" y " w" w " h" h
        }
        MsgBox, Invalid UI option type: %type%
    return ""
}

; --------------------
; Private Functions
; --------------------

__notificationToggleCloseTimer()
{
    __Notification_Close()
}

__Notification_Close()
{
    __HideGUI("NotificationUI")
}

__HideGUI(gui)
{
    Gui, %gui%:Hide
}

__ShowGUI(gui, options, title)
{
    Gui, %gui%:Show, %options%, %title%
}

; --------------------
; Functions
; --------------------

RegisterGUI(hwnd)
{
    global guiBlacklist
    guiBlacklist.Push(hwnd)
}

; Display sound toggle GUI
UI_Notification_Show(text)
{
    Gui, NotificationUI:Destroy

    Gui, NotificationUI:+ToolWindow -Caption +AlwaysOnTop +E0x20
    Gui, NotificationUI:Color, 202020
    Gui, NotificationUI:Font, s10, Segoe UI

    Gui, NotificationUI:Add, Text, x15 y8 cWhite, % "AHK: " . text

    guiWidth := (StrLen(text) * 7) + 60
    guiHeight := 30

    SysGet, wa, MonitorWorkArea
    xpos := waRight - guiWidth - 20
    ypos := waBottom - guiHeight - 20

    Gui, NotificationUI:Show, x%xpos% y%ypos% w%guiWidth% h%guiHeight% NoActivate

    Gui, NotificationUI:+LastFound
    hwnd := WinExist()
    RegisterGUI(hwnd)

    SetTimer, __notificationToggleCloseTimer, -2000
}