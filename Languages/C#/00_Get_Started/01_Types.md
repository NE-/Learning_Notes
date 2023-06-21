<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 29
  Purpose: C# Introduction to Types
-->

# Classes and Objects
- *Class* combines state (fields) and actions (methods and other functions) in a single unit
- Class header:
  - Attributes and modifiers
  - Name of class
  - Base class (if inheriting)
  - Interfaces (if implementing)
```c#
// Example class structure
public class Point
{
  public int X { get; }
  public int Y { get; }

  public Point(int x, int y) => (X, Y) = (x, y);
}
```
- Instantiated using `new`.
- Memory auto-reclaimed when object is no longer reachable.
  - Unnecessary and impossible to explicitly deallocate objects in C#.

# Type Parameters
- Used in body of class declarations to define members of the class.
- Class types that take type parameters called *generic class type*.
  - Struct, interface, and delegate can also be generic.
- Generic type with type arguments called *constructed type*.
```c#
public class Pair<TFirst, TSecond>
{
  public TFirst First { get; }
  public TSecond Second { get; }

  public Pair(TFirst first, TSecond second) =>
    (First, Second) = (first, second);
}

// Constructed type Pair<int, string>
var pair = new Pair<int, string>(1, "two");
int i = pair.First;
string s = pair.Second;
```

# Base Classes
- Omitting a base class same as dderiving from `object`.
- Don't inherit instance and static constructors, and finalizer.
- Implicit conversions exist from class to any base.
- Variable of a class type can reference an instance of that class or  of any derived class.
```c#
public class Point3D : Point
{
  public int Z { get; set; }
  public Point3D(int x, int y, int z) : base (x,y)
  {
    Z = z;
  }
}

// Can reference same types
Point a = new(10, 20);
point b = new Point3D(10, 20, 30);
```

# Structs
- Primary purpose is to store data values. Use classes for object creation.
- Implicitly derive from `System.ValueType`. Implicitly sealed (can't derive structs with each other).
```c#
public struct Point
{
  public double X { get; }
  public double Y { get; }

  public Point(double x, double y) => (X, Y) = (x, y);
}
```

# Interfaces
- Can contain methods, properties, events, and indexers.
- When class or struct implements an interface, instances f that class or struct can be implicitly converted to that interface type.
```c#
interface IControl 
{
  void Paint();
}

interface ITextBox : IControl
{
  void SetText(string text);
}

interface IListBox : IControl
{
  void SetItems(string[] items);
}

interface IComboBox : ITextBox, IListBox { }

// Implementation
interface IDataBound
{
  void Bind(Binder b);
}

public class EditBox : IControl, IDataBound
{
  public void Paint();
  public void Bind();
}

// Implicit conversion
EditBox editBox = new();
IControl control = editBox;
IDataBound dataBound = editBox;
```

# Enums
- Set of constant values
```c#
public enum RootVeg
{
  HorseRadish,
  Radish,
  Turnip
}
```
- Can be used in combination as flags.
```c#
[Flags]
public enum Seasons
{
  None   = 0,
  Summer = 1,
  Autumn = 2,
  Winter = 4,
  Spring = 8,
  All = Summer | Autumn | Winter | Spring
}

// Example usage
var turnip = RootVeg.Turnip;
var spring = Seasons.Spring;
var StartingOnEquinox = Seasons.Spring | Seasons.Autumn;
var theYear = Seasons.All;
```

# Nullable Types
- `null` indicates *no value*.
- Nullable value types (struct, enum) represented by `System.Nullable<T>`.
```c#
int? optionalInt = default; // Initialized to null
optionalInt = 5;
string? optionalText = default;
optionalText = "Hello World.";
```

# Tuples
- Group multiple data elements in a lightweight data structure.
```c#
(double Sum, int Count) t2 = (4.5, 3);
Console.WriteLine($"Sum of {t2.Count} elements is {t2.Sum}.");
```
