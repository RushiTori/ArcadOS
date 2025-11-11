bits 64

%include "bootloader/boot.inc"
%include "bootloader/idt64.inc"

%include "string.inc"

%include "bootloader/pic.inc"

%include "engine/display.inc"

%include "bootloader/rsdp.inc"
%include "main/main.inc"

%include "engine/PS2.inc"
%include "engine/timer.inc"

%define STACK_START                   0x0009FFFF                                                ;lotsa memory to grow down from here
%define TEXT_ADDR_START               0xB8000


%define TEXT_WIDTH_IN_CHARACTER       80
%define TEXT_CHAR_DATA_WIDTH_IN_BYTES 2
%define TEXT_WIDTH_IN_BYTES           (TEXT_WIDTH_IN_CHARACTER * TEXT_CHAR_DATA_WIDTH_IN_BYTES)
%define TEXT_COLOR_WHITE              0x0F

%define IDT64_BUFFER_LEN              64 + 2 + 1                                                ;add 2 for the prefix, add 1 for null terminator

%define IDT64_TRAP64_WIREFRAME_WIDTH  54

section .text

make_idt_64:
global  make_idt_64: function
	cli                                   
	mov rsp, STACK_START
	mov rbp, rsp

	;call keyboardSetScancodeTable

	mov rdi, 0

	.loop:
		mov rsi, qword[InterruptHandlerTable + rdi * 8]
		cmp rsi, 0
		je  .notPresent
			mov rax, LGATE_DESCRIPTOR_FLAGS(true, 0, GATE_TYPE_TRAP_64, 0)
		jmp .end
		.notPresent:
			mov rax,  LGATE_DESCRIPTOR_FLAGS(false, 0, GATE_TYPE_TRAP_64, 0)
		.end:
		call idt64_set_gate
		inc  rdi
		cmp  rdi, 0x20
		jl   .loop

	mov rdi, 0x20
	.loopIRQ:
		mov rsi, qword[InterruptHandlerTable + rdi * 8]
		cmp rsi, 0
		je  .notPresentIRQ
			mov rax, LGATE_DESCRIPTOR_FLAGS(true, 0, GATE_TYPE_ISR_64, 0)
			jmp .endIfElse
		.notPresentIRQ:
			mov rax, LGATE_DESCRIPTOR_FLAGS(false, 0, GATE_TYPE_ISR_64, 0)
		.endIfElse:
		call idt64_set_gate
		inc  rdi
		cmp  rdi, 0x30
		jl   .loopIRQ

	mov ax,               16 * 0x30 ;16 bytes for a gate's size, 33 gates set
	mov word[IDTR_START], ax

	mov rax,                   IDT_START
	mov qword[IDTR_START + 2], rax

	lidt [IDTR_START]
	sti

	mov  rdi, 0b11111110
	mov  rsi, 0b11111111
	call mask_pic64

	call memory_mover_start ;we need to set up memory mover before initializing other stuff

	call init_PIT
	call PS2_init        ;automatically initializes the drivers for the devices plugged in
	mov  rdi, 0b11111001 ;enable slave and enable IRQ1
	mov  rsi, 0b11101111 ;enable IRQ12
	call mask_pic64


	jmp main
	;jmp find_RSDP

;rdi = gate index
;rsi = handlerPointer
;rax = gate type and flags
idt64_set_gate:
	shl rdi, 1 ;multiply by 2 so that indexing is correct (want *16 instead of *8)

	mov rdx,                         rsi
	mov rcx,                         0xFFFF
	shl rcx,                         48
	and rdx,                         rcx
	shl rdx,                         (48 - 16)
	xor rcx,                         rcx
	mov rcx,                         rdx       ;0x00000000000000000_FFFF000000000000 part     
	shl rax,                         32
	or  rcx,                         rax       ;0x00000000000000000_0000FFFF00000000 part
	mov dx,                          cs
	shl rdx,                         16
	or  rcx,                         rdx       ;0x00000000000000000_00000000FFFF0000 part
	mov rdx,                         rsi
	and rdx,                         0xFFFF
	or  rcx,                         rdx       ;0x0000000000000000_0000000000000FFFF part
	mov qword [IDT_START + rdi * 8], rcx       ;write low qword

	mov rax,                             0xFFFFFFFF
	shl rax,                             32
	mov rcx,                             rsi
	and rcx,                             rax
	shr rcx,                             32         ;0x00000000FFFFFFFF_00000000000000000 part
	mov qword [IDT_START + 8 + rdi * 8], rcx

	shr rdi, 1 ;preserve rdi value to avoid needing stack
	ret

