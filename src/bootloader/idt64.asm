bits 64

%include "bootloader/boot.inc"
%include "bootloader/idt64.inc"

%include "bootloader/pic.inc"

%include "engine/display.inc"

%include "main/main.inc"

%include "engine/keyboard.inc"
%include "engine/timer.inc"

%define STACK_START                   0x00020000
%define TEXT_ADDR_START               0xB8000


%define TEXT_WIDTH_IN_CHARACTER       80
%define TEXT_CHAR_DATA_WIDTH_IN_BYTES 2
%define TEXT_WIDTH_IN_BYTES           (TEXT_WIDTH_IN_CHARACTER * TEXT_CHAR_DATA_WIDTH_IN_BYTES)
%define TEXT_COLOR_WHITE              0x0F

%define IDT64_BUFFER_LEN              64

%define IDT64_TRAP64_WIREFRAME_WIDTH  54

section .text

make_idt_64:
global  make_idt_64: function
	cli                                   
	mov rsp, STACK_START
	mov rbp, rsp

	call initPS2
	call keyboardSetScancodeTable

	mov rdi, 0

	.loop:
		mov rsi, qword[InterruptHandlerTable + rdi * 8]
		cmp rsi, 0
		je .notPresent
			mov rax, LGATE_DESCRIPTOR_FLAGS(true, 0, GATE_TYPE_TRAP_32, 0)
		jmp .end
		.notPresent:
			mov rax,  LGATE_DESCRIPTOR_FLAGS(false, 0, GATE_TYPE_TRAP_32, 0)
		.end:
		mov rcx, 0
		call idt64_SetGate
		inc rdi
		cmp rdi, 0x20
		jl .loop

	mov rdi, 0x20
	mov rsi, qword[InterruptHandlerTable + rdi * 8]
	mov rax, LGATE_DESCRIPTOR_FLAGS(true, 0, GATE_TYPE_ISR_64, 0)
	call idt64_SetGate

	mov rdi, 0x21
	mov rsi, qword[InterruptHandlerTable + rdi * 8]
	mov rax, LGATE_DESCRIPTOR_FLAGS(true, 0, GATE_TYPE_ISR_64, 0)
	call idt64_SetGate

	;mov rdi, 0xFC
	;mov rsi, 0xFF
	;call mask_pic64

	mov ax, 16 * 0x22 ;16 bytes for a gate's size, 33 gates set
	mov word[IDTR_START], ax

	mov rax, IDT_START
	mov qword[IDTR_START + 2], rax

	lidt [IDTR_START]
	sti

	jmp main

.loop_check:
	call update_keyboard_handler

	mov rdi, KEY_Z
	call is_key_pressed
	cmp rax, 0
	je .setText

	mov rdi, KEY_S
	call is_key_pressed
	cmp rax, 0
	je .clearText
	jmp .loop_check

.setText:
	mov al, 'K'
	mov ah, 0x0F
	mov word [0xB8000], ax
	jmp .loop_check

.clearText:
	mov al, ' '
	mov ah, 0x0F
	mov word [0xB8000], ax
	jmp .loop_check

;rdi = gate index
;rsi = handlerPointer
;rax = gate type and flags
idt64_SetGate:
	shl rdi, 1 ;multiply by 2 so that indexing is correct (want *16 instead of *8)

	mov rdx, rsi
	mov rcx, 0xFFFF
	shl rcx, 48
	and rdx, rcx
	shl rdx, (48 - 16)
	xor rcx, rcx
	mov rcx, rdx     ;0x00000000000000000_FFFF000000000000 part     
	shl rax, 32
	or rcx, rax      ;0x00000000000000000_0000FFFF00000000 part
	mov dx, cs
	shl rdx, 16
	or rcx, rdx      ;0x00000000000000000_00000000FFFF0000 part
	mov rdx, rsi
	and rdx, 0xFFFF
	or rcx, rdx      ;0x0000000000000000_0000000000000FFFF part
	mov qword [IDT_START + rdi * 8], rcx  ;write low qword

	mov rax, 0xFFFFFFFF
	shl rax, 32
	mov rcx, rsi
	and rcx, rax
	shr rcx, 32      ;0x00000000FFFFFFFF_00000000000000000 part
	mov qword [IDT_START + 8 + rdi * 8], rcx

	shr rdi, 1 ;preserve rdi value to avoid needing stack
	ret


