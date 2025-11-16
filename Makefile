# Makefile by RushiTori - November 15th 2025
# ====== Everything Makefile internal related ======

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
MAKEFLAGS+=--no-print-directory
RM:=rm -rvf
DEBUG:=0
RELEASE:=0

# ========= Everything project related =========

NAME:=ArcadOS

CC:=nasm
LD:=ld
MIN_IMAGE_SIZE:=33280

# ========== Everything files related ==========

HDS_DIR:=include
HDS_PATHS:=$(HDS_DIR)
HDS_PATHS:=$(addprefix -I,$(HDS_PATHS))

SRC_EXT:=asm
SRC_DIR:=src
BOOTLOADER_SRC_DIR:=$(SRC_DIR)/bootloader
ENGINE_SRC_DIR:=$(SRC_DIR)/engine

FIRST_SRC_FILENAME:=bootloader
FIRST_SRC_FILE:=$(BOOTLOADER_SRC_DIR)/$(FIRST_SRC_FILENAME).$(SRC_EXT)

LAST_SRC_FILENAME:=memory_mover
LAST_SRC_FILE:=$(SRC_DIR)/$(LAST_SRC_FILENAME).$(SRC_EXT)

BOOTLOADER_SRC_FILES:=$(call rwildcard,$(BOOTLOADER_SRC_DIR),*.$(SRC_EXT))
ENGINE_SRC_FILES:=$(call rwildcard,$(ENGINE_SRC_DIR),*.$(SRC_EXT))

SRC_FILES:=$(call rwildcard,$(SRC_DIR),*.$(SRC_EXT))
SRC_FILES:=$(filter-out $(BOOTLOADER_SRC_FILES), $(SRC_FILES))
SRC_FILES:=$(filter-out $(ENGINE_SRC_FILES), $(SRC_FILES))

SRC_FILES:=$(BOOTLOADER_SRC_FILES) $(ENGINE_SRC_FILES) $(SRC_FILES)
SRC_FILES:=$(filter-out $(FIRST_SRC_FILE), $(SRC_FILES))
SRC_FILES:=$(filter-out $(LAST_SRC_FILE), $(SRC_FILES))

SRC_FILES:=$(FIRST_SRC_FILE) $(SRC_FILES) $(LAST_SRC_FILE)

OBJ_DIR:=objs
OBJ_EXT:=obj
DEP_EXT:=dep
OBJ_FILES:=$(SRC_FILES:$(SRC_DIR)/%.$(SRC_EXT)=$(OBJ_DIR)/%.$(OBJ_EXT))
DEP_FILES:=$(SRC_FILES:$(SRC_DIR)/%.$(SRC_EXT)=$(OBJ_DIR)/%.$(DEP_EXT))

TARGET_ELF:=$(OBJ_DIR)/$(NAME).elf
TARGET_IMAGE:=$(NAME).img
TARGET_TEXT:=$(OBJ_DIR)/$(NAME).text
TARGET_DATA:=$(OBJ_DIR)/$(NAME).data
TARGET_RODATA:=$(OBJ_DIR)/$(NAME).rodata
TARGET_SYMBOLS:=$(OBJ_DIR)/$(NAME).symbols

# ========== Everything flags related ==========

CCFLAGS:=-felf64
ifeq ($(DEBUG), 1)
	CCFLAGS+=-gdwarf
endif
CCFLAGS+=$(HDS_PATHS)

LDFLAGS:=-Tlinkerscript.ld -Map=$(TARGET_SYMBOLS)

# =========== Every usable functions ===========

build_debug:
	@$(MAKE) DEBUG=1 build

release:
	@$(MAKE) RELEASE=1 build

build: $(TARGET_IMAGE)

$(TARGET_ELF):$(OBJ_FILES)
	@echo Linking $@
	@$(LD) $(LDFLAGS) $^ -o $@

$(TARGET_TEXT):$(TARGET_ELF)
	@echo Extracting raw code, section .text, into $@
	@objcopy --dump-section .text=$@ $(TARGET_ELF)

$(TARGET_DATA):$(TARGET_ELF)
	@echo Extracting data, section .data, into $@
	@objcopy --dump-section .data=$@ $(TARGET_ELF)
	@stat -c %s $@ | xargs printf "0x%08X" | xxd -r >> $(TARGET_TEXT)

$(TARGET_RODATA):$(TARGET_ELF)
	@echo Extracting rodata, section .rodata, into $@
	@objcopy --dump-section .rodata=$@ $(TARGET_ELF)
	@stat -c %s $@ | xargs printf "0x%08X" | xxd -r >> $(TARGET_TEXT)

$(TARGET_IMAGE):$(TARGET_ELF)
	@$(MAKE) $(TARGET_TEXT) 
	@$(MAKE) $(TARGET_DATA) 
	@$(MAKE) $(TARGET_RODATA)
	@echo Linking $(TARGET_TEXT) $(TARGET_DATA) and $(TARGET_RODATA) into $@
	@cat $(TARGET_TEXT) $(TARGET_DATA) $(TARGET_RODATA) > $@
	@echo truncating $@ to minimum of $(MIN_IMAGE_SIZE) bytes
	@truncate $@ --size=">$(MIN_IMAGE_SIZE)"

-include $(DEP_FILES)
$(OBJ_DIR)/%.$(OBJ_EXT): $(SRC_DIR)/%.$(SRC_EXT)
	@echo Compiling $< into $@
	@mkdir -p $(dir $@)
	@$(CC) $(CCFLAGS) $< -o $@ -MD $(@:.obj=.dep)

run: $(TARGET_IMAGE)
	qemu-system-x86_64 -drive file=$(TARGET_IMAGE),format=raw -no-reboot -no-shutdown

debug:
	qemu-system-x86_64 -drive file=$(TARGET_IMAGE),format=raw -M accel=tcg,smm=off -d int -no-reboot -no-shutdown -monitor stdio

clean:
	@$(RM) $(OBJ_DIR)

wipe: clean
	@$(RM) $(NAME).*

rebuild: wipe build

redebug: wipe debug 

rerelease: wipe release

rerun: build run

.PHONY: build rebuild
.PHONY: debug redebug
.PHONY: release rerelease
.PHONY: run rerun
.PHONY: install uninstall
.PHONY: clean wipe
