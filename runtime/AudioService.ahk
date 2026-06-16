; AudioService.ahk

;--------------------
; Globals
;--------------------

; default state for audio
global device := "Speakers"

;--------------------
; Functions
;--------------------

Audio_PlaySound(path, wait := false) {
    
    if (wait) {
        SoundPlay, %path%, wait
        return
    }
    SoundPlay, %path%, %wait%
}

Audio_PlayAHKState(state, wait := false)
{
    path := A_ScriptDir . "\..\assets\" . state . ".wav"
    Audio_PlaySound(path, wait)
}

Audio_PlayDeviceName(device, wait := false) 
{
    path := A_ScriptDir . "\..\assets\" . device . ".wav"
    Audio_PlaySound(path, wait)
    
}

Audio_CycleAudioDevice()
{
    global device
    if (device == "") {
        device := "Speakers"
    }
    if (device == "Speakers") 
    {   
        device := "Headphones"
    }
    else if (device == "Headphones")
    {
        device := "Ultra-Wide"
    }
    else
    {
        device := "Speakers"    
    }

    RunWait, nircmd setdefaultsounddevice "%device%"
    UI_Notification_Show("Default device: " . device)
    Audio_PlayDeviceName(device)

}
