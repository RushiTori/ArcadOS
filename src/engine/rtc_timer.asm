bits    64
default rel

%include "engine/rtc_timer.inc"
%include "bootloader/idt64.inc"

%define CMOS_OUT                    0x70
%define CMOS_IN                     0x71
%define CMOS_REG_A                  0x8A
%define CMOS_REG_B                  0x8B
%define CMOS_REG_C                  0x0C

; 1second / 8192hertz = 0.000122070312500seconds
; s ms  us  ns  ps  fs
; 0 000 122 070 312 500
%define RTC_TICKS_TO_FEMTOSECONDS   122070312500 ; multiplier
%define FEMTOSECONDS_TO_NANOSECONDS 1000000      ; divider
%define NANOSECONDS_TO_SECONDS      1000000000   ; divider

section     .bss

res(static, uint64_t, rtc_ticks)

section     .text

%macro select_cmos_reg 1
	mov al,       %1
	out CMOS_OUT, al ; select_cmos_reg(%1);
%endmacro

; uint8_t recv_cmos_register(uint8_t reg);
func(static, recv_cmos_register)
	select_cmos_reg dil

	in  al, CMOS_IN
	ret             ; return get_cmos();

; void send_cmos_register(uint8_t reg, uint8_t data);
func(static, send_cmos_register)
	select_cmos_reg dil

	mov al, sil      ; data
	out al, CMOS_OUT
	ret

; void turn_on_cmos_irq(void);
func(static, turn_on_cmos_irq)
	sub rsp, 8 ; to re-align the stack

	mov  dil, CMOS_REG_B
	call recv_cmos_register ; recv_cmos_register(CMOS_REG_B);

	add rsp, 8 ; to re-align the stack

	or  al,  0x40
	mov dil, CMOS_REG_B
	mov sil, al
	jmp send_cmos_register ; send_cmos_register(CMOS_REG_B, prev | 0x40);

; void set_cmos_frequency(uint8_t rate);
;
; 0x03 <= rate <= 0xF
; frequency = 32768 >> (rate - 1);
func(static, set_cmos_frequency)
	mov   sil, 0x03
	and   dil, 0x0F ; rate = rate & 0x0F
	cmp   dil, sil
	cmovl dil, sil  ; if (rate < 0x03) rate = 0x03

	push rdi ; preserve rate	

	mov  dil, CMOS_REG_A
	call recv_cmos_register ; get initial value of register A

	pop rdi ; restore rate

	and al, 0xF0 ; prev & 0xF0
	or  al, dil  ; (prev & 0xF0) | rate

	mov dil, CMOS_REG_A
	mov sil, al
	jmp send_cmos_register ; send_cmos_register(CMOS_REG_A, (prev & 0xF0) | rate);

func(static, rtc_irq)
	inc uint64_p [rtc_ticks] ; rtc_ticks++;

	sub rsp, 8 ; to re-align the stack

	mov  rdi, 8        ; IRQ8
	call sendEOI_pic64 ; sendEOI_pic64(IRQ8);

	mov  dil, CMOS_REG_C    ; register C
	call recv_cmos_register ; read register C to end the IRQ8

	add rsp, 8 ; to re-align the stack

	iretq

; void init_rtc(void);
;
; Assumes the insterupts are disabled
func(global, init_rtc)
	sub rsp, 8 ; to re-align the stack

	mov rdi, 
	lea  rsi, [rtc_irq]
	mov  rax, LGATE_DESCRIPTOR_FLAGS(true, 0, GATE_TYPE_ISR_64, 0) ; whatever that means...
	call idt64_set_gate ; not a SYSV call for some reason...

	call turn_on_cmos_irq ; turn_on_cmos_irq();

	add rsp, 8 ; to re-align the stack

	mov dil, 0x03
	jmp set_cmos_frequency ; set_cmos_frequency(0x03);

; Technique for dividing RDX:RAX by RDI
; source: https://stackoverflow.com/a/76086966
%macro div128 1
	mov  rdi, %1
	mov  rcx, rax ; Temporarily store LowDividend in RCX
    mov  rax, rdx ; First divide the HighDividend
    xor  edx, edx ; Setup for division RDX:RAX / RDI
    div  rdi      ; -> RAX is HighQuotient, Remainder is re-used
    xchg rax, rcx ; Temporarily move HighQuotient to RCX restoring LowDividend to RAX
    div  rdi      ; -> RAX is LowQuotient, Remainder RDX
    xchg rdx, rcx ; Build true 128-bit quotient in RDX:RAX
%endmacro

; RTCTime rtc_get_time(void);
;
; Return: The time since init_rtc().
func(global, rtc_get_time)
	mov rdi, RTC_TICKS_TO_FEMTOSECONDS
	mov rax, uint64_p [rtc_ticks]

	mul rdi ; rdx:rax = rtc_ticks * RTC_TICKS_TO_FEMTOSECONDS

	div128 FEMTOSECONDS_TO_NANOSECONDS
	div128 NANOSECONDS_TO_SECONDS
	
	; Convert to RTCTime struct
	shl rax, 33  ; RTCTime.sec = low 32 of rax and eliminate sign bit
	shr rax, 1
	or  rax, rcx ; RTCTime.nsec = rcx ; rcx is always less than 1e9 due to division
	ret

; RTCTime rtc_time_diff(RTCTime lhs, RTCTime rhs);
;
; Return: lhs - rhs.
func(global, rtc_time_diff)
	; WIP
	ret

; void rtc_sleep(RTCTime time);
;
; Will sleep for at least time, if time is too small or not exactly in line with the ticks, it'll sleep for an extra tick.
func(global, rtc_sleep)
	; WIP
	ret

; int64_t rtc_snprint(RTCTime time, char* buffer, uint64_t n);
;
; Equivalent to rtc_snprint_ex(time, buffer, n, RTC_PRECISION_MIN, RTC_PRECISION_MAX);
func(global, rtc_snprint)
	; WIP
	ret

; int64_t rtc_snprint_ex(RTCTime time, char* buffer, uint64_t n, RTCPrecision min, RTCPrecision max);
;
; Like your usual snprintf(...), will write up-to n-1 characters to buffer and will take care of the nul terminator.
; Return: strlen(buffer) on success, and any negative value on falure.
func(global, rtc_snprint_ex)
	; WIP
	ret
