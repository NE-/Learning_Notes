<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 19
  Purpose: C++ Data Types and Variables
-->

# Data Types
```cpp
/*
  Most used types
 */

// Character Types (integral. Usually signed)
char     // 1 byte
wchar_t  // 1 byte
char8_t  // 1 byte
char16_t // 2 bytes
char32_t // 4 bytes

// Integral Types
short     // 2 bytes
int       // 2-4 bytes
long      // 4 bytes
long long // 8 bytes

// Boolean Type
bool // 1 byte

// Floating-point (real) Types
float       // 4 bytes
double      // 8 bytes
long double // 8 bytes

// No Type
void // No size
```
- To find range, use: -2<sup>n-1</sup> to 2<sup>n-1</sup> - 1, where *n* is the number of bits.
  - Unsigned numbers use: 0 to 2<sup>n</sup> - 1.
- C++20 signed integers are two's complement.
```cpp
int i{ -1 };
i <<= 1; // -2

int j{ -1 };
j >>= 1; // -1 sign-extension
```

## Fast and Least
- For integral types, since the compiler handles the way types are represented, there is no guarantee the types will be exactly X bytes; this can be a waste of memory and risk of under/overflow is increased. Especially true for pre-64-bit computers.
- Guarantee at least or at most N bytes, *fast* and *least* integer types were introduced. Requires `cstdint` header.
- **Fast** integers give fastest integer type with a width of at least N (8, 16, 32, 64) bits.
  - Usually based on the machine's architecture.
- **Least** integers give smallest integer type with a width of at least N (8, 16, 32, 64) bits.
- *Prefer `int` if the number will always fit in a 2-byte range*.

# Initialization
## Copy Initialization
- Uses `=`. Copies RHS value into the variable on the left.
## Direct Initialization
- Uses `()`. Mostly seen with object creation and class variable initialization.
## List Initialization
- Uses `{}`. Assigns without the need to copy RHS (better performance) and used mainly with list-types.
- Empty braces initialize with `0` (or "empty" depending on type).
  - `{0}` used when you're *actually* going to use that 0.
  - `{}` used when the value will be replaced anyway.
- Highly recommended to use with modern C++ programming.
- Strict with assignment; doesn't allow for incompatible type assignment (narrow conversions) as Copy Initialization does.
  - Copy initialization will convert when necessary, which can cause data loss or even corruption.
```c++
// Initialization examples
// COPY
int pi = 3.14159; // Legal but causes data loss
int choice = 'a'; // Legal as char is integral
// DIRECT
MyClass b(3,1,4,"159");
// LIST
int a{ 5 };
int b{ 3.14159 }; // ERROR incompatible type!
int c{ 'a' };     // Legal
```

# Constants
- Compiler will swap out const variables with literals if it proves to be efficient.
- C++11 introduced `constexpr` to specify a constant *must* be resolved at compile-time.
  - `const` can be resolved at run-time.
- C++20 introduced `consteval` to specify a **function** *must* be evaluated at compile-time only.
  - `constexpr` implies a function *can* be evaluated at compile-time.
```c++
const double pi{ 3.14159 };
constexpr double sqrt3 { 1.7320508 };

int n {};
std::cin >> n;
constexpr int nStudents {n}; // ERROR must be resolved at compile-time

constexpr std::string str; // ERROR, use std::string_view instead
```

# Type Conversion
- Compiler will implicitly convert.
```cpp
void print(double x) {
  std::cout << x;
}

print(8);      // Implicit conversion
int x = 3.123; // Implicit conversion
print(x);      // Implicit conversion
```
- We can explicitly convert with `static_cast`.
```cpp
void print(int x) {
  std::cout << x;
}

print(static_cast<int>(5.5)); // Explicit conversion
                              // Compiler won't throw warnings

// char to int
char c{ 'a' };
std:cout << static_cast<int>(c); // 97

// Unsigned to signed
unsigned int u_i{ 3u };
int s_i { static_cast<int>(u_i) };
```