; String Literals
idt64_hexdigits:
static idt64_hexdigits:data
idt64_bindigits:
static idt64_bindigits:data
		db "0123456789ABCDEF"
	
equal_msg:
static equal_msg: data
		db " = ", 0
.end: 
%define equal_msg_len (equal_msg.end - equal_msg - 1)

; Register Names
%define REG_NAME_LEN  3
	reg_RIP_name:
	static reg_RIP_name: data
		db "RIP", 0
	reg_RAX_name:
	static reg_RAX_name: data
		db "RAX", 0
	reg_RBX_name:
	static reg_RBX_name: data
		db "RBX", 0
	reg_RCX_name:
	static reg_RCX_name: data
		db "RCX", 0
	reg_RDX_name:
	static reg_RDX_name: data
		db "RDX", 0
	reg_RSI_name:
	static reg_RSI_name: data
		db "RSI", 0
	reg_RDI_name:
	static reg_RDI_name: data
		db "RDI", 0
	reg_RSP_name:
	static reg_RSP_name: data
		db "RSP", 0
	reg_RBP_name:
	static reg_RBP_name: data
		db "RBP", 0
	reg_CS_name:
	static reg_CS_name: data
		db " CS", 0
	reg_DS_name:
	static reg_DS_name: data
		db " DS", 0
	reg_SS_name:
	static reg_SS_name: data
		db " SS", 0
	reg_ES_name:
	static reg_ES_name: data
		db " ES", 0
	reg_FS_name:
	static reg_FS_name: data
		db " FS", 0
	reg_GS_name:
	static reg_GS_name: data
		db " GS", 0

; Register Banks
	reg_RIP_bank:
	static reg_RIP_bank: data
		dq 0
	reg_RAX_bank:
	static reg_RAX_bank: data
		dq 0
	reg_RBX_bank:
	static reg_RBX_bank: data
		dq 0
	reg_RCX_bank:
	static reg_RCX_bank: data
		dq 0
	reg_RDX_bank:
	static reg_RDX_bank: data
		dq 0
	reg_RSI_bank:
	static reg_RSI_bank: data
		dq 0
	reg_RDI_bank:
	static reg_RDI_bank: data
		dq 0
	reg_RSP_bank:
	static reg_RSP_bank: data
		dq 0
	reg_RBP_bank:
	static reg_RBP_bank: data
		dq 0
	reg_CS_bank:
	static reg_CS_bank: data
		dq 0
	reg_DS_bank:
	static reg_DS_bank: data
		dq 0
	reg_SS_bank:
	static reg_SS_bank: data
		dq 0
	reg_ES_bank:
	static reg_ES_bank: data
		dq 0
	reg_FS_bank:
	static reg_FS_bank: data
		dq 0
	reg_GS_bank:
	static reg_GS_bank: data
		dq 0
	Error_Code_bank:
	static Error_Code_bank: data
		dq 0

idt64_buffer:
static idt64_buffer: data
	times IDT64_BUFFER_LEN db 0

; void idt64_puthex(uint32_t toPut, uint32_t n);
;
; x: rdi
; y: rsi
; toPut: rdx
; n: rcx
idt64_puthex_gfx:
static idt64_puthex_gfx: function
	mov byte [idt64_buffer],           '0'
	mov byte [idt64_buffer + 1],       'x'
	mov byte [idt64_buffer + rcx + 2], 0
	.cvt_loop:
		mov rax, rdx
		and rax, 0xF

		mov al,                                byte [idt64_hexdigits + rax]
		mov byte [idt64_buffer + rcx + 2 - 1], al                           ;add 2 for the prefix, remove 1 because rcx gets decremented only when the instruction loop is executed

		shr  rdx, 4
		loop .cvt_loop

	;rdi already set
	;rsi already set
	mov rdx, idt64_buffer
	
	call idt64_draw_text_and_shadow
	
	ret

; void idt64_putbin(uint32_t toPut);
;
; x: rdi
; y: rsi
; toPut: rdx
; n: rcx
; ruins the value of rax, rcx, r8 and anything draw_text ruins
idt64_putbin_gfx:
static idt64_putbin_gfx: function
	mov byte [idt64_buffer],           '0'
	mov byte [idt64_buffer + 1],       'b'
	mov byte [idt64_buffer + rcx + 2], 0
	.cvt_loop:
		mov rax, rdx
		and rax, 0b1

		mov al,                                byte [idt64_hexdigits + rax]
		mov byte [idt64_buffer + rcx + 2 - 1], al                           ;add 2 for the prefix, remove 1 because rcx gets decremented only when the instruction loop is executed

		shr  rdx, 1
		loop .cvt_loop

	;rdi already set
	;rsi already set
	mov rdx, idt64_buffer
	
	call idt64_draw_text_and_shadow
	
	ret


