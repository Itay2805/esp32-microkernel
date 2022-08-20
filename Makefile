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
	$(MAKE) -C apps/init clean
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

rootfs: kernel init
	./scripts/create_rootfs.py

loader:
	$(MAKE) -C loader

kernel:
	$(MAKE) -C kernel

init:
	$(MAKE) -C apps/init

#-----------------------------------------------------------------------------------------------------------------------
# Target specific stuff
#-----------------------------------------------------------------------------------------------------------------------

TOOLCHAIN_PATH	:= toolchain
include toolchain/esptool.mk
include toolchain/toolchain.mk
include toolchain/qemu.mk

$(QEMU):
	$(MAKE) -C toolchain fetch-qemu

objdump: kernel
	$(OBJDUMP) -d kernel/out/build/kernel.elf > kernel.S

run: all
	./scripts/run_esp32.py

qemu-debug: $(QEMU) all
	 $(QEMU) \
		-machine esp32 \
		-serial stdio \
		-monitor telnet:localhost:1235,server,nowait \
		-drive file=out/image.bin.full,if=mtd,format=raw \
		-m 4M \
		-s -S \
		-d int

qemu: $(QEMU) all
	 $(QEMU) \
		 --trace "*mtd*" -machine esp32 \
		-serial stdio \
		-monitor telnet:localhost:1235,server,nowait \
		-drive file=out/image.bin.full,if=mtd,format=raw \
		-m 4M
