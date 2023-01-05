        segment .text
        global main
        extern scanf
        extern printf

        segment .data
        struc longint
        longint_digits resd 10
        longint_sz resd 1
        longint_sign resb 1
        endstruc

        lhs istruc longint
        iend
        rhs istruc longint
        iend
        res istruc longint
        iend

base:
        dd 1000000000                  ; 10^9

        segment .bss
        buf resb 200

        segment .text
main:
        push rbp
        mov rbp, rsp

        mov r15, rdi                   ; argc

        lea rdi, [lhs]
        call input

        lea rdi, [rhs]
        call input

        cmp r15, 1                     ; argc
        je .sum
; ;; .mul:
        lea rdi, [lhs]
        lea rsi, [rhs]
        call unsigned_mul

        lea rdi, [res]
        call output
        jmp .exit
.sum:
        lea rdi, [lhs]
        lea rsi, [rhs]
        call signed_add
        mov rdi, rax
        call output

.exit:
        xor eax, eax
        leave
        ret

; ;; output(longint* rdi)
output:
        push rbp
        mov rbp, rsp

        mov byte[buf+99], 0
        mov byte[buf+98], '0'
        lea r9, [buf+98]

        cmp dword[rdi+longint_sz], 0
        je .print

        lea rsi, [buf+98]
        mov r8, 10
        mov rcx, 0
.while:
        mov eax, dword[rdi+4*rcx]

        mov r10, 9
.more:
        mov rdx, 0
        idiv r8
        cmp rdx, 0
        cmovnz r9, rsi
        add rdx, '0'
        mov byte[rsi], dl
        dec rsi

        dec r10
        jnz .more

        inc rcx
        cmp ecx, dword[rdi+longint_sz]
        jne .while

        cmp byte[rdi+longint_sign], 0
        je .print
        cmp byte[r9], '0'
        je .print
        dec r9
        mov byte[r9], '-'

.print:
        segment .data
.format:
        db "%s", 0xa, 0
        segment .text
        lea rdi, [.format]
        mov rsi, r9
        call printf

        leave
        ret

; ;; input(longint* rdi)
; ;; TODO: обнаружение недопустимых символов
; ;; TODO: ввод в шестнадцатеричной системе счисления
input:
        push rbp
        mov rbp, rsp

        mov r12, rdi

        segment .data
.format:
        db "%s", 0
        segment .text

        lea rdi, [.format]
        lea rsi, [buf]
        call scanf

        lea rdi, [buf]
        lea r9, [buf]
        cmp byte[buf], '-'
        jne .skip
        inc rdi
        inc r9
        mov byte[r12+longint_sign], 1
.skip:
        call strlen
        mov rcx, rax

        xor r8, r8
        cmp rcx, 0
.for:
        jl .endfor

        mov byte[r9+rcx], 0
        lea rdi, [r9+rcx-9]
        cmp rcx, 9
        cmovl rdi, r9
        call atoi
        mov dword[r12+4*r8], eax
        inc r8

        sub rcx, 9
        jmp .for
.endfor:

        mov dword[r12+longint_sz], r8d

        leave
        ret

strlen:
        mov rcx, -1
        xor al, al
        repne scasb
        mov rax, -2
        sub rax, rcx
        ret

atoi:
        xor rax, rax
        xor r14, r14
.more:
        imul eax, 10
        mov r14b, byte[rdi]
        add eax, r14d
        sub eax, '0'
        inc rdi
        cmp byte[rdi], 0
        jnz .more
        ret

; ;; unsigned_add(longint* rdi, longint* rsi)
unsigned_add:
        xor rax, rax                   ; carry = 0
        xor rcx, rcx                   ; i = 0
        mov r10d, dword[base]          ; base
        mov ebx, dword[rdi+longint_sz]
        cmp ebx, dword[rsi+longint_sz]
        cmovl ebx, dword[rsi+longint_sz] ; ebx = max(rdi.sz, rsi.sz)
.for:
        cmp ecx, ebx
        jl .forbody
        cmp eax, 0
        jnz .forbody
        jmp .endfor
.forbody:
        cmp ecx, dword[rdi+longint_sz]
        jne .skip
        xor r9, r9
        mov r9d, dword[rdi+longint_sz]
        mov dword[rdi+4*r9], 0
        inc dword[rdi+longint_sz]
.skip:
; ; rdi[i] += carry + (i < rsi.sz ? rsi[i] : 0)
        mov edx, dword[rdi+4*rcx]
        add edx, eax
        xor eax, eax
        cmp ecx, dword[rsi+longint_sz]
        cmovl eax, dword[rsi+4*rcx]
        add edx, eax
        mov dword[rdi+4*rcx], edx

        xor eax, eax
        cmp dword[rdi+4*rcx], r10d
        jl .skip2
        sub dword[rdi+4*rcx], r10d
        mov eax, 1
