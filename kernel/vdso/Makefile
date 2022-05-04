########################################################################################################################
# VDSO stuff
########################################################################################################################

#-----------------------------------------------------------------------------------------------------------------------
# Build constants
#-----------------------------------------------------------------------------------------------------------------------

TOOLCHAIN_PATH 	:= ../../toolchain
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

# Size optimization, include debug info
CFLAGS 		+= -Os -g3

# Link time optimization
CFLAGS 		+= -flto -ffat-lto-objects -fuse-linker-plugin

# Freestanding, static and short wchar_t (instead of int)
CFLAGS		+= -ffreestanding -static -fshort-wchar

# No stdlib
CFLAGS		+= -nostdlib

# Use proper linker script
CFLAGS		+= -Tsrc/linker.ld

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

########################################################################################################################
# Targets
########################################################################################################################

.PHONY: all clean

all: $(BIN_DIR)/vdso.bin

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:%.o=%.d)
-include $(DEPS)

$(BIN_DIR)/vdso.bin: $(BUILD_DIR)/vdso.elf
	@mkdir -p $(@D)
	@echo OBJCOPY $@
	@$(OBJCOPY) -O binary -j .text $^ $@

$(BUILD_DIR)/vdso.elf: $(OBJS)
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
