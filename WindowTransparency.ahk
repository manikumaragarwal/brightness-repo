; -----------------------------------------------------------------------------
; Window Transparency Control Script
; -----------------------------------------------------------------------------

#!Up::AdjustTransparency(10)   ; Increase transparency 
#!Down::AdjustTransparency(-10) ; Decrease transparency 

; Toggle Specific Transparency Levels
#!0::SetTransparency(255)      ; WIN+ALT+0 = Fully Opaque (100%)
#!9::SetTransparency(230)      ; WIN+ALT+9 = ~90% Opaque
#!8::SetTransparency(205)      ; WIN+ALT+8 = ~80% Opaque
#!7::SetTransparency(180)      ; WIN+ALT+7 = ~70% Opaque
#!6::SetTransparency(128)      ; WIN+ALT+6 = 50% Opaque
#!5::SetTransparency(64)       ; WIN+ALT+5 = ~25% Opaque

; Toggle Click-Through Mode (Window can't be clicked)
#!C::ToggleClickThrough()

; -----------------------------------------------------------------------------
; Function to adjust transparency by a step value
; Positive Step = More Opaque, Negative Step = More Transparent
; -----------------------------------------------------------------------------

AdjustTransparency(Step) {
    WinGet, Transparent, Transparent, A
    if (Transparent = "") ; If no transparency is set, start from 255 (fully opaque)
        Transparent := 255
    
    NewTrans := Transparent + Step
    
    ; Clamp values between 0 (invisible) and 255 (fully opaque)
    if (NewTrans > 255)
        NewTrans := 255
    if (NewTrans < 0)
        NewTrans := 0
    
    WinSet, Transparent, %NewTrans%, A
    ToolTip, Transparency: %NewTrans%/%255%
    SetTimer, RemoveToolTip, 1000
}

; -----------------------------------------------------------------------------
; Function to set a specific transparency level
; -----------------------------------------------------------------------------
SetTransparency(Level) {
    WinSet, Transparent, %Level%, A
    ToolTip, Transparency set to %Level%/%255%
    SetTimer, RemoveToolTip, 1000
}

; -----------------------------------------------------------------------------
; Function to toggle click-through mode
; -----------------------------------------------------------------------------
ToggleClickThrough() {
    static ClickThroughState := 0
    ClickThroughState := !ClickThroughState
    
    if (ClickThroughState) {
        WinSet, ExStyle, +0x20, A ; Add WS_EX_TRANSPARENT (click-through)
        ToolTip, Click-Through: ON
    } else {
        WinSet, ExStyle, -0x20, A ; Remove WS_EX_TRANSPARENT
        ToolTip, Click-Through: OFF
    }
    SetTimer, RemoveToolTip, 1000
}

; -----------------------------------------------------------------------------
; Remove the tooltip after a delay
; -----------------------------------------------------------------------------
RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return

; -----------------------------------------------------------------------------
; Display a quick help message on startup
; -----------------------------------------------------------------------------
#Persistent
SetTimer, ShowStartupHelp, 1000
ShowStartupHelp:
    SetTimer, ShowStartupHelp, Off
    MsgBox, 64, Window Transparency Controls,
    (LTrim
    Window Transparency Hotkeys Loaded!

    WIN + ALT + UP/DOWN: Adjust transparency
    WIN + ALT + 0: Fully opaque (100`%)
    WIN + ALT + 9: 90`% opaque
    WIN + ALT + 8: 80`% opaque
    WIN + ALT + 7: 70`% opaque
    WIN + ALT + 6: 50`% opaque
    WIN + ALT + 5: 25`% opaque
    
    WIN + ALT + C: Toggle click-through mode
    
    Note: Focus the window you want to modify first!
    )
return
