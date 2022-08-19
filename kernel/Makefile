########################################################################################################################
# ESP32 loader
########################################################################################################################

#-----------------------------------------------------------------------------------------------------------------------
# Build constants
#-----------------------------------------------------------------------------------------------------------------------

TOOLCHAIN_PATH 	:= ../toolchain
include $(TOOLCHAIN_PATH)/toolchain.mk
include $(TOOLCHAIN_PATH)/esptool.mk

OUT_DIR		:= out
BIN_DIR		:= $(OUT_DIR)/bin
BUILD_DIR	:= $(OUT_DIR)/build

#-----------------------------------------------------------------------------------------------------------------------
# General configurations
#-----------------------------------------------------------------------------------------------------------------------

CFLAGS		:= -Werror -std=gnu11
CFLAGS 		+= -Wno-unused-label
CFLAGS 		+= -Wno-address-of-packed-member
CFLAGS 		+= -Wno-psabi
CFLAGS 		+= -Wno-stringop-overflow

# Size optimization, include debug info
CFLAGS 		+= -Og -g3

# Link time optimization
#CFLAGS 		+= -flto -ffat-lto-objects -fuse-linker-plugin

# Freestanding, static and short wchar_t (instead of int)
CFLAGS		+= -ffreestanding -static -fshort-wchar

# Make GCC play nicely with volatile
CFLAGS 		+= -fstrict-volatile-bitfields

# No stdlib
CFLAGS		+= -nostdlib

# Use proper linker script
CFLAGS		+= -Tsrc/linker.ld

# Include the lib and kernel folders in include path
CFLAGS 		+= -Isrc -I../apps/shared

#-----------------------------------------------------------------------------------------------------------------------
# Target specific stuff
#-----------------------------------------------------------------------------------------------------------------------

# Use literal pools
CFLAGS 		+= -mauto-litpools

# We have the const16 instruction, so use it
CFLAGS 		+= -mconst16

# We are kernel
CFLAGS		+= -mforce-no-pic

# Align branch targets
CFLAGS 		+= -mtarget-align

# Allow VLIW
CFLAGS 		+= -Wa,--flix

# Tells the assembler that a long call may be needed, it does not seem
# to affect code gen too much with lto
CFLAGS 		+= -mlongcalls

#-----------------------------------------------------------------------------------------------------------------------
# Sources
#-----------------------------------------------------------------------------------------------------------------------

SRCS 		:= $(shell find src -name '*.c')
SRCS 		+= $(shell find src -name '*.S')

#
# UMM
#

SRCS		+= libs/umm_malloc/src/umm_malloc.c

CFLAGS 		+= -Ilibs/umm_malloc/src
CFLAGS 		+= -DUMM_CFGFILE="<util/umm_malloc_cfgport.h>"

########################################################################################################################
# Targets
########################################################################################################################

.PHONY: all clean

all: $(BIN_DIR)/kernel.bin

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:%.o=%.d)
-include $(DEPS)

$(BIN_DIR)/kernel.bin: $(BUILD_DIR)/kernel.elf
	@mkdir -p $(@D)
	@echo OBJCOPY $(BUILD_DIR)/kernel.bin.header
	@$(OBJCOPY) -O binary -j .header $^ $(BUILD_DIR)/kernel.bin.header
	@echo OBJCOPY $(BUILD_DIR)/kernel.bin.text
	@$(OBJCOPY) -O binary -j .text $^ $(BUILD_DIR)/kernel.bin.text
	@echo OBJCOPY $(BUILD_DIR)/kernel.bin.data
	@$(OBJCOPY) -O binary -j .data $^ $(BUILD_DIR)/kernel.bin.data
	@echo OBJCOPY $(BUILD_DIR)/kernel.bin.vdso
	@$(OBJCOPY) -O binary -j .vdso $^ $(BUILD_DIR)/kernel.bin.vdso
	@echo CAT $@
	@cat \
		$(BUILD_DIR)/kernel.bin.header \
		$(BUILD_DIR)/kernel.bin.text \
		$(BUILD_DIR)/kernel.bin.data \
		$(BUILD_DIR)/kernel.bin.vdso > $@

$(BUILD_DIR)/kernel.elf: $(OBJS)
	@echo LD $@
	@mkdir -p $(@D)
	@$(LD) $(CFLAGS) -o $@ $^

$(BUILD_DIR)/%.c.o: %.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -MMD -c $< -o $@

$(BUILD_DIR)/%.S.o: %.S
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf out
