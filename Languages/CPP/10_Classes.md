<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 20
  Purpose: C++ Classes
-->

# Class Basics
- User-defined data-types that construct objects.
```cpp
// Basic class structure
// Normally defined in a header file
class MyClass {
  // Only the class can access these
  private:
    int m_x;
    int m_y;

  // Can be accessed outside of the class
  public:
    MyClass();
    ~MyClass();
    
    int add();
    int m_public;
};

// Normally defined in a cpp file
MyClass::MyClass() {
  m_x = 0;
  m_y = 0;
}

int MyClass::add() {
  return m_x + m_y;
}
```
- More modern class syntax
```cpp
class Modern {
  private:
    int m_x{ 1 };
    int m_y{ 2 };
    const int m_const{ 12 };

  public:
    // Members already initialized; no need for constructor
    // Compiler makes a default constructor
    Modern() = default;

    // Using member initializer list
    // members initialized based on their declaration order
    Modern(int x, int y=44)
      : m_x{ x },
        m_y{ y },
        m_const{ 12 }
    { /* function body */ }
    
    // Accessors
    int getX() const { return m_x; }
    int getY() const { return m_y; }

    // Mutators
    void setX(int x){ m_x = x; }
    void setY(int y){ m_y = y; }
};

Modern m{ 99, 88 }; // Initializer list rather than direct
```
- If you don't specify `public` or `private`, the members are `private` by default.
- Compilers make default constructors and destructors if left out.

## Mutators and Accessors
- Mutators and accessors allow for changing or accessing the private data in a class, respectively.
```cpp
// Naming conventions

// Accessors get[identifier]
// const says the member(s) shouldn't be modified from the function
// - "this" is const
int getX() const { return m_x; }
int getY() const { return m_y; }

// Mutators set[identifier]
void setX(int x){ m_x = x; }
void setY(int y){ m_y = y; }

// Combine both by returning reference, though not recommended!!
int& getX() { return m_x; }
int& getY() { return m_y; }

// Usage of reference style
MyClass myClass(11);
myClass.getX();       // returns 11
myClass.getX() = 234; // sets m_x to 234
```

## Delegate Constructors
- Used to decrease DRY code in constructors.
```cpp
Constructor() {
  m_q = 1;
  m_w = 1;
  m_e = 1;
}
Constructor(int q) {
  m_q = q;
  m_w = 1;
  m_e = 1;
}
Constructor(int q, int w) {
  m_q = q;
  m_w = w;
  m_e = 1;
}
Constructor(int q, int w, int e) {
  m_q = q;
  m_w = w;
  m_e = e;
}


// Cant do this
Constructor(int q, int w, int e) {
  Constructor(q, w);
  m_e = e;
}

// Do this instead
Constructor(int q=1, int w=1, int e=1) :
  m_q{ q }, m_w{ w }, m_e{ e }
{}

// Delegate
Constructor(int q=1) : 
  // Calls the above which initializes everything
  Constructor{ q, 1, 1 }
{}
```
- Risk to use as they can cause infinite loops and crash stack space if not careful.

# Operator Overloading
- Rewrite the function of an operator.
- Cant overload `?: . .* :: typeid sizeof` and any casting operators.
- Arity level, precedence, and associativity remain the same.
- Free-function definitions partake in implicit conversions and are preferred. Sometimes free-functions just can't be used.
  - Member functions also partake, but aren't guaranteed to do so.
