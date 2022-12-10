        segment .text
        global main
        extern random
        extern printf
        extern srandom

main:
        push rbp
        mov rbp, rsp

        mov rdi, [seed]
        call srandom
        call fill
        call print
        call min
        segment .data
.format:
        db "index of max: %ld", 0x0a, 0
        segment .text
        lea rdi, [.format]
        mov rsi, rax
        call printf

        mov rax, 0
        leave
        ret

; ; fill()
fill:
        .i equ 0
        push rbp
        mov rbp, rsp
        sub rsp, 16
        xor rcx, rcx
        .more mov [rsp+.i], rcx
        call random
        mov rcx, [rsp+.i]
        mov r10d, 20
        idiv r10d
        mov [arr+rcx*4], edx
        inc rcx
        cmp rcx, [sz]
        jl .more
        leave
        ret

; ; print()
print:
        .i equ 0
        push rbp
        mov rbp, rsp
        sub rsp, 16
        xor rcx, rcx
; ; mov  [rsp+.i], rcx
        segment .data
.format:
        db "%10d", 0x0a, 0
        segment .text
        .more lea rdi, [.format]
        mov [rsp+.i], rcx
        mov esi, [arr+rcx*4]
        call printf
        mov rcx, [rsp+.i]
        inc rcx
        cmp rcx, [sz]
        jl .more
        leave
        ret

; ; x = min()
min:
        mov eax, 0
        mov r8d, [arr]
        mov rcx, 1
        .more: mov r9d, [arr+rcx*4]
        cmp r9d, r8d
        cmovg r8d, r9d
        cmovg eax, ecx
        inc rcx
        cmp rcx, [sz]
        jl .more
        ret

        segment .data
sz:
        dq 8
seed:
        dq 200

        segment .bss
        arr resd 8
