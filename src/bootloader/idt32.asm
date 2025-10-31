bits 32

%include "bootloader/boot.inc"
%include "bootloader/idt32.inc"

%define STACK_START                   0x00020000
%define TEXT_ADDR_START               0xB8000


%define TEXT_WIDTH_IN_CHARACTER       80
%define TEXT_CHAR_DATA_WIDTH_IN_BYTES 2
%define TEXT_WIDTH_IN_BYTES           (TEXT_WIDTH_IN_CHARACTER * TEXT_CHAR_DATA_WIDTH_IN_BYTES)
%define TEXT_COLOR_WHITE              0x0F

%define IDT32_BUFFER_LEN              64

%define IDT32_TRAP32_WIREFRAME_WIDTH  38

section .text

make_idt_32:
global  make_idt_32: function
	cli                                   ;0x8360
	mov esp, STACK_START
	mov ebp, esp

	mov edi, 0

	.loop:

		mov esi, dword[InterruptHandlerTable + edi * 4]
		mov eax, GATE_TYPE_TRAP_32
		call idt32_SetGate
		inc edi
		cmp edi, 0x20
		jl .loop

	mov ax, 8 * 0x20 ;8 bytes for a gate's size, 1 gate set
	mov word[IDTR_START], ax

	mov eax, IDT_START
	mov dword[IDTR_START + 2], eax

	lidt [IDTR_START]


	mov al, 'N'
	mov ah, 0x02
	mov word[0xBFFFE], ax

	jmp paging_start

;edi = gate index
;esi = handlerPointer
;eax = gate type
idt32_SetGate:
	mov ecx, esi
	and ecx, 0xFFFF0000
	shl eax, 8
	or ecx, eax
	cmp esi, 0
	je .notP

	or ecx, GATE_P

.notP:
	mov dword[IDT_START + 4 + edi * 8], ecx

	mov ecx, esi
	and ecx, 0x0000FFFF
	mov ax, cs
	shl eax, 16
	or ecx, eax
	mov dword[IDT_START + edi * 8], ecx
	ret



idt32_cursor:
static idt32_cursor:data
	dd TEXT_ADDR_START

; String Literals
idt32_hexdigits:
static idt32_hexdigits:data
idt32_bindigits:
static idt32_bindigits:data
		db "0123456789ABCDEF"
	
equal_msg:
	static equal_msg:data
		db " = "
.end: 
%define equal_msg_len (equal_msg.end - equal_msg)

; Register Names
%define REG_NAME_LEN 3

reg_EIP_name:
	static reg_EIP_name:data
		db "EIP"
reg_EAX_name:
	static reg_EAX_name:data
		db "EAX"
reg_EBX_name:
	static reg_EBX_name:data
		db "EBX"
reg_ECX_name:
	static reg_ECX_name:data
		db "ECX"
reg_EDX_name:
	static reg_EDX_name:data
		db "EDX"
reg_ESI_name:
	static reg_ESI_name:data
		db "ESI"
reg_EDI_name:
	static reg_EDI_name:data
		db "EDI"
reg_ESP_name:
	static reg_ESP_name:data
		db "ESP"
reg_EBP_name:
	static reg_EBP_name:data
		db "EBP"
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
reg_EIP_bank:
	static reg_EIP_bank:data
		resd 1
reg_EAX_bank:
	static reg_EAX_bank:data
		resd 1
reg_EBX_bank:
	static reg_EBX_bank:data
		resd 1
reg_ECX_bank:
	static reg_ECX_bank:data
		resd 1
reg_EDX_bank:
	static reg_EDX_bank:data
		resd 1
reg_ESI_bank:
	static reg_ESI_bank:data
		resd 1
reg_EDI_bank:
	static reg_EDI_bank:data
		resd 1
reg_ESP_bank:
	static reg_ESP_bank:data
		resd 1
reg_EBP_bank:
	static reg_EBP_bank:data
		resd 1
