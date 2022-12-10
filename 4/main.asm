        segment .text
        global main
        extern scanf

        segment .data
max_digits:
        dd 50
scanf_format:
        db "%50s%50s", 0
        segment .bss
        lstr resb 51
        rstr resb 51

        segment .text
main:
        push rbp
        mov rbp, rsp

        lea rdi, [scanf_format]
        lea rsi, [lstr]
        lea rdx, [rstr]
        call scanf

        xor eax, eax
        leave
        ret
