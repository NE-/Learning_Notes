<!--
  Author: NE- https://github.com/NE-
  Date: 2022 June 27
  Purpose: General notes for the Z80
-->

# General
- 4MHz, 1 byte registers, 16-bit address bus
- Format: [Operation Code] [Destination], [Source]
- Parenthesis used for indicating an address. `LD (HL), A` load A in the address held by HL. `LD HL, A` load A into HL.

# Registers
- 208 bits of read/write memory available (18 8-bit and 4 16-bit registers).
- Also contains two sets of Accumulator and Flag registers (one set being 'shadow' or 'complementary' registers) and 6 special-purpose registers.
## Accumulator (A)
- Holds the results of 8-bit arithmetic or logical operations.
## Flags Register (F)
- Each bit defines a "condition" we can use for testing (similar to an array of booleans).
- Used indirectly; set by mathimatical operations.
- Typically used with conditional jumps and calls
## High Low pair (HL)
- Used for storing memory locations. Special commands use it for quick read/write.
- Good for 16-bit maths (referred to as 16-bit Accumulator).
## Byte Counter pair (BC)
- Used for loop counters (max 65535).
- B can be used alone for max 255.
## Destination pair (DE)
- Like HL, DE is for destination e.g. `from HL, store in DE`.
## Index Registers (IX IY)
- Used to get memory by specifying a relative position.
- We use them with offsets e.g. IX+1 IX+2 IY+1 IY+2 etc.
-IXH (Hight) and IXL (Low) exist for us to use for whatever, but are slower than other registers.
## Program Counter (PC)
- Holds 16-bit address of current instruction being fetched from memory.
- Automatically incremented after contents transferred to the address lines.
- We shouldn't directly modify it; modified by calls, jumps, and return.
## Stack Pointer
- Holds 16-Bit address of current top of the stack (in RAM).
## Memory Refresh Register (R)
- Used for the system to know when to refresh the memory.
- ***DANGEROUS for personal use***.
- Can be used to get random numbers.
## Interrupt Page Address Register (I)
- Can be operated in a mode which an indirect call to any memory location can be made in response to an interrupt.
- Stores high order 8-bits  of the indirect address while interrupting device provides lower 8-bits.
- Allows for interrupt routines  to be dynamically allocated to anywhere in memory with minimal access time. 

# Flags
- Supply the user about status of Z80 CPU.
## Carry (C)
- Set if an addition generated a carry or if a subtraction generated a borrow, reset otherwise.
- Set if shifted out a '1' either on bit 0 (right) or 7 (left), reset if shifted a '0'.
- Set by using `SCF` (set carry flag), reset (accurately "complemented") by using `CCF` (compliment carry flag).
- Always reset when using `AND OR XOR`.
## Add/Subtract Flag  (N)
- AKA *Decimal Adjust Accumulator Flag*
- Used by `DAA` (BCD mode) to distinguish between `ADD` and `SUB`.
- Set when `SUB` instruction has been used.
- Reset when `ADD` instruction has been used.
## Parity/Overflow Flag (P/V)
- Set when the result in the Accumulator is greater than +127 or less than -128. Determined by examining the sign bits of the operands. *OVERFLOW*
- For addition, operands with different signs never cause overflow.
- For subtraction, overflow can occur for operands of unalike signs. Operands with alike signs never cause overflow.
- If carry in and no carry out, or if no carry in and yes carry out, then overflow has occured.
- Reset f number of 1 bits in a byte is odd, set if even. *PARITY*
- During `CPI CPIR CPD CPDR LDI LDIR LDD LDDR`, `P/V` monitors state of `BC` register if `BC` decrements to 0, flag is cleared to 0 else flag is 1.
- During `LD A,I` and `LD A,R` `P/V` set with value of `IFF2` (Interrupt Enable Flip-Flop) for storage or testing.
- When inputting byte from I/O device with `IN r,(C)`, `P/V` adjusted to indicate data parity.
## Half Carry Flag (H)
- Set or Cleared deending on the carry and borrow status between bits 3 and 4 of an 8-bit arithmetic operation.
- Used by DAA to correct result of packed BCD add or sub operation.
- Set if ADD Carry occurs from bit 3 to 4. SUB if a borrow from bit 4 occurs.
- Reset if ADD no cCarry occurs from bit 3 to 4. SUB no borrow from bit 4 occurs.
## Zero Flag (Z)
- Set if result is 0, reset otherwise.
- Arithmetic: set if Accumulator is 0.
- Compare/Search: set if Accumulator is equal to value in memory location in HL.
- Testing a bit (BIT b,r): Z contains complemented state of the indicated bit.
- I/O a byte between memory location and INI IND OUTI OUTD I/O device: Set if result of decrementing B is 0, otherwise reset.
## Sign Flag (S)
- Stores state of most significant bit in Accumulator (bit 7).

# Addressing Modes
## Immediate Addressing
- Byte after opcode contains the actual operand.  
`ADC 123`
## Immediate Extended Addressing
- 2 bytes after opcode contains the actual operand.  
`LD HL,$A123`
## Modified Page Zero Addressing
- Used with restarts to set the PC to an effective address in Page 0.  
`RST $20`
## Relative Addressing
- Used for displacement such as jumping. Also good for code relocation.
- It is ranged for performance (-126 to +129 from current memory location + 2).  
`JR -12`
## Extended Addressing
- Allows for 2 bytes of included address in the instruction.
- Mostly used for specifying a memory literal.  
`JP $1234 LD A,($A123)`
## Indexed Addressing
- IX or IY plus a displacement (signed 1 byte).  
`LD A,(IX-8)`
## Register Addressing
- Either source or destination are a register.  
`LD C, 9`
## Implied Addressing
- Opcode automatically implies one or more CPU registers as operands, such as A with aritmetic.
## Register Indirect Addressing
- 16-bit register (pair such as HL) used as a pointer to any memory location.  
`JP (HL)`
## Bit Addressing
- When using a bit instruction to set, reset, or test bits.  
`BIT 3,C`
## Addressing Mode Combinations
- Mixing addressing modes in instructions that have 2 operands.  
`LD E,(IX+1)`