```cpp
class MyInt {
  private:
    int m_i{};
  public:
    MyInt(int i{0}) : m_i{i}{}

    int getInt() const { return m_i; }
};

// Free function
MyInt operator+(const MyInt& m1, const MyInt& m2) {
  return MyInt{ m1.getInt() + m2.getInt() };
}

// Usage
MyInt m1{ 9 };
MyInt m2{ 3 };
MyInt m3{ m1 + m2 };
MyInt m4{ m1 + 7 }; // LEGAL does implicit conversion.
MyInt m5{ 7 + m2 }; // LEGAL does implicit conversion.
MyInt m6{ 7 + 12 }; // LEGAL does implicit conversion.

std::cout << m3.getInt(); // 12
std::cout << m4.getInt(); // 16
std::cout << m5.getInt(); // 10
std::cout << m6.getInt(); // 19


// ILLEGAL
std::cout << m1 + m2; // ERROR no operator << for type MyInt
```
- As member function example.
```cpp
class MyInt {
  private:
    int m_i{};
  public:
    MyInt(int i{0}) : m_i{i} {}

    // Only RHS parameter needed
    MyInt operator+(const MyInt& m2);

    int getInt() const { return m_i; }
};

MyInt MyInt::operator+(const MyInt& m2) {
  return MyInt{ m_i + m2.getInt() };
}

// Usage
MyInt m1{ 2 };
MyInt m2{ 3 };
MyInt m3{ m1 + m2 };
// Implicit conversion not guaranteed, though it worked fine with clang
MyInt m4{ m3 + 56 };
MyInt m5{ 77 + 4 };
```
## Friends
- Friend functions allow a function to access private members of a class.
  - The class must know which function(s) are friends.
  - Different classes can have the same friends.
- Since friend functions have access to private members, they are a danger! Also, the only benefit of friend versus non-friend is the access to private members, so people usually recommend using against them. All depends on your program.
```cpp
class MyInt {
  private:
    int m_i{};
  public:
    MyInt(int i{0}) : m_i{ i } {}

    int getInt() const { return m_i; }

    // Let the class know, but it's defined elsewhere
    friend MyInt operator+(const MyInt& m1, const MyInt& m2);
};

MyInt operator+(const MyInt& m1, const MyInt& m2) {
  return MyInt{ m1.m_i + m2.m_2 };
}
```
### Which Function to Use
- If binary operator **WONT** modify left operand, normal or friend for the implicit conversion.
- If binary operator **WILL** modify left operand (common with assignment operators), prefer member functions since left must always be a class type.
- Unary operators are typically members since they don't require any outside influence.
- Operators that require *fixed* parameters (such as the stream operators) should be normal or friends.

