; Orchestrator.ahk
; Acts like a Controller for the project.
#include %A_ScriptDir%\UIService.ahk
#include %A_ScriptDir%\AudioService.ahk

; --------------------
; Functions
; --------------------

Orchestrator_CycleAudioDevice()
{
    Audio_CycleAudioDevice()
}

Orchestrator_CommandBoardShow() {
    UI_CommandBoard_Show()
    SetTimer, UI_CommandBoard_SlideIn, 10
}

Orchestrator_CommandBoardSlideOut() {
    SetTimer, UI_CommandBoard_SlideOut, 10
}

Orchestrator_ToggleAHK()
{
    global toggle

    Suspend, Permit

    toggle := !toggle

    if (toggle)
    {
        overlayEnabled := false

        UI_CommandBoard_Hide()

        UI_Notification_Show("Suspended/Offline")
        Audio_PlayAHKState("ahk off")

        Suspend, On
    }
    else
    {
        overlayEnabled := true

        Suspend, Off

        UI_Notification_Show("Online")
        Audio_PlayAHKState("ahk online")
    }
}

Orchestrator_ReloadAHK() {
    ; second arg equals to wait.
    UI_Notification_Show("Reloading...")
    Audio_PlayAHKState("ahk reloading", true)
    Reload
}

Orchestrator_RebootPC() 
{
    UI_Notification_Show("Rebooting...")
    Run % A_ScriptDir "\powerAction.ahk reboot 5 " device
}

Orchestrator_ShutdownPC() 
{
    global device
    if (device != "Speakers")
    {    
        device := "Speakers"
        RunWait, % "nircmd setdefaultsounddevice ""Speakers"""
        Audio_PlayDeviceName(device, true)
        UI_Notification_Show("Default device: " . device)
    }

    UI_Notification_Show("Shutting down...") 
    Run % A_ScriptDir "\powerAction.ahk shutdown 5 " device
}