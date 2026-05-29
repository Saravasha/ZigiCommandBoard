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

__ShowCommandBoard()
{
    global overlay_x, overlay_y

    options := __BuildOptions("CommandBoard", {x: overlay_x, y: overlay_y})
    __ShowGUI("CommandBoardUI", options, "OverlayWidget")
}

; --------------------
; Functions
; --------------------

RegisterGUI(hwnd)
{
    global guiBlacklist
    guiBlacklist.Push(hwnd)
}

UI_CreateCommandBoard() {

    global widgetWidth
    global widgetHeight

    global overlay_x
    global overlay_y

    global overlayTargetY
    global overlayHiddenY
    global overlaySlideSpeed
 
    SysGet, wa, MonitorWorkArea
    
    overlay_x := waRight - widgetWidth - 10
    overlay_y := overlayHiddenY
    
    Gui, CommandBoardUI:+AlwaysOnTop -Caption +ToolWindow +E0x20
    Gui, CommandBoardUI:Color, 000000
    Gui, CommandBoardUI:Add, Picture, x0 y0 w801 h475, C:\Users\Siavash Gosheh\OneDrive\Pictures\Command Map.png
    
    options := "Hide x" . overlay_x . " y" . overlay_y
    __ShowGUI("CommandBoardUI", options, "OverlayWidget")
    Gui, CommandBoardUI:+LastFound
    hwnd := WinExist()
    RegisterGUI(hwnd)
}
UI_CreateCommandBoard()


UI_CommandBoard_Show() {
    global overlay_x, overlay_y, overlayVisible

    overlayVisible := true

    __ShowCommandBoard()
}

UI_CommandBoard_Hide() {
    global overlayVisible

    overlayVisible := false
    __HideGUI("CommandBoardUI")
}


UI_CommandBoard_SlideIn() {
    global overlay_y, overlay_x, overlayTargetY, overlaySlideSpeed

    overlay_y += overlaySlideSpeed

    if (overlay_y >= overlayTargetY) {
        overlay_y := overlayTargetY
        SetTimer, UI_CommandBoard_SlideIn, Off
    }

    __ShowCommandBoard()
}

UI_CommandBoard_SlideOut() {
    global overlay_y, overlay_x, overlayHiddenY, overlaySlideSpeed, overlayVisible

    overlay_y -= overlaySlideSpeed

    if (overlay_y <= overlayHiddenY) {
        overlay_y := overlayHiddenY
        SetTimer, UI_CommandBoard_SlideOut, Off
        __HideGUI("CommandBoardUI")
        overlayVisible := false
        return
    }

    __ShowCommandBoard()
}


; Display sound toggle GUI
UI_Notification_Show(text)
{
    Gui, NotificationUI:Destroy

    Gui, NotificationUI:+ToolWindow -Caption +AlwaysOnTop +E0x20
    Gui, NotificationUI:Color, 202020
    Gui, NotificationUI:Font, s10, Segoe UI

    Gui, NotificationUI:Add, Text, x15 y8 cWhite, AHK: %text%

    Gui, NotificationUI:Show, Hide AutoSize
    Gui, NotificationUI:Default
    GuiControlGet, textPos, Pos, NotificationText

    padding := 30
    guiWidth := (StrLen(text) * 7) + 60
    guiHeight := 30

    SysGet, wa, MonitorWorkArea
    xpos := waRight - guiWidth - 20 
    ypos := waBottom - guiHeight - 20

    MsgBox % "x=" xpos " y=" ypos " w=" guiWidth " h=" guiHeight
    options := __BuildOptions("Notification", {x: xpos, y: ypos, w: guiWidth, h: guiHeight})

    __ShowGUI("NotificationUI", options, "Notification")

    Gui, NotificationUI:+LastFound
    hwnd := WinExist()
    RegisterGUI(hwnd)

    SetTimer, __notificationToggleCloseTimer, -2000
}