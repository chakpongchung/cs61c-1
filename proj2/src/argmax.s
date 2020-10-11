.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    addi t0, x0, 1      # t0 = 1
    blt a1, t0, exit_7    # if a1 < 1, go to exit

loop_start:
    addi t0, x0, 1  # t0 = 1, t0 is 'i' in loop
    lw t1, 0(a0)    # t1 = a0[0], t1 is the largest num
    addi t2, x0, 0  # t2 = 0, t2 is the index of the largest num
    addi t3, x0, 4  # t3 = 4, meaning 4 bytes per 1 element

loop_continue:
    bge t0, a1, loop_end    # if to >= a1, go to loop_end
    mul t6, t0, t3          # the actual index of array
    add t4, a0, t6          # the address of a0[i]
    lw t5, 0(t4)            # the value of a0[i]
    bge t1, t5, loop_goback # if t1 >= t5, go to loop_goback
    addi t1, t5, 0          # t1 = t5
    addi t2, t0, 0          # t2 = t0

loop_goback:
    addi t0, t0, 1
    j loop_continue


loop_end:
    # Epilogue
    addi a0, t2, 0
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

exit_7:
    addi a0, x0, 17
    addi a1, x0, 7
    ecall