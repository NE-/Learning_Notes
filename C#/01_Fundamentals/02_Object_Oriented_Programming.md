<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 13
  Purpose: C# OOP Concepts
-->

# Classes, Structs, and Records Overview
## Encapsulation
- Specify how accessible each of its members is to outside code (client code).

## Members
- Methods, fields, constants, properties, and events.
- No global variables or members in C#.
- Valid members for class, struct, or record:
  - Fields
  - Constants
  - Properties
  - Methods
  - Constructors
  - Events
  - Finalizers
  - Indexers
  - Operators
  - Nested Types

## Accessibility
- Limit accessibility with access modifiers: public, protected, internal, protected internal, private, private protected.
  - Default is `private`.

## Inheritance
- Classes, not structs, support inheritance.
- Derived classes contain all public, protected, and internal members of base class except constructors and finalizers.
- Declare `sealed` to prevent other classes from inheriting from them.

## Interfaces
- Derived type implements all methods defined in the interface.

## Generic Types
- Type parameters. Type supplied by client code when instance created.

## Static Types
- Static classes can only have static members and can't be instantiated with `new`.

## Nested Types
- Class, struct, or record can be nested within another class, struct, or record.

## Partial Types
- Define part of class, struct, or method in one code file and another part in a seperate code file.

## Object Initializers
- Instantiate and initialize class or struct objects, and collections of objects, by assigning values to its properties.

## Anonymous Types
- Types defined by their named data members.

## Extension Methods
- "Extend" a class without creating a derived class by creating a seperate type.
- Type contains methods that can be called as if belonged to original type.

## Implicitly Typed Local Variables
- Implicitly type to instruct compiler to determine variable's type at compile time.
  - `var`.

## Records
- Classes with built-in behavior for encapsulating data in immutable types.
- C#10 intriduces `record struct`.
- Features:
  - Concise syntax for creating a reference type with immutable properties.
  - Value equality. Two variables of a record type are equal if they have the same type, and if, for every field, the values in both records are equal. Classes use reference equality: two variables of a class type are equal if they refer to the same object.
  - Concise syntax for nondestructive mutation. A with expression lets you create a new record instance that is a copy of an existing instance but with specified property values changed.
  - Built-in formatting for display. The ToString method prints the record type name and the names and values of public properties.
  - Support for inheritance hierarchies in record classes. Record classes support inheritance. Record structs don't support inheritance.

# Objects
- Class object variables hold *reference*; struct variables hold copy of the entire object.