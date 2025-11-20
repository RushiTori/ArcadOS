%include "bootloader/regs_dumps.inc"

%define CONVERT_BUFFER_LEN (128)

section .text

flag_reg_name:
static  flag_reg_name: data
    db "FLGS"

flag_reg_bank:
static flag_reg_bank: data
    dd 0

segment_regs_names:
static segment_regs_names: data
    ._cs: db " CS "
    ._ds: db " DS "
    ._ss: db " SS "
    ._es: db " ES "
    ._fs: db " FS "
    ._gs: db " GS "

segment_regs_banks:
static segment_regs_banks: data
    ._cs: dw 0
    ._ds: dw 0
    ._ss: dw 0
    ._es: dw 0
    ._fs: dw 0
    ._gs: dw 0

control_regs_names:
static control_regs_names: data
    ._cr0: db "CR0 "
    ._cr2: db "CR2 "
    ._cr3: db "CR3 "
    ._cr4: db "CR4 "
    ._cr8: db "CR8 "

control_regs_banks:
static control_regs_banks: data
    ._cr0: dq 0
    ._cr2: dq 0
    ._cr3: dq 0
    ._cr4: dq 0
    ._cr8: dq 0

table_regs_names:
static table_regs_names: data
    ._gdtr: db "GDTR"
    ._idtr: db "IDTR"

gdtr_reg_bank:
static gdtr_reg_bank: data
    .limit: dw 0
    .base:  dq 0

idtr_reg_bank:
static idtr_reg_bank: data
    .limit: dw 0
    .base:  dq 0

ap_regs_names_32:
static ap_regs_names_32: data
    ._eip: db "EIP "
    ._eax: db "EAX "
    ._ebx: db "EBX "
    ._ecx: db "ECX "
    ._edx: db "EDX "
    ._esi: db "ESI "
    ._edi: db "EDI "
    ._esp: db "ESP "
    ._ebp: db "EBP "

ap_regs_names_64:
static ap_regs_names_64: data
    ._rip: db "RIP "
    ._rax: db "RAX "
    ._rbx: db "RBX "
    ._rcx: db "RCX "
    ._rdx: db "RDX "
    ._rsi: db "RSI "
    ._rdi: db "RDI "
    ._rsp: db "RSP "
    ._rbp: db "RBP "
    ._r8:  db " R8 "
    ._r9:  db " R9 "
    ._r10: db "R10 "
    ._r11: db "R11 "
    ._r12: db "R12 "
    ._r13: db "R13 "
    ._r14: db "R14 "
    ._r15: db "R15 "

ap_regs_banks:
static ap_regs_banks: data
    ._eip:
    ._rip: dq 0
    ._eax:
    ._rax: dq 0
    ._ebx:
    ._rbx: dq 0
    ._ecx:
    ._rcx: dq 0
    ._edx:
    ._rdx: dq 0
    ._esi:
    ._rsi: dq 0
    ._edi:
    ._rdi: dq 0
    ._esp:
    ._rsp: dq 0
    ._ebp:
    ._rbp: dq 0
    ._r8:  dq 0
    ._r9:  dq 0
    ._r12: dq 0
    ._r13: dq 0
    ._r14: dq 0
    ._r15: dq 0

error_code_bank:
static error_code_bank: data
    dq 0



convert_buffer:
static convert_buffer: data
    times CONVERT_BUFFER_LEN db 0

string(static, convert_digits, "0123456789ABCDEF")
string(static, bin_header,     "0b")
string(static, hex_header,     "0x")

bits           32

; const char* convert_bin_32(uint32_t n);
func(static,   convert_bin_32)
    ; WIP
    ret

; const char* convert_hex_32(uint32_t n);
func(static, convert_hex_32)
    ; WIP
    ret

; void save_regs_32(void);
func(static, save_regs_32)
    ; All Purpose Registers
        ; mov uint32_p [ap_regs_banks._eip], eip
        mov uint32_p [ap_regs_banks._eax], eax
        mov uint32_p [ap_regs_banks._ebx], ebx
        mov uint32_p [ap_regs_banks._ecx], ecx
        mov uint32_p [ap_regs_banks._edx], edx
        mov uint32_p [ap_regs_banks._esi], esi
        ; mov uint32_p [ap_regs_banks._edi], edi
        ; mov uint32_p [ap_regs_banks._esp], esp
        mov uint32_p [ap_regs_banks._ebp], ebp

    ; Table Registers
        sidt [idtr_reg_bank]
        sgdt [gdtr_reg_bank]

    ; Flags Register
        pushf
        pop uint32_p [flag_reg_bank]

    ; Control Registers
        mov eax,                                cr0
        mov uint32_p [control_regs_banks._cr0], eax
        mov eax,                                cr2
        mov uint32_p [control_regs_banks._cr2], eax
        mov eax,                                cr3
        mov uint32_p [control_regs_banks._cr3], eax
        mov eax,                                cr4
        mov uint32_p [control_regs_banks._cr4], eax
        mov eax,                                cr8
        mov uint32_p [control_regs_banks._cr8], eax

    ; Segment Registers
        mov uint16_p [segment_regs_banks._cs], cs
        mov uint16_p [segment_regs_banks._ds], ds
        mov uint16_p [segment_regs_banks._ss], ss
        mov uint16_p [segment_regs_banks._es], es
        mov uint16_p [segment_regs_banks._fs], fs
        mov uint16_p [segment_regs_banks._gs], gs

    ret

