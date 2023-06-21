<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 17
  Purpose: General notes for 32-bit ARM assembly
-->

# Registers
- User mode: 16 registers that hold 4 Bytes (one word) each.
- `R0 - R12`: general purpose.
  - `R7` used with system calls (stores syscall number).
  - `R11` can be a Frame Pointer.
  - `R12` can be Intra Procedural Call (backup of LR subroutines).
- `R13`: stack pointer (can be used for general purpose).
  - Contains an address pointing to an area of memory where we can save information (stack).
  - Not limited to one stack.
- `R14`: link register (can be used for general purpose).
  - Holds address of instruction after`BL` (when executed).
  - GCC: refer as `R14` or `LR` in code.
- `R15`: program counter (can be used for general purpose, though *NOT* recommended).
  - Keeps track of where your program is in execution.
  - Holds the next instruction's address to be fetched (8 Bytes ahead).
    - Reading `PC` gives current address + 8 (2 instructions)
  - Mistreatment can cause the program to crash. ***Fragile***.
  - GCC: refer as `R15` or `PC` in code.
## CPSR
- Current program status register.
- Holds information about the current program and results of operations it has carryed and is carrying out.
- Only `CMP` and `CNV` have direct effect on the status register.
  - `S` suffix allows for other instructions to alter the status register.
### Flags
- `N` - Bit 31 (**N**egative)
  - Signifies potential negative number.
- `Z` - Bit 30 (**Z**ero)
  - Signifies if the result was zero.
- `C` Bit 29 (**C**arry)
  - Holds carry bit.
- `V` Bit 28 (O**v**erflow)
  - Signifies if the operation caused a carry from bit 30 to 31.
    - Arithmetic caused a positive number to be negative.
- Bits 27 to 8 unused
- `I` Bit 7
  - IRQ disable
- `F` Bit 6
  - FIQ disable
- `T` Bit 5
  - Thumb mode (v4 only)
  - Indicates processor state.
- Bits 4 - 0 indicate the processor/privilege mode.
  - `00` user
  - `01` FIQ
  - `10` IRQ
  - `11` Supervisor