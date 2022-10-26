<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 10
  Purpose: COBOL Data Declaration notes.
-->

# Categories of Program Data
- 3 categories:
  - Literals
    - Raw data (alphanumeric or numeric).
  - Figurative constants
    - Special constants that can be used as literal values.
    - Overwrites **EVERYTHING** when assigned to data item.
    - ISO 2002 has added constants via `CONSTANT` clause.
  - Data items
    - "Identifier". Area of memory reserved for a data item.
- *COBOL does not support user-defined constants.*

 | Figurative Constant | Behavior |
 | ------------------- | -------- |
 | ZERO<br>ZEROS<br>ZEROES | Literal value 0 (1 or more instances of 0). |
 | SPACE<br>SPACES | Space character (1 or more instances). |
 | HIGH-VALUE<BR>HIGH-VALUES | Highest ordinal position in current collating sequence (usually ASCII charset. 1 or more instances). |
 | LOW-VALUE<br>LOW-VALUES | Lowest ordinal position in current collating sequence (null character 0x00 in the ASCII charset. 1 or more instances). |
 | QUOTE<br>QUOTES | Quote character (1 or more instances). Can't be used to bracket non-numeric literal instead of actual quote character.<br>QUOTE Freddy QUOTE cannot be used in place of "Freddy". |
 | ALL literal | Ordinary literal character behaves as if it were a figurative constant. |

## Elementary Data Items
- *Elementary item* equivalent of variable in other languages.
- Atomic data that is not further subdivided.
  - Level 01 or 77.
    - 77 is special; later discussed.
- Mandatory items:
  - Level number
  - Data-name or identifier
  - PICTURE (PIC) clause
- Also optional clauses e.g. `VALUE` for assignment.

# Declaring Elementary Data Items
- COBOL is not a *typed* language, uses *declaration by example* strategy.
  - You provide example, or template, or *picture* of the size and type of the item. System then allocates item as necessary.
## PICTURE Clause Symbols
- Most common symbols:

 | Symbol | Meaning |
 | ------ | ------- |
 | A | Alphabetic character (a to z and blank) at corresponding position. |
 | X | Any character at corresponding position. |
 | 9 | Digit at corresponding position. |
 | V | Position of decimal point in numeric value.<br>AKA *assumed decimal point* because not part of the value, rather information about the value. |
 | S | Presence of a sign. Can only appear at the beginning of the picture. |

## PICTURE Clause Notes
- Use a *repeat* factor.
```cobol
PIC 9(8)      same as PICTURE 99999999
PIC 9(7)V99   same as PICTURE 9999999V99
PICTURE X(15) same as PIC XXXXXXXXXXXXXXX
```
- Normally used when PIC > 3 symbols.
- Numeric values MAX 18 digits; strings system dependent.
  - ISO 2002 increased 18 digit limit to 31.
```cobol
*> Example declaration and memory representation
DATA DIVISION.
WORKING-STORAGE SECTION.
01 Num1         PIC 999   VALUE ZEROS.
01 Num2         PIC 999   VALUE 15.
01 TaxRate      PIC V99   VALUE .35.
01 CustomerName PIC X(15) VALUE "Mike".

| Num1 | Num2 | TaxRate |  CustomerName   |
| 000  | 015  |   35    | Mike*********** |
```

# Assignment
## MOVE Verb
- All ordinary assignments should only be done with `MOVE`.
### MOVE Syntax
- `MOVE Source$#il TO Destination$#il...`
  - COBOL verbs do left-to-right assignment unlike most modern languages (dest = src).
    - `COMPUTE` is an exception to this rule.
- **Copies** data from source to one or more destinations.

### MOVE Rules
- Source and destination can be either elementary or group data items.
- When data copied to destination, destination is completely replaced.
- If number of characters in source is too few to fill destination, the characters that cannot fit are lost (truncation).
- Destination is alphanumeric or alphabetic (PIC X or A), data copied into destination from left to right, with space filling or truncation on the right.
- Destination is numeric or edited numeric, data is aligned along the decimal point with zero-filling or truncation as necessary.
- When decimal point not explicitly specified in either source or destination, item is treated as assumed decimal point immediately after its rightmost character.

### Alphanumeric MOVES
```cobol
01 Surname PIC X(8) VALUE "COUGHLAN" [C][O][U][G][H][L][A][N]
MOVE "Smith" TO Surname              [S][M][I][T][H][ ][ ][ ]
MOVE "FITZWILLIAM" TO Surname        [F][I][T][Z][W][I][L][L]
MOVE ALL "@" TO Surname              [@][@][@][@][@][@][@][@]
```
### Numeric MOVEs
- *Edited* numeric data is data containing `$,.` symbols that format data for output.
  - Can't be used in calculations (except as receiving field).
  - Obey decmal-point alignment and zero-filling rules.
