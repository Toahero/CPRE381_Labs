###############################################################
# RISC-V Merge Sort (RV32I compliant)
# Sorts an array of words in place
###############################################################

.data
array:  .word 1, 17, 7, -44, -5
size:   .word 5

space:   .asciz " "
head:    .asciz "The sorted numbers are:\n"
newline: .asciz "\n"

.text
.globl main

###############################################################
# main
###############################################################
main:
    # load array and size
    la a0, array
    lw a1, size
    jal mergeSort

done:
    wfi  # halt (for now)
    ret


###############################################################
# mergeSort(a0=arrayPtr, a1=size)
###############################################################
mergeSort:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    li t0, 1
    ble a1, t0, ms_done     # base case: size <= 1

    # midpoint = size / 2
    srai s0, a1, 1          # s0 = mid
    mv s1, a0               # save base pointer

    # --- sort left half ---
    mv a0, s1
    mv a1, s0
    jal mergeSort

    # --- sort right half ---
    mv a0, s1
    sub a1, a1, s0          # right size = size - mid
    add a0, a0, s0, slli 2  # right pointer = base + mid*4
    jal mergeSort

    # --- merge halves ---
    mv a0, s1               # array base
    lw a1, size             # full size
    jal merge

ms_done:
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    ret


###############################################################
# merge(a0=arrayPtr, a1=size)
# Merge two halves in place using stack temporary buffer
###############################################################
merge:
    # compute mid and byte size
    srai s0, a1, 1          # mid = size / 2
    slli t0, a1, 2          # bytes = size*4
    sub sp, sp, t0           # allocate temp buffer
    mv s1, sp                # temp buffer pointer

    # set pointers
    mv t1, a0                # leftPtr = array
    slli t2, s0, 2
    add t3, a0, t2           # rightPtr = array + mid*4
    mv t4, s1                # tempPtr = buffer

    # compute ends
    add t5, t3, t2           # leftEnd = leftPtr + mid*4
    add t6, a0, t0           # arrEnd = array + size*4

merge_loop:
    # left exhausted?
    beq t1, t3, copy_right

    # right exhausted?
    beq t3, t6, copy_left

    lw t7, 0(t1)             # left val
    lw t8, 0(t3)             # right val
    ble t7, t8, take_left
    j take_right

take_left:
    sw t7, 0(t4)
    addi t1, t1, 4
    addi t4, t4, 4
    j merge_loop

take_right:
    sw t8, 0(t4)
    addi t3, t3, 4
    addi t4, t4, 4
    j merge_loop

copy_left:
    beq t1, t3, copy_back
    lw t7, 0(t1)
    sw t7, 0(t4)
    addi t1, t1, 4
    addi t4, t4, 4
    j copy_left

copy_right:
    beq t3, t6, copy_back
    lw t8, 0(t3)
    sw t8, 0(t4)
    addi t3, t3, 4
    addi t4, t4, 4
    j copy_right

copy_back:
    mv t4, s1               # reset tempPtr
    mv t1, a0               # reset arrayPtr
    slli t0, a1, 2          # size in bytes
copy_back_loop:
    beqz t0, merge_done
    lw t7, 0(t4)
    sw t7, 0(t1)
    addi t4, t4, 4
    addi t1, t1, 4
    addi t0, t0, -4
    j copy_back_loop

merge_done:
    add sp, sp, t0           # free buffer
    ret
