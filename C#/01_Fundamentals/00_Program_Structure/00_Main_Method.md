<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 30
  Purpose: C# Main Method
-->

# Main
- Can be declared in a class or struct.
  - Must be `static` and it need not be public.
- Can have `void int Task Task<int>` return type.
  - If, and only if, returns `Task` or `Task<int>`, may include `async` modifier. Specifically excludes `async void Main` method.
  - `async` and `Task Task<int>` returns types simplifies code when console applications need to start and `await` asynchronous operations in `Main`.
- Can be declared with or without `string[] args`.
  - When using VS to create Windows applications, can add parameter manually or use `GetCommandLineArgs()` method.
  - Name of program is **not** the first command-line argument of args array, but is for `GetCommandLineArgs()`.
- Can have multiple classes with `Main`, but you must compile with **StartupObject** compiler option and specify which main method to use.
- Can omit `Main` starting **C#9**.
```c#
// Valid Main signatures
// "public" typical but not required
public static void Main() { }
public static int Main() { }
public static void Main(string[] args) { }
public static int Main(string[] args) { }
public static async Task Main() { }
public static async Task<int> Main() { }
public static async Task Main(string[] args) { }
public static async Task<int> Main(string[] args) { }
```

- Returning `int` or `Task<int>` enables program to communicate status information to other programs or scripts that invoke the executable file.
```c#
// Example retrieve exit code

// C#
class MainReturnValTest
{
  static int Main()
  {
    //...
    return 0;
  }
}

// PowerShell
dotnet run
if ($LastExitCode -eq 0) {
    Write-Host "Execution succeeded"
} else
{
    Write-Host "Execution Failed"
}
Write-Host "Return value = " $LastExitCode
```
- Return value stored in env variable (Windows) and retrieved using `ERRORLEVEL` from batch or `$LastExitCode` from PowerShell.

# Async Main Return Values
- When declare `async` for `Main`, compiler generates boilerplate code for calling asynchronous methods in `Main`.
  - If you don't specify `async`, you have to write this code yourself.
    - Typically better to allow compiler to write it.
```c#
// Example boilerplate async
public static void Main()
{
  AsyncConsoleWork().GetAwaiter().GetResult();
}

private static async Task<int> AsyncConsoleWork()
{
  // Main body here
  // Runs until async operation completed
  return 0;
}

// Can be replaced by
static async Task<int> Main(string[] args)
{
    return await AsyncConsoleWork();
}
```
- When entry point returns a `Task` or `Task<int>`, compiler geberates new entry point that calls the entry point method declared in the application code.
- Assuming this entry point is called `$GeneratedMain`, compiler generates the following code for these entry points (same if `async` used):
  - `static Task Main()` results in the compiler emitting the equivalent of `private static void $GeneratedMain() => Main().GetAwaiter().GetResult();`
  - `static Task Main(string[])` results in the compiler emitting the equivalent of `private static void $GeneratedMain(string[] args) => Main(args).GetAwaiter().GetResult();`
  - `static Task<int> Main()` results in the compiler emitting the equivalent of `private static int $GeneratedMain() => Main().GetAwaiter().GetResult();`
  - `static Task<int> Main(string[])` results in the compiler emitting the equivalent of `private static int $GeneratedMain(string[] args) => Main(args).GetAwaiter().GetResult();`

# Command-Line Arguments
- Check args with `.Length` property.
  - `args` can't be `null`, so it's safe to access `Length` without null checking.
```c#
if (args.Length == 0)
{
  System.Console.WriteLine("Please enter a numeric argument.");
  return 1;
}
```
- Convert string arguments to numerics using `Convert` class or `Parse` method.
```c#
long num = Int64.Parse(args[0]);
// Aliases Int64
long num = long.Parse(args[0]);

// Using Convert
long num = Convert.ToInt64(s);
```

```c#
// Example args (one) to integer and calculate factorial
public class Functions
{
  public static long Factorial(int n)
  {
    // Test for invalid input.
    if ((n < 0) || (n > 20))
    {
      return -1;
    }

    // Calculate the factorial iteratively rather than recursively.
    long tempResult = 1;
    for (int i = 1; i <= n; i++)
    {
      tempResult *= i;
    }
    return tempResult;
  }
}

class MainClass
{
  static int Main(string[] args)
  {
    // Test if input arguments were supplied.
    if (args.Length == 0)
    {
      Console.WriteLine("Please enter a numeric argument.");
      Console.WriteLine("Usage: Factorial <num>");
      return 1;
    }

    // Try to convert the input arguments to numbers. This will throw
    // an exception if the argument is not a number.
    // num = int.Parse(args[0]);
    int num;
    bool test = int.TryParse(args[0], out num);
    if (!test)
    {
      Console.WriteLine("Please enter a numeric argument.");
      Console.WriteLine("Usage: Factorial <num>");
      return 1;
    }

    // Calculate factorial.
    long result = Functions.Factorial(num);

    // Print result.
    if (result == -1)
      Console.WriteLine("Input must be >= 0 and <= 20.");
    else
      Console.WriteLine($"The Factorial of {num} is {result}.");

    return 0;
  }
}
// If 3 is entered on command line, the
// output reads: The factorial of 3 is 6.
```

# Top Level Statements
- Since C#9, don't need explicit `Main` method in console application.
- Application must have only one entry point. Project can have only one file with top-level statements.
  - Project can have additional source code files that don't have top-level statements
- Can explicitly write `Main` method, but it can't function as entry point.
  - `-main` compiler option can't be used.
- `using` directives must be first in the file.
- Top-level statements implicitly in global namespace.
- Can have namespaces and type definitions, but must come *after* top-level statements.
```c#
MyClass.TestMethod();
MyNamespace.MyClass.MyMethod();

public class MyClass
{
  public static void TestMethod()
  {
    Console.WriteLine("Hello World!");
  }

}

namespace MyNamespace
{
  class MyClass
  {
    public static void MyMethod()
    {
        Console.WriteLine("Hello World from MyNamespace.MyClass.MyMethod!");
    }
  }
}
```
- Top-level statements can reference `args` variable.
  - `args` never null, but length is zero if no command-line arguments provided.
- Can use `await`.
```c#
Console.Write("Hello ");
await Task.Delay(5000);
Console.WriteLine("World!");
```
- Can return exit code at the end.
```c#
string? s = Console.ReadLine();

int returnValue = int.Parse(s ?? "-1");
return returnValue;
```

## Implicit Entry Point Method
 | Top-level code contains | Implicit `main` signature |
 | ----------------------- | ------------------------- |
 | `await` and `return` | `static async Task<int> Main(string[] args)` |
 | `await` | `static async Task Main(string[] args)` |
 | `return` |	`static int Main(string[] args)` |
 | No `await` or `return` | `static void Main(string[] args)` |