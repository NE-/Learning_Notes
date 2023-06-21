<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 19
  Purpose: C++ Pointers
-->

# Operators
- Address-of (unary `&`) returns the address of a variable; or more accurately, a pointer containing the address.
- Indirection operator (unary `*`) returns the value stored in the refrenced address.

```cpp
int i{0};

std::cout << i;     // 0
std::cout << &i;    // memory address of i (varies)
std::cout << *(&i); // Value held in memory address of i. 0 in this case
```

# Pointers
- Variable that holds a memory address type.
- Size of pointers typically same as the architecture (32-bit is 4 bytes, 64-bit is 8 bytes).
```cpp
int i{ 2 };
int* ptr_i{ nullptr }; // nullify

ptr_i = &i; // assignment

std::cout << &i;     // address of i
std::cout << ptr_i;  // address of i
std::cout << i;      // value in i (2)
std::cout << *ptr_i; // value in memory address of i (2)

*ptr_i = 100; // i is also 100
```
- Since pointers are variables, they themselves have memory addresses we can reference.
  - Use `**` which means "pointer to a pointer".

```cpp
/*
  Read from left to right
 */
int* p;     // Pointer to an int
int** pp;   // Pointer to a pointer to an int
int*** ppp; // Pointer to a pointer to a pointer to an int

// Example
int i { 3 };
int* p{ &i };
int** pp{ &p };
int*** ppp{ &pp };

std::cout << i;      // 3
std::cout << &i;     // 0xBC
std::cout << p;      // 0xBC

std::cout << &p;     // 0x12
std::cout << pp;     // 0x12

std::cout << &pp;    // 0x04
std::cout << ppp;    // 0x04

std::cout << i;      // 3
std::cout << *p;     // 3
std::cout << **pp;   // 3
std::cout << ***ppp; // 3
```
# Pointers and `const`
```cpp
// Read from right to left

/*
  Pointer to an int constant 
 */
const int* p;

/*
  Pointer to a constant int

  just east-const style
 */
int const* p;

/*
  Constant pointer to an int
 */
int* const p;

/*
  constant pointer to an integer constant
 */
const int* const p;

/*
  Pointer to a pointer constant
  to a pointer constant
  to a pointer to a pointer to int constant
 */
const int** const* const** p;
```
```cpp
// Example usage
int i{ 3 };
int j{ 4 };
const int* p{ &i }; // Integer is constant
*p = 33; // ERROR read-only int
p = &j;  // OK pointer is not read-only

/*
  const int reference requires const int*
 */
const int k{ 1 };
const int l{ 2 };

int* p{ &k }; // ERROR invalid conversion from const int* to int*
const int* p{ &k }; // OK
const int* const p2{ &l }; // OK as long as int is const

*p = 111; // ERROR int is read-only
p2 = &k;  // ERROR pointer is read-only
```
- Using `constexpr` requires static variables for compile-time resolution, which is undesired.
```cpp
static const int i {123};
constexpr const int* const p{ &i };
```

# Void Pointers
- AKA generic pointers, used to point to any data type. Possible since pointers are fixed-size (only hold addresses).
- Dereferencing requires casting (`auto` can be used as well).
  - Can lead to undefined behavior if wrong cast used.
```cpp
int i{ 5 };
double j { 4.56 };
void *p{ nullptr };

p = &i; // OK no cast required

// Doesn't know what type to print
std::cout << *p; // ERROR void is not a pointer-to-object type

std::cout << *static_cast<int*>(p); // Change to int* then dereference

p = &j; // OK no cast required
std::cout << *static_cast<double*>(p);
std::cout << *static_cast<float*>(p); // Legal
std::cout << *static_cast<char*>(p);  // Legal though wrong type
```

# References
- Used to *refer* to an object so we don't use the actual object.
- Behave the same as if using the indirection operator with a const pointer.
  - References *must* be initialized and cannot be reassigned.
- Objects are references with `&`.
```cpp
int i{ 2 };
int j{ 55 };
int& r { i };

r = j;  // i is now 55
r = 3;  // i is now 3
r += 3; // i is now 6

int& r2{9}; // Illegal
const int& r3{9}; // Legal
```
