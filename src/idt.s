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
		mov rdi, qword[IDT_data_table + rax * 8]
		mov rsi, 0x10
		mov rdx, GATE_TYPE_TRAP_64
		mov r8, rax
		call setGate
		inc rax
		cmp rax, 256
		jne .setIDTloop

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

interrupt_func0x00:
	cli
	mov rdi, 0x00
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x01:
	cli
	mov rdi, 0x01
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x02:
	cli
	mov rdi, 0x02
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x03:
	cli
	mov rdi, 0x03
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x04:
	cli
	mov rdi, 0x04
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x05:
	cli
	mov rdi, 0x05
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x06:
	cli
	mov rdi, 0x06
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x07:
	cli
	mov rdi, 0x07
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x08:
	cli
	mov rdi, 0x08
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x09:
	cli
	mov rdi, 0x09
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0A:
	cli
	mov rdi, 0x0A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0B:
	cli
	mov rdi, 0x0B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0C:
	cli
	mov rdi, 0x0C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0D:
	cli
	mov rdi, 0x0D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0E:
	cli
	mov rdi, 0x0E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x0F:
	cli
	mov rdi, 0x0F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x10:
	cli
	mov rdi, 0x10
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x11:
	cli
	mov rdi, 0x11
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x12:
	cli
	mov rdi, 0x12
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x13:
	cli
	mov rdi, 0x13
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x14:
	cli
	mov rdi, 0x14
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x15:
	cli
	mov rdi, 0x15
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x16:
	cli
	mov rdi, 0x16
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x17:
	cli
	mov rdi, 0x17
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x18:
	cli
	mov rdi, 0x18
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x19:
	cli
	mov rdi, 0x19
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1A:
	cli
	mov rdi, 0x1A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1B:
	cli
	mov rdi, 0x1B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1C:
	cli
	mov rdi, 0x1C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1D:
	cli
	mov rdi, 0x1D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1E:
	cli
	mov rdi, 0x1E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x1F:
	cli
	mov rdi, 0x1F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x0 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x20:
	cli
	mov rdi, 0x20
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x21:
	cli
	mov rdi, 0x21
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x22:
	cli
	mov rdi, 0x22
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x23:
	cli
	mov rdi, 0x23
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x24:
	cli
	mov rdi, 0x24
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x25:
	cli
	mov rdi, 0x25
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x26:
	cli
	mov rdi, 0x26
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x27:
	cli
	mov rdi, 0x27
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x28:
	cli
	mov rdi, 0x28
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x29:
	cli
	mov rdi, 0x29
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2A:
	cli
	mov rdi, 0x2A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2B:
	cli
	mov rdi, 0x2B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2C:
	cli
	mov rdi, 0x2C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2D:
	cli
	mov rdi, 0x2D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2E:
	cli
	mov rdi, 0x2E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x2F:
	cli
	mov rdi, 0x2F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x2 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x30:
	cli
	mov rdi, 0x30
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x31:
	cli
	mov rdi, 0x31
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x32:
	cli
	mov rdi, 0x32
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x33:
	cli
	mov rdi, 0x33
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x34:
	cli
	mov rdi, 0x34
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x35:
	cli
	mov rdi, 0x35
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x36:
	cli
	mov rdi, 0x36
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x37:
	cli
	mov rdi, 0x37
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x38:
	cli
	mov rdi, 0x38
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x39:
	cli
	mov rdi, 0x39
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3A:
	cli
	mov rdi, 0x3A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3B:
	cli
	mov rdi, 0x3B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3C:
	cli
	mov rdi, 0x3C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3D:
	cli
	mov rdi, 0x3D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3E:
	cli
	mov rdi, 0x3E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x3F:
	cli
	mov rdi, 0x3F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x3 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x40:
	cli
	mov rdi, 0x40
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x41:
	cli
	mov rdi, 0x41
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x42:
	cli
	mov rdi, 0x42
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x43:
	cli
	mov rdi, 0x43
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x44:
	cli
	mov rdi, 0x44
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x45:
	cli
	mov rdi, 0x45
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x46:
	cli
	mov rdi, 0x46
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x47:
	cli
	mov rdi, 0x47
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x48:
	cli
	mov rdi, 0x48
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x49:
	cli
	mov rdi, 0x49
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4A:
	cli
	mov rdi, 0x4A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4B:
	cli
	mov rdi, 0x4B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4C:
	cli
	mov rdi, 0x4C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4D:
	cli
	mov rdi, 0x4D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4E:
	cli
	mov rdi, 0x4E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x4F:
	cli
	mov rdi, 0x4F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x4 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x50:
	cli
	mov rdi, 0x50
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x51:
	cli
	mov rdi, 0x51
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x52:
	cli
	mov rdi, 0x52
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x53:
	cli
	mov rdi, 0x53
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x54:
	cli
	mov rdi, 0x54
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x55:
	cli
	mov rdi, 0x55
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x56:
	cli
	mov rdi, 0x56
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x57:
	cli
	mov rdi, 0x57
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x58:
	cli
	mov rdi, 0x58
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x59:
	cli
	mov rdi, 0x59
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5A:
	cli
	mov rdi, 0x5A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5B:
	cli
	mov rdi, 0x5B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5C:
	cli
	mov rdi, 0x5C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5D:
	cli
	mov rdi, 0x5D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5E:
	cli
	mov rdi, 0x5E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x5F:
	cli
	mov rdi, 0x5F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x5 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x60:
	cli
	mov rdi, 0x60
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x61:
	cli
	mov rdi, 0x61
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x62:
	cli
	mov rdi, 0x62
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x63:
	cli
	mov rdi, 0x63
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x64:
	cli
	mov rdi, 0x64
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x65:
	cli
	mov rdi, 0x65
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x66:
	cli
	mov rdi, 0x66
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x67:
	cli
	mov rdi, 0x67
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x68:
	cli
	mov rdi, 0x68
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x69:
	cli
	mov rdi, 0x69
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6A:
	cli
	mov rdi, 0x6A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6B:
	cli
	mov rdi, 0x6B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6C:
	cli
	mov rdi, 0x6C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6D:
	cli
	mov rdi, 0x6D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6E:
	cli
	mov rdi, 0x6E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x6F:
	cli
	mov rdi, 0x6F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x6 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x70:
	cli
	mov rdi, 0x70
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x71:
	cli
	mov rdi, 0x71
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x72:
	cli
	mov rdi, 0x72
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x73:
	cli
	mov rdi, 0x73
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x74:
	cli
	mov rdi, 0x74
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x75:
	cli
	mov rdi, 0x75
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x76:
	cli
	mov rdi, 0x76
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x77:
	cli
	mov rdi, 0x77
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x78:
	cli
	mov rdi, 0x78
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x79:
	cli
	mov rdi, 0x79
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7A:
	cli
	mov rdi, 0x7A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7B:
	cli
	mov rdi, 0x7B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7C:
	cli
	mov rdi, 0x7C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7D:
	cli
	mov rdi, 0x7D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7E:
	cli
	mov rdi, 0x7E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x7F:
	cli
	mov rdi, 0x7F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x7 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x80:
	cli
	mov rdi, 0x80
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x81:
	cli
	mov rdi, 0x81
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x82:
	cli
	mov rdi, 0x82
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x83:
	cli
	mov rdi, 0x83
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x84:
	cli
	mov rdi, 0x84
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x85:
	cli
	mov rdi, 0x85
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x86:
	cli
	mov rdi, 0x86
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x87:
	cli
	mov rdi, 0x87
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x88:
	cli
	mov rdi, 0x88
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x89:
	cli
	mov rdi, 0x89
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8A:
	cli
	mov rdi, 0x8A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8B:
	cli
	mov rdi, 0x8B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8C:
	cli
	mov rdi, 0x8C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8D:
	cli
	mov rdi, 0x8D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8E:
	cli
	mov rdi, 0x8E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x8F:
	cli
	mov rdi, 0x8F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x8 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x90:
	cli
	mov rdi, 0x90
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x91:
	cli
	mov rdi, 0x91
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x92:
	cli
	mov rdi, 0x92
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x93:
	cli
	mov rdi, 0x93
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x94:
	cli
	mov rdi, 0x94
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x95:
	cli
	mov rdi, 0x95
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x96:
	cli
	mov rdi, 0x96
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x97:
	cli
	mov rdi, 0x97
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x98:
	cli
	mov rdi, 0x98
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x99:
	cli
	mov rdi, 0x99
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9A:
	cli
	mov rdi, 0x9A
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9B:
	cli
	mov rdi, 0x9B
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9C:
	cli
	mov rdi, 0x9C
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9D:
	cli
	mov rdi, 0x9D
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9E:
	cli
	mov rdi, 0x9E
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0x9F:
	cli
	mov rdi, 0x9F
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0x9 * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA0:
	cli
	mov rdi, 0xA0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA1:
	cli
	mov rdi, 0xA1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA2:
	cli
	mov rdi, 0xA2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA3:
	cli
	mov rdi, 0xA3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA4:
	cli
	mov rdi, 0xA4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA5:
	cli
	mov rdi, 0xA5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA6:
	cli
	mov rdi, 0xA6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA7:
	cli
	mov rdi, 0xA7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA8:
	cli
	mov rdi, 0xA8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xA9:
	cli
	mov rdi, 0xA9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAA:
	cli
	mov rdi, 0xAA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAB:
	cli
	mov rdi, 0xAB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAC:
	cli
	mov rdi, 0xAC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAD:
	cli
	mov rdi, 0xAD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAE:
	cli
	mov rdi, 0xAE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xAF:
	cli
	mov rdi, 0xAF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xA * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB0:
	cli
	mov rdi, 0xB0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB1:
	cli
	mov rdi, 0xB1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB2:
	cli
	mov rdi, 0xB2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB3:
	cli
	mov rdi, 0xB3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB4:
	cli
	mov rdi, 0xB4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB5:
	cli
	mov rdi, 0xB5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB6:
	cli
	mov rdi, 0xB6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB7:
	cli
	mov rdi, 0xB7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB8:
	cli
	mov rdi, 0xB8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xB9:
	cli
	mov rdi, 0xB9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBA:
	cli
	mov rdi, 0xBA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBB:
	cli
	mov rdi, 0xBB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBC:
	cli
	mov rdi, 0xBC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBD:
	cli
	mov rdi, 0xBD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBE:
	cli
	mov rdi, 0xBE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xBF:
	cli
	mov rdi, 0xBF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xB * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC0:
	cli
	mov rdi, 0xC0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC1:
	cli
	mov rdi, 0xC1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC2:
	cli
	mov rdi, 0xC2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC3:
	cli
	mov rdi, 0xC3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC4:
	cli
	mov rdi, 0xC4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC5:
	cli
	mov rdi, 0xC5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC6:
	cli
	mov rdi, 0xC6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC7:
	cli
	mov rdi, 0xC7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC8:
	cli
	mov rdi, 0xC8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xC9:
	cli
	mov rdi, 0xC9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCA:
	cli
	mov rdi, 0xCA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCB:
	cli
	mov rdi, 0xCB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCC:
	cli
	mov rdi, 0xCC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCD:
	cli
	mov rdi, 0xCD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCE:
	cli
	mov rdi, 0xCE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xCF:
	cli
	mov rdi, 0xCF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xC * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD0:
	cli
	mov rdi, 0xD0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD1:
	cli
	mov rdi, 0xD1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD2:
	cli
	mov rdi, 0xD2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD3:
	cli
	mov rdi, 0xD3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD4:
	cli
	mov rdi, 0xD4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD5:
	cli
	mov rdi, 0xD5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD6:
	cli
	mov rdi, 0xD6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD7:
	cli
	mov rdi, 0xD7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD8:
	cli
	mov rdi, 0xD8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xD9:
	cli
	mov rdi, 0xD9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDA:
	cli
	mov rdi, 0xDA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDB:
	cli
	mov rdi, 0xDB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDC:
	cli
	mov rdi, 0xDC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDD:
	cli
	mov rdi, 0xDD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDE:
	cli
	mov rdi, 0xDE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xDF:
	cli
	mov rdi, 0xDF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xD * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE0:
	cli
	mov rdi, 0xE0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE1:
	cli
	mov rdi, 0xE1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE2:
	cli
	mov rdi, 0xE2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE3:
	cli
	mov rdi, 0xE3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE4:
	cli
	mov rdi, 0xE4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE5:
	cli
	mov rdi, 0xE5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE6:
	cli
	mov rdi, 0xE6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE7:
	cli
	mov rdi, 0xE7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE8:
	cli
	mov rdi, 0xE8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xE9:
	cli
	mov rdi, 0xE9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEA:
	cli
	mov rdi, 0xEA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEB:
	cli
	mov rdi, 0xEB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEC:
	cli
	mov rdi, 0xEC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xED:
	cli
	mov rdi, 0xED
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEE:
	cli
	mov rdi, 0xEE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xEF:
	cli
	mov rdi, 0xEF
	call set_color
	mov rdi, 0xF * 8
	mov rsi, 0xE * 8
	mov rdx, 8
	call draw_square
	jmp $








