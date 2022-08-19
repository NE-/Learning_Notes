<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 12
  Purpose: General notes for the x86-64 instructions.
-->

# MOV
- `mov dst,src`
- If specify 8 or 16 bit register, remaining bits are unaffected; however, 32 bit registers set remaining bits to '0'.
## movsx
- Sign eXtend value to 16 or 32 bits.
- `movsxd` for double word values.
## movzx
- Zero eXtend value to 16 or 32 bits.

## Conditional MOV
- More profitable than using branching.
- `cmovz` mov if Z set.
- `cmovnz` mov if Z not set.
- `cmovl` mov if result negative.
- `cmovle` mov if result negative or zero.
- `cmovg` mov if result positive.
- `cmovge` mov if result positive or zero.

# NEG
- Performs two's complement of operand.
- Sets Sign and Zero Flag.

# ADD
- Integer addition.
## Flags 
- Overflow if addition overflows.
- Sign set to sign bit of result.
- Zero set if result is 0.
# SUB
- Integer subtraction.
- Flags same as `ADD`.
# MUL
- Unsigned integer multiplication.
  - `imul` for signed.
    - result stored in `rdx:rax` *high:low*.
# IDIV
- Returns 2 results: quotient and remainder.
- `rdx:rax` stores dividend.
  - `rax` quotient
  - `rdx` remainder
# NOT
- Inverts bits (~1=0 ~0=1).
# AND
- Bit **checker**
- 1 & 1 = 1
- 1 & 0 = 0
- 0 & 0 = 0
# OR
- Bit **setter**
- 1 | 1 = 1
- 1 | 0 = 1
- 0 | 0 = 0
# XOR
- Bit **flipper**
- 1 ^ 1 = 0
- 1 ^ 0 = 1
- 0 ^ 0 = 0
# SHL
- Shift left
- Same as `SAL`
# SAL
- Shift arithmetic left
- Same as `SHL`
# SHR
- Shift right
- Introduces zeros from left.
# SAR
- Shift arithmetic right
- Propogates sign bit into newly vacated positions on left (preserves sign).
# ROL
- Rotatae left
# ROR
- Rotate right
# BT
- Bit test
- Sets carry flag to value being tested.
# BTS
- Bit test and set
- Sets carry flag to value being tested.
# BTR
- Bit test and reset
- Sets carry flag to value being tested.
