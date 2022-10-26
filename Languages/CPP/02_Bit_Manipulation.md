<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 19
  Purpose: C++ Bit Manipulation
-->

# Operators
 | Operator | Summary |
 | -------- | ------- |
 |x`<<`y | left shift (logical if unsigned, arithmetic if signed though it may vary) |
 |x`>>`y | right shift (logical if unsigned, arithmetic if signed though it may vary) |
 | `~`x | NOT/Compliment flips all the bits |
 |x`&`y | AND operation |
 | x`|`y | OR operation |
 | x`^`y | XOR operation |

# std::bitset
- Makes bit manipulation more legible. Requires `<bitset>`.
- Approximate size is dependent on the internal representation of the system.
  - 32bit: `4 * ((N + 31) / 32)`.
  - 64bit: `8 * ((N + 63) / 64)`.
```cpp
/*
  Pre bitset
*/
// C++11
constexpr std::uint8_t c11mask0 { 0x0B };   // 0000 1011 
constexpr std::uint8_t c11mask1 { 1 << 3 }; // 0000 1000

// C++14
constexpr std::uint8_t c14mask { 0b0000'0001 };
```
```cpp
// Some bitset function usage examples
std::bitset<8> bits{ 0b1001'1001 };

/*
  test(n)
    Returns value in bit n

  Same as x & y
 */
bits.test(0); // 1
bits.test(3); // 1
bits.test(5); // 0

/*
  set()
    sets all bits to 1
  set(n)
    sets bit n to 1

  same as x |= y
 */
bits.set(0); // No change
bits.set(1); // 1001 1011

/*
  reset()
    sets all bits to 0
  reset(n)
    sets bit n to 0

  same as x &= ~y
 */
bits.reset(0); // 1001 1010
bits.reset(1); // 1001 1000
bits.reset(1); // No change

/*
  flip()
    flips all bits
  flip(n)
    flips bit at n

  same as x ^= y
 */
bits.flip(4); // 1000 1000
bits.flip(2); // 1000 1100
```
