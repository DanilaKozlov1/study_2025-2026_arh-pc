%include "in_out.asm"

SECTION .data
    msg DB "Введите значение переменной x: ",0
    res DB "Результат: ",0

SECTION .bss
    x RESB 80

SECTION .text
GLOBAL _start

_start:
    mov eax, msg
    call sprint

    mov ecx, x
    mov edx, 80
    call sread

    mov eax, x
    call atoi

    mov ebx, 3
    cdq
    idiv ebx

    add eax, 5
    imul eax, 7

    mov edi, eax

    mov eax, res
    call sprint
    mov eax, edi
    call iprint

    call quit