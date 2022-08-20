
# By default fetch the toolchain
default: fetch-toolchain

# The path to the toolchain is in this current directory
TOOLCHAIN_PATH = .

# Include the toolchain
include toolchain.mk
include qemu.mk

# Fetch it
.PHONY: fetch-toolchain
fetch-toolchain:
	rm -rf $(TOOLCHAIN_NAME)
	wget -N $(TOOLCHAIN_DOWNLOAD_URL)
	tar -xvf $(TOOLCHAIN_NAME).tar.xz

.PHONY: fetch-qemu
fetch-qemu:
	rm -rf $(QEMU_NAME)
	wget -N $(QEMU_DOWNLOAD_URL)
	tar -xvf $(QEMU_NAME).tar.bz2
