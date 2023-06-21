<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 19
  Purpose: Program counter notes for 32-bit ARM assembly
-->

# Program Counter
- Register 15.
- Holds address of next instruction to be fetched.
- Can be used as operand 1, operand 2, and destination.

## Pipelining
- ARM executes an instruction, decodes a second, and fetches a third.

|  | Fetched | Decoded | Executed |
|--|---------|---------|----------|
| Cycle 1 | Op1 | empty | empty |
| Cycle 2 | Op2 | Op1 | empty |
| Cycle 3 | Op3 | Op2 | Op1 |
| Cycle 4 | Op4 | Op3 | Op2 |
> Takes 3 cycles to fill the pipeline at start of operation

> Cycle 4: PC holds address of Op4, the next one to be fetched

> **Newer models are more sophisticated**

- PC: next instruction to be fetched.
- PC-4: instruction being decoded.
- PC-8: currently executing.
- PC-12: previously executed.
  - ***Address held in PC is 8 bytes more than the address being executed***.

## Calculating Branches
- Branch value is 24-bit signed offset in twos compliment form.
- Word offset shifted left two places to form a byte offset then added to PC.
```arm
0x0100 BEQ zero
...
0x0120 BL notzero
...
0x1C30 zero: ...
...
0x2C30 notzero: ...

/* BEQ calculation */
> Instruction being fetched is two instructions later from current (8 Bytes)
0x1C30 - 0x0100 - 8 = 0x1B28

> Word offset
0x1B28 / 4 = 0x6CA

/* BL calculation */
> Instruction being fetched is two instructions later from current (8 Bytes)
0x2C30 - 0x0120 - 8 = 0x2B08

> Word offset
0x2B08 / 4 = 0xAC2
```
- Allows for relocatable code (no hardcoded memory addresses).
