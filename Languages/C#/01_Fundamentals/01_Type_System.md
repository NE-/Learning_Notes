<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 12
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

# Interfaces
- Contain definitions that non-abstract `class` or `struct` must implement.
- `static` methods must be implemented in the interface.
- Default implmentations for members may be defined.
- May not declare fields, auto-implemented properties, or property-like events.
  - Can't contain instance fields, instance constructors, or finalizers.
  - members public by default, but can explicitly specify accessibility modifiers.
    - `private` members *must* have default implementation.
- Must use interface to simulate inheritance in structs.
- Interfaces can inherit from one or more interfaces.
- C#11, interface members  that aren't fields may be `static abstract`.
```c#
// Interface Class
interface IEquatable<T>
{
  bool Equals(T obj);
}

// Usage
public class Car : IEquatable<Car>
{
  public string? Make  { get; set; }
  public string? Model { get; set; }
  public string? Year  { get; set; }

  // Implementation of IEquatable<T> interface
  public bool Equals(Car? car)
  {
    return (this.Make, this.Model, this.Year) ==
      (car?.Make, car?.Model, car?.Year);
  }
}
```

# Generic Classes and Methods
- Concept of type parameters. Commonly used for collections.
- Types resolved at run-time using by reflection.
- Combine reusability, type safety, and efficiency in a way non-generics cannot.
- Non-generic collections, such as `ArrayList`, are **not** recommended and are maintained for compatibility reasons (located in `System.Collections`).
  - Recommended collections located in `System.Collections.Generic`.
```c#
// Example linked list
// - Recommended to use List<T> instead
// type parameter T in angle brackets
public class GenericList<T>
{
  // The nested class is also generic on T.
  private class Node
  {
    // T used in non-generic constructor.
    public Node(T t)
    {
      next = null;
      data = t;
    }

    private Node? next;
    public Node? Next
    {
      get { return next; }
      set { next = value; }
    }

    // T as private member data type.
    private T data;

    // T as return type of property.
    public T Data
    {
      get { return data; }
      set { data = value; }
    }
  }

  private Node? head;

  // constructor
  public GenericList()
  {
    head = null;
  }

  // T as method parameter type:
  public void AddHead(T t)
  {
    Node n = new Node(t);
    n.Next = head;
    head = n;
  }

  public IEnumerator<T> GetEnumerator()
  {
    Node? current = head;

    while (current != null)
    {
      yield return current.Data;
      current = current.Next;
    }
  }
}

// Usage
class TestGenericList
{
  static void Main()
  {
    // int is the type argument
    GenericList<int> list = new GenericList<int>();

    for (int x = 0; x < 10; x++)
    {
      list.AddHead(x);
    }

    foreach (int i in list)
    {
      System.Console.Write(i + " ");
    }
    System.Console.WriteLine("\nDone");
  }
}
```

# Anonymous Types
- Convenient way to encapsulate a set of read-only properties into single object without having to explicitly define a type first.
- Methods or events invalid. Initializer values cannot be `null`, anonymous function, or pointer type.
- Type generated and inferred by compiler.
- Create using `new` with object initializer.
- Anonymous types are *class* types derived from `object` and can't be cast to other types.
- Similar object initializers (properties in the same order have same name and type) in an assembly are treated as instances of the same type.
  - Share same compiler-generated type information.
```c#
var v = new { Amount = 108, Message = "Hello" };
//                  int        string
Console.WriteLine(v.Amount + v.Message);
```
- Typically used with `LINQ` queries.
```c#
var productQuery =
  from prod in products
  select new { prod.Color, prod.Price };

// var v automatically gives the correct type
foreach (var v in productQuery)
{
  Console.WriteLine("Color={0}, Price={1}", v.Color, v.Price);
}
```
```c#
// Create array  of anonymously typed elements
var anonArray = new[] { new { name = "apple", diam = 4 }, new { name = "grape", diam = 1 }};
```
```c#
// Use with for non-destructive mutation
var apple = new { Item = "apples", Price = 1.35 };
var onSale = apple with { Price = 0.79 }; // New instance
Console.WriteLine(apple);
Console.WriteLine(onSale);
```
```c#
// Using ToString
var v = new { Title = "Hello", Age = 24 };

Console.WriteLine(v.ToString()); // "{ Title = Hello, Age = 24 }"
```
- Can't declare a field, property, event, or return type of a method as having an anonymous type. Can't declare a formal parameter of a method, property, constructor, or indexer as having an anonymous type.
- Pass anonymous types as argument, declare parameter as type `object`.
  - Beats purpose of strong typing. Consider using ordinary class or struct.