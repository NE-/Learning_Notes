<!--
  Author: NE- https://github.com/NE-
  Date: 2022 August 28
  Purpose: General notes for Data Structures in x86-64 Assembly.
-->

# Data Structures
## Linked Lists
- Chain of nodes.
  - Example is stack-like (first in is first node).
```asm
; Node struct
        struc node
n_value resq  1 ; data value
n_next  resq  1 ; pointer to next node
        align 8 ; bound-safety though not required for 2 QWs
        endstruc

; Create empty list
newlist:
  xor eax, eax ; use NULL pointer as empty list
  ret

; Insert number
;; list = insert(list, k)
insert:
.list equ 0
.k    equ 8
      push rbp               ; epilogue
      mov  rbp, rsp          ; epilogue
      sub  rsp, 16           ; allocate memory
      mov  [rsp+.list], rdi  ; save list pointer on stack
      mov  [rsp+.k], rsi     ; save k on stack
      mov  edi, node_size    ; prepare for memory allocation
      call malloc
      mov  r8, [rsp+.list]   ; get list pointer
      mov  [rax+n_next], r8  ; save pointer in node
      mov  r9, [rsp+.k]      ; get k
      mov  [rax+n_value], r9 ; save k in node
      leave
      ret

; Traversing and printing the list
print:
      segment .data
.print_fmt:
      db "%ld ",0
.newline:
      db 0x0a,0

      segment .text
.rbx  equ 0
      push rbp                ; epilogue
      mov  rbp, rsp           ; epilogue
      sub  rsp, 16            ; allocate memory
      mov  [rsp+.rbx], rbx    ; preserve rbx
      cmp  rdi, 0             ; if list size 0/NULL
      je   .done              ; leave
      mov  rbx, rdi           ; save size
.more lea  rdi, [.print_fmt]  ; prepare to print node data
      mov  rsi, [rbx+n_value] ; get node value
      xor  eax, eax           ; clear eax (no float parameters)
      call printf
      mov  rbx, [rbx+n_next]  ; get next node in list
      cmp  rbx, 0             ; if node isn't NULL
      jne  .more              ; redo data printing
.done lea  rdi, [.newline]    ; prepare to print newline character
      xor  eax, eax           ; clear eax (no float parameters)
      call printf
      mov  rbx, [rsp+.rbx]    ; restore rbx
      leave
      ret

; main function
; create list, read values, insert values to list, print list
main:
.list equ 0
.k    equ 8
      segment .data
.scanf_fmt:
  db "%ld",0
      segment .text
      push rbp      ; epilogue
      mov  rbp, rsp ; epilogue
      sub  rsp, 16  ; allocate memory
      call newlist
      mov  [rsp+.list], rax  ; sets .list to 0 (NULL)
.more lea  rdi, [.scanf_fmt] ; prepare for scanf
      lea  rsi, [rsp+.k]     ; holds read data
      xor  eax, eax          ; no float parameters
      call scanf
      cmp  rax, 1            ; did scanf successfully math 1 input item?
      jne  .done             ; if not, terminate
      mov  rdi, [rsp+.list]  ; arg1 for insert subroutine
      mov  rsi, [rsp+.k]     ; arg2 for insert subroutine
      call insert
      mov  [rsp+.list], rax  ; save returned allocated list to .list
      mov  rdi, rax          ; arg1 if 0, ends print subroutine
      call print
      jmp  .more             ; prompt for another value
.done leave
      ret
```

## Doubly Linked List
- 2 pointers for each node: one for previous node, one for next node.
  - Example is circularly linked.
```asm
        struc node
n_value resq 1
n_next  resq 1
n_prev  resq 1
        align 8
        endstruc

; Create new list
;; list = newlist();
newlist:
  push rbp
  mov rbp, rsp
  mov edi, node_size ; prepare for allocation
  call malloc
  mov [rax+n_next], rax ; link to itself
  mov [rax+n_prev], rax ; link to itself
  leave
  ret

; Insert at front
;; insert(list, k);
insert:
.list equ 0
.k    equ 8
      push rbp
      mov  rbp, rsp
      sub  rsp, 16
      mov  [rsp+.list], rdi  ; save list pointer on stack
      mov  [rsp+.k], rsi     ; save k on stack
      mov  edi,node_size     ; prepare for allocation
      call malloc
      mov  r8, [rsp+.list]   ; get list pointer
      mov  r9, [r8+n_next]   ; get head's next
      mov  [rax+n_next], r9  ; set new next
      mov  [rax+n_prev], r8  ; set new prev
      mov  [r8+n_next], rax  ; set head's next
      mov  [r8+n_prev], rax  ; set new node's next's prev
      mov  r9, [rsp+.k]      ; get k
      mov  [rax+n_value], r9 ; save k in node
      leave
      ret

; List traversal
;; print(list);
print:
      segment .data
.print_fmt:
      db "%ld",0
.newline:
      db 0x0a,0
      segment .text
.list equ 0
.rbx equ 8
      push rbp, rsp
      mov  rbp, rsp
      sub  rsp, 16
      mov  [rsp+.rbx], rbx    ; preserve rbx
      mov  [rsp+.list], rdi   ; save list pointer
      mov  rbx, [rdi+n_next]  ; get next node
      cmp  rbx, [rsp+.list]   ; check if we reached head node
      je   .done              ; if so, list has been fully traversed
.more lea  rdi, [.print_fmt]  ; get print format
      mov  rsi, [rbx+n_value] ; get node's value for printing
      call printf
      mov  rbx, [rbx+n_next]  ; get next node
      cmp  rbx, [rsp+.list]   ; check if reached head node
      jne  .more 
.done lea  rdi, [.newline]    ; prepare newline for printf
      call printf
      mov  rbx, [rsp+.rbx]    ; restore rbx
      leave
      ret

main:
  ...
```

