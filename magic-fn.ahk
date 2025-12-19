; Configuration (adjust as needed)
threshold := 100 ; Time (ms) to distinguish tap (short press) vs hold (long press)
; LOG_FILE := "D:\Users\Tommy\Documents\AutoHotkey\test-logs.txt"

Log(str) {
    global LOG_FILE
    if (IsSet(LOG_FILE))
    {
        FileAppend str, LOG_FILE
    }
}

; Core Logic
MagicFnDown(&stateRef) {
    if (stateRef == 0)
    {
        stateRef := 1
        Log "key down" stateRef "`n"
        IntoHold() {
            SetTimer , 0
            if (stateRef == 1)
            {
                stateRef := 2
                Log "key holding" stateRef "`n"
            }
        }
        SetTimer IntoHold, threshold 
    }
}

MagicFnUp(&stateRef, tapFn?) {
    Log "key up" stateRef "`n"
    if (stateRef == 1 && IsSet(tapFn))
    {
        tapFn()
    }
    stateRef := 0 
}


; State tracking (0 = up, 1 = tap, 2 = hold)
capslock_state := 0
*CapsLock::{
    global capslock_state
    MagicFnDown(&capslock_state)
}
*CapsLock Up::{
    global capslock_state
    MagicFnUp(&capslock_state, TapCaps)
}
TapCaps(){
    SetCapsLockState !GetKeyState("CapsLock", "T")
}

apps_state := 0
*AppsKey::{
    global apps_state
    MagicFnDown(&apps_state)
}
*AppsKey Up::{
    global apps_state
    MagicFnUp(&apps_state, TapApps)
}
TapApps(){
    Send "{AppsKey}"
}

; Magic Fn layer 1
#HotIf capslock_state == 2 || apps_state == 2
{
    ; Navigation
    w::Up
    a::Left
    s::Down
    d::Right
    [::Home
    ]::End

    ; Edit
    Backspace::Delete

    ; Fn
    F1::send "{Media_Prev}"
    F2::send "{Media_Play_Pause}"
    F3::send "{Media_Next}" 
    Home::PrintScreen
}
#HotIf

; Magic Fn layer 2
#HotIf capslock_state == 2 && apps_state == 2
{
    Delete::Shutdown(9)
}
#HotIf