ifndef TOOLCHAIN_PATH
$(error TOOLCHAIN_PATH must be set to a relative path to the toolchain directory)
endif

QEMU_VERSION			:= esp-develop-20220802
QEMU_NAME				:= qemu-$(QEMU_VERSION)
QEMU_DOWNLOAD_URL		:= https://github.com/espressif/qemu/releases/download/$(QEMU_VERSION)/$(QEMU_NAME).tar.bz2

QEMU					:= $(TOOLCHAIN_PATH)/qemu/bin/qemu-system-xtensa
