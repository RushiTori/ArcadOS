%include "bootloader/rsdp.inc"

%include "main/main.inc"

%include "string.inc"

section .rodata
RSDP_identifier:
    db "RSD PTR " ;8 bytes identifier for RDSP, it's always 16 aligned

FADT_identifier:
    db "FACP" ;4 bytes identifier for FADT apparently???

DSDT_identifier:
    db "DSDT" ;4 bytes identifier for DSDT

RSDP_error_string:
    db "Couldn't find RSDP", 0

RSDT_error_string:
    db "RSDT checksum failed", 0


FADT_not_found_error_string:
    db "could not find FADT", 0

FADT_checksum_error_string:
    db "FADT checksum failed", 0

DSDT_checksum_error_string:
    db "DSDT checksum failed", 0

section .text

;finds the rsdp/xsdp, and copies it to 0x500000
find_RSDP:
    mov rax, qword [RSDP_identifier]
    mov rsi, EBDA_MEMORY

    .search_ebda_loop:
        mov rdx, [rsi]
        cmp rax, rdx
        je .validate

        add rsi, 0x10
        cmp rsi, EBDA_MEMORY_END
        je .search_bios_memory_region
        jmp .search_ebda_loop
    .search_bios_memory_region:
    mov rsi, BIOS_MEMORY_REGION
    .search_bios_memory_region_loop:
        mov rdx, [rsi]
        cmp rax, rdx
        je .validate

        add rsi, 0x10
        cmp rsi, BIOS_MEMORY_REGION_END
        je .error
        jmp .search_bios_memory_region_loop

    .validate:
        mov dil, [rsi + RSDP.Revision]
        cmp dil, 2
        jne .revision1
    .revision2:
        mov rdi, 0
        mov rcx, XSDP_size
        .checksumLoop2:    
            add dil, byte [rsi + rcx - 1]
            loop .checksumLoop2
        jnz .error
        jmp .success2
    .revision1:
        mov rdi, 0
        mov rcx, RSDP_size
        .checksumLoop1:    
            add dil, byte [rsi + rcx - 1]
            loop .checksumLoop1
        jnz .error
        jmp .success1
    .success2:
        mov rdi, RSDP_COPY_MEMORY_BOUNDARY
        mov rdx, XSDP_size
        call memcpy
        jmp .end_xsdp
    .success1:
        mov rdi, RSDP_COPY_MEMORY_BOUNDARY
        mov rdx, RSDP_size
        call memcpy
    .end_rsdp:

    call find_dsdt
    jmp .end

    .end_xsdp:

    call find_dsdt_extended
    ;now that we got our dsdt where we want it, we're good
    .end:
    jmp main
    .error:
        mov rdi, 0x01
        call set_color

        call clear_screen

        mov rdi, 0
        mov rsi, 0
        mov rdx, RSDP_error_string
        call rsdp_draw_text_and_shadow
    .error_loop:
        jmp .error_loop

rsdp_draw_text_and_shadow:
static draw_text_and_shadow:function
	push rdi
	push rsi
	push rdx
	call draw_text_shadow

	pop rdx
	pop rsi
	pop rdi
	call draw_text

	ret

;screw rdi
;rsi: pointer
;rcx: length
;returns bool in rax, nonzero = valid, zero = invalid
validateChecksum:
    mov rax, 0
    .checksumLoop2:    
        add al, byte [rsi + rcx - 1]
        loop .checksumLoop2
    ret

;copies

find_dsdt:
    mov esi, dword [RSDP_COPY_MEMORY_BOUNDARY + RSDP.RsdtAddress]
    mov ecx, dword [rsi + RSDT.Length]
    call validateChecksum
    cmp rax, 0
    jnz .error_rsdt

    mov ecx, dword [rsi + RSDT.Length]
    sub rcx, ACPISDTHeader_size

    mov eax, dword [FADT_identifier]
    add rsi, ACPISDTHeader_size
    .loop:
        mov edx, dword [rsi] ;address to table
        mov edx, dword [edx] ;header identifier normally
        cmp edx, eax
        je .found
        add rsi, 4
        sub rcx, 4
        jne .loop
    
    jmp .error_fadt_not_found

    .found:
    mov esi, dword [rsi]
    mov ecx, dword [rsi + ACPISDTHeader.Length]
    call validateChecksum
    cmp rax, 0
    jnz .error_fadt_not_valid

    mov edi, dword [rsi + ACPISDTHeader.Length]
    mov rdx, FADT_size
    call memcpy

    mov esi, dword [rsi + FADT.Dsdt]
    mov ecx, dword [rsi + ACPISDTHeader.Length]
    call validateChecksum
    cmp rax, 0
    jnz .error_dsdt_not_valid

    mov rdi, DSDT_COPY_MEMORY_BOUNDARY
    mov edx, dword [rsi + ACPISDTHeader.Length]
    call memcpy

    jmp $

.error_rsdt:
        mov rdi, 0x01
        call set_color

        call clear_screen

        mov rdi, 0
        mov rsi, 0
        mov rdx, RSDT_error_string
        call rsdp_draw_text_and_shadow
    .error_rsdt_loop:
        jmp .error_rsdt_loop

.error_fadt_not_found:
    mov rdi, 0x01
    call set_color

    call clear_screen

    mov rdi, 0
    mov rsi, 0
    mov rdx, FADT_not_found_error_string
    call rsdp_draw_text_and_shadow
.error_fadt_not_found_loop:
    jmp .error_fadt_not_found_loop

.error_fadt_not_valid:
        mov rdi, 0x01
        call set_color

        call clear_screen

        mov rdi, 0
        mov rsi, 0
        mov rdx, FADT_checksum_error_string
        call rsdp_draw_text_and_shadow
    .error_fadt_invalid_loop:
        jmp .error_fadt_invalid_loop

.error_dsdt_not_valid:
        mov rdi, 0x01
        call set_color

        call clear_screen

        mov rdi, 0
        mov rsi, 0
        mov rdx, DSDT_checksum_error_string
        call rsdp_draw_text_and_shadow
    .error_dsdt_invalid_loop:
        jmp .error_dsdt_invalid_loop

find_dsdt_extended:
    jmp $
