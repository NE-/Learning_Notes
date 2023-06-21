<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 20
  Purpose: C++ File Scope
-->

# Linkage
- If the scope of an object is exposed to the linker.
## No Linkage
- Objects that can only be referred to in the **_same scope_**.
- If a variable isn't explicitly declared `extern` it has no linkage.
- Local classes and their members have no linkage.
- Anything inside a code block has no linkage.
## Internal Linkage
- Identifier that can only be identified and used within a **_single file_** (not exposed to the linker).
- Non-constant global variables and functions are external by default, but we can make them internal with `static` or by making them constant.
  - Using `static` only for linkage is not ideal because `static` is a storage class specifier, which set linkage *and* duration.
  - `const` does not make functions external.
```cpp
// main.cpp
int global0{}; // External

static int internal0{};    // Internal
const int internal1{};     // Internal
constexpr int internal2{}; // Internal

int main() { return 0; }
///////

// other.cpp
/*
  Linker error:
  multiple definition of
  global0
 */
int global0{}; // External
/* legal; no errors */
static int internal0{};    // Internal
const int internal1{};     // Internal
constexpr int internal2{}; // Internal
```
```cpp
/** Global functions example **/
// add.cpp
int add(int x, int y){ return x+y; }

// main.cpp
int add(int x, int y); // Forward declaration required

int main() {
  add(9,9);
  return 0;
}
////////

/** Internal functions example **/
// add.cpp
static int add(int x, int y){ return x+y; }

// main.cpp
int add(int x, int y); // Forward declaration required

int main() {
  // ERROR Undefined reference to add(int, int)
  add(9,9);
  return 0;
}
///////////
// add.cpp
constexpr int add(int x, int y){ return x+y; }

// main.cpp
int add(int x, int y); // Forward declaration required

int main() {
  // ERROR Undefined reference to add(int, int)
  add(9,9);
  return 0;
}
```
## External Linkage
- Objects can be seen by **_any file_** in the project.
- Global variables and functions are external by default.
- Using constant modifiers makes them internal, but if we want to make the constants external we use `extern`.
  - `extern` requires forward declaration when using somewhere else.
  - Doesn't work with `static` as their meanings conflict. `static` = this variable is internal. `extern` = this variable is external. `extern static` = ???.
- `constexpr` variables can't be forward declared; therefore it's recommended not to give them external linkage.
```cpp
// ext.cpp
int gbl0{0};
extern const int gbl1{55};

// main.cpp

// Forward declaration required
/*
  Not initialized meaning
  they are defined somewhere else
 */
extern int gbl0;
extern const int gbl1;

int main() { return 0; }
```

# Storage Duration
- How long an object exists or "object's lifetime".
- **Automatic**: storage allocated at the beginning of the code block and deallocated at the end.
  - Local objects **not** declared `static`, `extern`, or `thread_local`.
- **Static**: storage allocated when program begins and deallocated when program ends.
  - Objects declared at namespace scope, `static`, or `extern`.
- **Thread**: storage allocated when the thread begins and deallocated when the thread ends.
  - Objects declared `thread_local`.
- **Dynamic**: storage is allocated and deallocated upon request.
  - Objects created dynamically.

# Inline Variables
- Modern way of efficiently using global variables.
- Variables that are allowed to be defined in multiple files. This means it will only be truly defined once by the linker and any multiple definitions caused by the preprocessor are ignored.
  - Inline variables mainly used in header files.
- Old way was to use a header file (or template and struct hacks) with variables and include it wherever we need them. This needlessly copies the variables every time!
```cpp
// math.h
// Notice constexpr can be external now!
namespace math_constants{
  inline constexpr double pi{ 3.14159 };
  inline constexpr double py{ 1.41421 };
  inline constexpr double gravity{ 9.80665 };
};

// main.cpp
#include "math.h"

int main(){
  std::cout << math::pi;
  std::cout << math::py;
  std::cout << math::gravity;

  return 0;
}
```
