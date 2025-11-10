bits 64

%include "string.inc"

%include "engine/PS2keyboard.inc"
%include "engine/PS2.inc"
%include "bootloader/pic.inc"

%define KEY_STATE_UNKNOWN  0
%define KEY_STATE_PRESSED  1
%define KEY_STATE_DOWN     2
%define KEY_STATE_RELEASED 3
%define KEY_STATE_UP       4
%define KEY_STATE_TYPEMATIC_PRESSED 5

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
	dq 0x0015, 0xF015	;A:								33
	dq 0x001D, 0xF01D	;Z:								34
	dq 0x0024, 0xF024	;E:								35
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
	dq 0x0031, 0xF031	;N:								71
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
	dq 0x0011, 0xF011	;alt							83
	dq 0x0029, 0xF029	;space bar:						84
	dq 0xE011, 0xE0F011	;alt gr							85
	dq 0, 0				;right fn not mapped
	dq 0xE014, 0xE0F014	;right control:					87
	dq 0xE075, 0xE0F075	;UP:							88
	dq 0xE072, 0xE0F072	;DOWN:							89
	dq 0xE06B, 0xE0F06B	;LEFT:							90
	dq 0xE074, 0xE0F074	;RIGHT:							91

key_to_char:
	db 0	;escape:						0
	db 0	;F1:							1
	db 0	;F2:							2
	db 0	;F3:							3
	db 0	;F4:							4
	db 0	;F5:							5
	db 0	;F6:							6
	db 0	;F7:							7
	db 0	;F8:							8
	db 0	;F9:							9
	db 0	;F10:							10
	db 0	;F11:							11
	db 0	;F12:							12
	db 0	;insert:						13
	db 0	;delete:						14
	db 0	;unused							15

	db 0	;square symbol:					16
	db '&' 	;one:							17
	db '2' 	;two:							18
	db 0x22 ;three:							19
	db 0x27	;four:							20
	db '(' 	;five:							21
	db '-' 	;six:							22
	db '7' 	;seven:							23
	db '_' 	;eight:							24
	db '9' 	;nine:							25
	db '0' 	;zero:							26
	db ')' 	;end parenthesis:				27
	db '=' 	;equal sign:					28
	db 0	;backspace:						29
	db 0	;unused							30
	db 0	;unused							31
	
	db 0x9	;tab:							32
	db 'a'	;A:								33
	db 'z'	;Z:								34
	db 'e'	;E:								35
	db 'r'	;R:								36
	db 't'	;T:								37
	db 'y'	;Y:								38
	db 'u'	;U:								39
	db 'i'	;I:								40
	db 'o'	;O:								41
	db 'p'	;P:								42
	db '^'	;caret:							43
	db '$'	;dollar sign:					44
	db 0xA	;enter:							45
	db 0	;unused							46
	db 0	;unused							47

	db 0	;caps lock:						48
	db 'q'	;Q:								49
	db 's'	;S:								50
	db 'd'	;D:								51
	db 'f'	;F:								52
	db 'g'	;G:								53
	db 'h'	;H:								54
	db 'j'	;J:								55
	db 'k'	;K:								56
	db 'l'	;L:								57
	db 'm'	;M:								58
	db '%'	;u with accent pointing right:	59   replaced with % since % is in the ascii table
	db '*'	;asterisk:						60
	db 0	;unused							61
	db 0	;unused							62
	db 0	;unused							63
	
	db 0	;left shift:					64
	db '<'	;lower than:					65
	db 'w'	;W:								66
	db 'x'	;X:								67
	db 'c'	;C:								68
	db 'v'	;V:								69
	db 'b'	;B:								70
	db 'n'	;N:								71
	db ','	;comma:							72
	db ';'	;semicolon:						73
	db ':'	;colon:							74
	db '!'	;exclamation mark:				75
	db 0	;right shift:					76
	db 0	;unused							77
	db 0	;unused							78
	db 0	;unused							79

	db 0	;left ctrl:						80
	db 0	;left fn not mapped
	db 0	;win not mapped
	db 0	;alt							83
	db ' '	;space bar:						84
	db 0	;alt gr							85
	db 0	;right fn not mapped
	db 0	;right control:					87
	db 0	;UP:							88
	db 0	;DOWN:							89
	db 0	;LEFT:							90
	db 0	;RIGHT:							91

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

