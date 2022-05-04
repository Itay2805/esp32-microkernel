# Flash 

We are going to use the internal flash for two main things:
- Storing installed apps
- Storing NVM variables

For this we are going to base ourselves on the UEFI Firmware File System 
set of formats, we are going to use them mostly because of how well tested
they are given every AMI UEFI bios essentially uses them, and they are 
optimized for flash devices, with all the downsides and upsides.

We are also going to support the Fault-Tolerant-Write design that edk2 (idr 
if it is part of the UEFI spec) provides, this should allow for flash updates
to work even if the board suddenly shuts down in the middle of a write. Allowing 
to restore the contents if needed.




