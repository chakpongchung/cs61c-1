.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    # save arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    # fopen
    mv a1, s0
    li a2, 1
    jal fopen
    blt a0, x0, exit_53
    mv s4, a0

    # calculate the number of items
    mul s5, s2, s3

    # fwrite
    mv a1, s4
    mv a2, s1
    mv a3, s5
    li a4, 4
    jal fwrite
    blt a0, s5, exit_54

    # fclose
    mv a1, s4
    jal fclose
    bne a0, x0, exit_55


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

exit_53:
    li a1, 53
    j exit2

exit_54:
    li a1, 54
    j exit2

exit_55:
    li a1, 55
    j exit2