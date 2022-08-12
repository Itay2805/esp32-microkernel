ifndef TOOLCHAIN_PATH
$(error TOOLCHAIN_PATH must be set to a relative path to the toolchain directory)
endif

TOOLCHAIN_VERSION			:= esp-2022r1-RC1
TOOLCHAIN_TARGET			:= xtensa-esp32-elf
TOOLCHAIN_NAME				:= $(TOOLCHAIN_TARGET)-gcc11_2_0-$(TOOLCHAIN_VERSION)-linux-amd64
TOOLCHAIN_DOWNLOAD_URL		:= https://github.com/espressif/crosstool-NG/releases/download/$(TOOLCHAIN_VERSION)/$(TOOLCHAIN_NAME).tar.xz

PREFIX						:= $(TOOLCHAIN_PATH)/$(TOOLCHAIN_TARGET)/bin/$(TOOLCHAIN_TARGET)-
CC 							:= $(PREFIX)gcc
LD							:= $(PREFIX)gcc
OBJCOPY						:= $(PREFIX)objcopy
