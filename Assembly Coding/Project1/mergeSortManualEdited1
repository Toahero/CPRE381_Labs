###############################################################
# RISC-V Merge Sort (RV32I compliant — t0–t6 only)
###############################################################

.data
array:  .word 1, 17, 7, -44, -5
size:   .word 5

space:  .asciz " "
head:   .asciz "The sorted numbers are:\n"

.text
.globl main

###############################################################
# main
###############################################################
main:
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    call mergeSort

    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  print

    j instDone



###############################################################
# print(a0=arrayAddr, a1=size)
###############################################################
print:
    mv t0, a0              # array pointer
    mv t1, a1              # counter

    la   a0, head
    li   a7, 4
    ecall

print_loop:
    beqz t1, print_end
    lw   a0, 0(t0)
    li   a7, 1
    ecall

    la   a0, space
    li   a7, 4
    ecall

    addi t0, t0, 4
    addi t1, t1, -1
    j print_loop

print_end:
    jr ra

###############################################################
# mergeSort(a0=arrayPtr, a1=size)
###############################################################
mergeSort:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a0, 8(sp)
    sw a1, 4(sp)

    li t0, 1
    ble a1, t0, ms_done     # base case if size <= 1

    # midpoint = size / 2
    srai t1, a1, 1

    # --- left half ---
    mv a0, a0
    mv a1, t1
    call mergeSort

    # --- right half ---
    lw a0, 8(sp)
    lw a1, 4(sp)
    srai t2, a1, 1          # mid again
    slli t3, t2, 2
    add a0, a0, t3          # a0 = right start
    sub a1, a1, t2          # a1 = right size
    call mergeSort

    # --- merge halves ---
    lw a0, 8(sp)
    lw a1, 4(sp)
    call merge

ms_done:
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

###############################################################
# merge(a0=arrayPtr, a1=size)
###############################################################
merge:
    addi sp, sp, -512       # temp buffer
    mv t6, sp               # t6 = temp start

    srai t0, a1, 1          # mid = size/2
    slli t1, t0, 2
    add t2, a0, t1          # rightStart = a0 + mid*4

    mv t3, a0               # leftPtr
    mv t4, t2               # rightPtr
    mv t5, t6               # tempPtr

merge_loop:
    # check if left exhausted
    slli t1, t0, 2
    add t2, a0, t1          # leftEnd
    beq t3, t2, copy_right

    # check if right exhausted
    slli t1, a1, 2
    add t2, a0, t1          # arrEnd
    beq t4, t2, copy_left

    lw a2, 0(t3)
    lw a3, 0(t4)
    ble a2, a3, take_left
    j take_right

take_left:
    sw a2, 0(t5)
    addi t3, t3, 4
    addi t5, t5, 4
    j merge_loop

take_right:
    sw a3, 0(t5)
    addi t4, t4, 4
    addi t5, t5, 4
    j merge_loop

copy_left:
    slli t1, a1, 2
    add t2, a0, t1
copy_left_loop:
    beq t3, t2, copy_back
    lw a2, 0(t3)
    sw a2, 0(t5)
    addi t3, t3, 4
    addi t5, t5, 4
    j copy_left_loop

copy_right:
    slli t1, a1, 2
    add t2, a0, t1
copy_right_loop:
    beq t4, t2, copy_back
    lw a3, 0(t4)
    sw a3, 0(t5)
    addi t4, t4, 4
    addi t5, t5, 4
    j copy_right_loop

copy_back:
    mv t5, t6
    mv t3, a0
    mv t1, a1
copy_back_loop:
    beqz t1, merge_done
    lw a2, 0(t5)
    sw a2, 0(t3)
    addi t3, t3, 4
    addi t5, t5, 4
    addi t1, t1, -1
    j copy_back_loop

merge_done:
    addi sp, sp, 512
    ret

instDone:
    wfi