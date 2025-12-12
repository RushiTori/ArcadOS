%include "main/snake.inc"

%define FRAME_TIME 16666666
%define FRAME_PER_UPDATE 8

bits 64

section .bss

res(global, uint64_t, rand_val) ;temporary

res(global, uint64_t, snake_size) ;temporary

res(global, uint8_t, is_game_over) ;temporary

snake_dir:
global snake_dir:data
    .x:
        resb 1
    .y:
        resb 1

snake_pos:
global snake_pos:data
    resd SNAKE_MAX_LENGTH ;istruc ScreenVec2

fruit_pos:
global fruit_pos:data
    istruc ScreenVec2

section .rodata

gameover_text:
    db "game over!",0

section .text

;void srand(uint64_t seed)
func(static, srand)
    mov [rand_val], rdi
    ret

%define RAND_TAP_MASK      0b01000000000100000100000011010010
%define RAND_SHIFT_OUT_BIT 0b00000000000000000000000000000001

; screenvec2 vec_add(screenvec2 a, screenvec2 b)
func(static, vec_add)
	push rsi
	call screenvec2_unpack
	mov si, ax
	mov cx, dx
	pop rdi
	call screenvec2_unpack
	add ax, si
	add dx, cx
	mov di, ax
	mov si, dx
	call screenvec2_pack
	ret

;uint64_t rand(void)
func(static, rand)
    mov rdi, [rand_val]
    mov rsi, rdi
    mov rdx, rdi
    and rdx, RAND_SHIFT_OUT_BIT
    shr rdi, 1
    cmp rdx, 0
    je .end

    xor rdi, RAND_TAP_MASK
.end:
    mov [rand_val], rdi
    mov rax, rdi
    ret

;void init_snake(void)
func(static, init_snake)
    mov rdi, 0xFF
    call clear_screen_c

    call draw_board

    mov rdi, 0xFFFFFFFFFFFFFFFF
    call srand
    ret

func(static, setup_snake)
    .waitForStart:
        call PS2KB_update

        mov rdi, FRAME_TIME ;16.666666 milliseconds
        call rtc_sleep

        call rand

        ;press a key to finish setup

        call PS2KB_is_any_key_pressed
        cmp rax, true
        je .endWait

        jmp .waitForStart
    .endWait:
    
    mov uint64_p [snake_size], 1
    mov uint8_p [is_game_over], false
    mov uint16_p [snake_dir], 0

    ;get initial snake position
    call rand
    
    xor rdx, rdx
    mov rbx, (SCREEN_WIDTH/SCREEN_TILE_SIZE)
    div rbx
    push dx

    call rand
    
    xor rdx, rdx
    mov rbx, (SCREEN_HEIGHT/SCREEN_TILE_SIZE)
    div rbx
    
    xor rdi, rdi
    xor rsi, rsi
    pop di
    mov si, dx
    call screenvec2_pack

    mov ScreenVec2 [snake_pos], eax

    call generate_fruit
    ret

func(static, draw_board)
    mov rdi, VGA_BLACK
    call clear_screen_c
    ret


func(static, draw_snake)
    call draw_board

    mov rdi, VGA_GREEN
    call set_display_color

    mov rcx, [snake_size]
    .draw_snake_loop:
        push rcx

        mov edi, ScreenVec2 [snake_pos + rcx * 4 - 4]
        call screenvec2_tile_to_screen

        mov rdi, rax
        mov rsi, SCREEN_TILE_SIZE
        call draw_square_vec

        pop rcx
        loop .draw_snake_loop

    mov rdi, VGA_RED
    call set_display_color

    mov edi, ScreenVec2 [fruit_pos]
    call screenvec2_tile_to_screen

    mov edi, eax
    mov rsi, SCREEN_TILE_SIZE
    call draw_square_vec

    ret

func(static, generate_fruit)
    .regen:
        call rand
        
        xor rdx, rdx
        mov rbx, (SCREEN_WIDTH/SCREEN_TILE_SIZE)
        div rbx

        push dx

        call rand

        xor rdx, rdx
        mov rbx, (SCREEN_HEIGHT/SCREEN_TILE_SIZE)
        div rbx

        xor rsi, rsi
        xor rdi, rdi
        pop di
        mov si, dx
        call screenvec2_pack
    
        mov rcx, [snake_size]
        .snake_compare_loop:
            cmp eax, ScreenVec2 [snake_pos + rcx * 4 - 4]
            je .regen
            loop .snake_compare_loop
        mov [fruit_pos], rax
    ret


