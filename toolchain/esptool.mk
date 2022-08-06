ifndef TOOLCHAIN_PATH
$(error TOOLCHAIN_PATH must be set to a relative path to the toolchain directory)
endif

ESPTOOL_VERSION				:= v4.2
ESPTOOL_NAME				:= esptool-$(ESPTOOL_VERSION)-linux-amd64
ESPTOOL_DOWNLOAD_URL		:= https://github.com/espressif/esptool/releases/download/$(ESPTOOL_VERSION)/$(ESPTOOL_NAME).zip

ESPTOOL						:= $(TOOLCHAIN_PATH)/$(ESPTOOL_NAME)/esptool
ESPEFUSE					:= $(TOOLCHAIN_PATH)/$(ESPTOOL_NAME)/espefuse
ESPSECURE					:= $(TOOLCHAIN_PATH)/$(ESPTOOL_NAME)/espsecure
