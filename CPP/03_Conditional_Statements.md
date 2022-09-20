<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 19
  Purpose: C++ Conditional Statements
-->

# Conditional Operators
 | Operator | Prec. | Assoc. | Summary |
 | -------- | ----- | ------ | ------- |
 | < | 9 | LtR | True if lhs less than rhs<br>False if lhs greater than rhs |
 | <= | 9 | LtR | True if lhs less than or equal to rhs<br>False if lhs greater than rhs |
 | > | 9 | LtR | True if lhs greater than to rhs<br>False if lhs less than rhs |
 | >= | 9 | LtR | True if lhs greater than or equal to rhs<br>False if lhs less than rhs |
 | == | 10 | LtR | True if lhs equal to rhs<br>False otherwise |
 | != | 10 | LtR | True if lhs not equal to rhs<br>False otherwise |
 | && | 14 | LtR | True if lhs and rhs are true<br>False if any are false |
 | \|\| | 15 | LtR | True if either lhs or rhs is true<br>False if both are false |
```cpp
/* 
  Three-way comparison (C++20)
  - Precedence level 8
  - Associativity LtR

  Returns:
    (x <=> y)  < 0 if x  < y // Less
    (x <=> y)  > 0 if x  > y // Greater
    (x <=> y) == 0 if x == y // Equal
    
    Must use std::string_ordering for integerals,
    std::partial_ordering for floating-point
      In <compare>
 */
int x{ 9 };
int y{ 4 };

if (x <=> y == std::strong_ordering::less) {}
else if (x <=> y == std::strong_ordering::greater) {}
else if (x <=> y == std::strong_ordering::equal) {}
```

# Conditional Statements
```cpp
// If statement
if (<condition>) {}
else if (<condition>) {}
else {}

// Ternary Operator
<condition> ? <evaluated true> : <evaluated false>

// Switch
switch(<integral constant>) {
  case <constant>:
    break;
  case <constant>:
    break;
  case <constant>:
    [[fallthrough]];
  case <constant>:
    break;
  ...
  default: break;
}