<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 06
  Purpose: ARM64 Register notes.
-->

# General Purpose Registers
- 31 general purpose registers.
- 64-bit use 'X' (X0...X30), 32-bit use 'W' (W0...W30).
  - **Wn** is bottom 32-bits of **Xn**.
  - 32-bit registers result in 32-bit calculations.
  - When **Wn** register is used, top 32-bits of **Xn** are zeroed.
- Seperate set of 32 registers used for floating point and vector operations.
  - 128-bit in size, but can be broken down.
    - **Bx** is 8-bits.
    - **Hx** is 16-bits.
    - **Sx** is 32-bits.
    - **Dx** is 64-bits.
    - **Qx** is 128-bits.
  - **V** registers treated as *vector*.
```asm
// Vector float addition
FADD V0.2D, V1.2D, V2.2D
// Vector integer addition
ADD V0.2D, V1.2D, V2.2D
```

## Other Registers
- Zero registers **XZR WZR** always read as 0 and ignore writes.
- **SP** Stack Pointer.
  - Can be used for base address of loads and stores.
  - Can be used with limited set of data-processing instructions, but it is NOT general purpose.
  - Armv8-A has multiple stack pointers.
  - When **SP** is used in an instruction, it means *current* stack pointer.
- **X30** used as Link Register and can be referred to as **LR**.
- **ELR_ELx** used for returning from exceptions.
- Program Counter **PC** NOT general purpose and can NOT be used with data processing instructions.
  - **PC** can be read using `ADR Xd, .`
    - **ADR** returns address of a label, calculated based on current location (`.`), so it's returning the address of itself.
  - **PC** implicitly used with load/store operations.

> **PC** and **SP** are general purpose in A32 and T32 instruction sets, not A64.

# System Registers
- Used to configure processor and control systems such as MMU and exception handling.
- Can't be used directly by data processing or load/store instructions.
  - Have to be read into *X* register, operated on, then written back to system register.
```asm
// Two specialist instructions for accessing system registers

MRS Xd, <system register> // Read sysreg into Xd
MSR <system register>, Xn // Write Xn to sysreg
```
- System registers are specified by name e.g. `SCTLR_EL1`.
- End with `_ELx` which specifies minimum privilege necessary to access the register. If privilege is insufficient, an exception occurs.
  - `_EL1` requires privelege 1 or higher, `_EL2` 2 or higher, `_EL3` highest.
> `_EL12` or `_EL01` used for virtualization.
