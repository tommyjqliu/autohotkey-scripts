#Requires AutoHotkey v2.0

; Settings
tap_threshold := 200  ; ms
hold_threshold := 200 ; ms

; State tracking
capslock_is_held := false
capslock_was_tapped := false

; Main CapsLock handler with timer
CapsLock::
{
    global capslock_is_held, capslock_was_tapped
    
    capslock_is_held := true
    capslock_was_tapped := false
    
    ; Set a timer to check if it's being held
    SetTimer check_capslock_hold, -hold_threshold
}

CapsLock Up::
{
    global capslock_is_held, capslock_was_tapped
    
    ; If timer already determined it was held, do nothing
    if capslock_is_held
    {
        ; It was a tap
        capslock_was_tapped := true
        SetCapsLockState !GetKeyState("CapsLock", "T")
    }
    
    capslock_is_held := false
    SetTimer check_capslock_hold, 0  ; Disable timer
}

check_capslock_hold()
{
    global capslock_is_held
    
    if capslock_is_held
    {
        ; CapsLock is being held - activate Fn layer
        ; The layer is active via #HotIf below
    }
}

; Magic Fn layer - active when CapsLock is held
#HotIf capslock_is_held
{
    ; Navigation
    w::Up
    a::Left
    s::Down
    d::Right
    [::Home
    ]::End
}
#HotIf