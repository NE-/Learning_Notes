<!--
  Author: NE- https://github.com/NE-
  Date: 2022 October 14
  Purpose: C# Functional Techniques
-->

# Pattern Matching
- Test an expression to determine if it has certain characteristics.
- `is` supports pattern matching to test an expression and conditionally declare a new varible to the result of that expression.
- `switch` performs actions based on the first matching pattern for an expression.

## Null Checks
```c#
int? maybe = 12;

// Declaration pattern example. Safer technique
if (maybe is int number)
{
  Console.WriteLine($"The nullable int 'maybe' has the value {number}");
}
else
{
  Console.WriteLine("The nullable int 'maybe' doesn't hold a value");
}

string? message = "This is not the null string";

// Constant pattern example
if (message is not null)
{
    Console.WriteLine(message);
}
```

## Type Tests
```c#
public static T MidPoint<T>(IEnumerable<T> sequence)
{
  // Test if variable matches a given type
  if (sequence is IList<T> list)
  {
    return list[list.Count / 2];
  }
  else if (sequence is null)
  {
    throw new ArgumentNullException(nameof(sequence), "Sequence can't be null.");
  }
  // Didn't mathc ILits, use different approach to achieve same thing
  else
  {
    int halfLength = sequence.Count() / 2 - 1;
    if (halfLength < 0) halfLength = 0;
    return sequence.Skip(halfLength).First();
  }
}
```
- Can use `switch` to test against types.

## Compare Discrete Values
```c#
// Test value against all possible values declared in an enumeration
public State PerformOperation(Operation command) =>
  command switch
  {
    Operation.SystemTest => RunDiagnostics(),
    Operation.Start => StartSystem(),
    Operation.Stop => StopSystem(),
    Operation.Reset => ResetToReady(),
    // Discard pattern that matches all values
    // Compiler warning if omitted
    _ => throw new ArgumentException("Invalid enum value for command", nameof(command)),
  };

// Using constants instead
public State PerformOperation(string command) =>
  command switch
  {
    "SystemTest" => RunDiagnostics(),
    "Start" => StartSystem(),
    "Stop" => StopSystem(),
    "Reset" => ResetToReady(),
    _ => throw new ArgumentException("Invalid string value for command", nameof(command)),
  };

// C#11 use Span<char> or ReadOnlySpan<char> for string constants
public State PerformOperation(ReadOnlySpan<char> command) =>
  command switch
  {
    "SystemTest" => RunDiagnostics(),
    "Start" => StartSystem(),
    "Stop" => StopSystem(),
    "Reset" => ResetToReady(),
    _ => throw new ArgumentException("Invalid string value for command", nameof(command)),
  };
```

## Relational Patterns
- Compare value against constants (`not and or`).
```c#
string WaterState(int tempInFahrenheit) =>
  tempInFahrenheit switch
  {
    // Relational pattern
    (> 32) and (< 212) => "liquid",
    < 32 => "solid",
    > 212 => "gas",
    // Required for satisfying every possible input
    // Compile warns without them
    32 => "solid/liquid transition",
    212 => "liquid / gas transition",
  };

// Same as above
string WaterState2(int tempInFahrenheit) =>
  tempInFahrenheit switch
  {
    < 32 => "solid",
    32 => "solid/liquid transition",
    < 212 => "liquid",
    212 => "liquid / gas transition",
    _ => "gas",
  };
```
- Compiler also warns if a switch arm is already handled by a previous switch arm.

