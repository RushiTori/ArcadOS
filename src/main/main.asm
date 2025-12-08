bits    64
default rel

%include "main/main.inc"

%define TITLE_COLOR_OFFSET 0x38

section .data

%define TEXT_BUFFER_LEN 1024

text_buffer:
static text_buffer: data
	times TEXT_BUFFER_LEN db 0

var(static, uint64_t, text_index, 0)

title_pos:
static title_pos: data
	istruc ScreenVec2
		at ScreenVec2.x, .x: dw 8
		at ScreenVec2.y, .y: dw 8
	iend

title_vel:
static title_vel: data
	istruc ScreenVec2
		at ScreenVec2.x, .x: dw 4
		at ScreenVec2.y, .y: dw 4
	iend

var(static, uint8_t, title_main_color, 0)
var(static, uint8_t, title_shadow_color, 0)
var(static, uint8_t, title_back_color, 0)

var(static, bool_t, title_manual, false)

section .rodata

string(static, ArcadOSTitle, "ArcadOS", 0)

section .text

; Had to implement it with PS2KB_get_char because PS2KB_is_key_pressed never worked for some reason
; Tried with arrow keys at first
; Tried with PS2KB_is_key_down, but it was false for half a second, then true for 1 frame then false until released and pressed again
%macro check_for_key_pressed_and_do 3
	cmp al, %1
	jne %%skip_action
		%2, %3
	%%skip_action:
%endmacro

; void main_update(void);
func(static, main_update)
	sub rsp, 8 ; to re-align the stack

	call PS2KB_update ; PS2KB_update();

	call PS2KB_get_char

	check_for_key_pressed_and_do ' ', xor bool_p [title_manual], 1

	cmp bool_p [title_manual], false
	je  .auto_move

	.manual_move:
		check_for_key_pressed_and_do 'z', sub uint16_p [title_pos.y], 4
		check_for_key_pressed_and_do 's', add uint16_p [title_pos.y], 4
		check_for_key_pressed_and_do 'q', sub uint16_p [title_pos.x], 4
		check_for_key_pressed_and_do 'd', add uint16_p [title_pos.x], 4
	.skip_manual_move:
	jmp .skip_auto_move

	.auto_move:
		mov ax, uint16_p [title_pos.x]
		add ax, uint16_p [title_vel.x]

		mov uint16_p [title_pos.x], ax

		cmp ax, 0
		je  .flip_vel_x

		cmp ax, 320 - sizeof(ArcadOSTitle) * 8
		jne .skip_flip_vel_x

		.flip_vel_x:
			neg uint16_p [title_vel.x]
		.skip_flip_vel_x:

		mov ax, uint16_p [title_pos.y]
		add ax, uint16_p [title_vel.y]

		mov uint16_p [title_pos.y], ax

		cmp ax, 0
		je  .flip_vel_y

		cmp ax, 200 - 2 * 8
		jne .skip_flip_vel_y

		.flip_vel_y:
		neg uint16_p [title_vel.y]
		.skip_flip_vel_y:
	.skip_auto_move:

	mov cl, uint8_p [title_main_color]
	inc cl
	and cl, 31

	add cl,                           TITLE_COLOR_OFFSET
	mov uint8_p [title_main_color],   cl
	add cl,                           0x48
	mov uint8_p [title_shadow_color], cl
	add cl,                           0x48
	mov uint8_p [title_back_color],   cl


	call update_kb_buffer ; update_kb_buffer();

	add rsp, 8 ; to re-align the stack
	ret

; void main_display(void);
func(static, main_display)
	sub rsp, 8 ; to re-align the stack

	mov  dil, 0xFF
	call clear_screen_c

	call display_kb_buffer ; display_kb_buffer();

	mov  dil, 0x12
	call set_display_color

	mov  di, uint16_p [title_pos.x]
	mov  si, uint16_p [title_pos.y]
	mov  dx, (sizeof(ArcadOSTitle)) * 8
	mov  cx, 16
	call draw_rect


	lea  rdi, [ArcadOSTitle]
	mov  si,  uint16_p [title_pos.x]
	add  si,  4
	mov  dx,  uint16_p [title_pos.y]
	add  dx,  4
	mov  cl,  uint8_p [title_main_color]
	mov  r8b, uint8_p [title_shadow_color]
	mov  r9b, uint8_p [title_back_color]
	call draw_text_all_c

	add rsp, 8 ; to re-align the stack
	ret

func(global, main)
	; Setting up the xmm registers and flloat instructions
		mov rax, cr0
		and ax,  0xFFFB ;clear coprocessor emulation CR0.EM
		or  ax,  0x2    ;set coprocessor monitoring  CR0.MP
		mov cr0, rax
		mov rax, cr4
		or  ax,  3 << 9 ;set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
		mov cr4, rax


		call start_snake

	.main_loop:
		call main_update
		call main_display

		; mov  rdi, 1024       ; 1 second in rtc_ticks
		; call rtc_sleep_ticks

		mov  rdi, 0              ; seconds
		shl  rdi, 32
		add  rdi, 10 * 1_000_000 ; milliseconds
		add  rdi, 0 * 1_000      ; microseconds
		add  rdi, 0 * 1          ; nanoseconds
		call rtc_sleep

		jmp .main_loop

; void update_kb_buffer(void);
func(static, update_kb_buffer)
	sub rsp, 8 ; to re-align the stack

	.add_to_buffer_loop:
		call PS2KB_get_char          ; PS2KB_get_char();
		cmp  rax, -1
		je   .add_to_buffer_loop_end ; if (PS2KB_get_char() == EOF) break;

		; if (text_index >= TEXT_BUFFER_LEN) break;
		mov rdi,                   uint64_p [text_index]
		cmp uint64_p [text_index], TEXT_BUFFER_LEN
		jge .add_to_buffer_loop_end

		; text_buffer[text_index++] = PS2KB_get_char();
		mov uint8_p [text_buffer + rdi], al
		inc uint64_p [text_index]

		jmp .add_to_buffer_loop
	.add_to_buffer_loop_end:

	mov  rdi, KEY_BACKSPACE
	call PS2KB_is_key_pressed ; PS2KB_is_key_pressed(KEY_BACKSPACE);
	cmp  rax, true
	je   .handle_backspace

	mov  rdi, KEY_BACKSPACE
	call PS2KB_is_key_pressed_typematic ; PS2KB_is_key_pressed_typematic(KEY_BACKSPACE);
	cmp  rax, true
	je   .handle_backspace

	jmp .skip_handle_backspace

	.handle_backspace:
		; if (!text_index) goto skip_handle_backspace;
		mov rdi, uint64_p [text_index]
		cmp rdi, 0
		je  .skip_handle_backspace

		; text_buffer[--text_index] = '\0';
		dec uint64_p [text_index]
		mov al,                              uint8_p [text_buffer + rdi]
		mov uint8_p [text_buffer + rdi - 1], 0

	.skip_handle_backspace:

	add rsp, 8 ; to re-align the stack
	ret

; void display_kb_buffer(void);
func(static, display_kb_buffer)
	sub rsp, 8 ; to re-align the stack

	lea  rdi, [text_buffer]
	xor  rsi, rsi
	call draw_text_and_shadow_vec

	add rsp, 8 ; to re-align the stack
	ret
