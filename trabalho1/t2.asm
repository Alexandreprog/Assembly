.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\msvcrt.inc
include \masm32\macros\macros.asm
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib

.data

fileName db "catita.bmp", 0H
fileName2 db "catita2.txt", 0H
fileHandle dd 0
fileHandle2 dd 0
fileBuffer db 3 dup(0)
readCount dd 0
writeCount dd 0
num dd 0

.code
start:
    

    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL

    mov fileHandle, eax

    invoke ReadFile, fileHandle, addr fileBuffer, 0, addr readCount, NULL ; Le 10 bytes do arquivo


    invoke CreateFile, addr fileName2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle2, eax

    ;mov eax, 0
    xor eax, eax

    inicio:
        push eax
        invoke ReadFile, fileHandle, addr fileBuffer, 1, addr readCount, NULL ;
        invoke WriteFile, fileHandle2, addr fileBuffer, 1, addr writeCount, NULL
        pop eax
        
        inc eax
        ;printf("%d\n", eax)
        cmp eax, 54
        jb inicio


    printf("%d\n", eax)

    invoke CloseHandle, fileHandle
    invoke CloseHandle, fileHandle2

    
    invoke ExitProcess, 0
    
end start
