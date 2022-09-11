<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 10
  Purpose: General C notes
-->

# Introduction
- Useful for writing compilers, operating systems, drivers, and other "systems" programs.
- C ideas stem from BCPL, but C is *typed* language.
- C offers only straightforward, single-thread control flow.

# Program Layout
- "Free format" language to enhance readability and highlight its logical structure.
```C
// String folding old C
printf("very very very very \
        very very long string!"
);

// Preferred folding (won't work in old C)
printf("very very very very "
       "very very long string!"
);
```
- Comments read as spaces by compiler.
```c
int/**/egral();
// Same as
int egral();
```

## Translation Phases
 1. Trigraphs
 2. Line joining
 3. Comment to space (white spaces may be condensed into one).
 4. Program

# Real Types
- `float.h` basic guarantees on precision and range of real numbers.
  - Mostly used by numeric analysts.
- Basic real types (lowest to highest precision): `float`, `double`, `long double`.
## Conversion (implicit up-down casting AKA pro/demotion)
- When two real types involved in an expression, lower precision type is implicitly converted to higher precision type then arithmetic is performed.
- With assignment, same rule applies *after* all arithmetic is completed.
- Higher to lower loses precision!
  - If destination is unable to hold the value, behavior is undefined.
- Mixed type conversions (e.g. integer to real) are implied.
## Printing
 | Type | Format |
 | ---- | ------ |
 | float | %f |
 | double | %f |
 | long double | %lf |

# Integral Types
- `limits.h` details number of actual bits available in a given implementation.
  - Actually minimum and maximum a variable type can hold.
  - `int` normally 16 bit but can be greater (16 is **NOT** guaranteed).
- `char` is integral type in C.
  - At least 8 bits.
  - Store a value of at least +127 and minimum is 0 (can be lower but the only guaranteed range is 0 to 127).
- Use `getchar` function to read char from STDIN (returns int for EOF catching).
```c
// Count commas and full stops given by STDIN

#include <stdio.h>
#include <stdlib.h>

main() {
  int inChar, commaCnt, stopCnt;

  commaCnt = stopCnt = 0;
  inChar = getChar();

  while (inCHar != EOF) {
    if (inChar == '.')
      stopCnt = stopCnt + 1;
    if (inChar == ',')
      commaCnt = commaCnt + 1;

    inChar = getchar();
  }

  printf("%d commas, %d stops\n", commaCnt, stopCnt);

  exit(EXIT_SUCCESS);
}
```
## Integral Promotion
- `short`, `char`, `bitfield`, `enum` promoted to int when:
  - int can hold all values of original type, otherwise unsigned int.

## Printing
 | Format | Use With |
 | ------ | -------- |
 | %c | char |
 | %d | signed int, short, char |
 | %u | unsigned int, short, char |
 | %x | hexadecimal int, short, char |
 | %o | octal int, short, char |
 | %ld | signed long |
 | %lu %lx %lo | as above, but for **long** |

# Type Casting
- Force type with `(<type>)`.

# Bitwise Operators
 | Operator | Effect | Conversions |
 | -------- | ------ | ----------- |
 | & | AND | usual arithmetic conversions |
 | \| | OR | usual arithmetic conversions |
 | ^ | XOR | usual arithmetic conversions |
 | << | left shift | integral promotions |
 | >> | right shift | integral promotions |
 | ~ | one's compliment | integral promotions |
- Left shift guarantees to shift zeros into low-order bits.
- Right shift can perform either logical or arithmetic shift on signed integers.
  - Unsigned guarantees logical. Best to cast unsigned when right-shifting `(unsigned)n >> 4`.
- Shift result is same type as the thing that got shifted (after integral promotions).

# Precedence and Associativity
 | Operator | Direction | Notes |
 | -------- | --------- | ----- |
 | () [] -> . | LtR | () for expression grouping |
 | ! ~ ++ -- - + (cast) * & sizeof | RtL | Unary |
 | * / % | LtR | Binary |
 | + - | LtR | Binary |
 | << >> | LtR | Binary |
 | < <= > >= | LtR | Binary |
 | == != | LtR | Binary |
 | & | LtR | Binary |
 | ^ | LtR | Binary |
 | \| | LtR | Binary |
 | && | LtR | Binary |
 | \|\| | LtR | Binary |
 | ?: | RtL | Ternary |
 | = += all combined assignments | RtL |  |
 | , | LtR | Binary |
