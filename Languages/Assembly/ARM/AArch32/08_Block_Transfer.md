<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 19
  Purpose: Block transfer notes for 32-bit ARM assembly
-->

# Block Transfer
- Multiple load and store for efficient data movement.
- `LDM <Options> <Suffixes> <Operand 1>(!), {<Registers>}`
- `STM <Options> <Suffixes> <Operand 1>(!), {<Registers>}`
  - `<Operand 1>` start of memory to be used.
    - Changed only with write back operator `!`.
  - `<Registers>` is a list of registers (in any order) seperated by commas or ranged by a hyphen
    - Examples: `{R1, R3, R2}`, `{R1-R5}`, `{R1, R5-R8}`
```arm
/*
  R0 holds start of memory block
  [R0]    overwritten with R1
  [R0+4]  overwritten with R5
  [R0+8]  overwritten with R6
  [R0+12] overwritten with R7
  [R0+16] overwritten with R8
 */
STM R0, {R1, R5-R8}

/* Save and restore registers */
STMIA R0, {R1-R14}
LDM R0, {R1-R14}
// LDM to restore R15 may cause infinite loop
```
## Counting Suffixes
- Change how increment step is handled.
- `IA` Increment After
- `IB` Increment Before
- `DA` Decrement After
- `DB` Decrement Before
- `I`ncrement: Address = Address + 4 × n
- `D`ecrement: Address = Address - 4 × n
  - Where 'n' is number of registers in register list.
- `B`efore memory has been accessed.
  - Skips base memory address.
- `A`fter memory has been accessed.