bits 64

%include "keyboard.inc"
%include "pic.inc"

section .bss
scancode: resd 1
global scancode:data

section .text

initPS2:

	;step 1 and 2 skipped because i'm lazy

	call waitForSending

	mov al, 0xAD
	out PS2_COMMAND, al

	call waitForSending

	mov al, 0xA7
	out PS2_COMMAND, al

	call waitForResponse

	in al, PS2_DATA

	call waitForSending

	mov al, 0xAA
	out PS2_COMMAND, al

	call waitForResponse

	in al, PS2_DATA

	call waitForSending

	mov al, 0x20
	out PS2_COMMAND, al

	call waitForResponse

	in al, PS2_DATA

	and al, ~((1 << 0) | (1 << 4) | (1 << 6))
	mov ah, al

	call waitForSending

	mov al, 0x60
	out PS2_COMMAND, al

	call waitForSending

	mov ah, al
	out PS2_DATA, al

	call waitForSending

	mov al, 0xAA
	out PS2_COMMAND, al

	call waitForResponse

	in al, PS2_DATA
	cmp al, 0x55
.fail:	jne .fail

	call waitForSending

	;step 7 and 8 skip because i'm lazy
	mov al, 0xAE
	out PS2_COMMAND, al

	call waitForSending

	mov al, 0x60
	out PS2_COMMAND, al

	call waitForSending
	out PS2_COMMAND, al

	or ah, (1 << 0)
	mov al, ah
	out PS2_DATA, al

	call waitForSending

	mov al, 0xFF
	out PS2_COMMAND, al

	call waitForResponse



	ret

waitForResponse:
	in al, PS2_STATUS
	and al, (1 << 0)
	jz waitForResponse
	ret

waitForSending:
	in al, PS2_STATUS
	and al, (1 << 1)
	jnz waitForSending
	ret

;rdi: byte
sendBytePS2:

keyboardSetScancodeTable:
global keyboardSetScancodeTable:function
	mov rdi, 0xFF
	mov rsi, 0xFF
	call mask_pic64

	call waitForSending

	mov al, 0xF0
	out PS2_DATA, al

	call waitForSending

	mov al, 2
	out PS2_DATA, al

	call waitForResponse

	in al, PS2_DATA
	cmp al, 0xFE
	je keyboardSetScancodeTable

	cmp al, 0xFF
	je $
	cmp al, 0x00
	je $

	mov rdi, 0xFD
	mov rsi, 0xFD
	call mask_pic64
	ret

;rax: scancode with byte 1 being MSB, and byte 3 being LSB
keyboardRead:
global keyboardRead:function
	xor rax, rax
	in al, PS2_DATA
	shl rax, 8
	in al, PS2_STATUS
	and al, (1 << 0)
	je .end
	in al, PS2_DATA
	shl rax, 8
	in al, PS2_STATUS
	and al, (1 << 0)
	je .end
	in al, PS2_DATA
.end:
	mov [scancode], eax
	ret

keyboardFlushBuffer:
global keyboardFlushBuffer:function
	in al, PS2_STATUS
	and al, (1 << 0)
	je .end
	in al, PS2_DATA
	jmp keyboardFlushBuffer
.end:
	ret