## IO Stream Overloading
### Ostream
- Binary operator `<<` where lhs is `std::cout` and rhs is data to be printed.
- Copies of ostream are forbidden, so we must return by reference.
```cpp
#include <iostream>

class Vec2D {
  private:
    double m_x{};
    double m_y{};
  
  public:
    Vec2D(double x{0.0}, double y{0.0})
      : m_x{x}, m_y{y} {}
    
    friend std::ostream& operator<<(std::ostream& out, const Vec2D& v);
};

std::ostream& operator<<(std::ostream& out, const Vec2D& v) {
  // Sending data to "out" stream
  out << 
    "Location: (" <<
    v.m_x << ", " <<
    v.m_y << ")\n";

  return out;
}

// Usage
Vec2D player{2.0, 6.0};
std::cout << player;
```
### Istream
- Same as ostream, but since we do change members, the rhs object can't be const.
```cpp
#include <iostream>

class Vec2D {
  private:
    double m_x{};
    double m_y{};
  
  public:
    Vec2D(double x{0.0}, double y{0.0})
      : m_x{x}, m_y{y} {}
    
    friend std::ostream& operator<<(std::ostream& out, const Vec2D& v);
    friend std::istream& operator>>(std::istream& in, Vec2D& v);
};

std::ostream& operator<<(std::ostream& out, const Vec2D& v) {
  // Sending data to "out" stream
  out << 
    "Location: (" <<
    v.m_x << ", " <<
    v.m_y << ")\n";

  return out;
}

std::istream& operator>>(std::istream& in, Vec2D& v) {
  // Getting data from "in" stream
  in >> v.m_x;
  in >> v.m_y;

  return in;
}

// Usage
Vec2D player{};
std::cin  >> player;
std::cout << player;
```
## Unary Operators
- Same as binary but without parameters.
```cpp
class MyInt{
  ...
  MyInt operator-() const {
    /*
      Implicit conversion is assumed,
      but curly braces tells the
      reader there is conversion
      going on versus returning a
      negative literal (int in this case).
     */
    return { -m_i };
  }
  ...
};

// Usage
MyInt mi{23};
// Shows we're returning MyInt not a literal
std::cout << (-mi).getInt();
```
- Logical negation `!` must return a bool.
## Comparison Operators
- Same, just return booleans.
```cpp
class Vec2D {
  ...
  friend bool operator==(const Vec2D& v1, const Vec2D& v2);
};

bool operator==(const Vec2D& v1, const Vec2D& v2) {
  return (
    v1.m_x == v2.m_x &&
    v1.m_y == v2.m_y
  );
}

// Usage
Vec2D player {4.5, 8.3};
Vec2D monster {44.5, 23.3};
if (player == monster) {
  std::cout << "Player hit!\n";
}
```
### Tricks
```cpp
/*
  !=
  != is the same as !(x == y)

  is x the same as y?
  if yes, evaluate to
  true then flip to 
  false because they
  ARE equal.

  is x different from y?
  if yes, evaluate to
  false then flip to
  true because they
  ARE NOT equal.
 */
bool operator==(a, b) {
  return a.x == b.x;
}

bool operator !=(a, b) {
  return !(operator==(a,b));
}



/*
  >
  x > y is the same as 
  y < x

  Same results when 
  we flip everything.
 */
bool operator<(a, b) {
  return a.x < b.x;
}

bool operator>(a, b) {
  return operator<(b, a);
}



/*
  <= and >=
  <= is the same as
  !(x > y)

  5 <= 7 ? Yes!
  5 > 7  ? No!
  !(No)  ? Yes!

  6 <= 2 ? No!
  6 > 2  ? Yes!
  !(Yes) ? No!

  >= is the same as
  !(x < y)
 */
bool operator<=(a, b) {
  return !(operator>(a, b));
}

bool operator>=(a, b) {
  return !(operator<(a, b));
}
```
## Post and Prefix Operators
- Prefix has *no* parameters and postfix takes an anonymous `int`.
- Prefix returns a pointer to itself for chaining operators.
- Postfix returns its old state.
```cpp
class MyInt {
  ...
  // Prefix
  MyInt& operator++() {
    ++m_i;

    return *this;
  }

  // Postfix
  MyInt operator++(int) {
    // Keep old state
    MyInt temp{ *this };

    // Increment with prefix we defined earlier
    ++(*this);

    // Return copy
    return temp;
  }
};

// Usage
MyInt mi{0};
std::cout << ++mi; // 1
std::cout << mi++; // 1
std::cout << mi;   // 2
```
## Assignment Operator
- Straight forward, just watch out for self assignment.
```cpp
MyInt& operator=(const MyInt& mi) {
  // Check for self assignment
  if (this == &mi) {
    return *this;
  }

  // Write new data
  m_i = mi.m_i;

  return *this;
}
```

# Copy Constructors
- Constructors that copy the contents of another instantiated class of the same type. Memberwise initialization, or shallow copy.
```cpp
class Vec3D {
  private:
    double m_x{};
    double m_y{};
    double m_z{};
  
  public:
    Vec3D(double x=0, double y=0, double z=0)
      : m_x{x}, m_y{y}, m_z{z} {}

    // Copy constructor
    Vec3D(const Vec3D& v)
      : m_x{v.m_x}, m_y{v.m_y}, m_z{v.m_z} {}
};

// Usage
Vec3D cube0{ 0.0, 2.4, 56.6 };
Vec3D cube1{ cube0 };
```
- To prevent copies, make the copy constructor private.
- Passing objects by value calls the copy constructor, that's a reason why passing by value is expensive.
- Compilers may create default copy constructors so basic ones, like the one above, don't have to be created, mostly used for assignment error checking (prevent zero assignment to a denominator variable, for example) or dynamic memory allocation.
  - However, they may also do direct initialization instead, this is known as elision.
```cpp
// Elision Examples

/*
  Assume Vec3D has no user-defined copy constructor

  Vec3D may be translated to
  Vec3D c2 { 12, 56.5, 44.32 }
  Since it's more efficient
 */
Vec3D c1{ 12, 56.5, 44.32 };
Vec3D c2{ c1 };


/*
  Assume Vec3D has a user-defined copy constructor

  Anonymous objects may also
  be elided instead of calling
  the Copy Constructor for
  performance boosts.

  Compiler dependent!
 */
Vec3D c4{ Vec3D{4,5,8} };
```

