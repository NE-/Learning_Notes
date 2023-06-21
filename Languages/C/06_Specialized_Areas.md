<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 14
  Purpose: C Specialized Areas
-->

# Definitions, Declarations, and Accessibility
## Storage Class Specifiers
- Specify type of storage used for data objects.
  - `extern`, `auto`, `register`, `static`.
- External declaration (and functions) default is `extern`; internal is `auto`.
### Duration
- Whether storage allocated once only, at program start-up, or is more transient in nature (allocated and freed as necessary).
- **Static duration**: storage allocated permanently.
- **Automatic duration**: storage allocated and freed as necessary.
  - Declaration is inside a function.
  - *AND* declaration does not contain `static` or `extern` keywords.
  - *AND* declaration is not declaration of a function.
- `register` uses hardware registers for storage.
  - Don't have address ('&' is forbidden), using too many may slow down the program (compiler has to save registers or registers may run out), and should only be used with machine-specific choices (characteristics are different between processors even in the same family) or if you desperately need to speed up a function.

> External declarations (outside a function) table

 | Storage Class Specifier | Function or Data Object | Linkage | Duration |
 | ----------------------- | ----------------------- | ------- | -------- |
 | static | either | internal | static |
 | extern | either | external | static |
 | none | function | external | static |
 | none | data object | external | static |

> Internal declarations table

 | Storage Class Specifier | Function or Data Object | Linkage | Duration |
 | ----------------------- | ----------------------- | ------- | -------- |
 | register | data object only | none | automatic |
 | auto | data object only | none | automatic |
 | static | data object only | none | static |
 | extern | either | external | static |
 | none | data object | none | automatic |
 | none | function | external | static |

### Scope
- Function scope.
  - Labels whose names are visible throughout the function they're declared.
- File scope.
  - Any name declared outside a function.
- Block scope.
  - Any name declared inside a compound statement or formal parameter of a function.
