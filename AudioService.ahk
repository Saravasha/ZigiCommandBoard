; AudioService.ahk


;--------------------
; Globals
;--------------------

; default state for audio
global device := "Speakers"

;--------------------
; Functions
;--------------------

soundToggleState(state)
{
    SoundPlay, C:\Users\Siavash Gosheh\Music\%state%.wav
}

Audio_PlayDeviceName(device) 
{
    SoundPlay, %A_WinDir%\Media\Starcrafty\%device%.wav
}

CycleAudioDevice()
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
    soundToggleBox(device)
    Audio_PlayDeviceName(device)

}