## Multiple Inputs
```c#
public record Order(int Items, decimal Cost);

public decimal CalculateDiscount(Order order) =>
  order switch
  {
    { Items: > 10, Cost: > 1000.00m } => 0.10m,
    { Items: > 5, Cost: > 500.00m } => 0.05m,
    { Cost: > 250.00m } => 0.02m,
    null => throw new ArgumentNullException(nameof(order), "Can't calculate discount on null order"),
    // Matches any other value
    var someObject => 0m,
  };

// If Order type defines a suitable Deconstruct method, you can omit 
// the property names from the pattern and use deconstruction to examine properties
// AKA positional pattern
public decimal CalculateDiscount(Order order) =>
  order switch
  {
    ( > 10,  > 1000.00m) => 0.10m,
    ( > 5, > 50.00m) => 0.05m,
    { Cost: > 250.00m } => 0.02m,
    null => throw new ArgumentNullException(nameof(order), "Can't calculate discount on null order"),
    var someObject => 0m,
  };
```

## List Patterns
- Apply a pattern to any element of a sequence.
  - Can apply discard pattern `_` to match any element.
  - Can apply slice pattern to match zero or more elements.
```c#
public void MatchElements(int[] array)
{
  if (array is [0,1])
  {
    Console.WriteLine("Binary Digits");
  }
  else if (array is [1,1,2,3,5,8, ..])
  {
    Console.WriteLine("array looks like a Fibonacci sequence");
  }
  else
  {
    Console.WriteLine("Array shape not recognized");
  }
}
```

# Discards
- Placeholder variables that are intentionally unused. Don't have a value.
  - Tells compiler and code-readers you intended to ignore result of an expression.
- Use `_` as variable name.
```c#
(_, _, area) = city.GetCityInformation(cityName);
```
- C#9, use discards to specify unused input parameters of a lambda expression.

## Tuple and Object Deconstruction
```c#
var (_, _, _, pop1, _, pop2) = QueryCityDataForYears("New York City", 1960, 2010);

Console.WriteLine($"Population change, 1960 to 2010: {pop2 - pop1:N0}");

static (string, double, int, int, int, int) QueryCityDataForYears(string name, int year1, int year2)
{
  int population1 = 0, population2 = 0;
  double area = 0;

  if (name == "New York City")
  {
    area = 468.48;
    if (year1 == 1960)
    {
      population1 = 7781984;
    }
    if (year2 == 2010)
    {
      population2 = 8175133;
    }
    return (name, area, year1, population1, year2, population2);
  }

  return ("", 0, 0, 0, 0, 0);
}
// The example displays the following output:
//      Population change, 1960 to 2010: 393,149
```

- `Deconstruct` method of a class, struct, or interface allows you to retrieve and deconstruct a specific set of data from an object.
```c#
using System;

namespace Discards
{
  public class Person
  {
    public string FirstName { get; set; }
    public string MiddleName { get; set; }
    public string LastName { get; set; }
    public string City { get; set; }
    public string State { get; set; }

    public Person(string fname, string mname, string lname,
                  string cityName, string stateName)
    {
      FirstName = fname;
      MiddleName = mname;
      LastName = lname;
      City = cityName;
      State = stateName;
    }

    // Return the first and last name.
    public void Deconstruct(out string fname, out string lname)
    {
      fname = FirstName;
      lname = LastName;
    }

    public void Deconstruct(out string fname, out string mname, out string lname)
    {
      fname = FirstName;
      mname = MiddleName;
      lname = LastName;
    }

    public void Deconstruct(out string fname, out string lname,
                            out string city, out string state)
    {
      fname = FirstName;
      lname = LastName;
      city = City;
      state = State;
    }
  }
  class Example
  {
    public static void Main()
    {
      var p = new Person("John", "Quincy", "Adams", "Boston", "MA");

      // Deconstruct the person object.
      var (fName, _, city, _) = p;
      Console.WriteLine($"Hello {fName} of {city}!");
      // The example displays the following output:
      //      Hello John of Boston!
    }
  }
}
```

