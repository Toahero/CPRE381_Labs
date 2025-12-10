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
    #li   sp, 0x7FFFEFEC
    lui x2, 0x0007ffff
    nop
    nop
    nop
    addi x2, x2, 0xFFFFFFec
    
    lasw   a0, array
    lasw   a1, size
    
    nop
    nop
    nop
    lw   a1, 0(a1)
    nop
    nop
    nop
    jal  x1, mergeSort
    nop

    lasw   a0, array
    
    lasw   a1, size
    
    nop
    nop
    nop
    lw   a1, 0(a1)
    nop
    nop
    nop
    jal  x1, print
	nop
	nop
	nop
    j instDone
	nop

###############################################################
# print(a0=arrayAddr, a1=size)
###############################################################
print:
    mv t0, a0              # array pointer
    mv t1, a1              # counter

nop
nop
    lasw   a0, head
    li   a7, 4
    ecall
    nop
    nop
    nop

print_loop:
nop
nop
nop
    beqz t1, print_end
    nop
    lw   a0, 0(t0)
    li   a7, 1
    ecall
    nop
    nop
    nop

    lasw   a0, space
    li   a7, 4
    ecall
    nop
    nop
    nop

    addi t0, t0, 4
    addi t1, t1, -1
    nop
    nop
    nop 
    j print_loop
    nop

print_end:
nop
nop
nop
    jalr x0, 0(ra)
    nop


###############################################################
# mergeSort(a0=arrayPtr, a1=size)
###############################################################
mergeSort:
    addi sp, sp, -16
    
    nop
    nop
    nop
    sw ra, 12(sp)
    sw a0, 8(sp)
    sw a1, 4(sp)

nop
nop
    li t0, 1
    nop
    nop
    nop
    ble a1, t0, ms_done     # base case if size <= 1

    # midpoint = size / 2
    nop
    nop
    nop
    srai t1, a1, 1

    # --- left half ---
    mv a0, a0
    
    nop
    nop
    mv a1, t1
    nop
    nop
    nop
    jal x1, mergeSort
    nop

    # --- right half ---
    lw a0, 8(sp)
    lw a1, 4(sp)
    
    nop
    nop
    nop
    srai t2, a1, 1          # mid again
    
    nop
    nop
    nop
    slli t3, t2, 2
    
    nop
    nop
    nop
    add a0, a0, t3          # a0 = right start
    sub a1, a1, t2          # a1 = right size
    nop
    nop
    nop
    jal x1, mergeSort
    nop

    # --- merge halves ---
    lw a0, 8(sp)
    lw a1, 4(sp)
    nop
    nop
    nop
    jal x1, merge
    nop

ms_done:
    lw ra, 12(sp)
    addi sp, sp, 16
    
    nop
    nop
    nop
    jalr x0, 0(ra)
    nop


###############################################################
# merge(a0=arrayPtr, a1=size)
###############################################################
merge:
    addi sp, sp, -512       # temp buffer
    
    nop
    nop
    nop
    mv t6, sp               # t6 = temp start

    srai t0, a1, 1          # mid = size/2
    
    nop
    nop
    nop
    slli t1, t0, 2
    
    nop
    nop
    nop
    add t2, a0, t1          # rightStart = a0 + mid*4

    mv t3, a0               # leftPtr
    nop
    nop
    mv t4, t2               # rightPtr
    mv t5, t6               # tempPtr

merge_loop:
    # check if left exhausted
    slli t1, t0, 2
    
    nop
    nop
    nop
    add t2, a0, t1          # leftEnd
    
    nop
    nop
    nop
    beq t3, t2, copy_right
    nop

    # check if right exhausted
    slli t1, a1, 2
    
    nop
    nop
    nop
    add t2, a0, t1          # arrEnd
    
    nop
    nop
    nop
    beq t4, t2, copy_left
    nop

    lw a2, 0(t3)
    lw a3, 0(t4)
    
    nop
    nop
    nop
    ble a2, a3, take_left
    nop
    nop
    nop
    j take_right
    nop

take_left:
    sw a2, 0(t5)
    addi t3, t3, 4
    nop
    nop
    addi t5, t5, 4
    
    nop
    nop
    nop
    j merge_loop
    nop

take_right:
    sw a3, 0(t5)
    addi t4, t4, 4
    
    nop
    nop
    addi t5, t5, 4
    nop
    nop
    nop
    j merge_loop
    nop

copy_left:
    slli t1, a1, 2
    
    nop
    nop
    nop
    add t2, a0, t1
    
copy_left_loop:
nop
nop
nop
    beq t3, t2, copy_back
    nop
    lw a2, 0(t3)
    
    nop
    nop
    nop
    sw a2, 0(t5)
    addi t3, t3, 4
    
    nop
    nop
    addi t5, t5, 4
    nop
    nop
    nop
    j copy_left_loop
    nop

copy_right:
    slli t1, a1, 2
    
    nop
    nop
    nop
    add t2, a0, t1
    
copy_right_loop:
nop
nop
nop
    beq t4, t2, copy_back
    nop
    lw a3, 0(t4)
    
    nop
    nop
    nop
    sw a3, 0(t5)
    addi t4, t4, 4
    addi t5, t5, 4
    nop
    nop
    nop
    j copy_right_loop
    nop

copy_back:
    mv t5, t6
    mv t3, a0
    mv t1, a1
copy_back_loop:
    nop
    nop
    nop
    beqz t1, merge_done
    nop
    lw a2, 0(t5)
    nop
    nop
    nop
    sw a2, 0(t3)
    addi t3, t3, 4
    addi t5, t5, 4
    addi t1, t1, -1
    nop
    nop
    nop
    j copy_back_loop
    nop
    
merge_done:
    addi sp, sp, 512
    nop
    nop
    nop
    jalr x0, 0(ra)
    nop

instDone:
	
    wfi
    nop
    nop
    nop