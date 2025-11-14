%ifndef PIT_TIMER_INC
%define PIT_TIMER_INC

%include "standard.inc"
%include "bootloader/pic.inc"

%define MAX_TIMER_COUNT 256

%define FRAME_TIME      0x00000010aaaaaaab ; 16.666666666744277 ms in 32.32 fixed point

%define IRQ0_FREQUENCY  600

; This initializes the PIT to fire an IRQ0 at roughly 600 hz
extern init_PIT

; This is the IRQ0 function
extern timerTick

; return : The number of times the PIT fired an IRQ0 since end of boot.
extern get_system_ticks

; return : The current system time since end of boot in 32.32 fixed point milliseconds.
extern get_system_time_ms

; return : the created timer ID or -1 if it failed.
extern create_timer

; args : u8 timerID
extern remove_timer

; args : u8 timerID
; return : The number of times the PIT fired an IRQ0 since the timer was (re)created or reset,
;          or same as get_system_ticks if the timerID is invalid.
extern get_timer_ticks

; args : u8 timerID
; return : The timerID's time in 32.32 fixed point milliseconds since it was (re)created or reset,
;          or same as get_system_time_ms if the timerID isn't valid.
extern get_timer_ms

; args : u8 timerID
; return : Same as get_timer_ms.
extern reset_timer

; args : u64 ms
; notes : ms should be in 32.32 fixed point format.
extern sleep_ms

%endif ; PIT_TIMER_INC
