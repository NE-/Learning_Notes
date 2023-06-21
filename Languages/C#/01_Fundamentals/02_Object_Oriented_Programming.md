<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 October 13
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
- Structs allocated on thread stack and copied on assignment.

## Object Identitiy vs. Value Equality
- Determine if class instances refer to same location in memory (same *identity*), use `Object.Equals`.
- Determine if instance fields in struct instances have same values, use `ValueType.Equals`.
  - `Equals()` can be called directly from struct object since structs inherit `System.ValueType`.
Determine if values of fields in class instances are equal, use `Equals` or `==` operator.
  - *only* use if class has overridden or overloaded them to provide what "equality" means for those objects.

# Inheritance
- Inherited classes gain all members except constructors and finalizers.
```C#
// WorkItem implicitly inherits from the Object class.
public class WorkItem
{
  // Static field currentID stores the job ID of the last WorkItem that
  // has been created.
  private static int currentID;

  //Properties.
  protected int ID { get; set; }
  protected string Title { get; set; }
  protected string Description { get; set; }
  protected TimeSpan jobLength { get; set; }

  // Default constructor. If a derived class does not invoke a base-
  // class constructor explicitly, the default constructor is called
  // implicitly.
  public WorkItem()
  {
    ID = 0;
    Title = "Default title";
    Description = "Default description.";
    jobLength = new TimeSpan();
  }

  // Instance constructor that has three parameters.
  public WorkItem(string title, string desc, TimeSpan joblen)
  {
    this.ID = GetNextID();
    this.Title = title;
    this.Description = desc;
    this.jobLength = joblen;
  }

  // Static constructor to initialize the static member, currentID. This
  // constructor is called one time, automatically, before any instance
  // of WorkItem or ChangeRequest is created, or currentID is referenced.
  static WorkItem() => currentID = 0;

  // currentID is a static field. It is incremented each time a new
  // instance of WorkItem is created.
  protected int GetNextID() => ++currentID;

  // Method Update enables you to update the title and job length of an
  // existing WorkItem object.
  public void Update(string title, TimeSpan joblen)
  {
    this.Title = title;
    this.jobLength = joblen;
  }

  // Virtual method override of the ToString method that is inherited
  // from System.Object.
  public override string ToString() =>
    $"{this.ID} - {this.Title}";
}

// ChangeRequest derives from WorkItem and adds a property (originalItemID)
// and two constructors.
public class ChangeRequest : WorkItem
{
  protected int originalItemID { get; set; }

  // Constructors. Because neither constructor calls a base-class
  // constructor explicitly, the default constructor in the base class
  // is called implicitly. The base class must contain a default
  // constructor.

  // Default constructor for the derived class.
  public ChangeRequest() { }

  // Instance constructor that has four parameters.
  public ChangeRequest(string title, string desc, TimeSpan jobLen, int originalID)
  {
    // The following properties and the GetNexID method are inherited
    // from WorkItem.
    this.ID = GetNextID();
    this.Title = title;
    this.Description = desc;
    this.jobLength = jobLen;

    // Property originalItemId is a member of ChangeRequest, but not
    // of WorkItem.
    this.originalItemID = originalID;
  }
}


// Usage
// Create an instance of WorkItem by using the constructor in the
// base class that takes three arguments.
WorkItem item = new WorkItem("Fix Bugs",
                            "Fix all bugs in my code branch",
                            new TimeSpan(3, 4, 0, 0));

// Create an instance of ChangeRequest by using the constructor in
// the derived class that takes four arguments.
ChangeRequest change = new ChangeRequest("Change Base Class Design",
                                        "Add members to the class",
                                        new TimeSpan(4, 0, 0),
                                        1);

// Use the ToString method defined in WorkItem.
Console.WriteLine(item.ToString());

// Use the inherited Update method to change the title of the
// ChangeRequest object.
change.Update("Change the Design of the Base Class", new TimeSpan(4, 0, 0));

// ChangeRequest inherits WorkItem's override of ToString.
Console.WriteLine(change.ToString());
/* Output:
  1 - Fix Bugs
  2 - Change the Design of the Base Class
*/
```