interrupt_func0xF0:
	cli
	mov rdi, 0xF0
	call set_color
	mov rdi, 0x0 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF1:
	cli
	mov rdi, 0xF1
	call set_color
	mov rdi, 0x1 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF2:
	cli
	mov rdi, 0xF2
	call set_color
	mov rdi, 0x2 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF3:
	cli
	mov rdi, 0xF3
	call set_color
	mov rdi, 0x3 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF4:
	cli
	mov rdi, 0xF4
	call set_color
	mov rdi, 0x4 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF5:
	cli
	mov rdi, 0xF5
	call set_color
	mov rdi, 0x5 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF6:
	cli
	mov rdi, 0xF6
	call set_color
	mov rdi, 0x6 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF7:
	cli
	mov rdi, 0xF7
	call set_color
	mov rdi, 0x7 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF8:
	cli
	mov rdi, 0xF8
	call set_color
	mov rdi, 0x8 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xF9:
	cli
	mov rdi, 0xF9
	call set_color
	mov rdi, 0x9 * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFA:
	cli
	mov rdi, 0xFA
	call set_color
	mov rdi, 0xA * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFB:
	cli
	mov rdi, 0xFB
	call set_color
	mov rdi, 0xB * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFC:
	cli
	mov rdi, 0xFC
	call set_color
	mov rdi, 0xC * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFD:
	cli
	mov rdi, 0xFD
	call set_color
	mov rdi, 0xD * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFE:
	cli
	mov rdi, 0xFE
	call set_color
	mov rdi, 0xE * 8
	mov rsi, 0xF * 8
	mov rdx, 8
	call draw_square
	jmp $

interrupt_func0xFF:
	cli
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

PAD_SECTOR(SECTOR_SIZE * 21)