; void set_eip_bank(uint32_t value);
func(global, set_eip_bank)
    push edi ; preserve edi

    mov edi, uint32_p [esp + 8] ; edi = value

    mov uint32_p [ap_regs_banks._eip], edi

    pop edi ; restore edi
    ret

; void set_esp_bank(uint32_t value);
func(global, set_esp_bank)
    push edi ; preserve edi

    mov edi, uint32_p [esp + 8] ; edi = value

    mov uint32_p [ap_regs_banks._esp], edi

    pop edi ; restore edi
    ret

; void set_edi_bank(uint32_t value);
func(global, set_edi_bank)
    push edi ; preserve edi

    mov edi, uint32_p [esp + 8] ; edi = value

    mov uint32_p [ap_regs_banks._edi], edi

    pop edi ; restore edi
    ret

; void set_error_code_32(uint32_t value);
func(global, set_error_code_32)
    push edi ; preserve edi

    mov edi, uint32_p [esp + 8] ; edi = value

    mov uint32_p [error_code_bank], edi

    pop edi ; restore edi
    ret

; void dump_regs_text_32(bool_t useErrorCode);
func(global, dump_regs_text_32)
    ; WIP
    ret

bits 64

%macro __convert_base_64 4
    mov ax, uint16_p [%1]

    mov uint16_p [convert_buffer], ax ; memcpy(conver_buffer, %1, 2);

    lea rsi, [convert_buffer + sizeof(%1)]
    lea rdi, [convert_digits]

    xor rax, rax
    mov rcx, %4  ; len
    .cvt_loop:
        mov al,  dil ; get lowest part of n
        and al,  %2  ; n % mod_mask
        shr rdi, %3  ; n / div_mask

        ; *convert_buffer++ = convert_digits[n % mod_mask];
        mov al,            uint8_p [rdi + rax]
        mov uint8_p [rsi], al
        inc rsi

        loop .cvt_loop
%endmacro

%define convert_base_64(header, mod_mask, div_mask, len) __convert_base_64 header, mod_mask, div_mask, len

; const char* convert_bin_64(uint64_t n);
func(static, convert_bin_64)
    convert_base_64(bin_header, 1, 1, 64)
    ret

; const char* convert_hex_64(uint64_t n);
func(static, convert_hex_64)
    convert_base_64(hex_header, 0xF, 4, 16)
    ret

; void save_regs_64(void);
func(static, save_regs_64)
    ; All Purpose Registers
        ; mov uint64_p [ap_regs_banks._rip], rip
        mov uint64_p [ap_regs_banks._rax], rax
        mov uint64_p [ap_regs_banks._rbx], rbx
        mov uint64_p [ap_regs_banks._rcx], rcx
        mov uint64_p [ap_regs_banks._rdx], rdx
        mov uint64_p [ap_regs_banks._rsi], rsi
        ; mov uint64_p [ap_regs_banks._rdi], rdi
        ; mov uint64_p [ap_regs_banks._rsp], rsp
        mov uint64_p [ap_regs_banks._rbp], rbp
        mov uint64_p [ap_regs_banks._r8],  r8
        mov uint64_p [ap_regs_banks._r9],  r9
        mov uint64_p [ap_regs_banks._r12], r12
        mov uint64_p [ap_regs_banks._r13], r13
        mov uint64_p [ap_regs_banks._r14], r14
        mov uint64_p [ap_regs_banks._r15], r15

    ; Table Registers
        sidt [idtr_reg_bank]
        sgdt [gdtr_reg_bank]

    ; Flags Register
        pushf
        pop uint64_p [flag_reg_bank]

    ; Control Registers
        mov rax,                                cr0
        mov uint64_p [control_regs_banks._cr0], rax
        mov rax,                                cr2
        mov uint64_p [control_regs_banks._cr2], rax
        mov rax,                                cr3
        mov uint64_p [control_regs_banks._cr3], rax
        mov rax,                                cr4
        mov uint64_p [control_regs_banks._cr4], rax
        mov rax,                                cr8
        mov uint64_p [control_regs_banks._cr8], rax

    ; Segment Registers
        mov uint16_p [segment_regs_banks._cs], cs
        mov uint16_p [segment_regs_banks._ds], ds
        mov uint16_p [segment_regs_banks._ss], ss
        mov uint16_p [segment_regs_banks._es], es
        mov uint16_p [segment_regs_banks._fs], fs
        mov uint16_p [segment_regs_banks._gs], gs

    ret

; void set_rip_bank(uint64_t value);
func(global, set_rip_bank)
    mov uint64_p [ap_regs_banks._rip], rdi
    ret

; void set_rsp_bank(uint64_t value);
func(global, set_rsp_bank)
    mov uint64_p [ap_regs_banks._rsp], rdi
    ret

; void set_rdi_bank(uint64_t value);
func(global, set_rdi_bank)
    mov uint64_p [ap_regs_banks._rdi], rdi
    ret

; void set_error_code_64(uint64_t value);
func(global, set_error_code_64)
    mov uint64_p [error_code_bank], rdi
    ret

; void dump_regs_text_64(bool_t useErrorCode);
func(global, dump_regs_text_64)
    ; WIP
    ret

; void dump_regs_graphics(bool_t useErrorCode);
func(global, dump_regs_graphics)
    ; WIP
    ret
