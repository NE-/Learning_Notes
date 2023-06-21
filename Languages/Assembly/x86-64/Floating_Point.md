<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 August 27
  Purpose: General notes for x86-64 Floating Point.
-->

# Floating Point Instructions
- Use **Streaming SIMD Extensions** (SSE) registers xmm0-xmm15.
  - SIMD: Single Instruction - Multiple Data.

## Floating Point Registers
- Can be used with instructions operating single value in each register or on a vector of values. 
  - When used as a vector, XMM register can be used as 4 floats or 2 doubles.
- Core i series introduced Advanced Vector Extensions which doubled size of float registers. ymm0-ymm15 (8 floats or 4 doubles).

## Moving
- `movss` moves 32 bit floats. No implicit conversion.
- `movsd` moves 64 bit floats (double). No implicit conversion.
- `movaps` moves 4 floats. aligned 16 bytes. XMM
- `movapd` moves 2 doubles. aligned 16 bytes. XMM
- `movups` moves 4 floats. unaligned. XMM
- `movupd` moves 4 doubles. unaligned. XMM

## Addition
- Floating point adds don't set flags.
- `addss` adds 2 floats. scalar. Destination MUST be XMM.
- `addsd` adds 2 doubles. scalar. Destination MUST be XMM.
- `addps` adds 4 floats. packed. Destination MUST be XMM.
- `addpd` adds 2 doubles. packed. Destination MUST be XMM.

## Subtraction
- `subss` subtracts 2 floats. scalar. Destination MUST be XMM.
- `subsd` subtracts 2 doubles. scalar. Destination MUST be XMM.
- `subps` subtracts 4 floats. packed. Destination MUST be XMM.
- `subpd` subtracts 2 doubles. packed. Destination MUST be XMM.

## Multiplication
- `mulss` multiplies 2 floats. scalar. Destination MUST be XMM.
- `mulsd` multiplies 2 doubles. scalar. Destination MUST be XMM.
- `mulps` multiplies 4 floats. packed. Destination MUST be XMM.
- `mulpd` multiplies 2 doubles. packed. Destination MUST be XMM.

## Division
- `divss` divides 2 floats. scalar. Destination MUST be XMM.
- `divsd` divides 2 doubles. scalar. Destination MUST be XMM.
- `divps` divides 4 floats. packed. Destination MUST be XMM.
- `divpd` divides 2 doubles. packed. Destination MUST be XMM.

## Converting to Different Length
- `cvtss2sd` float to double. Destination MUST be XMM.
- `cvtsd2ss` double to float. Destination MUST be XMM.
- `cvtps2pd` 2 packed floats to 2 packed doubles. Destination MUST be XMM.
- `cvtpd2ps` 2 packed doubles to 2 packed floats. Destination MUST be XMM.

## Convert Float to/from Integer
- `cvtss2si` float to double or QW integer. rounded. Destination MUST be general purpose register.
- `cvtsd2si` double to double or QW integer. rounded. Destination MUST be general purpose register.
  - `cvttss2si` and `cvtts2si` convert by truncating.
- `cvtsi2ss` double or QW integer to float. Destination MUST be general purpose register.
- `cvtsi2sd` double or QW integer to double. Destination MUST be general purpose register.
  - When using memory location, must add "dword" or "qword" to instruction to specify the size.
```asm
cvtsi2sd xmm0, dword [x] ; convert dword integer
```

## Floating Point Comparisons
- *QNaN* (Quiet NaN) does not raise an exception.
- *SNaN* (Signaling NaN) always raises an exception when generated.
- "Ordered" comparisons cause floating point exception if operand is either QNaN or SNaN.
- "Unordered" cause exception only for SNaN.
- `ucomiss` compare floats. unordered.
- `ucomisd` compare doubles. unordered.
  - Set Zero, Parity, and Carry flags to indicate result: unordered (one operand is NaN), less than, equal or greater than.

### Conditional Jumping
 | instruction | jump if | aliases | flags |
 | ----------- | ------- | ------- | ----- |
 | jb | if < (floating point) | jc jnae | CF=1 |
 | jbe | if <= (floating point) | jc jnae | CF=1 or ZF=1 |
 | ja | if > (floating point) | jnbe | ZF=0, CF=0 |
 | jae | if >= (floating point) | jnc jnb | CF=0 |
