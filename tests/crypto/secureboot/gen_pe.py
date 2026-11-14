#!/usr/bin/env python3
"""Writes the PE images tests/crypto/secureboot uses: small PE32+ and PE32
EFI applications with sections out of table order, a .bss with no raw data,
and data after the last section, so every rule of the Authenticode digest
is exercised. Deterministic; rerun to regenerate."""
import struct, sys, os

def pe(plus, out):
    file_align, sect_align = 0x200, 0x1000
    sections = [  # (name, raw size, characteristics); placed out of order below
        (b".text", 0x400, 0x60000020),
        (b".data", 0x200, 0xC0000040),
        (b".bss", 0, 0xC0000080),
        (b".reloc", 0x200, 0x42000040),
    ]
    nsec = len(sections)
    opt_size = 240 if plus else 224
    headers = 0x400
    # Raw data placement: .data first in the file, then .text, then .reloc,
    # so file order differs from section-table order.
    order = [1, 0, 3]
    ptr = {}
    at = headers
    for i in order:
        ptr[i] = at
        at += sections[i][1]
    end_of_sections = at
    trailer = b"TRAILING-DATA-HASHED" + bytes(12)
    img = bytearray(end_of_sections + len(trailer))
    img[0:2] = b"MZ"
    struct.pack_into("<I", img, 0x3C, 0x80)
    img[0x80:0x84] = b"PE\0\0"
    struct.pack_into("<HHIIIHH", img, 0x84, 0x8664 if plus else 0x14C, nsec, 0, 0, 0, opt_size, 0x22 if plus else 0x102)
    o = 0x98
    struct.pack_into("<H", img, o, 0x20B if plus else 0x10B)
    struct.pack_into("<I", img, o + 16, 0x1000)          # AddressOfEntryPoint
    struct.pack_into("<I", img, o + 32, sect_align)
    struct.pack_into("<I", img, o + 36, file_align)
    struct.pack_into("<I", img, o + 56, 0x6000)          # SizeOfImage
    struct.pack_into("<I", img, o + 60, headers)         # SizeOfHeaders
    struct.pack_into("<I", img, o + 64, 0x1234ABCD)      # CheckSum (excluded from the digest)
    struct.pack_into("<H", img, o + 68, 10)              # Subsystem: EFI application
    nd_at = o + (108 if plus else 92)
    struct.pack_into("<I", img, nd_at, 16)
    st = o + opt_size
    for i, (name, size, ch) in enumerate(sections):
        e = st + 40 * i
        img[e:e + 8] = name.ljust(8, b"\0")
        struct.pack_into("<IIIIIIHHI", img, e + 8, 0x200, 0x1000 * (i + 1), size, ptr.get(i, 0), 0, 0, 0, 0, ch)
    for i in order:
        size = sections[i][1]
        img[ptr[i]:ptr[i] + size] = bytes((j * 7 + i * 31) & 255 for j in range(size))
    img[end_of_sections:] = trailer
    open(out, "wb").write(img)

d = sys.argv[1]
pe(True, os.path.join(d, "tiny64.efi"))
pe(False, os.path.join(d, "tiny32.efi"))
