<!--
  Author: NE- https://github.com/NE-
  Date: 2022 June 27
  Purpose: General notes to get started on assembly language programming
-->

# CPU
- "Calculator" as it reads in numbers and commands and calculates the results.
- Commands and their parameters usually read from memory and results stored back to memory (source and destination can be from other hardware).

## Endianness
- Sequence of bytes stored in memory.
- Name comes from "Gulliver's Travel" where two factions were split over which end of an egg should be eaten first.
### Big Endian
- Stores the *highest* byte first and lowest last.
- ***LEAST*** common!
- `$1234` stored as `$12 $34`
### Little Endian
- Stores the *lowest* byte first and highest last.
- ***MOST*** common!
- `$1234` stored as `$34 $12`

## Registers
- Built in memory on the CPU for storing parameters for calculations.
- Faster than RAM, but there's usually only a very few amount of registers (amounts vary by CPU).
- Constantly overwritten so they're referred to as *short-term storage*.

### Segment/Bank Registers
- Only exist in 20/24 bit address bus CPUs.
- Registers are still 16-bit, so that leaves 8-bits free for address calculation.
- Useful for allowing extra memory to be used while still being compatible with older programming methods. For example, if an old program can only be used within a `$0000` - `$FFFF` *logical address* range, with bank registers, it may actually be using `$120000` - `$12FFFF` *true address*.
`Segment $12 + address $3456 = $123456` 

### Base Pointer
- Used for efficiently traversing a memory range or to keep track of the start of a subroutine's stack frame.  
`Base Pointer $1234 + offset 1 = $1235`.
`Base Pointer $1235 + offset 1 = $1236`

### Index Registers (IR)
- Usually used for memory traversing.
- Common registers are IX and IY (I and X, I and Y)
- X and Y are usually slower than other registers therefore used for another purpose.

### Accumulator (A)
- Stores calculation results (one at a time).
- Older CPUs only had one 'A' register, newer ones (especially ARM) can have multiple accumulators.

### Program Counter (PC) / Instruction Pointer (IP)
- Points to the current address of the line being executed [of a program] by the CPU.

### Stack Pointer (SP)
- Stores an address (from RAM) that points to the current position of the call stack.

### Interrupt Mask Register (IMR)
- Used to enable or mask interrupts from being triggered.

### Flags (F) / Condition Codes (CCR)
- Boolean array (of bits) that sets a bit if a condition is met (by an instruction/command).
- Can also contain information for the CPU to behave a certain way.
- ***Which commands and conditions set and reset what flags is CPU dependent. Types of available flags and their order are CPU dependent***.
- *Undetermined State* - means a flag has been changed, but the change was unpredictable and/or useless.  
**⚠️ The following flag definitions/uses/triggers are just general ⚠️**

#### Carry Flag (C)
- Mostly used with *unsigned* numbers.
- Set when the result was too big to store in the register or if the result of a subtraction was negative
- Commonly used with shifting and rotating.
- Useful for combining registers to store larger values than a single register can contain e.g. on 8-bit systems, we combine two registers to store 16-bit numbers.

#### Half-Carry (H)
- Same as carry, but the carry is detected in the least significant nibble.
- Common when using binary coded decimal mode.

#### Sign Flag (S)
- Set if the accumulator evaluated to a negative number, reset if positive.
- Checks/stores bit 7 of the accumulator (assuming A is signed).

#### Zero Flag (Z)
- Set if the last instruction cased a register to equal zero, Reset otherwise.

#### Parity/Overflow (P/V)
- Mostly used with *signed* numbers.
- The instruction detremines if this flag is either referring to parity or overflow.
- Set if a register contains a value that exceeds its range. Checks if the sign bit changed. *OVERFLOW*
- Set if the number of set bits in the accumulator are even, reset if odd. *PARITY*

#### Add/Subtract (N)
- Set if the last instruction was a subtraction, reset if it was addition.
- Common when using binary coded decimal mode.



# Memory
- Storage for software.
- Referred to by a numeric address (usually 1 byte).
- *Address Bus* - wires that connect the CPU to Memory.
- *Bank Switching* - memory map "switches" between areas of memory. Useful for accessing more memory than within a given confined space.
- *Memory Mapped Ports* - We can access I/O ports from a normal memory space rather than with special commands. Machine dependent.

## RAM
- "Random Access Memory" meaning it can be written to and read from directly.
### Zero/Direct Page
- The first 256 bytes of memory (all have `$00` high byte; `$0000` - `$00FF`).
- Read and write is faster than memory, but slower than registers.
- We can omit the high `$00` byte when referencing this part of memory. This reults in a 1-byte call which is why it's faster to compute!
- AKA the *Direct Page* on systems with a Direct Page Register (D). ***The direct page might not always start on `$00`***

## ROM
- "Read-Only Memory" meaning we *can't* change its contents (read-only).

# Stack
- Temporary data storage. Useful when we need the current data later, but have to do another job now (e.g. subroutines) that may overwrite our registers.
- The current stack poisiton is stored in a *stack pointer*.
- Stack exists in RAM; the stack pointer is a CPU register.
- Stack operations normally have a *push* and *pop* operation.
- *Push* works by overwriting the current data that's stored in the current position (held by the stack pointer) with new data then either incrementing or decrementing (CPU dependent. How much varies, but it's usually two bytes) the stack pointer. Decrementing is more common (stack grows *downward* in this case).
- *Pop* works by writing the data stored in the current position of the stack pointer to a given register (can be CPU dependent) then either incrementing or decrementing (CPU dependent. How much varies, but it's usually two bytes) the stack pointer. `POP BC` will write the data to BC. Incrementing is more common (stack grows *downward* in this case).

# Interrupts
- These interrupt the CPU from it's normal flow to tend to another job. After the job is complete, the CPU returns to where it left off.
- Interrupts can be turned off to give higher priority to another job. Useful for making interrupt handlers do things that weren't meant to be done normally, like adding more colors in one screen than was restricted or make screen effects like wobbling.
- Interrupts usually deal with hardware.
- Modern CPUs do this asynchronously.
- Privilege modes on modern CPUs make this harder to do. Higher privleges that are not default accessible by the user usually deal with interrupts.
## Maskable (AKA IRQ - Interrupt Request)
- These are interrupts that can be disabled. Usually by setting a bit in the IMR.
- Maskable because they are safe to give lower priority without any repercussions.
- Higher response times than NMIs
## Non-Maskable (NMI)
- Cannot be disabled or ignored (CPU dependent).
- Used for high priority tasks (e.g. critical response time is needed) that can crash a system if interrupted.

# RST (Reset) / Traps
- Special commands that cause special subroutines to run. Machine dependent.
- Traps are also used for debugging and error-handling ("step" in debuggers).
- Relatable to interrupts, but not quite the same.