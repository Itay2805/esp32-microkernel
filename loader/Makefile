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

# Size optimization, include debug info
CFLAGS 		+= -Os -g3

# Link time optimization
CFLAGS 		+= -flto -ffat-lto-objects -fuse-linker-plugin

# Freestanding, static and short wchar_t (instead of int)
CFLAGS		+= -ffreestanding -static -fshort-wchar

# No stdlib
CFLAGS		+= -nostdlib

# Use proper linker script
CFLAGS		+= -Tlinker.ld

# Include the lib and kernel folders in include path
CFLAGS 		+= -Isrc -I../kernel/src

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

#
# LittleFS driver
#

SRCS 		+= ../lib/littlefs/lfs.c
SRCS 		+= ../lib/littlefs/lfs_util.c
CFLAGS 		+= -I../lib/littlefs

# we don't have malloc in the loader
CFLAGS		+= -DLFS_NO_MALLOC

# we are readonly in the loader
CFLAGS 		+=  -DLFS_READONLY

########################################################################################################################
# Targets
########################################################################################################################

.PHONY: all clean

all: $(BIN_DIR)/loader.bin

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:%.o=%.d)
-include $(DEPS)

$(BIN_DIR)/loader.bin: $(BIN_DIR)/loader.elf
	@echo ESPTOOL ELF2IMAGE $@
	@$(ESPTOOL) --chip esp32 --trace elf2image --output $(BUILD_DIR)/loader.bin --version 3 --min-rev 3 --flash_freq 40m --flash_mode dio --flash_size 16MB $^
	@test `wc -c <$(BUILD_DIR)/loader.bin` -lt 12288
	@cp $(BUILD_DIR)/loader.bin $@

$(BIN_DIR)/loader.elf: $(OBJS)
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
