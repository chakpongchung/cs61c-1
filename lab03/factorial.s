.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi s2, x0, 1  #s2:result
    addi s3, x0, 1  #s3:1
loop:
    blt a0, s3, loop_end
    mul s2, s2, a0
    addi a0, a0, -1
    jal x0, loop
loop_end:
    add a0, x0, s2
    add s2, x0, x0
    jr ra

