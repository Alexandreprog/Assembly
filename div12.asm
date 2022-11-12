.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
include \masm32\include\msvcrt.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data

    num sdword 1000
    resto sdword 5

.code
start:
    xor edx, edx
    xor eax, eax
    xor ebx, ebx
    mov num, 1000
    mov resto, 5
    mov ebx, 11
    mov eax, num

    retorno:
        mov edx, 0
        mov eax, num
        div ebx
        cmp edx, resto
        je mostrar

        jmp adiciona
        

    adiciona:
        inc num
        cmp num, 2000
        je fim
        jmp retorno


    mostrar:
        printf("%d tem resto %d quando dividido por %d\n", num, edx, ebx)
        jmp adiciona

    fim:
        invoke ExitProcess, 0


end start