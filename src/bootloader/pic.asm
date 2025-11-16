bits 32

%include "bootloader/pic.inc"

;edi: mask master
;esi: mask slave
mask_pic32:
global mask_pic32:function
	cli
	mov ax, di
	out PIC1_DATA, al
	mov ax, si
	out PIC2_DATA, al
	sti
	ret

;edi: offset of master PIC
;esi: offset of slave PIC
remap_pic32:
global remap_pic32:function
	in al, PIC1_DATA
	mov dl, al
	in al, PIC2_DATA
	mov dh, al

	mov al, ICW1_INIT | ICW1_ICW4
	out PIC1_COMMAND, al

	mov al, ICW1_INIT | ICW1_ICW4
	out PIC2_COMMAND, al

	mov ax, di
	out PIC1_DATA, al

	mov ax, si
	out PIC2_DATA, al

	mov al, 4
	out PIC1_DATA, al

	mov al, 2
	out PIC2_DATA, al

	mov al, ICW4_8086
	out PIC1_DATA, al

	mov al, ICW4_8086
	out PIC2_DATA, al

	mov al, dl
	out PIC1_DATA, al

	mov al, dh
	out PIC2_DATA, al

	ret

;edi: irq number
;returns: negative number on error, 0x20 on success
sendEOI_pic32:
global sendEOI_pic32:function
	cmp edi, 0x16
	jae .errorRet
	cmp edi, 0x8
	mov al, PIC_EOI
	jae .handleSlaveIrq
.end:
	out PIC1_COMMAND, al
	ret
.handleSlaveIrq:
	out PIC2_COMMAND, al
	jmp .end
.errorRet:
	mov eax, -1
	ret


bits 64

;rdi: mask master
;rsi: mask slave
mask_pic64:
global mask_pic64:function
	cli
	mov ax, di
	out PIC1_DATA, al
	mov ax, si
	out PIC2_DATA, al
	sti
	ret

;rdi: irq number
maskout_irq_pic64:
global maskout_irq_pic64:function
	cli
	cmp rdi, 16
	jae .error
	cmp rdi, 8
	jae .slaveHandle

	mov cl, dil
	mov ah, 1
	shl ah, cl
	in al, PIC1_DATA
	or ah, al
	mov al, ah
	out PIC1_DATA, al

	sti
	ret
.slaveHandle:
	sub rdi, 8
	mov cl, dil
	mov ah, 1
	shl ah, cl
	in al, PIC2_DATA
	or ah, al
	mov al, ah
	out PIC1_DATA, al

	sti
	ret
.error:
	sti
	ret
;rdi: irq number
maskin_irq_pic64:
global maskin_irq_pic64:function
	cli
	cmp rdi, 16
	jae .error
	cmp rdi, 8
	jae .slaveHandle

	mov cl, dil
	mov ah, 1
	shl ah, cl
	not ah
	in al, PIC1_DATA
	and ah, al
	mov al, ah
	out PIC1_DATA, al

	sti
	ret
.slaveHandle:
	sub rdi, 8
	mov cl, dil
	mov ah, 1
	shl ah, cl
	not ah
	in al, PIC2_DATA
	and ah, al
	mov al, ah
	out PIC1_DATA, al
	sti
	ret
.error:
	sti
	ret

;keeps interrupts disabled
remap_pic64:
global remap_pic64:function
	cli
	in al, PIC1_DATA
	mov dl, al
	in al, PIC2_DATA
	mov dh, al

	mov al, ICW1_INIT | ICW1_ICW4
	out PIC1_COMMAND, al

	mov al, ICW1_INIT | ICW1_ICW4
	out PIC2_COMMAND, al

	mov al, dil
	out PIC1_DATA, al

	mov al, sil
	out PIC2_DATA, al

	mov al, 4
	out PIC1_DATA, al

	mov al, 2
	out PIC2_DATA, al

	mov al, ICW4_8086
	out PIC1_DATA, al

	mov al, ICW4_8086
	out PIC2_DATA, al

	mov al, dl
	out PIC1_DATA, al

	mov al, dh
	out PIC2_DATA, al

	ret

;rdi: irq number
;returns: negative number on error, 0x20 on success
sendEOI_pic64:
global sendEOI_pic64:function
	cmp rdi, 0x16
	jae .errorRet
	cmp rdi, 0x8
	mov al, PIC_EOI
	jae .handleSlaveIrq
.end:
	out PIC1_COMMAND, al
	ret
	.handleSlaveIrq:
		out PIC2_COMMAND, al
		jmp .end
	.errorRet:
		mov rax, -1
	ret
