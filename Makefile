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

out/image.bin: kernel/out/bin/kernel.bin loader/out/bin/loader.bin
	@mkdir -p $(@D)
	rm -rf $@
	dd if=loader/out/bin/loader.bin of=$@
	dd if=kernel/out/bin/kernel.bin of=$@ bs=1 seek=4K

#-----------------------------------------------------------------------------------------------------------------------
# Wrap our kernel and loader targets
#-----------------------------------------------------------------------------------------------------------------------

loader:
	$(MAKE) -C loader

kernel:
	$(MAKE) -C kernel

kernel/out/bin/kernel.bin: kernel
loader/out/bin/loader.bin: loader

#-----------------------------------------------------------------------------------------------------------------------
# Target specific stuff
#-----------------------------------------------------------------------------------------------------------------------

TOOLCHAIN_PATH	:= toolchain
include toolchain/esptool.mk

run: all
	@sudo $(ESPTOOL) \
			--chip esp32 \
			--before default_reset \
			--after hard_reset \
			write_flash \
			0x1000 \
			out/image.bin
	@sudo $(ESPTOOL) \
			--chip esp32 \
			--before default_reset \
			--after hard_reset \
			run
