bits    64
default rel

%include "engine/rtc_timer.inc"
%include "bootloader/idt64.inc"
%include "bootloader/pic.inc"

%define CMOS_OUT                    0x70
%define CMOS_IN                     0x71
%define CMOS_REG_A                  0x8A
%define CMOS_REG_B                  0x8B
%define CMOS_REG_C                  0x0C

; 1second / 8192hertz = 0.000122070312500seconds
; s ms  us  ns  ps  fs
; 0 000 122 070 312 500
%define RTC_TICKS_TO_FEMTOSECONDS   122070312500 ; multiplier
%define NANOSECONDS_TO_FEMTOSECONDS 1000000      ; multiplier
%define SECONDS_TO_NANOSECONDS      1000000000   ; multiplier

%define FEMTOSECONDS_TO_RTC_TICKS   122070312500 ; divider
%define FEMTOSECONDS_TO_NANOSECONDS 1000000      ; divider
%define NANOSECONDS_TO_SECONDS      1000000000   ; divider

section     .bss

res(static, uint64_t, rtc_ticks)
res(static, uint64_t, rtc_sleep_ticks)
res(global, uint64_t, rtc_pos)

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

	mov al,      sil ; data
	out CMOS_IN, al
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
	mov   si, 0x03
	and   di, 0x0F ; rate = rate & 0x0F
	cmp   di, si
	cmovl di, si   ; if (rate < 0x03) rate = 0x03

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
	push rax
	push rdi

	inc uint64_p [rtc_pos]      ; debug
	cmp uint64_p [rtc_pos], 200 * 1024
	jle .skip_pos
		mov uint64_p [rtc_pos], 0
	.skip_pos:
	inc uint64_p [rtc_ticks] ; rtc_ticks++;

	sub rsp, 8 ; to re-align the stack

	mov  rdi, 8        ; IRQ8
	call sendEOI_pic64 ; sendEOI_pic64(IRQ8);

	mov  dil, CMOS_REG_C    ; register C
	call recv_cmos_register ; read register C to end the IRQ8

	add rsp, 8 ; to re-align the stack

	pop rdi
	pop rax
	iretq

; void init_rtc(void);
;
; Assumes the insterupts are disabled
func(global, init_rtc)
	sub rsp, 8 ; to re-align the stack

	mov  rdi, 0x28
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

; uint128_t rtctime_to_nanoseconds(RTCTime time);
func(static, rtctime_to_nanoseconds)
	mov esi, edi ; preserve time.nsec
	shr rdi, 32  ; edi = time.sec
	
	mov rax, SECONDS_TO_NANOSECONDS
	mul rdi                         ; rdx:rax = time.sec * SECONDS_TO_NANOSECONDS
	
	add rax, rsi ; rdx:rax = time.sec * SECONDS_TO_NANOSECONDS + time.nsec
	adc rdx, 0
	ret

; RTCTime rtc_time_diff(RTCTime lhs, RTCTime rhs);
;
; Return: lhs - rhs.
func(global, rtc_time_diff)
	push rsi ; preserve rhs

	call rtctime_to_nanoseconds ; rtctime_to_nanoseconds(lhs);

	pop rdi ; restore rhs

	push rdx    ; preserve high 64 bits
	push rax    ; preserve low 64 bits
	sub  rsp, 8 ; to re-align the stack

	call rtctime_to_nanoseconds ; rtctime_to_nanoseconds(rhs);

	add rsp, 8 ; to re-align the stack

	pop rsi ; restore low 64 bits
	pop rdi ; restore high 64 bits

	; rdi:rsi - rdx:rax
	sub rsi, rax
	sbb rdi, rdx

	mov    rax, rsi
	mov    rdx, rdi
	div128 NANOSECONDS_TO_SECONDS
	
	; Convert to RTCTime struct
	shl rax, 32  ; RTCTime.sec = low 32 bits of rax
	or  rax, rcx ; RTCTime.nsec = rcx ; rcx is always less than 1e9 due to division
	ret

