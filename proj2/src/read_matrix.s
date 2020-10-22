.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -40 
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

    # save arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2
   
    # fopen
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq t0, a0, exit_50
    mv s5, a0   # s5: file descriptor

    # read the number of rows and columns
    li s6, 4    # the number of bytes per word
    mv a1, s5
    mv a2, s1   
    mv a3, s6
    jal fread
    bne a0, s6, exit_51 
    mv a1, s5
    mv a2, s2   
    mv a3, s6
    jal fread
    bne a0, s6, exit_51 
    lw s3, 0(s1)    # s3: the number of rows
    lw s4, 0(s2)    # s4: the number of cols

    # allocate space
    mul s8, s3, s4
    mul s8, s8, s6  # number of bytes to be read
    mv a0, s8
    jal malloc
    mv s7, a0   # the pointer to result

    # read matrix
    mv a1, s5
    mv a2, s7
    mv a3, s8
    jal fread
    bne a0, s8, exit_51 

    # fclose
    mv a1, s5
    jal fclose
    bne a0, x0, exit_52
    
    # output the result
    mv a0, s7

    # Epilogue
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
    addi sp, sp, 40 

    ret

exit_48:
    li a1, 48
    j exit2

exit_50:
    li a1, 50
    j exit2

exit_51:
    li a1, 51
    j exit2

exit_52:
    li a1, 52
    j exit2