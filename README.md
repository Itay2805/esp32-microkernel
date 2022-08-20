# ESP32 Microkernel for TTGO T-Watch-2020-V2

This is a protected microkernel designed to run baremetal on an ESP32 with the main target 
being the TTGO T-Watch-2020-V2.

This projects has multiple aims:
- test if the ESP32 can run a proper microkernel at all
- have a simple yet usable Xtensa/ESP32 baremetal example

## Wait.. what? how?

In brief, the ESP32 we have runs a dual core Xtensa CPU, the CPU itself
has no built-in memory or instruction protections, there is no concept of
userspace or rings.

So how can we even make a protected microkernel? well the ESP32 does provide an 
MMU in the SoC itself, that MMU does allow for both protections and translation of 
virtual address range to a physical one. In addition it uses a PID controller 
that can be used to switch between PIDs.

The combination of the MMU and PID controller allows us to protect the kernel
memory, the system resources, and DMA access of all the devices in the system. 
Essentially allowing to prevent escalation from a user process to the kernel.

It is worth noting that the MMU also prevents user code from modifying its own 
code, so self modifying code is not allowed.

But what about interrupts? In Xtensa interrupts go through the vecbase, and because
we have no userspace the user can change it! well, thankfully the esp32 does provide
a way to protect specifically the vecbase! The dport can change it so the CPU will take
the vecbase from the dport instead from the internal register! Additionally we configure
the pid controller to switch to our kernel mode when a fetch from the vecbase is made.

For more indepth information it is the best to look at the code.

## How to build

Currently, I only support building from linux.

You will need the following python dependencies:
* `esptool`
* `littlefs-python`
* `tqdm`

First you will need to get the toolchain:
```shell
make fetch-toolchain
```

Then you can simply run
```shell
make
```

This will build a full system image that can be used under `out/image.bin`

To test run you can use (note that this will also build if needed), note that you might need to run this as 
root if you don't have permission to use the serial device directly.
```shell
make run
```

If you want to use qemu then you will need to build it first 
