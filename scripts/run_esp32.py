#!/usr/bin/env python3
import os
from dataclasses import dataclass
from typing import List, Optional

import littlefs
from tqdm import tqdm
from esptool import ESP32ROM, ESPLoader
from esptool.targets import CHIP_DEFS
from littlefs import LittleFS, lfs, LittleFSError

#
# Connect to the ESP32
#
esp = CHIP_DEFS['esp32']()
esp.connect()
print(f'Serial port {esp.serial_port}')

#
# Print info about the chip just in case
#
assert not esp.secure_download_mode
print(f'Chip is {esp.get_chip_description()}')
print(f'Features: {", ".join(esp.get_chip_features())}')
print(f'Crystal is {esp.get_crystal_freq()}MHz')
print(f'MAC: {":".join(map(lambda x: "%02x" % x, esp.read_mac()))}')

#
# Run the stub
#
esp: ESP32ROM = esp.run_stub()


def write_flash(offset, data):
    # Setup for flashing
    esp.flash_begin(len(data), offset)

    seq = 0
    while len(data) != 0:
        # get and pad the block
        block = data[:esp.FLASH_WRITE_SIZE]
        block = block + b'\xFF' * (esp.FLASH_WRITE_SIZE - len(data))

        # Send it
        esp.flash_block(block, seq)

        # Next step
        data = data[esp.FLASH_WRITE_SIZE:]
        seq += 1

    # Stub only writes each block to flash after 'ack'ing the receive,
    # so do a final dummy operation which will not be 'ack'ed
    # until the last block has actually been written out to flash
    esp.read_reg(ESPLoader.CHIP_DETECT_MAGIC_REG_ADDR)


# write the loader
write_flash(4096, open('loader/out/bin/loader.bin', 'rb').read())


# The offset from the start of the flash (in blocks) where
# the filesystem is located at
ON_FLASH_BLOCK_OFFSET = 4


class EspLfsContext(lfs.UserContext):

    def __init__(self):
        super().__init__(0)
        self._flash: List[Optional[int]] = [None] * 16 * 1024 * 1024

    def read(self, cfg: lfs.LFSConfig, block: int, off: int, size: int) -> bytearray:
        offset = block * cfg.block_size + off

        # Get the real data
        data = bytearray(esp.read_flash(offset + (cfg.block_size * ON_FLASH_BLOCK_OFFSET), size))

        # and override it with the written data
        for i in range(size):
            if self._flash[offset + i] is not None:
                data[i] = self._flash[offset + i]

        return data

    def prog(self, cfg: lfs.LFSConfig, block: int, off: int, data: bytes) -> int:
        offset = block * cfg.block_size + off
        for i in range(len(data)):
            self._flash[offset + i] = data[i]
        return 0

    def erase(self, cfg: lfs.LFSConfig, block: int) -> int:
        for i in range(cfg.block_size):
            self._flash[block * cfg.block_size + i] = 0xFF
        return 0

    def _sync_range(self, offset, data):
        print(f"SYNC CHUNK {offset:x}-{offset + len(data):x}")
        offset = offset + (ON_FLASH_BLOCK_OFFSET * 4096)
        write_flash(offset, data)

    def sync(self, cfg: lfs.LFSConfig) -> int:
        return 0

    def do_full_sync(self) -> int:
        print("SYNC START")
        offset = 0
        write_offset = -1
        while offset < len(self._flash):
            # find the next non-None byte
            if self._flash[offset] is None:
                if write_offset != -1:
                    # we need to write this range
                    self._sync_range(write_offset, bytes(self._flash[write_offset:offset]))
                    write_offset = -1
                offset += 1
                continue

            if write_offset == -1:
                # we found the first non-None byte
                write_offset = offset

            offset += 1

        # Commit the last change
        if write_offset != -1:
            self._sync_range(write_offset, bytes(self._flash[write_offset:offset]))

        print("SYNC END")

        self._flash = [None] * 16 * 1024 * 1024

try:
    ctx = EspLfsContext()
    fs = LittleFS(
        context=ctx,
        block_count=4096-4,
        block_size=4096,
        cache_size=256,
        lookahead_size=16,
        prog_size=256,
        read_size=4,
        mount=False
    )
    fs.format()
    fs.mount()

    rfs = LittleFS(
        block_count=4096-4,
        block_size=4096,
        cache_size=256,
        lookahead_size=16,
        prog_size=256,
        read_size=4,
        mount=False
    )
    rfs.context.buffer = open('out/rootfs.bin', 'rb').read()
    rfs.mount()

    paths = ['/']
    while len(paths) != 0:
        path = paths.pop()
        stat = rfs.stat(path)

        if stat.type == 2:
            # Add all the subdirs
            print(f'mkdir {path}')

            for file in rfs.listdir(path):
                paths.append(os.path.join(path, file))

            # Make sure it exists on the other side
            fs.makedirs(path, exist_ok=True)

        elif stat.type == 1:
            # This is a normal file
            print(f'cp {path} - {stat.size} bytes')

            # Read the wanted file
            with rfs.open(path, 'rb') as f:
                file_data = f.read()

            # Now write it
            with fs.open(path, 'wb') as f:
                f.write(file_data)

        else:
            assert False, "Unknown file type"

    ctx.do_full_sync()

finally:
    #
    # Hard reset in any case
    #
    esp.hard_reset()

os.system(f'picocom {esp.serial_port} -b {esp.ESP_ROM_BAUD}')