```x86asm
movss   xmm0, [a]
mulss   xmm0, [b]
ucomiss xmm0, [c]
jbe     less_eq   ; jump if a*b <= c
```

## Mathematical Functions
### Min and Max
- `minss` minimum scalar for floats.
- `maxss` maximum scalar for floats.
- `minsd` minimum scalar for doubles.
- `maxsd` maximum scalar for doubles.
- `minps` minimum packed for 4 floats.
- `maxps` maximum packed for 4 floats.
- `minpd` minimum packed for 2 doubles.
- `maxpd` maximum packed for 2 doubles.
  - Destination MUST be XMM; source can be XMM or memory.
  - Result stored in destination.
```x86asm
movss  xmm0, [x] ; move x into xmm0
maxss  xmm0, [y] ; xmm0 has max(x,y)
movapd xmm0, [a] ; move a[0] and a[1] into xmm0
minpd  xmm0, [b] ; xmm0[0] has min(a[0],b[0])
                 ; xmm0[1] has min(a[1],b[1])
```
### Rounding
- `roundss` rounds 1 float.
- `roundss` rounds 1 double.
- `roundps` rounds 4 floats.
- `roundpd` rounds 2 doubles.
  - First operand must be XMM.
  - Third operand selects rounding mode.
    - 0: round, giving ties to even numbers.
    - 1: round down.
    - 2: round up.
    - 3: round toward 0 (truncate).

### Square Roots
- `sqrtss` 1 float square root.
- `sqrtsd` 1 double square root.
- `sqrtps` 2 float square roots.
- `sqrtpd` 2 double square roots.

### Sample Code
d = sqrt( (x<sub>1</sub>-x<sub>2</sub>)<sup>2</sup>+(y<sub>1</sub>-y<sub>2</sub>)<sup>2</sup>+(z<sub>1</sub>-z<sub>2</sub>)<sup>2</sup> )
```x86asm
; Find distance in 3D space

dist3d:
  movss  xmm0, [rdi]   ; x from point 1
  subss  xmm0, [rsi]   ; sub x from point 2
  mulss  xmm0, xmm0    ; (x1 - x2)^2
  movss  xmm1, [rdi+4] ; y from point 1
  subss  xmm1, [rsi+4] ; sub y from point 2
  mulss  xmm1, xmm1    ; (y1 - y2)^2
  movss  xmm2, [rdi+8] ; z from point 1
  subss  xmm2, [rsi+8] ; sub z from point 2
  mulss  xmm2, xmm2    ; (z1 - z2)^2
  addss  xmm0, xmm1    ; add x and y parts
  addss  xmm0, xmm2    ; add z part
  sqrtss xmm0, xmm0    ; sqrt whole and store in xmm0
  ret
```
d = x<sub>1</sub>x<sub>2</sub> + y<sub>1</sub>y<sub>2</sub> + z<sub>1</sub>z<sub>2</sub>
``` x86asm
; Find dot product of 3D vectors

dot_product:
  movss xmm0, [rdi]   ; get x1
  mulss xmm0, [rsi]   ; multiply with x2
  movss xmm1, [rdi+4] ; get y1
  mulss xmm1, [rsi+4] ; multiply with y2
  adds xmm0, xmm1     ; add results
  movss xmm2, [rdi+8] ; get z1
  mulss xmm2, [rsi+8] ; multiply with z2
  addss xmm0, xmm2    ; add 'z' result to whole
  ret
```

Horner's Rule
```x86asm
; Evaluate polynomial using Horner's Rule

horner:
  movsd xmm1, xmm0        ; use xmm1 as x
  movsd xmm0, [rdi+rsi*8] ; accumulator for b_k
  cmp   esi,  0           ; is degree 0?
  jz    done
more:
  sub   esi,  1
  mulsd xmm0, xmm1        ; b_k * x
  addsd xmm0, [rdi+rsi*8] ; add p_k
  jnz   more
done:
  ret
