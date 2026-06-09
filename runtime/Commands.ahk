;Commands.ahk
#NoTrayIcon
#SingleInstance Force

global CommandMap := {}

;--------------------
; Functions
;--------------------

WinMinimizeAll() {
    WinMinimizeAll
    return
}
  
MaxAllWindows()
{
    WinGet, id, List
    Loop, %id%
         
    {
        hwnd := id%A_Index%

        WinGet, MinMax, MinMax, ahk_id %hwnd%
        WinGetClass, class, ahk_id %hwnd%

        if (class = "Progman")
            continue
        if (class = "WorkerW")
            continue
        if (class = "AutoHotkeyGUI")
            continue
        if (class = "Shell_TrayWnd")
            continue

        
        WinGetTitle, title, ahk_id %hwnd%
        if (title = "")
            continue
        ; if (title = "Zigi Command Board")
        ;     continue

        WinGet, ProcessName, ProcessName, ahk_id %hwnd%

        if (ProcessName = "Zigi Command Board.exe")
            continue

        if (ProcessName = "electron.exe")
            continue

        WinMaximize, ahk_id %hwnd%
    }
    return
}

HorizontalTileWindows() {
    DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
    return
}


CascadeWindows() {
    DllCall( "CascadeWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
    return
}

VerticalTileWindows() {
    DllCall( "TileWindows", uInt,0, Int,1, Int,0, Int,0, Int,0 )
    return
}

FileRecycleEmpty() {
    FileRecycleEmpty
    return
}


SubscriptClipboard() {

    ; copy selected text
    Clipboard :=
    Send ^c
    ClipWait, 1

    text := Clipboard

    ; -----------------------------
    ; symbols
    ; -----------------------------
    text := StrReplace(text, "+", "₊")
    text := StrReplace(text, "-", "₋")
    text := StrReplace(text, "=", "₌")
    text := StrReplace(text, "(", "₍")
    text := StrReplace(text, ")", "₎")

    ; -----------------------------
    ; digits
    ; -----------------------------
    text := StrReplace(text, "0", "₀")
    text := StrReplace(text, "1", "₁")
    text := StrReplace(text, "2", "₂")
    text := StrReplace(text, "3", "₃")
    text := StrReplace(text, "4", "₄")
    text := StrReplace(text, "5", "₅")
    text := StrReplace(text, "6", "₆")
    text := StrReplace(text, "7", "₇")
    text := StrReplace(text, "8", "₈")
    text := StrReplace(text, "9", "₉")

    ; -----------------------------
    ; lowercase
    ; -----------------------------
    text := StrReplace(text, "a", "ₐ")
    text := StrReplace(text, "e", "ₑ")
    text := StrReplace(text, "h", "ₕ")
    text := StrReplace(text, "i", "ᵢ")
    text := StrReplace(text, "j", "ⱼ")
    text := StrReplace(text, "k", "ₖ")
    text := StrReplace(text, "l", "ₗ")
    text := StrReplace(text, "m", "ₘ")
    text := StrReplace(text, "n", "ₙ")
    text := StrReplace(text, "o", "ₒ")
    text := StrReplace(text, "p", "ₚ")
    text := StrReplace(text, "r", "ᵣ")
    text := StrReplace(text, "s", "ₛ")
    text := StrReplace(text, "t", "ₜ")
    text := StrReplace(text, "u", "ᵤ")
    text := StrReplace(text, "v", "ᵥ")
    text := StrReplace(text, "x", "ₓ")

    ; -----------------------------
    ; uppercase
    ; -----------------------------
    text := StrReplace(text, "A", "ₐ")
    text := StrReplace(text, "E", "ₑ")
    text := StrReplace(text, "H", "ₕ")
    text := StrReplace(text, "I", "ᵢ")
    text := StrReplace(text, "J", "ⱼ")
    text := StrReplace(text, "K", "ₖ")
    text := StrReplace(text, "L", "ₗ")
    text := StrReplace(text, "M", "ₘ")
    text := StrReplace(text, "N", "ₙ")
    text := StrReplace(text, "O", "ₒ")
    text := StrReplace(text, "P", "ₚ")
    text := StrReplace(text, "R", "ᵣ")
    text := StrReplace(text, "S", "ₛ")
    text := StrReplace(text, "T", "ₜ")
    text := StrReplace(text, "U", "ᵤ")
    text := StrReplace(text, "V", "ᵥ")
    text := StrReplace(text, "X", "ₓ")

    ; paste transformed text
    Clipboard := text
    ClipWait, 1
    Send ^v
}

SuperscriptClipboard() {

    ; copy selected text
    Clipboard :=
    Send ^c
    ClipWait, 1

    text := Clipboard

    ; -----------------------------
    ; symbols
    ; -----------------------------
    text := StrReplace(text, "+", "⁺")
    text := StrReplace(text, "-", "⁻")
    text := StrReplace(text, "=", "⁼")
    text := StrReplace(text, "(", "⁽")
    text := StrReplace(text, ")", "⁾")

    ; -----------------------------
    ; digits
    ; -----------------------------
    text := StrReplace(text, "0", "⁰")
    text := StrReplace(text, "1", "¹")
    text := StrReplace(text, "2", "²")
    text := StrReplace(text, "3", "³")
    text := StrReplace(text, "4", "⁴")
    text := StrReplace(text, "5", "⁵")
    text := StrReplace(text, "6", "⁶")
    text := StrReplace(text, "7", "⁷")
    text := StrReplace(text, "8", "⁸")
    text := StrReplace(text, "9", "⁹")

    ; -----------------------------
    ; lowercase
    ; -----------------------------
    text := StrReplace(text, "a", "ᵃ")
    text := StrReplace(text, "b", "ᵇ")
    text := StrReplace(text, "c", "ᶜ")
    text := StrReplace(text, "d", "ᵈ")
    text := StrReplace(text, "e", "ᵉ")
    text := StrReplace(text, "f", "ᶠ")
    text := StrReplace(text, "g", "ᵍ")
    text := StrReplace(text, "h", "ʰ")
    text := StrReplace(text, "i", "ⁱ")
    text := StrReplace(text, "j", "ʲ")
    text := StrReplace(text, "k", "ᵏ")
    text := StrReplace(text, "l", "ˡ")
    text := StrReplace(text, "m", "ᵐ")
    text := StrReplace(text, "n", "ⁿ")
    text := StrReplace(text, "o", "ᵒ")
    text := StrReplace(text, "p", "ᵖ")
    text := StrReplace(text, "r", "ʳ")
    text := StrReplace(text, "s", "ˢ")
    text := StrReplace(text, "t", "ᵗ")
    text := StrReplace(text, "u", "ᵘ")
    text := StrReplace(text, "v", "ᵛ")
    text := StrReplace(text, "w", "ʷ")
    text := StrReplace(text, "x", "ˣ")
    text := StrReplace(text, "y", "ʸ")
    text := StrReplace(text, "z", "ᶻ")

    ; -----------------------------
    ; uppercase
    ; -----------------------------
    text := StrReplace(text, "A", "ᵃ")
    text := StrReplace(text, "B", "ᵇ")
    text := StrReplace(text, "C", "ᶜ")
    text := StrReplace(text, "D", "ᵈ")
    text := StrReplace(text, "E", "ᵉ")
    text := StrReplace(text, "F", "ᶠ")
    text := StrReplace(text, "G", "ᵍ")
    text := StrReplace(text, "H", "ʰ")
    text := StrReplace(text, "I", "ⁱ")
    text := StrReplace(text, "J", "ʲ")
    text := StrReplace(text, "K", "ᵏ")
    text := StrReplace(text, "L", "ˡ")
    text := StrReplace(text, "M", "ᵐ")
    text := StrReplace(text, "N", "ⁿ")
    text := StrReplace(text, "O", "ᵒ")
    text := StrReplace(text, "P", "ᵖ")
    text := StrReplace(text, "R", "ʳ")
    text := StrReplace(text, "S", "ˢ")
    text := StrReplace(text, "T", "ᵗ")
    text := StrReplace(text, "U", "ᵘ")
    text := StrReplace(text, "V", "ᵛ")
    text := StrReplace(text, "W", "ʷ")
    text := StrReplace(text, "X", "ˣ")
    text := StrReplace(text, "Y", "ʸ")
    text := StrReplace(text, "Z", "ᶻ")

    ; paste transformed text
    Clipboard := text
    ClipWait, 1
    Send ^v
}

VolumeMixer() {
    if WinExist("Volume Mixer")
        WinActivate
    else
        Run, SndVol.exe
    return
}
Calculator() {
    if WinExist("Calculator")
        WinActivate
    else
        Run calc.exe
    return
}

Downloads() {
    if WinExist("Downloads")
        WinActivate
    else
        Run, C:\Users\Siavash Gosheh\Downloads
    return
}

GoogleSearchClipboard() {
    Send ^g
    ClipWait, 0.5
    Run, http://www.google.com/search?q=%clipboard%
    return
}

GoogleCalendar() {
    if WinExist("Google Calendar")
        WinActivate
    else
        Run, https://calendar.google.com/calendar/u/0/r/week?pli=1
    return
}

Gmail() {
    if WinExist("Inkorgen")
        WinActivate
    else
        Run, https://mail.google.com/mail/u/0/
    return
}

Projects() {
    if WinExist("Projects")
        WinActivate
    else
        Run, C:\Users\Siavash Gosheh\Projects
    return
}


ProgramsAndFeatures() {
    if WinExist("Programs and Features")
        WinActivate
    else
        Run, appwiz.cpl
    return
}


TaskScheduler() {
    if WinExist("Task Scheduler")
        WinActivate
    else
        Run, taskschd.msc
    return
}

Clock() {
    if WinExist("Clock")
        WinActivate
    else
        Run, explorer.exe shell:Appsfolder\Microsoft.WindowsAlarms_8wekyb3d8bbwe!App 
    return
}

OpenWithSublimeText() {
    revert_clipboard := clipboardAll
    clipboard =
    send ^{c}
    clipWait, 0.3
    sublime_path := portable_apps "C:\Program Files\Sublime Text\sublime_text.exe"
if fileExist(clipboard)
    run, %sublime_path% "%clipboard%", , useErrorLevel
clipboard := revert_clipboard
return
}

OpenWithWindowsMediaPlayer() {
    revert_clipboard := clipboardAll
    clipboard =
    send ^{c}   
    clipWait, 0.3
    mediaplayer_path := portable_apps "C:\Program Files\Windows Media Player\wmplayer.exe"
if fileExist(clipboard)
    run, %mediaplayer_path% "%clipboard%", , useErrorLevel
clipboard := revert_clipboard
return
}

; --------------------
; REGISTRATION
; --------------------

CommandMap["minimize_all"] := Object("name", "Minimize All Windows", "desc", "Minimizes all windows", "hotkey", "Ctrl+Alt+E","category", "Window Management", "exec", Func("WinMinimizeAll"))
CommandMap["max_all"] := Object("name", "Max All Windows", "desc", "Maximizes all visible windows", "hotkey", "Ctrl+Shift+Alt+Z","category", "Window Management", "exec", Func("MaxAllWindows"))
CommandMap["horizontal_tile_windows"] := Object("name", "Horizontal Tile Windows", "desc", "Tiles all visible windows horizontally", "hotkey", "Ctrl+Shift+Alt+X","category", "Window Management", "exec", Func("HorizontalTileWindows"))
CommandMap["cascade_windows"] := Object("name", "Cascade Windows", "desc", "Cascades all visible windows", "hotkey", "Ctrl+Shift+Alt+C","category", "Window Management", "exec", Func("CascadeWindows"))
CommandMap["vertical_tile_windows"] := Object("name", "Vertical Tile Windows", "desc", "Tiles all visible windows vertically", "hotkey", "Ctrl+Shift+Alt+V","category", "Window Management", "exec", Func("VerticalTileWindows"))
CommandMap["file_recycle_empty"] := Object("name", "Empty Recycle Bin", "desc", "Empties the recycle bin", "hotkey", "Win+Delete","category", "System", "exec", Func("FileRecycleEmpty"))
CommandMap["subscript_clipboard"] := Object("name", "Subscript Clipboard", "desc", "Transforms selected text to subscript and pastes it", "hotkey", "Shift+Alt+NumpadMinus","category", "Text Transformation", "exec", Func("SubscriptClipboard"))
CommandMap["superscript_clipboard"] := Object("name", "Superscript Clipboard", "desc", "Transforms selected text to superscript and pastes it", "hotkey", "Shift+Alt+NumpadAdd","category", "Text Transformation", "exec", Func("SuperscriptClipboard"))
CommandMap["volume_mixer"] := Object("name", "Volume Mixer", "desc", "Toggles the volume mixer", "hotkey", "Ctrl+F11","category", "System", "exec", Func("VolumeMixer"))
CommandMap["calculator"] := Object("name", "Calculator", "desc", "Opens or toggles the calculator app", "hotkey", "Ctrl+Alt+C","category", "System", "exec", Func("Calculator"))
CommandMap["downloads"] := Object("name", "Downloads", "desc", "Opens the Downloads folder", "hotkey", "Ctrl+Alt+D","category", "System", "exec", Func("Downloads"))
CommandMap["google_search_clipboard"] := Object("name", "Google Clipboard", "desc", "Prompts for a search query on the clipboard and searches it on Google", "hotkey", "Ctrl+Alt+Shift+G","category", "System", "exec", Func("GoogleSearchClipboard"))
CommandMap["google_calendar"] := Object("name", "Google Calendar", "desc", "Opens the Google Calendar app", "hotkey", "Ctrl+Alt+G","category", "System", "exec", Func("GoogleCalendar"))
CommandMap["gmail"] := Object("name", "Gmail", "desc", "Opens the Gmail app", "hotkey", "Ctrl+Alt+P","category", "System", "exec", Func("Gmail"))
CommandMap["programs_and_features"] := Object("name", "Programs and Features", "desc", "Opens the Programs and Features app", "hotkey", "Ctrl+Alt+Shift+T","category", "System", "exec", Func("ProgramsAndFeatures"))
CommandMap["task_scheduler"] := Object("name", "Task Scheduler", "desc", "Opens the Task Scheduler app", "hotkey", "Ctrl+Alt+Shift+U","category", "System", "exec", Func("TaskScheduler"))
CommandMap["clock"] := Object("name", "Clock", "desc", "Opens the Windows Clock app", "hotkey", "Ctrl+Alt+Shift+I","category", "System", "exec", Func("Clock"))
CommandMap["open_with_sublime_text"] := Object("name", "Open with Sublime Text", "desc", "Opens the selected file in Sublime Text 3", "hotkey", "Shift+Alt+S","category", "System", "exec", Func("OpenWithSublimeText"))
CommandMap["open_with_windows_media_player"] := Object("name", "Open with Windows Media Player", "desc", "Opens the selected file in Windows Media Player", "hotkey", "Shift+Alt+W","category", "System", "exec", Func("OpenWithWindowsMediaPlayer"))
CommandMap["projects"] := Object("name", "Projects", "desc", "Opens the Projects folder", "hotkey", "Ctrl+Alt+Shift+P","category", "System", "exec", Func("Projects"))
; --------------------
; ENTRYPOINT
; --------------------

if (A_Args.Length() > 0)
{
    cmd := A_Args[1]

    ;msgBox, Received command: %cmd%

    if (CommandMap.HasKey(cmd))
    {
        CommandMap[cmd].exec.Call()
    }
}

ExitApp
