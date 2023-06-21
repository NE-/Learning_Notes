<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 17
  Purpose: Advanced multiplication notes for 32-bit ARM assembly
-->

# Advanced Multiplication
- Deal with numbers up to 64-bits long.
- Cannot use `PC`, and `SP` is not supported in some later ARM chips.

## Long Multiplication
- `<Instruction> <Suffixes> <Destination Lo>, <Destination Hi>, <Operand 1>, <Operand 2>`
  - `<Destination Lo>` and `<Destination Hi>` should be different.
- Use two registers containing 32-bit operands.
  - 64-bit result is split across two destination registers.
### SMULL
- Signed Long Multiplication
- Operands assumed to be in two's complement form.
### UMULL
- Unsigned Long Multiplication
---
## Long Accumulation
- Operands 1 and 2 are multiplied together and result added to value in destination lo and hi.
### SMLAL
- Signed Long Multiplication with Accumulator
- `SMLA<x><y> <Suffixes> <Destination>, <Operand 1>, <Operand 2>, <Operand 3>`
  - `<x>` and `<y>` can be either `B` (Bottom two bytes) or `T` (Top two bytes).
  - `SMLABTCC R0, R1, R2, R3` 
    - If Carry clear, Bottom half-word of R1 is multiplied with top half-word of R2. 
    - Result added to R3 and stored in R0.
- `SMLAW<y> <Destination>, <Operand 1>, <Operand 2>, <Operand 3>`
  - Signed Multiply Wide
  - Multiplies signed 16-bit integer from selected half of operand 2 by 32-bit integer operand 1, adds top 32-bits of 48-bit result to 32-bit value in operand 3, then stores in destination.
  - 16-bit by 32-bit multiplication with accumulator.
### UMLAL
- Unsigned Long Multiplication with Accumulator
- `<Instruction> <Suffixes> <Destination Lo>, <Destination Hi>, <Operand 1>, <Operand 2>`
- Multiply operand 1 by operand 2, and store result to destination Hi and Lo.
---
## Simple Multiplication Tricks
```arm
/* Multiply by a factor of 2 */
MOV R0, R0, LSL #n @ R0 * 2^n

/* Multiply by (2^n)+1 */
ADD R0, R0, R0, LSL #n

/* Multiply by (2^n)-1 */
RSB R0, R0, R0, LSL #n

/* Multiply by 6 */
ADD R0, R0, R0, LSL #1 @ Multiply by 3
MOV R0, R0, LSL #1     @ Multiply by 2
```