bits 64

%include "bootloader/idt.inc"
%include "bootloader/boot.inc"
%include "engine/display.inc"
%include "pic.inc"
%include "main/main.inc"
%include "keyboard.inc"
extern memory_mover_start

section .rodata

text_test:
static text_test:data
	db "Chirp chirp", 0xa, 0x9, "This seems to work !!", 0

section .bss

keyPressed:
static keyPressed:data
	resw 1

section .text

IDT_Setup: ;0x8400
	cli

	call keyboardSetScancodeTable

	mov rsp, 0x7c00
	mov rbp, rsp

	jmp main

	mov rcx, 960
	mov rdi, 0xA0000
	mov rax, 0X0808080808080808
	rep stosq

	xor rax, rax
	xor rcx, rcx
	.setIDTloop:
		mov rdi, qword[IDT_data_table + rax * 8]
		mov rsi, 0x10
		mov rdx, GATE_TYPE_TRAP_64
		mov r8, rax
		call setGate
		inc rax
		cmp rax, 256
		jne .setIDTloop

	mov rdi, 0xFC
	mov rsi, 0xFF
	call mask_pic64

	mov word[IDTR_START + IDTDescriptor.byteSize], 256 * 8 - 1
	mov qword[IDTR_START + IDTDescriptor.ptr], IDT_START

	;jmp $

	lidt [IDTR_START]
	sti
	;mov rax, 0
	;div rax
	;mov byte[0x0], 10
waitForInterrupt:
	hlt
	mov eax, [scancode]
	cmp eax, 0
	je waitForInterrupt

	mov dword[scancode], 0

	cmp eax, 0x5A
	jne .checkReleased

	mov rdi, 0x0A
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square

	jmp waitForInterrupt
.checkReleased:
	cmp eax, 0xF05A
	jne waitForInterrupt

	mov rdi, 0x02
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square

	jmp waitForInterrupt

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

;rdi = idx
nullify_IDT_gate:
	imul rdi, IDTGateDescriptor_size
	mov qword[IDT_START + rdi], 0
	mov qword[IDT_START + rdi + 8], 0
	ret

interrupt_func0x00:
	
	mov rdi, 0x00
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x01:
	
	mov rdi, 0x01
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x02:
	
	mov rdi, 0x02
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x03:
	
	mov rdi, 0x03
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x04:
	
	mov rdi, 0x04
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x05:
	
	mov rdi, 0x05
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x06:
	
	mov rdi, 0x06
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x07:
	
	mov rdi, 0x07
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x08:
	
	mov rdi, 0x08
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x09:
	
	mov rdi, 0x09
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0A:
	
	mov rdi, 0x0A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0B:
	
	mov rdi, 0x0B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0C:
	
	mov rdi, 0x0C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0D:
	
	mov rdi, 0x0D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0E:
	
	mov rdi, 0x0E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0F:
	
	mov rdi, 0x0F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x10:
	
	mov rdi, 0x10
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x11:
	
	mov rdi, 0x11
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x12:
	
	mov rdi, 0x12
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x13:
	
	mov rdi, 0x13
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x14:
	
	mov rdi, 0x14
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x15:
	
	mov rdi, 0x15
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x16:
	
	mov rdi, 0x16
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x17:
	
	mov rdi, 0x17
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x18:
	
	mov rdi, 0x18
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x19:
	
	mov rdi, 0x19
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1A:
	
	mov rdi, 0x1A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1B:
	
	mov rdi, 0x1B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1C:
	
	mov rdi, 0x1C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1D:
	
	mov rdi, 0x1D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1E:
	
	mov rdi, 0x1E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1F:
	
	mov rdi, 0x1F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x20: ;IRQ0 aka system timer
	push rax	;just in case because i don't know what registers are modified
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push rbp
	mov rbp, rsp

	mov rdi, 0x20
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square

	mov rdi, 0 ;IRQ0
	call sendEOI_pic64

	mov rsp, rbp
	pop rbp
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	iretq

