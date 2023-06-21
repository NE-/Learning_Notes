<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 September 09
  Purpose: COBOL Foundation notes.
-->

# Idiosyncrasies
- Made as English-like as possible. Turns away many programmers used to other laguages.
- *Noise words*: words with no semantic content used only to enhance readability (making more English-like).

# Syntax Metalanguage
- Uppercase words are reserved.
  - When underlined, mandatory, else *noise words* which are optional.
- Mixed cased words devised by the programmer.
- Material enclosed in curly braces means a choice must be made from options within braces.
  - If only one option, then that item is mandatory.
- Material enclosed in square brackets means material is optional and may be included or omitted as required.
- Ellipsis indicate the preceding synatic element may be repeated at your discretion.
- Comma, semicolon, and space characters used as seperators in a statement but have no semantic effect (to assist readability).
```cobol
*> All semantically identical
ADD Num1 Num2 Num3 TO Result
ADD Num1, Num2, Num3 TO Result
ADD Num1; Num2; Num3 TO Result
```
## Special Metalanguage Suffixes
 | Suffix | Meaning |
 | ------ | ------- |
 | $i | Alphanumeric data item |
 | $il | Alphanumeric data item or string literal |
 | #i | Numeric data item |
 | #il | Numeric data item or numeric literal |
 | $#i | Numeric or alphanumeric data item |

# Structure of COBOL Programs
- Hierarchial structure.
  - Consist of: divisions, sections, paragraphs, sentences, and statements.
```
PROGRAM
  DIVISION(S)
    SECTIONS(S)
      Paragraph(s)
        Sentences(s)
          Statement(s)
```
## DIVISION(S)
- Major structual element
- Four types:
  - IDENTIFICATION DIVISION
  - ENVIRONMENT DIVISION
  - DATA DIVISION
  - PROCEDURE DIVISION
## SECTION(S)
- In the first three divisions, sections are organizational structure defined by the language. In PROCEDURE DIVISION, sections and paragraphs used to identify blocks of code that can be executed using `PERFORM` or `GO TO`.
- Begins with section name (devised by the programmer), ends when next section name is encountered or program text ends.
```cobol
*> Example names
MyRecords SECTION.
FILE SECTION.
CONFIGRUATION SECTION.
INPUT-OUTPUT SECTION.
```
## PARAGRAPH(S)
- In first three divisions, sections are organizational structure defined by the language. In PROCEDURE DIVISION, used to identify blocks of code that can be executed using `PERFORM` or `GO TO`.
- Begins paragraph name, ends where next section or paragraph name is encountered or where program text ends.
```cobol
*> ENVIRONMENT DIVISION entries required for File Declaration
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
  SELECT ExampleFile ASSIGN TO "Example.dat"
    ORGANIZATION IS SEQUENTIAL.

*> PROCEDURE DIVISION with two PARAGRAPHS
PROCEDURE DIVISION.
Begin.
  PERFORM DisplayGreeting 10 TIMES.
  STOP RUN.

DisplayGreeting.
  DISPLAY "Greetings from COBOL".
```
## Sentence(s)
- One or more statements terminated by a period.
  - **MUST** be at least one sentence in a paragraph.
```cobol
*> Example sentences
SUBTRACT Tax FROM GrossPay GIVING NetPay.

MOVE .21 TO VatRate
COMPUTE VatAmount = ProductCost * VatRate
DISPLAY "The VAT amount is - " VaTAmount.
```
## Statement(s)
- Statements in COBOLS referred to as *verbs*.
- Starts with name of verb and followed by operand(s) on which the verb acts
```cobol
*> Example statements
DISPLAY "Enter name " WITH NO ADVANCING
ACCEPT StudentName
DISPLAY "Name entered was " StudentName
```
### Major COBOL Verbs
 | Arithmetic | File Handling | Flow Control | Assignment & IO | Table Handling | String Handling |
 | --- | --- | --- | --- | --- | --- |
 | COMPUTE | OPEN | IF | MOVE | SEARCH | INSPECT |
 | ADD | CLOSE | EVALUATE | SET | SEARCH ALL | STRING|
 | SUBTRACT | READ | PERFORM | INITIALIZEACCEPT | SET | UNSTRING |
 | MULTIPLY | WRITE | GO TO | DISPLAY | 
 | DIVIDE | DELETE | CALL | 
 | | REWRITE | STOP RUN | | 
 | | START | EXIT PROGRAM |
 | | SORT | |
 | | RETURN | 
 | | RELEASE |

# Four Divisions
- Although divisions can be omitted, sequence in which they are specified is fixed.
```cobol
IDENTIFICATION DIVISION. Information about the program
ENVIRONMENT DIVISION. Environment information
DATA DIVISION. Data descriptions
PROCEDURE DIVISION. Program algorithms
```
## IDENTIFICATION DIVISION
- Provides info about the program to you, compiler, and linker.
- `PROGRAM-ID` paragraph is the only required. Used by `CALL` and the linker (main "identity" of the program).
  - `AUTHOR` and `DATE-WRITTEN` also most common.
- Nowadays, other entries usually comments.
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. MyProgram.
AUTHOR. Cody Boland.
DATE-WRITTEN. 2022 September 09.
```
## ENVIRONMENT DIVISION
- Describes environment which the program works (dependencies).
- Useful when have to change the program to run on a different computer, peripherals, or country (character set? currency?).
- Two sections:
  - CONFIGRUATION SECTION
    - `SPECIAL-NAMES` paragraph specifies alphabet, currency symbol, and decimal point symbol.
      - `DECIMAL-POINT IS COMMA` specifies `1.234,56` rather than `1,234.56`.
      - `SYMBOLIC CHARACTERS` lets you assign name to one of the unprintable characters (use ordinal position, not value).
      - `SELECT` and `ASSIGN` connect name you use for a file in program with actual name and location in disk.
  - INPUT-OUTPUT SECTION
    - `FILE-CONTROL` paragraph lets you connect internal file names with external devices and files.
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. ConfigExample.
AUTHOR. Cody Boland.
ENVIRONMENT DIVISION.
CONFIGRUATION SECTION.
SPECIAL-NAMES.
  DECIMAL-POINT IS COMMA.
  SYMBOLIC CHARACTERS ESC CR LF
                  ARE  28 14 11.

INPUT-OUTPUT SECTION.
FILE-CONTROL.
  SELECT StockFile ASSIGN TO "D:\DataFiles\Stock.dat"
    ORGANIZATION IS SEQUENTIAL.
```

## DATA DIVISION
- Describes most of the data the program processes.
- Four sections:
  - FILE SECTION
  - WORKING-STORAGE SECTION
  - LINKAGE SECTION
  - REPORT SECTION
- First two are main sections; `LINKAGE` only used in subprograms, `REPORT` only used when generating reports.
### FILE SECTION
- Describes data sent to, or comes from, computer's data storage (card readers, magnetic tape drives, HDDs, CDs, DVDs, etc.).

### WORKING-STORAGE SECTION
- Describes general variables used in program.
```cobol
*> Example data declaration
IDENTIFICATION DIVISION.
PROGRAM-ID. ExDataDeclr.
AUTHOR. Cody Boland.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 CardinalNum   PIC 99      VALUE ZEROS.
01 IntegerNum    PIC S99     VALUE -14
01 DecimalNum    PIC 999V999 VALUE 543.21
01 ShopName      PIC X(30)   VALUE SPACES.
01 ReportHeading PIC X(25)   VALUE "=== Employment Report ==="
```
### Data Hierarchy
- Use level numbers: higher level (`01`) is final composition, lower level (n > `01`) are subordinate data items.
```cobol
01 BirthDate.
  02 YearOfBirth.
    03 CenturyOB  PIC 99.
    03 YearOB     PIC 99.
  02 MonthOfBirth PIC 99.
  02 DayOfBirth   PIC 99.
```
```cobol
*> Example data move
MOVE "19451225" TO BirthDate.

 |               BirthDate                        |
 |     YearOfBirth    | MonthOfBirth | DayOfBirth |
 | CenturyOB | YearOB |                           |
 |  1  |  9  | 4 | 5  |   1   |   2  |   2  |   5 |
```
## PROCEDURE DIVISION
- Where data in DATA DIVISION is processed and produced.
- Section is optional; must be at least one paragraph, one sentence, and one statement.
- Section and paragraph names chosen by programmer (not defined by the language like other divisions).
```cobol
*> Example shortest program that meets all requiremnts
IDENTIFICATION DIVISION.
PROGRAM-ID. ShortProgram.
PROCEDURE DIVISION.
DisplayPrompt.
  DISPLAY "Hello World".
```
# COBOL Coding Rules
- Punch card era rules:
  - On coding sheet, first 6 chaarcter positions reserved for sequence numbers.
    - Sequence numbers used to be vital insurance against disaster of dropping stack of punch cards.
  - Seventh character reserved for asterisk which is start of comment.
  - Actual program text starts on column 8.
    - 8 to 11 known as Area A. 
      - Division, section, and paragraph names, file-description entries, and 01 level numbers must start in Area A.
    - 12 to 72 Area B.
      - All other sentences.
  - 73 to 80 is identification area used to identify the program.
    - Used for disaster insurance (if card stacks of different programs dropped, easily identifiable).

  ## Name Construction
- Must contain 1 character and not more than 30.
- Must contain at least 1 alphabetic character and not begin or end with hyphen (conflicts with minus sign).
- Must be characters A-Z, numbers 0-9, and hyphen.
- Names aren't case-sensitive, including reserved words.
- Reserved words cannot be used as user-defined names.
- Reserved words typically all caps and user-defined mixed case with starting uppercase character.
- Style may be differentiated amongst programmers!
## Example Formatting Rules
```cobol
*> Display a greeting N times

IDENTIFICATION DIVISION.
PROGRAM-ID. Greetings.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 IterNum PIC 9 VALUE 5.

PROCEDURE DIVISION.
BeginProgram.
  PERFORM DisplayGreeting IterNum TIMES.
  STOP RUN.

DisplayGreeting.
  DISPLAY "Greetings from COBOL!"
```
```cobol
*> Add to numbers from STDIN

IDENTIFICATION DIVISION.
PROGRAM-ID. DoAddition.
AUTHOR. Cody Boland.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 FirstNum   PIC 9     VALUE ZEROS.
01 SecondNum  PIC 9     VALUE ZEROS.
01 CalcResult PIC 99    VALUE 0.
01 UserPrompt PIC X(38) VALUE
              "Please enter two single digit numbers".
PROCEDURE DIVISION.
CalculateResult.
  DISPLAY UserPrompt.
  ACCEPT FirstNum
  ACCEPT SecondNum
  COMPUTE CalcResult = FirstNum + SecondNum
  DISPLAY "Result is ", CalcResult
  STOP RUN.
```
## Condition Names
- Boolean that can only take *true* or *false* values.
- Associated (via level 88) with a data item. Rather than setting *true* or *false* directly, it automatically takes the value (true or false) depending on value of its associated data item.
```cobol
*> Example conditions. Output if STDIN is vowel, consonant or digit.

IDENTIFICATION DIVISION.
PROGRAM-ID. ConditionNames.
AUTHOR. Cody Boland.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 CharIn PIC X.
  88 Vowel           VALUE "a", "e", "i", "o", "u".
  88 Consonant       VALUE "b", "c", "d", "f", "g", "h"
                           "j" THRU "n", "p" THRU "t", "v" THRU "z".
  88 Digit           VALUE "0" THRU "9".
  88 ValidCharacter  VALUE "a" THRU "z", "0" THRU "9".
PROCEDURE DIVISION.
Begin.
  DISPLAY "Enter lower case character or digit. Invalid char terminates program."
  ACCEPT CharIn
  PERFORM UNTIL NOT ValidCharacter
    EVALUATE TRUE
      WHEN Vowel     DISPLAY "The letter " CharIn " is a vowel."
      WHEN Consonant DISPLAY "The letter " CharIn " is a consonant."
      WHEN Digit     DISPLAY CharIn " is a digit."
    END-EVALUATE
    ACCEPT CharIn
  END-PERFORM

  STOP RUN.
```
