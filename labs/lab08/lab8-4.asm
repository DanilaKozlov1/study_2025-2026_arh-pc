%include 'in_out.asm'
SECTION .data
    msg_func   db "Функция f(x) = 3(10 + x)", 0
    msg_result db "Результат: ", 0
SECTION .text
    GLOBAL _start
_start:
    mov eax, msg_func
    call sprintLF
    pop ecx
    pop edx
    sub ecx, 1
    mov esi, 0
next:
    cmp ecx, 0
    jz  _end
    pop eax
    call atoi

    add eax, 10
    mov ebx, 3
    mul ebx
    add esi, eax
    loop next
_end:
    mov eax, msg_result
    call sprint

    mov eax, esi
    call iprintLF
    call quit