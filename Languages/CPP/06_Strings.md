<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 19
  Purpose: C++ Strings
-->

# std::string
- Not fundamental data type, they are a compund data type defined in `<string>`.
  - Preferred over C-style strings.
## Input 
- cin cuts off whitespace and keeps the trimmed part in the input stream, which causes a problem...
```cpp
std::string name{};
std::string age{};

std::cout << "Enter first and last name: ";
std::cin >> name; // STDIN: John Coder

std::cout << "Enter age: ";
std::cin >> age; // No prompt, "Coder" is accepted here

/*
  Output:
  Name: John
  Age: Coder
 */
std::cout 
  << "Name: " << name << '\n'
  << "Age:  " << age  << '\n';
```

- Use `getline` in `<string>`.
- `std::ws` input manipulator tells cin to ignore whitespace.
```cpp
std::string name{};
std::string age{};

std::cout << "Enter first and last name: ";
std::getline(std::cin >> std::ws, name); // STDIN: John Coder

std::cout << "Enter age: ";
std::getline(std::cin >> std::ws, age); // 42

/*
  Output:
  Name: John Coder
  Age: 42
 */
std::cout 
  << "Name: " << name << '\n'
  << "Age:  " << age  << '\n';
```

# std::string_view
- Safe, efficient way to create *fake* constant strings.
  - Preferred when you need read-only strings.
  - Don't use if you don't know if the lifetime of the string is less than the string_view object. Dangerous when used for a function's return type.
  - Also preferred for passing a string to a function vs. `const std::string&`.
- It does not copy data when used for assignment. The assigned variables "reference" the original string_view.
- Doesn't require null terminator, it keeps track of its length instead.
```cpp
std::string_view str { "constant string" };

static_cast<std::string>(str); // Cast is possible

str.length(); // 15
std::ssize(str); // C++20
str.substr(0, str.find(' ')); // constant

// C++20
str.starts_with("L");    // false
str.ends_with("string"); // true

// C++23
std::cout
  << "C++23"sv.contains('+') << ' ' // 1 (true)
  << "C++23"sv.contains('-') << ' ' // 0 (false)

// Change viewable area, not the string itself
str.remove_prefix(1); // Ignore 1 character: onstant string
str.remove_suffix(1); // Ignore last 2: onstant stri
```

# Literals
- `s` for `string`, `sv` for `string_view`.
```c++
using namespace std::literals;

std::cout << "C-Style\n";
std::cout << "string\n"s;
std::cout << "string_view\n"sv;
```
