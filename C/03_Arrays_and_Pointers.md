<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 13
  Purpose: C Arrays and Pointers
-->

# Arrays
- Collection of items of the same type.
- Indexes must be constant expressions that can be evaluated at *compile-time*.

## Multidimensional
- Just arrays of arrays.
```c
/*
  Array with 2 elements
  - each element is array of 3 elements
 */
int two3[2][3];

/*
  5 element array
  - with 4 element members
  -- which has members that are 2 element arrays
 */
int threeD[5][4][3];
```

# Pointers
- Pointer to \<type\> (no automatic conversions).
- `arr[n]` same as `*(arr+n)` (like assembly).
- `arr` same as `&arr[0]` (address of start of array).
- `*(&arr[n])` same as `arr[n]` same as `*(arr+n)`.
- `n[arr]` same as `arr[n]` (because `arr + n` same as `n + arr`).
```c
// Pointer to ar's index 3.
int *p = &ar[3];
// Assign ar[4] to 0
*(p+1) = 0; 
// Initialize array
/*
  Faster for sequential access
  1D arrays require one multiplication and one addition through subscripts
  Pointers require no arithmetic
 */
for (p = &ar[0]; p < &ar[20]; ++p)
  *p = 0;

// "Multiple" return
void date(int*, int*);

...
int month, day;
date(&month, &day); // month and day CAN be changed inside function
```

## Type Qualifiers
- Applied to declared type to modify its behavior.
- `const` makes variables unmodifiable.
- `const` argument pointers tell readers that values can't be changed in the function.
- `const` objects allow for optimization.
```c
const int c1 = 1; // Can't be changed
const int* pc; // Pointer to some constant int

int i;
int *const cp = &i; // Constant pointer to int
const int *const cp = &c1; // Constant pointer to integer constant

int *ip, *const i_cp;

i_cp = ip; // Valid
ip = i_cp; // Invalid
```

## Pointer Arithmetic
```c
/*
  Subtraction

  Returns short, int, or long (ptrdiff_t <stddef.h>)
  Casted to be long for compatibility safety
 */
#define SIZE 10

...

float arr[SIZE], *ap1, *ap2;

ap1 = ap2 = arr; // Point to first element

while(ap2 != &arr[SIZE]) {
  printf("Difference %d\n", (long)(ap2-ap1));
  ap2++;
}

...
```

## Relational Expressions
- Can only compare:
  - Pointers to compatible object types with each other.
  - Pointers to compatible incomplete types with each other.
- If 2 pointers compare equal, pointing to the same thing.
- If pointing to same array:
  - If one pointer is less than other, points nearer to the front of the array.

## Void, Null, and Dubious Pointers
- Can do implicit conversions with `void` pointers.
  - Old C used `char` pointers.
- `NULL` used to point to nothing (value is `((void*)0)`).
```c
int i;
int *ip;
void *vp;

ip = &i;
vp = ip;
ip = vp;
if (ip != &i)
  printf("Compiler error\n");
```

## Pointers to Functions
```c
void func(int);

...
void (*fp)(int);

fp = func; // func returns address; doesn't call

// Valid calls
(*fp)(1);
fp(2);
...


// Array of function pointers
void (*fps[])(int, float); = {
  /* initializer */
};

// Call one
fps[3](2,3.14159);

```

# Character Handling
```c
// Example read line until "stop"; otherwise print length

# define MAX 100 // Max input length

...
char input[MAX];
char *cp;
int c;

cp = input;

while((c = getc(stdin)) != EOF) {
  if (cp == &input[MAX-1] || c == '\n') {
    *cp = 0; // end of line marker

    if (strcmp(input, "stop") == 0) {
      exit(EXIT_SUCCESS);
    }
    else {
      printf("Line was %d chars long\n",
        (int)cp-input;
      );
      cp = input;
    }
  }
  else
    *(cp++) = c;
}
...
```
```c
// Basic strcmp

int basic_strcmp(const char* s1, const char* s2) {
  while(*s1 == *s2) {
    // End of line reached
    if (*s1 == 0)
      return 0; // Both equal
    s1++; s2++;
  }

  // Not equal strings
  return 1;
}
```

## Strings
- Array of char, but modifying them may cause undefined behavior (according to current Standard. Old C OK!), usually segfault.
  - String literal is `const char*`.
- Good practice to always terminate with 0 ('\0').
  - String literal automatically terminates.
```c
char* str   = "hello"; // Auto null
char str[]  = "hello"; // Auto null
char str[5] = "hello"; // No auto null since limit reached
char str[6] = "hello"; // Auto null since have extra space

