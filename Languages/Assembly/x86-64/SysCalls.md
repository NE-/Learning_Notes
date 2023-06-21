<!--
  Author:  NE- https://github.com/NE-
  Date:    2022 August 27
  Purpose: General notes for x86-64 System Calls.
-->

# System Calls
- Essentially a function call that changes CPU into kernel mode and executes a function which is part of the kernel.
  - Executing kernel functions typically need proper permissions.

## 32 Bit System Calls
- Defined in **/user/include/asm/unistd_32.h**.
- To execute a syscall, place syscall number in `eax` and use software interrupt instruction to effect the call (`int 0x80`).
  - Parameters placed in `ebx ecx edx esi edi ebp`. Return value placed in `eax`.
```x86asm
; STDOUT call example

       segment .data
hello: db "Hello World!",0x0a
       segment .text
       ...
       mov eax, 4       ; 4 is sys_write
       mov ebx, 1       ; 1 is file descriptor (STDOUT)
       lea ecx, [hello] ; array to write
       mov edx, 13      ; size in bytes
       int 0x80
       ...
```

## 64 Bit System Calls
- Defined in **/user/include/asm/unistd_64.h**.
  - Documented in section 2 of on-line manual e.g. `man 2 write`.
- Syscall number placed in `rax`, parameters in `rdi rsi rdx r10 r8 r9`, return value in `rax`.
  - Registers same in C function calls except `r10` replaced `rcx` for parameter 4.
- Instead of `int 0x80`, x86-64 Linux uses `syscall` instruction.
```x86asm
; 64 bit Hello World
        segment .data
hello:  db "Hello World!",0x0a

        segment .text
        global _start
_start:
        mov eax, 1       ; syscall 1 is write
        mov edi, 1       ; file descriptor (STDOUT)
        lea rsi, [hello] ; array to write
        mov edx, 13      ; size in bytes
        syscall
        mov eax, 60      ; syscall 60 is exit
        xor edi, edi     ; exit(0)
        syscall
```

## C Wrapper Functions
- Using C wrapper functions over explicit `syscall` is preferred way to use system calls.
  - Don't have to worry about finding numbers.
  - Don't have to deal with different register usage.
```x86asm
; 64 bit Hello World using C wrapper functions

      segment .data
msg:  db "Hello World!",0x0a
len:  equ $-msg ; Current address - address of msg
                ; Gives length of string

      segment .text
      global  main
      extern  write, exit ; defined in C library
main:
      mov  edx, len ; arg3 is length
      mov  rsi, msg ; arg2 is array
      mov  edi, 1   ; arg1 is file descriptor
      call write
      xor  edi, edi ; prepare for return 0
      call exit
```

## Open System Call
- Open files.
```C 
/**
  @param[in] pathname - Character array terminated with a 0 byte.
  @param[in] flags    - Bit patterns that determine how the file will be opened. OR'd together.
  @param[in] mode     - If file is to be created, mode defines permissions (rwx) to assign the file.

  @return File descriptor index or negative number on failure.
 */
int open(char* pathname, int flags [,int mode]);
```
### Flags
 | bits | meaning |
 | ---- | ------- |
 | 0 | read-only |
 | 1 | write-only |
 | 2 | read and write |
 | 0x40 | create if needed |
 | 0x200 | truncate the file |
 | 0x400 | append |
```x86asm
; Sample file open

      segment .data
fd:   dd 0
name: db "sample",0

      segment .text
      extern open

      lea rdi, [name] ; pathname
      mov esi, 0x42   ; 0x40 (create) | 0x02 (read-write)
      mov rdx, 600o   ; 011 000 000 permissions (rw user)
      call open
      cmp eax, 0      ; 0 - eax
      jl error        ; negative result means failed to open
      mov [fd], eax   ; savefile descriptor
      ...
```

## Read and Write System Calls
```C
/**
  @param[in] fd    - File descriptor to read from.
  @param[in] buf   - Read into buffer.
  @param[in] count - Read up to count bytes.

  @return Number of bytes read (0 indicates EOF) or -1 on failure.
 */
int read(int fd, void *buf, size_t count);

/**
  @param[in] fd    - File descriptor to write to.
  @param[in] buf   - Write from buffer.
  @param[in] count - Write up to count bytes.

  @return Number of bytes written or -1 on failure (errno set).
 */
int write(int fd, void *buf, size_t count);
```

## lseek
- Repositions file offset before read/write.
```C
/**
  @param[in] fd     - File Descriptor.
  @param[in] offset - Offset position in bytes.
  @param[in] whence - Directive:
                        SEEK_SET set to "offset" bytes.
                        SEEK_CUR set to current location plus "offset" bytes.
                        SEEK_END set to size of file plus "offset" bytes.

  @return Offset location in bytes from beggining of file or -1 on failure (errno set).
 */ 
off_t lseek(int fd, off_t offset, int whence);
```
- Using `lseek` with offset 0 and *whence* 2 returns byte position 1 greater than last byte of file (easy way to determine file size).
  - Knowing size helps with memory allocation for reading entire file.
```x86asm
; Get file size and allocate memory.

mov edi, [fd]
xor esi, esi    ; offset = 0
mov edx, 2      ; whence = 2
call lseek      ; determine file size
mov [size], rax ; save return
mov edi, rax    ; prepare for allocation
call malloc
mov [data], rax ; save return
mov edi, [fd]
xor esi, esi    ; offset = 0
xor edx, edx    ; whence = 0
call lseek      ; seek to start
mov edi, [fd]
mov esi, [data] ; read into buffer
mov edx, [size] ; number of bytes to read
call read
```

## Close System Call
- Close file when done reading/writing.
  - Operating system will close it if not properly closed as with premature termination of a program.
    - Still good to always close a file because reduces overhead in kernel and avoids per-process limit on number of open files.
```C
/**
  @param[in] fd - File descriptor to close.

  @return 0 on success or -1 on failure (errno set).
 */
int close(int fd);
```
```x86asm
mov edi, [fd]
call close
```
