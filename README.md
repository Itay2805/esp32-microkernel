# ESP32 Microkernel for TTGO T-Watch-2020-V2

This is a microkernel designed to run baremetal on an ESP32 with the main target being 
the TTGO T-Watch-2020-V2.

This projects has multiple aims:
- test if the ESP32 can run a proper microkernel at all
- have a simple yet usable Xtensa/ESP32 baremetal example

## Wait.. what? how?

In brief, the ESP32 we have runs a dual core Xtensa CPU, the CPU itself
has no built-in memory or instruction protections, there is no concept of
userspace or rings.

So how can we even make a microkernel? well the ESP32 does provide an MMU 
in the SoC itself, that MMU does allow for both protections and translation of 
virtual address range to a physical one. In addition it uses a PID controller 
that can be used to switch between PIDs.

The combination of the MMU and PID controller allows us to fully protect the kernel
memory, the system resources, and DMA access of all the devices in the system. 
Essentially allowing to prevent escalation from a user process to the kernel.

Of course the internal processor state is still modifiable, for the most part it is 
fine since all the special MMU and PID stuff are protected by the MMU. The userspace
can still change one important register, which is the vecbase, but that should be based 
because the entry point is still configured in the PID controller, so you can't take over 
the device, but you can DOS it, with a simple watchdog we should be fine :)

For more indepth information it is the best to look at the code.

## How to build

Currently I only support building from linux.

First you will need to get the toolchain:
```shell
make fetch-toolchain
```

Then you can simply run
```shell
make
```

This will build a full system image that can be used under `out/image.bin`

To test run you can use (note that this will also build if needed)
```shell
make run
```