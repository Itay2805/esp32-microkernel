########################################################################################################################
# Template for building userspace programs
########################################################################################################################

ifndef APP_NAME
$(error APP_NAME must be set to a unique name for the app)
endif

ifndef APP_SHARED
$(error APP_SHARED must be set to a relative path to the app shared directory)
endif

TOOLCHAIN_PATH 	:= $(APP_SHARED)/../../toolchain

#-----------------------------------------------------------------------------------------------------------------------
# Build constants
#-----------------------------------------------------------------------------------------------------------------------

include $(TOOLCHAIN_PATH)/toolchain.mk
include $(TOOLCHAIN_PATH)/esptool.mk

OUT_DIR		:= out
BIN_DIR		:= $(OUT_DIR)/bin
BUILD_DIR	:= $(OUT_DIR)/build

#-----------------------------------------------------------------------------------------------------------------------
# General configurations
#-----------------------------------------------------------------------------------------------------------------------

CFLAGS		?= -Werror -std=gnu11
CFLAGS 		+= -Wno-unused-label
CFLAGS 		+= -Wno-address-of-packed-member
CFLAGS 		+= -Wno-psabi
CFLAGS 		+= -Wno-stringop-overflow

# Size optimization, include debug info
CFLAGS 		+= -Os -g3

# Link time optimization
CFLAGS 		+= -flto -ffat-lto-objects -fuse-linker-plugin

# Freestanding, static and short wchar_t (instead of int)
CFLAGS		+= -ffreestanding -static -fshort-wchar

# Make GCC play nicely with volatile
CFLAGS 		+= -fstrict-volatile-bitfields

# No stdlib
CFLAGS		+= -nostdlib

# Use proper linker script
CFLAGS		+= -T$(APP_SHARED)/app.ld

# Include the lib and kernel folders in include path
CFLAGS 		+= -I$(APP_SHARED)

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

########################################################################################################################
# Targets
########################################################################################################################

.PHONY: all clean

all: $(BIN_DIR)/$(APP_NAME).bin

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:%.o=%.d)
-include $(DEPS)

$(BIN_DIR)/$(APP_NAME).bin: $(BUILD_DIR)/$(APP_NAME).elf
	@mkdir -p $(@D)
	@echo OBJCOPY $(BUILD_DIR)/$(APP_NAME).bin.header
	@$(OBJCOPY) -O binary -j .header $^ $(BUILD_DIR)/$(APP_NAME).bin.header
	@echo OBJCOPY $(BUILD_DIR)/$(APP_NAME).bin.text
	@$(OBJCOPY) -O binary -j .text $^ $(BUILD_DIR)/$(APP_NAME).bin.text
	@echo OBJCOPY $(BUILD_DIR)/$(APP_NAME).bin.data
	@$(OBJCOPY) -O binary -j .data $^ $(BUILD_DIR)/$(APP_NAME).bin.data
	@echo CAT $@
	@cat \
		$(BUILD_DIR)/$(APP_NAME).bin.header \
		$(BUILD_DIR)/$(APP_NAME).bin.text \
		$(BUILD_DIR)/$(APP_NAME).bin.data > $@

$(BUILD_DIR)/$(APP_NAME).elf: $(OBJS)
	@echo LD $@
	@mkdir -p $(@D)
	@$(LD) $(CFLAGS) -o $@ $^

$(BUILD_DIR)/%.c.o: %.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -MMD -c $< -o $@

clean:
	rm -rf out
