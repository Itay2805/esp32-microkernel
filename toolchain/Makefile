
# By default fetch the toolchain
default: fetch-toolchain

# The path to the toolchain is in this current directory
TOOLCHAIN_PATH = .

# Include the toolchain
include toolchain.mk

# Fetch it
.PHONY: fetch-toolchain
fetch-toolchain:
	rm -rf $(TOOLCHAIN_NAME)
	wget -N $(TOOLCHAIN_DOWNLOAD_URL)
	tar -xvf $(TOOLCHAIN_NAME).tar.xz
