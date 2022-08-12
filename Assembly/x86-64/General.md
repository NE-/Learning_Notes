<!--
  Author: NE- https://github.com/NE-
  Date: 2022 July 11
  Purpose: General notes for the 6502
-->

# General
- Segment registers esentially obsolete.
- 16 general purpose registers with few specialized instructions.
- Little Endian.

# Floating Point
- Supports 32,64, and 80 bit floating point numbers (IEEE 754).  

| Bits | Type        | Exponent | Bias  | Fraction | Precision  |  
| ---- | ----------- | -------- | ----- | -------- | ---------  |  
| 32   | Float       | 8        | 127   | 23       | ~7 Digits  |  
| 64   | Double      | 11       | 1023  | 52       | ~16 Digits |  
| 80   | Long Double | 15       | 16383 | 64       | 19 Digits  |  
- `0xFF` represents ±inf.

# Memory
- Most modern CPUs have hardware mapped registers. Benefit is multiple people can each run a program which starts at the same address at the same time.
  - Perceive same **logical** address while using different **physical** address.
- Hardware maping registers can map 4096 bytes and 2 megabyte pages.
  - Linux uses 2MB pages for kernel and 4KB for other uses. Newer CPUs also support 1GB.
- Purpose is to translate upper bits of address from logical to physical address.
- Translation generally efficient and quick.
- Memory access highly restricted to their (program's) assigned page and restricted from reading/writing to/from other processes.
  - Assume 4KB page. Address translated based on page nuber and address within page.
  - `0x4000002220` 4096 = 2<sup>12</sup>, offset is right-most 12 bits (`0x220`). Page number is remaining (`0x4000002`).
  - Hardware register(s) translates number to physical address, for example `0x70000000` then both are combined to `0x70000220`.
 - Each process assigned 4 logical regions: text, data, heap, stack.
## text
- Lowest address.
- Doesn't grow.
## data
- Immediately above text segment.
- Above data is `.bss` (block started by symbol) which contains statically allocated data by the process (not stored in executable). Initial contents are '0'.
## heap
- Above data segment.
- Contains initialized data.
- Dynamically resizable region of memory used to allocate memory to a process.
## stack
- Mapped to highest address of a process.
   - Linux x86-64 it's `0x7FFFFFFFFFFF` or 131 TB. Max amount of bits allowed in logical address being 48 bits (47 bits all '1', 48th '0').
- Typically 16MB (depends on Kernel) therefore lowest valid address `0x7FFFFF000000`.