interrupt_func0x21:	;IRQ1 aka keyboard IRQ
	push rax	;just in case because i don't know what registers are modified
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push rbp
	mov rbp, rsp

	mov rdi, 0x21
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square

	call keyboardRead

	mov rdi, 1 ;IRQ1
	call sendEOI_pic64	;tell the PIC we finished handling the interrupt

	mov rsp, rbp
	pop rbp
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	iretq	;this is how we return from an interrupt in long mode

interrupt_func0x22:
	mov rdi, 0x22
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square

	mov rdi, 2 ;IRQ2
	call sendEOI_pic64
	iretq

interrupt_func0x23:
	
	mov rdi, 0x23
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x24:
	
	mov rdi, 0x24
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x25:
	
	mov rdi, 0x25
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x26:
	
	mov rdi, 0x26
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x27:
	
	mov rdi, 0x27
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x28:
	
	mov rdi, 0x28
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x29:
	
	mov rdi, 0x29
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2A:
	
	mov rdi, 0x2A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2B:
	
	mov rdi, 0x2B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2C:
	
	mov rdi, 0x2C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2D:
	
	mov rdi, 0x2D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2E:
	
	mov rdi, 0x2E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2F:
	
	mov rdi, 0x2F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x30:
	
	mov rdi, 0x30
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x31:
	
	mov rdi, 0x31
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x32:
	
	mov rdi, 0x32
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x33:
	
	mov rdi, 0x33
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x34:
	
	mov rdi, 0x34
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x35:
	
	mov rdi, 0x35
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x36:
	
	mov rdi, 0x36
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x37:
	
	mov rdi, 0x37
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x38:
	
	mov rdi, 0x38
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x39:
	
	mov rdi, 0x39
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3A:
	
	mov rdi, 0x3A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3B:
	
	mov rdi, 0x3B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3C:
	
	mov rdi, 0x3C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3D:
	
	mov rdi, 0x3D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3E:
	
	mov rdi, 0x3E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3F:
	
	mov rdi, 0x3F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x40:
	
	mov rdi, 0x40
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x41:
	
	mov rdi, 0x41
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x42:
	
	mov rdi, 0x42
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x43:
	
	mov rdi, 0x43
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x44:
	
	mov rdi, 0x44
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x45:
	
	mov rdi, 0x45
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x46:
	
	mov rdi, 0x46
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x47:
	
	mov rdi, 0x47
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x48:
	
	mov rdi, 0x48
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x49:
	
	mov rdi, 0x49
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4A:
	
	mov rdi, 0x4A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4B:
	
	mov rdi, 0x4B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4C:
	
	mov rdi, 0x4C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4D:
	
	mov rdi, 0x4D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4E:
	
	mov rdi, 0x4E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4F:
	
	mov rdi, 0x4F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x50:
	
	mov rdi, 0x50
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x51:
	
	mov rdi, 0x51
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x52:
	
	mov rdi, 0x52
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x53:
	
	mov rdi, 0x53
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x54:
	
	mov rdi, 0x54
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x55:
	
	mov rdi, 0x55
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x56:
	
	mov rdi, 0x56
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x57:
	
	mov rdi, 0x57
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x58:
	
	mov rdi, 0x58
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x59:
	
	mov rdi, 0x59
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5A:
	
	mov rdi, 0x5A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5B:
	
	mov rdi, 0x5B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5C:
	
	mov rdi, 0x5C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5D:
	
	mov rdi, 0x5D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5E:
	
	mov rdi, 0x5E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5F:
	
	mov rdi, 0x5F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x60:
	
	mov rdi, 0x60
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x61:
	
	mov rdi, 0x61
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x62:
	
	mov rdi, 0x62
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x63:
	
	mov rdi, 0x63
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x64:
	
	mov rdi, 0x64
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x65:
	
	mov rdi, 0x65
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x66:
	
	mov rdi, 0x66
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x67:
	
	mov rdi, 0x67
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x68:
	
	mov rdi, 0x68
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x69:
	
	mov rdi, 0x69
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6A:
	
	mov rdi, 0x6A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6B:
	
	mov rdi, 0x6B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6C:
	
	mov rdi, 0x6C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6D:
	
	mov rdi, 0x6D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6E:
	
	mov rdi, 0x6E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6F:
	
	mov rdi, 0x6F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x70:
	
	mov rdi, 0x70
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x71:
	
	mov rdi, 0x71
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x72:
	
	mov rdi, 0x72
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x73:
	
	mov rdi, 0x73
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x74:
	
	mov rdi, 0x74
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x75:
	
	mov rdi, 0x75
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x76:
	
	mov rdi, 0x76
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x77:
	
	mov rdi, 0x77
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x78:
	
	mov rdi, 0x78
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x79:
	
	mov rdi, 0x79
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7A:
	
	mov rdi, 0x7A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7B:
	
	mov rdi, 0x7B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7C:
	
	mov rdi, 0x7C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7D:
	
	mov rdi, 0x7D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7E:
	
	mov rdi, 0x7E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7F:
	
	mov rdi, 0x7F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x80:
	
	mov rdi, 0x80
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x81:
	
	mov rdi, 0x81
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x82:
	
	mov rdi, 0x82
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x83:
	
	mov rdi, 0x83
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x84:
	
	mov rdi, 0x84
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x85:
	
	mov rdi, 0x85
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x86:
	
	mov rdi, 0x86
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x87:
	
	mov rdi, 0x87
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x88:
	
	mov rdi, 0x88
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x89:
	
	mov rdi, 0x89
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8A:
	
	mov rdi, 0x8A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8B:
	
	mov rdi, 0x8B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8C:
	
	mov rdi, 0x8C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8D:
	
	mov rdi, 0x8D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8E:
	
	mov rdi, 0x8E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8F:
	
	mov rdi, 0x8F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x90:
	
	mov rdi, 0x90
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x91:
	
	mov rdi, 0x91
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x92:
	
	mov rdi, 0x92
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x93:
	
	mov rdi, 0x93
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x94:
	
	mov rdi, 0x94
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x95:
	
	mov rdi, 0x95
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x96:
	
	mov rdi, 0x96
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x97:
	
	mov rdi, 0x97
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x98:
	
	mov rdi, 0x98
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x99:
	
	mov rdi, 0x99
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9A:
	
	mov rdi, 0x9A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9B:
	
	mov rdi, 0x9B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9C:
	
	mov rdi, 0x9C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9D:
	
	mov rdi, 0x9D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9E:
	
	mov rdi, 0x9E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9F:
	
	mov rdi, 0x9F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA0:
	
	mov rdi, 0xA0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA1:
	
	mov rdi, 0xA1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA2:
	
	mov rdi, 0xA2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA3:
	
	mov rdi, 0xA3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA4:
	
	mov rdi, 0xA4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA5:
	
	mov rdi, 0xA5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA6:
	
	mov rdi, 0xA6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA7:
	
	mov rdi, 0xA7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA8:
	
	mov rdi, 0xA8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA9:
	
	mov rdi, 0xA9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAA:
	
	mov rdi, 0xAA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAB:
	
	mov rdi, 0xAB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAC:
	
	mov rdi, 0xAC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAD:
	
	mov rdi, 0xAD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAE:
	
	mov rdi, 0xAE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAF:
	
	mov rdi, 0xAF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB0:
	
	mov rdi, 0xB0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB1:
	
	mov rdi, 0xB1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB2:
	
	mov rdi, 0xB2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB3:
	
	mov rdi, 0xB3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB4:
	
	mov rdi, 0xB4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB5:
	
	mov rdi, 0xB5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB6:
	
	mov rdi, 0xB6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB7:
	
	mov rdi, 0xB7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB8:
	
	mov rdi, 0xB8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB9:
	
	mov rdi, 0xB9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBA:
	
	mov rdi, 0xBA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBB:
	
	mov rdi, 0xBB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBC:
	
	mov rdi, 0xBC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBD:
	
	mov rdi, 0xBD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBE:
	
	mov rdi, 0xBE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBF:
	
	mov rdi, 0xBF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC0:
	
	mov rdi, 0xC0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC1:
	
	mov rdi, 0xC1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC2:
	
	mov rdi, 0xC2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC3:
	
	mov rdi, 0xC3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC4:
	
	mov rdi, 0xC4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC5:
	
	mov rdi, 0xC5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC6:
	
	mov rdi, 0xC6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC7:
	
	mov rdi, 0xC7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC8:
	
	mov rdi, 0xC8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC9:
	
	mov rdi, 0xC9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCA:
	
	mov rdi, 0xCA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCB:
	
	mov rdi, 0xCB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCC:
	
	mov rdi, 0xCC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCD:
	
	mov rdi, 0xCD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCE:
	
	mov rdi, 0xCE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCF:
	
	mov rdi, 0xCF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD0:
	
	mov rdi, 0xD0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD1:
	
	mov rdi, 0xD1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD2:
	
	mov rdi, 0xD2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD3:
	
	mov rdi, 0xD3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD4:
	
	mov rdi, 0xD4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD5:
	
	mov rdi, 0xD5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD6:
	
	mov rdi, 0xD6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD7:
	
	mov rdi, 0xD7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD8:
	
	mov rdi, 0xD8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD9:
	
	mov rdi, 0xD9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDA:
	
	mov rdi, 0xDA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDB:
	
	mov rdi, 0xDB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDC:
	
	mov rdi, 0xDC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDD:
	
	mov rdi, 0xDD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDE:
	
	mov rdi, 0xDE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDF:
	
	mov rdi, 0xDF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE0:
	
	mov rdi, 0xE0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE1:
	
	mov rdi, 0xE1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE2:
	
	mov rdi, 0xE2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE3:
	
	mov rdi, 0xE3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE4:
	
	mov rdi, 0xE4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE5:
	
	mov rdi, 0xE5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE6:
	
	mov rdi, 0xE6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE7:
	
	mov rdi, 0xE7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE8:
	
	mov rdi, 0xE8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE9:
	
	mov rdi, 0xE9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEA:
	
	mov rdi, 0xEA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEB:
	
	mov rdi, 0xEB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEC:
	
	mov rdi, 0xEC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xED:
	
	mov rdi, 0xED
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEE:
	
	mov rdi, 0xEE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEF:
	
	mov rdi, 0xEF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF0:
	
	mov rdi, 0xF0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF1:
	
	mov rdi, 0xF1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF2:
	
	mov rdi, 0xF2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF3:
	
	mov rdi, 0xF3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF4:
	
	mov rdi, 0xF4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF5:
	
	mov rdi, 0xF5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF6:
	
	mov rdi, 0xF6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF7:
	
	mov rdi, 0xF7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF8:
	
	mov rdi, 0xF8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF9:
	
	mov rdi, 0xF9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFA:
	
	mov rdi, 0xFA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFB:
	
	mov rdi, 0xFB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFC:
	
	mov rdi, 0xFC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFD:
	
	mov rdi, 0xFD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFE:
	
	mov rdi, 0xFE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFF:
	
	mov rdi, 0xFF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