char_buffer:
static char_buffer:data
	times CHAR_BUFFER_SIZE resb 1
char_buffer_idx:
static char_buffer_idx:data
	resq 1

isScrollLocked:
static isScrollLocked:data
	resb 1

isCapsLocked:
static isCapsLocked:data
	resb 1

isNumpadLocked:
static isNumpadLocked:data
	resb 1

section .text

waitForResponseKeyboard:
static waitForResponse:function
	in al, PS2_STATUS
	and al, PS2_STATUS_INPUT_BUFFER_FULL
	jz waitForResponseKeyboard
	ret

waitForSendingKeyboard:
static waitForSending:function
	in al, PS2_STATUS
	and al, PS2_STATUS_OUTPUT_BUFFER_FULL
	jnz waitForSendingKeyboard
	ret

;masks all interrupt
keyboardInit:
global keyboardSetScancodeTable:function
	mov rdi, 0xFE
	mov rsi, 0xFE
	call mask_pic64

	mov rdi, KB_COMMAND_GET_SET_SCANCODE_SET
	call PS2SendCommandToPort1

	mov rdi, 2 ;set 2
	call PS2SendCommandToPort1

	mov al, false
	mov [isScrollLocked], al
	mov [isCapsLocked], al
	mov [isNumpadLocked], al

	mov rcx, KEY_COUNT

	.clearKeys:
		mov byte [key_states + rcx - 1], KEY_STATE_UP
		mov byte [IRQ_key_states + rcx - 1], KEY_STATE_UNKNOWN
		loop .clearKeys


	mov rdi, 0xFF
	mov rsi, 0xFF
	call mask_pic64

	mov rdi, KB_COMMAND_SET_TYPEMATIC_RATE_DELAY
	call PS2SendCommandToPort1
	cmp rax, -1
	je .end

			  ;z_dd_rrrrr where z must be zero, d is delay in a range of 250 to 1000ms (0 is 250ms) (included on both ends), and rrrrr is a repeat rate, from 2 Hz to 30Hz (0 is 30Hz) (included on both ends)
	mov rdi, 0b0_01_00000 ;here 500 ms with a repeat rate of 30Hz, sounds good
	call PS2SendCommandToPort1
	cmp rax, -1
	je .end

.end:
	ret

.error:
	jmp $

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
		cmp rcx, KEY_COUNT * 2 ;multiply by 2 because there's pressed key and released key for scancodes
		jae .end
		jmp .lookup_loop
	.end:
	mov rax, rcx
	shr rax, 1

	and rcx, 1
	mov ah, cl

	ret

;rdi: keycode
;return 
keyboardKeycodeToChar:
static keyboardKeycodeToChar:function
	movzx rax, byte[key_to_char + rdi]
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

	cmp ah, false
	je .writepress
	.writerelease:
		movzx rdi, al
		mov byte[IRQ_key_states + rdi], KEY_STATE_RELEASED
		jmp .end
	.writepress:
		movzx rdi, al
		mov byte[IRQ_key_states + rdi], KEY_STATE_PRESSED
	

	cmp rdi, KEY_CAPS_LOCK
	jne .skipCapsLockHandling

	xor byte [isCapsLocked], 1
	call keyboardUpdateLEDs
.skipCapsLockHandling:

	;rdi already holds keycode
	call keyboardKeycodeToChar
	cmp rax, 0
	je .skipTextWrite
	mov rsi, [char_buffer_idx]
	cmp rsi, CHAR_BUFFER_SIZE - 1
	jge .skipTextWrite
	mov byte [char_buffer + rsi], al
	inc qword [char_buffer_idx]
.skipTextWrite:

	.end:
	ret

keyboardUpdateLEDs:
	mov dil, 0xED
	call PS2SendCommandToPort1KB
	cmp rax, -1
	je .error

	;cns where n is numpad lock, c is caps lock, and s is scroll lock
	mov al, byte [isScrollLocked]
	mov dil, al
	mov al, byte [isNumpadLocked]
	shl al, 1
	or dil, al
	mov al, byte [isCapsLocked]
	shl al, 2
	or dil, al
	call PS2SendCommandToPort1KB
	cmp rax, -1
	je .error

	ret

