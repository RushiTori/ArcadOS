COMP:=nasm
COMP_FLAGS:=-f bin
LINK:=cat
LINK_FLAGS:=

NAME:=ArcadOS.bin

INC_DIR:=include
SRC_DIR:=src
OBJ_DIR:=objs

BOOT_SRC_FILES:=$(SRC_DIR)/bootloader.s $(SRC_DIR)/lineA20.s $(SRC_DIR)/gdt.s
BOOT_OBJ_FILES:=$(BOOT_SRC_FILES:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)
BOOT_DEP_FILES:=$(BOOT_SRC_FILES:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.d)

SRC_FILES:=$(wildcard $(SRC_DIR)/*.asm)
OBJ_FILES:=$(SRC_FILES:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.obj)
DEP_FILES:=$(SRC_FILES:$(SRC_DIR)/%.asm=$(OBJ_DIR)/%.dep)

build:$(NAME)

$(NAME):$(BOOT_OBJ_FILES)
	$(LINK) $(LINK_FLAGS) $^ > $@

-include $(BOOT_DEP_FILES)
$(OBJ_DIR)/%.o:$(SRC_DIR)/%.s | $(OBJ_DIR)
	$(COMP) $(COMP_FLAGS) -i $(INC_DIR)/ $< -M -MF $(@:.o=.d)
	$(COMP) $(COMP_FLAGS) -i $(INC_DIR)/ $< -o $@

$(OBJ_DIR):
	mkdir -p $@

start:
	qemu-system-x86_64 -drive file=$(NAME),format=raw

restart: build start

clean:
	rm -rf $(OBJ_DIR)

cleanAll: clean
	rm -rf $(NAME)

rebuild: cleanAll build

show:
	@echo $(OBJ_FILES)

.PHONY:build start restart clean cleanAll rebuild