idt64_cursor:
static idt64_cursor:data
	dq TEXT_ADDR_START

; String Literals
idt64_hexdigits:
static idt64_hexdigits:data
idt64_bindigits:
static idt64_bindigits:data
		db "0123456789ABCDEF"
	
equal_msg:
	static equal_msg:data
		db " = "
.end: 
%define equal_msg_len (equal_msg.end - equal_msg)

; Register Names
%define REG_NAME_LEN 3

reg_RIP_name:
	static reg_RIP_name:data
		db "RIP"
reg_RAX_name:
	static reg_RAX_name:data
		db "RAX"
reg_RBX_name:
	static reg_RBX_name:data
		db "RBX"
reg_RCX_name:
	static reg_RCX_name:data
		db "RCX"
reg_RDX_name:
	static reg_RDX_name:data
		db "RDX"
reg_RSI_name:
	static reg_RSI_name:data
		db "RSI"
reg_RDI_name:
	static reg_RDI_name:data
		db "RDI"
reg_RSP_name:
	static reg_RSP_name:data
		db "RSP"
reg_RBP_name:
	static reg_RBP_name:data
		db "RBP"
reg_CS_name:
	static reg_CS_name:data
		db " CS"
reg_DS_name:
	static reg_DS_name:data
		db " DS"
reg_SS_name:
	static reg_SS_name:data
		db " SS"
reg_ES_name:
	static reg_ES_name:data
		db " ES"
reg_FS_name:
	static reg_FS_name:data
		db " FS"
reg_GS_name:
	static reg_GS_name:data
		db " GS"

; Register Banks
reg_RIP_bank:
	static reg_RIP_bank:data
		resq 1
reg_RAX_bank:
	static reg_RAX_bank:data
		resq 1
reg_RBX_bank:
	static reg_RBX_bank:data
		resq 1
reg_RCX_bank:
	static reg_RCX_bank:data
		resq 1
reg_RDX_bank:
	static reg_RDX_bank:data
		resq 1
reg_RSI_bank:
	static reg_RSI_bank:data
		resq 1
reg_RDI_bank:
	static reg_RDI_bank:data
		resq 1
reg_RSP_bank:
	static reg_RSP_bank:data
		resq 1
reg_RBP_bank:
	static reg_RBP_bank:data
		resq 1
reg_CS_bank:
	static reg_CS_bank:data
		resq 1
reg_DS_bank:
	static reg_DS_bank:data
		resq 1
reg_SS_bank:
	static reg_SS_bank:data
		resq 1
reg_ES_bank:
	static reg_ES_bank:data
		resq 1
reg_FS_bank:
	static reg_FS_bank:data
		resq 1
reg_GS_bank:
	static reg_GS_bank:data
		resq 1

Error_Code_bank:
	static Error_Code_bank:data
		resq 1

idt64_buffer:
static idt64_buffer: data
resb   IDT64_BUFFER_LEN

; void idt64_putchar(char toPut);
;
; toPut: rdi
idt64_putchar:
static idt64_putchar: function
	mov rsi, qword [idt64_cursor]

	cmp rdi, 0xA ; '\n'
	je  .crnl

	mov rax, rdi ;dil doesn't exist in 32 bits so write to rax, and use al for the character
	
	mov byte [rsi],           al
	;mov byte [rsi + 1],       TEXT_COLOR_WHITE
	add rsi,                  TEXT_CHAR_DATA_WIDTH_IN_BYTES
	mov qword [idt64_cursor], rsi
	jmp .end
	
	.crnl:
		mov rdx, 0
		mov rax, rsi
		sub rax, TEXT_ADDR_START
		mov rcx, TEXT_WIDTH_IN_BYTES
		div rcx
		mov rax, rdx
		sub rcx, rax

		add rsi, rcx

		mov qword[idt64_cursor], rsi
		jmp .end
	.end:
	ret

idt64_disable_cursor:
static idt64_disable_cursor: function
	mov dx, 0x3D4
	mov al, 0x0A
	out dx, al
	mov dx, 0x3D5
	mov al, 0x20
	out dx, al
	ret
	
