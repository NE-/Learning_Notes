<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 18
  Purpose: Shift and rotate notes for 32-bit ARM assembly
-->

# Shifts and Rotates
- `<Instruction> <Operand 1>`
  - `<Operand 1>` may be an immediate value or register.
    - Limited to 12-bit value (because of ARM encoding).
      - 8-bits for the numeric constant.
      - 4-bits for 16 different positions which the 8-bit value may be rotated to through an even number of positions.
    - 257 can't be used.
```arm
ADD R0, R1, #257 @ Invalid constant error

/* Bypass 257 constant error */
MOV R2, #256
ADD R2, R2, #1
ADD R0, R1, R2
```
- Performed by the barrel shifter; an internal ARM mechanism.
- Rotates do not have an arithmetic function.
  - Only used to move bits.
- Can not be used as a standalone instruction.
  - Implemented as an add-on to operand 2.
  - `MOVS R0, R1, LSL#1` shifts R1 and stores result in R0.
- Can affect conditional tests.
  - `MOVCSS R0, R1, ASR R2` executes if Carry flag is set.
- Can be used with:
  - `ADC ADD AND BIC CMN CMP EOR MOV MVN ORR RSB SBC SUB TEQ TST`
  - Also be used to manipulate index value of `LDR` and `STR`.
---
## Logical Shifts
- Shift left doubles the number; right halves it.

### LSL
- Logical Shift Left.
- MSB (bit 31) drops out into the Carry flag.
  - Value is lost if overwritten by another shift.
  - Useful for testing if overflow occured.
- Bit 0 is filled with a zero after a shift.
### LSR
- Logical Shift Right
- MSB (bit 31) goes right with a 0 taking its place.
- LSB (bit 0) drops into the Carry flag.

## Arithmetic Shifts
- Sign bit is preserved.

### ASL
- Arithmetic Shift Left
- Identical to `LSL`.
- ***Should not be used!***
  - Assemblers may throw an error or warning.
  - Use `LSL` instead.
### ASR
- Arithmetic Shift Right
- MSB (bit 31) is saved, and everything else is shifted right.
  - Value of bit 31 is extended to bit 30, but bit 31 is preserved.
- LSB (bit 0) drops into the Carry flag.
- Ensures division is correct for both positive and negative numbers.
---
## Rotations
- Only right rotations.
- No arithmetic significance.
- Used for bit shift patterns.
### ROR
- Rotate Right.
- Moves bits out from low end (LSB) and feeds to high end (MSB).
- Last bit rotated out is also copied into Carry flag.
- `ROL` not in arm. Simulate with 32-n `ROR` instructions.
### RRX
- Extended Rotate.
- No operand 1: only shifts right by one.
- Value of Carry flag dropped into bit 31 and bit 0 dropped into the Carry flag.
- Uses Carry flag as a 32<sup>nd</sup> bit which preserves all bits.