## Conversion Constructors
- Used for implicit conversions. Saves use of creating temp objects or anonymous objects.
```cpp
class Vec3D {
  ...

  // Copy constructor
  Vec3D(const Vec3D& v)
    : m_x{v.m_x}, m_y{v.m_y}, m_z{v.m_z} {}

  friend std::ostream& operator<<(std::ostream& out, const Vec3D& v3);
};

...

// This function demonstrates implicit conversion
void printV3(const Vec3D& v3) {
  std::cout << v3;
}

printV3(9);             // Legal, same as Vec3D{9}
printV3({2.3,7,54.32}); // Legal
printV3(1,2,3); // ERROR, too many arguments
```
- Prevent implicit conversions with `explicit` keyword.
  - `explicit` may mean something else in the upcoming standard!
```cpp
class Vec3D {
  ...

  // Default constructor now explicit
  explicit Vec3D(double x=0, double y=0, double z=0)
    : m_x{x}, m_y{y}, m_z{z} {}
  // Copy constructor
  Vec3D(const Vec3D& v)
    : m_x{v.m_x}, m_y{v.m_y}, m_z{v.m_z} {}
  ...
};

// This function demonstrates implicit conversion
void printV3(const Vec3D& v3) {
  std::cout << v3;
}

printV3(9);             // ERROR passing int as Vec3D
printV3(1.234);         // ERROR passing double as Vec3D
printV3({2.3,7,54.32}); // ERROR constructor is explicit

printV3(Vec3D{2.3,7,54.32}); // Legal Vec3D object

/*
  static_cast is explicit,
  so it will be legal.
 */
printV3(
  static_cast<Vec3D>(9)
);

```
- Prevent implicit conversion of similar types (e.g. `int` and `char`) with `delete`.
```cpp
class IntsOnly {
  private:
    int m_a{};
    int m_b{};
    int m_c{};
  public:
    IntsOnly(int a, int b, int c)
     : m_a{a}, m_b{b}, m_c{c} {}
};

IntsOnly i{ 1.2, 3.4, 5.6 }; // Legal
IntsOnly j{ 'c', 'a', 'b' }; // Legal

/* Make the legal an error */
class IntsOnly {
  private:
    int m_a{};
    int m_b{};
    int m_c{};
  public:
    IntsOnly(char, char, char)       = delete;
    IntsOnly(double, double, double) = delete;

    IntsOnly(int a, int b, int c)
     : m_a{a}, m_b{b}, m_c{c} {}
};

IntsOnly i{ 1.2, 3.4, 5.6 }; // ERROR attempted to use deleted function
IntsOnly j{ 'c', 'a', 'b' }; // ERROR attempted to use deleted function
IntsOnly k{ 'c', 1, 2 }; // WARNING ambiguous
```
## Shallow versus Deep Copy
- Shallow copying is fine for simple classes, but problematic for classes that use or require memory-allocation.
- Shallow copying a pointer copies the address, not the contents. When the address is "freed", it affects all pointers to that address, not just the copy.
- Deep copying allows for giving copies their own memory address while retaining the same contents of the copied object.
  - *Simple copy constructors won't replace this*.
```cpp
class Copier {
  private:
    char* m_name{};

  public:
    Copier(const char* str="") {
      // Make room for null terminator
      std::size_t n = std::char_traits<char>::length(str) + 1;

      // Allocate for the member string
      m_name = new char[n];

      // Copy contents. can use strncpy at a risk
      for (std::size_t i{0}; i < n; ++i) {
        m_name[i] = str[i];
      }

      // Add null terminator
      m_name[n-1] = '\0';
    }

    // Since we allocated memory, destructor is needed
    ~Copier() {
      delete [] m_name;
    }

    /* How to make a deep copy copy constructor */
    Copier(const Copier& c) {
      deepCopy(c);
    }

    // Should be private if only the class uses it
    void deepCopy(const Copier& c) {
      // Check if null
      if (c.m_name) {
        // Deallocate before reallocation
        delete [] m_name;

        // Repeat constructor allocation code
        /* 
          This function should be called
          in the construction instead

          Here for demonstration purposes
          only!
         */
      }
      // Otherwise set to null
      else
        m_name = nullptr;
    }
};

// Usage
Copier c1{ "Hello " "World" };
Copier c2{ c1 }; // c2.m_name has "Hello World" but
                 // has nothing to do with c1
```