.error:
	jmp $
keyboard_char_buffer_flush:
	mov qword [char_buffer_idx], 0
	ret

keyboard_get_char:
	mov al, 0
	mov rsi, [char_buffer_idx]
	cmp rsi, 0
	mov rax, -1
	jz .end

	mov rdi, KEY_RIGHT_ALT
	call is_key_pressed
	mov rcx, rax

	mov rdi, KEY_RIGHT_ALT
	call is_key_down
	or rcx, rax
	cmp rcx, true
	je .altGrHandling

	mov rdi, KEY_LEFT_SHIFT
	call is_key_pressed
	mov rcx, rax

	mov rdi, KEY_LEFT_SHIFT
	call is_key_down
	or rcx, rax

	mov rdi, KEY_RIGHT_SHIFT
	call is_key_pressed
	or rcx, rax

	mov rdi, KEY_RIGHT_SHIFT
	call is_key_down
	or rcx, rax

	xor cl, byte [isCapsLocked]

	xor rax, rax
	mov al, [char_buffer]
	cmp al, 0
	je .end

	cmp cl, 0
	je .skipSpecialHandling

	cmp al, '<'
	jne .skipLowerThanHandling

	mov al, '>'
	jmp .skipSpecialHandling
.skipLowerThanHandling:

	cmp al, ','
	jne .skipCommaHandling

	mov al, '?'
	jmp .skipSpecialHandling

.skipCommaHandling:

	cmp al, ';'
	jne .skipSemicolonHandling

	mov al, '.'
	jmp .skipSpecialHandling

.skipSemicolonHandling:

	cmp al, ':'
	jne .skipColonHandling

	mov al, '/'
	jmp .skipSpecialHandling

.skipColonHandling:

	cmp al, '&'
	jne .skipAmpersandHandling

	mov al, '1'
	jmp .skipSpecialHandling
.skipAmpersandHandling:

	cmp al, 0x22
	jne .skipDquoteHandling

	mov al, '3'
	jmp .skipSpecialHandling
.skipDquoteHandling:

	cmp al, 0x27
	jne .skipApostropheHandling

	mov al, '4'
	jmp .skipSpecialHandling
.skipApostropheHandling:

	cmp al, '('
	jne .skipParenthesisStartHandling

	mov al, '5'
	jmp .skipSpecialHandling
.skipParenthesisStartHandling:

	cmp al, '-'
	jne .skipDashHandling

	mov al, '6'
	jmp .skipSpecialHandling
.skipDashHandling:

	cmp al, '_'
	jne .skipUnderscoreHandling

	mov al, '8'
	jmp .skipSpecialHandling
.skipUnderscoreHandling:

	cmp al, '='
	jne .skipEqualHandling

	mov al, '+'
	jmp .skipSpecialHandling

.skipEqualHandling:

	cmp al, 'a'
	jl .skipSpecialHandling

	cmp al, 'z'
	jg .skipSpecialHandling

	sub al, ('a' - 'A')
	jmp .skipSpecialHandling ;end of caps handling

.altGrHandling:
	xor rax, rax
	mov al, [char_buffer]

	cmp al, '2'
	jne .skipTwoHandling

	mov al, '~'
	jmp .skipSpecialHandling
.skipTwoHandling:
	cmp al, 0x22
	jne .skipAltDquoteHandling

	mov al, '#'
	jmp .skipSpecialHandling
.skipAltDquoteHandling:
	cmp al, 0x27
	jne .skipAltApostropheHandling

	mov al, '{'
	jmp .skipSpecialHandling
.skipAltApostropheHandling:
	cmp al, '('
	jne .skipAltParenthesisStartHandling

	mov al, '['
	jmp .skipSpecialHandling
.skipAltParenthesisStartHandling:
	cmp al, '-'
	jne .skipAltDashHandling

	mov al, '|'
	jmp .skipSpecialHandling
.skipAltDashHandling:
	cmp al, '7'
	jne .skipAltSevenHandling

	mov al, '`'
	jmp .skipSpecialHandling