reg_CS_bank:
	static reg_CS_bank:data
		resd 1
reg_DS_bank:
	static reg_DS_bank:data
		resd 1
reg_SS_bank:
	static reg_SS_bank:data
		resd 1
reg_ES_bank:
	static reg_ES_bank:data
		resd 1
reg_FS_bank:
	static reg_FS_bank:data
		resd 1
reg_GS_bank:
	static reg_GS_bank:data
		resd 1

Error_Code_bank:
	static Error_Code_bank:data
		resd 1

idt32_buffer:
static idt32_buffer: data
resb   IDT32_BUFFER_LEN

; void idt32_putchar(char toPut);
;
; toPut: edi
idt32_putchar:
static idt32_putchar: function
	mov esi, dword [idt32_cursor]

	cmp edi, 0xA ; '\n'
	je  .crnl

	mov eax, edi ;dil doesn't exist in 32 bits so write to eax, and use al for the character
	
	mov byte [esi],           al
	mov byte [esi + 1],       TEXT_COLOR_WHITE
	add esi,                  TEXT_CHAR_DATA_WIDTH_IN_BYTES
	mov dword [idt32_cursor], esi
	jmp .end
	
	.crnl:
		mov edx, 0
		mov eax, esi
		sub eax, TEXT_ADDR_START
		mov ecx, TEXT_WIDTH_IN_BYTES
		div ecx
		mov eax, edx
		sub ecx, eax

		add esi, ecx

		mov dword[idt32_cursor], esi
		jmp .end
	.end:
	ret

idt32_clrscrn:
static idt32_clrscrn: function
	mov ax, 0
	
	mov ecx, TEXT_WIDTH_IN_BYTES * 25
	mov edi, 0
	.clearLoop:
		mov word[TEXT_ADDR_START + edi * 2], ax
		inc edi
		loop .clearLoop
	ret

; void idt32_putnl(void);
idt32_putnl:
static idt32_putnl: function
	mov edi, 0xA
	jmp idt32_putchar

; void idt32_putnchar(char* toPut, uint32_t n);
;
; toPut: edi
; n:     esi
idt32_putnchar:
static idt32_putnchar: function
	mov ecx, esi
	mov edx, edi

	.put_loop:
		movzx  edi, byte [edx]
		call idt32_putchar
		inc  edx
		loop .put_loop

	ret

; void idt32_putchar_repeat(char toPut, uint32_t n);
;
; toPut: edi
; n:     esi
idt32_putchar_repeat:
static idt32_putchar_repeat: function
	mov ecx, esi

	.put_loop:
		call idt32_putchar
		loop .put_loop

	ret