IDT_data_table:
dq interrupt_func0x00
dq interrupt_func0x01
dq interrupt_func0x02
dq interrupt_func0x03
dq interrupt_func0x04
dq interrupt_func0x05
dq interrupt_func0x06
dq interrupt_func0x07
dq interrupt_func0x08
dq interrupt_func0x09
dq interrupt_func0x0A
dq interrupt_func0x0B
dq interrupt_func0x0C
dq interrupt_func0x0D
dq interrupt_func0x0E
dq interrupt_func0x0F
dq interrupt_func0x10
dq interrupt_func0x11
dq interrupt_func0x12
dq interrupt_func0x13
dq interrupt_func0x14
dq interrupt_func0x15
dq interrupt_func0x16
dq interrupt_func0x17
dq interrupt_func0x18
dq interrupt_func0x19
dq interrupt_func0x1A
dq interrupt_func0x1B
dq interrupt_func0x1C
dq interrupt_func0x1D
dq interrupt_func0x1E
dq interrupt_func0x1F
dq interrupt_func0x20
dq interrupt_func0x21
dq interrupt_func0x22
dq interrupt_func0x23
dq interrupt_func0x24
dq interrupt_func0x25
dq interrupt_func0x26
dq interrupt_func0x27
dq interrupt_func0x28
dq interrupt_func0x29
dq interrupt_func0x2A
dq interrupt_func0x2B
dq interrupt_func0x2C
dq interrupt_func0x2D
dq interrupt_func0x2E
dq interrupt_func0x2F
dq interrupt_func0x30
dq interrupt_func0x31
dq interrupt_func0x32
dq interrupt_func0x33
dq interrupt_func0x34
dq interrupt_func0x35
dq interrupt_func0x36
dq interrupt_func0x37
dq interrupt_func0x38
dq interrupt_func0x39
dq interrupt_func0x3A
dq interrupt_func0x3B
dq interrupt_func0x3C
dq interrupt_func0x3D
dq interrupt_func0x3E
dq interrupt_func0x3F
dq interrupt_func0x40
dq interrupt_func0x41
dq interrupt_func0x42
dq interrupt_func0x43
dq interrupt_func0x44
dq interrupt_func0x45
dq interrupt_func0x46
dq interrupt_func0x47
dq interrupt_func0x48
dq interrupt_func0x49
dq interrupt_func0x4A
dq interrupt_func0x4B
dq interrupt_func0x4C
dq interrupt_func0x4D
dq interrupt_func0x4E
dq interrupt_func0x4F
dq interrupt_func0x50
dq interrupt_func0x51
dq interrupt_func0x52
dq interrupt_func0x53
dq interrupt_func0x54
dq interrupt_func0x55
dq interrupt_func0x56
dq interrupt_func0x57
dq interrupt_func0x58
dq interrupt_func0x59
dq interrupt_func0x5A
dq interrupt_func0x5B
dq interrupt_func0x5C
dq interrupt_func0x5D
dq interrupt_func0x5E
dq interrupt_func0x5F
dq interrupt_func0x60
dq interrupt_func0x61
dq interrupt_func0x62
dq interrupt_func0x63
dq interrupt_func0x64
dq interrupt_func0x65
dq interrupt_func0x66
dq interrupt_func0x67
dq interrupt_func0x68
dq interrupt_func0x69
dq interrupt_func0x6A
dq interrupt_func0x6B
dq interrupt_func0x6C
dq interrupt_func0x6D
dq interrupt_func0x6E
dq interrupt_func0x6F
dq interrupt_func0x70
dq interrupt_func0x71
dq interrupt_func0x72
dq interrupt_func0x73
dq interrupt_func0x74
dq interrupt_func0x75
dq interrupt_func0x76
dq interrupt_func0x77
dq interrupt_func0x78
dq interrupt_func0x79
dq interrupt_func0x7A
dq interrupt_func0x7B
dq interrupt_func0x7C
dq interrupt_func0x7D
dq interrupt_func0x7E
dq interrupt_func0x7F
dq interrupt_func0x80
dq interrupt_func0x81
dq interrupt_func0x82
dq interrupt_func0x83
dq interrupt_func0x84
dq interrupt_func0x85
dq interrupt_func0x86
dq interrupt_func0x87
dq interrupt_func0x88
dq interrupt_func0x89
dq interrupt_func0x8A
dq interrupt_func0x8B
dq interrupt_func0x8C
dq interrupt_func0x8D
dq interrupt_func0x8E
dq interrupt_func0x8F
dq interrupt_func0x90
dq interrupt_func0x91
dq interrupt_func0x92
dq interrupt_func0x93
dq interrupt_func0x94
dq interrupt_func0x95
dq interrupt_func0x96
dq interrupt_func0x97
dq interrupt_func0x98
dq interrupt_func0x99
dq interrupt_func0x9A
dq interrupt_func0x9B
dq interrupt_func0x9C
dq interrupt_func0x9D
dq interrupt_func0x9E
dq interrupt_func0x9F
dq interrupt_func0xA0
dq interrupt_func0xA1
dq interrupt_func0xA2
dq interrupt_func0xA3
dq interrupt_func0xA4
dq interrupt_func0xA5
dq interrupt_func0xA6
dq interrupt_func0xA7
dq interrupt_func0xA8
dq interrupt_func0xA9
dq interrupt_func0xAA
dq interrupt_func0xAB
dq interrupt_func0xAC
dq interrupt_func0xAD
dq interrupt_func0xAE
dq interrupt_func0xAF
dq interrupt_func0xB0
dq interrupt_func0xB1
dq interrupt_func0xB2
dq interrupt_func0xB3
dq interrupt_func0xB4
dq interrupt_func0xB5
dq interrupt_func0xB6
dq interrupt_func0xB7
dq interrupt_func0xB8
dq interrupt_func0xB9
dq interrupt_func0xBA
dq interrupt_func0xBB
dq interrupt_func0xBC
dq interrupt_func0xBD
dq interrupt_func0xBE
dq interrupt_func0xBF
dq interrupt_func0xC0
dq interrupt_func0xC1
dq interrupt_func0xC2
dq interrupt_func0xC3
dq interrupt_func0xC4
dq interrupt_func0xC5
dq interrupt_func0xC6
dq interrupt_func0xC7
dq interrupt_func0xC8
dq interrupt_func0xC9
dq interrupt_func0xCA
dq interrupt_func0xCB
dq interrupt_func0xCC
dq interrupt_func0xCD
dq interrupt_func0xCE
dq interrupt_func0xCF
dq interrupt_func0xD0
dq interrupt_func0xD1
dq interrupt_func0xD2
dq interrupt_func0xD3
dq interrupt_func0xD4
dq interrupt_func0xD5
dq interrupt_func0xD6
dq interrupt_func0xD7
dq interrupt_func0xD8
dq interrupt_func0xD9
dq interrupt_func0xDA
dq interrupt_func0xDB
dq interrupt_func0xDC
dq interrupt_func0xDD
dq interrupt_func0xDE
dq interrupt_func0xDF
dq interrupt_func0xE0
dq interrupt_func0xE1
dq interrupt_func0xE2
dq interrupt_func0xE3
dq interrupt_func0xE4
dq interrupt_func0xE5
dq interrupt_func0xE6
dq interrupt_func0xE7
dq interrupt_func0xE8
dq interrupt_func0xE9
dq interrupt_func0xEA
dq interrupt_func0xEB
dq interrupt_func0xEC
dq interrupt_func0xED
dq interrupt_func0xEE
dq interrupt_func0xEF
dq interrupt_func0xF0
dq interrupt_func0xF1
dq interrupt_func0xF2
dq interrupt_func0xF3
dq interrupt_func0xF4
dq interrupt_func0xF5
dq interrupt_func0xF6
dq interrupt_func0xF7
dq interrupt_func0xF8
dq interrupt_func0xF9
dq interrupt_func0xFA
dq interrupt_func0xFB
dq interrupt_func0xFC
dq interrupt_func0xFD
dq interrupt_func0xFE
dq interrupt_func0xFF

PAD_SECTOR(SECTOR_SIZE * 22)
