bits 64

%include "idt.inc"
%include "boot.inc"

org BOOT_SECTOR(4)

IDT_Setup: ;0x8400
	cli
	;xor rax, rax
.setIDT:
	mov rdi, divByZero
	mov rsi, 0x10
	mov rdx, GATE_TYPE_TRAP_64
	mov rcx, 0
	mov r8, rax
	call setGate
	;inc rax
	;cmp rax, 256
	;jne .setIDT

	mov word[IDTR_START + IDTDescriptor.byteSize], 15
	mov qword[IDTR_START + IDTDescriptor.ptr], IDT_START

	lidt [IDTR_START]
	sti
	mov rax, 0
	div rax
	jmp $

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

PAD_SECTOR(SECTOR_SIZE)
