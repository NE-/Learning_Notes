<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 20
  Purpose: C++ Templates
-->

# Templates
- Used to make one thing work with many different data types rather than typing a lot of overloaded functions or classes.
```cpp
// Example basic template class

template<typename T>
class A {
  private:
    T m_a{};

  public:
    A(T a) : m_a{ a } {}

    T getA() const { return m_a; }
};

A<int> a_i{ 23 };
a_i.getA() // 23

A<char> a_c{ 97 };
a_c.getA() // 'a'

A<int> adbl{ 23.23 }; // ERROR narrowing conversion
A<int> adbl2(23.23);  // OK m_a is 23
```
- Change behavior based on the typename functions (function template specialization) and templates (class template specialization).
  - Useful for heavy objects or if some allocation is needed.
- `typename` can be `auto`.
```cpp
/** Function Specialization **/
template<typename T>
class A {
  private:
    T m_a{};
  
  public:
    A(T a) : m_a{ a } {}

    void say() const {
      std::cout << "int\n";
    }
};

// Defined outside the class
// Type must be specified
template<>
void A<double>::say() const {
  std::cout << "Double\n";
}

// Usage
A<int> a_i{1};
a_i.say(); // int

A<double> a_d{23.34};
a_i.say(); // double


/** Class Specialization **/
template<>
class A<std::string> {
  private:
    // Use string_view instead of default compiler string
    std::string_view m_a{};

  public:
    A(T a) : m_a{ a } {}

    std::string_view getA() const { return m_a; }
};
```
- Template classes *must* be defined in the same header file. The preprocessor will just include the header files with 'T' and no type.
```cpp
// template.h
template<typename T>
class A {
  private:
    T m_a{};

  public:
    A(T a) : m_a{ a } {}

    T getA() const;
};

// template.cpp
#include "template.h"

/*
  When we compile this file,
  the compiler knows this
  is a template, but doesn't
  know what to replace 'T'
  with.

  It should NOT just make
  one for every existing type!

  That's where the error comes in.
 */
template<typename T>
T A<T>::getA() const {
  return m_a;
}

// main.cpp
/*
  Preprocessor includes
  everything from template.h
  knowing nothing about types
  or templates (preprocessor
  doesn't know C++).
 */
#include "template.h"

int main() {
  /*
    Compiler knows you 
    want an int here,
   */
  A<int> a{ 23 };

  /*
    but an int version
    was never made when it 
    compiled template.cpp
    so this doesn't exist
   */
  a.getA(); // ERROR unresolved external symbol

  return 0;
}
```
- To combat this, just declare and define in the header file (convention), rename the extension of a template's cpp source file to "inl" then include it at the bottom of the template's header file (to not include cpp files), or use the "three-file" approach which has the normal header and source files, but uses a third file that includes both (.h .cpp) and contains all the instantiated template classes you'll need.
```cpp
/** Three-file approach **/
// Templates.cpp
// Include ALL template classes in project
#include "templateA.h"
#include "templateA.cpp"
#include "templateB.h"
#include "templateB.cpp"

/*
  Explicitally instantiate 
  what you'll be using
 */
template class templateA<int>;
template class templateA<double>;
template class templateB<char>;
template class templateB<unsigned>;
template class templateB<float>;
```
- The compiler will prematurely instantiate the template classes thus bringing them into existence for use.

# Template Parameter Lists
- Type template parameters use `typename`; non-type template parameters use fundamental and user-defined types.
- Valid non-type template parameters:
  - lvalue reference (to object or function)
  - integral types
  - pointers (to object or function)
  - pointers to members (member object or function)
  - enumerations
  - nullptr type (std::nullptr_t) (C++11)
  - floating-point type (C++20)
  - literal class type (has restrictions) (C++20)
  - placeholder such as auto (C++20)
```cpp
// int is default if no type given
template<typename T=int, std::size_t S=20>
class A {
  private:
    T m_val{};
    std::size_t m_size{ S };

  public:
    std::size_t getSize() const {
      return m_size;
    }
};

A<int, 5> a_i;
a_i.getSize(); // 5

A<double> a_d;
a_d.getSize(); // 20

A a_deduction{ 7 }; // Compiler will determine type
a_deduction.getSize(); // 7
```
## Template Template Parameters
- Template inside template parameter list.
  - Which alsos have their own parameter lists.
```cpp
template<typename T, typename U, template<typename> typename V=std::array>
class TemplateTemplate {
  private:
    V<T> key;
    V<U> value;
};
```
## Parameter Packs
- Argument pack for templates. Also uses ellipsis and must be last in the list.
- Use `std::forward` for access.

# Constraints and Concepts
- Constraints specify requirements on template arguments.
  - Useful for overloading and type specialization.
- Evaluated at compile time.
- Require `<concepts>`.
## Concepts
- Named set of requirements that evaluate to `true` or `false`. 
  - Concepts from `<concepts>`, expressions, and functions are valid requirements.
  - Identifiers are conventionally capitalized.
```cpp
#include <concepts>

// If T is not a floating point, throw error
template<typename T>
concept FloatOnly = std::floating_point<T>
```
## Constraints
- The usage of the concepts. Appear within requires-expressions.
- Use the same 'T' as the template function or class we're testing.
```cpp
template<typename T>
concept FloatingPoint = std::floating_point<T>

template<typename T>
requires FloatingPoint<T>
class A{
  T m_a {};
};

A<bool> a;  // ERROR constraint not satisfied
A<float> a; // OK
```
- Constraints have three types
  - Conjunctions
    - If **all** constraints satisfied, concept evaluates to `true`.
      - Uses `&&`. Evaluated LtR and short-circuited.
  - Disjunctions
    - If **any** constraint is satisfied, the entire clause is `true`.
      - Uses `||`. Evaluated LtR and short-circuited.
  - Atomic
    - Use boolean primary expressions rather than logical AND or OR. If the expression is true, the constraint is satisfied.
```cpp
/*
  Conjunction
 */
#include <concepts>

template<typename T>
concept Integral = std::is_integral<T>::value;
template<typename T>
concept SignedInt = std::is_signed<T>::value;

/*
  You can also do this

  concept SignedInt = Integral<T> && std::is_signed<T>::value;

  but change requires Integral<T> && SignedInt<T>
  to requires SignedInt
 */

template<typename T>
requires Integral<T> && SignedInt<T>
class A {
  private:
    T m_a{};
};

// Usage
A<unsigned int> a; // ERROR constraints not satisfied



/*
  Disjunction
 */
#include <concepts>

template<typename T>
concept Integral = std::is_integral<T>::value;
template<typename T>
concept SignedInt = std::is_signed<T>::value;

/*
  You can also do this

  concept SignedInt = Integral<T> || std::is_signed<T>::value;

  but change requires Integral<T> || SignedInt<T>
  to requires SignedInt
 */

template<typename T>
requires Integral<T> || SignedInt<T>
class A {
  private:
    T m_a{};
};

// Usage
A<unsigned int> a; // OK unsigned int is still integral



/*
  Atomic
 */
#include <concepts>
#include <iostream>

template<typename T>
constexpr bool is_true = 5 < 6;

template<typename T>
constexpr bool is_false = 5 > 6;

// Disjunction
template<typename T>
concept Ok = is_true<T> || is_false<T>;

template<Ok T>
void f1(T t) {
  std::cout << t;
}

// Usage
f1(0); // 0
f1(1); // 1
f1(2); // 2
```
