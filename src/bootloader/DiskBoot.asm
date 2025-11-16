bits 64

%include "bootloader/DiskBoot.inc"

section .bss

;channels:
;    istruc IDEChannelRegisters ;channel[0]
;    istruc IDEChannelRegisters ;channel[1]
;
;ide_buf:
;    resb 2048
;ide_irq_invoked:
;    resb 1
;atapi_packet:
;    resb 12
;
;ide_devices:
;    istruc ide_device   ;ide_devices[0]
;    istruc ide_device   ;ide_devices[1]
;    istruc ide_device   ;ide_devices[2]
;    istruc ide_device   ;ide_devices[3]

section .text

;IDE_Initialize:
;    ;assuming parallel IDE
;    ;so IDE_Initialize(0x1F0, 0x3F6, 0x170, 0x376, 0x000);
;
;;rsi: channel
;;rsi: reg
;IDE_read:
;    cmp rsi, 0x7
;    jle .skipHandle0x8to0xB_1
;    cmp rsi, 0xC
;    jge .skipHandle0x8to0xB_1
;
;    push rdi
;    push rsi
;    ;channel already in rdi
;    mov rsi, ATA_REG_CONTROL
;    mov rdx, 0x80
;    mov rcx, [channels + rdi * 8]
;    or rdx, rcx
;    call IDE_write
;    jmp 
;.skipHandle0x8to0xB_1
;
;cmp rsi, 0x7
;    jle .skipHandle0x8to0xB_2
;    cmp rsi, 0xC
;    jge .skipHandle0x8to0xB_2
;
;    push rdi
;    push rsi
;    ;channel already in rdi
;    mov rsi, ATA_REG_CONTROL
;    mov rdx, 0x80
;    mov rcx, [channels + rdi * 8]
;    or rdx, rcx
;    call IDE_write
;.skipHandle0x8to0xB_2
;
;

;=============================================================================
; ATA read sectors (LBA mode) 
;
; @param EAX Logical Block Address of sector
; @param CL  Number of sectors to read
; @param RDI The address of buffer to put data obtained from disk
;
; @return None
;=============================================================================
ata_lba_read:
               pushfq
               and rax, 0x0FFFFFFF
               push rax
               push rbx
               push rcx
               push rdx
               push rdi

               mov rbx, rax         ; Save LBA in RBX
               
               mov edx, 0x01F6      ; Port to send drive and bit 24 - 27 of LBA
               shr eax, 24          ; Get bit 24 - 27 in al
               or al, 11100000b     ; Set bit 6 in al for LBA mode
               out dx, al

               mov edx, 0x01F2      ; Port to send number of sectors
               mov al, cl           ; Get number of sectors from CL
               out dx, al
               
               mov edx, 0x1F3       ; Port to send bit 0 - 7 of LBA
               mov eax, ebx         ; Get LBA from EBX
               out dx, al

               mov edx, 0x1F4       ; Port to send bit 8 - 15 of LBA
               mov eax, ebx         ; Get LBA from EBX
               shr eax, 8           ; Get bit 8 - 15 in AL
               out dx, al


               mov edx, 0x1F5       ; Port to send bit 16 - 23 of LBA
               mov eax, ebx         ; Get LBA from EBX
               shr eax, 16          ; Get bit 16 - 23 in AL
               out dx, al

               mov edx, 0x1F7       ; Command port
               mov al, 0x20         ; Read with retry.
               out dx, al

.still_going:  in al, dx
               test al, 8           ; the sector buffer requires servicing.
               jz .still_going      ; until the sector buffer is ready.

               mov rax, 256         ; to read 256 words = 1 sector
               xor bx, bx
               mov bl, cl           ; read CL sectors
               mul bx
               mov rcx, rax         ; RCX is counter for INSW
               mov rdx, 0x1F0       ; Data port, in and out
               rep insw             ; in to [RDI]

               pop rdi
               pop rdx
               pop rcx
               pop rbx
               pop rax
               popfq
               ret