- Function prototype scope
  - Declaration of a name extends to end of function prototype (parameters can't have same names and names expire after last parenthesis).

### Linkage
- Determine what makes same name declared in different scopes refer to the same thing.
- External linkage.
  - Every instance of that name refers to same object throughout the program.
- Internal linkage.
  - Limited to source file.
- No linkage.
  - Refer to different things. Objects inside a code block, for instance.
- How to get appropriate linkage?
  - File scope declaration with `static` results in *internal* linkage.
  - Declaration contains `extern` or function declaration:
    - If already visible declaration of that identifier with file scope, linkage stays the same;
    - otherwise, *external*.
  - File scope declaration is neither declaration of a function nor contains explicit storage specifier, then *external*.
  - Any other form of declaration is *no linkage*.
  - In any one source file, if identifier has both internal and external linkage, then result is undefined.

---
```c
// Linkage example

/*
  EXTERNAL LINKAGE
 */
// Declarations (defined somewhere else)
extern int e_a; 
extern int e_f(double, int);

// Definitions
extern int e_i = 0;
void ef(int b) {}

/*
  INTERNAL LINKAGE
 */
static int s_i;
static float pi = 3.14159f;
static struct {
  int x;
  int y;
} local;

static void sf();
static int local(int a1, int a2) {
  return a1*a2;
}

/*
  NO LINKAGE
 */
static void none() {
  // No linkage inside
  static int counter;

  int i = 1;
}
```

# Typedef
- Allows you to introduce synonyms for types.
- Rarely used in typical C programming; most common in library development and for portability.
```c
typedef int aaa, bbb, ccc;
aaa int1;
bbb int2;
ccc int3;

typedef int arr[10];
ar ddd; // Array of 10 ints

typedef char *p_c;
p_c cptr; // Pointer to char

/* Function pointers */
typedef int func(int, int);

func *myfunc() {} // Returns pointer to type func

func otherF() {}; // ERROR: C functions can't return functions!
```

# Const and Volatile
## Const
- Something is unmodifiable. Can't be assigned to during run-time.
- Borrowed from C++ (older C Specifications may not support it).
```c
// Dangerous pointer assignment
int i;
const int ci = 123;

const int* cpi;
int *pi;

cpi = &ci;
pi = &i;

/* LEGAL */
cpi = pi;

/* Dangerous, but allowed (must be cast) */
pi = (int*)cpi;

/* The const is now modified! */
*pi = 0;
```

## Volatile
- Tells compiler that the object is subject to sudden, unpredictable change.
- Mostly used in real-time and embedded C programs (also asynchronous interrupts).
- Dangerous to take address of volatile object (with cast) and put into pointer to a regular object.
  - Possible, but undefined behavior.
```C
// Example no const or volatile accessing hardware
struct devregs {
  unsigned short csr;  // Control Status Register
  unsigned short data; // Data port
};

// Patterns in CSR
#define ERROR 0x1
#define READY 0x2
#define RESET 0x4

// Absolute address of device
#define DEVADDR ((struct devregs*)0xFFFF0004);

// Number of devices
#define NDEVS 4

//Busy-wait to read byte from device n.
unsigned int read_dev(unsigned devno) {
  struct devregs* dvp = DEVADDR + devno;

  // Check if in range
  if (devno >= NDEVS)
    return 0xFFFF;
  
  while((dvp->csr & (READY | ERROR)) == 0)
    ; // Wait until done

  // Reset error
  if (dvp->csr & ERROR) {
    dvp->csr = RESET;
    return 0xFFFF
  }

  // Read byte and return it
  return ((dvp->data) & 0xFF);
}
```
- Problem with above: C compilers notice the same memory address being tested; therefore it will optimize and reference the memory only *once* and copy the value into a hardware register to speed up the loop. Not what we intended!
```c
// Example with const and volatile read hardware
struct devregs {
  unsigned short volatile csr; // Control Status Register
  unsigned short const data;   // Data port
};

// Patterns in CSR
#define ERROR 0x1
#define READY 0x2
#define RESET 0x4

// Absolute address of device
#define DEVADDR ((struct devregs*)0xFFFF0004);

//Busy-wait to read byte from device n.
unsigned int read_dev(unsigned devno) {
  struct devregs* dvp = DEVADDR + devno;

  // Check if in range
  if (devno >= NDEVS)
    return 0xFFFF;
  
  while((dvp->csr & (READY | ERROR)) == 0)
    ; // Wait until done

  // Reset error
  if (dvp->csr & ERROR) {
    dvp->csr = RESET;
    return 0xFFFF
  }

  // Read byte and return it
  return ((dvp->data) & 0xFF);
}
```
```c
// Alternate declaration to above
struct devregs {
  unsigned short csr;  // Control Status Register
  unsigned short data; // Data port
};

...

/*
  Works, but bad style!
  - volatile belongs in the structure (it should 
  only apply to device registers)
 */
volatile struct devregs *const dvp = DEVADDR + devno;
/////////////////

volatile struct dr2 {} v_dr2;
struct dr2 my_dv2; // volatile not auto-applied! only to v_dr2

volatile struct dr2 {} v_dr2;
/* same as */
struct dr2 {} volatile v_dr2;

```
- For asynchronous events, `sig_atomic_t` (in signal.h) guarantees to modify objects in asynchronous events.

# Sequence Points
- When certain sorts of optimization may and may not be permitted to be in effect (each defined by the Standard).
```c
int i;
void func();

...
/*
  Compiler might want to
  store 'i' in a machine
  register for speed, however
  func needs 'i' so 'i'
  will have to be refetched
  for every func call!
 */
while (i != 10000) {
  func();
  i++;
}

...

void func() { printf("%d\n", i); }
```
- Sequence points laid down by the Standard:
  - Point of calling a function after evaluating arguments.
  - End of first operand of '&&'.
  - End of first operand of '||'.
  - End of first operand of '?:'.
  - End of each operand of comma operator.
  - Completing evaluation of a full expression:
    - Evaluating initializer of `auto` object.
    - Expression in 'ordinary' statement (expression followed by semicolon).
    - Controlling expressions in `do`, `while`, `if`, `switch`, or `for`.
    - The other two expressions in a for statement.
    - Expression in a `return` statement.
