%ifndef REGS_DUMPS_INC
%define REGS_DUMPS_INC

;
; These setters do NOT modify any registers, and are safe to call without backing up anything
;

; void set_eip_bank(uint32_t value);
extern set_eip_bank

; void set_rip_bank(uint64_t value);
extern set_rip_bank

; void set_esp_bank(uint32_t value);
extern set_esp_bank

; void set_rsp_bank(uint64_t value);
extern set_rsp_bank

; void set_edi_bank(uint32_t value);
extern set_edi_bank

; void set_rdi_bank(uint64_t value);
extern set_rdi_bank

; void set_error_code_32(uint32_t value);
extern set_error_code_32

; void set_error_code_64(uint64_t value);
extern set_error_code_64

; void dump_regs_text_32(bool_t useErrorCode);
extern dump_regs_text_32

; void dump_regs_text_64(bool_t useErrorCode);
extern dump_regs_text_64

; void dump_regs_graphics(bool_t useErrorCode);
extern dump_regs_graphics

%endif ; REGS_DUMPS_INC
