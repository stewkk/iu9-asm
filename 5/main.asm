; ;; Вариант 2
        %include "macros.mac"

        segment .text
        global main
        extern read, printf, open, perror

        segment .bss
        buf resb 201

        segment .text
main:
        begin

        xor r12, r12
        xor r13, r13
        parse_argv r12b, r13b, r14

        cmp r14, 0
        je .skip
        mov rdi, r14
        xor rsi, rsi
        call open
        mov r14, rax
        cmp rax, 0
        jge .skip
        xor rdi, rdi
        call perror
        return 1
.skip:

        mov edi, r14d
        lea rsi, [buf]
        mov rdx, 200
        call read
        cmp rax, 0
        jge .skip2
        xor rdi, rdi
        call perror
        return 1
.skip2:

        lea rsi, [buf]
        replace r12b, r13b, rsi, rax

        segment .data
.format:
        db "%s", 0
        segment .text

        lea rdi, [.format]
        lea rsi, [buf]
        call printf

        return 0
