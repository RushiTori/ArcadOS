COMP:=nasm
COMP_FLAGS:=-f elf64
LINK:=ld
LINK_FLAGS:=-Tlinkerscript.ld

NAME:=ArcadOS

INC_DIR:=include
SRC_DIR:=src
OBJ_DIR:=objs

BOOT_SRC_FILES:=$(SRC_DIR)/bootloader.s $(SRC_DIR)/lineA20.s $(SRC_DIR)/gdt.s $(SRC_DIR)/paging.s $(SRC_DIR)/idt.s $(SRC_DIR)/display.s $(SRC_DIR)/string64.s $(SRC_DIR)/memory_mover.s
BOOT_OBJ_FILES:=$(BOOT_SRC_FILES:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)
BOOT_DEP_FILES:=$(BOOT_SRC_FILES:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.d)

SRC_FILES:=$(wildcard $(SRC_DIR)/*.asm)
OBJ_FILES:=$(SRC_FILES:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.obj)
DEP_FILES:=$(SRC_FILES:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.dep)

build:$(NAME)

$(NAME):$(BOOT_OBJ_FILES)
	$(LINK) $(LINK_FLAGS) $^ -o $@.elf

	rm -f $@.text
	touch $@.text
	objcopy --dump-section .text=$@.text     $@.elf

	rm -f $@.data
	touch $@.data
	objcopy --dump-section .data=$@.data     $@.elf
	stat -c %s $@.data | xargs printf "0: %08X" | xxd -r >> $@.text

	rm -f $@.rodata
	touch $@.rodata
	objcopy --dump-section .rodata=$@.rodata $@.elf
	stat -c %s $@.rodata | xargs printf "0: %08X" | xxd -r >> $@.text

	cat $@.text $@.data $@.rodata > $@.img

-include $(BOOT_DEP_FILES)
$(OBJ_DIR)/%.o:$(SRC_DIR)/%.s | $(OBJ_DIR)
	$(COMP) $(COMP_FLAGS) -i $(INC_DIR)/ $< -M -MF $(@:.o=.d)
	$(COMP) $(COMP_FLAGS) -i $(INC_DIR)/ $< -o $@

$(OBJ_DIR):
	mkdir -p $@

start:
	qemu-system-x86_64 -drive file=$(NAME).img,format=raw

restart: build start

clean:
	rm -rf $(OBJ_DIR)

cleanAll: clean
	rm -rf $(NAME).*

rebuild: cleanAll build

show:
	@echo $(OBJ_FILES)

.PHONY:build start restart clean cleanAll rebuild
