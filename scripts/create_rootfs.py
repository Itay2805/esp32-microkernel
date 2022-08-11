#!/usr/bin/env python3
import os

from littlefs import LittleFS, lfs

fs = LittleFS(
    block_count=4096-4,
    block_size=4096,
    cache_size=256,
    lookahead_size=16,
    prog_size=256,
    read_size=4
)


def copy_file(orig, to):
    with open(orig, 'rb') as f:
        data = f.read()
    with fs.open(to, 'wb') as f:
        f.write(data)


#
# Place all the apps
#
fs.mkdir('/apps')

#
# Place the kernel in the root folder
#
copy_file('kernel/out/bin/kernel.bin', '/kernel')

#
# Save it
#
os.makedirs('out', exist_ok=True)
with open('out/rootfs.bin', 'wb') as fh:
    fh.write(fs.context.buffer)
