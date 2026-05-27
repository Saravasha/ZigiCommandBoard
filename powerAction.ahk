;powerAction.ahk
#NoTrayIcon
#SingleInstance Force

; --- Read arguments
action = %1%   ; first argument
delay  = %2%   ; second argument
device = %3%   ; third argument

;  FOR DEBUGGING ONLY ;
; MsgBox, % "action = " action " delay = " delay " device = " device

PlaySpeakers() 
{    
    SoundPlay, %A_WinDir%\Media\Starcrafty\Speakers.wav, wait
}


if (device != "Speakers" && action = "shutdown")
{    
    RunWait, nircmd setdefaultsounddevice "Speakers"
    device := "Speakers"
    PlaySpeakers()
}

SoundPlay, %A_WinDir%\Media\Starcrafty\Stargate_What.wav

; Create hidden GUI to keep thread alive
Gui, +AlwaysOnTop -SysMenu +ToolWindow
Gui, Show, Hide

msDelay := delay * 1000
SetTimer, __DoAction, -%msDelay%
return

__DoAction:


if (action = "shutdown")
{
    Shutdown, 1
}
else if (action = "reboot")
{
    Shutdown, 2
}

Gui, Destroy
ExitApp
return