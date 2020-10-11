.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    li t5, 1
    blt a2, t5, exit_5
    blt a3, t5, exit_7
    blt a4, t5, exit_7

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

loop_start:
    li t0, 0    # t0 is the i in the loop
    li t4, 0    # t4 is the result to return

loop_continue:
    bge t0, a2, loop_end
    mul t1, t0, a3  # the offset of v0
    mul t2, t0, a4  # the offset of v1
    add t1, t1, a0  # the address of v0[i]
    add t2, t2, a1  # the address of v1[i]
    lw t1, 0(t1)    # the value of v0[i]
    lw t2, 0(t2)    # the value of v1[i]
    mul t3, t1, t2  # t3 = t1 * t2
    add t4, t3, t4  # result = result + t3
    addi t0, t0, 1  # t0 = t0 + 1
    j loop_continue

loop_end:
    mv a0, t4

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret

exit_5:
    li a0, 17
    li a1, 5
    ecall

exit_7:
    li a0, 17
    li a1, 6
    ecall