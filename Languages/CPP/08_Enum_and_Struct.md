<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 19
  Purpose: C++ Enum and Struct
-->

# Enum
- User-defined data type which every value is defined by a constant (signed int).
- Members used to be in all caps, but the convention isn't followed as much anymore.
- Scope of the enumerators are the same as the enumeration, therefore names can't be reused!
```cpp
enum Direction {
  UP,   // 0
  DOWN, // 1
  LEFT, // 2
  RIGHT // 3
};

Direction player1_dir{ UP };
Direction player2_dir{ DOWN };

Direction enemy1_dir{ 0 }; // ERROR
Direction enemy2_dir{ static_cast<Direction>(0) }; // OK

int UP{4}; // ERROR "UP" already declared

// Explicit value definition
enum  {
  a = -3,
  b,      // -2
  c,      // -1

  d = 7,
  e,      // 8
  f,      // 9

  // Same value okay
  j=3,
  k=3,
  l=3,
  m,      // 4
};
```
```cpp
// Enum comparison
enum Car {
  Toyota,
  Nissan,
  Mazda
};

enum Fruit {
  banana,
  apple,
  peach
};

// Implicit conversion of enumerators
std::cout << std::boolalpha
  << (Toyota == banana); // True, 0 == 0

Fruit cup{ Toyota }; // ERROR

// Can change enum type
// - Must be integral type
// - bool can have only 2 enumerators (true, false)
enum Color : std::uint_least8_t {
  red,
  green,
  blue
};
```
- Prevent implicit conversions with `class` keyword (C++11). This makes the enum strongly typed.
  - Known as scoped enums or an enum class.
- This also prevents arithmetic usage regardless of type.
```cpp
enum class Color {
  red,
  green,
  blue,
  alpha,
  unknown
};

int alpha{ 4 }; // OK alpha not declared in this scope

// OK no redeclaration done
enum Apple {
  red,
  green,
  blue
};

Color wall{ unknown }; // ERROR "unknown" not declared in this scope
Color floor{ Color::unknown }; // OK scope resolution

Color::red == red; // ERROR can't match type Color with Apple

floor == Color::blue; // OK compatible types
```

# Struct
- Aggregate data types. Used more in C than C++ thanks to C++ `class` introduction.
```cpp
struct Person {
  unsigned int id{0};

  std::string birthMonth{};
  unsigned int birthDay{};
  unsigned int birthYear{};

  unsigned float weight{};
  unsigned float height{};

  bool isDeceased{0};
};

Person john{
  574943,
  "April",
  3,
  1986
  // Can omit the rest
};

Person Samantha {
  632,
  "January",
  27,
  1999,
  45,
  1.62
};

Person Gabe {
  33672,
  "March",
  2,
  1905,
  63.3,
  2.02,
  1
};

// C++20 Designated initializers
// - Initialization MUST be in order
Person Desirae { .birthYear=1987, .height=1.76 };


Person Rob{ Gabe }; // Copies all values
Rob.birthDay = 7;
Rob.isDeceased = false;

// Nested structs
enum class Gender : bool {
  male,
  female
};

struct Date {
  unsigned int month;
  unsigned int day;
  unsigned int year;
};

struct Person {
  unsigned int id {0};
  Date birthdate;
  unsigned float wt;
  unsigned float ht;
  Gender gender;
};

Person Marc {
  8473,

  {
    10,
    29,
    2000
  },

  65.34,
  1.99,

  Gender::male
};
```
