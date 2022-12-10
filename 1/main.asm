        segment .text
        global main

main:
        mov rbx, [a]
        imul rbx, [b]
        mov rax, [c]
        xor rdx, rdx
        div qword[d]
        sub rax, 3
        add rax, rbx

; ; atoi(rax)
        push word 0x0A
        mov r8, 10
        mov rcx, 2
atoi:
        xor rdx, rdx
        div r8
        add rdx, 48
        dec rsp
        mov [rsp], dl
        inc rcx
        cmp rax, 0
        jnz atoi

; ; print()
        mov eax, 1
        mov edi, 1
        mov rsi, rsp
        mov edx, ecx
        syscall

; ; exit(0)
        mov eax, 60
        xor edi, edi
        syscall

        segment .data
a:
        dq 100
b:
        dq 2
c:
        dq 20
d:
        dq 5
