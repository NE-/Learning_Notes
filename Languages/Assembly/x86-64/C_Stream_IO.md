<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 28
  Purpose: General notes for x86-64 C Stream I/O.
-->

# C Stream I/O
- Using buffered I/O is more efficient.
  - If reading, it will read from already read data, enough to fill its buffer (~8192 bytes).
  - Reading from buffer is 20 times faster (using `read`) than reading 1 byte at a time using `getchar`.
- When call `read` to read 1 byte, OS forced by disk drive to read complete sectors (~512 bytes per sector).
  - OS will "save" 4096 read bytes for efficient retrieval. WIthout buffers, retrieval requires disk interaction for each byt (10-20 times slower versus using buffer).
- For small quantity data, faster to use stream I/O rather than system calls.

## Opening a File
```C
/**
  @param[in] pathname Name of file to open.
  @param[in] mode     Opening mode.
      r:  read
      r+: read and write
      w:  write. truncates or creates
      w+: read and write. truncates or creates
      a:  write only. appends or creates
      a+: read and write. appends or creates

  @return FILE pointer, NULL on failure (errno set).
  */
FILE *fopen(char* pathname, char* mode);
```
```asm
;;; Opening a file

     segment .data
name db "customers.dat",0
mode db "w+",0
fp   dq 0
     segment .text
     global  fopen
     lea     rdi, [name] ; arg1 pathname
     lea     rsi, [mode] ; arg2 mode
     call fopen
     mov     [fp], rax   ; save pointer
```

## fscanf and fprintf
```C
/**
  @param[in] fp     FILE pointer
  @param[in] format Format string
  @param[in] ...    Variable number of arguments

  @return Number of input items matched or EOF (errno set).
  */
int fscanf(FILE *fp, char* format, ...);

/**
  @param[in] fp     FILE pointer
  @param[in] format Format string
  @param[in] ...    Variable number of arguments

  @return Number of characters printed or negative number on error.
  */
int fprintf(FILE *fp, char* format, ...);
```

## fgetc and fputc
- Convenient for processing data character by character.
```C
/**
  @param[in] fp FILE pointer

  @return Character read or EOF (reached end of file or error).
  */
int fgetc(FILE* fp);

/**
  @param[in] c  Character to write
  @param[in] fp FILE pointer

  @return Character written or EOF on error.
  */
int fputc(int c, FILE* fp);
```
- `int ungetc(int c, FILE* fp);` gives 1 character **_c_** back to file stream **_fp_**.
  - Returns **_c_** on success or EOF on error.

```asm
;;; Copy file from one stream to another

more mov  rdi, [ifp] ; use input file pointer
     call fgetc
     cmp  eax, -1    ; check if error or EOF
     je   done       ; abort if error or EOF
     mov  rdi, rax   ; save return
     mov  rsi, [ofp] ; use output file pointer
     call fputc
     jmp  more       ; next char
done:
  ...
```

## fgets and fputs
- Processes line-by-line.
```C
/**
  @param[in] s    Buffer for character storage
  @param[in] size Num-1 characters to read
  @param[in] fp   FILE pointer

  @return s on success or NULL on error or EOF
  */
char* fgets(char* s, int size, FILE* fp);

/**
  @param[in] s  String to write
  @param[in] fp FILE pointer

  @return Non-negative number on success or EOF on error
  */
int fputs(char* s, FILE* fp);
```

```asm
;;; Copy lines of text from one stream to another
;;; Skips lines starting with ';' 

more lea rdi, [s]   ; character buffer
     mov esi, 200   ; size to read
     mov rdx, [ifp] ; input file pointer
     call fgets
     cmp rax, 0     ; check for NULL or EOF
     je done
     mov al, [s]    ; get data
     cmp al, ';'    ; check delimiter for skipping line
     je more
     lea rdi, [s]   ; character buffer
     mov rsi, [ofp] ; output file pointer
     call fputs
     jmp more       ; next line
done:
  ...
```

## fread and fwrite
- Read and write arrays of data.
```C
/**
  @param[in] p            Pointer for storage
  @param[in] size         Size, in bytes, of each data item
  @param[in] nelts(nmemb) Number of items to be read
  @param[in] fp           FILE pointer to read from

  @return Number of items read, 0 or 1 on failure
  */
int fread(void* p, int size, int nelts, FILE* fp);

/**
  @param[in] p            Pointer for storage
  @param[in] size         Size, in bytes, of each data item
  @param[in] nelts(nmemb) Number of items to be written
  @param[in] fp           FILE pointer to obtain data from

  @return Number of items written, 0 or 1 on failure
  */
int fwrite(void* p, int size, int nelts, FILE* fp);
```
```asm
mov  rdi, [customers]   ; storage pointer
mov  esi, Customer_size ; size of each data item
mov  edx, 100           ; number of items to be written
mov  rcx, [fp]          ; file pointer
call fwrite
```
## fseek and ftell
- fseek positions a stream.
- ftell determines current position.
```C
/**
  @param[in] fp     Stream to use
  @param[in] offset Bytes to offset from
  @param[in] whence Offset specifier (SEEK_SET SEEK_CUR SEEK_END)

  @return 0 on success -1 on error (errno set)
  */
int fseek(FILE* fp, long offset, int whence);

/**
  @param[in] fp Stream to use

  @return Current offset or -1 on error (errno set)
  */
long ftell(FILE* fp);
```

```asm
;;; Write a Customer to file
; void write_customer(FILE* fp, struct Customer* c, int record_number);

     segment .text
     global write_customer
write_customer:
.fp  equ  0
.c   equ  8
.rec equ  16
     push rbp                ; function epilogue
     mov  rbp, rsp           ; function epilogue
     sub  rsp, 32            ; allocate memory
     mov  [rsp+.fp], rdi     ; save arg1
     mov  [rsp+.c], rsi      ; save arg2
     mov  [rsp+.rec], rdx    ; save arg3
     mul  rdx, Customer_size ; record_number * sizeof(struct Customer)
     mov  rsi, rdx           ; offset
     mov  rdx, 0             ; whence
     call ftell
     mov  rdi, [rsp+.c]      ; restore struct argument
     mov  rsi, Customer_size ; offset
     mov  rdx, 1             ; whence
     mov  rcx, [rsp+.fp]     ; file pointer
     call fwrite
     leave
     ret
```

## fclose
- Closes a stream. Writes data when called or forgotten when failed to call.
```C
/**
  @param[in] stream Stream to close

  @return 0 on success EOF on error (errno set)
  */
int fclose(FILE* stream);
```