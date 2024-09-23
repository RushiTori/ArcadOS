bits 64

%include "idt.inc"
%include "boot.inc"

org BOOT_SECTOR(4)

IDT_Setup: ;0x8400
	cli
.setSegments:
	mov ax, 0x18
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
.setIDT: 
	mov rdi, divByZero
	mov rsi, 0x08
	mov rdx, GATE_TYPE_TRAP_64
	mov rcx, 0
	mov r8, TRAP_DIVBYZERO
	call setGate
	mov word[IDTR_START + IDTDescriptor.byteSize + r8], 0x10 
	mov qword[IDTR_START + IDTDescriptor.ptr + r8], IDT_START

	jmp $

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
	mov word[IDT_START + IDTGateDescriptor.offset_0 + r8], di ;set first offset
	mov word[IDT_START + IDTGateDescriptor.seg_sel + r8], si ;set segment selector
	mov byte[IDT_START + IDTGateDescriptor.IST + r8], ;no ist implem
	shl cl, 5 ;shift dpl so that it's actually formatted correctly
	or dl, cl ;into dl, which is our gate type
	or dl, 0b10000000 ;add present bit
	mov byte[IDT_START + IDTGateDescriptor.gate_type_dpl + r8], dl ;
	shr rdi, 16
	mov word[IDT_START + IDTGateDescriptor.offset_1 + r8], di ;offset 1
	shr rdi, 16
	mov dword[IDT_START + IDTGateDescriptor.offset_2 + r8], edi ;offset 2
	ret

divByZero: ;TRAP 0x00
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0x0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

debug: ;TRAP 0x01
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0x0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

NMI: ;TRAP 0x02
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0x0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

breakpoint: ;TRAP 0x03
	cli
	mov rcx, 640
	mov rdi, 0xA0000
	mov rax, 0x0C0C0C0C0C0C0C0C
	rep stosq
	jmp $

overflow: ;TRAP 0x04
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0x0c0c0c0c0c0c0c0c
	rep stosq
	jmp $

boundRangeExceeded: ;TRAP 0x05
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0x0c0c0c0c0c0c0c0c
	rep stosq
	jmp $

invalidOpcode: ;TRAP 0x06
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0x0c0c0c0c0c0c0c0c
	rep stosq
	jmp $
	
deviceNotAvailable: ;TRAP 0x07
	cli
	mov rcx, 640
	mov rdi, 0xa0000
	mov rax, 0x0c0c0c0c0c0c0c0c
	rep stosq
	jmp $
times 512 - ($ - $$) db 0

