<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 16
  Purpose: C Libraries
-->

# Headers
- Standard headers: assert, ctype, errno, float, limits, locale, math, setjmp, signal, stdarg, stddef, stdio, stdlib, string, time.
- Library routines may be implemented as marcos which aslo have a *true* function that does the same job. To use the real function, undefine the macro with `#undef` or enclose its name in parentheses.
```c
func("Probably a macro");
(func)("Can't be a macro");
```
- Change **locale** to change behavior of library functions depending on native languages and customs.

## stddef
- Contains mostly types used in many headers, like `NULL`.
- Pointer difference type: `ptrdiff_t`
- `sizeof` returns `size_t`.
- Distance between member and start of struct: `offsetof`.
  - Doesn't work for bitfields (undefined behavior).
- Wide characters: `wchar_t`.

## errno
- Tells when library functions have detected an error via a particular value to indicate what went wrong (often -1).
  - 0 at program start-up, then never resets unless explicitly assigned to.
  - Should only inspect `errno` or, rarely, reset it.
- It's now a modifiable lvalue of type `int`.
- `EDOM ERANGE` expand to nonzero integral constant expressions. Used for `#if` directives.

# Diagnostics
- Use `assert` in `assert.h`.
  - Defined as a macro.
  - `assert(int <expression>)`
  - If expression is 0, `assert` will write a message, name of source file, line, and the expression; then `abort` is called which halts the program.
```c
assert(1 == 2);

/* Example output */
Assertion failed: 1 == 2, file main.c, line 15
```
- Disable assertions by defining `NDEBUG` *before* including `assert.h`. Expressions are not evaluated.

# Character Handling
- `isalnum(int c)` True if *c* alphabetic or digit.
  - `isalpha(c) || isdigit(c)`.
- `isalpha(int c)` True if `isupper(c) || islower(c)`.
- `iscntrl(int c)` True if *c* is control character (from the ASCII non-printing chacters).
- `isdigit(int c)` True if *c* is decimal digit.
- `isgraph(int c)` True if *c* is any printing character except space.
- `islower(int c)` True if *c* is lower case alphabetic character.
- `isprint(int c)` True if *c* is a printing character, including space.
- `ispunct(int c)` True if *c* is any printing character that is neither a space nor a character which would return true from `isalnum`.
- `isspace(int c)` True if *c* is either whitespace character (' ', '\f', '\n', '\r', '\t', '\v').
- `isupper(int c)` True if *c* is an upper case alphabetic character.
- `isxdigit(int c)` True if *c* is a valid hexadecimal digit.
- `tolower(int c)` Returns lower case equivalent if given upper case letter.
- `tolower(int c)` Returns upper case equivalent if given lower case letter.

# Localization
- Controls current locale. Use `locale.h`.
- `struct lconv` stores information about formatting of numeric values.
  - `CHAR_MAX` used to indicate that a value is not available in the current locale.
- ` char* setlocale(int category, const char* locale)`.
  - Category:
    - LC_ALL: Set entire locale.
    - LC_COLLATE: Modify behavior of `strcoll` and `strxfrm`.
    - LC_CTYPE: Modify behavior of character-handling functions.
    - LC_MONETARY: Modify monetary formatting information returned by locale-conv.
    - LC_NUMERIC: Modify decimal-point character for formatted I/O and string conversion routines.
    - LC_TIME: Modify behavior of `strftime`.
  - Locale:
    - "C": Select minimal environment for C translation.
    - "": Select implementation-defined 'native-environment'.
      - Implementaion-defined: Select other environments.
  - Normally `setlocale(LC_ALL, "C")`.

# Limits
- `float.h` and `limits.h`.
- Declare allowable values.
## limits.h

 | Name | Allowable Value | 
 | ---- | --------------- |
 | CHAR_BIT | >= 8 | Bits in a char
 | CHAR_MAX | If char signed:  >=+127<br>else >=255U | 
 | CHAR_MIN | If char signed: <=-127<br>else 0 |
 | INT_MAX | (≥+32767) |
 | INT_MIN | (≤-32767)
 | LONG_MAX |(≥+2147483647) |
 | LONG_MIN | (≤-2147483647) |
 | MB_LEN_MAX | (≥1) |
 | SCHAR_MAX | (≥+127) |
 | SCHAR_MIN | (≤-127) |
 | SHRT_MAX | (≥+32767) |
 | SHRT_MIN | (≤-32767) |
 | UCHAR_MAX | (≥255U) |
 | UINT_MAX | (≥65535U) |
 | ULONG_MAX | (≥4294967295U) |
 | USHRT_MAX | (≥65535U) |

