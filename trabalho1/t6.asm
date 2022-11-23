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

fileName db 50 dup(0)
inputHandle dd 0 ; Variavel para armazenar o handle de entrada
outputHandle dd 0 ; Variavel para armazenar o handle de saida
console_count dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string dd 0 ; Variavel para armazenar tamanho de string terminada em 0

fileName2 db 50 dup(0)
inputHandle2 dd 0 ; Variavel para armazenar o handle de entrada
outputHandle2 dd 0 ; Variavel para armazenar o handle de saida
console_count2 dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string2 dd 0 ; Variavel para armazenar tamanho de string terminada em 0

numCanal db 50 dup(0)
inputHandle3 dd 0 ; Variavel para armazenar o handle de entrada
outputHandle3 dd 0 ; Variavel para armazenar o handle de saida
console_count3 dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string3 dd 0 ; Variavel para armazenar tamanho de string terminada em 0

;fileName db "catita.bmp", 0H
;fileName2 db "catita41.bmp", 0H
fileHandle dd 0
fileHandle2 dd 0
fileBuffer db 3 dup(0)
readCount dd 0
writeCount dd 0
numCanal1 dd 0
num dd 0

.code
start:

    printf("Digite o nome do arquivo:\n")
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke ReadConsole, inputHandle, addr fileName, sizeof fileName, addr console_count, NULL
    invoke StrLen, addr fileName
    mov tamanho_string, eax
    invoke WriteConsole, outputHandle, addr fileName, tamanho_string, addr console_count, NULL

    mov esi, offset fileName ; Armazenar apontador da string em esi
    proximo:
        mov al, [esi] ; Mover caractere atual para al
        inc esi ; Apontar para o proximo caractere
        cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
        jne proximo
        dec esi ; Apontar para caractere anterior
        xor al, al ; ASCII 0
        mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR

    printf("Digite o nome do arquivo de saida:\n")
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle2, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle2, eax
    invoke ReadConsole, inputHandle2, addr fileName2, sizeof fileName2, addr console_count2, NULL
    invoke StrLen, addr fileName2
    mov tamanho_string2, eax
    invoke WriteConsole, outputHandle2, addr fileName2, tamanho_string2, addr console_count2, NULL

    mov esi, offset fileName2 ; Armazenar apontador da string em esi
    proximo2:
        mov al, [esi] ; Mover caractere atual para al
        inc esi ; Apontar para o proximo caractere
        cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
        jne proximo2
        dec esi ; Apontar para caractere anterior
        xor al, al ; ASCII 0
        mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR

    printf("Digite o numero do canal:\n")
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle3, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle3, eax
    invoke ReadConsole, inputHandle3, addr numCanal, sizeof numCanal, addr console_count3, NULL
    invoke StrLen, addr numCanal
    mov tamanho_string3, eax
    invoke WriteConsole, outputHandle3, addr numCanal, tamanho_string3, addr console_count3, NULL

    mov esi, offset numCanal; Armazenar apontador da string em esi
    proximo3:
        mov al, [esi] ; Mover caracter atual para al
        inc esi ; Apontar para o proximo caracter
        cmp al, 48 ; Verificar se menor que ASCII 48 - FINALIZAR
        jl terminar
        cmp al, 58 ; Verificar se menor que ASCII 58 - CONTINUAR
        jl proximo3
    terminar:
        dec esi ; Apontar para caracter anterior
        xor al, al ; 0 ou NULL
        mov [esi], al ; Inserir NULL logo apos o termino do numero

    invoke atodw, addr numCanal
    mov numCanal1, eax

    ;printf("%d\n", numCanal1)
    

    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL

    mov fileHandle, eax

    invoke ReadFile, fileHandle, addr fileBuffer, 0, addr readCount, NULL


    invoke CreateFile, addr fileName2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle2, eax


    ;mov eax, 0
    xor eax, eax
    xor ebx, ebx
    
    inicio:
        push eax
        invoke ReadFile, fileHandle, addr fileBuffer, 1, addr readCount, NULL ;
        invoke WriteFile, fileHandle2, addr fileBuffer, 1, addr writeCount, NULL
        pop eax
        
        inc eax
        ;printf("%d\n", eax)
        cmp eax, 54
        jb inicio


    ;printf("%d\n", eax)
    colorir:
        push eax
        invoke ReadFile, fileHandle, addr fileBuffer, 3, addr readCount, NULL ;
        ;invoke WriteFile, fileHandle2, addr fileBuffer, 3, addr writeCount, NULL
        ;pop eax

        ;printf("1:%d\n",fileBuffer(0))
        ;printf("%d", ecx); tem alguma coisa mexendo em ecx
        ;printf("canal: %d\n", numCanal1)

        xor ecx, ecx
        mov ecx, numCanal1
  
        mov bl, BYTE PTR [fileBuffer+0]
        add bl, 50
        mov BYTE PTR [fileBuffer+0], bl
        ;printf("%d\n", ecx)
        cmp BYTE PTR [fileBuffer+0], 50
        jb limiter
        
        jmp escreve
        limiter:
            mov BYTE PTR [fileBuffer+0], 255
            jmp escreve
            
        escreve:
            invoke WriteFile, fileHandle2, addr fileBuffer, 3, addr writeCount, NULL
            pop eax      

            inc eax
            cmp readCount, 0
            je fim
        
            jmp colorir 
        
        ;printf("%d\n", fileBuffer)
    fim:
        ;printf("%d\n", fileBuffer)
        invoke CloseHandle, fileHandle
        invoke CloseHandle, fileHandle2

    
    invoke ExitProcess, 0
    
end start