.skip2:
        inc ecx
        jmp .for
.endfor:
        ret

; ;; unsigned_sub(longint* rdi, longint* rsi)
unsigned_sub:
        xor rax, rax                   ; carry = 0
        xor rcx, rcx                   ; i = 0
        mov r10d, dword[base]          ; base
.for:
        cmp ecx, dword[rsi+longint_sz]
        jl .forbody
        cmp eax, 0
        jnz .forbody
        jmp .endfor
.forbody:
; ; rdi[i] -= carry + (i < rsi.sz ? rsi[i] : 0)
        mov edx, dword[rdi+4*rcx]
        sub edx, eax
        xor eax, eax
        cmp ecx, dword[rsi+longint_sz]
        cmovl eax, dword[rsi+4*rcx]
        sub edx, eax
        mov dword[rdi+4*rcx], edx

        xor eax, eax
        cmp dword[rdi+4*rcx], 0
        jge .skip2
        add dword[rdi+4*rcx], r10d
        mov eax, 1
.skip2:
        inc ecx
        jmp .for
.endfor:
        xor r9, r9
        mov r9d, dword[rdi+longint_sz]
.while:
        cmp r9d, 1
        jle .endwhile
        cmp dword[rdi+4*r9-4], 0
        jnz .endwhile
        dec r9d
        mov dword[rdi+longint_sz], r9d
        jmp .while
.endwhile:
        ret

; ;; unsigned_mul(longint* rdi, longint* rsi) -> res
unsigned_mul:
        mov ecx, dword[rdi+longint_sz]
        add ecx, dword[rsi+longint_sz]
        mov dword[res+longint_sz], ecx
        xor rcx, rcx                   ; i = 0
.for:
        cmp ecx, dword[rdi+longint_sz]
        jge .endfor

        xor rbx, rbx                   ; j = 0
        xor rax, rax                   ; carry = 0
.inner_for:
        mov r8d, dword[rsi+longint_sz]
        cmp ebx, r8d
        jl .body_inner_for
        cmp rax, 0
        jnz .body_inner_for
        jmp .end_inner_for
.body_inner_for:
        xor r10, r10                   ; cur
        cmp ebx, dword[rsi+longint_sz] ; if j < b.size()
        cmovl r10d, dword[rsi+4*rbx]   ; b[j] : 0
        xor r11, r11
        mov r11d, dword[rdi+4*rcx]     ; a[i]
        imul r10, r11                  ; a[i] * (b[j] : 0)
        xor r11, r11
        lea r12, [res+4*rcx]
        mov r11d, dword[r12+4*rbx]
        add r10, r11
        add rax, r10
        xor rdx, rdx
        idiv dword[base]
        mov dword[r12+4*rbx], edx
        inc ebx
        jmp .inner_for
.end_inner_for:
        inc ecx
        jmp .for
.endfor:
        xor r9, r9
        mov r9d, dword[res+longint_sz]
.while:
        cmp r9d, 1
        jle .endwhile
        cmp dword[res+4*r9-4], 0
        jnz .endwhile
        dec r9d
        mov dword[res+longint_sz], r9d
        jmp .while
.endwhile:
        ret

; ;; signed_add(longint* rdi, longint* rsi) -> longint* res
signed_add:
        xor rax, rax
        mov al, byte[rdi+longint_sign]
        cmp byte[rsi+longint_sign], al
        jz .add
        call less_than
        cmp rax, 0
        je .sub
        xchg rdi, rsi
        jmp .sub

.add:
        call unsigned_add
        mov rax, rdi
        ret
.sub:
        call unsigned_sub
        mov rax, rdi
        ret

; ;; less_than(longint* rdi, longint* rsi) -> bool
less_than:
; ;; FIXME: сравнение 0 с 0 работает неверно!
        xor rcx, rcx
        mov ecx, dword[rdi+longint_sz]
        cmp ecx, dword[rsi+longint_sz] ; rdi.sz < rsi.sz
        jl .less
        jg .not_less
        mov edx, dword[rsi+longint_sz]
.more:
        dec rcx
        dec edx
        cmp rcx, -1
        je .not_less
        mov ebx, dword[rdi+4*rcx]
        xor rdx, rdx
        cmp ebx, dword[rsi+4*rdx]
        jl .less
        jg .not_less
        jmp .more
.not_less:
        mov rax, 0
        ret
.less:
        mov rax, 1
        ret

; ;; TODO: signed_mul(longint* rdi, longint* rsi)
