.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Prologue
    addi sp, sp, -64 
    sw s0, 0(sp)
	sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)  
    sw ra, 36(sp)


    # verify the number of command line arguments
    li t0, 5
    bne a0, t0, exit_49

    # save arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0, 4(s1)
    addi a1, sp, 40     # pointer to # of rows of m0
    addi a2, sp, 44     # pointer to # of cols of m0
    jal read_matrix
    mv s3, a0           # pointer to the start of m0

    # Load pretrained m1
    lw a0, 8(s1)
    addi a1, sp, 48     # pointer to # of rows of m1
    addi a2, sp, 52     # pointer to # of cols of m1
    jal read_matrix
    mv s4, a0           # pointer to the start of m1


    # Load input matrix
    lw a0, 12(s1)
    addi a1, sp, 56     # pointer to # of rows of input matrix
    addi a2, sp, 60     # pointer to # of cols of input matrix
    jal read_matrix
    mv s5, a0           # pointer to the start of input matrix



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)


    # 1
    ## malloc
    lw t0, 40(sp)
    lw t1, 60(sp)
    li t2, 4
    mul t3, t1, t0
    mul t3, t3, t2
    mv a0, t3
    jal malloc
    blt a0, x0, exit_48
    mv s6, a0   # pointer to the hidden_layer

    ## m0 * input
    mv a0, s3
    lw a1, 40(sp)
    lw a2, 44(sp)
    mv a3, s5
    lw a4, 56(sp)
    lw a5, 60(sp)
    mv a6, s6
    jal matmul

    # 2
    lw t0, 40(sp)
    lw t1, 60(sp)
    mul t3, t1, t0
    mv a1, t3
    mv a0, s6
    jal relu

    # 3
    ## malloc
    lw t0, 48(sp)   # number of rows of m1
    lw t1, 60(sp)   # number of cols of hidden_layer
    li t2, 4
    mul t3, t1, t0
    mul t3, t3, t2
    mv a0, t3
    jal malloc
    blt a0, x0, exit_48
    mv s7, a0   # pointer to the scores

    ## m1 * hidden_layer
    mv a0, s4
    lw a1, 48(sp)
    lw a2, 52(sp)
    mv a3, s6
    lw a4, 40(sp)
    lw a5, 60(sp)
    mv a6, s7
    jal matmul




    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s7
    lw a2, 48(sp)
    lw a3, 60(sp)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s7
    lw t0, 48(sp)   # number of rows of m1
    lw t1, 60(sp)   # number of cols of hidden_layer
    mul a1, t0, t1
    jal argmax
    mv s8, a0

    # Print classification
    mv a1, s8
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char

    # output
    mv a0, s8

    #Epilogue  
    lw s0, 0(sp)
	lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)  
    lw ra, 36(sp)
    addi sp, sp, 64 

    ret

exit_49:
    li a1, 49
    j exit2

exit_48:
    li a1, 48
    j exit2