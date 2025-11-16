bits 64
%include "bootloader/USBBoot.inc"

section .text
initUSB:
    call initEHCI
    ret

initEHCI:
