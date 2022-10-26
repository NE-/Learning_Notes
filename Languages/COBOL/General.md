<!--
  Author: NE- https://github.com/NE-
  Date: 2022 September 07
  Purpose: COBOL General notes.
-->

# General
- COBOL acronym for **Co**mmon **B**usiness **O**riented **L**anguage.
  - Focus is business or enterprise computing.
  - Great for processing data transactions.
- Not good for general computing (computer science concepts).
  - No low-level access.
  - No dynamic memory allocation.
  - No recursion.
  - Can't create data structures (linked lists, queues, etc).
  - Can't create algorithms such as Quicksort.
- Why it's great for business?
  - Declare and manipulate heterogeneous data (fixed and variable length character strings, integers, cardinals, and decimal numbers). 
  - Declare and manipulate decimal data as a native data type.
    - Computed calculations should produce **_exactly_** the same result using manual calculations. Other languages commonly have minute rounding errors.
  - Conveniently generate reports and create GUI.
    - Business applications should have external focus e.g. process data in files and databases rather than in memory.

### COBOL vs. Java Example
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. SalesTax.
WORKING-STORAGE SECTION.
01 beforeTax    PIC 999V999 VALUE 123.45.
01 salesTaxRate PIC V999    VALUE .065.
01 afterTax     PIC 999.99.
PROCEDURE DIVISION.
Begin.
  COMPUTE afterTax ROUNDED = beforeTax + (beforeTax * salesTaxRate)
  DISPLAY "After tax amount is " afterTax.
```
```java
import java.math.BigDecimal;

public class SalesTaxWithBigDecimal {
  public static void main(java.lang.String[] args) {
    BigDecimal beforeTax    = BigDecimal.valueOf(12345, 2);
    BigDecimal salesTaxRate = BigDecimal.valueOf(65, 3);
    BigDecimal ratePlusOne  = salesTaxRate.add(BigDecimal.valueOf(1));
    BigDecimal afterTax     = beforeTax.multiply(ratePlusOne);
    afterTax = afterTax.setScale(2, BigDecimal.ROUND_HALF_UP);
    System.out.println("After tax amount is " + afterTax);
  }
}
```
- COBOL has more native decimal data while Java relies on BigDecimal class. This makes COBOL easier to read and understand for these kinds of applications.

# History
- Discussed April 1959 to create data-oriented language for business.
  - Sponsored and organized by the US Department of Defense.
- COBOL influenced by AIMACO (US Air Force designed), FLOW-MATIC (developed under Rear Admiral Grace Hopper), and COMTRAN (IBM's COMmercial TRANslator).
- First definition produced by CODASYL Committee in 1960.
- RCA and Remington-Rand-Univac produced first compiler.
- Standards assumed by ANSI, which produced next 3 standards: ANS 68, ANS 74, and ANS 85.
  - Newer standards assumed by ISO. ISO 2002 was first standard produced by ISO which defines object-oriented version of COBOL.
- Used coding forms and passed to puch-card operators then submitted to computer operator.
  - Required many strict formatting rules that aren't necessary today, but still followed.


# Standards
- 4 standards: 1968, 1974, 1985, and 2002.
## COBOL ANS 68
- Resolved incompatibilities between versions.
- reemphasized *common* part of COBOL acronym (language is same acroos range of machines).

## COBOL ANS 74
- Introduced `CALL` and external subprograms.
- Restricted access to any variable in the Data Division.

## COBOL ANS 85
- Introduced structured programming.
- `END-IF` and `END-READ`.
- Previous versions, period (full stop) used to delimit scope, caused many bugs.

## COBOL ANS 2002
- Object orientation constructs introduced in ISO 2002 standard.