## Abstract and Virtual Methods
- Abstract classes prevent direct instantiation.
- `virtual` base class methods *can* be `override`n in derived class.
- `abstract` **must** be overriden in any non-abstract derived class.
  - Abstract derived classes do not implement base class abstract methods.

## Interfaces
- Reference type that defines a set of members.
- Classes and structs that implement interface *must* implement those members.
- Interfaces can define a default implementation for any or all members.
- Classes can implement multiple interfaces.
- For not "is-a" relationships. 

## Derived Class Hiding of Base Class Members
- A derived class can hide base class members by declaring members with the same name and signature. 
- The new modifier can be used to explicitly indicate that the member isn't intended to be an override of the base member. 
  - The use of new isn't required, but a compiler warning will be generated if new isn't used. 

# Polymorphism
- Two distinct aspects:
  - At run time, objects of derived class may be treated as objects of base class in places such as method parameters and collections or arrays. When this polymorphism occurs, the object's declared type is no longer identical to its run-time type.
  - Base classes may define and implement virtual methods, and derived classes can override them. At run-time, when client code calls the method, the CLR looks up the run-time type of the object, and invokes that override of the virtual method. In your source code you can call a method on a base class, and cause a derived class's version of the method to be executed.
```c#
public class Shape
{
  // A few example members
  public int X { get; private set; }
  public int Y { get; private set; }
  public int Height { get; set; }
  public int Width { get; set; }

  // Virtual method
  public virtual void Draw()
  {
    Console.WriteLine("Performing base class drawing tasks");
  }
}

public class Circle : Shape
{
  public override void Draw()
  {
    // Code to draw a circle...
    Console.WriteLine("Drawing a circle");
    base.Draw();
  }
}
public class Rectangle : Shape
{
  public override void Draw()
  {
    // Code to draw a rectangle...
    Console.WriteLine("Drawing a rectangle");
    base.Draw();
  }
}
public class Triangle : Shape
{
  public override void Draw()
  {
    // Code to draw a triangle...
    Console.WriteLine("Drawing a triangle");
    base.Draw();
  }
}

// Polymorphism at work #1: a Rectangle, Triangle and Circle
// can all be used whereever a Shape is expected. No cast is
// required because an implicit conversion exists from a derived
// class to its base class.
var shapes = new List<Shape>
{
  new Rectangle(),
  new Triangle(),
  new Circle()
};

// Polymorphism at work #2: the virtual method Draw is
// invoked on each of the derived classes, not the base class.
foreach (var shape in shapes)
{
  shape.Draw();
}
/* Output:
  Drawing a rectangle
  Performing base class drawing tasks
  Drawing a triangle
  Performing base class drawing tasks
  Drawing a circle
  Performing base class drawing tasks
*/
```
- In C#, every type is polymorphic because all types inherit from `Object`.

## Hide Base Class Members with New Members
```C#
public class BaseClass
{
  public void DoWork() { WorkField++; }
  public int WorkField;
  public int WorkProperty
  {
    get { return 0; }
  }
}

public class DerivedClass : BaseClass
{
  public new void DoWork() { WorkField++; }
  public new int WorkField;
  public new int WorkProperty
  {
    get { return 0; }
  }
}

//  Usage
DerivedClass B = new DerivedClass();
B.DoWork();  // Calls the new method.

BaseClass A = (BaseClass)B;
A.DoWork();  // Calls the old method.
```
- Prevent derived class from overriding virtual members with `sealed`.
```c#
public class A
{
  public virtual void DoWork() { }
}
public class B : A
{
  public override void DoWork() { }
}
public class C : B
{
  public sealed override void DoWork() { }
}

// Replace sealed method with new
public class D : C
{
  public new void DoWork() { }
}
```
- Access base class virtual members from derived classes with `base` keyword.
```c#
public class Base
{
  public virtual void DoWork() {/*...*/ }
}
public class Derived : Base
{
  public override void DoWork()
  {
    //Perform Derived's work here
    //...
    // Call DoWork on base class
    base.DoWork();
  }
}
```