## Pattern Matching with `switch`
- Every expression, including `null`, always matches the discard pattern.
```c#
object?[] objects = { CultureInfo.CurrentCulture,
                   CultureInfo.CurrentCulture.DateTimeFormat,
                   CultureInfo.CurrentCulture.NumberFormat,
                   new ArgumentException(), null };
foreach (var obj in objects)
  ProvidesFormatInfo(obj);

static void ProvidesFormatInfo(object? obj) =>
  Console.WriteLine(obj switch
  {
    IFormatProvider fmt => $"{fmt.GetType()} object",
    null => "A null object reference: Its use could result in a NullReferenceException",
    _ => "Some object type without format information"
  });
// The example displays the following output:
//    System.Globalization.CultureInfo object
//    System.Globalization.DateTimeFormatInfo object
//    System.Globalization.NumberFormatInfo object
//    Some object type without format information
//    A null object reference: Its use could result in a NullReferenceException
```

## Calls to Methods with `out` Parameters
- When calling the Deconstruct method to deconstruct a user-defined type, can discard the values of individual out arguments. But can also discard the value of out arguments when calling any method with an `out` parameter.
```c#
string[] dateStrings = {"05/01/2018 14:57:32.8", "2018-05-01 14:57:32.8",
                      "2018-05-01T14:57:32.8375298-04:00", "5/01/2018",
                      "5/01/2018 14:57:32.80 -07:00",
                      "1 May 2018 2:57:32.8 PM", "16-05-2018 1:00:32 PM",
                      "Fri, 15 May 2018 20:10:57 GMT" };
foreach (string dateString in dateStrings)
{
  if (DateTime.TryParse(dateString, out _))
    Console.WriteLine($"'{dateString}': valid");
  else
    Console.WriteLine($"'{dateString}': invalid");
}
// The example displays output like the following:
//       '05/01/2018 14:57:32.8': valid
//       '2018-05-01 14:57:32.8': valid
//       '2018-05-01T14:57:32.8375298-04:00': valid
//       '5/01/2018': valid
//       '5/01/2018 14:57:32.80 -07:00': valid
//       '1 May 2018 2:57:32.8 PM': valid
//       '16-05-2018 1:00:32 PM': invalid
//       'Fri, 15 May 2018 20:10:57 GMT': invalid
```

# A Standalone Discard
- Indicate any variable that you choose to ignore.
- Typical use is to use assignment to ensure argument isn't `null`.
```c#
public static void Method(string arg)
{
  // Result isn't needed, but we want a forced null check
  _ = arg ?? throw new ArgumentNullException(paramName: nameof(arg), message: "arg can't be null");

  // Do work with arg.
}
```
```c#
private static async Task ExecuteAsyncMethods()
{
  Console.WriteLine("About to launch a task...");
  // Ignore returned Task object
  // Compiler warning if no assignment e.g.: Task.Run(() => ...
  _ = Task.Run(() =>
  {
    var iterations = 0;
    for (int ctr = 0; ctr < int.MaxValue; ctr++)
        iterations++;
    Console.WriteLine("Completed looping operation...");
    throw new InvalidOperationException();
  });
  await Task.Delay(5000);
  Console.WriteLine("Exiting after 5 second delay");
}
// The example displays output like the following:
//       About to launch a task...
//       Completed looping operation...
//       Exiting after 5 second delay
```
- `_` is a valid identifier; not discarded when used outside of suppoerted context.
```c#
private static void ShowValue(int _)
{
  byte[] arr = { 0, 0, 1, 2 };
  _ = BitConverter.ToInt32(arr, 0);
  Console.WriteLine(_);
}
 // The example displays the following output:
 //       33619968

// Type safety violation
private static bool RoundTrips(int _)
{
  string value = _.ToString();
  int newValue = 0;
  _ = Int32.TryParse(value, out newValue);
  return _ == newValue;
}
// The example displays the following compiler error:
//      error CS0029: Cannot implicitly convert type 'bool' to 'int'

public void DoSomething(int _)
{
 var _ = GetValue(); // Error: cannot declare local _ when one is already in scope
}
// The example displays the following compiler error:
// error CS0136:
//       A local or parameter named '_' cannot be declared in this scope
//       because that name is used in an enclosing local scope
//       to define a local or parameter
```

