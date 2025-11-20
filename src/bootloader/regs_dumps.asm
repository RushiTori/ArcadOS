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
    .cs: db " CS "
    .ds: db " DS "
    .ss: db " SS "
    .es: db " ES "
    .fs: db " FS "
    .gs: db " GS "

segment_regs_banks:
static segment_regs_banks: data
    .cs: dw 0
    .ds: dw 0
    .ss: dw 0
    .es: dw 0
    .fs: dw 0
    .gs: dw 0

control_regs_names:
static control_regs_names: data
    .cr0: db "CR0 "
    .cr2: db "CR2 "
    .cr3: db "CR3 "
    .cr4: db "CR4 "
    .cr8: db "CR8 "

control_regs_banks:
static control_regs_banks: data
    .cr0: dq 0
    .cr2: dq 0
    .cr3: dq 0
    .cr4: dq 0
    .cr8: dq 0

table_regs_names:
static table_regs_names: data
    .gdtr: db "GDTR"
    .idtr: db "IDTR"

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

convert_digits:
static convert_digits: data
    db "0123456789ABCDEF"

bits         32

; const char* convert_bin_32(uint32_t n);
func(static, convert_bin_32)
    ; WIP
    ret

; const char* convert_hex_32(uint32_t n);
func(static, convert_hex_32)
    ; WIP
    ret

; void save_regs_32(void);
func(static, save_regs_32)
    ; WIP
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

bits         64

; const char* convert_bin_64(uint64_t n);
func(static, convert_bin_64)
    ; WIP
    ret

; const char* convert_hex_64(uint64_t n);
func(static, convert_hex_64)
    ; WIP
    ret

; void save_regs_64(void);
func(static, save_regs_64)
    ; WIP

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
