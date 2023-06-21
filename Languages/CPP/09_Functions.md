<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 19
  Purpose: C++ Functions
-->

# Functions
- Reusable sequence of statements designed to do a particular job.
- Nested functions not supported.
- If a function is set to return (non-void) and no return is given in the body, it causes undefined behavior.
  - Good compilers catch this anyway.
  - main() will implicitly return 0 if no return given.
  - Returning a value from a void function is a compiler error.

# Parameters and Arguments
- **Parameter**: variable used in a function.
- **Argument**: value passed from the caller.
```cpp
/*
  Pass by value
  Variables are just copies of the arguments.

  Fine for simple fundamental types,
  but inefficient for larger data structures.
 */
int add(int x, int y) {
  return x + y;
}
...
add(9, 5);

int x{3};
int y{345};
add(x, y);

/*
  Pass by reference
  Variables refer to arguments (not copies).
  Used to return multiple values instead of tuples or arrays.

  Also used to pass in large data structures
  that are inefficient to copy
 */
void change(int& a, int& b, int& c) {
  a = 1;
  b = 2;
  c = 3;
}
...
int a{ 2222 };
int b{ 2 };
int c{ 345 };
change(a, b, c);

change (1, 2, 4); // ERROR
const int d{ 9 };
change(a, b, d); // ERROR can't pass const reference if parameter isn't const


// Prefer const when object doesn't need to change
void printColor(const Color& color) {
  std::cout << color.r << '\n';
  std::cout << color.g << '\n';
  std::cout << color.b << '\n';
  std::cout << color.a << '\n';
}

struct Color {
  int r{ 0 };
  int g{ 0 };
  int b{ 0 };
  int a{ 0 };
};

Color wall{ 0x23, 0x06, 0xA6, 0xFF };
printColor(wall);

// Pass pointer by reference
// Read: Reference of a pointer to an integer
void ptr_passRef(int*& ptr) {
  ptr = nullptr;
}


/*
  Pass by address
  Copy of the address. Technically same as pass by value.
 */
void ptr_pass(int* ptr) {
  *ptr = 345;
}

int a{ 1 };
ptr_pass(&a); // a is now 345

// Arrays decay into pointers, so this is preferred
void printArr(const int* arr, const std::size_t n) {
  if (!arr) return; // Safe checking if pointer exists
                    // Else program may crash.

  for (std::size_t i{0}; i < n; ++i) {
    std::cout << arr[i] << ' ';
  }
  std::cout << '\n';
}

const std::size_t n{ 5 };
int arr[n]{ 1, 2, 3, 4, 5 };

printArr(arr, n);
```

# Inline Functions
- Functions have their own overhead (program halted, new stack frame is created, then execution continues. Afterwards, stackframe destroyed, local variables destroyed, then execution continues where we left off) and extra memory space.
- `inline` tells the compiler to replace any function call with the code itself (like a C function macro).
  - Most compilers already do this behind the scenes, so inline may not be necessary, but it's also not good to rely heavily on the compiler.
- This should mainly be used with small functions, especially one-line functions; larger functions may just be ignored by a good compiler.
```cpp
inline int add(int x, int y) {
  return x + y;
}

int sum{ add(23,56) };
// Replaced as
int sum{ 23 + 56 }; // More efficient
```

# Function Pointers
- Functions are just labels defined in a memory location, so they too can be pointed to!
```cpp
void sayHi() {
  std::cout << "Hi!\n";
}

// Pointer to a void function that has no parameters
void (*f_ptr)(){ &sayHi };

// Usage
f_ptr();
(*f_ptr)(); // Explicit call for older compilers


/*
  Function with parameters
 */
int inc(int a) {
  return ++a;
}

int (*f_ptr)(int){ nullptr };
// Both are the same!
f_ptr = &inc;
f_ptr = inc;  // Returns address of inc
f_ptr(9);


/*
  Function as parameter
 */
bool oldEnough(int age, int max, bool (*cmp)(int,int)) {
  return cmp(age, max);
}

bool isGreater(int a, int b) {
  return a > b;
}
bool isLess(int a, int b) {
  return a < b;
}

std::cout << 
  oldEnough(20, 25, isGreater)
    ? "Is"
    : "Not"
  << " old enough\n";

std::cout << 
  oldEnough(25, 20, isLess)
    ? "Is"
    : "Not"
  << " old enough\n";

// Type alias for legibility
using CmpFunc = bool(*)(int,int);
bool oldEnough(int age, int max, CmpFunc cmp) {
  return cmp(age, max);
}
```