;al: color code (bit 7 is blink, bit 4 - 6 are background color, bit 0 - 3 are foreground color)
idt64_clrscrn:
static idt64_clrscrn: function
	shl ax, 8
	
	mov rcx, TEXT_WIDTH_IN_BYTES * 25
	mov rdi, 0
	.clearLoop:
		mov word[TEXT_ADDR_START + rdi * 2], ax
		inc rdi
		loop .clearLoop
	ret

; void idt64_putnl(void);
idt64_putnl:
static idt64_putnl: function
	mov rdi, 0xA
	jmp idt64_putchar

; void idt64_putnchar(char* toPut, uint32_t n);
;
; toPut: rdi
; n:     rsi
idt64_putnchar:
static idt64_putnchar: function
	mov rcx, rsi
	mov rdx, rdi

	.put_loop:
		movzx  rdi, byte [rdx]
		call idt64_putchar
		inc  rdx
		loop .put_loop

	ret

; void idt64_putchar_repeat(char toPut, uint32_t n);
;
; toPut: rdi
; n:     rsi
idt64_putchar_repeat:
static idt64_putchar_repeat: function
	mov rcx, rsi

	.put_loop:
		call idt64_putchar
		loop .put_loop

	ret

; void idt64_puthex(uint32_t toPut, uint32_t n);
;
; toPut: rdi
; rsi: n (if there are more characters to print than the value of n, it's UB)
idt64_puthex:
static idt64_puthex: function
	mov rdx, idt64_buffer

	mov byte [rdx],     '0'
	mov byte [rdx + 1], 'x'
	
	add rdx, 2
	add rdx, rsi

	mov rcx, rsi
	.cvt_loop:
		mov rax,  rdi
		and rax, 0xF

		mov al, byte [idt64_hexdigits + rax]
		mov byte [idt64_buffer + rcx + 2 - 1], al

		shr  rdi, 4
		loop .cvt_loop

	mov  rdi, idt64_buffer
	add  rsi, 2
	call idt64_putnchar
	ret

; void idt64_putbin(uint32_t toPut);
;
; toPut: rdi
idt64_putbin:
static idt64_putbin: function
	mov rdx, idt64_buffer

	mov byte [rdx],     '0'
	mov byte [rdx + 1], 'b'
	
	add rdx, 2
	add rdx, rsi

	mov rcx, rsi
	.cvt_loop:
		mov rax,  rdi
		and rax, 0b1

		mov al, byte [idt64_bindigits + rax]
		mov byte [idt64_buffer + rcx + 2 - 1], al ;add 2 for the prefix, remove 1 because rcx gets decremented only when the instruction loop is executed

		shr  rdi, 1
		loop .cvt_loop

	mov  rdi, idt64_buffer
	add  rsi, 2
	call idt64_putnchar
	ret


; void idt64_putreg(char* name, uint32_t* bank, uint32_t n);
;
; name: rdi
; bank: rsi
; n:    rcx
idt64_putreg:
static idt64_putreg: function
	push rsi ; Storing the arguments for later
	push rcx

	mov  rsi, REG_NAME_LEN ; Putting the reg name
	call idt64_putnchar

	mov  rdi, equal_msg
	mov  rsi, equal_msg_len
	call idt64_putnchar     ; Putting the " = " string


	pop rsi
	pop rdi
	mov rdi, qword [rdi]
	
	call idt64_puthex

	; TODO: call puthex(*bank, n)
	ret

idt64_fault_string:
	db "fault occured at "
.end:	
%define idt64_fault_string_len (idt64_fault_string.end - idt64_fault_string)
idt64_allpurposereg_string:
	db "    All-Purpose Regs    "
.end:	
%define idt64_allpurposereg_string_len (idt64_allpurposereg_string.end - idt64_allpurposereg_string)
idt64_segmentregs_string:
	db "      Segment Regs      "
.end:	
%define idt64_segmentregs_string_len (idt64_segmentregs_string.end - idt64_segmentregs_string)
idt64_signature_string:
	db "      By RushiTori      "
.end:	
%define idt64_signature_string_len (idt64_signature_string.end - idt64_signature_string)
idt64_errorcode_string:
	db "Error Code: "
.end:	
%define idt64_errorcode_string_len (idt64_errorcode_string.end - idt64_errorcode_string)
idt64_noerrorcode_string:
	db "           No Error Code          "
.end:	
%define idt64_noerrorcode_string_len (idt64_noerrorcode_string.end - idt64_noerrorcode_string)


;rdi: 1 = error code, 0 = no error code
idt64_regdump:
static idt64_regdump:function
	push rdi


	call idt64_disable_cursor

	mov al, 0x1F ;background blue, foreground white
	call idt64_clrscrn

	; Putting line 0
	mov  rdi, '='
	mov  rsi, IDT64_TRAP64_WIREFRAME_WIDTH
	call idt64_putchar_repeat

	call idt64_putnl

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 4
	call idt64_putchar_repeat

	mov rdi, idt64_fault_string
	mov rsi, idt64_fault_string_len
	call idt64_putnchar

	mov rdi, reg_RIP_name
	mov rsi, reg_RIP_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 5
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 1
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov  rdi, '='
	mov  rsi, IDT64_TRAP64_WIREFRAME_WIDTH - 4
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 2
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, idt64_allpurposereg_string
	mov rsi, idt64_allpurposereg_string_len
	call idt64_putnchar

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, idt64_segmentregs_string
	mov rsi, idt64_segmentregs_string_len
	call idt64_putnchar

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 3
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, (IDT64_TRAP64_WIREFRAME_WIDTH - 6)/2
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, (IDT64_TRAP64_WIREFRAME_WIDTH - 6)/2
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	
	;RAX and CS on line 4
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RAX_name
	mov rsi, reg_RAX_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, reg_CS_name
	mov rsi, reg_CS_bank
	mov rcx, 4
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RBX and DS on line 5
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RBX_name
	mov rsi, reg_RBX_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, reg_DS_name
	mov rsi, reg_DS_bank
	mov rcx, 4
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RCX and SS on line 6
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RCX_name
	mov rsi, reg_RCX_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, reg_SS_name
	mov rsi, reg_SS_bank
	mov rcx, 4
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RDX and ES on line 7
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RDX_name
	mov rsi, reg_RDX_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, reg_ES_name
	mov rsi, reg_ES_bank
	mov rcx, 4
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RSI and FS on line 8
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RSI_name
	mov rsi, reg_RSI_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, reg_FS_name
	mov rsi, reg_FS_bank
	mov rcx, 4
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RDI and GS on line 9
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RDI_name
	mov rsi, reg_RDI_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, reg_GS_name
	mov rsi, reg_GS_bank
	mov rcx, 4
	call idt64_putreg

	mov rdi, ' '
	mov rsi, 6
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RSP on line 10
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RSP_name
	mov rsi, reg_RSP_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, (IDT64_TRAP64_WIREFRAME_WIDTH - 6)/2
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl



	;RBP on line 11
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, reg_RBP_name
	mov rsi, reg_RBP_bank
	mov rcx, 16
	call idt64_putreg

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, idt64_signature_string
	mov rsi, idt64_signature_string_len
	call idt64_putnchar

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 12
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov  rdi, '='
	mov  rsi, IDT64_TRAP64_WIREFRAME_WIDTH - 4
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 13
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, idt64_errorcode_string
	mov rsi, idt64_errorcode_string_len
	call idt64_putnchar

	mov rdi, ' '
	mov rsi,  IDT64_TRAP64_WIREFRAME_WIDTH - 4 - idt64_errorcode_string_len
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 14 (conditional for whether there is an error code or not too)
	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	mov rdi, ' '
	mov rsi, 8
	call idt64_putchar_repeat

	pop rdi
	cmp rdi, 0
	je .noErrorCode

		mov rdi, qword [Error_Code_bank]
		mov rsi, 32
		call idt64_putbin
		jmp .endErrorCode

	.noErrorCode:

		mov rdi, idt64_noerrorcode_string
		mov rsi, idt64_noerrorcode_string_len
		call idt64_putnchar
	.endErrorCode:

	mov rdi, ' '
	mov rsi, 8
	call idt64_putchar_repeat

	mov rdi, '|'
	mov rsi, 2
	call idt64_putchar_repeat

	call idt64_putnl


	;putting line 15
	mov  rdi, '='
	mov  rsi, IDT64_TRAP64_WIREFRAME_WIDTH
	call idt64_putchar_repeat

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
	mov word [reg_CS_bank],  cs
	mov word [reg_DS_bank],  ds
	mov word [reg_SS_bank],  ss
	mov word [reg_ES_bank],  es
	mov word [reg_FS_bank],  fs
	mov word [reg_GS_bank],  gs

	pop rax
	mov qword [Error_Code_bank], rax

	pop rax
	mov qword [reg_RIP_bank], rax

	mov rdi, true
	call idt64_regdump
	
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
	mov word [reg_CS_bank],  cs
	mov word [reg_DS_bank],  ds
	mov word [reg_SS_bank],  ss
	mov word [reg_ES_bank],  es
	mov word [reg_FS_bank],  fs
	mov word [reg_GS_bank],  gs

	pop rax
	mov qword [reg_RIP_bank], rax

	mov rdi, false
	call idt64_regdump

	jmp $

	iret

idt64_exception_GPF_string:
	db "  #GP "
.end:	
%define idt64_exception_GPF_string_len (idt64_exception_GPF_string.end - idt64_exception_GPF_string)

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
	mov word [reg_CS_bank],  cs
	mov word [reg_DS_bank],  ds
	mov word [reg_SS_bank],  ss
	mov word [reg_ES_bank],  es
	mov word [reg_FS_bank],  fs
	mov word [reg_GS_bank],  gs

	pop rax
	mov qword [Error_Code_bank], rax

	pop rax
	mov qword [reg_RIP_bank], rax

	mov rdi, true
	call idt64_regdump

	mov rdi, TEXT_ADDR_START + TEXT_WIDTH_IN_BYTES + (6 * 2) ;line 1 (zero indexed), column 2 (zero indexed), multiplied by 2 since 1 byte out of two controls color
	mov [idt64_cursor], rdi

	mov rdi, idt64_exception_GPF_string
	mov rsi, idt64_exception_GPF_string_len
	call idt64_putnchar

	jmp $

;IRQ0 aka system timer
idt64_timerIRQ:
	push rax

	call timerTick
	mov al, PIC_EOI
	out PIC1_COMMAND, al

	pop rax
	iretq


;idt64_keyboard_interrupt_string:
;	db "Keyboard interrupt struck"
;.end:	
%define idt64_keyboard_interrupt_string_len (idt64_keyboard_interrupt_string.end - idt64_keyboard_interrupt_string)

;IRQ1 aka keyboard handler
idt64_keyboardIRQ:
static idt64_keyboardIRQ:function
	push_all
	push rbp
	mov rbp, rsp

	call keyboardRead

	mov rdi, 1 ;IRQ1
	call sendEOI_pic64	;tell the PIC we finished handling the interrupt

	mov rsp, rbp
	pop rbp
	pop_all
	iretq	;this is how we return from an interrupt in long mode


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

InterruptHandlerTable:
;faults:
	dq idt64_trap64    			;division
	dq idt64_trap64    			;debug
	dq idt64_trap64	   			;NMI
	dq idt64_trap64    			;breakpoint
	dq idt64_trap64    			;overflow
	dq idt64_trap64    			;bound range exceeded
	dq idt64_trap64    			;invalid opcode
	dq idt64_trap64 			;device not available
	dq idt64_trap64_error_code	;double fault
	dq 0			   			;coprocessor segment overrun (doesn't happen anymore)
	dq idt64_trap64_error_code 	;invalid tss
	dq idt64_trap64_error_code  ;segment not present
	dq idt64_trap64_error_code	;stack segment fault
	dq idt64_GPF				;GPF
	dq idt64_trap64_error_code	;page fault
	dq 0						;reserved

	dq idt64_trap64				;x87 floating point exception
	dq idt64_trap64_error_code	;alignment check
	dq idt64_trap64				;machine check
	dq idt64_trap64				;SIMD floating point exception
	dq idt64_trap64				;virtualization exception
	dq idt64_trap64_error_code	;control protection exception
	dq 0						;reserved
	dq 0
	dq 0
	dq 0
	dq 0
	dq 0						;all the way until there
	dq idt64_trap64				;hypervisor injection exception
	dq idt64_trap64_error_code	;VMM communication exception
	dq idt64_trap64_error_code	;security exception
	dq 0						;reserved

;irqs:
	dq idt64_timerIRQ
	dq idt64_keyboardIRQ