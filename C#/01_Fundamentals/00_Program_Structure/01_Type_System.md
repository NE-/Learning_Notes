<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 12
  Purpose: C# Type System
-->

# Overview
- Strongly typed language. Type safe (e.g. `bool` is not convertible `int`).
- Compiler embeds type information into executable as metadata. CLR uses metadata at run time to further guarantee type safety when it allocates and reclaims memory.

## Specifying Types in Variable Declaraions
- Specify variable type or use `var` to let compiler infer type.
```c#
// Declaration only:
float temperature;
string name;
MyClass myClass;

// Declaration with initializers (four examples):
char firstLetter = 'C';
var limit = 3;
int[] source = { 0, 1, 2, 3, 4, 5 };
var query = from item in source
            where item <= limit
            select item;
```
- Type conversion that doesn't cause data loss performed automatically by compiler.
  - Conversions that may cause data loss require explicit *cast*.

## Common Type System
- Principle of inheritance: *Unified type hierarchy*.
- All base types inherit from `System.Object`.
- Each type in CTS is either *value* or *reference* type.

## Value Types
- Derive from `System.ValueType`.
- Directly contain their values.
- Memory for struct is allocated inline in whatever context the variable is declared.
  - No seperate heap allocation or garbage collection overhead for value-type variables.
- Two categories: `struct` and `enum`.
  - Built-in numeric types are `struct`.
- Value types are *sealed* (can't derive a type from a value type).
  - Can cast struct type to any interface type it implements (causes boxing).
- `enum` inherits from `System.Enum` which inherits from `System.ValueType`.

## Reference Types
- `class record delegate array interface`.
- Created on managed heap.
  - Overhead when allocated and reclaimed (reclaimed by garbage collector).
    - Garbage collector highly optimized so may not cause performance issues.
- Only hold reference to location of object.
- Usually fully support inheritance from any interface or class *not* sealed.

## Types of Literal Values
- Compiler infres type, but you can specify with a letter after the number, e.g. 'f' for float.

## Generic Types
- Type parameters that serve as placeholder for actual type (*concrete type*).

## Implicit, Anonymous, and Nullable Value Types
- Implicitly type local variable (not class members) using `var`.
- Anonymous types have no name. Useful for simple sets of related values you don't intend to store or pass outside method boundaries.
- Nullable types created by appending `?` after the type.
  - Useful when data *can* be null e.g. from a database.

## Compile-Time and Run-Time Type
- *Compile-time* declared or inferred type of variable in source-code.
- *Run-time* instance referred to by that variable.
```c#
/*
  string is run-time type
  object and IEnumerable compile-time
 */
object anotherMessage = "This is another string of characters";
IEnumerable<char> someCharacters = "abcdefghijklmnopqrstuvwxyz";
```
- Compile-time types determine all actions taken by compiler.
  - Method call resolution, overload resolution, and available implicit and explicit casts.
- Run-time types determine all actions that are resolved at run time.
  - Dispatching virtual method calls, evaluating `is` and `switch` expressions, and other type testing APIs.
  