bits 64

%include "engine/keyboard.inc"
%include "bootloader/pic.inc"

%define KEY_STATE_PRESSED  1
%define KEY_STATE_DOWN     2
%define KEY_STATE_RELEASED 3
%define KEY_STATE_UP       4

section .rodata

keymap:
static keymap:data
	; unused	row		column	
	; b			bbb		bbbb
	;
	;
	;  press   release
	dq 0x0076, 0xF076	;escape:						0
	dq 0x0005, 0xF005	;F1:							1
	dq 0x0006, 0xF006	;F2:							2
	dq 0x0004, 0xF004	;F3:							3
	dq 0x000C, 0xF00C	;F4:							4
	dq 0x0005, 0xF005	;F5:							5
	dq 0x000B, 0xF00B	;F6:							6
	dq 0x0083, 0xF083	;F7:							7
	dq 0x000A, 0xF00A	;F8:							8
	dq 0x0001, 0xF001	;F9:							9
	dq 0x0009, 0xF009	;F10:							10
	dq 0x0078, 0xF078	;F11:							11
	dq 0x0007, 0xF007	;F12:							12
	dq 0xE070, 0xE0F070	;insert:						13
	dq 0xE071, 0xE0F071	;delete:						14
	dq 0x0000, 0x0000	;unused							15

	dq 0x000E, 0xF00E	;square symbol:					16
	dq 0x0016, 0xF016 	;one:							17
	dq 0x001E, 0xF01E 	;two:							18
	dq 0x0026, 0xF026 	;three:							19
	dq 0x0025, 0xF025 	;four:							20
	dq 0x002E, 0xF02E 	;five:							21
	dq 0x0036, 0xF036 	;six:							22
	dq 0x003D, 0xF03D 	;seven:							23
	dq 0x003E, 0xF03E 	;eight:							24
	dq 0x0046, 0xF046 	;nine:							25
	dq 0x0045, 0xF045 	;zero:							26
	dq 0x004E, 0xF04E 	;end parenthesis:				27
	dq 0x0055, 0xF055 	;equal sign:					28
	dq 0x0066, 0xF066 	;backspace:						29
	dq 0x0000, 0x0000	;unused							30
	dq 0x0000, 0x0000	;unused							31
	
	dq 0x000D, 0xF00D	;tab:							32
	dq 0x0016, 0xF016	;A:								33
	dq 0x001D, 0xF01D	;Z:								34
	dq 0x0025, 0xF025	;E:								35
	dq 0x002D, 0xF02D	;R:								36
	dq 0x002C, 0xF02C	;T:								37
	dq 0x0035, 0xF035	;Y:								38
	dq 0x003C, 0xF03C	;U:								39
	dq 0x0043, 0xF043	;I:								40
	dq 0x0044, 0xF044	;O:								41
	dq 0x004D, 0xF04D	;P:								42
	dq 0x0054, 0xF054	;caret:							43
	dq 0x005B, 0xF05B	;dollar sign:					44
	dq 0x005A, 0xF05A	;enter:							45
	dq 0x0000, 0x0000	;unused							46
	dq 0x0000, 0x0000	;unused							47

	dq 0x0058, 0xF058	;caps lock:						48
	dq 0x001C, 0xF01C	;Q:								49
	dq 0x001B, 0xF01B	;S:								50
	dq 0x0023, 0xF023	;D:								51
	dq 0x002B, 0xF02B	;F:								52
	dq 0x0034, 0xF034	;G:								53
	dq 0x0033, 0xF033	;H:								54
	dq 0x003B, 0xF03B	;J:								55
	dq 0x0042, 0xF042	;K:								56
	dq 0x004B, 0xF04B	;L:								57
	dq 0x004C, 0xF04C	;M:								58
	dq 0x0052, 0xF052	;u with accent pointing right:	59
	dq 0x005D, 0xF05D	;asterisk:						60
	dq 0x0000, 0x0000	;unused							61
	dq 0x0000, 0x0000	;unused							62
	dq 0x0000, 0x0000	;unused							63
	
	dq 0x0012, 0xF012	;left shift:					64
	dq 0x0061, 0xF061	;lower than:					65
	dq 0x001A, 0xF01A	;W:								66
	dq 0x0022, 0xF022	;X:								67
	dq 0x0021, 0xF021	;C:								68
	dq 0x002A, 0xF02A	;V:								69
	dq 0x0032, 0xF032	;B:								70
	dq 0x0031, 0xF032	;N:								71
	dq 0x003A, 0xF03A	;comma:							72
	dq 0x0041, 0xF041	;semicolon:						73
	dq 0x0049, 0xF049	;colon:							74
	dq 0x004A, 0xF04A	;exclamation mark:				75
	dq 0x005A, 0xF05A	;right shift:					76
	dq 0x0000, 0x0000	;unused							77
	dq 0x0000, 0x0000	;unused							78
	dq 0x0000, 0x0000	;unused							79

	dq 0x0014, 0xF014	;left ctrl:						80
	dq 0, 0				;left fn not mapped
	dq 0, 0				;win not mapped
	dq 0, 0				;alt not mapped
	dq 0x0029, 0xF029	;space bar:						84
	dq 0, 0				;alt gr not mapped
	dq 0, 0				;right fn not mapped
	dq 0xE014, 0xE0F014	;right control:					87
	dq 0xE075, 0xE0F075	;UP:							88
	dq 0xE072, 0xE0F072	;DOWN:							89
	dq 0xE06B, 0xE0F06B	;LEFT:							90
	dq 0xE074, 0xE0F074	;RIGHT:							91