; uint128_t mul128(uint128_t a, uint128_t b);
func(static, mul128)
	;
	; uint128_t mul128(uint128_t a, uint128_t b) {
	;     return a * b;
	; }
	;
	; Godbolt gcc 15.2 with -O3 flag output
    imul rsi, rdx ; rsi = hi_a * lo_b
    mov  rax, rdi ; rax = lo_a
    imul rcx, rdi ; rcx = hi_b * lo_a
    mul  rdx      ; rdx:rax = lo_a * lo_b
    add  rsi, rcx ; rsi = hi_a * lo_b + hi_b * lo_a
    add  rdx, rsi ; rdx:rax = a * b
	ret

; void rtc_sleep(RTCTime time);
;
; Will sleep for at least time, if time is too small or not exactly in line with the ticks, it'll sleep for an extra tick.
func(global, rtc_sleep)
	sub rsp, 8 ; to re-align the stack

	call rtctime_to_nanoseconds ; rtctime_to_nanoseconds(time);

	mov  rdi, NANOSECONDS_TO_FEMTOSECONDS ; lo_a
	xor  rsi, rsi                         ; hi_a
	mov  rcx, rdx                         ; hi_b
	mov  rdx, rax                         ; lo_b
	call mul128                           ; mul128(NANOSECONDS_TO_FEMTOSECONDS, rtctime_to_nanoseconds(time));

	div128 FEMTOSECONDS_TO_RTC_TICKS
	cmp    rcx, 0
	je     .skip_off_by_one_correction
		inc rax
	.skip_off_by_one_correction:

	mov uint64_p [rtc_sleep_ticks], rax

	add rsp, 8 ; to re-align the stack
	ret

; int64_t rtc_snprint(RTCTime time, char* buffer, uint64_t n);
;
; Equivalent to rtc_snprint_ex(time, buffer, n, RTC_PRECISION_MIN, RTC_PRECISION_MAX);
func(global, rtc_snprint)
	mov cl,  RTC_PRECISION_MIN
	mov r8b, RTC_PRECISION_MAX
	jmp rtc_snprint_ex         ; rtc_snprint_ex(time, buffer, n, RTC_PRECISION_MIN, RTC_PRECISION_MAX);

%macro put_char_in_buffer 1
	mov al, %1
	cmp al, 0
	je  %%skip_put_char

	mov uint8_p [r12 + r11], al ; buffer[bufferIdx] = %1;
	inc r11
	mov uint8_p [r12 + r11], 0  ; buffer[bufferIdx] = '\0';

	cmp r11, r13
	jae .end_with_cleanup ; if (bufferIdx >= n) goto end_with_cleanup;
	%%skip_put_char:
%endmacro