; void idt64_putreg(char* name, uint32_t* bank, uint32_t n);
;

; x: rdi
; y: rsi
; name: rdx
; bank: rcx
; n: r8
idt64_putreg_gfx:
static idt64_putreg_gfx: function
	push rbp
	mov  rbp,          rsp
	sub  rsp,          0x8 * 5
	mov  [rbp],        rdi     ;x
	mov  [rbp - 0x8],  rsi     ;y
	mov  [rbp - 0x10], rdx     ;name
	mov  [rbp - 0x18], rcx     ;bank
	mov  [rbp - 0x20], r8

	
	call idt64_draw_text_and_shadow

	mov  rdi, [rbp - 0x10]
	call strlen
	shl  rax, 3            ;mul by 8 because 1 char is 8 pixels

	mov  rdi,       [rbp - 0]
	add  rdi,       rax
	mov  [rbp - 0], rdi
	mov  rsi,       [rbp - 0x8]
	mov  rdx,       equal_msg
	call idt64_draw_text_and_shadow ; Putting the " = " string


	mov  rdi, equal_msg
	call strlen
	shl  rax, 3         ;mul by 8 because 1 char is 8 pixels
	
	mov  rdi, [rbp - 0]
	add  rdi, rax
	;no need to store it back
	mov  rsi, [rbp - 0x8]
	mov  rdx, [rbp - 0x18]
	mov  rdx, [rdx]
	mov  rcx, [rbp - 0x20]
	call idt64_puthex_gfx

	add rsp, 0x8 * 5
	pop rbp
	ret

idt64_fault_string:
	db "fault occured", 0
.end:	
%define idt64_fault_string_len (idt64_fault_string.end - idt64_fault_string)

idt64_occured_string:
	db " occured", 0
.end:	
%define idt64_fault_string_len (idt64_fault_string.end - idt64_fault_string)
idt64_allpurposereg_string:
	db "All-Purpose Regs", 0
.end:	
%define idt64_allpurposereg_string_len (idt64_allpurposereg_string.end - idt64_allpurposereg_string)
idt64_segmentregs_string:
	db "Segment Regs", 0
.end:	
%define idt64_segmentregs_string_len (idt64_segmentregs_string.end - idt64_segmentregs_string)
idt64_signature_string:
	db "By RushiTori", 0
.end:	
%define idt64_signature_string_len (idt64_signature_string.end - idt64_signature_string)
idt64_errorcode_string:
	db "Error Code", 0
.end:	
%define idt64_errorcode_string_len (idt64_errorcode_string.end - idt64_errorcode_string)
idt64_noerrorcode_string:
	db "No Error Code", 0
.end:	
%define idt64_noerrorcode_string_len (idt64_noerrorcode_string.end - idt64_noerrorcode_string - 1) ;removing one for the null terminator

;rdi: x
;rsi: y
;rdx: str
idt64_draw_text_and_shadow:
static idt64_draw_text_and_shadow:function
	xchg rdi, rdx             ; rdi = str, rdx = x
	xchg rsi, rdx             ; rsi = x, rdx = y
	jmp  draw_text_and_shadow ; draw_text_and_shadow(x, y, str);
	

