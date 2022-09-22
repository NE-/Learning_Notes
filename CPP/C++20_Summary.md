<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 22
  Purpose: C++20 Concepts Summary
           Refer to https://en.cppreference.com/w/
           for details.
-->

# Feature Testing
- Simple portable way to detect precense of language and library features. [List](https://en.cppreference.com/w/cpp/feature_test).
  - *Tested* with conditional preprocessor macros.

# Source Code Information
- `std::source_location` (requires `<source_location>`) class represents information about the source code. Used mainly for logging, testing, or debugging purposes.
  - Alternative for `__LINE__ __FILE__`.
```cpp
void log(const std::string_view message,
         const std::source_location location = 
               std::source_location::current()) {
    std::cout << "file: "
              << location.file_name() << "("
              << location.line() << ":"
              << location.column() << ") `"
              << location.function_name() << "`: "
              << message << '\n';
}
 
template <typename T> void fun(T x) {
    log(x);
}
 
int main(int, char*[]) {
    log("Hello world!");
    fun("Hello C++20!");
}

/*
  Possible output
  file: main.cpp(23:8) `int main(int, char**)`: Hello world!
  file: main.cpp(18:8) `void fun(T) [with T = const char*]`: Hello C++20!
*/
```

# Coroutines
- Functions that suspend execution to be resumed later.
- Stackless: suspend execution by returning to caller and the data required to resume execution is stored seperately from the stack.
  - Allows asynchronouos code execution.
  - State stored in *heap* instead of stack.
- A function is a coroutine if it contains any of the following:
  - `co_await`: suspend execution until resumed.
  - `co_yield`: suspend execution returning a value.
  - `co_return`: complete execution returning a value.

# Formatting Library
- Safe and extensible alternative to the printf family functions. Complement existing C++ I/O stream libraries. [Link](https://en.cppreference.com/w/cpp/utility/format).

# `std::span`
- Object that can refer to a contiguous sequence of objects.
  - Can have static or dynamic extent.
  - Static extent has only one member: pointer to *T*.
  - Dynamic extent holds two members: pointer to *T* and a size.
- Members much like `std::vector`.

# Ranges Library
- Extension and generalization of the algorithms and iterator libraries. More composable and less error-prone.
  - [Constrained Algorithms](https://en.cppreference.com/w/cpp/algorithm/ranges).
- Creates and manipulates range *views* (lightweight objects that indirectly represent iterable sequences (ranges)).

# Mathematical Constants
- [New constants](https://en.cppreference.com/w/cpp/numeric/constants) in `<numerics>`.

# Clock
- [Additions](https://en.cppreference.com/w/cpp/chrono) to the chrono library.

# Modules
- Organization of C++ code into logical components.
- Using headers can cause macros leakage across header entrance and exit (by the preprocessor), inclusion-order dependencies, repetitive compilation of the same code (fixed by `-c`?), cyclic dependencies, poor encapsulation, etc. (**NEEDS RESEARCH**).
- [More detail](https://vector-of-bool.github.io/2019/03/10/modules-1.html).
```cpp
// Example basic implementation
// Not supported with C++20 yet (tested clang and gcc)

// speech.cpp
export module speech;

export const char* get_phrase() {
    return "Hello, world!";
}
// main.cpp
import speech;

import <iostream>;

int main() {
    std::cout << get_phrase() << '\n';
}
```