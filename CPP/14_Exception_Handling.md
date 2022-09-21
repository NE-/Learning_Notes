<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 21
  Purpose: C++ Templates
-->

# Exceptions
- Exception handling works by going up the call stack (stack unwinding) when an exception has been caught. This backwards flow allows the program to "fix" anything that may cause the program to crash or perform unwanted or impossible behavior.
- Can be performance costly when an exception is thrown, even for zero-cost exceptions.

## Throwing Exception
- Exception or error case occured, we signal that certain error condition. Known as throwing, or raising, an exception.
- Use `throw` statement to execute the appropriate error handler.
  - Can have any primary expression in a throw statement.
```cpp
throw -1;             // terminate called after throwing 'int'
throw new int[8];     // terminate called after throwing 'int*'
throw "string";       // terminate called after throwing 'char const*'
throw MyClass{};      // terminate called after throwing 'MyClass'
throw 6 < 9 && 7 < 0; // terminate called after throwing 'bool'
throw 5 + 9 - 45;     // terminate called after throwing 'int'

// This is AKA rethrowing the object
throw; // terminate called without an active exception.
```
- These are "uncaught exceptions" that only call std::terminate.
## Try-Block
- Statements that look for thrown exceptions and appropriately handle those exceptions.
```cpp
// This is a compiler error (missing catch), just showing syntax.
try {
  // compound-statement
  // can have normal code.
  int i = 0;
  i = 7 + 9;

  throw i;
}

// 'i' does not exist outside the try-block
```
- To actually resolve the `throw`, we use a *catch-block*.
## Catch-Block
- AKA *catch-clause*, used to catch a thrown exception.
- Can have individual catch blocks to handle individual throws, or one "catch-all" to catch any kind of exception.
```cpp
try {
  // Throw an int
  throw 5;

  // Throw a double
  throw 7.8;
}
catch(int x) {
  std::cerr << "Caught int " << x;
}
catch(double x) {
  std::cerr << "Caught double " << x;
}
// the catch-all handler
// MUST be last
catch(...) {
  std::cerr << "Caught something, but we don't know what type";

}
```
- Catch-all used mostly to ignore exceptions we never meant to throw, catch anything abnormal, or catch library throws we have no control over.

## Function Try-Block
- Functions with a try-block as a body.
```cpp
std::size_t validateIndex(std::size_t i) try {
  if (i > 5)
    throw "ERROR: Out of bounds ";
  
  return i;
}
catch(char const* error) {
  /*
    Function parameters
    still exist here,
    but variables decalred
    inside the function (try{})
    don't.
   */
  std::cout << error << i;

  /*
    non-void function must
    still return its type
   */
  return 0;
}

// Usage
validateIndex(4); // just returns 4

validateIndex(99); // ERROR: Out of bounds 99
```

# `std::exception`
- Used to make your own exceptions.
```cpp
/*
  ERROR (shortened)
  terminate called after throwing
  std::out_of_range

  what(): __pos is 10, 
          this->size() is 3
 */
std::string{"qwe"}.substr(10);

// We never see this
std::cout << "Hello from line " << __LINE__ << '\n';
```
- In this case, `std::out_of_range` was thrown from the internals of `substr`. 
- `what()` is a virtual function part of `std::exception` to give explanation of what has been thrown.
```cpp
try {
  std::string{"qwe"}.substr(10);
} 
catch(const std::exception& e) {
  cout << e.what() << '\n';
}

// We see this now
std::cout << "Hello from line " << __LINE__ << '\n';

/** To be more specific **/

```cpp
try {
  std::string{"qwe"}.substr(10);
} 
catch(const std::out_of_range& e) {
  cout << e.what() << '\n';
}

// We see this now
std::cout << "Hello from line " << __LINE__ << '\n';
```
- Can instantiate `std::out_of_range` and change the `what`, but it is typically not recommended to do so unless there is great need to.
```cpp
try {
  throw std::out_of_range{ "Custom Message" };
} 
catch(const std::out_of_range& e) {
  cout << e.what() << '\n'; // Custom Message
}
```
```cpp
// Example custom throws
// Test 1
std::size_t validateIndex(std::size_t i) {
  if (i > 5)
    throw std::out_of_range{ "ERROR: Out of bounds" };

  return i;
}

// Usage
try {
  validateIndex(99);
}
// This one called since it's a base of std::out_of_range
// Compiler warns about it
catch(const std::exception& e) {
  cout << "std::exception\n";
}
catch(const std::out_of_range& e) {
  cout << "std::out_of_range\n";
}