;rdi: 1 = error code, 0 = no error code
;rsi: exception string pointer
idt64_regdump_gfx_mode:
static idt64_regdump_gfx_mode:function
	push rdi
	push rsi

	mov  rdi, 0x01
	call set_display_color

	call clear_screen

	mov  rdi, 0x0F
	call set_display_color

	mov  rdi, 0
	mov  rsi, 0
	pop  rdx
	cmp  rdx, 0
	mov  rax, 0
	je   .skipPrintExceptionCode
	push rdx
	call idt64_draw_text_and_shadow

	pop  rdi
	call strlen
	shl  rax, 3 ;multiply by 8
	add  rax, 8 ;add one character of spacing

	.skipPrintExceptionCode:
	mov  rdi, rax
	mov  rsi, 0
	mov  rdx, idt64_fault_string
	call idt64_draw_text_and_shadow

	;putting an empty line for clarity

	mov  rdi, 0
	mov  rsi, 16
	mov  rdx, reg_RIP_name
	mov  rcx, reg_RIP_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	;putting an empty line for clarity

	mov  rdi, 0
	mov  rsi, 32
	mov  rdx, reg_RAX_name
	mov  rcx, reg_RAX_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 40
	mov  rdx, reg_RBX_name
	mov  rcx, reg_RBX_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 48
	mov  rdx, reg_RCX_name
	mov  rcx, reg_RCX_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 56
	mov  rdx, reg_RDX_name
	mov  rcx, reg_RDX_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 64
	mov  rdx, reg_RDI_name
	mov  rcx, reg_RDI_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 72
	mov  rdx, reg_RSI_name
	mov  rcx, reg_RSI_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 80
	mov  rdx, reg_RBP_name
	mov  rcx, reg_RBP_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 88
	mov  rdx, reg_RSP_name
	mov  rcx, reg_RSP_bank
	mov  r8,  (64/4)
	call idt64_putreg_gfx

	;putting an empty line for clarity

	mov  rdi, 0
	mov  rsi, 104
	mov  rdx, reg_CS_name
	mov  rcx, reg_CS_bank
	mov  r8,  (16/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 112
	mov  rdx, reg_DS_name
	mov  rcx, reg_DS_bank
	mov  r8,  (16/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 120
	mov  rdx, reg_SS_name
	mov  rcx, reg_SS_bank
	mov  r8,  (16/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 128
	mov  rdx, reg_ES_name
	mov  rcx, reg_ES_bank
	mov  r8,  (16/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 136
	mov  rdx, reg_FS_name
	mov  rcx, reg_FS_bank
	mov  r8,  (16/4)
	call idt64_putreg_gfx

	mov  rdi, 0
	mov  rsi, 144
	mov  rdx, reg_GS_name
	mov  rcx, reg_GS_bank
	mov  r8,  (16/4)
	call idt64_putreg_gfx

	;putting empty line
	pop rdi
	cmp rdi, 0
	je  .noErrorCode

	.errorCode:
		mov  rdi, 0
		mov  rsi, 160
		mov  rdx, idt64_errorcode_string
		mov  rcx, Error_Code_bank
		mov  r8,  (32/4)
		call idt64_putreg_gfx

		mov  rdi, 0
		mov  rsi, 168
		mov  rdx, [Error_Code_bank]
		mov  rcx, 32
		call idt64_putbin_gfx

		jmp .endErrorCode
	.noErrorCode:
		mov  rdi, 0
		mov  rsi, 160
		mov  rdx, idt64_errorcode_string
		call draw_text

		mov  rdi, idt64_errorcode_string
		call strlen

		mov  rdi, 0
		add  rdi, rax
		mov  rsi, 160
		mov  rdx, idt64_noerrorcode_string
		call draw_text
	.endErrorCode:
	
	ret

; void idt64_trap64(void)
idt64_trap64_error_code:
static idt64_trap64_error_code:function
	; TODO: Bank RIP, RSP and RBP(?) correctly

	mov qword [reg_RAX_bank], rax
	mov qword [reg_RBX_bank], rbx
	mov qword [reg_RCX_bank], rcx
	mov qword [reg_RDX_bank], rdx
	mov qword [reg_RSI_bank], rsi
	mov qword [reg_RDI_bank], rdi
	mov qword [reg_RSP_bank], rsp
	mov qword [reg_RBP_bank], rbp
	mov word [reg_CS_bank],   cs
	mov word [reg_DS_bank],   ds
	mov word [reg_SS_bank],   ss
	mov word [reg_ES_bank],   es
	mov word [reg_FS_bank],   fs
	mov word [reg_GS_bank],   gs

	pop rax
	mov qword [Error_Code_bank], rax

	pop rax
	mov qword [reg_RIP_bank], rax

	mov  rdi, true
	call idt64_regdump_gfx_mode
	
	; TODO: put all the other lines

	jmp $

	iret



; void idt64_trap64(void)
idt64_trap64:
static idt64_trap64:function
	; TODO: Bank RIP, RSP and RBP(?) correctly

	mov qword [reg_RAX_bank], rax
	mov qword [reg_RBX_bank], rbx
	mov qword [reg_RCX_bank], rcx
	mov qword [reg_RDX_bank], rdx
	mov qword [reg_RSI_bank], rsi
	mov qword [reg_RDI_bank], rdi
	mov qword [reg_RSP_bank], rsp
	mov qword [reg_RBP_bank], rbp
	mov word [reg_CS_bank],   cs
	mov word [reg_DS_bank],   ds
	mov word [reg_SS_bank],   ss
	mov word [reg_ES_bank],   es
	mov word [reg_FS_bank],   fs
	mov word [reg_GS_bank],   gs

	pop rax
	mov qword [reg_RIP_bank], rax

	mov  rdi, false
	call idt64_regdump_gfx_mode

	jmp $

	iret

idt64_PF:
static idt64_PF:function
	; TODO: Bank RIP, RSP and RBP(?) correctly

	mov qword [reg_RAX_bank], rax
	mov qword [reg_RBX_bank], rbx
	mov qword [reg_RCX_bank], rcx
	mov qword [reg_RDX_bank], rdx
	mov qword [reg_RSI_bank], rsi
	mov qword [reg_RDI_bank], rdi
	mov qword [reg_RSP_bank], rsp
	mov qword [reg_RBP_bank], rbp
	mov word [reg_CS_bank],   cs
	mov word [reg_DS_bank],   ds
	mov word [reg_SS_bank],   ss
	mov word [reg_ES_bank],   es
	mov word [reg_FS_bank],   fs
	mov word [reg_GS_bank],   gs

	pop rax
	mov qword [Error_Code_bank], rax

	pop rax
	mov qword [reg_RIP_bank], rax

	mov  rdi, true
	mov  rsi, interrupt_code_table.PageFault
	call idt64_regdump_gfx_mode

	jmp $

idt64_GPF:
static idt64_GPF:function
	; TODO: Bank RIP, RSP and RBP(?) correctly

	mov qword [reg_RAX_bank], rax
	mov qword [reg_RBX_bank], rbx
	mov qword [reg_RCX_bank], rcx
	mov qword [reg_RDX_bank], rdx
	mov qword [reg_RSI_bank], rsi
	mov qword [reg_RDI_bank], rdi
	mov qword [reg_RSP_bank], rsp
	mov qword [reg_RBP_bank], rbp
	mov word [reg_CS_bank],   cs
	mov word [reg_DS_bank],   ds
	mov word [reg_SS_bank],   ss
	mov word [reg_ES_bank],   es
	mov word [reg_FS_bank],   fs
	mov word [reg_GS_bank],   gs

	pop rax
	mov qword [Error_Code_bank], rax

	pop rax
	mov qword [reg_RIP_bank], rax

	mov  rdi, true
	mov  rsi, interrupt_code_table.GeneralProtectionFault
	call idt64_regdump_gfx_mode

	jmp $

;IRQ0 aka system timer
idt64_IRQ_PIT:
	push_all

	call timerTick

	mov  rdi, 0        ;IRQ0
	call sendEOI_pic64 ;tell the PIC we finished handling the interrupt

	pop_all
	iretq


;idt64_keyboard_interrupt_string:
; db "Keyboard interrupt struck"
;.end:	
%define idt64_keyboard_interrupt_string_len (idt64_keyboard_interrupt_string.end - idt64_keyboard_interrupt_string)

;IRQ1 aka PS/2 port1 IRQ
idt64_IRQ_port1:
static idt64_keyboardIRQ:function
	push_all

	mov  rdi, 0         ;port 1, 0 indexed
	call PS2_IRQ_update

	mov  rdi, 1        ;IRQ1
	call sendEOI_pic64 ;tell the PIC we finished handling the interrupt

	pop_all
	iretq ;this is how we return from an interrupt in long mode

;IRQ12 aka PS/2 port2 IRQ
idt64_IRQ_port2:
static idt64_keyboardIRQ:function
	push_all

	mov  rdi, 1         ;port 2, 0 indexed
	call PS2_IRQ_update

	mov  rdi, 12       ;IRQ12
	call sendEOI_pic64 ;tell the PIC we finished handling the interrupt

	pop_all
	iretq ;this is how we return from an interrupt in long mode

	

	


;Name   ; IDT64 Trap64 WireFrame
;Width  ; 123456789;123456789;123456789;123456789;123456789;123456789;1234
;line  0; ======================================================
;line  1; ||      #xx occured at RIP = 0x0123456789ABCDEF     ||
;line  2; ||==================================================||        
;line  3; ||    All-Purpose Regs    ||      Segment Regs      ||
;line  4; ||                        ||                        ||
;line  5; ||RAX = 0x0123456789ABCDEF||       CS = 0x0123      ||
;line  6; ||RBX = 0x0123456789ABCDEF||       DS = 0x0123      ||
;line  7; ||RCX = 0x0123456789ABCDEF||       SS = 0x0123      ||
;line  8; ||RDX = 0x0123456789ABCDEF||       ES = 0x0123      ||
;line  9; ||RSI = 0x0123456789ABCDEF||       FS = 0x0123      ||
;line 10; ||RDI = 0x0123456789ABCDEF||       GS = 0x0123      ||
;line 11; ||RSP = 0x0123456789ABCDEF||                        ||
;line 12; ||RBP = 0x0123456789ABCDEF||      By RushiTori      ||
;line 13; ||==================================================||
;line 14; ||Error Code:                                       ||
;line 15; ||        0b0123456789;0123456789;0123456789        ||
;line 16; ======================================================
;line 15; ||                   No Error Code                  ||
;	 alt;


%define interrupt_code_size 4
interrupt_code_table:
.DivisionError:
	db "#DE", 0
.Debug:
	db "#DB", 0
.NMI:
	dd 0
.Breakpoint:
	db "#BP", 0
.Overflow:
	db "#OF", 0
.BoundRangeExceeded:
	db "#BR", 0
.InvalidOpcode:
	db "#UD", 0
.DeviceNotAvailable:
	db "#NM", 0
.DoubleFault:
	db "#DF", 0
.CoprocessorSegmentOverrun:
	dd 0
.invalidTSS:
	db "#TS", 0
.SegmentNotPresent:
	db "#NP", 0
.StackSegmentFault:
	db "#SS", 0
.GeneralProtectionFault:
	db "#GP", 0
.PageFault:
	db "#PF", 0
	dd 0
.x87FloatingPointException:
	db "#MF", 0
.AlignmentCheck:
	db "#AC", 0
.MachineCheck:
	db "#MC", 0
.SIMDFloatingPointException:
	db "#XM", 0
.VirtualizationException:
	db "#VE", 0
.ControlProtectionException:
	db "#CP", 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0
.HypvervisorInjectionException:
	db "#HV", 0
.VMMCommunicationException:
	db "#VC", 0
.SecurityException:
	db "#SX", 0
	dd 0

InterruptHandlerTable:
;faults:
	dq idt64_trap64            ;division
	dq idt64_trap64            ;debug
	dq idt64_trap64            ;NMI
	dq idt64_trap64            ;breakpoint
	dq idt64_trap64            ;overflow
	dq idt64_trap64            ;bound range exceeded
	dq idt64_trap64            ;invalid opcode
	dq idt64_trap64            ;device not available
	dq idt64_trap64_error_code ;double fault
	dq 0                       ;coprocessor segment overrun (doesn't happen anymore)
	dq idt64_trap64_error_code ;invalid tss
	dq idt64_trap64_error_code ;segment not present
	dq idt64_trap64_error_code ;stack segment fault
	dq idt64_GPF               ;GPF
	dq idt64_PF                ;page fault
	dq 0                       ;reserved

	dq idt64_trap64            ;x87 floating point exception
	dq idt64_trap64_error_code ;alignment check
	dq idt64_trap64            ;machine check
	dq idt64_trap64            ;SIMD floating point exception
	dq idt64_trap64            ;virtualization exception
	dq idt64_trap64_error_code ;control protection exception
	dq 0                       ;reserved
	dq 0
	dq 0
	dq 0
	dq 0
	dq 0                       ;all the way until there
	dq idt64_trap64            ;hypervisor injection exception
	dq idt64_trap64_error_code ;VMM communication exception
	dq idt64_trap64_error_code ;security exception
	dq 0                       ;reserved

;irqs:
	dq idt64_IRQ_PIT   ;IRQ0  0x20 timer
	dq idt64_IRQ_port1 ;IRQ1  0x21 PS/2 port 1
	dq 0               ;IRQ2  0x22 doesn't exist since it's the cascade signal for the slave PIC
	dq 0               ;IRQ3  0x23
	dq 0               ;IRQ4  0x24
	dq 0               ;IRQ5  0x25
	dq 0               ;IRQ6  0x26
	dq 0               ;IRQ7  0x27

	dq 0               ;IRQ8  0x28
	dq 0               ;IRQ9  0x29
	dq 0               ;IRQ10 0x2A
	dq 0               ;IRQ11 0x2B
	dq idt64_IRQ_port2 ;IRQ12 0x2C PS/2 port 2
	dq 0               ;IRQ13 0x2D
	dq 0               ;IRQ14 0x2E
	dq 0               ;IRQ15 0x2F
