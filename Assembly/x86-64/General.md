<!--
  Author: NE- https://github.com/NE-
  Date: 2022 July 11
  Purpose: General notes for the 6502
-->

# General
- Segment registers esentially obsolete.
- 16 general purpose registers with few specialized instructions.
- Little Endian.

# Floating Point
- Supports 32,64, and 80 bit floating point numbers (IEEE 754).  

| Bits | Type        | Exponent | Bias  | Fraction | Precision  |  
| ---- | ----------- | -------- | ----- | -------- | ---------  |  
| 32   | Float       | 8        | 127   | 23       | ~7 Digits  |  
| 64   | Double      | 11       | 1023  | 52       | ~16 Digits |  
| 80   | Long Double | 15       | 16383 | 64       | 19 Digits  |  
- `0xFF` represents ±inf.

# Memory

 