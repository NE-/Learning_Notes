<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 30
  Purpose: C# Major Language Areas
-->

# Arrays., Collections, LINQ
- Generic collection types listed `System.Collections.Generic`.
## Arrays
- Reference types. Declaring array variable sets aside space for a reference to an array instance.
  - Actual instances created dynamically at run-time with `new`.
  - Default initializes elements to 0 for numeric types and `null` for reference types.
```c#
// User initialized array
int[] a0 = new int[] { 0, 2, 3, 5 };
int[] a01 = { 0, 2, 3, 5 }; // Shorter syntax

int[]   a1 = new int[10];     // 1D
int[,]  a2 = new int[10,5];   // 2D
int[,,] a3 = new int[10,5,2]; // 3D

// Jagged
// Initialized to null
int[][] a4 = new int[3][];
a4[0] = new int[10];
a4[0] = new int[5];
a4[0] = new int[20];
```
- Array with elements of array type is sometimes called *jagged array*.
- Traverse through any collection with `foreach`.
```c#
foreach (int item in a)
{
  Console.WriteLine(item);
}
```

# String Interpolation
- Format strings in format expressions.
  - Uses `$` token and evaluates expression between `{}` then converts to string.
  - `:` specifies the format string.
```c#
Console.WriteLine($"The low and high temperature on {weatherData.Date:MM-DD-YYYY}");
Console.WriteLine($"    was {weatherData.LowTemp} and {weatherData.HighTemp}.");
// Output (similar to):
// The low and high temperature on 08-11-2020
//     was 5 and 30.
```

# Delegates and Lambda Expressions
- Delegate reference to methods with particular parameter list and return type.
  - "Function pointers" that are objects and type-safe.
```c#
delegate double Function(double x);

class Multiplier
{
  double _factor;

  public Multiplier(double factor) => _factor = factor;

  public double Multiply(double x) => x * _factor;
}

class DelegateExample
{
  static double[] Apply(double[] a, Function f)
  {
    var result = new double[a.Length];
    for (int i = 0; i < a.Length; i++) result[i] = f(a[i]);
    return result;
  }

  public static void Main()
  {
    double[] a = { 0.0, 0.5, 1.0 };
    double[] squares = Apply(a, (x) => x * x);
    double[] sines = Apply(a, Math.Sin);
    Multiplier m = new(2.0);
    double[] doubles = Apply(a, m.Multiply);

    // Lambda version
    double[] doublesL = Apply(a, (double x) => x * 2.0);

  }
}
```

# Async/Await
- Asynchronous programming keywords.
- `async` modifier added to method to declare it asynchronous.
- `await` operator tells the compiler to asynchronously await for the result to finish.
  - Control returned to the caller.
  - Method returns a structure (typically `System.Threading.Tasks.Task<TResult>`, or another supported awaiter) that manages the state of the asynchronous work.
```c#
// Example downloads home page for Microsoft docs

public async Task<int> RetrieveDocsHomePage()
{
  var client = new HttpClient();
  byte[] content = await client.GetByteArrayAsync("https://docs.microsoft.com/");

  Console.WriteLine($"{nameof(RetrieveDocsHomePage)}: Finished downloading.");

  return content.Length;
}
```

# Attributes
- Modifiers (for types, members, and other entities) that control certain aspects of their behavior.
- All derive from `Attribute` class.
```c#
public class HelpAttribute : Attribute
{
  string _url;
  string _topic;

  public HelpAttribute(string url) => _url = url;

  public string Url => _url;

  public string Topic
  {
    get => _topic;
    set => _topic = value;
  }
}

// Usage
// "Attribute" from HelpAttribute can be omitted!
// - only if at the end of the name.
[Help("https://docs.microsoft.com/dotnet/csharp/tour-of-csharp/features")]
public class Widget
{
  [Help("https://docs.microsoft.com/dotnet/csharp/tour-of-csharp/features",
  Topic = "Display")]
  public void Display(string text) { }
}
```
- Metadata defined by attributes can be read and manipulated at run time using reflection.
  - Constructor is invoked with info provided in source.
    - Attribute instance is returned.
```c#
Type widgetType = typeof(Widget);

object[] widgetClassAttributes = widgetType.GetCustomAttributes(typeof(HelpAttribute), false);

if (widgetClassAttributes.Length > 0)
{
  HelpAttribute attr = (HelpAttribute)widgetClassAttributes[0];
  Console.WriteLine($"Widget class help URL : {attr.Url} - Related topic : {attr.Topic}");
}

System.Reflection.MethodInfo displayMethod = widgetType.GetMethod(nameof(Widget.Display));

object[] displayMethodAttributes = displayMethod.GetCustomAttributes(typeof(HelpAttribute), false);

if (displayMethodAttributes.Length > 0)
{
  HelpAttribute attr = (HelpAttribute)displayMethodAttributes[0];
  Console.WriteLine($"Display method help URL : {attr.Url} - Related topic : {attr.Topic}");
}
```
