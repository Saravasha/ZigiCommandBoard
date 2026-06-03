;Shutdown.ahk
#NoTrayIcon
#SingleInstance Force

countdown := 60  ; seconds

; Play warning sound
SoundPlay, C:\Users\Siavash Gosheh\Music\shutdownwarning.wav

; Create GUI
Gui, +AlwaysOnTop +Resize +ToolWindow
Gui, Font, s14, Segoe UI
Gui, Add, Text, vTimerText w260 Center, Shutting down in %countdown% seconds...

Gui, Show,, Shutdown Timer

; Start timer (runs every 1 second)
SetTimer, UpdateTimer, 1000
return

UpdateTimer:
countdown--

GuiControl,, TimerText, Shutting down in %countdown% seconds...

if (countdown <= 0)
{
    SetTimer, UpdateTimer, Off
    Gui, Destroy
    Run, % A_ScriptDir "\powerAction.ahk shutdown 5 notSpeaker"
    return

}
return
