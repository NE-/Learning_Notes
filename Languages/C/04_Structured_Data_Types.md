<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 13
  Purpose: C Structured Data Types
-->

# Structures
```c
// Declaration
struct mystruct /* tag */ {
  // Attributes
  char c_attr;
  int i_attr;
  float* fp_attr;
};

// Incomplete declaration
struct notDefinedYet;

struct mystruct a, b; // Define two variables
struct mystruct mystruct; // legal

// Attribute access
a.c_attr = 'e';
b.i_attr = 123;

// Variables can be defined immediately after
struct mystruct {
  char c_attr;
  int i_attr;
  float* fp_attr;
} ms1, ms2;

// Assign structs to each other (if same type)
ms1.c_attr = 'f';
ms2 = ms1; // All attributes copied

// Array of structs
struct mystruct mystructs[0xFF];

// Struct pointer
struct mystruct* ps;
// Attribute access
(*ps).c_attr = 'e';
ps->i_attr = 123; // Preferred
```
- Layout guarantees (applies to unions as well):
  - Members are allocated within structure in order of appearance in declaration and have ascending addresses.
  - No padding in front of first member.
  - address of struct same as address of first member.
  - Bit fields don't have addresses; conceptually packed into **_units_**.

# Unions
- Same as struct except struct members are allocated seperate consecutive chunks, whereas union members allocated same piece of storage (size of largest type).
  - Useful for "compact" structs, but require close maintenance.
- All members have same address; no padding in front of any.
- Only first member can be initialized (bitfields and padding ignored).
```c
union {
  float u_f;
  int u_i;
} var;

var.u_f = 3.1415;
var.u_i = 31415;
printf("%f\n", var.u_f, var.u_i); // 0.000000 31415

var.u_i = 31415;
var.u_f = 3.1415;
printf("%f\n", var.u_f, var.u_i); // 3.141500 1078529622

/*
  1078529622 could be
  interfering with IEEE 754
  floating point arithmetic.
  Likely the mantissa+exponent sections.
 */
```

# Bitfields
- Can only be declared inside `struct` or `union`.
- Used to specify small objects in size of bits.
- Useful for tight data packing.
  - Does not mean it's efficient! Can actually take up more time and space!
- Standard says fields packed into 'storage units' (machine words).
  - Force alignment with zero width field before the one you want aligned.
- Can be `const` or `volatile`.
- Do not have addresses.
  - No pointers to them or arrays of them.
- Rarely used.
```c
struct {
  unsigned field :4; // 4 bits wide
  unsigned       :3; // Unnamed field
                     // Used for padding

  signed field2 :1; // 1 bit. can only be -1 or 0 (2's complement).
} fieldsEx;
```

# Enums
- Aren't full-fledged in C, but help reduce number of `#define`s.
- Always integer constant.
```c
enum etag {
  a,     //  0
  b,     //  1
  c,     //  2
  d=20,  // 20
  e,     // 21
  f,     // 22
  g=20,  // 20
  h,     // 21
  i='3', // 51 char is integral type
  j,     // 52
  k      // 53
} var, *pe;

var = e; // No dot operator!

pe = &var;

int i = f; // Legal
```
