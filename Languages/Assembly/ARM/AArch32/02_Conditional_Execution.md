<!--
  Author:  @NE- https://github.com/NE-
  Date:    2023 June 18
  Purpose: Conditional execution notes for 32-bit ARM assembly
-->

# Conditional Execution
- Instructions with suffixes that will only execute if the condition is met.
- Act on the status of CSPR flags and do not alter it.
- Add `S` suffix ***AFTER*** the condition code.

## EQ
- Equal {`Z=1`}
- Executes when zero flag is set.
- If two numbers are equal, subtracting them will set the zero flag.
## NE
- Not Equal {`Z=0`}
- Execute when zero flag is clear.
- Subtracting two unlike numbers will clear the zero flag.
## VS
- Overflow Set {`V=1`}
- Execute when arithmetic operation resulted in an overflow.
## VC
- Overflow Clear {`V=0`}
- Execute if no overflow has occured.
## AL
- Always
- Always executes. Disregards CSPR.
- Commonly used with `B` for clarity and to have a three letter mnemonic.
## NV
- Never
- Never executes. Disregards CSPR.
- Commonly used to reserve space for data, for self-modifying code, or for ARM pipelining effects.
## HI
- Higher (Unsigned) {`C=1` and `Z=0`}
  - Numbers are assumed unsigned and are not being used in a twos compliment format.
- Execute if operand 1 is greater than operand 2.
## LS
- Lower than or Same (Unsigned) {`C=0` and `Z=1`}
  - Numbers are assumed unsigned and are not being used in a twos compliment format.
- Execute if operand 1 is less than operand 2.
## PL
- Plus Clear {`N=0`}
- Execute when arithmetic operation produced a result greater than or equal to 0.
## MI
- Minus Set {`N=1`}
- Execute when arithmetic operation produced a result less than 0.
- Execute when logical operation sets bit 31.
## CS
- Carry Set {`C=1`}
- Execute when arithmetic operation produced result greater than 32-bits.
  - Carry flag thought of as the "33rd bit."
## CC
- Carry Clear {`C=0`}
- Execute when arithmetic operation produced result that fits inside 32-bits.
## GE
- Greater than or Equal (Signed) {`N=1`,`V=1` or `N=0`,`V=0`}
- Execute if operand 1 greater than or equal to operand 2.
## LT
- Less Than (Signed) {`N=1`,`V=0` or `N=0`,`V=1`}
- Execute if operand 1 is less than operand 2.
## GT
- Greater Than (Signed) {`N=1`,`V=1` or `N=0`,`V=0` and `Z=0`}
- Execute if result is a positive number and not zero.
## LE
- Less than or Equal (Signed) {`N=1`,`V=0` or `N=0`,`V=1` or `Z=1`}
- Execute if operand 1 is less than or equal to operand 2.