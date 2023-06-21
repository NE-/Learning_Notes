<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 17
  Purpose: Data processing notes for 32-bit ARM assembly
-->

# Data Processing
- `<Instruction> <Suffixes> <Destination>, <Operand 1>, <Operand 2>`
  - `<Destination>` is always an ARM register (R0 - R15).
  - `<Operand 1>` is always an ARM register (R0 - R15).
  - `<Operand 2>` can be an ARM register (R0-R15), value or constant, or shifted operand.

## Arithmetic Instructions
### Addition
- `ADD`: add operand 1 and operand 2 and store result in destination.
- `ADC`: add operand 1, operand 2, and **C**arry and store result in destination.
- Use `S` to alter CSPR.

```arm
/* Add two 64-bit numbers */
MOV R2, #0xFFFFFFFF @ lower half of first number
MOV R3, #0x1        @ upper half of first number
MOV R4, #0xFFFFFFFF @ lower half of second number
MOV R5, #0xFF       @ upper half of second number

ADDS R0, R2, R4     @ add lower and set flags
ADCS R1, R3, R5     @ add upper with carry
```
---
### Subtraction
- `SUB`: subtracts operand 2 from operand 1 and stores result in destination.
- `SBC`: subtracts operand 2 from operand 1, and the **C**arry and stores result in destination.
- `RSB`: subtracts operand 1 from operand 2 and stores result in destination.
  - **R**everse subtraction.
- `RSC`: subtracts operand 1 from operand 2, and the **C**arry and stores result in destination.
  - **R**everse subtraction.
- Use `S` to alter CSPR.
- ***Carry flag is used "backwards" or as a "NOT carry flag"***
  - If borrow generated, **C**arry is clear (0)
  - If borrow not generated, **C**arry is set (1)
  - **C**arry is inverted before using `SBC`.
---
### Multiplication
- Destination must be a register and not the same as operand 1.
  - `R15` can not be used.
- Operand 1 must be a register and not the same as destination.
- Operand 2 must be a register and not an immediate constant or shifted operation.
- `MUL`: multiply operand 1 and operand 2 and store result in destination.
- `MLA`: multiply operand 1 and operand 2 and add to a third operand and store result in destination.
```arm
MLA R0, R1, R2, R3 @ R0 = (R1 * R2) + R3
MLA R0, R1, R2, R0 @ R0 = (R1 * R2) + R0
```
- Use `S` to alter CSPR.

---
### Move
- `MOV <Suffixes> <Destination>, <Operand 2>`
- `MOV`: load operand 2 into destination.
- `MVN`: negate operand 2 then load into destination.
  - Used to move negative intermediate numbers.
  - (NOT n) + 1
```arm
MVN R0, #9 @ Move -10 into R0
MVN R0, #0 @ Move -1 into R0
MVN R1, R2 @ Move NOT R2 into R1
```
- Use `S` to alter CSPR.
---
### Compare
- `CMP`: compare operand 1 with operand 2.
  - Sets flags of operand 2 - operand 1.
- `CMN`: take logical NOT of operand 2 then compare with operand 1.
  - Sets flags of operand 2 + operand 1.
  - Logical NOT of operand 2 is taken (NOT n + 1).
    - Operand 2 *= -1.
  - Useful in loops that decrement past zero.
