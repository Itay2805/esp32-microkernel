########################################################################################################################
# watch-micro-kernel build system
########################################################################################################################

#-----------------------------------------------------------------------------------------------------------------------
# The targets to combine it all
#-----------------------------------------------------------------------------------------------------------------------

.PHONY: all clean fetch-toolchain loader kernel

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

out/image.bin: loader kernel
	@mkdir -p $(@D)
	rm -rf $@
	dd if=loader/out/bin/loader.bin of=$@ bs=1 seek=4k
	dd if=kernel/out/bin/kernel.bin of=$@ bs=1 seek=8K
	cp $@ $@.full
	truncate -s 16M $@.full

#-----------------------------------------------------------------------------------------------------------------------
# Wrap our kernel and loader targets
#-----------------------------------------------------------------------------------------------------------------------

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
	@sudo $(ESPTOOL) \
			--chip esp32 \
			--before default_reset \
			--after hard_reset \
			write_flash \
			0 \
			out/image.bin

qemu-debug: all
	 $(QEMU) \
		-machine esp32 \
		-serial stdio \
		-monitor telnet:localhost:1235,server,nowait \
		-drive file=/home/tomato/projects/osdev/watch-micro-kernel/out/image.bin.full,if=mtd,format=raw \
		-m 4M \
		-s -S \
		-d int

qemu: all
	 $(QEMU) \
		-machine esp32 \
		-serial stdio \
		-d unimp,guest_errors \
		-monitor telnet:localhost:1235,server,nowait \
		-drive file=/home/tomato/projects/osdev/watch-micro-kernel/out/image.bin.full,if=mtd,format=raw \
		-m 4M
