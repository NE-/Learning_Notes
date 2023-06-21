<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 14
  Purpose: C Preprocessor
-->

# Preprocessor
- Preprocessor directives are effective until the end of the file and always globally scoped regardless of block position.

# Directives
 | Directive | Meaning |
 | --------- | ------- |
 | #include | include source file |
 | #define | define a macro |
 | #if | conditional compilation |
 | #ifdef | conditional compilation |
 | #ifndef | conditional compilation |
 | #elif | conditional compilation |
 | #else | conditional compilation |
 | #endif | conditional compilation |
 | #line | control error reporting |
 | #error | force error message |
 | #pragma | implementation-dependent control |
 | # | null directive; no effect |

## define Directive
```c
// Macro
#define PI 3.14159

// Function macro
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define CALL(a, b) a b

...

if (PI) { // expands to if (3.14159)
  ...
}

int x = MIN(9,3); // Expands to int x = ((a) < (b) ? (a) : (b));

...

CALL(printf, ("%d %d %s\n", 1, 2, "Hello"));
/** Expands to **/
printf("%d %d %s\n", 1, 2, "Hello");

// Undefined behavior; missing token
CALL(,"hello");
```

- Be careful when using macros with expressions.
```c
#define DBL(x) x+x

printf("%d\n", DBL(2));
/** expands to **/
printf("%d\n", 2+2);

printf("%d\n", 3 * DBL(2));
/** expands to **/
printf("%d\n", 3 * 2+2); // 8 not 12

#define SQR(x) x*x
SQR(3+4); // Expands to 3+4 * 3+4. 3 + 12 + 4

/*
  FIX
 */
#define DBL(x) (x) + (x)
#define SQR(x) (x) * (x)
```

### Stringizing
- Using '#' "stringizes" a token. Trailing whitespace discarded.
```c
#define MSG(x) printf("%s\n", #x)

MSG(Text with "quotes");
/** Expands to **/
printf("%s\n", "Text with \"quotes\"");
```

### Token Pasting
- '##' joins tokens together. Can't be used at beginning or end.
- If joined tokens don't form a valid token, behavior is undefined.
```c
#define REPL replacement text
#define JOIN(a, b) a ## b

JOIN(RE, PL);
/** Becomes **/
REPL
/** After rescan **/
replacement text
```

### Rescan
- When macro names are replaced.
- Nesting is possible and multiple rescans can occur.
  - Macro names not replaced become tokens which are immune to replacement (prevents infinite recursion).
```c
#define m(x) m((x)+1)

m(abc);
/** expands to **/
m((abc)+1); // Replacement stops here

m(m(abc));
/** inner 'm' replaced first **/
m(m((abc)+1))
/** expands to **/
m(m((abc+1))+1);
```
### undef
- Undefines a macro (name is forgotten).

## include Directive
- At least 8 nested levels supported.
- In regards to file name, upper and lowercase distinctions may be ignored and implementations may only use size significant characters before the '.' character.
```c
#include <stdlib.h> // Search system libs
#include "myfile.h" // Search project

#define SRC <stdio.h>
#include SRC // Valid but not recommended
```

## Predefined Names
```c
__LINE__ // Current line number. Const int.
__FILE__ // Name of current file. String literal.
__DATE__ // Current date (MMM DD YYYY). String literal.
         // Month name defined in asctime lib function.
         // Date is [space]D if day > 10
__TIME__ // Time of translation (hh:mm:ss def. in asctime). String literal
__STDC__ // Integer constant '1'. 
         // Used to test if compiler is Standard-conforming.
```
- Can't be used with `#define` or `#undef`.

## line Directive
- Sets value of `__LINE__` and `__FILE__`.
  - Never really used for standard C programming.
- `#line <line number> <file name>`

## Conditional Compilation
- Used for selective compilation or ignoring depending on met condition(s).
- Useful for compiling machine-dependent code.
```c
#ifdef NAME
  /* Compile this if NAME defined */
#endif
#ifndef NAME2
  /* Compile this if NAME2 is not defined */
#else
  /* Compile this if NAME2 is defined */
#endif

// defined example
#define NUM 100

#if ((NUM > 50) && (defined __STDC__))
  ...
#elif NUM > 25
  ...
#else
  ...
#endif
```

## pragma Directive
- Allows implementation-defined things to take place.
  - **_Same thing could mean something else in different implementations!_**
- If implementation was not recognized, it is ignored.
- Useful for including local project header files once and only once; otherwise it is rarely used.
```c
// Tell implementation to align all struct members on byte addresses.
// - word-sized struct members on byte addresses slow down member access speed.
#pragma byte_align
```