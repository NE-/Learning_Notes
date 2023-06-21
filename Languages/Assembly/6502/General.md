<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 June 27
  Purpose: General notes for the 6502
-->

# History
- Small group of Motorola employees from Phoenix, AZ quit their jobs to create an affordable microprocessor.
- Moved to Pennsylvania and collaborated with MOS Technology, Inc. employees to create an 8-bit microprocessor that is smaller, cheaper, and faster than modern (1974-1975) microprocessors.
- Accomplished in 1975, the cost of computers dropped significantly which allowed for personal computers to become normal in households.
- 6502 was also used in numerous electronics other than just desktop computers and throughout pop-culture.

# General
- 1-3MHz, 1 Byte registers, 16-bit address bus.
- Stack pointer is only 8-bits
- No 16-bit registers, so we need to split addresses into High and Low bytes with < (Low), > (High).  
  - `#<$1234` is `#$34`
  - `#>$1234` is `#$12`

# Registers
## Accumulator (A)
- Used for doing mathematical operations.
## Flags (F) / Status Register (SR)
- Stores "conditions" after an instruction has been executed.
- Used for conditional operations.
## Indirect X (X)
- For address indexing.
## Indirect Y (Y)
- For address indexing.
## Stack Pointer (SP)
- Holds 8-Bit address of current top of the stack.
- Normally starts at `$0100+SP` where `SP` is <= `$FF`.  
## Program Counter (PC)
- Holds 16-bit address of current instruction being fetched from memory.

# Flags
⚠️ Descriptions may vary from instruction to instruction! ⚠️
## Negative (N)
- Set if register value is less than input value with comparison.
- Set if result was negative; bit 7 was set.
## Overflow (V)
- Set if signed overflow occured from addition or subtraction.
  - If sign of result differes from sign of input and accumulator.
- Set to bit 6 of operand of `BIT` instruction.
## BRK (B)
- Set if an interrupt request has been triggered by `BRK`.
## Decimal Mode (D)
- Mathematical instructions will treat literal numbers as decimal numbers.
## IRQ Disable (I)
- Disables interrupts when set.
## Zero (Z)
- Set if register value equal to input with comparison.
- Set if logical `AND` (with Accumulator) resulted to 0.
- Set if mathematical operation resulted in 0.
## Carry (C)
- Set if unsigned overflow occured with mathematical operations.
  - Result is less than the initial value (or equal if carry was set).
- Set if register greater than or equal to input with comparisons.
- Set to value of eliminated bit of the input with shifting.

# Addressing Modes
## Implied/Inherant
- Needs no parameters; operand is implied.  
`TXA`
## Relative
- Uses Program Counter with offset *nn* (-128 to +127).  
`BPL $12`
## Accumulator
- Accumulator is the parameter.  
`ASL`
## Immediate
- Byte *nn* is parameter.  
`LDA #$56`
## Absolute
- Parameter is 2-Byte memory address *`$nnnn`*.  
`LDX $ABCD`
## Absolute Indexed
- Parameter is 2-Byte memory address *`$nnnn+X`* (or Y).  
`INC $2022, Y`
## Zero Page
- Parameter is zero page address *`$00nn`*.  
`LDX $34`
## Zero Page Indexed
- Parameter is zero page address *`$00nn+X`*.  
`LDA $01,X`
## Indirect
- Parameter from pointer at address *`$nnnn`*. Only used with `JMP`.  
`JMP ($B453)`
## Indirect ZP
- 65c02 can read from an unindexed Zero Page.  
`LDA $01,X`
## Pre-Indexed (Indirect,X)
- Parameter from pointer at address *`$nnnn+X`*.  
`STA ($23,X)`
## Post-Indexed (Indirect),Y
- Parameter from pointer at address *`$nnnn`* then add Y.
- If `$1234`, and `Y = 4`, address reads from `$1234` *then* 4 will be added.  
`EOR ($2A),Y`