bits    64

%include "main/main.inc"

section .data

%define TEXT_BUFFER_LEN 4096

text_buffer:
static text_buffer:
	times TEXT_BUFFER_LEN db 0

var(static, uint64_t, text_index, 0)

section      .rodata

string(static, ArcadOSTitle, "ArcadOS", 0)

section      .text

; void main_update(void);
func(static, main_update)
	sub rsp, 8 ; to re-align the stack

	call PS2KB_update ; PS2KB_update();

	call update_kb_buffer ; update_kb_buffer();

	add rsp, 8 ; to re-align the stack
	ret

; void main_display(void);
func(static, main_display)
	sub rsp, 8 ; to re-align the stack

	mov  dil, 0x02
	call clear_screen ; green screen

	call display_kb_buffer ; display_kb_buffer();

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

	; Activating timer
		mov  rdi, 0
		call maskin_irq_pic64

	; Setting up the display buffer
		mov  rdi, VGA_MEMORY_ADDR
		call set_display_buffer   ; set_display_buffer(VGA_MEMORY_ADDR);

	.main_loop:
		call main_update
		call main_display

		.waitForFrameTime:
			mov  rdi, 16
			shl  rdi, 32  ; literal 16 as 32.32 fixed point
			call sleep_ms ; sleep_ms(16.0);

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

	jmp .skipBackspace

	.handle_backspace:
		; if (!text_index) goto skip_handle_backspace;
		mov rdi, uint64_p [text_index]
		cmp rdi, 0
		je  .skipBackspace

		; text_buffer[--text_index] = '\0';
		dec qword[text_index]
		mov byte [text_buffer + rdi], 0

	.skipBackspace:

	add rsp, 8 ; to re-align the stack
	ret

; void display_kb_buffer(void);
func(static, display_kb_buffer)
	sub rsp, 8 ; to re-align the stack

	lea  rdi, [text_buffer]
	xor  rsi, rsi
	xor  rdx, rdx
	call draw_text_and_shadow

	add rsp, 8 ; to re-align the stack
	ret