```cobol
01 SalePrice PIC 9(4)V99. *> 4 digits before decimal position, 2 after
MOVE ZEROS     TO SalePrice [0][0][0][0][0][0]
MOVE 25.5      TO SalePrice [0][0][2][5][5][0]
MOVE 7.553     TO SalePrice [0][0][0][7][5][5]
MOVE 93425.158 TO SalePrice [3][4][2][5][1][5]
MOVE 128       TO SalePrice [0][1][2][8][0][0]
MOVE 674532    TO SalePrice [4][5][3][2][0][0]

```
- **No protection against truncation!** It is up to the programmer to ensure data is large enough for `MOVE` operations.
  - Can protect against inadvertent truncation by `ON SIZE ERROR` clause.

# Structured Data
## Group Data Items
- Consist of elementary or other group items.
- Group item cannot have a PICTURE clause and size is sum of sizes of its subordinate elementary items.
- Higher the level number, the lower it is in hierarchy and more atomic.
  - Level `01` called *record*.
- Type always assumed alphanumeric (PIC X) because group item may have different types.

## Level Numbers
- 01 - 49 general level numbers used to express hierarchy.
  - Hierarchy matters only with its preceding items (actual numbers not as important).
  - COBOL convention: lower levels incremented by 5 to allow for adding new sub items without disturbing the layout. Not very much used nowadays.

- 66 and 77 rarely used in modern COBOL.
- 66 used with `RENAMES`. 
  - `RENAMES` allows for renaming data-name or group of contiguous data-names.
    - Similar to `REDEFINES`, but `RENAMES` has maintenance problems and misuse.
- 77 used to identify noncontiguous, single data item in WORKING-STORAGE or LINKAGE sections; can't be subdivided can't be part of group item.
  - 77 use less memory; used to be preferred over using 01, but now 01 preferred over 77 because of heirarchial/grouping properties.
- 88 used to implement condition names.
```cobol
*> Example hierarchy

WORKING-STORAGE SECTION.
01 StudentRec.
  02 StudentId    PIC 9(7).
  02 StudentName  PIC X(21).
  02 DateOfBirth  PIC X(8).
  02 CourseId     PIC X(5).
  02 GPA          PIC 9V99.

|                             StudentRec                           |
| StudentId |       StudentName     | DateOfBirth | CourseId | GPA |
|  9999999  | aaaaaaaaaaaaaaaaaaaaa |   11111111  |   AA999  | 999 |

*> Flush entire record
MOVE SPACES TO StudentRec

*> Copy data to another record
MOVE StudentRec TO StudentRecCopy

*> Assign to group items
MOVE ZEROS TO StudentId
MOVE "CS101" TO CourseId

*> Granulize
01 StudentRec.
  02 StudentId     PIC 9(7)
  02 StudentName.
    03 Forename    PIC X(9).
    03 Surname     PIC X(12).
  02 DateOfBirth.
    03 YOB         PIC 9(4).
    03 MOB         PIC 99.
    03 DOB         PIC 99.
  02 CourseId      PIC X(5).
  02 GPA           PIC 9V99.

DISPLAY "Student: " Surname "," SPACE Forename
MOVE "Billy" TO Forename
MOVE 22 TO DOB

*> Different level numbers, still same as above
01 StudentRec.
  07 StudentId     PIC 9(7)
  07 StudentName.
    12 Forename    PIC X(9).
    12 Surname     PIC X(12).
  07 DateOfBirth.
    14 YOB         PIC 9(4).
    14 MOB         PIC 99.
    14 DOB         PIC 99.
  07 CourseId      PIC X(5).
  07 GPA           PIC 9V99.

*> Conventional format
01 StudentRec.
  05 StudentId     PIC 9(7)
  05 StudentName.
    10 Forename    PIC X(9).
    10 Surname     PIC X(12).
  05 DateOfBirth.
    10 YOB         PIC 9(4).
    10 MOB         PIC 99.
    10 DOB         PIC 99.
  05 CourseId      PIC X(5).
  05 GPA           PIC 9V99.

**> Conventional format slipping in item
01 StudentRec.
  05 StudentId     PIC 9(7)
  05 StudentName.
    10 Forename    PIC X(9).
    10 Surname     PIC X(12).
  05 DateOfBirth.
    08 YOB         PIC 9(4). *> Changed
    08 MOBandDOB             *> Added
      10 MOB       PIC 99.   *> Changed
      10 DOB       PIC 99.   *> Changed
  05 CourseId      PIC X(5).
  05 GPA           PIC 9V99.
```
