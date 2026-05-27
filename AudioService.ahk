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

CycleAudioDevice()
{
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

}
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
