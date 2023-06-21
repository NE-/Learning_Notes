<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 10
  Purpose: C Control of Flow and Logical Expressions
-->

# Logical Expressions
 | Operator | Operation |
 | -------- | --------- |
 | < | less than |
 | <= | less than or equal to |
 | > | greater than |
 | >= | greater than or equal to |
 | == | equal to |
 | != | not equal to |
 | && | Logical AND |
 | \|\| | Logical OR |
 | ! | NOT |
- Results are type int where 0 is *false* and non-zero is *true*.


# Control of Flow
## `if` Statement
- `if (expression) statement else statement`
## `while` and `do`
- `while (expression) statement`
- `do statement while (expression);`
```c
// Example read from STDIN until EOF
while ((inC = getchar()) != EOF)
  printf("%c was read\n", inC);
```
## `for` Statement
- `for (initialize; check; update) statement`

## `switch` Statement
```c
switch(expression) {
  case constant1: 
    statements
  case constant2:
    statements
  ...
  default: statements
}
```
- *expression* can only be integral type.
- `break` clause leaves a `switch` statement immediately.
  - `break` can be used to leave any loop, though bad practice with anything other than `switch`.

## `continue` Statememt
- Starts next iteration of a loop (not useful for standalone `switch` statements).
  - `while` will jump to the test expression.
  - `for` will evaluate the update expression, then controlling expression is evaluated.
- Good convention to use at the top of the loop, to determine if the body should be executed.

## `goto` and Labels
- Always been considered 'bad' because high risk of spaghetti code.
- in C, useful for escaping multiple nested loops or for going to an error handling exit.
- goto requires a label (like in assembly languages).
  - Label names don't clash with variable or function names.
  - Label scope is same as variable's. Because of this, you cant jump to other functions.
  - Label can be referenced before declared.
> Use as minimal (if at all) as possible.
