COMP:=nasm
COMP_FLAGS:=-f elf64 -g -F dwarf
LINK:=ld
LINK_FLAGS:=-Tlinkerscript.ld

NAME:=ArcadOS

INC_DIR:=include
SRC_DIR:=src
OBJ_DIR:=objs

BOOTLOADER_SRC_FILES:=  $(SRC_DIR)/bootloader/bootloader.asm \
						$(SRC_DIR)/bootloader/memmap.asm \
						$(SRC_DIR)/bootloader/lineA20.asm \
						$(SRC_DIR)/bootloader/gdt.asm \
						$(SRC_DIR)/bootloader/paging.asm \
						$(SRC_DIR)/bootloader/pic.asm \
						$(SRC_DIR)/bootloader/idt.asm

ENGINE_SRC_FILES:=$(wildcard $(SRC_DIR)/engine/*.asm)

SRC_FILES:=$(wildcard $(SRC_DIR)/*.asm) $(wildcard $(SRC_DIR)/**/*.asm)
SRC_FILES:=$(filter-out $(BOOTLOADER_SRC_FILES), $(SRC_FILES))
SRC_FILES:=$(filter-out $(ENGINE_SRC_FILES), $(SRC_FILES))
SRC_FILES:=$(filter-out $(SRC_DIR)/memory_mover.asm, $(SRC_FILES))
SRC_FILES:=$(BOOTLOADER_SRC_FILES) $(ENGINE_SRC_FILES) $(SRC_FILES) $(SRC_DIR)/memory_mover.asm

OBJ_FILES:=$(SRC_FILES:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.obj)
DEP_FILES:=$(SRC_FILES:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.dep)

build:$(NAME)

$(NAME):$(OBJ_FILES)
	@echo Linking $@.elf
	@$(LINK) $(LINK_FLAGS) $^ -o $@.elf

	@echo Extracting raw code, section .text, into $@.text
	@rm -f $@.text
	@touch $@.text
	@objcopy --dump-section .text=$@.text     $@.elf

	@echo Extracting data, section .data, into $@.data
	@rm -f $@.data
	@touch $@.data
	@objcopy --dump-section .data=$@.data     $@.elf
	@stat -c %s $@.data | xargs printf "0x%08X" | xxd -r >> $@.text

	@echo Extracting rodata, section .rodata, into $@.rodata
	@rm -f $@.rodata
	@touch $@.rodata
	@objcopy --dump-section .rodata=$@.rodata $@.elf
	@stat -c %s $@.rodata | xargs printf "0x%08X" | xxd -r >> $@.text

	@echo Linking $@.text $@.data and $@.rodata into $@.img
	@cat $@.text $@.data $@.rodata > $@.img

-include $(DEP_FILES)
$(OBJ_DIR)/%.obj:$(SRC_DIR)/%.asm
	@echo Compiling $< into $@
	@mkdir -p $(dir $@)
	@$(COMP) $(COMP_FLAGS) -i $(INC_DIR)/ $< -M -MF $(@:.obj=.dep) -MT $@
	@$(COMP) $(COMP_FLAGS) -i $(INC_DIR)/ $< -o $@

start:
	qemu-system-x86_64 -drive file=$(NAME).img,format=raw

restart: build start

debug:
	qemu-system-x86_64 -drive file=$(NAME).img,format=raw -s -S

redebug: build debug

clean:
	rm -rf $(OBJ_DIR)

cleanAll: clean
	rm -rf $(NAME).*

rebuild: cleanAll build

show:
	@echo $(SRC_FILES)

.PHONY:build start restart debug redebug clean cleanAll rebuild show
