;powerAction.ahk
#NoTrayIcon
#SingleInstance Force

; --- Read arguments
action = %1%   ; first argument
delay  = %2%   ; second argument
; device = %3%   ; third argument

;  FOR DEBUGGING ONLY ;
; MsgBox, % "action = " action " delay = " delay " device = " device


; Create hidden GUI to keep thread alive
Gui, +AlwaysOnTop -SysMenu +ToolWindow
Gui, Show, Hide


msDelay := delay * 1000
path := A_ScriptDir . "\..\assets\" . "Stargate_What" . ".wav"
SoundPlay, %path%
SetTimer, __DoAction, -%msDelay%
return


__DoAction:


; MsgBox, % "Performing action: " action " with device: " device "with a delay of " delay " seconds."

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