# Class Pointers
- Nested types are what seperate class pointers from fundamental pointers.
```cpp
class Parent {
  public:
    void printType() {
      std::cout << "Parent\n";
    }
};
class Child : public Parent {
  public:
    void printType() {
      std::cout << "Child\n";
    }
};

Parent parent;
Child child;

// Pointer to same type
Parent* p_ptr = &parent;
Child* c_ptr = &child;

p_ptr->printType(); // Parent
c_ptr->printType(); // Child

// Pointer to each other
p_ptr = &child;
c_ptr = &parent; // ERROR attemping promotion/upcast

p_ptr->printType(); // Parent


/** References **/
Parent& p_ref{parent};
Child& c_ref{child};

p_ref.printType(); // Parent
p_ref.printType(); // Child

// References to each other
Parent& p_ref{child};
Child& c_ref{parent}; // ERROR cant bind non-const lvalue reference of type 'Child&' to rvalue 'Child'

p_ref.printType(); // Parent

// - Fix
const Child& c_ref{parent};

/*
  Calling printType is an error
  because there's no guarantee
  printType won't change the 
  const reference.

  To fix that, change to
  void printType() const
  in the child, though
  changing in the parent 
  keeps consistency.
 */
// After fix
c_ref.printType(); // Child

// Assignment
p_ref = child; // OK
c_ref = parent; // ERROR no match for operator=
```

## Virtual Functions
- Virtual functions use polymorphism. They use the most derived version of the function.
- Less efficient since they rely on a vtable.
- The parent must know one of its functions will be used as virtual. `virtual` can be omitted in base classes, however, it's recommended to keep for legibility reasons.
```cpp
class Parent {
  public:
    virtual ~Parent() = default; // Compiler may give warning if this isn't here

    virtual void printType() const {
      std::cout << "Parent\n";
    }
};
class Child: public Parent {
  public:
    virtual void printType() const {
      std::cout << "Child\n";
    }
};
class Baby: public Child {
  public:
    virtual void printType() const {
      std::cout << "Baby\n";
    }
};

Parent* p_ptr{ nullptr };
Child child;
Baby baby;

p_ptr = &child;
p_ptr->printType(); // Child

p_ptr = &baby;
p_ptr->printType(); // Baby


/** References **/
Child c;
Parent& p_ref{c};

p_ref.printType(); // Child

Baby b;
Parent& p_refB{b};
Child& c_refB{b};

p_refB.printType(); // Baby
c_refB.printType(); // Baby
```
- Useful for arrays of objects.
```cpp
#include <iostream>
#include <array> // to_array() (C++20)

class Human {
  private:
    std::string m_name{};

  public:
    Human(const std::string& name="Default") :
      m_name{ name } {}

    const std::string& getName() const {
      return m_name;
    }

    virtual void getType() const {
      std::cout << m_name << " is a human\n";
    }
};

class Student: public Human {
  public:
    Student(const std::string& name="Student") :
      Human{ name } {}

    virtual void getType() const {
      std::cout << getName() << " is a student\n";
    }
};

class Employee: public Human{
  public:
    Employee(const std::string& name="Employee") :
      Human{ name } {}

    virtual void getType() const {
      std::cout << getName() << " is an employee\n";
    }
};


// Usage
const Student s1{ "Student One" };
const Student s2{ "Student Two" };
const Student s3{ "Student Three" };

const Employee e1{ "Employee One" };
const Employee e2{ "Employee Two" };
const Employee e3{ "Employee Three" };

// One array of different types!
const auto humans{
  // More efficient to use vector instead!
  std::to_array<const Human*>({
    &s1, &s2, &s3, 
    &e1, &e2, &e3
  })
};

for (const auto human: humans) {
  human->getType(); // Prints fine!
}
```
### Pure Virtual Functions
- Virtual function without definition.
  - Base classes that consist of one or more pure virtual functions are known as *abstract classes*.
- Useful for keeping base classes as broad as possible and allow derived classes to define the functions to their needs.
  - Pure virtual functions **must** be defined in the inherited class regardless if needed or not.
- Abstract classes **CAN'T** be instantiated!
- To make a function pure virtual, assign 0 to it.
  - It only takes one pure virtual function to make the entire class abstract and uninstantiatable.
