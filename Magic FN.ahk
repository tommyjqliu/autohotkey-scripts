#Requires AutoHotkey v2.0

; Settings
threshold := 100 ; ms

; State tracking, 0 up, 1 tap, 2 hold
capslock_state := 0

; Main CapsLock handler with timer
CapsLock::
{
    global capslock_state
    capslock_state := 1
    SetTimer caplocks_into_hold, threshold
}

CapsLock up::
{
    if capslock_state == 1
    {
        SetCapsLockState !GetKeyState("CapsLock", "T")
    }

    global capslock_state
    capslock_state := 0
}

caplocks_into_hold()
{
    SetTimer , 0
    if capslock_state == 1
    {
        global capslock_state
        capslock_state := 2
    }
}

; Magic Fn layer - active when CapsLock is held
#HotIf capslock_state == 2
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