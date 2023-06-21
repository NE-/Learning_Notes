<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 19
  Purpose: C++ Introduction
-->

# History
- Developed by Bjarne Stroustrup at Bell Labs as an *extension* to C starting in 1979.
  - Standardized 1998 by ISO.
- Popularized because it was an object-oriented language.
- 1998 standard was updated in 2003, known as C++03. Later major updates: C++11, C++14, C++17, C++20, C++23 coming soon.
  - C++17 is the *safe* standard for modern C++ programming (as of 2022). Typically safe to use one or two previous version from the current standard because not all defects have been fixed and not all good and practices (of new features) are known yet. Also for cross-platform compatibility.

# Compiler
- Driver responsible for compiling, assembling, and linking via stages (can be halted).
## Preprocessing Stage
- Tokenizes source files and expands preprocessor directives.
- Flag `-E` (clang).
> outputs .i (C)  or .ii (C++). "Pure C" source code that shouldn't be preprocessed.
## Parsing and Semantic Analysis Stage
- Translates tokens into parse tree. Once tree is formed, it applies semantic analysis to determine types for expresions and to detremine if the code is well formed.
- All warnings and errors get thrown at this stage!
> Outputs the AST
## Code Generation and Optimization Stage
- Translates AST into low-level intermediate code (**[framework] IR** (e.g. LLVM IR (clang) GIMPLE (GCC)) programming language) then that gets translated into machine code.
  - Optimizes code and generates any target-specific code if necessary.
- Flag `-S` (clang). *runs previous stages as well*.
> Outputs .s file. Generated assembly by the compiler.
## Assembler Stage
- Runs target assembler and translates compiler's output into an object file.
- Flag `-c` (clang). *runs previous stages as well*.
> Outputs .o file.
## Linker Stage
- Runs target linker (merges all object files into executable or dynamic library).
- Default if no stage selection flag has been used.
> Outputs .out, .dylib, or .so
