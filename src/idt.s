bits 64

%include "idt.inc"
%include "boot.inc"
%include "display.inc"

section .text

IDT_Setup: ;0x8400
	mov rsp, 0x7c00
	mov rbp, rsp

	mov rdi, 0x0B
	call set_color
	call clear_screen

	mov rcx, 960
	mov rdi, 0xA0000
	mov rax, 0X0808080808080808
	rep stosq
	cli

	xor rax, rax
	xor rcx, rcx
	.setIDTloop:
		mov rdi, divByZero
		mov rsi, 0x10
		mov rdx, GATE_TYPE_TRAP_64
		mov r8, rax
		call setGate
		inc rax
		cmp rax, 256
		jne .setIDTloop

	mov rdi, pageFault
	mov rsi, 0x10
	mov rdx, GATE_TYPE_TRAP_64
	mov r8, 0x0E
	call setGate

	mov word[IDTR_START + IDTDescriptor.byteSize], 256 * 8 - 1
	mov qword[IDTR_START + IDTDescriptor.ptr], IDT_START


	;jmp $

	lidt [IDTR_START]
	sti
	;mov rax, 0
	;div rax
	mov byte[0x0], 10
	hlt

;rdi = offset
;rsi = segment selector
;rdx = gate type
;rcx = dpl
;r8 = idx
setGate:
	imul r8, IDTGateDescriptor_size
	mov word[IDT_START + r8 + IDTGateDescriptor.offset_0], di
	shr rdi, 16
	mov word[IDT_START + r8 + IDTGateDescriptor.offset_1], di
	shr rdi, 16
	mov dword[IDT_START + r8 + IDTGateDescriptor.offset_2], edi

	mov byte[IDT_START + r8 + IDTGateDescriptor.IST], 0
	mov word[IDT_START + r8 + IDTGateDescriptor.seg_sel], si

	and dl, 0xf
	and cl, 0x3
	shl cl, 5
	or dl, cl
	or dl, 0x80

	mov byte[IDT_START + r8 + IDTGateDescriptor.gate_type_dpl], dl

	mov dword[IDT_START + r8 + IDTGateDescriptor.reserved], 0
	ret

divByZero: ;TRAP 0x00
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

debug: ;TRAP 0x01
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

NMI: ;TRAP 0x02
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

breakpoint: ;TRAP 0x03
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

overflow: ;TRAP 0x04
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

boundRangeExceeded: ;TRAP 0x05
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

invalidOpcode: ;TRAP 0x06
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $
	
deviceNotAvailable: ;TRAP 0x07
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0X0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

generalProtectionFault: ;TRAP 0x0D
	jmp $
pageFault:				;TRAP 0x0E
	cli
	mov rcx, (320 * 8) / 8
	mov rdi, 0xa0000
	mov rax, 0x0202020202020202
	rep stosq
	mov rdi, 0
	mov rsi, 0
	call put_pixel
	jmp $

PAD_SECTOR(SECTOR_SIZE)
