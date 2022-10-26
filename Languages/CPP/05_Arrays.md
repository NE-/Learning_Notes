<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 19
  Purpose: C++ Arrays
-->

# Creation
- `<type> <identifier>[<length>]{ <list of elements> }`
  - Brackets are literal '[' ']'.
```cpp
int arr1[]{ 1, 2, 3, 4 }; // Compiler determines length
int arr2[3]{}; // Elements can contain 0 or random,
               // always assume random!

constexpr std::size_t maxStudents{ 30 };
int students[maxStudents]{};
```

# Lengths and Size
```cpp
int arr[]{ 1, 2, 3, 4, 5 };
sizeof arr; // 5 ints * 4 bytes each -> retuns 20
            // 20 is the SIZE
sizeof arr / sizeof arr[0]; // 5 ints * 4 bytes each / sizeof an int
                            // 20 / 4 -> returns 5
                            // 5 is the LENGTH

// Can also use std::size()
int arr1[35]{};
std::size(arr1);  // 35 unsigned
std::ssize(arr1); // 35 signed
```

# Looping
```cpp
int a1[]{ 1, 2, 3, 4, 5, 6, 7, 8 };

for (std::size_t i{0}; i < sizeof a1 / sizeof a1[0]; ++i)
  a1[i];

for (std::size_t i{0}; i < std::size(a1); ++i)
  a1[i];

std::size_t i{0};
while (i < std::size(a1)) {
  a1[i];
}

// Using pointers
for (int* p{&a1[0]}; p != &a1[8]; ++p)
  std::cout << *p;

for (int* p{a1}; p != a1 + 8; ++p)
  std::cout << *p;

// - Modern
#include <iterator>

for (
  auto it{std::begin(a1)};
  it != std::end(a);
  ++it
)
  std::cout << *it;



// Looping backwards
// - safer to use signed integers
int a2[]{ 0, 1, 2, 3, 4, 5 };
const std::size_t n{ sizeof a2 / sizeof a2[0] };

for (std::size_t i{ n }; i-- > 0;)
  a2[i];


// Range-based for loop
// - Loops through EVERY element
// - Recommended for modern C++

for (auto i : arr)
  i = 0; // i is a copy so this wont effect the array's elements

// Referencing is more efficient
for (auto& i : arr)
  i = 0; // i is referencing array element so it does effect it

for (const auto& i : arr)
  i = 0; // ERROR: i is const

// Can have initializers
for (int a{0}, b{9}; const auto& i : arr)
  std::cout << ++a << ' ' << ++b << '\n';
```

# Multidimensional Arrays
```cpp
a1[3]; // Holds 3 elements

a2[3][2]; // 3 elements
          // Each element is an array that holds 2 elements

a3[3][2][4]; // 3 elements
             // Each element is an array of 2 items
             // Those 2 items are arrays that hold 4 items
```

# std::array
- Object with many helper functions (defined in `<array>`).
- Don't decay into pointers when passed into a function.
```cpp
std::array<int, 5>a{};
// C++17 can omit
std::array b{ 1, 3, 5 };
// Using auto
// Uses copy-initialization. Not performance friendly
auto c{ std::to_array({ 1,2,3,4,5,6,7 }) };

// Element Access
b.at(0);   // 1
b.front(); // 1
b.back();  // 5

// Looping helpers
b.begin(); // Iterator to beginning
b.end();   // Iterator to end

b.size(); // Number of elements
```