; void idt32_puthex(uint32_t toPut, uint32_t n);
;
; toPut: edi
; esi: n (if there are more characters to print than the value of n, it's UB)
idt32_puthex:
static idt32_puthex: function
	mov edx, idt32_buffer

	mov byte [edx],     '0'
	mov byte [edx + 1], 'x'
	
	add edx, 2
	add edx, esi

	mov ecx, esi
	.cvt_loop:
		mov eax,  edi
		and eax, 0xF

		mov al, byte [idt32_hexdigits + eax]
		mov byte [idt32_buffer + ecx + 2 - 1], al

		shr  edi, 4
		loop .cvt_loop

	mov  edi, idt32_buffer
	add  esi, 2
	call idt32_putnchar
	ret

; void idt32_putbin(uint32_t toPut);
;
; toPut: edi
idt32_putbin:
static idt32_putbin: function
	mov edx, idt32_buffer

	mov byte [edx],     '0'
	mov byte [edx + 1], 'b'
	
	add edx, 2
	add edx, esi

	mov ecx, esi
	.cvt_loop:
		mov eax,  edi
		and eax, 0b1

		mov al, byte [idt32_bindigits + eax]
		mov byte [idt32_buffer + ecx + 2 - 1], al ;add 2 for the prefix, remove 1 because ecx gets decremented only when the instruction loop is executed

		shr  edi, 1
		loop .cvt_loop

	mov  edi, idt32_buffer
	add  esi, 2
	call idt32_putnchar
	ret


; void idt32_putreg(char* name, uint32_t* bank, uint32_t n);
;
; name: edi
; bank: esi
; n:    ecx
idt32_putreg:
static idt32_putreg: function
	push esi ; Storing the arguments for later
	push ecx

	mov  esi, REG_NAME_LEN ; Putting the reg name
	call idt32_putnchar

	mov  edi, equal_msg
	mov  esi, equal_msg_len
	call idt32_putnchar     ; Putting the " = " string


	pop esi
	pop edi
	mov edi, [edi]
	
	call idt32_puthex

	; TODO: call puthex(*bank, n)
	ret

idt32_fault_string:
	db "fault occured at "
.end:	
%define idt32_fault_string_len (idt32_fault_string.end - idt32_fault_string)
idt32_allpurposereg_string:
	db "All-Purpose Regs"
.end:	
%define idt32_allpurposereg_string_len (idt32_allpurposereg_string.end - idt32_allpurposereg_string)
idt32_segmentregs_string:
	db "  Segment Regs  "
.end:	
%define idt32_segmentregs_string_len (idt32_segmentregs_string.end - idt32_segmentregs_string)
idt32_signature_string:
	db "  By RushiTori  "
.end:	
%define idt32_signature_string_len (idt32_signature_string.end - idt32_signature_string)
idt32_errorcode_string:
	db "Error Code: "
.end:	
%define idt32_errorcode_string_len (idt32_errorcode_string.end - idt32_errorcode_string)
idt32_noerrorcode_string:
	db "           No Error Code          "
.end:	
%define idt32_noerrorcode_string_len (idt32_noerrorcode_string.end - idt32_noerrorcode_string)


;edi: 1 = error code, 0 = no error code
idt32_regdump:
static idt32_regdump:function
	push edi

	call idt32_clrscrn

	; Putting line 0
	mov  edi, '='
	mov  esi, IDT32_TRAP32_WIREFRAME_WIDTH
	call idt32_putchar_repeat

	call idt32_putnl

	; Putting line 1
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	call idt32_putchar

	mov edi, idt32_fault_string
	mov esi, idt32_fault_string_len
	call idt32_putnchar

	mov edi, reg_EIP_name
	mov esi, reg_EIP_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl

	;putting line 2
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov  edi, '='
	mov  esi, IDT32_TRAP32_WIREFRAME_WIDTH - 4
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl

	;putting line 3
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, idt32_allpurposereg_string
	mov esi, idt32_allpurposereg_string_len
	call idt32_putnchar

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, idt32_segmentregs_string
	mov esi, idt32_segmentregs_string_len
	call idt32_putnchar

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, (IDT32_TRAP32_WIREFRAME_WIDTH - 6)/2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, (IDT32_TRAP32_WIREFRAME_WIDTH - 6)/2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl


	
	;EAX and CS
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_EAX_name
	mov esi, reg_EAX_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_CS_name
	mov esi, reg_CS_bank
	mov ecx, 4
	call idt32_putreg

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;EBX and DS
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_EBX_name
	mov esi, reg_EBX_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_DS_name
	mov esi, reg_DS_bank
	mov ecx, 4
	call idt32_putreg

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;ECX and SS
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_ECX_name
	mov esi, reg_ECX_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_SS_name
	mov esi, reg_SS_bank
	mov ecx, 4
	call idt32_putreg

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;EDX and ES
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_EDX_name
	mov esi, reg_EDX_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_ES_name
	mov esi, reg_ES_bank
	mov ecx, 4
	call idt32_putreg

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;ESI and FS
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_ESI_name
	mov esi, reg_ESI_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_FS_name
	mov esi, reg_FS_bank
	mov ecx, 4
	call idt32_putreg

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;EDI and GS
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_EDI_name
	mov esi, reg_EDI_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_GS_name
	mov esi, reg_GS_bank
	mov ecx, 4
	call idt32_putreg

	mov edi, ' '
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;ESP
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_ESP_name
	mov esi, reg_ESP_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, ' '
	mov esi, (IDT32_TRAP32_WIREFRAME_WIDTH - 6)/2
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	;EBP
	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, reg_EBP_name
	mov esi, reg_EBP_bank
	mov ecx, 8
	call idt32_putreg

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, idt32_signature_string
	mov esi, idt32_signature_string_len
	call idt32_putnchar

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl


	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov  edi, '='
	mov  esi, IDT32_TRAP32_WIREFRAME_WIDTH - 4
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl



	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	mov edi, idt32_errorcode_string
	mov esi, idt32_errorcode_string_len
	call idt32_putnchar

	mov edi, ' '
	mov esi,  IDT32_TRAP32_WIREFRAME_WIDTH - 4 - idt32_errorcode_string_len
	call idt32_putchar_repeat

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl


	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	pop edi
	cmp edi, 0
	je .noErrorCode

		mov edi, dword [Error_Code_bank]
		mov esi, 32
		call idt32_putbin
		jmp .endErrorCode

	.noErrorCode:

		mov edi, idt32_noerrorcode_string
		mov esi, idt32_noerrorcode_string_len
		call idt32_putnchar
	.endErrorCode:

	mov edi, '|'
	mov esi, 2
	call idt32_putchar_repeat

	call idt32_putnl

	mov  edi, '='
	mov  esi, IDT32_TRAP32_WIREFRAME_WIDTH
	call idt32_putchar_repeat

	ret
; void idt32_trap32(void)
idt32_trap32_error_code:
static idt32_trap32:function
	; TODO: Bank EIP, ESP and EBP(?) correctly

	mov dword [reg_EAX_bank], eax
	mov dword [reg_EBX_bank], ebx
	mov dword [reg_ECX_bank], ecx
	mov dword [reg_EDX_bank], edx
	mov dword [reg_ESI_bank], esi
	mov dword [reg_EDI_bank], edi
	mov dword [reg_ESP_bank], esp
	mov dword [reg_EBP_bank], ebp
	mov word [reg_CS_bank],  cs
	mov word [reg_DS_bank],  ds
	mov word [reg_SS_bank],  ss
	mov word [reg_ES_bank],  es
	mov word [reg_FS_bank],  fs
	mov word [reg_GS_bank],  gs

	pop eax
	mov dword [Error_Code_bank], eax

	pop eax
	mov dword [reg_EIP_bank], eax

	mov edi, 1
	call idt32_regdump
	
	; TODO: put all the other lines

	jmp $

	iret



; void idt32_trap32(void)
idt32_trap32:
static idt32_trap32:function
	; TODO: Bank EIP, ESP and EBP(?) correctly

	mov dword [reg_EAX_bank], eax
	mov dword [reg_EBX_bank], ebx
	mov dword [reg_ECX_bank], ecx
	mov dword [reg_EDX_bank], edx
	mov dword [reg_ESI_bank], esi
	mov dword [reg_EDI_bank], edi
	mov dword [reg_ESP_bank], esp
	mov dword [reg_EBP_bank], ebp
	mov word [reg_CS_bank],  cs
	mov word [reg_DS_bank],  ds
	mov word [reg_SS_bank],  ss
	mov word [reg_ES_bank],  es
	mov word [reg_FS_bank],  fs
	mov word [reg_GS_bank],  gs

	pop eax
	mov dword [reg_EIP_bank], eax

	mov edi, 0
	call idt32_regdump
	
	; TODO: put all the other lines

	jmp $

	iret

idt32_exception_GPF_string:
	db " #GP "
.end:	
%define idt32_exception_GPF_string_len (idt32_exception_GPF_string.end - idt32_exception_GPF_string)

idt32_GPF:
static idt32_trap32:function
	; TODO: Bank EIP, ESP and EBP(?) correctly

	mov dword [reg_EAX_bank], eax
	mov dword [reg_EBX_bank], ebx
	mov dword [reg_ECX_bank], ecx
	mov dword [reg_EDX_bank], edx
	mov dword [reg_ESI_bank], esi
	mov dword [reg_EDI_bank], edi
	mov dword [reg_ESP_bank], esp
	mov dword [reg_EBP_bank], ebp
	mov word [reg_CS_bank],  cs
	mov word [reg_DS_bank],  ds
	mov word [reg_SS_bank],  ss
	mov word [reg_ES_bank],  es
	mov word [reg_FS_bank],  fs
	mov word [reg_GS_bank],  gs

	pop eax
	mov dword [Error_Code_bank], eax

	pop eax
	mov dword [reg_EIP_bank], eax

	mov edi, 1
	call idt32_regdump

	mov edi, 0xB8000 + TEXT_WIDTH_IN_BYTES + (3 * 2) ;line 1 (zero indexed), column 2 (zero indexed), multiplied by 2 since 1 byte out of two controls color
	mov [idt32_cursor], edi

	mov edi, idt32_exception_GPF_string
	mov esi, idt32_exception_GPF_string_len
	call idt32_putnchar
	
	; TODO: put all the other lines

	jmp $

;Name   ; IDT32 Trap32 WireFrame
;Width  ; 123456789;123456789;123456789;123456789;123456789;123456789;1234
;line  0; ======================================                            x
;line  1; ||  #xx occured at EIP = 0x01234567 ||                            x
;line  2; ||==================================||                            x
;line  3; ||All-Purpose Regs||  Segment Regs  ||
;line  4; ||                ||                ||
;line  5; ||EAX = 0x01234567||  CS = 0x0123   ||
;line  6; ||EBX = 0x01234567||  DS = 0x0123   ||
;line  7; ||ECX = 0x01234567||  SS = 0x0123   ||
;line  8; ||EDX = 0x01234567||  ES = 0x0123   ||
;line  9; ||ESI = 0x01234567||  FS = 0x0123   ||
;line 10; ||EDI = 0x01234567||  GS = 0x0123   ||
;line 11; ||ESP = 0x01234567||                ||
;line 12; ||EBP = 0x01234567||  By RushiTori  ||
;line 13; ||==================================||
;line 14; ||Error Code:                       ||
;line 15; ||0b0123456789;0123456789;0123456789||
;line 16; ======================================
;line 15; ||           No Error Code          ||
;	 alt;

InterruptHandlerTable:
	dd idt32_trap32    			;division
	dd idt32_trap32    			;debug
	dd idt32_trap32	   			;NMI
	dd idt32_trap32    			;breakpoint
	dd idt32_trap32    			;overflow
	dd idt32_trap32    			;bound range exceeded
	dd idt32_trap32    			;invalid opcode
	dd idt32_trap32 			;device not available
	dd idt32_trap32_error_code	;double fault
	dd 0			   			;coprocessor segment overrun (doesn't happen anymore)
	dd idt32_trap32_error_code 	;invalid tss
	dd idt32_trap32_error_code  ;segment not present
	dd idt32_trap32_error_code	;stack segment fault
	dd idt32_GPF				;GPF
	dd idt32_trap32_error_code	;page fault
	dd 0						;reserved

	dd idt32_trap32				;x87 floating point exception
	dd idt32_trap32_error_code	;alignment check
	dd idt32_trap32				;machine check
	dd idt32_trap32				;SIMD floating point exception
	dd idt32_trap32				;virtualization exception
	dd idt32_trap32_error_code	;control protection exception
	dd 0						;reserved
	dd 0
	dd 0
	dd 0
	dd 0
	dd 0						;all the way until there
	dd idt32_trap32				;hypervisor injection exception
	dd idt32_trap32_error_code	;VMM communication exception
	dd idt32_trap32_error_code	;security exception
	dd 0						;reserved