; Orchestrator.ahk
; Acts like a Controller for the project.
#include %A_ScriptDir%\UIService.ahk
#include %A_ScriptDir%\AudioService.ahk

; --- Read arguments
device = %1%   ; first argument
; --------------------
; Functions
; --------------------

Orchestrator_CycleAudioDevice()
{
    Audio_CycleAudioDevice()
}

Orchestrator_ToggleAHK()
{
    global toggle

    Suspend, Permit

    toggle := !toggle

    if (toggle)
    {
        overlayEnabled := false

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
    Run % A_ScriptDir "\powerAction.ahk reboot 5"
}

Orchestrator_ShutdownPC() 
{
    global device

    if (device != "Speakers")
    {    
        device := "Speakers"
        UI_Notification_Show("Default device: " . device)
        Audio_PlayDeviceName(device, true)
        RunWait, % "nircmd setdefaultsounddevice ""Speakers"""
    }
    
    UI_Notification_Show("Shutting down...") 
    Run % A_ScriptDir "\powerAction.ahk shutdown 5"
}

