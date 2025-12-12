%include "bootloader/vesa.inc"

bits 16

;for now: void setup_vesa_mode(void)     later: void setup_vesa_mode(uint16_t width, uint16_t height, uint8_t bpp)
setup_vesa_mode:

    call get_vesa_info

    mov di, word [data_vbe_info_structure + vbe_info_structure.video_modes + 2]
    mov es, di
    mov di, word [data_vbe_info_structure + vbe_info_structure.video_modes]
    .loop:
        mov ax, [es:di]
        cmp ax, 0xFFFF
        je .error

        push di
        mov di, es
        push di

        mov di, ax
        call get_vesa_mode_info
        
        mov al, byte [data_vbe_mode_info_structure + vbe_mode_info_structure.attributes]
        and al, 0x80 ;supports LFB?
        je .next

        mov ax, word [data_vbe_mode_info_structure + vbe_mode_info_structure.width]
        cmp ax, word [desired_settings.width]
        jne .next

        mov ax, word [data_vbe_mode_info_structure + vbe_mode_info_structure.height]
        cmp ax, word [desired_settings.height]
        jne .next
        
        mov al, byte [data_vbe_mode_info_structure + vbe_mode_info_structure.bpp]
        cmp al, byte [desired_settings.bpp]
        jne .next

        pop di
        mov es, di
        pop di
        mov ax, [es:di]
        mov di, ax
        or di, 0x4000 ;LFB bit
        call set_vesa_mode
        jmp .end_loop

        .next:
        pop di
        mov es, di
        pop di

        add di, 2
        jmp .loop
    .end_loop:
    ;jmp $
    ret ;we got our data here :)
    .error:
        jmp $

;void get_vesa_info(void)
get_vesa_info:
    mov ax, 0x00
    mov es, ax
    mov di, data_vbe_info_structure
    mov ax, 0x4F00
    int 0x10
    cmp ax, 0x4F
    jne .error
    ret
.error:
    jmp $

;void get_vesa_mode_info(uint16_t mode)
get_vesa_mode_info:
    mov ax, 0x00
    mov es, ax
    mov ax, 0x4F01
    mov cx, di
    mov di, data_vbe_mode_info_structure
    int 0x10
    cmp ax, 0x4F
    jne .error
    ret
.error:
    jmp $

;void set_vesa_mode(uint16_t mode)
set_vesa_mode:
    mov ax, 0x4F02
    mov bx, di
    int 0x10
    cmp ax, 0x4F
    jne .error
    ret
.error:
    jmp $

desired_settings:
    .width:     dw 640
    .height:    dw 480
    .bpp:       db 32

data_vbe2_pmi_table_reference:
global data_vbe2_pmi_table:data
    .ptr: resd 1
    .len: resw 1

data_vbe_info_structure:
global data_vbe_info_structure:data
    .signature: db "VBE2"
    .table_data: resb 512 - 4

data_vbe_mode_info_structure:
global data_vbe_mode_info_structure:data
    resb vbe_mode_info_structure_size