.skipAltSevenHandling:
	cmp al, '_'
	jne .skipAltUnderscoreHandling

	mov al, '\'
	jmp .skipSpecialHandling
.skipAltUnderscoreHandling:
	cmp al, '9'
	jne .skipAltNineHandling

	mov al, '^'
	jmp .skipSpecialHandling
.skipAltNineHandling:
	cmp al, '0'
	jne .skipAltZeroHandling

	mov al, '@'
	jmp .skipSpecialHandling
.skipAltZeroHandling:
	cmp al, ')'
	jne .skipAltParenthesisEndHandling

	mov al, ']'
	jmp .skipSpecialHandling
.skipAltParenthesisEndHandling:
	cmp al, '='
	jne .skipAltEqualHandling

	mov al, '}'
.skipAltEqualHandling:
	;end of alt gr handling
.skipSpecialHandling:

	push rax

	mov rdi, char_buffer
	mov rdx, CHAR_BUFFER_SIZE
	sub rdx, rsi
	add rsi, char_buffer
	call memmove
	
	mov qword [char_buffer_idx], 0

	pop rax
.end:
	ret

update_keyboard_handler:
global update_keyboard_handler:function
	; WIP

	xor rdi, rdi
	mov rcx, KEY_COUNT
	.update_loop:
		mov al, byte[IRQ_key_states + rdi]
		cmp al, KEY_STATE_UNKNOWN
		je .update_key_status

		cmp al, KEY_STATE_RELEASED
		je .handleReleased
		.handlePressed:
			.put_state_pressed:
			cmp byte[key_states + rdi], KEY_STATE_DOWN
			je .put_state_typematic_pressed
			mov byte[key_states + rdi], KEY_STATE_PRESSED
			jmp .continue_update_loop

			.put_state_typematic_pressed:
			mov byte[key_states + rdi], KEY_STATE_TYPEMATIC_PRESSED
			jmp .continue_update_loop

		.handleReleased:
			.put_state_released:
			mov byte[key_states + rdi], KEY_STATE_RELEASED
			jmp .continue_update_loop

		.put_state_down:
			mov byte [key_states + rdi], KEY_STATE_DOWN
			jmp .continue_update_loop

		.put_state_up:
			mov byte [key_states + rdi], KEY_STATE_UP
			jmp .continue_update_loop

		.update_key_status:
			cmp byte[key_states + rdi], KEY_STATE_TYPEMATIC_PRESSED
			je .put_state_down
			cmp byte[key_states + rdi], KEY_STATE_PRESSED
			je .put_state_down
			cmp byte[key_states + rdi], KEY_STATE_RELEASED
			je .put_state_up
		.continue_update_loop:
		mov byte[IRQ_key_states + rdi], KEY_STATE_UNKNOWN
		inc rdi
		loop .update_loop

	ret
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
; returns : true if 'keycode' is typematic pressed, otherwise false.
is_key_pressed_typematic:
global is_key_pressed:function
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_TYPEMATIC_PRESSED
	jne .end
	inc rax

	.end:
	ret

; args : u8 keycode
; returns : true if 'keycode' is down, otherwise false. (note: typematic pressed state is included as down here, since it is still holding down the key physically)
is_key_down:
global is_key_down:function
	xor rax, rax
	cmp dil, KEY_COUNT
	jge .end

	and rdi, 0xFF
	mov dil, byte[key_states + rdi]

	cmp dil, KEY_STATE_TYPEMATIC_PRESSED
	je .end
	cmp dil, KEY_STATE_DOWN
	jne .end
.true:
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


PS2SendCommandToPort1KB:
	xor rcx, rcx
.resend:
	mov al, dil
	out PS2_DATA, al
	call waitForSendingKeyboard
	call waitForResponseKeyboard

	in al, PS2_DATA
	cmp al, RESPONSE_RESEND
	je .resend_handler
	cmp al, RESPONSE_ACK
	mov rax, 0
	je .end
	jmp .error
.resend_handler:
	inc rcx
	cmp rcx, 3
	jl .resend
	jmp .error
.end:
	ret
.error:
	jmp $