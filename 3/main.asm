    segment .text
    global main
    extern printf

main:
    push  rbp
    mov   rbp,    rsp

    mov   rax,    0
    mov   rdi,    0
    lea   rsi,    [buf]
    mov   rdx,    50
    syscall
    mov   [buf+rax-1], byte 0
    lea   rsi,    [buf+rax]
    mov   r8, rsi
    mov   rax,    0
    syscall
    xor   rcx,   rcx
    mov   [r8+rax-1], byte 0

    mov  rdi,     buf
    mov  rsi,     r8
    call strcspn

    segment .data
.format:
      db    "strcspn returned: %ld",0x0a,0
    segment .text
    lea   rdi,    [.format]
    mov   rsi,    rax
    call  printf

    xor rax, rax
    leave
    ret

    segment .bss
buf resb    100

    segment .text
strcspn:
    mov  r8,    0
.for:
    cmp  byte[rdi+r8], 0
    jz   .end
    mov  r9,    0
.ifor:
    cmp  byte[rsi+r9], 0
    jz   .iend
    mov  r10b,    [rsi+r9]
    cmp  byte[rdi+r8], r10b
    jz   .end
    inc  r9
    jmp  .ifor
.iend:
    inc  r8
    jmp  .for
.end:
    mov rax, r8
    ret