# Deconstructing Tuples and Other Types
```c#
// Tuple deconstruction syntaxes

// Infer type
var (name, address, city, zip) = contact.GetAddressInfo();
// Explicitly declare type
(string city, int population, double area) = QueryCityData("New York City");
// Mix
(string city, var population, var area) = QueryCityData("New York City");
// Deconstruct into existing variables
string city = "Raleigh";
int population = 458880;
double area = 144.8;

(city, population, area) = QueryCityData("New York City");

// C#10, mix variable and assignment
string city = "Raleigh";
int population = 458880;

(city, population, double area) = QueryCityData("New York City");

// And discards are valid
```

## User-Defined Types
- Only `record` and `DictionaryEntry` are supported natively.
  - Authors can deconstruct class, struct, or interface by implementing `Deconstruct` methods.
    - `Deconstruct` returns void and each value to be deconstructed indicated by an `out` parameter in method signature.
```c#
using System;

public class Person
{
  public string FirstName { get; set; }
  public string MiddleName { get; set; }
  public string LastName { get; set; }
  public string City { get; set; }
  public string State { get; set; }

  public Person(string fname, string mname, string lname,
                string cityName, string stateName)
  {
    FirstName = fname;
    MiddleName = mname;
    LastName = lname;
    City = cityName;
    State = stateName;
  }

  // Return the first and last name.
  public void Deconstruct(out string fname, out string lname)
  {
    fname = FirstName;
    lname = LastName;
  }

  public void Deconstruct(out string fname, out string mname, out string lname)
  {
    fname = FirstName;
    mname = MiddleName;
    lname = LastName;
  }

  public void Deconstruct(out string fname, out string lname,
                          out string city, out string state)
  {
    fname = FirstName;
    lname = LastName;
    city = City;
    state = State;
  }
}

public class ExampleClassDeconstruction
{
  public static void Main()
  {
    var p = new Person("John", "Quincy", "Adams", "Boston", "MA");

    // Deconstruct the person object.
    var (fName, lName, city, state) = p;
    Console.WriteLine($"Hello {fName} {lName} of {city}, {state}!");
  }
}
// The example displays the following output:
//    Hello John Adams of Boston, MA!

// Discards are valid
// Deconstruct the person object.
var (fName, _, city, _) = p;
Console.WriteLine($"Hello {fName} of {city}!");
// The example displays the following output:
//      Hello John of Boston!
```

