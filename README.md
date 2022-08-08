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

The combination of the MMU and PID controller allows us to protect the kernel
memory, the system resources, and DMA access of all the devices in the system. 
Essentially allowing to prevent escalation from a user process to the kernel.

It is worth noting that the MMU also prevents user code from modifying its own 
code, so self modifying code is not allowed.

Sadly, the internal processor state is still modifiable, for the most part it is 
fine since all the special MMU and PID stuff are protected by the MMU. But this breaks 
once the user can change the vecbase (Where interrupts jump to) and cause an exception/interrupt
to happen while we are handling an exception/interrupt. For example, setting a breakpoint on the 
first instruction of the interrupt handler, and then jumping to it, would cause the PID 
controller to switch us to kernel mode, but after the first instruction is executed we 
will go to the vecbase set by the user, which can be usercode of course, You might ask why
not have the first opcode set the vecbase, sadly xtensa requires at least two opcodes to load
the address, and we actually take 3 since we need to preserve the first reg as well...

So to summarise, our threat model assumes innocent apps, meaning that apps are not trying to 
compromise the kernel, but that they may have vulnerabilities in them. With the memory safeties 
that we can give, an attacker is highly unlikely to be able to have gadgets to perform the attack.

If you have an idea on how to prevent the user from modifying vecbase, I will be more than happy
to hear about it, as giving a full isolation would be my dream.

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