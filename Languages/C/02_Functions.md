<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 13
  Purpose: C Functions
-->

# Functions
- Nested functions are not supported to improve the run-time performance of C.

# Function Jargon
- **Declaration**: When a name has a type associated with it .
- **Definition**: Also a declaration, but storage is reserved for the named object.
  - For functions, when a body is provided.
- **Formal parameters**: Names used inside a function to refer to its parameters.
- **Actual argumets**: Values used as arguments when the function is actually called.

# Function Prototypes
- Biggest change in newer C standard.
- Function arguments are mandatory, but only used for backwards compatibility with old C and should be avoided.

# Argument Conversions
## Default
- Int promotions always applicable.
- If argument is `float`, converted to `double`.
## Standard
- When function is called without a prototype in scope, args undergo default argument promotions.
  - If number of arguments does not agree with number formal parameters to the function, behavior is undefined.
  - If function definition was not definition containing a prototype, then type of actual arguments after promotion must be compatible with types of formal parameters in definition after promotions applied. Otherwise, undefined behavior.
  - If function definition was definition containing prototype, and all types of actual arguments after promotion are not compatible with formal parameters in prototype, then behavior is undefined. Behavior is also undefined if prototype includes ellipsis.
- At point of calling function, if prototype is in scope, arguments are converted, as if by assignment, to types specified in prototype. Any args from ellipsis still undergo default argument conversions.

# Recursion
- `auto` keyword (for variables) automatically allocates and frees variable storage on entry and return.
  - Never used in practice since it's default for internal declarations and invalid for external ones. Prone to undefined behavior.

# Linkage
- Functions always **external**.
  - Functions have implicit `extern`.
- Anything internal to a function has no linkage.
  - Circumvent using `extern` keyword.
- Objects located at outermost level of the program are **external**.
- `extern` must be unique (no same names and/or types).
  - As all external objects must be unique.
- Single objects within a single source file are **internal**.
  - Prefix their declarations with `static` keyword. Changes external objects to internal.
 
 | Linkage | Object | Accessibility |
 | ------- | ------ | ------------- |
 | external | external | Throughout the program |
 | internal | external | A single file |
 | none | internal | Local to a single function | 

```c
/*
  Variable names unique only 
  to this file.

  Static variables always
  initialized to 0.
 */
static int tank[100];
static int fuel;
static void fill();

// Can be accessed from outside
int gas() {
  if (fuel == 0)
    fill();
  
  return (tank[fuel--]);
}

// Unique to this file
static void fill() {
  while (fuel < 100)
    tank[fuel++] = 1;
}
```
```c
// Example extern scope problem

void f1() {
  extern float ee;
}

void f2() {
  int i = ee; // ERROR: 'ee' undeclared
}
```

# Internal `static`
- Always initialized to 0.
- Retain value between entry and exit from statement containing declaration and only one copy of each one (initialized only once), which is shared between recursion calls.
```c
void rec() {
  static int depth;
  
  depth++;

  if (depth > 200) {
    printf("Excessive recursion\n");
    exit(1);
  }

  rec();
}
```

 | Declaration | Keyword | Linkage | Accessibility |
 | ----------- | ------- | ------- | ------------- |
 | external | none | external | entire program |
 | external | extern | external | entire program |
 | external | static | internal | single file |
 | internal | none | none | single function |
 | internal | extern | external | entire program |
 | internal | static | none | single function |