## Hash Tables
- Efficient dictionary that uses hash values as keys.
- Good hash functions give good key distribution for short chains.
  - Recommended that a hash table length should be a prime number. If there is no pattern to keys, use *n* mod *t*.
    - *n* is the key, *t* is table length.
```asm
; Hash function. Table length = 256 (0xFF)
;; i = hash(n);
;;; n % 256
hash mov rax, rdi
     and rax, 0xFF
     ret
```
---
### Hash Function for Strings
- Treat string as containing polynomial coefficients and evaluate *p(n)* for some prime number *n*.
```C
int hash(unsigned char* s) {
  unsigned long h = 0;
  int i = 0;

  // for each character
  while (s[i]) {
    h = h*191 + s[i]; // hash with prime 191
    ++i;
  }
  return h % 100000; // return hash % table length
}
```
 ---

```asm
        segment .data
table   times 256 dq 0 ; initialize array of length 256
        struc node
n_value resq  1
n_next  resq  1
        align 8
        endstruc

; Find value in hash table
;; p = find(n);
find:
.n equ 0
      push rbp
      mov  rbp, rsp
      sub  rsp, 16
      mov  [rsp+.n], rdi      ; save arg n
      call hash               ; get it's hash value (key)
      mov  rax, [table+rax*8] ; go to that index in table
      mov  rdi, [rsp+.n]      ; retrieve n
      cmp  rax, 0             ; if index is empty
      je   .done              ; leave
.more cmp  rdi, [rax+n_value] ; if values match
      je   .done              ; we found the node
      mov  rax, [rax+n_next]  ; check next node
      cmp  rax, 0             ; if not NULL
      jne  .more              ; redo process
.done leave
      ret

; Insertion
;; insert(n);
insert:
.n     equ  0
.h     equ  8
       push rbp
       mov  rbp, rsp
       sub  rsp, 16
       mov  [rsp+.n], rdi     ; save n
       call find              ; to avoid inserting key more than once
       cmp  rax, 0            ; if find didn't return 0 (not found)
       jne  .found            ; key already exists
       mov  rdi, [rsp+.n]     ; restore n
       call hash              ; get has value
       mov  [rsp+.h], rax     ; save returned hash
       mov  rdi, node_size    ; prepare for allocation
       call malloc
       mov  r9, [rsp+.h]      ; get hash value
       mov  r8, [table+r9*8]  ; get pointer to new node
       mov  [rax+n_next], r8  ; set next
       mov  r8, [rsp+.n]      ; restore n
       mov  [rax+n_value], r8 ; set value
       mov  [table+r9*8], rax ; save pointer
.found leave
       ret

; Printing
print:
        push rbp
        mov  rbp, rsp
        push r12                ; preserve r12
        push r13                ; preserve r13
        xor  r12, r12           ; set r12 to 0
.more_table:
        mov  r13, [table+r12*8] ; get first index
        cmp  r13, 0             ; check if NULL
        je   .empty             ; if NULL, index is empty

        segment .data
.print1 db "list %3d: ",0
        segment .text
        lea  rdi, [.print1]     ; print format
        mov  rsi, r12           ; r12 is index counter
        call printf
        
.more_list:
        segment .data
.print2 db "%ld ",0
        segment .text
        lea  rdi, [.print2]     ; print format
        mov  rsi, [r13+n_value] ; get data property from node
        call printf
        mov  r13, [r13+n_next]  ; get next property from node
        cmp  r13, 0             ; check for NULL
        jne  .more_list         ; if not NULL, print next node

        segment .data
.print3 db 0x0a,0
        segment .text
        lea  rdi, [.print3] ; print format (newline)
        call printf
.empty  inc  r12            ; get next table index
        cmp  r12, 256       ; check if at end of table
        jl   .more_table    ; if not, do next index
        pop  r13            ; restore r13
        pop  r12            ; restore r12
        leave
        ret

; main
main:
.k    equ 0
      segment .data
.scanf_fmt:
      db "%ld",0
      segment .text
      push rbp
      mov  rbp, rsp
      sub  rsp, 16
.more lea  rdi, [.scanf_fmt] ; scanf format
      lea  rsi, [rsp+.k]     ; buffer to store input
      call scanf
      cmp  rax, 1            ; successful scanf?
      jne  .done             ; if not terminate
      mov  rdi, [rsp+.k]     ; get input value
      call insert            ; insert into table
      call print             ; print table
      jmp  .more             ; repeat
.done leave
      ret
```

