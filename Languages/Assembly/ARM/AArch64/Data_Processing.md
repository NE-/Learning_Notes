<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 06
  Purpose: ARM64 Data Processing notes.
-->

# Arithmetic and Logic Operation
## Format
```
<operation> <destination> <input register> <input register or constant>
```
- Operation: defines what instruction does.
  - **S** can be added to set ALU flags e.g. `ADD` becomes `ADDS`.
- Destination: where result of operation is always placed.
  - Always a register.
  - Some operations can have 2 destinations.
  - *W* registers zero out top 32-bits of corresponding *X* register.
- Operand 1: First input of instruction.
  - Always a register.
- Operand 2: Second input of instruction.
  - Register or constant.
  - When register, may include optional shift.
  - When constant, it's encoded within instruction (range of constants available is limited).
- `MOV MVN`  instructions moves constant or contents of another register into destiation register.

# Floating Point
- Same format as integer data-processing instructions.
- Instructions always start with an `F`.
- Floating point is mandatory in Armv8-A.
```asm
// H0 = H1 / H2
FDIV H0, H1, H2 // Half precision

// S0 = S1 + S2
FADD S0, S1, S2 // Single precision

// D0 = D1 - D2
FSUB D0, D1, D2 // Double precision
```
- Half-precision added in Armv8.2-A reported by `ID_AA64PFR0_EL1`.

# Bit Manipulation
- `BFI` inserts bit field into register.
- `UBFX` extracts a bit field.
```asm
W0: 00000000 10101100 01001110 01110100

/*
  BFI takes 6-bit field from W0 and inserts it 
  at bit position 9 in the destination register.
 */
BFI W0, W0, #9, #6
W0: 00000000 10101100 0[110100]0 01110100

/*
  UBFX takes 7-bit field from bit position
  18 in source register, places it in 
  destination register.
 */
UBFX W1, W0, #18, #7
W1: 00000000 00000000 00000000 0[0101011]

/*
  WZR is zero register that is always 0
 */
BFI W1, WZR, #3, #4
W1: 00000000 00000000 00000000 0[0000]011
```
- `REV16` reverses byte order in each halfword.
- `RBIT` reverses bit order in a 32-bit word.

# Extension and Saturation
- Convert data from one size to another.
- `SXTx` (signed extend) `UXTx` (unsigned extend) where *x* determines the size of the data being extended.
```asm
W0: 0x55 66 77 88

/*
  'B' takes bottom byte and sign extends
  to 32 bits.
 */
SXTB W1, W0
W1: 0xFF FF FF 88

/*
  'H' takes bottom 16 bits and zero
  extends to 32-bits.
 */
UXTH W2, W1
W2: 0x00 00 FF 88

/*
  'W' takes bottom word and sign
  extends to 64-bits
 */
SXTW X3, W2
X3: 0x00 00 00 00 00 00 FF 88
```

## Sub-register-sized Integer Data Processing
- If result larger or smaller than destination can hold, result is set to largest or smallest value of destination's integer range (saturating arithmetic).
- `SXTH`or `..., SXTH` used for saturating arithmetic.

# Format Conversion
