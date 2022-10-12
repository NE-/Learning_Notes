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

# Namespaces
- Heavily used in C# for organization and scope control.
- `global` namespace is the "root" namespace: `global::System` refers to .NET `System` namespace.
```c#
namespace SampleNamespace
{
  class SampleClass
  {
    public void SampleMethod()
    {
      System.Console.WriteLine(
        "SampleMethod inside SampleNamespace");
    }
  }
}

// C#10 can have namespace at top
namespace SampleNamespace;

class AnotherSampleClass
{
  public void AnotherSampleMethod()
  {
    System.Console.WriteLine(
      "SampleMethod inside SampleNamespace");
  }
}
```

# Classes
- Create instance with `new` or an object reference without creating an object.
```c#
MyObj obj1 = new MyObj(); // Instance.
MyObj obj2; // Just a reference. Fails at run-time.

// Recommended usage
MyObj obj1 = new MyObj();
MyObj obj2 = obj1; // Assign to existing object
```

## Class Inheritance
- Base class specified by using colon.
```c#
public class Manager : Employee
{
  // Employee fields, properties, methods and events are inherited
  // New Manager fields, properties, methods and events go here...
}
```
- C# classes can only directly inherit from **_one_** base class.
  - Can indirectly inherit multiple classes by inheriting a class that inherits another.
- Can directly implement one or more interfaces.
```c#
using System;

public class Person
{
  // Constructor that takes no arguments:
  public Person()
  {
    Name = "unknown";
  }

  // Constructor that takes one argument:
  public Person(string name)
  {
    Name = name;
  }

  // Auto-implemented readonly property:
  public string Name { get; }

  // Method that overrides the base class (System.Object) implementation.
  public override string ToString()
  {
    return Name;
  }
}
class TestPerson
{
  static void Main()
  {
    // Call the constructor that has no parameters.
    var person1 = new Person();
    Console.WriteLine(person1.Name);

    // Call the constructor that has one parameter.
    var person2 = new Person("Sarah Jones");
    Console.WriteLine(person2.Name);
    // Get the string representation of the person2 instance.
    Console.WriteLine(person2);
  }
}
// Output:
// unknown
// Sarah Jones
// Sarah Jones
```

# Records
- Class or struct that provides special syntax and behavior for working with data models.
## When to use
- Want to define a data model that depends on value equality (two variables of a record type are equal if types match and all property and field values match).
- Want to define a type for which objects are immutable.
  - Useful for thread-safety and hash codes.

## Difference from Classes and Structs
- `class` substituted with `record`; `struct` now `record struct`.
- Can use positional parameters to create and instantiate a type with immutable properties.
- Reference equality/inequality methods and operators (e.g. `.Equals()` and `==` ) indicate *value equality/inequality*.
- Can use `with` expression to create copy of immutable object with new values.
- `ToString` method creates formatted string that shows object's type name and names and values of all its public properties.
- Can inherit from another `record`.
  - Can't inherit from `class` and `class` can't inherit `record`.
- `record struct` the compiler synthesizes the methods for equality, and `ToString` and a `Deconstruct` method for positional record structs.
```c#
public record Person(string FirstName, string LastName);

public static void Main()
{
  Person person = new("Nancy", "Davolio");
  Console.WriteLine(person);
  // output: Person { FirstName = Nancy, LastName = Davolio }
}

// Value Equality
public record Person(string FirstName, string LastName, string[] PhoneNumbers);

public static void Main()
{
  var phoneNumbers = new string[2];
  Person person1 = new("Nancy", "Davolio", phoneNumbers);
  Person person2 = new("Nancy", "Davolio", phoneNumbers);
  Console.WriteLine(person1 == person2); // output: True

  person1.PhoneNumbers[0] = "555-1234";
  Console.WriteLine(person1 == person2); // output: True

  Console.WriteLine(ReferenceEquals(person1, person2)); // output: False
}

// with Expression Copy Immutable
public record Person(string FirstName, string LastName)
{
    public string[] PhoneNumbers { get; init; }
}

public static void Main()
{
  Person person1 = new("Nancy", "Davolio") { PhoneNumbers = new string[1] };
  Console.WriteLine(person1);
  // output: Person { FirstName = Nancy, LastName = Davolio, PhoneNumbers = System.String[] }

  Person person2 = person1 with { FirstName = "John" };
  Console.WriteLine(person2);
  // output: Person { FirstName = John, LastName = Davolio, PhoneNumbers = System.String[] }
  Console.WriteLine(person1 == person2); // output: False

  person2 = person1 with { PhoneNumbers = new string[1] };
  Console.WriteLine(person2);
  // output: Person { FirstName = Nancy, LastName = Davolio, PhoneNumbers = System.String[] }
  Console.WriteLine(person1 == person2); // output: False

  person2 = person1 with { };
  Console.WriteLine(person1 == person2); // output: True
}
```