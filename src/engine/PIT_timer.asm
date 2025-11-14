bits  64

%include "engine/PIT_timer.inc"

struc Timer
    .ms:    resq 1
    .ticks: resq 1
endstruc

section .bss

sleep_timer:
static  system_time_64:data
    .fractions:
    static system_time_64.fractions:data
    	resd 1 ; Fractions of 1 ms to sleep for
    .ms:
    static system_time_64.ms:data
    	resd 1 ; Number of whole ms to sleep for

system_time_64:
static system_time_64:data
    .fractions:
    static system_time_64.fractions:data
    	resd 1 ; Fractions of 1 ms since timer initialized
    .ms:
    static system_time_64.ms:data
    	resd 1 ; Number of whole ms since timer initialized

IRQ0_time_64:
static IRQ0_time_64:data
    .fractions:
    static IRQ0_time_64.fractions:data
    	resd 1 ; Fractions of 1 ms between IRQ0's
    .ms:
    static IRQ0_time_64.ms:data
    	resd 1 ; Number of whole ms between IRQ0's

IRQ0_frequency:         
static IRQ0_frequency:data
	resd 1 ; Actual frequency of PIT

PIT_reload_value:       
static PIT_reload_value:data
	resw 1 ; Current PIT reload value

PIT_ticks:
static PIT_ticks:data
    resq 1

timers_state:                   ; a bitfield where each bit represent if a timer ID is available or not
static        timers_state:data
    resq 4

timers_data:                  ; an array of MAX_TIMER_COUNT timers, following the Timer struc specs
static       timers_data:data
    times MAX_TIMER_COUNT resb Timer_size

section .text

; This initializes the PIT to fire an IRQ0 at roughly 6000 hz
init_PIT:
global  init_PIT:function
    push_all ; pushad

    mov rax,                         0xFFFFFFFFFFFFFFFF
    mov qword[timers_state],         rax
    mov qword[timers_state + 8],     rax
    mov qword[timers_state + 8 * 2], rax
    mov qword[timers_state + 8 * 3], rax

    mov rbx, IRQ0_FREQUENCY
 
    ; Do some checking
 
    mov rax, 0x10000    ;eax = reload value for slowest possible frequency (65536)
    cmp rbx, 18         ;Is the requested frequency too low?
    jbe .gotReloadValue ; yes, use slowest possible frequency
 
    mov rax, 1          ;ax = reload value for fastest possible frequency (1)
    cmp rbx, 1193181    ;Is the requested frequency too high?
    jae .gotReloadValue ; yes, use fastest possible frequency
 
    ; Calculate the reload value
 
    mov rax, 3579545
    mov rdx, 0           ;edx:eax = 3579545
    div rbx              ;eax = 3579545 / frequency, rdx = remainder
    cmp rdx, 3579545 / 2 ;Is the remainder more than half?
    jb  .l1              ; no, round down
    inc rax              ; yes, round up
	.l1:
    mov rbx, 3
    mov rdx, 0           ;edx:eax = 3579545 * 256 / frequency
    div rbx              ;eax = (3579545 * 256 / 3 * 256) / frequency
    cmp rdx, 3 / 2       ;Is the remainder more than half?
    jb  .l2              ; no, round down
    inc rax              ; yes, round up
	.l2:
 
 
 ; Store the reload value and calculate the actual frequency
 
	.gotReloadValue:
    push rax                         ;Store reload_value for later
    mov  word[PIT_reload_value], ax  ;Store the reload value for later
    mov  rbx,                    rax ;ebx = reload value
 
    mov rax,                   3579545
    mov rdx,                   0           ;edx:eax = 3579545
    div rbx                                ;eax = 3579545 / reload_value, rdx = remainder
    cmp rdx,                   3579545 / 2 ;Is the remainder more than half?
    jb  .l3                                ; no, round down
    inc rax                                ; yes, round up
	.l3:
    mov rbx,                   3
    mov rdx,                   0           ;edx:eax = 3579545 / reload_value
    div rbx                                ;eax = (3579545 / 3) / frequency
    cmp rdx,                   3 / 2       ;Is the remainder more than half?
    jb  .l4                                ; no, round down
    inc rax                                ; yes, round up
	.l4:
    mov dword[IRQ0_frequency], eax         ;Store the actual frequency for displaying later
 
 
 ; Calculate the amount of time between IRQs in 32.32 fixed point
 ;
 ; Note: The basic formula is:
 ;           time in ms = reload_value / (3579545 / 3) * 1000
 ;       This can be rearranged in the following way:
 ;           time in ms = reload_value * 3000 / 3579545
 ;           time in ms = reload_value * 3000 / 3579545 * (2^42)/(2^42)
 ;           time in ms = reload_value * 3000 * (2^42) / 3579545 / (2^42)
 ;           time in ms * 2^32 = reload_value * 3000 * (2^42) / 3579545 / (2^42) * (2^32)
 ;           time in ms * 2^32 = reload_value * 3000 * (2^42) / 3579545 / (2^10)
 
    pop rbx             ;ebx = reload_value
    mov rax, 0xDBB3A062 ;eax = 3000 * (2^42) / 3579545
    mul rbx             ;edx:eax = reload_value * 3000 * (2^42) / 3579545
    shrd rax, rdx, 10
    shr rdx, 10         ;edx:eax = reload_value * 3000 * (2^42) / 3579545 / (2^10)
	inc edx
 
    mov dword [IRQ0_time_64.ms],        edx ;Set whole ms between IRQs
    mov dword [IRQ0_time_64.fractions], eax ;Set fractions of 1 ms between IRQs
 
 
 ; Program the PIT channel
 
    pushfq
    cli ;Disabled interrupts (just in case)
 
    mov al,   00110100b ;channel 0, lobyte/hibyte, rate generator
    out 0x43, al
 
    mov ax,   word[PIT_reload_value] ;ax = 16 bit reload value
    out 0x40, al                     ;Set low byte of PIT reload value
    mov al,   ah                     ;ax = high 8 bits of reload value
    out 0x40, al                     ;Set high byte of PIT reload value
 
    popfq
 
    pop_all ; popad
    ret

