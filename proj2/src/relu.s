.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    addi t0, x0, 1      # t0 = 1
    blt a1, t0, exit_8    # if a1 < 1, go to exit

loop_start:
    addi t0, x0, 0      # t0 = 0, t0 is the index of the array
    addi t1, x0, 4      # t1 = 4, meaning 4 bytes per 1 element

loop_continue:   
    bge t0, a1, loop_end    # if t0 >= size, go to loop_end
    mul t2, t0, t1      # t2: the actual index of array
    add t3, t2, a0      # t3: the address of array[i]
    lw  t4, 0(t3)       # t4: the value of array[i]
    blt t4, x0, change_arr

loop_goback:
    addi t0, t0, 1
    j loop_continue
         
change_arr:
    sw x0, 0(t3)
    j loop_goback


loop_end:
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    
	ret

exit_8:
    addi a0, x0, 17
    addi a1, x0, 8
    ecall