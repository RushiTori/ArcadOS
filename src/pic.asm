%include "pic.inc"

bits 32

;edi: mask master
;esi: mask slave
mask_pic32:
global mask_pic32:function
	mov ax, di
	out PIC1_DATA, al
	mov ax, si
	out PIC2_DATA, al
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
	mov al, PIC_EOI
	cmp edi, 0x8
	jae .handleSlaveIrq
	out PIC1_COMMAND, al
	ret
.handleSlaveIrq:
	out PIC2_COMMAND, al
	ret
.errorRet:
	mov eax, -1
	ret


bits 64

;rdi: mask master
;rsi: mask slave
mask_pic64:
global mask_pic64:function
	mov ax, di
	out PIC1_DATA, al
	mov ax, si
	out PIC2_DATA, al
	ret

remap_pic64:
global remap_pic64:function
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
	mov al, PIC_EOI
	cmp rdi, 0x8
	jae .handleSlaveIrq
	out PIC1_COMMAND, al
	ret
.handleSlaveIrq:
	out PIC2_COMMAND, al
	ret
.errorRet:
	mov rax, -1
	ret