; This is the IRQ0 function
timerTick:
global timerTick:function
    inc qword[PIT_ticks]                           ; increment the number of ticks since end of boot
	mov rax,                   qword[IRQ0_time_64] ; read the time between two IRQ0's in rax
	add qword[system_time_64], rax                 ; add that time to the system time

    sub qword[sleep_timer], rax ; sub that time to the sleep timer
    jnc .end                    ; if the sleep timer didn't underflow we can end the tick
    mov qword[sleep_timer], 0   ; else we set the timer to 0
    
    .end:
	ret

; return : The number of times the PIT fired an IRQ0 since end of boot.
get_system_ticks:
global get_system_ticks:function
    mov rax, qword[PIT_ticks]
    ret

; return : The current system time since end of boot in 32.32 fixed point milliseconds.
get_system_time_ms:
global get_system_time_ms:function
    mov rax, qword[system_time_64]
    ret

; return : the created timer ID or -1 if it failed.
create_timer:
global create_timer:function
    xor rdi, rdi
    .search_loop:
        cmp qword[timers_state + rdi * 8], 0
        je  .continue_search_loop
        bsf rax,                           qword[timers_state + rdi * 8]
        ;btc qword[timers_state + rdi * 8], rax
        shr rdi,                           3
        add rax,                           rdi
        
        xor  rdi, rdi
        push rax
        call maskout_irq_pic64
        pop  rax

        shl rax,                                    4                     ; multiply rax by Timer_size which is 16
        mov rdi,                                    qword[system_time_64]
        mov qword[timers_data + rax + Timer.ms],    rdi
        mov rdi,                                    qword[PIT_ticks]
        mov qword[timers_data + rax + Timer.ticks], rdi
        shr rax,                                    4                     ; restore rax

        xor  rdi, rdi
        push rax
        call maskin_irq_pic64
        pop  rax
        jmp  .end

        .continue_search_loop:
        inc rdi
        cmp rdi, 4
        jb  .search_loop

    mov rax, -1
    .end:
    ret

; args : u8 timerID
remove_timer:
global remove_timer:function
    and rdi,                                    0xff
    shl rdi,                                    4
    mov qword[timers_data + rdi + Timer.ms],    0
    mov qword[timers_data + rdi + Timer.ticks], 0
    shr rdi,                                    4

    mov rax,                       rdi
    shr rax,                       6
    and rdi,                       0x3F
    mov rcx,                       rdi
    mov rdi,                       1
    shr rdi,                       cl
    or  qword[timers_state + rax], rdi
    ret

; args : u8 timerID
; return : The number of times the PIT fired an IRQ0 since the timer was (re)created or reset,
;          or same as get_system_ticks if the timerID is invalid.
get_timer_ticks:
global get_timer_ticks:function
    and rdi, 0xFF
    shl rdi, 4
    mov rax, qword[PIT_ticks]
    sub rax, qword[timers_data + rdi + Timer.ticks]
    ret

; args : u8 timerID
; return : The timerID's time in 32.32 fixed point milliseconds since it was (re)created or reset,
;          or same as get_system_time_ms if the timerID isn't valid.
get_timer_ms:
global get_timer_ms:function
    and rdi, 0xFF
    shl rdi, 4
    mov rax, qword[system_time_64]
    sub rax, qword[timers_data + rdi + Timer.ms]
    ret

; args : u8 timerID
; return : Same as get_timer_ms.
reset_timer:
global reset_timer:function
    and rdi, 0xFF
    shl rdi, 4
    mov rax, qword[system_time_64]
    sub rax, qword[timers_data + rdi + Timer.ms]

    mov rsi,                                 qword[system_time_64]
    mov qword[timers_data + rdi + Timer.ms], rsi

    mov rsi,                                    qword[PIT_ticks]
    mov qword[timers_data + rdi + Timer.ticks], 0
    ret

; args : u64 ms
; notes : ms should be in 32.32 fixed point format.
sleep_ms:
global sleep_ms:function
    ; WIP
    mov qword[sleep_timer], rdi
    .sleep_loop:
        cmp qword[sleep_timer], 0
        je  .end
        hlt
        jmp .sleep_loop

    .end:
    ret
