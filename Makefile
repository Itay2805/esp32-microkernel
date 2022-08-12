########################################################################################################################
# watch-micro-kernel build system
########################################################################################################################

#-----------------------------------------------------------------------------------------------------------------------
# The targets to combine it all
#-----------------------------------------------------------------------------------------------------------------------

.PHONY: all clean fetch-toolchain loader kernel rootfs

# Build all the targets
all: out/image.bin

# Clean everything
clean:
	$(MAKE) -C loader clean
	$(MAKE) -C kernel clean
	rm -rf out

# Fetch the toolchain for the given target
fetch-toolchain:
	$(MAKE) -C toolchain

#-----------------------------------------------------------------------------------------------------------------------
# Combine everything into a nice image
#-----------------------------------------------------------------------------------------------------------------------

out/image.bin: loader rootfs
	@mkdir -p $(@D)

	# set the loader at the start and resize it nicely
	rm -rf $@
	dd if=loader/out/bin/loader.bin of=$@ bs=1 seek=4k
	truncate -s 16K $@

	# put the rootfs afterwards
	cat out/rootfs.bin >> $@

	# create a version with a full size image
	cp $@ $@.full
	truncate -s 16M $@.full

rootfs: kernel
	./scripts/create_rootfs.py

loader:
	$(MAKE) -C loader

kernel:
	$(MAKE) -C kernel

#-----------------------------------------------------------------------------------------------------------------------
# Target specific stuff
#-----------------------------------------------------------------------------------------------------------------------

TOOLCHAIN_PATH	:= toolchain
include toolchain/esptool.mk


QEMU			?= /home/tomato/checkouts/esp_qemu/build/qemu-system-xtensa

run: all
	./scripts/run_esp32.py

qemu-debug: all
	 $(QEMU) \
		-machine esp32 \
		-serial stdio \
		-monitor telnet:localhost:1235,server,nowait \
		-drive file=out/image.bin.full,if=mtd,format=raw \
		-m 4M \
		-s -S \
		-d int

qemu: all
	 $(QEMU) \
		 --trace "*mtd*" -machine esp32 \
		-serial stdio \
		-monitor telnet:localhost:1235,server,nowait \
		-drive file=out/image.bin.full,if=mtd,format=raw \
		-m 4M
