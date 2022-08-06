
# By default fetch the toolchain
default: fetch-toolchain

# The path to the toolchain is in this current directory
TOOLCHAIN_PATH = .

# Include the toolchain
include esptool.mk
include toolchain.mk

# Fetch it
.PHONY: fetch-toolchain
fetch-toolchain:
	rm -rf $(TOOLCHAIN_NAME)
	rm -rf $(ESPTOOL_NAME)

	wget -N $(TOOLCHAIN_DOWNLOAD_URL)
	tar -xvf $(TOOLCHAIN_NAME).tar.xz

	wget -N $(ESPTOOL_DOWNLOAD_URL)
	unzip $(ESPTOOL_NAME).zip
	chmod +x $(ESPTOOL)