; int64_t rtc_snprint_ex(RTCTime time, char* buffer, uint64_t n, RTCPrecision min, RTCPrecision max);
;
; Like your usual snprintf(...), will write up-to n-1 characters to buffer and will take care of the nul terminator.
; Return: strlen(buffer) on success, and any negative value on falure.
func(global, rtc_snprint_ex)
	mov r11, -1
	; Error checking
		cmp rsi, NULL
		je  .end      ; if (!buffer) return -1;

		cmp rdx, 0
		je  .end   ; if (!n) return -1;

		cmp cl, RTC_PRECISION_MAX
		ja  .end                  ; if (min > RTC_PRECISION_MAX) return -1;

		cmp r8b, RTC_PRECISION_MAX
		ja  .end                   ; if (max > RTC_PRECISION_MAX) return -1;

		xor r11,           r11
		mov uint8_p [rsi], 0   ; *buffer = '\0';

		cmp rdx, 1
		je  .end   ; if (n == 1) return 0;

		cmp cl, r8b
		jbe .skip_swap
			xchg cl, r8b ; if (min > max) swap(min, max);
		.skip_swap:

	push r12    ; preserve r12
	push r13    ; preserve r13
	push r14    ; preserve r14
	push r15    ; preserve r15
	sub  rsp, 8 ; to re-align the stack

	mov r12,  rsi ; buffer
	mov r13,  rdx ; n
	mov r14b, cl  ; min
	mov r15b, r8b ; max

	call rtctime_to_nanoseconds ; rtctime_to_nanoseconds(time);

	add rsp, 8    ; to re-align the stack
	xor r11, r11  ; bufferIdx
	mov sil, true ; isFirstUnit = true

	cmp rax, 0
	jge .skip_negative
		put_char_in_buffer '-'
		neg                rax
	.skip_negative:
	
	xor rcx, rcx
	.cvt_loop:
		xor rdx, rdx

		div uint64_p [rtc_time_cvt_ratios + rcx * 8]
		mov uint64_p [rtc_snprint_ex_data_table + rcx * 8], rax

		inc rcx
		cmp rcx, RTC_DAYS
		jle .cvt_loop

	movzx rcx, r14b
	.mod_loop:
		xor rdx, rdx

		mov rax, uint64_p [rtc_snprint_ex_data_table + rcx * 8]

		div uint64_p [rtc_time_mod_values + rcx * 8]
		mov uint64_p [rtc_snprint_ex_data_table + rcx * 8], rdx

		inc cl
		cmp cl, r15b
		jl  .mod_loop

	movzx rcx, r15b
	.put_loop:
		mov rax, uint64_p [rtc_snprint_ex_data_table + rcx * 8]
		cmp rax, 0
		je  .continue_put_loop

		mov sil, true ; handlingDigits = true
		mov r8,  r11
		mov r9,  r11
		.put_digits_loop:
			xor rdx, rdx
			mov r10, 10
			div r10
			add dl,  '0'

			put_char_in_buffer dl

			inc r9
			cmp rax, 0
			jne .put_digits_loop
		dec r9
		
		.reverse_digits_loop:
			dec r9
			cmp r8, r9
			jge .reverse_digits_loop_end

			mov al, uint8_p [r12 + r8]
			mov dl, uint8_p [r12 + r9]

			mov uint8_p [r12 + r8], dl
			mov uint8_p [r12 + r9], al

			inc r8
			jmp .reverse_digits_loop
		.reverse_digits_loop_end:

		put_char_in_buffer ' '

		mov                al, uint8_p [rtc_time_names + rcx * 2]
		put_char_in_buffer al

		mov                al, uint8_p [1 + rtc_time_names + rcx * 2]
		put_char_in_buffer al

		put_char_in_buffer ' '

		.continue_put_loop:
		dec cl
		cmp cl, r14b
		jge .put_loop

	.end_with_cleanup:
		cmp sil, false                ; handlingDigits
		je  .skip_reverse_last_digits

		.reverse_last_digits:
			.last_reverse_loop:
				dec r9
				cmp r8, r9
				jge .last_reverse_loop_end

				mov al, uint8_p [r12 + r8]
				mov dl, uint8_p [r12 + r9]

				mov uint8_p [r12 + r8], dl
				mov uint8_p [r12 + r9], al

				inc r8
				jmp .last_reverse_loop
			.last_reverse_loop_end:
		.skip_reverse_last_digits:

		pop r15 ; restore r15
		pop r14 ; restore r14
		pop r13 ; restore r13
		pop r12 ; restore r12

	.end:
	mov rax, r11
	ret

section .data

rtc_snprint_ex_data_table:
static  rtc_snprint_ex_data_table: data
	.nanos:   dq 0
	.micros:  dq 0
	.millis:  dq 0
	.seconds: dq 0
	.minutes: dq 0
	.hours:   dq 0
	.days:    dq 0

section .rodata

rtc_time_cvt_ratios:
static  rtc_time_cvt_ratios: data
	.nanos_to_nanos:     dq 1
	.nanos_to_micros:    dq 1000
	.micros_to_millis:   dq 1000
	.millis_to_seconds:  dq 1000
	.seconds_to_minutes: dq 60
	.minutes_to_hours:   dq 60
	.hours_to_days:      dq 24

rtc_time_mod_values:
static rtc_time_mod_values: data
	.nanos:   dq 1000
	.micros:  dq 1000
	.millis:  dq 1000
	.seconds: dq 1000
	.minutes: dq 60
	.hours:   dq 60
	.days:    dq 24

rtc_time_names:
static rtc_time_names: data
	.nanos:   db "ns"
	.micros:  db "ms"
	.millis:  db "ms"
	.seconds: db "s", 0
	.minutes: db "m", 0
	.hours:   db "h", 0
	.days:    db "d", 0
