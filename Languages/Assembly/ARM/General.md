<!--
  Author:  @NE- https://github.com/NE-
  Date:    2022 July 06
  Purpose: General notes for the ARM processor
-->

# General
- All ARM instructions 32-bit long.
  - Stored word-aligned.
  - Least significant 2 bits always 0 in ARM state.
- Line length between 128 - 255 characters.
  - Assembler dependent? 
  - Just convention?
- Local labels begin with number 0-99
  - Scope limited by `AREA` directive. `ROUT` used to tighten scope.
- Constant `n_XXX` where *n* is base between 2 and 9 and *XXX* number in that base.
- Boolean TRUE and FALSE written as `{TRUE} {FALSE}`.
- Bi-endian since v3.
# Thumb
- CPU in ARM state cannot execute Thumb instructions and vice versa.
- Thumb is optimized for production by a C/C++ compiler.
- Instructions 16-bit wide and halfword-aligned in memory.
- Least significant bit of the address of an instruction is always 0 .
  - Helps instructions determine if code being branched to is Thumb or ARM.
- Most instructions can only access r0 to r7 (Low registers).
  - r8 to r15 (high registers) limited access registers. Used for fast temporary storage in Thumb state.


# Processor Modes
- All modes except user are referred to as *privileged* modes (because they service exceptions or access privileged resources).
## User
- Used for task protection.
- Programs can access resources they have permission for.
## FIQ - Fast Interrupt Request
- Higher priority, faster, lower latency; first when multiple interrupts occur.
- FIQ servicing disables IRQ until re-enabled by FIQ.
  - Done by restoring CSPR from SPSR at the end of the handler.
- Last entry of vector table (0x1C) to remove need of branching.
## IRQ - Interrupt Request
- Normal priority standard interrupt handler.
## Supervisor
- `SVC` instruction executed; allows for privileged level execution.
- Common in embedded applications.
## Abort
- Invalid memory access.
- Program terminated or OS sends signal.
## Undefined
- Invalid instruction encountered.
- Program terminated or OS sends signal.
## System (ARMv4+)
- OS runs at this level.
- Common in embedded applications.
## Monitor
- Monitor the system (feature in ARM procesors with security extensions).
## Hyp
- Hypervisor mode (optional ARM extension).
- Allows virtual hypervisor to run at more secure level than the OS it is virtualizing.


# Registers
- 37 Registers (arranged in partially overlapping banks; different bank for each mode).
- 15 general-purpose 32-bit registers are visible at any one time (depending on processor mode) as r0 ... r14.
- r0 can act as accumulator
- r7 holds syscall number
- r11 is FP (optional).
  - Points to area in stack used by subroutine for relative offsets
- r12 is IP (optional).
  - Used as backup for LR for subroutines.
- r13 is SP.
- r14 is LR (User mode). Can be used for general-purpose with caution.  
  - In exception handling modes, r14 holds return address for the exception or subroutine called within an exception.
## PC - Program Counter
- r15
- Incremented by four bytes in ARM state, two bytes in Thumb state.
- Branch instructions load destination address to PC.
- Load PC directly with data operation instructions.
  - `MOV pc, lr` to return from a subroutine.
- During execution, r15 does **NOT** contain address of current executing instruction.
  - Typically `pc-8` for ARM, `pc-4` for Thumb. 2 instructions ahead!
## CPSR - Current Program Status Register (CPSR)
- Contains copies of ALU status flags, current processor mode, interrupt disable flags.
- Also holds current processor state (Thumb-capable processors, both modes).
- On ARMv5TE, also holds Q flag.
## SPSR(s) - (Five) Saved Program Status Registers
- Holds CPSR when exception is taken.
- One SPSR accessible in each exception-handling modes.
  - User and System mode have no SPSR.

# Addressing Modes
- Immediate - fixed value *n*
  - `ADD R0, R0, #3`
- Register - value in register Rn
  - `ADD R0, R0, R1`
- Register shifted by immediate
  - `MOV R0,R1,ROR #3`
- Immediate offset
  - `LDR R0,[R1,#3]`
- Immediate pre-indexed
  - `LDR R0,[R1,#3]!`
- Regiser offset
  - `LDR R0,[R1,R2]`
- Register pre-indexed
  - `LDR R0,[R1,R2]!`
- Scaled register offset
  - `LDR R0,[R1,R2,LSL #3]`
- Scaled register pre-indexed
  - `LDR R0,[R1,R2,LSL #3]!`
- Immediate post-indexed
  - `LDR R0,[R1],#3`
- Register post-indexed
  - `LDR R0,[R1],R2`
- Scaled register post-indexed
  - `LDR R0,[R1],R2,LSL #3`

# ALU status flags
- *N* - result was *N*egative.
- *Z* - result was *Z*ero.
- *C* - operation resulted in a *C*arry
  - addition >= 2<sup>32</sup>.
  - subtraction >= 0.
  - Barrel shift or logical instructions.
- *V* - operation caused o*V*erflow.
  - addition|subtraction|compare >= 2<sup>32</sup>.
  - addition|subtraction|compare < -2<sup>31</sup>.
- *Q* - sticky flag (instruction can set, but can't clear). Used with special saturating arithmetic instructions or underflow.
  - Only E variants of ARMv5+.
- *J* - Jazelle. 
  - Allows for Java bytecode hardware execution.
- *GE* - Greater than or equal for SIMD.
- *E* - Endianess.
- *A* - Abort disable.
- *I* - IRQ disable.
- *F* - FIQ disable.
- *T* - Thumb.
- *M* - Processor/privilege mode.
  - `00`=user, `01`=FIQ, `10`=IRQ, `11`=Supervisor.
## Suffixes
- EQ - EQual **Z** set.
- NE - Not Equal **Z** clear.
- CS/HS - Higher or same (unsigned >=) **C** set.
- CC/LO - Lower (unsigned <) **C** clear.
- MI - Negative **N** set.
- PL - Positive or Zero **N** clear.
- VS - oVerflow **V** set.
- VC - no oVerflow **V** clear.
- HI - HIgher (unsigned >) **C** set and **Z** clear.
- LS - Lower or Same (unsigned <=) **C** clear or **Z** set.
- GE - Signed >= **N** and **V** same.
- LT - signed < **N** and **V** differ.
- GT - signed > **Z** clear, **N** **V** same
- LE - signed <= **Z** set, **N** **V** differ.
- AL - Always. Any. **NORMALLY OMITTED**