func(static, update_snake)
    call update_input_snake
    
    mov rcx, uint64_p [snake_size] ;we don't need to check if it's 1 because the copy is useful anyways
    mov rdi, snake_pos + 4 ;(if we eat a fruit, the new tail will be those 4 bytes currently exceeding the length)
    mov rsi, snake_pos
    shl rcx, 2 ;times 4 since each pos is a dword
    
    .loopmemcpy:
        mov al, byte [rsi + rcx - 1]
        mov byte [rdi + rcx - 1], al
        loop .loopmemcpy

    movsx bx, uint8_p [snake_dir.x]
    movsx cx, uint8_p [snake_dir.y]
    mov edi, ScreenVec2 [snake_pos]
    call screenvec2_unpack
    add ax, bx
    add dx, cx
    mov di, ax
    mov si, dx
    call screenvec2_pack
    mov ScreenVec2 [snake_pos], eax

    mov edi, ScreenVec2 [snake_pos]
    call screenvec2_unpack
    cmp ax, (SCREEN_WIDTH/SCREEN_TILE_SIZE)
    jae .handle_gameover
    cmp dx, (SCREEN_HEIGHT/SCREEN_TILE_SIZE)
    jae .handle_gameover

    mov eax, ScreenVec2 [snake_pos]
    mov rcx, uint64_p [snake_size]
    cmp rcx, 4
    jle .end_check_head_body_collision ;no need to check, it's impossible to die from your own body below 5 segments
    .check_head_body_collision:
        dec rcx
        cmp eax, [snake_pos + rcx * 4]
        je .handle_gameover
        cmp rcx, 1
        jne .check_head_body_collision
    .end_check_head_body_collision:

    mov eax, ScreenVec2 [fruit_pos]
    cmp ScreenVec2 [snake_pos], eax
    jne .skip_handle_fruit_catch ;if we don't have the same position as the fruit, we don't increase the snake size and the fruit stays where it is

        inc uint64_p [snake_size]

        call generate_fruit ;if fruit is catched, increment the snake's size and generate a new fruit, works because we copy the tail of the snake into unused memory, which becomes the next tail

    .skip_handle_fruit_catch:

    ret

.handle_gameover:
    ;mov rdi, VGA_RED
    ;call set_font_color

    mov uint8_p [is_game_over], 1

    lea rdi, uint8_p [gameover_text]
    mov rsi, SCREEN_WIDTH/2 - 10*SCREEN_TILE_SIZE/2 ;get the center of the screen minus half the text size (10 glyphs)
    mov rdx, SCREEN_HEIGHT/2 - 1*SCREEN_TILE_SIZE/2 
    call draw_text ;displays the gameover text

    mov rdi, 2 
    shl rdi, 32
    call rtc_sleep ;2 seconds

    ret

func(static, update_input_snake)
    call PS2KB_update

    cmp byte [snake_dir.y], 1
    je .skip_handle_up
    mov rdi, KEY_UP
    call PS2KB_is_key_pressed
    cmp rax, true
    jne .skip_handle_up
    
        mov byte [snake_dir.x], 0
        mov byte [snake_dir.y], -1

    .skip_handle_up:
    cmp byte [snake_dir.y], -1
    je .skip_handle_down
    mov rdi, KEY_DOWN
    call PS2KB_is_key_pressed
    cmp rax, true
    jne .skip_handle_down

        mov byte [snake_dir.x], 0
        mov byte [snake_dir.y], 1

    .skip_handle_down:
    cmp byte [snake_dir.x], 1
    je .skip_handle_left
    mov rdi, KEY_LEFT
    call PS2KB_is_key_pressed
    cmp rax, true
    jne .skip_handle_left

        mov byte [snake_dir.x], -1
        mov byte [snake_dir.y], 0
    
    .skip_handle_left:
    cmp byte [snake_dir.x], -1
    je .skip_handle_right
    mov rdi, KEY_RIGHT
    call PS2KB_is_key_pressed
    cmp rax, true
    jne .skip_handle_right

        mov byte [snake_dir.x], 1
        mov byte [snake_dir.y], 0

    .skip_handle_right:
    ret

;void run_snake(void)
func(static, run_snake)
    call setup_snake
    call draw_snake
    .startup_wait_loop:
        call update_input_snake

        mov rdi, FRAME_TIME
        call rtc_sleep
        cmp uint16_p [snake_dir], 0
        je .startup_wait_loop

    .game_loop:
        call update_snake
        call draw_snake

        mov rdi, FRAME_TIME * FRAME_PER_UPDATE
        call rtc_sleep
        cmp uint8_p [is_game_over], true
        jne .game_loop
    ret



func(global, start_snake)
    call init_snake
    call run_snake
    jmp start_snake
