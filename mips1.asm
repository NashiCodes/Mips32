.equ SIZE, 20
.data
msg_main: .asciiz "Soma: "                                      # string msg_main
espaco_imprime: .asciiz ", "                                    # string espaco
fim_linha: .asciiz "\n"                                         # string fim_linha
vet: .space SIZE*4                                              # vetor de inteiros
.text
main:
    la      $s0,                vet                             # $s0 = &vet
    li      $s1,                0                               # variavel soma inicializada com 0

    la      $a0,                $s0                             # $a0 = &vet
    li      $a1,                SIZE                            # $a1 = SIZE
    li      $a2,                71                              # $a2 = 71
    jal     inicializaVetor                                     # chama a função inicializaVetor
    move    $s1,                $v0                             # soma = retorno da função inicializaVetor

    la      $a0,                $s0                             # $a0 = &vet
    li      $a1,                SIZE                            # $a1 = SIZE
    jal     ImprimeVetor                                        # chama a função ImprimeVetor

    la      $a0,                $s0                             # $a0 = &vet
    li      $a1,                SIZE                            # $a1 = SIZE
    jal     ordenaVetor                                         # chama a função ordenaVetor

    la      $a0,                $s0                             # $a0 = &vet
    li      $a1,                SIZE                            # $a1 = SIZE
    jal     ImprimeVetor                                        # chama a função ImprimeVetor

    la      $a0,                $s0                             # $a0 = &vet
    sll     $a1,                SIZE,           2               # $a1 = SIZE * 4
    add     $a1,                $s0,            $a1             # $a1 = &vet[SIZE]
    jal     zeraVetor                                           # chama a função zeraVetor

    la      $a0,                $s0                             # $a0 = &vet
    li      $a1,                SIZE                            # $a1 = SIZE
    jal     ImprimeVetor                                        # chama a função ImprimeVetor

    la      $a0,                msg_main                        # carrega o endereço de msg_main para o registrador de argumento
    li      $v0,                4                               # carrega o valor 4 para imprimir string
    syscall                                                     # imprime a string msg_main
    li      $a0,                $s1                             # carrega o valor de soma para o registrador de argumento
    li      $v0,                1                               # carrega o valor 1 para imprimir inteiro
    syscall                                                     # imprime o valor de soma
    li      $v0,                4                               # carrega o valor 4 para imprimir string
    la      $a0,                fim_linha                       # carrega o endereco da string fim_linha para o registrador de argumento
    syscall                                                     # imprime a string fim_linha

    li      $v0,                10                              # carrega o valor 10 para sair do programa
    syscall                                                     # sai do programa



# Função para zerar o vetor
# $a0: ponteiro para a primeira posição do vetor
# $a1: ponteiro para a última posição + 1 do vetor
zeraVetor:
    addi    $sp,                $sp,            -12             # aloca espaço para salvar $s0, $s1 e $s2 na pilha
    sw      $s0,                0($sp)                          # salva $s0 na pilha
    sw      $s1,                4($sp)                          # salva $s1 na pilha
    sw      $s2,                8($sp)                          # salva $s2 na pilha

    move    $s0,                $a0                             # $s0 recebe o ponteiro para a primeira posição do vetor
    move    $s1,                $a1                             # $s1 recebe o ponteiro para a última posição + 1 do vetor
    li      $s2,                0                               # $s2 recebe o valor zero

loop_zera:
    beq     $s0,                $s1,            fim_zera        # se $s0 for igual a $s1, encerra o loop
    sw      $s2,                ($s0)                           # armazena o valor zero na posição apontada por $s0
    addi    $s0,                $s0,            4               # incrementa $s0 para apontar para a próxima posição
    j       loop_zera                                           # volta ao início do loop

fim_zera:
    lw      $s2,                8($sp)                          # recupera $s2 da pilha
    lw      $s1,                4($sp)                          # recupera $s1 da pilha
    lw      $s0,                0($sp)                          # recupera $s0 da pilha
    addi    $sp,                $sp,            12              # libera espaço da pilha
    jr      $ra                                                 # retorna para o endereço de retorno

# Função para ler o vetor
# $a0: ponteiro para a primeira posição do vetor
# $a1: ponteiro para a última posição + 1 do vetor
ImprimeVetor:
    addi    $sp,                $sp,            -8              # $sp = $sp + -8
    sw      $s0,                0($sp)                          # salva o valor de $s0 na pilha
    sw      $s1,                4($sp)                          # salva o valor de $s1 na pilha

    move    $s0,                $a0                             # $s0 recebe o inicio do array
    move    $s1,                $a1                             # $s1 recebe o tamanho do array

    li      $t0,                0                               # carrega o valor 0 para o contador
loop_imprime:
    bge     $t0,                $s1,            fim_imprime     # Enquanto o contador for menor q o tamanho, continua o loop
    lw      $a0,                0($s1)                          # carrega o valor do ponteiro do inicio
    li      $v0,                1                               # carrega o valor 1 para imprimir inteiro
    syscall 

    li      $v0,                4                               # carrega o valor 4 para imprimir string
    la      $a0,                espaco_imprime                  # carrega o endereco da string espaco para o registrador de argumento
    syscall                                                     # imprime a string espaco

    addi    $t0,                $t0,            1               # incrementa o contador
    addi    $s0,                $s0,            4               # incrementa o ponteiro do inicio
    j       loop_imprime                                        # Volta ao loop_imprime