## std::function
- Function-type wrapper that is a more complex function pointer (C++11 defined in `<functional>`).
```cpp
bool oldEnough(int age, int max, std::function<bool(int,int)> cmp) {
  return cmp(age, max);
}

// Use as pointer
std::function<int()> f_ptr{ &sayHi };
```

# Function Templates
- Used when we don't know what the type will be when used.
- The compiler will generate the right function at compile-time.
- Replaced function overloading.
```cpp
template<typename T>
T add(T a, T b) {
  return a + b;
}

// Usage
add<int>(1, 2);
add<double>(1.2, 2.3);
add<>(3, 6); // Legal, the compiler will determine type
add(23, 67); // Legal, the compiler will determine type

add(1, 2.3); // ERROR
add<double>(1, 2.3); // OK

// Multiple typenames
template<typename T, typename U>
T add(T a, U b) {
  return x = y;
}

/*
  C++20 
  can use auto to replace
  template syntax
 */
auto add(auto x, auto y) {
  return x + y;
}
```

# Lambdas
- AKA anonymous functions.
- Can be used to technically nest functions.
- `[<capture clause>](<parameters>) -> return-type {};`
```cpp
std::function add {
  [](int a, int b) {
    return a + b;
  }
};

auto add {
  [](auto a, auto b) {
    return a + b;
  }
};
```
## Capture Clause
- Captures variables outside the lambda. Constant copies by default.
```cpp
int i{};

[i]() {
  ++i; // Illegal. read-only variable
};
```
- Use `mutable` to make the copies mutable.
- The copies are also preserved!
```cpp
int a{ 0 };

auto inc{
  [a]() mutable {
    ++a;
    std::cout << a << '\n';
  }
};

inc(); // prints 1
inc(); // prints 2
std::cout << a; // prints 0
```
- To actually change the outside variable, capture by reference
```cpp
int a{ 0 };

auto inc{
  [&a]() {
    ++a;
    std::cout << a << '\n';
  }
};

inc(); // prints 1
inc(); // prints 2
std::cout << a; // prints 2
```
- You can capture every variable in the same scope as the lambda.
- Tokens *must* be first in the list
```cpp
// Capture all by value (constant copies)
[=]() {};

// Capture all by reference
[&]() {};

// Capture all by value, but a is referenced
[=, &a]() {};

// Capture all by reference, but a is a const copy
[&, a]() {};

// Capture a as const copy, b as reference
[a, &b]() {};

// Define new variable
// Type not needed
[nStudents{ 33 }]() {};

[a, &]() {};  // ERROR '&' must be first
[&, &a]() {}; // ERROR everything already captured as reference
[=, a]() {};  // ERROR everything already captured by value
[a, &a]() {}; // ERROR two instances of 'a'

[*this]{};    // Capture "this" by value (C++17)
[this]{};     // Capture "this" by reference (C++20)
```

## Template Parameter Lists
```cpp
// Until C++17
[](auto vector){
  using T = typename decltype(vector)::value_type;
  // use T
};
// since C++20:
[]<typename T>(std::vector<T> vector){
  // use T
};

// access argument type
// until C++20
[](const auto& x){
  using T = std::decay_t<decltype(x)>;
  // using T = decltype(x); // without decay_t<> it would be const T&, so
  T copy = x;               // copy would be a reference type
  T::static_function();     // and these wouldn't work at all
  using Iterator = typename T::iterator;
};
// since C++20
[]<typename T>(const T& x){
  T copy = x;
  T::static_function();
  using Iterator = typename T::iterator;
};

// perfect forwarding
// until C++20:
[](auto&&... args){
  return f(std::forward<decltype(args)>(args)...);
};
// since C++20:
[]<typename... Ts>(Ts&&... args){
  return f(std::forward<Ts>(args)...);
};

// and of course you can mix them with auto-parameters
[]<typename T>(const T& a, auto b){};
```