```cpp
class Pure {
  private:
    int m_x{};

  public:
    virtual int getX() const = 0;

    // ERROR
    virtual int getX() const = 0 {
      return m_x;
    }
};

// OK; define outside
int Parent::getX() const {
  return m_x;
}
```
### Interface Class
- Class that has ALL pure virtual functions and typically no members.
- It is convention to start the identifier name with an 'I'.
- Not having a virtual destructor can lead to undefined behavior.
```cpp
class IInterface {
  public:
    IInterface() {}
    virtual ~IInterface() {}

    virtual void task1() = 0;
    virtual void task2() = 0;
};

class Child1 : public IInterface {
  private:
    int m_m1{};
    int m_m2{};

  public:
    // MUST be defined
    void task1() {
      std::cout << 1 << '\n';
    }
    void task2() {
      std::cout << "Task 2\n";
    }

    // Expand derived class
    void task3() {
      std::cout << "Task 3\n";
    }
};

class Child2: public IInterface {
  private:
    int m_m1{};
    int m_m2{};
    int m_m3{};

  public:
  // MUST be defined
    void task1() {
      std::cout << "Task 1\n";
    }
    void task2() {
      std::cout << 2 << '\n';
    }

    // Expand the class
    void task3() {
      std::cout << "Task 3 Child 2\n";
    }
    void task4() {
      std::cout << "Task 4 Child 2\n";
    }
};


void printChild(IInterface& child) {
  child.task1();
  child.task2();
  child.task3(); // ERROR IInterface doesn't have task3()
}

Child1 c1;
Child2 c2;

printChild(c1);
c1.task3();

printChild(c2);
c2.task4();
```
### Virtual Table
- Virtual functions use a virtual table to dynamically resolve functions.
- The table is a static array and pointer (referred to as vptr, *vptr, *\_vptr, or VPTR) created by the compiler (for each class that has a virtual function).
  - Compiler errors call this *vtable*.
- Because of this, virtual functions are dynamic since we don't know which one(s) will be called at runtime.

### Forcing and Preventing Override
#### Override Specifier
- If virtual functions don't match exactly, they won't be treated as override functions. `override` was introduced in C++11 to combat this.
- `override` is more of an error-prevention tool.
```cpp
class Parent {
  public:
    virtual std::string_view getType() const {
      return "I am a Parent\n";
    }
};
class Child: public Parent {
  public:
    // Misspelled getType
    virtual std::string_view geTType() const {
      return "I am a Child\n";
    }
};

Child c;
Parent* p{&c};
p->getType(); // I am a Parent
```
- Not catching that capital 'T' can be an annoying hard to find bug.
- Using `override` will give us an error.
```cpp
class Parent {
  public:
    virtual std::string_view getType() const {
      return "I am a Parent\n";
    }
};
class Child: public Parent {
  public:
    // Misspelled getType
    // ERROR geTType marked as override but does not override
    virtual std::string_view geTType() const override{
      return "I am a Child\n";
    }

    // FIXED
    // Virtual can be omitted if override is present
    std::string_view getType() const override{
      return "I am a Child\n";
    }
};

Child c;
Parent* p{&c};
p->getType(); // I am a Child
```
> `virtual` should be used for base classes and `override` for derived classes!

#### Final Specifier
- Prevent virtual functions from being overriden.
```cpp
class Parent {
  public:
    virtual std::string_view getType() const {
      return "I am a Parent\n";
    };
};

class Child: public Parent {
  public:
    // final, no more overrides please!
    std::string_view getType() const override final {
      return "I am a Child\n";
    }
};

class GrandChild: public Child {
  public:
    /*
      ERROR
      Attempting to override
      a final function.
     */
    std::string_view getType() const override {
      return "I am a GrandChild\n";
    }
};
```
- Can also be used to prevent inheritance.
```cpp
class Parent {
  public:
    virtual std::string_view getType() const {
      return "I am a Parent\n";
    };
};

// final, no more inheritance please!
class Child final: public Parent {
  public:
    std::string_view getType() const override {
      return "I am a Child\n";
    }
};

/*
  ERROR
  Can't derive from 
  'final' class 'Child'
 */
class GrandChild: public Child {
  public:
    std::string_view getType() const override {
      return "I am a GrandChild\n";
    }
};
```