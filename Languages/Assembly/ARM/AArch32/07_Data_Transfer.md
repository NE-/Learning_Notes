<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 19
  Purpose: Data transfer notes for 32-bit ARM assembly
-->

# Data Transfer
- Load and store data into memory.

## ADR
- GCC directive/pseudo-instruction, not actual ARM instruction.
- `ADR <Register> <Label>`
- Calculates offset between the two memory positions.
```arm
ADR R0, val
MOV R1, #15

MOV R7, #1
SWI 0

val:
  .word 255

/* Assembled ARM code */
add r0, pc, #8
mov r1, #15
mov r7, #1
svc 0x00000000
```
- ***Values referenced by `ADR` must be within `.text` or executable section.***
  - ***Remember `.align` if necessary!***

## LDR
- Load to Register from memory
- `LDRB` write a single byte.
  - `B` must be at the end e.g. `LDREQB`.
## STR
- Store from Register to memory
- `STRB` store a single byte.
  - `B` must be at the end e.g. `STREQB`.

---
## Addressing Modes
### Indirect
- Reference or access memory via a register.
- `LDR <Suffixes> <Operand 1>, [<Operand 2>]`
  - `<Operand 2>` as a label: `=labelName`
    - No brackets.
- `STR <Suffixes> <Operand 1>, [<Operand 2>]`

### Pre-Indexed
- Add offset to base address.
  - Offset can be immediate constant or value in a register.
  - Subtract offset by placing minus sign in front of the offset.
    - Example: `#-8` or `-R2`
  - Rotate offset by using shift operators.
    - Example: `LDR R0, [R1, R2, LSR #4]` (R2 is shifted and added to R1).
    - Useful for traversing byte-aligned memory blocks.
- `LDR <Suffixes> <Destination>, [<base>, <offset>]`
- `STR <Suffixes> <Destination>, [<base>, <offset>]`
```arm
/* Replace third item in 4-Byte wide list with second item */
/* R1 holds start of the list */
MOV R2, #4               @ four byte offset
LDR R4, [R1, R2]         @ Load R4 from R1 + 4
STR R4, [R1, R2, LSL #1] @ Store R4 at R1 + 8

```
- Address write back by using `!`.
```arm
/*
  R1 holds some address
  R2 holds some index
  R1 + R2 = new address
  write back new address into R1
 */
LDR R0, [R1, R2]!

/* Single word step (useful for arrays) */
LDR R0, [R1, #4]!
```
- Offset limit: ±4096.

### Post-Indexed
- Uses write back by default.
- Offset is mandatory.
- Operand 1 is taken as source or destination, memory gets extracted or deposited, then offset (operand 2) is added to the base (operand 1) and base is overwritten with result of addition.
  - Offset is added **_post_** memory access.
- `LDR <Suffixes> <Destination>, [<Operand 1>], <Operand 2>`
- `STR <Suffixes> <Destination>, [<Operand 1>], <Operand 2>`