# Mathematical Functions
- Floating point mathematical arithmetic `math.h`.
- **Domain error** if input argument is outside domain **HUGE_VAL**.
  - Square root a negative: `errno` set to **EDOM** and function returns implementation defined value.
- **Range error** if result of function cannot be represented as a double value.
  - If magnitude of result is too large, returns ±**HUGE_VAL** and `errno` set to **ERANGE**.
  - If too small, 0.0 is returned and `errno` value is implementation defined.
- Refer to `math.h` for extensive list of available functions!

# Non-local Jumps
- `setjmp` and `longjmp` (`setjmp.h`) allow for "non-local" goto alternative.
- `jmp_buf` stores information to make the jump.
  - `int setjmp(jmp_buf env);` initializes `jmp_buf`.
    - Always returns 0 on inital call, then returns non-zero when longjmp is called.
  - `void longjmp(jmp_buf env, int val);` makes the jump.
    - `val` can't be 0; it will be changed to 1 if encountered.
    - calling `longjmp` without a `setjmp` is unfedined behavior; possibly a crash.
    - Undefined behavior for nested `longjmp` chains.
```c
void func();
jmp_buf place;

main() {
  int retval;

  if (retval = setjmp(place)) {
    printf("Returned using longjmp %d\n", retval);
    exit(EXIT_SUCCESS);
  }

  func();
  printf("This should never be called\n");
}

void func() {
  // Set flow back to main
  // Returns 4 to setjmp
  longjmp(place, 4);
  printf("This should never be called\n");
}
```

# Signal Handling
- A signal is a condition that may be reported during program execution (can be ignored, handled, or used to terminate the program (default)).
- Many signals generated by the hardware or operating system or by signal-sending function `raise`.
- Signals defined in `signal.h`. Other implementations may have additional signals available!
  - **SIGABRT**: Abnormal termination.
    - *Abort*
  - **SIGFPE**: Erronous arithmetic operation (e.g. divide by 0 or overflow).
    - *Floating Point Exception*
  - **SIGILL**: Invalid object program detected.
    - *Illegal instruction*
  - **SIGINT**: Interactive attention signal. Usually generated by typing some "break-in" key in the terminal.
    - *Interrupt*
  - **SIGSEGV**: Invalid storage access (usually caused by storing value in object pointed by a bad pointer).
    - *Segment Violation*
  - **SIGTERM**: Termination reauest made to the program.
    - *Terminate*
- `signal` function allows you to specify action taken on receipt of a signal. Returns pointer to another function.
```c
  /*
    Pointed function takes int and returns void
    func arg takes in
    - SIG_DFL: Default signal handler
    - SIG_IGN: Used to ignore a signal
   */
  void (*signal(int sig, void (*func)(int)))(int);
```

```c
// Example exit program on interrupt signal

FILE* f_tmp;
void leave(int sig);

main() {
  (void) signal(SIGINT, leave);

  f_tmp = fopen("tmp", w);

  for(;;) {
    ...
    getchar(); // To get interrupt from user
  }
  // Unreachable
  exit(EXIT_SUCCESS);
}

/*
  Calling library functions from
  signal handler is not guaranteed
  to work in all implementations
 */
void leave(int sig) {
  fprintf(f_tmp, "\nInterrupted...\n");
  fclose(f_tmp);
  exit(sig);
}
```
- Program send signals to itself using `int raise(int sig)`.
  - `raise` returns 0 if successful, non-zero otherwise.
```c
void abort() {
  raise(SIGABRT);
}
```

# Variable Numbers of Arguments
- Must use `stdarg.h` to access arguments.
- Before accessing, must call `void vastart(valist ap, parmN)`.
  - **ap** used for other "va" functions.
  - **parmN** identifier naming rightmost parameter before `...`.
```c
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

int maxof(int, ...);
void f();

main() {
  f();
  exit(EXIT_SUCCESS);
}

int maxof(int n_args, ...) {
  register int i;
  int max, a;
  va_list ap; // Holds argument list values

  va_start(ap, n_args); // Initialize list
                        // Must be called before access

  max = va_arg(ap, int); // Extract argument and assign type

  for (i=2; i <= n; ++i) {
    if ((a=va_arg(ap, int)) > max)
      max = a;
  }

  va_end(ap);

  return max;
}

void f() {
  int i = 5;
  int j[256];
  j[42] = 24;
  printf("%d\n", maxof(3, i, j[42], 0));
}
```