## Extension Methods for User-defined Types
- Multiple deconstruct methods for specific values.
```c#
using System;
using System.Collections.Generic;
using System.Reflection;

public static class ReflectionExtensions
{
  public static void Deconstruct(this PropertyInfo p, out bool isStatic,
                                  out bool isReadOnly, out bool isIndexed,
                                  out Type propertyType)
  {
    var getter = p.GetMethod;

    // Is the property read-only?
    isReadOnly = ! p.CanWrite;

    // Is the property instance or static?
    isStatic = getter.IsStatic;

    // Is the property indexed?
    isIndexed = p.GetIndexParameters().Length > 0;

    // Get the property type.
    propertyType = p.PropertyType;
  }

    public static void Deconstruct(this PropertyInfo p, out bool hasGetAndSet,
                                   out bool sameAccess, out string access,
                                   out string getAccess, out string setAccess)
  {
    hasGetAndSet = sameAccess = false;
    string getAccessTemp = null;
    string setAccessTemp = null;

    MethodInfo getter = null;
    if (p.CanRead)
      getter = p.GetMethod;

    MethodInfo setter = null;
    if (p.CanWrite)
      setter = p.SetMethod;

    if (setter != null && getter != null)
      hasGetAndSet = true;

    if (getter != null)
    {
      if (getter.IsPublic)
        getAccessTemp = "public";
      else if (getter.IsPrivate)
        getAccessTemp = "private";
      else if (getter.IsAssembly)
        getAccessTemp = "internal";
      else if (getter.IsFamily)
        getAccessTemp = "protected";
      else if (getter.IsFamilyOrAssembly)
        getAccessTemp = "protected internal";
    }

    if (setter != null)
    {
      if (setter.IsPublic)
        setAccessTemp = "public";
      else if (setter.IsPrivate)
        setAccessTemp = "private";
      else if (setter.IsAssembly)
        setAccessTemp = "internal";
      else if (setter.IsFamily)
        setAccessTemp = "protected";
      else if (setter.IsFamilyOrAssembly)
        setAccessTemp = "protected internal";
    }

    // Are the accessibility of the getter and setter the same?
    if (setAccessTemp == getAccessTemp)
    {
      sameAccess = true;
      access = getAccessTemp;
      getAccess = setAccess = String.Empty;
    }
    else
    {
      access = null;
      getAccess = getAccessTemp;
      setAccess = setAccessTemp;
    }
  }
}

public class ExampleExtension
{
  public static void Main()
  {
    Type dateType = typeof(DateTime);
    PropertyInfo prop = dateType.GetProperty("Now");
    var (isStatic, isRO, isIndexed, propType) = prop;
    Console.WriteLine($"\nThe {dateType.FullName}.{prop.Name} property:");
    Console.WriteLine($"   PropertyType: {propType.Name}");
    Console.WriteLine($"   Static:       {isStatic}");
    Console.WriteLine($"   Read-only:    {isRO}");
    Console.WriteLine($"   Indexed:      {isIndexed}");

    Type listType = typeof(List<>);
    prop = listType.GetProperty("Item",
                                BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static);
    var (hasGetAndSet, sameAccess, accessibility, getAccessibility, setAccessibility) = prop;
    Console.Write($"\nAccessibility of the {listType.FullName}.{prop.Name} property: ");

    if (!hasGetAndSet | sameAccess)
    {
      Console.WriteLine(accessibility);
    }
    else
    {
      Console.WriteLine($"\n   The get accessor: {getAccessibility}");
      Console.WriteLine($"   The set accessor: {setAccessibility}");
    }
  }
}
// The example displays the following output:
//       The System.DateTime.Now property:
//          PropertyType: DateTime
//          Static:       True
//          Read-only:    True
//          Indexed:      False
//
//       Accessibility of the System.Collections.Generic.List`1.Item property: public
```

## Extension Method for System Types
- Provided for convenience.
```c#
Dictionary<string, int> snapshotCommitMap = new(StringComparer.OrdinalIgnoreCase)
{
    ["https://github.com/dotnet/docs"] = 16_465,
    ["https://github.com/dotnet/runtime"] = 114_223,
    ["https://github.com/dotnet/installer"] = 22_436,
    ["https://github.com/dotnet/roslyn"] = 79_484,
    ["https://github.com/dotnet/aspnetcore"] = 48_386
};

foreach (var (repo, commitCount) in snapshotCommitMap)
{
  Console.WriteLine(
    $"The {repo} repository had {commitCount:N0} commits as of November 10th, 2021.");
}
```
- Can add `Deconstruct` method to system types that don't have one.
```c#
public static class NullableExtensions
{
  public static void Deconstruct<T>(
    this T? nullable,
    out bool hasValue,
    out T value) where T : struct
  {
    hasValue = nullable.HasValue;
    value = nullable.GetValueOrDefault();
  }
}

// Usage
DateTime? questionableDateTime = default;
var (hasValue, value) = questionableDateTime;
Console.WriteLine(
  $"{{ HasValue = {hasValue}, Value = {value} }}");

questionableDateTime = DateTime.Now;
(hasValue, value) = questionableDateTime;
Console.WriteLine(
  $"{{ HasValue = {hasValue}, Value = {value} }}");

// Example outputs:
// { HasValue = False, Value = 1/1/0001 12:00:00 AM }
// { HasValue = True, Value = 11/10/2021 6:11:45 PM }
```

## `record` Types
- When you declare a `record` type by using two or more positional parameters, the compiler creates a `Deconstruct` method with an `out` parameter for each positional parameter in the `record` declaration.
