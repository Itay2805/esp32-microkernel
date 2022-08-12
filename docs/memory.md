# Memory map

## BootROM

This is the first code which runs, and it will eventually run our 
loader code.

### SRAM 1 (0x3FFE_0000 - 0x3FFE_FFFF)

Seems to contain XTOS data. Looking at the symbols it only
takes the first 64KB in there.

This range also includes the initial stack. 

### SRAM 2 (0x3FFA_E000 - 0x3FFB_FF70)
Contains alot of the integrated newlib and I think bluetooth drivers 
data. It takes about 72KB.

## Loader

The loader needs to respect both the kernel and the bootrom memory ranges, and its main
goal is to essentially setup a nice environment for the kernel to start in.

For the loader:
- 0x4008_0000 - 0x4009_FFFF (128K): Loader code
- 0x3FFC_0000 - 0x3FFC_1FFF (8K): Loader data
- 0x3FFC_2000 - 0x3FFC_FFFF (56K): initrd
- 0x3FFD_0000 - 0x3FFD_FFFF (64K): Temp buffer

*TODO: currently we have a huge overkill on the loader code, maybe we 
       can use this for something else*

The main problem is the collision between the kernel data and the bootrom using both 
the SRAM 1 data range, to avoid having problems when loading the kernel we will read 
everything to a temp buffer, and then we will copy from there to the real range, once
we are sure that we don't need the bootrom anymore.

## Kernel

For the kernel mode we have a very defined memory map.
- User code and data: those are set in areas where we have configurable MMU
- Kernel code and data: those are set in areas where we have a static MMU

| Name              | Address Range               | Size    | Usage         |
|-------------------|-----------------------------|---------|---------------|
| SRAM 2            | 0x3FFA_E000 - 0x3FFB_FFFF   | 72KB    | Kernel heap   |
| SRAM 2            | 0x3FFC_0000 - 0x3FFD_FFFF   | 128KB   | User data     |
| SRAM 1            | 0x3FFE_0000 - 0x3FFF_FFFF   | 128KB   | Kernel Data   |
| SRAM 1            | 0x400A_0000 - 0x400B_FFFF   | 128KB   | Kernel Code   |
| SRAM 0            | 0x4007_0000 - 0x4007_FFFF   | 64KB    | Cache         | 
| SRAM 0            | 0x4008_0000 - 0x4009_FFFF   | 128KB   | User Code     |

*Note: SRAM 1 code and data are aliases, so there is a total of 128KB for both*

### vDSO

Because of how the MMU/MPU/PID Controller works, we need to have the vecbase be mapped to usermode,
which is actually fine, usermode can't modify code, so we can safely share this between all the 
processes allowing us to only reserve 8kb for this, giving the process 120kb code, we can take this 
to also include other useful code while we are at it.

Note that we must have this page always mapped and can't have it swapped, that is because we are going 
to do swapping with an exception, which won't work for us if it is swapped out...