## Binary Trees
- Has 1 root node ("start" of tree) and "left" and "right" pointers to nodes.
- Generally built with ordering applied to keys.
  - If node's key is less than previous, link "left," else link "right."
  - Ordering makes searches faster (called Binary Search Trees) through comparative traversals.
```asm
        struc node
n_value resq 1
n_left  resq 1
n_right resq 1
        align 8
        endstruc

        struc tree
t_count resq 1     ; number of nodes in the tree
t_root  resq 1
        align 8
        endstruc

; Create empty tree
new_tree:
  push rbp
  mov  rbp, rsp
  mov  rdi, tree_size     ; prepare for allocation
  call malloc
  xor  edi, edi           ; set to 0
  mov  [rax+t_root], rdi  ; set tree's root to 0
  mov  [rax+t_count], rdi ; set tree's count to 0
  leave
  ret

; Finding a Key
;; p = find(t, n);
find:
      push rbp
      mov  rbp,rsp
      mov  rdi, [rdi+t_root]  ; get root node
      xor  eax, eax           ; set to 0
.more cmp  rdi, 0             ; if root is NULL
      je   .done              ; leave
      cmp  rsi, [rdi+n_value]
      jl   .goleft            ; if arg n < current node's value, traverse left
      jg   .goright           ; else if arg n > current node's value, traverse right
      mov  rax, rsi           ; otherwise save arg n
      jmp  .done              ; leave
.goleft
      mov  rdi, [rdi+n_left]  ; store left pointer
      jmp  .more              ; redo search
.go_right:
      mov  rdi,[rdi+n_right]  ; store right pointer
      jmp  .more              ; redo search
.done leave
      ret

; Insert a Key into Tree
;; insert(t, n);
insert:
.n    equ  0
.t    equ  8
      push rbp
      mov  rbp, rsp
      sub  rsp, 16
      mov  [rsp+.t], rdi       ; save arg root note
      mov  [rsp+.n], rsi       ; save arg n
      call find                ; find if key exists
      cmp  rax, 0              ; if key found
      jne  .done               ; do not create a new node
      mov  rdi, node_size      ; prepare fir node allocation
      call malloc
      mov  rsi, [rsp+.n]       ; restore arg n
      mov  [rax+n_value], rsi  ; save as node's value property
      xor  edi, edi            ; set to 0
      mov  [rax+n_left], rdi   ; set left property to NULL
      mov  [rax+n_right], rdi  ; set right property to NULL
      mov  rdx, [rsp+.t]       ; get root node arg t
      mov  rdi, [rdx+t_count]  ; get number of nodes
      cmp  rdi, 0              ; if tree is not empty
      jne  .findparent        
      inc  qword [rdx+t_count] ; else increment number of nodes
      mov  [rdx+t_root], rax   ; newly created node is the root
      jmp  .done               ; nothing else to do
.findparent:
      mov  rdx, [rdx+t_root]   ; point to root node
.repeatfind:
      cmp  rsi, [rdx+n_value]  ; if new key < current node's key
      jl   .goleft             ; traverse left
      ; otherwise traverse right
      mov  r8, rdx             ; save current node
      mov  rdx, [r8+n_right]   ; rdx points to node's right node
      cmp  rdx, 0              ; if node is not NULL
      jne  .repeatfind         ; redo finding insertion point
      mov  [r8+n_right], rax   ; else saved current node now points to new node
      jmp  .done               ; nothing else to do
.goleft:
      mov  r8, rdx             ; save current node
      mov  rdx, [r8+n_left]    ; rdx points to node's left node
      cmp  rdx, 0              ; if node is not NULL
      jne  .repeatfind         ; redo finding insertion point
      mov  [r8+n_left], rax    ; else saved current node now points to new node
.done leave
      ret

; Printing in-order
rec_print:
.t     equ  0
       push rbp
       mov  rbp, rsp
       sub  rsp, 16
       cmp  rdi, 0             ; if node is NULL
       je   .done              ; leave but return to previous call (recursion)
       mov  [rsp+.t], rdi      ; save node
       mov  rdi, [rdi+n_left]  ; traverse left
       call rec_print          ; recurse
       mov  rdi, [rsp+.t]      ; restore node
       mov  rsi, [rdi+n_value] ; get value in node
       segment .data
.print db "%ld ",0
       segment .text
       lea  rdi, [.print]      ; load print format
       call printf
       mov  rdi, [rsp+.t]      ; get node
       mov  rdi, [rdi+n_right] ; traverse right
       call rec_print          ; recurse
.done  leave
       ret

; print(t)
print:
       push rbp
       mov  rbp, rsp
       mov  rdi, [rdi+t_root]  ; get root
       call rec_print          ; recursive print
       segment .data
.print db 0x0a,0
       segment .text
       lea  rdi, [.print]      ; print a newline character
       call printf
       leave
       ret
```