// Test 2
std::size_t validateIndex(std::size_t i) {
  if (i > 5)
    throw std::out_of_range{ "ERROR: Out of bounds" };

  return i;
}

// Usage
try {
  validateIndex(99);
}
// This one called since checks go one-by-one
// and this is first valid exception
catch(const std::out_of_range& e) {
  cout << "std::out_of_range\n";
}
catch(const std::exception& e) {
  cout << "std::exception\n";
}
```
# Exception Class
- Recommended to use if you need to overwrite objects that inherit from `std::exception` or for customized exceptions that don't exist in std::exception.
```cpp
// Derive from std::exception
class MyException : public std::exception {
  private:
    std::string m_msg;
  public:
    Exception(const std::string& msg) : m_msg{msg}{}

    // Override the what()
    virtual const char* what() const noexcept override {
        return m_msg.c_str();
    }
};

// Don't need to derive from std::exception
class MyException {
  private:
    std::string m_error{};

  public:
    MyException(const std::string& e) :
      m_error{ e } 
    {}

    std::string_view getError() const {
      return m_error;
    }
};

// Usage
try {
  if (9 > 10)
    throw MyException{ "9 is greater than 10" };
}
catch(const MyException& e) {
  std::cout << e.getError(); // 9 is greater than 10

  // If using derived version.
  std::cout << e.what(); // 9 is greater than 10
}
```
# `noexcept`
- Specifier that tells us a function will not (or can't) throw an exception.
- Can help the compiler optimize the function further, but it is often abused or overused which can cause more harm than good (early termination).
  - If you truly know your function won't throw an exception anywhere it's used (especially with other libraries you don't know the inner workings of), then add `noexcept`; otherwise omit it.

- If a function doesn't throw an exception, the compiler will "bare" it, else it will add `std::terminate` (reason for "terminate called after throwing..." message).
  - In code, exceptions will not be caught regardless if it's in a try-catch block and just treminate the program.
- `noexcept` preferred over `throw(<exception-list>)`.
```cpp
// Marked noexcept
std::size_t validateIndex(std::size_t i) noexcept {
  if (i > 5)
    // If this is reached, std::terminate is called instead
    throw std::out_of_range{ "ERROR: Out of bounds" };

  return i;
}

// Usage
try {
  validateIndex(99);
}
// Never caught, terminate called instead
catch(const std::exception& e) {
  cout << e.what() << '\n';
}
```
## `noexcept(<boolean-expression>)`
- Specifies whether a function could throw exceptions.
  - Returns *true* (non-throwing) or *false* (potentially-throwing).
```cpp
int f1() { 
  std::cout << "f1";
  return 999; 
}

int f2() noexcept { 
  std::cout << "f2";
  return 21; 
}

// Set it to not throw
int f3() noexcept(true) {
  return 123;
}

// Set it to throw
int f4() noexcept(false) {
  return 123;
}

class A{};

class B{
  public:
    B(){}
};


// Usage
std::cout << std::boolalpha; // for true false output

/*
  Function is never called, but 
  we must use '()' since address
  is always true

  Is this function non-throwing?
  true = yes this function
         does NOT throw

  false = no this function
          DOES throw

  Function address is always true
  noexcept(function) always true
 */
// Functions are implicitly potentially-throwing
std::cout << noexcept(f1()); // false
std::cout << noexcept(f2()); // true

std::cout << noexcept(f3()); // true
std::cout << noexcept(f4()); // false

// Default, copy, and move constructors are implicitly non-throwing
std::cout << noexcept(A{});  // true
// User-defined constructors are implicitly potentially-throwing
std::cout << noexcept(B{});  // false

// ints and bools are non-throwing
std::cout << noexcept(123 + 456); // true

/*
  In this case, not the
  function case, it's always
  true because it's evaluating
  a raw boolean.
 */
std::cout << noexcept(false); // true
std::cout << noexcept(true);  // true
```
# When to Use Exception Handling
- Exception blocks can be expensive so using them all the time may not be ideal. Use them when:
  - The error is serious and may cause the rest of the program to not work or crash.
  - A function you're using is explicitly (or even implicitly) potentially-throwing (such as functions in libraries we didn't write e.g. `substr`).
  - The error can't be handled where it occurs.
  - Conditionals, branches, or return error codes can't be used for some reason.
  