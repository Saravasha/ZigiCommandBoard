;powerAction.ahk
#NoTrayIcon
#SingleInstance Force

; --- Read arguments
action = %1%   ; first argument
delay  = %2%   ; second argument
device = %3%   ; third argument

;  FOR DEBUGGING ONLY ;
;  MsgBox, action=%action%`ndelay=%delay%`ndevice=%device%

PlaySpeakers() 
{    
    SoundPlay, %A_WinDir%\Media\Starcrafty\Speakers.wav, wait
}

if (device != "Speakers")
{    
    RunWait, nircmd setdefaultsounddevice "Speakers"
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
;MsgBox, "%action%"
Gui, Destroy
ExitApp
return