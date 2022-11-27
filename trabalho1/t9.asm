.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
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

numIn db 50 dup(0)
inputHandle4 dd 0 ; Variavel para armazenar o handle de entrada
outputHandle4 dd 0 ; Variavel para armazenar o handle de saida
console_count4 dd 0 ; Variavel para armazenar caracteres lidos/escritos na console
tamanho_string4 dd 0 ; Variavel para armazenar tamanho de string terminada em 0

output db "Digite o nome do arquivo original:", 0ah, 0h
outputHandle5 dd 0 ; Variavel para armazenar o handle de saida
write_count dd 0; Variavel para armazenar caracteres escritos na console

output1 db "Digite o nome do arquivo de saida:", 0ah, 0h
outputHandle6 dd 0 ; Variavel para armazenar o handle de saida
write_count1 dd 0; Variavel para armazenar caracteres escritos na console

output2 db "Digite o numero do canal:(0-azul, 1-verde, 2-vermelho)", 0ah, 0h
outputHandle7 dd 0 ; Variavel para armazenar o handle de saida
write_count2 dd 0; Variavel para armazenar caracteres escritos na console

output3 db "Digite o numero a ser adicionado:(entre 0 e 255)", 0ah, 0h
outputHandle8 dd 0 ; Variavel para armazenar o handle de saida
write_count3 dd 0; Variavel para armazenar caracteres escritos na console

fileHandle dd 0
fileHandle2 dd 0
fileBuffer db 3 dup(0)
readCount dd 0
writeCount dd 0
numCanal1 dd 0; Variável para armazenar o número do canal
numInserido dd 0; Variável para armazenar o número a ser adicionado no pixel

.code
start:

    push STD_OUTPUT_HANDLE
    call GetStdHandle ;Call convention do tipo callee clean-up, nao precisa mover esp depois
    mov outputHandle5, eax
    invoke WriteConsole, outputHandle5, addr output, sizeof output, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke ReadConsole, inputHandle, addr fileName, sizeof fileName, addr console_count, NULL
    invoke StrLen, addr fileName
    mov tamanho_string, eax

    mov esi, offset fileName ; Armazenar apontador da string em esi
    proximo:
        mov al, [esi] ; Mover caractere atual para al
        inc esi ; Apontar para o proximo caractere
        cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
        jne proximo
        dec esi ; Apontar para caractere anterior
        xor al, al ; ASCII 0
        mov [esi], al ; Inserir ASCII 0 no lugar do ASCII CR

    push STD_OUTPUT_HANDLE
    call GetStdHandle 
    mov outputHandle6, eax
    invoke WriteConsole, outputHandle6, addr output1, sizeof output1, addr write_count1, NULL
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle2, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle2, eax
    invoke ReadConsole, inputHandle2, addr fileName2, sizeof fileName2, addr console_count2, NULL
    invoke StrLen, addr fileName2
    mov tamanho_string2, eax

    mov esi, offset fileName2
    proximo2:
        mov al, [esi] 
        inc esi 
        cmp al, 13
        jne proximo2
        dec esi 
        xor al, al 
        mov [esi], al

    push STD_OUTPUT_HANDLE
    call GetStdHandle 
    mov outputHandle7, eax
    invoke WriteConsole, outputHandle7, addr output2, sizeof output2, addr write_count2, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle3, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle3, eax
    invoke ReadConsole, inputHandle3, addr numCanal, sizeof numCanal, addr console_count3, NULL
    invoke StrLen, addr numCanal
    mov tamanho_string3, eax

    mov esi, offset numCanal
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


    push STD_OUTPUT_HANDLE
    call GetStdHandle ;Call convention do tipo callee clean-up, nao precisa mover esp depois
    mov outputHandle8, eax
    invoke WriteConsole, outputHandle8, addr output3, sizeof output3, addr write_count3, NULL
    
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle4, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle4, eax
    invoke ReadConsole, inputHandle4, addr numIn, sizeof numIn, addr console_count4, NULL
    invoke StrLen, addr numIn
    mov tamanho_string4, eax

    mov esi, offset numIn; Armazenar apontador da string em esi
    proximo4:
        mov al, [esi]
        inc esi 
        cmp al, 48 
        jl terminar1
        cmp al, 58
        jl proximo4
    terminar1:
        dec esi
        xor al, al
        mov [esi], al

    invoke atodw, addr numIn
    mov numInserido, eax
    

    invoke CreateFile, addr fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL; Função para abrir uma imagem já existente

    mov fileHandle, eax

    invoke ReadFile, fileHandle, addr fileBuffer, 0, addr readCount, NULL; Função que vai ler o conteúdo da imagem aberta


    invoke CreateFile, addr fileName2, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL; Função que vai criar uma nova imagem com o nome infomado pelo usuário
    mov fileHandle2, eax


    xor eax, eax
    xor ebx, ebx

    ;Label criada para repetir os 54 bytes de cabeçalho na nova imagem criada
    inicio:
        push eax; Push e Pop realizados pois o invoke mexe nos registradores e bagunça tudo
        invoke ReadFile, fileHandle, addr fileBuffer, 1, addr readCount, NULL; Lê os bytes da imagem orignal
        invoke WriteFile, fileHandle2, addr fileBuffer, 1, addr writeCount, NULL; Escreve os bytes lidos na imagem de saída
        pop eax
        
        inc eax
        cmp eax, 54
        jb inicio

    push offset fileBuffer; Colocando o fileBuffer da imagem na pilha
    push numCanal1; Colocando o número do canal escolhido na pilha
    push numInserido; Clocando o número a ser somado na pilha 
    
    call Colorir; Chamada da Função

    ;Função criada para mexer nos canais e nos valores dos canais escolhidos pelo usuário
    Colorir:
        push ebp
        mov ebp, esp
        inicio2:
            push eax
            mov edx, DWORD PTR [ebp+16]; [ebp+16] = posição do fileBuffer na pilha

            push edx; Push e Pop realizados pois o invoke mexe nos registradores e bagunça tudo
            invoke ReadFile, fileHandle, edx, 3, addr readCount, NULL ;
            pop edx
        
            mov ecx, DWORD PTR [ebp+12]; [ebp+12] = posição do numCanal1 na pilha
            mov bl, BYTE PTR [edx+ecx]
    
            add bl, BYTE PTR [ebp+8]; [ebp+8] = posição do numInserido na pilha
            mov BYTE PTR [edx+ecx], bl
           
            cmp bl, BYTE PTR [ebp+8]
            jb limiter

            jmp escreve
            
        ; Label criada para para evitar o estouro da memória, corrige os pixels errados depois da soma caso o valor ultrapasse 255
        limiter:
            mov BYTE PTR [edx+ecx], 255
            jmp escreve

        escreve:
            invoke WriteFile, fileHandle2, edx, 3, addr writeCount, NULL; Escreve na imagem de saído os novos valores das cores
            pop eax      

            inc eax
            cmp readCount, 0; Verifica se chegou no final do arquivo
            je fim
        
            jmp inicio2
            
        fim:
            mov esp, ebp
            pop ebp
            invoke CloseHandle, fileHandle; Fecha a imagem de entrada
            invoke CloseHandle, fileHandle2; Fecha a imagem de saída


    invoke ExitProcess, 0
    
end start
