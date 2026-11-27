; ==========================================
; Persistence.ahk
; AutoHotkey v1.1.37
; ==========================================

Persistence_Init()
{
    global VirtualClipboards := {}
    global VirtualClipboard2 := ""
    global VirtualClipboard3 := ""
    global VirtualClipboard4 := ""

    global VirtualClipboardQueue := []
    global VirtualClipboardBusy := false

    OnMessage(0x004A, "Persistence_Receive")
}

Persistence_Receive(wParam, lParam, msg, hwnd)
{
    global VirtualClipboardQueue
    OutputDebug, Persistence_Receive entered
    MsgBox, 64, IPC Debug, WM_COPYDATA received!

    dataSize := NumGet(lParam + A_PtrSize, 0, "UInt")
    dataPtr := NumGet(lParam + 2 * A_PtrSize, 0, "Ptr")

    if (!dataPtr || dataSize < 2 || Mod(dataSize, 2))
        return false

    payload := StrGet(dataPtr, "UTF-16")
    parts := StrSplit(payload, "|")

    if (parts.Length() != 2)
        return false

    slot := parts[1] + 0
    operation := parts[2]

    if (slot != 2 && slot != 3 && slot != 4)
        return false

    if (operation != "copy"
        && operation != "cut"
        && operation != "paste")
        return false

    ; Queue the operation rather than executing it
    ; inside the Windows message callback.
    VirtualClipboardQueue.Push({slot: slot, operation: operation})

    timerCallback := Func("Persistence_ProcessNext")
    ; Temporarily disable queue processing for this test.
    SetTimer, %timerCallback%, -10
    OutputDebug, % "Queued: " slot "|" operation
    return true
}

Persistence_ProcessNext()
{
    global VirtualClipboardQueue, VirtualClipboardBusy

    MsgBox, 64, Queue Debug, Persistence_ProcessNext executed!

    if (VirtualClipboardBusy)
        return

    VirtualClipboardBusy := true

    while (VirtualClipboardQueue.Length() > 0)
    {
        request := VirtualClipboardQueue.RemoveAt(1)
        VirtualClipboard(request.slot, request.operation)
    }

    VirtualClipboardBusy := false
}


VirtualClipboard(slot, operation)
{
    global VirtualClipboards

    if (operation = "copy")
    {
        Clipboard := ""
        SendInput, ^c
        ClipWait, 1

        VirtualClipboards[slot] := Clipboard

        ToolTip, % "Saved slot " slot ": " VirtualClipboards[slot]
        SetTimer, RemoveClipboardTooltip, -2000
    }
    else if (operation = "paste")
    {
        ToolTip, % "Slot " slot ": " VirtualClipboards[slot]
        SetTimer, RemoveClipboardTooltip, -2000
    }
}

RemoveClipboardTooltip:
ToolTip
return

VirtualClipboardDebug()
{
    global VirtualClipboards

    report := ""

    for _, slot in [2, 3, 4]
    {
        if (VirtualClipboards.HasKey(slot))
        {
            savedClipboard := ClipboardAll
            Clipboard := VirtualClipboards[slot]

            report .= "Slot " slot ": " Clipboard "`n"

            Clipboard := savedClipboard
        }
        else
        {
            report .= "Slot " slot ": EMPTY`n"
        }
    }

    MsgBox, 64, Virtual Clipboard Debug, %report%
}