fim_imprime:
    lw      $s1,                4($sp)                          # recupera o valor de $s1 da pilha
    lw      $s0,                0($sp)                          # recupera o valor de $s0 da pilha
    addi    $sp,                $sp,            8               # $sp = $sp + 8
    jr      $ra                                                 # retorna para o endereço de retorno

# Função para trocar dois valores
troca:

    move    $t0,                $a0                             # $t0 = $a0
    move    $t1,                $a1                             # $t1 = $a1

    sw      $t1,                0($t2)                          # salva o valor de $t1 na posição apontada por $t2
    sw      $t0,                0($t1)                          # salva o valor de $t0 na posição apontada por $t1
    sw      $t2,                0($t0)                          # salva o valor de $t2 na posição apontada por $t0

    jr      $ra                                                 # retorna para o endereço de retorno


# Função para ordenar o vetor
# $a0: ponteiro para a primeira posição do vetor
# $a1: ponteiro para o tamanho do vetor
ordenaVetor:
    addi    $sp,                $sp,            -24             # $sp = $sp + -24
    sw      $s0,                0($sp)                          # salva o valor de $s0 na pilha
    sw      $s1,                4($sp)                          # salva o valor de $s1 na pilha
    sw      $s2,                8($sp)                          # salva o valor de $s2 na pilha
    sw      $s3,                12($sp)                         # salva o valor de $s3 na pilha
    sw      $s4,                16($sp)                         # salva o valor de $s4 na pilha
    sw      $s5,                20($sp)                         # salva o valor de $s5 na pilha

    move    $s0,                $a0                             # $s0 recebe o inicio do array (ponteiro)
    move    $s1,                $a1                             # $s1 recebe o tamanho do array (n)

    li      $s2,                0                               # inicializa i
    li      $s3,                0                               # inicializa j
    li      $s4,                0                               # inicializa min_idx
    add     $s5,                $s1,            -1              # n - 1


loop_ordena_i:
    bge     $s2,                $s5,            fim_ordena      # Enquanto o contador for menor q o tamanho-1, continua o loop
    move    $s4,                $s2                             # min_idx = i

loop_ordena_j:
    add     $s3,                $s2,            1               # j = i + 1
    bge     $s3,                $s1,            confere_min     # Enquanto j < n, continua o loop

    sll     $t0,                $s3,            2               # $t0 = j * 4
    sll     $t1,                $s4,            2               # $t1 = min_idx * 4
    add     $t0,                $s0,            $t0             # $t0 = &vet[j]
    add     $t1,                $s0,            $t1             # $t1 = &vet[min_idx]
    lw      $t0,                0($t0)                          # $t0 = vet[j]
    lw      $t1,                0($t1)                          # $t1 = vet[min_idx]
    bgt     $t0,                $t1,            loop_ordena_j   # Se vet[j] > vet[min_idx], vai para loop_ordena_j
    move    $s4,                $s3                             # min_idx = j
    addi    $s3,                $s3,            1               # j++
    j       loop_ordena_j                                       # Volta ao loop_ordena_j

confere_min:
    beq     $s4,                $s1,            fim_ordena_i    # Se min_idx == n, volta para fim_ordena_i
    sll     $t0,                $s2,            2               # $t0 = i * 4
    sll     $t1,                $s4,            2               # $t1 = min_idx * 4
    add     $t0,                $s0,            $t0             # $t0 = &vet[i]
    add     $t1,                $s0,            $t1             # $t1 = &vet[min_idx]
    lw      $a0,                0($t1)                          # $a0 = vet[min_idx]
    lw      $a1,                0($t0)                          # $a1 = vet[i]
    jal     troca                                               # chama a função troca
    addi    $s2,                $s2,            1               # i++
    j       loop_ordena_i                                       # Volta ao loop_ordena_i

fim_ordena:
    lw      $s5,                20($sp)                         # recupera o valor de $s5 da pilha
    lw      $s4,                16($sp)                         # recupera o valor de $s4 da pilha
    lw      $s3,                12($sp)                         # recupera o valor de $s3 da pilha
    lw      $s2,                8($sp)                          # recupera o valor de $s2 da pilha
    lw      $s1,                4($sp)                          # recupera o valor de $s1 da pilha
    lw      $s0,                0($sp)                          # recupera o valor de $s0 da pilha
    addi    $sp,                $sp,            24              # $sp = $sp + 24
    jr      $ra                                                 # retorna para o endereço de retorno


valorAleatorio:
    addi    $sp,                $sp,            -24             # $sp = $sp + -24
    sw      $ra,                0($sp)                          # salva o valor de $ra na pilha
    sw      $s0,                4($sp)                          # salva o valor de $s0 na pilha
    sw      $s1,                8($sp)                          # salva o valor de $s1 na pilha
    sw      $s2,                12($sp)                         # salva o valor de $s2 na pilha
    sw      $s3,                16($sp)                         # salva o valor de $s3 na pilha
    sw      $s4,                20($sp)                         # salva o valor de $s4 na pilha

    move    $s0,                $a0                             # $s0 recebe parametro $a0
    move    $s1,                $a1                             # $s1 recebe parametro $a1
    move    $s2,                $a2                             # $s2 recebe parametro $a2
    move    $s3,                $a3                             # $s3 recebe parametro $a3

