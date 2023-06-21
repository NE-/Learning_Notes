<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 18
  Purpose: Logical operation notes for 32-bit ARM assembly
-->

# Logical Operations
- `<Instruction> <Suffixes> <Destination>, <Operand 1>, <Operand 2>`
  - `<Destination>` is always an ARM register (R0 - R15).
  - `<Operand 1>` is always an ARM register (R0 - R15).
  - `<Operand 2>` can be an ARM register (R0-R15) or immediate value.
- Non-arithmetic operations that result in a '0' or '1'.
- Never a carry.

## AND
- Generates `1` if both bits are `1`; `0` otherwise.
- Useful for **masking** or **preserving** bits.

## ORR
- Generates `1` if either bit is `1`; `0` otherwise.
- Useful for **setting** bits.

## EOR
- Generates `1` if only one bit is `1`; `0` otherwise (both bits are identical).
- Useful to compliment, or invert, a number or bit.
  - EOR with all bits set to invert a number.
- `MVN` performs EOR on operand 2.

## BIC
- Sets or clears individual bits in registers or memory locations.
- Performs operand 1 AND NOT operand 2.
- Useful for clearing bits using `1`.
  - `BIC R0, R0, %1111` clears low 4 bits of R0.

## TST
- Tests bits on operand 1 with operand 2 as a mask.
- Performs logical AND and sets the zero flag if there is a match; reset otherwise.
- *Same as `ANDS` but the result is discarded.*

## TEQ
- Tests bits on operand 1 with operand 2 as a mask.
- Performs logical EOR and sets zero flag if both operands are equal; reset otherwise.
- Useful for checking if two numbers have the same sign.