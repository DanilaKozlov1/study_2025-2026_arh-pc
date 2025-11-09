%include "in_out.asm"

SECTION .data
msg: DB "Введите строку: ", 0h
msgLen: EQU $-msg

SECTION .bss
bufl: RESB 80

SECTION .text
	GLOBAL _start
	_start:
	mov  eax, msg
	call sprint

	mov ecx, bufl
	mov edx, 80

	call sread
	mov eax, 4
	mov ebx, 1
	mov ecx, bufl
	int 80h

	call quit

	call quit

