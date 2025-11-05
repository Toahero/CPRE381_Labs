###############################################################
# RISC-V Merge Sort (RV32I compliant)
# Uses only t0–t6, s0–s2, a0–a7, ra, sp
# Sorts array in place
###############################################################

.data
array:  .word 1, 17, 7, -44, -5
size:   .word 5

space:  .asciz " "
head:   .asciz "The sorted numbers are:\n"
newline:.asciz "\n"

.text
.globl main

###############################################################
# main
###############################################################
main:
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  mergeSort

    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    #jal  print

    j done

done:
    wfi




###############################################################
# mergeSort(a0=arrayPtr, a1=size)
###############################################################
mergeSort:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw a0, 4(sp)
    sw a1, 0(sp)

    li t0, 1
    ble a1, t0, ms_done     # base case if size <= 1

    # midpoint = size / 2
    srai s0, a1, 1          # s0 = mid

    # --- left half ---
    mv a0, a0               # left pointer unchanged
    mv a1, s0               # left size = mid
    jal mergeSort

    # --- right half ---
    lw a0, 4(sp)            # base addr
    lw a1, 0(sp)            # total size
    mv s1, a0               # save base pointer
    srai t1, a1, 1
    slli t2, t1, 2
    add a0, a0, t2          # right start = base + mid*4
    sub a1, a1, t1          # right size = size - mid
    jal mergeSort

    # --- merge halves ---
    mv a0, s1               # array base
    lw a1, 0(sp)            # full size
    jal merge

ms_done:
    lw ra, 16(sp)
    lw s0, 12(sp)
    lw s1, 8(sp)
    addi sp, sp, 20
    ret


###############################################################
# merge(a0=arrayPtr, a1=size)
# Uses temporary space on stack = size*4 bytes
###############################################################
merge:
    srai s0, a1, 1              # mid = size/2
    slli t0, a1, 2              # bytes = size * 4
    sub sp, sp, t0              # allocate buffer
    mv s1, sp                   # s1 = temp start

    # setup pointers
    mv t1, a0                   # leftPtr = array
    slli t2, s0, 2
    add t3, a0, t2              # rightPtr = array + mid*4
    mv t4, s1                   # tempPtr = temp buffer

    # compute bounds once
    slli t5, s0, 2
    add t5, a0, t5              # leftEnd
    slli t6, a1, 2
    add t6, a0, t6              # arrEnd

merge_loop:
    # check if left exhausted
    beq t1, t5, copy_right

    # check if right exhausted
    beq t3, t6, copy_left

    lw a2, 0(t1)
    lw a3, 0(t3)
    ble a2, a3, take_left
    j take_right

take_left:
    sw a2, 0(t4)
    addi t1, t1, 4
    addi t4, t4, 4
    j merge_loop

take_right:
    sw a3, 0(t4)
    addi t3, t3, 4
    addi t4, t4, 4
    j merge_loop

copy_left:
    beq t1, t5, copy_back
    lw a2, 0(t1)
    sw a2, 0(t4)
    addi t1, t1, 4
    addi t4, t4, 4
    j copy_left

copy_right:
    beq t3, t6, copy_back
    lw a3, 0(t3)
    sw a3, 0(t4)
    addi t3, t3, 4
    addi t4, t4, 4
    j copy_right

copy_back:
    mv t4, s1                   # tempPtr = temp start
    mv t1, a0                   # arrPtr = array start
    mv t0, a1                   # counter = size
copy_back_loop:
    beqz t0, merge_done
    lw a2, 0(t4)
    sw a2, 0(t1)
    addi t4, t4, 4
    addi t1, t1, 4
    addi t0, t0, -1
    j copy_back_loop

merge_done:
    slli t0, a1, 2
    add sp, sp, t0              # free temp buffer
    ret
