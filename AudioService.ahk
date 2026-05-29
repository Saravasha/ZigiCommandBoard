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
    path := "C:\Users\Siavash Gosheh\Music\" state ".wav"
    Audio_PlaySound(path, wait)
}

Audio_PlayDeviceName(device, wait := false) 
{
    path := A_WinDir "\Media\Starcrafty\" device ".wav"
    Audio_PlaySound(path, wait)
    
}

Audio_CycleAudioDevice()
{
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
