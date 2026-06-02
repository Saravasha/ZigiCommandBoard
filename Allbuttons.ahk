;Allbuttons.ahk
#MaxThreadsPerHotkey 1
#MaxThreadsBuffer Off
#Persistent         ; This keeps the script running permanently.
#SingleInstance Force     ; Only allows one instance of the script to run.
FileEncoding, UTF-8
;Modifiers: ; + = shift ; ! = alt ; ^ = ctrl
#include %A_ScriptDir%\Orchestrator.ahk
;--------------------
; Globals
;--------------------
ahkExe := "C:\Program Files\AutoHotkey\AutoHotkey.exe"
commandScript := A_ScriptDir . "\electron\Commands.ahk"
wasDown := false
SetBatchLines, -1

;--------------------
; Functions
;--------------------

IsGameActive()
{ 
    if WinActive("ahk_exe StarCraft.exe")
        return true
    if WinActive("ahk_exe Wow.exe")
        return true
    if WinActive("ahk_exe Warcraft III.exe")
        return true
    
    return false
}

RunCommand(id)
{
    global ahkExe, commandScript

    cmd := """" ahkExe """ """ commandScript """ " id

    RunWait, %cmd%
}

SendPipe(msg) {

    pipe := DllCall("CreateFile"
        , "Str", "\\.\pipe\zigi-board"
        , "UInt", 0x40000000  ; GENERIC_WRITE
        , "UInt", 0
        , "UInt", 0
        , "UInt", 3          ; OPEN_EXISTING
        , "UInt", 0
        , "UInt", 0
        , "Ptr")

    if (pipe = -1)
        return false
        data := msg . "`n"
        VarSetCapacity(buf, StrPut(data, "UTF-8"), 0)
        StrPut(data, &buf, "UTF-8")

        DllCall("WriteFile"
            , "Ptr", pipe
            , "Ptr", &buf
            , "UInt", StrLen(data)
            , "UInt*", written
            , "UInt", 0)

    DllCall("CloseHandle", "Ptr", pipe)
    return true
}

; -------------------
; Persistent Listener
; -------------------

SetTimer, CheckModifiersFn, 50

CheckModifiersFn() {
    global overlayVisible
    global wasDown
    ; Escape early if script is suspended
    if (A_IsSuspended)
        return

    ctrl  := GetKeyState("Ctrl", "P")
    shift := GetKeyState("Shift", "P")
    alt   := GetKeyState("Alt", "P")

        if (ctrl && shift && alt)
        {
            if (!wasDown)
            {
                SendPipe("show")
                wasDown := true
            }
        }
        else
        {
            if (wasDown)
            {
                SendPipe("hide")
                wasDown := false
            }
    }
}

; --------------------
; Hotkeys
; --------------------

!^E::
RunCommand("minimize_all")
return

!^+Z::
RunCommand("max_all")
return 


!^+X::
RunCommand("horizontal_tile_windows")
return


!^+C::
RunCommand("cascade_windows")
return

!^+V::
RunCommand("vertical_tile_windows")
return

; Empty trash
#Del::
RunCommand("file_recycle_empty")
return

+!NumpadSub::
RunCommand("subscript_clipboard")
return

+!NumpadAdd::
RunCommand("superscript_clipboard")
return 


^F11::
RunCommand("volume_mixer")
return
 
!^C::
RunCommand("calculator")
return

^!D:: 
RunCommand("downloads")
return

^!+G::
RunCommand("google_search_clipboard")
return

^!G::
RunCommand("google_calendar")
return

^!P:: 
RunCommand("gmail")
return

^!+T:: 
RunCommand("programs_and_features")
return

^!+U:: 
RunCommand("task_scheduler")
return

^!+I::
RunCommand("clock")
return

; -- Command to open file in Sublime Text 3
#ifWinActive ahk_class CabinetWClass  ; file Explorer
+!S::
RunCommand("open_with_sublime_text")
return
#ifWinActive

; -- Command to open file in Windows Media Player
#ifWinActive ahk_class CabinetWClass  ; file Explorer
+!W::
RunCommand("open_with_windows_media_player")
return
#ifWinActive

; -- AHK Script Toggler
+F5::
Suspend, Permit
Orchestrator_ToggleAHK()
return

; -- AHK reload
#F5::
Suspend Permit
Orchestrator_ReloadAHK()
return

+Pause::
Orchestrator_CycleAudioDevice()
return

; -- Close windows/apps Shortcut. Ctrl+W
#If WinActive("Calculator") or WinActive("Volume Mixer") or WinActive("Clock") or WinActive("Task Manager") or WinActive("Task Scheduler")
^W::
WinClose
return
#If 

#If !IsGameActive()

; -- Win+Arrow Functions
; Win + Up
!NumpadMult::Send, #{Up}
; Win + Lefta
!Numpad7::Send, #{Left}
;Win + Down 
!Numpad8::Send, #{Down}◘
; Win + RightO
!Numpad9::Send, #{Right}
#If 

; -- Window Commands
#If !IsGameActive()
!^Q::Send, +#{m}
return
#If

!+PgUp::
Orchestrator_RebootPC()
return

!+PgDn::
Orchestrator_ShutdownPC()
return

#IfWinActive Warcraft III
; Recommended for performance
#NoEnv

; Better and more reliable
SendMode Input

; Press the < key and click and un-click the left mouse button
+<::
<::
click Down left
click Up left
return

; Press the z key and click and un-click the right mouse button
+Z::
Z::
click Down right
click Up right
return

!^1::
send {F1}
return

!^2::
send {F2}
return

!^3::
send {F3}
return

!^4::
send {F4}
return

;Idle Workers remap to Alt+Q

+!Q::
send +{F8}
return

^!Q::
send ^{F8}
return

!Q::
send {F8}
return

^Q::
click Down left
click Up left
return 

^W::
click Down left
click Up left
return 

^E::
click Down left
click Up left
return 

^R::
click Down left
click Up left
return 

;focus selected unit
^F::
send ^{C}
return

; remap base cycling
SC029::
send {BackSpace}
return

#IfWinActive

#IfWinActive Diablo III

; Recommended for performance
#NoEnv

; Better and more reliable
SendMode Input

; Press the Q key and click and un-click the left mouse button
^Q::
+Q::
Q::
click Down left
keywait Q
click Up left
return

^<::
+<::
<::
click Down left
click Up left
return

; Press the W key and click and un-click the right mouse button
+W::
W::
click Down right
keywait W
click Up right
return

#IfWinActive