section .bss

scancode_complete:
global scancode_complete:data
	resb 1

scancode:
global scancode:data
	resq 1

IRQ_key_states:
static IRQ_key_states:data
	times KEY_COUNT resb 1

key_states:
static key_states:data
	times KEY_COUNT resb 1

section .text

initPS2:
global initPS2:function
	;step 1 and 2 skipped because i'm lazy

	call waitForSending

	mov al, 0xAD
	out PS2_COMMAND, al

	call waitForSending

	mov al, 0xA7
	out PS2_COMMAND, al

	call waitForSending

	call keyboardFlushBuffer

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

	.key_repeat_loop:
		mov al, 0xF3
		out PS2_DATA, al
		call waitForSending
		xor al, al
		out PS2_DATA, al
		call waitForResponse
		in al, PS2_DATA
		cmp al, 0xFE
		je .key_repeat_loop

	ret

waitForResponse:
static waitForResponse:function
	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	jz waitForResponse
	ret

waitForSending:
static waitForSending:function
	in al, PS2_STATUS
	and al, PS2_STATUS_OUTPUT_BUFFER_FULL
	jnz waitForSending
	ret

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

	cmp byte[scancode_complete], false
	je .skipResetScancode
	mov qword[scancode], false
	.skipResetScancode:

	in al, PS2_DATA
	cmp al, 0xFA
	je .endRead

	mov rcx, qword[scancode]
	shl rcx, 8
	or rax, rcx
	mov qword[scancode], rax

	cmp al, 0xE0
	je .awaitNextKeyState
	cmp al, 0xF0
	je .awaitNextKeyState

	mov byte[scancode_complete], true
	call update_keyboard_handler_IRQ
	jmp .endRead

	.awaitNextKeyState:
		mov byte[scancode_complete], false
	.endRead:
	
	ret

;rdi: scancode
;return al: keycode, ah: isReleased
keyboardScancodeToKeycode:
static keyboardScancodeToKeycode:function
	xor rcx, rcx
	.lookup_loop:
		cmp rdi, qword[keymap + rcx * 8]
		je .end
		inc rcx
		cmp rcx, 256
		jae .end
		jmp .lookup_loop
	.end:
	mov rax, rcx
	shr rax, 1

	and rcx, 1
	mov ah, cl

	ret

keyboardFlushBuffer:
static keyboardFlushBuffer:function
	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	je .end
	in al, PS2_DATA
	jmp keyboardFlushBuffer
	.end:
	ret

update_keyboard_handler_IRQ:
static update_keyboard_handler_IRQ:function
	mov rdi, qword[scancode]
	call keyboardScancodeToKeycode
	cmp al, KEY_COUNT
	jge .end

	inc ah
	movzx rdi, al
	mov byte[IRQ_key_states + rdi], ah

	.end:
	ret

update_keyboard_handler:
global update_keyboard_handler:function
	; WIP
	mov rdi, 1
	call maskout_irq_pic64

	xor rdi, rdi
	mov rcx, KEY_COUNT
	.update_loop:
		mov al, byte[IRQ_key_states + rdi]
		cmp al, 0
		je .continue_update_loop
		dec al

		cmp al, true
		je .handleReleased
		.handlePressed:
			cmp byte[key_states + rdi], KEY_STATE_DOWN
			jg .put_state_pressed

			.put_state_down:
			mov byte[key_states + rdi], KEY_STATE_DOWN
			jmp .continue_update_loop

			.put_state_pressed:
			mov byte[key_states + rdi], KEY_STATE_PRESSED
			jmp .continue_update_loop

		.handleReleased:
			cmp byte[key_states + rdi], KEY_STATE_DOWN
			jg .put_state_pressed

			.put_state_released:
			mov byte[key_states + rdi], KEY_STATE_RELEASED
			jmp .continue_update_loop

			.put_state_up:
			mov byte[key_states + rdi], KEY_STATE_UP
		; Logic to translate
		;	if (isPressed) {
		;		if (state == InputState::Pressed)
		;			state = InputState::Down;
		;		else if (state == InputState::Released || state == InputState::Up)
		;			state = InputState::Pressed;
		;	} else {
		;		if (state == InputState::Released)
		;			state = InputState::Up;
		;		else if (state == InputState::Pressed || state == InputState::Down)
		;			state = InputState::Released;
		;	}

		.continue_update_loop:
		mov byte[IRQ_key_states + rdi], 0
		inc rdi
		loop .update_loop

	mov rdi, 1
	call maskin_irq_pic64
	ret

; args : u8 keycode
; returns : true if 'keycode' is pressed, otherwise false.
is_key_pressed:
global is_key_pressed:function
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_PRESSED
	jne .end
	inc rax

	.end:
	ret

; args : u8 keycode
; returns : true if 'keycode' is down, otherwise false.
is_key_down:
global is_key_down:function
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_DOWN
	jne .end
	inc rax

	.end:
	ret

; args : u8 keycode
; returns : true if 'keycode' is released, otherwise false.
is_key_released:
global is_key_released:function
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_RELEASED
	jne .end
	inc rax

	.end:
	ret

; args : u8 keycode
; returns : true if 'keycode' is up, otherwise false.
is_key_up:
global is_key_up:function
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_UP
	jne .end
	inc rax
	
	.end:
	ret
