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

    li   sp, 0x7FFFEFEC

	
    la   a0, array
	
    la   a1, size
	nop
	nop
	nop
	nop
	
    lw   a1, 0(a1)
	nop
	nop
	nop
	nop
	
    jal  x1, mergeSort
	nop
	nop
	nop
	nop
	
    
    la   a0, array
	
    la   a1, size
	nop
	nop
	nop
	nop
	
    lw   a1, 0(a1)
	
    jal  x1, print
	nop
	nop
	nop
	nop
	

    j instDone
	nop
	nop
	nop
	nop
	


###############################################################
# print(a0=arrayAddr, a1=size)
###############################################################
print:
    mv t0, a0              # array pointer
	
    mv t1, a1              # counter
	

    la   a0, head
	nop
	nop
	nop

	
    li   a7, 4
	nop
	nop
	nop
	nop
	
    ecall
    	nop
    	nop
    	nop
    	nop

print_loop:
    beqz t1, print_end
	nop
	nop
	nop
	nop
	
    lw   a0, 0(t0)
	
    li   a7, 1
	nop
	nop
	nop
	nop
	
    ecall
    nop
    nop
    nop
    nop

    la   a0, space
	nop
	nop
	nop
	
    li   a7, 4
	nop
	nop
	nop
	nop
	
    ecall

    addi t0, t0, 4
	nop
	nop
	
    addi t1, t1, -1
	nop
	nop
	nop
	
    j print_loop
	nop
	nop
	nop
	nop
	

print_end:
    jalr x0, 0(ra)
	nop
	nop
	nop
	nop
	


###############################################################
# mergeSort(a0=arrayPtr, a1=size)
###############################################################
mergeSort:
    addi sp, sp, -16
	nop
	nop
	nop
	nop
	
    sw ra, 12(sp)

	
    sw a0, 8(sp)
	
    sw a1, 4(sp)
	

    li t0, 1
	nop
	nop
	nop
	nop
	
    ble a1, t0, ms_done     # base case if size <= 1
	nop
	nop
	nop
	nop
	

    # midpoint = size / 2
    srai t1, a1, 1
	nop
	nop
	nop
	

    # --- left half ---
    mv a0, a0
	
    mv a1, t1
	nop
	nop
	nop
	nop
	
    jal x1, mergeSort
	nop
	nop
	nop
	nop
	

    # --- right half ---
    lw a0, 8(sp)
	
    lw a1, 4(sp)
	nop
	nop
	nop
	nop
	
    srai t2, a1, 1          # mid again
	nop
	nop
	nop
	nop
	
    slli t3, t2, 2
	nop
	nop
	nop
	nop
	
    add a0, a0, t3          # a0 = right start
	
    sub a1, a1, t2          # a1 = right size
	
    jal x1, mergeSort
	nop
	nop
	nop
	nop
	

    # --- merge halves ---
    lw a0, 8(sp)
	nop
	nop
	nop
	nop
	
    lw a1, 4(sp)
	nop
	nop
	nop
	nop
	
    jal x1, merge
	nop
	nop
	nop
	nop
	

ms_done:
    lw ra, 12(sp)
	nop
	nop
	nop
	nop
	
    addi sp, sp, 16
	nop
	nop
	nop
	nop
	
    jalr x0, 0(ra)
	nop
	nop
	nop
	nop
	


###############################################################
# merge(a0=arrayPtr, a1=size)
###############################################################
merge:
    addi sp, sp, -512       # temp buffer
	
    mv t6, sp               # t6 = temp start
	

    srai t0, a1, 1          # mid = size/2
	
    slli t1, t0, 2
	nop
	nop
	nop
	nop
	
    add t2, a0, t1          # rightStart = a0 + mid*4
	nop
	nop
	nop
	nop
	

    mv t3, a0               # leftPtr
	
    mv t4, t2               # rightPtr
	
    mv t5, t6               # tempPtr
	nop
	nop
	nop
	nop
	

merge_loop:
    # check if left exhausted
    slli t1, t0, 2
	nop
	nop
	nop
	nop
	
    add t2, a0, t1          # leftEnd
	nop
	nop
	nop
	nop
	
    beq t3, t2, copy_right
	nop
	nop
	nop
	nop
	

    # check if right exhausted
    slli t1, a1, 2
	nop
	nop
	nop
	nop
	
    add t2, a0, t1          # arrEnd
	nop
	nop
	nop
	nop
	
    beq t4, t2, copy_left
	nop
	nop
	nop
	nop
	

    lw a2, 0(t3)
	
    lw a3, 0(t4)
	nop
	nop
	nop
	nop
	
    ble a2, a3, take_left
	nop
	nop
	nop
	
    j take_right
	nop
	nop
	nop
	nop
	

take_left:
    sw a2, 0(t5)
	
    addi t3, t3, 4
	
    addi t5, t5, 4
	
    j merge_loop
	nop
	nop
	nop
	nop
	

take_right:
    sw a3, 0(t5)

	
    addi t4, t4, 4
	
    addi t5, t5, 4
	
    j merge_loop
	nop
	nop
	nop
	nop
	

copy_left:
    slli t1, a1, 2
	nop
	nop
	nop
	nop
	
    add t2, a0, t1
	nop
	nop
	nop
	nop
	
copy_left_loop:
    beq t3, t2, copy_back
	nop
	nop
	nop
	nop
	
    lw a2, 0(t3)
	nop
	nop
	nop
	nop
	
    sw a2, 0(t5)
	
    addi t3, t3, 4
	nop
	nop
	nop
	nop
	
    addi t5, t5, 4
	
    j copy_left_loop
	nop
	nop
	nop
	nop
	

copy_right:
    slli t1, a1, 2
	nop
	nop
	nop
	nop
	
    add t2, a0, t1
	nop
	nop
	nop
	nop
	
copy_right_loop:
    beq t4, t2, copy_back
	nop
	nop
	nop
	nop
	
    lw a3, 0(t4)
	nop
	nop
	nop
	nop
	
    sw a3, 0(t5)
    nop
    nop
	
    addi t4, t4, 4
	
    addi t5, t5, 4
	
    j copy_right_loop
	nop
	nop
	nop
	nop
	

copy_back:
    mv t5, t6
	
    mv t3, a0
	
    mv t1, a1
	nop
	nop
	nop
	nop
	
copy_back_loop:
    beqz t1, merge_done
	nop
	nop
	nop
	nop
	
    lw a2, 0(t5)
	nop
	nop
	nop
	nop
	
    sw a2, 0(t3)
	nop
	nop
	nop
	
    addi t3, t3, 4

	
    addi t5, t5, 4

	
    addi t1, t1, -1
	
    j copy_back_loop
	nop
	nop
	nop
	nop
	

merge_done:
    addi sp, sp, 512

	
    jalr x0, 0(ra)
	nop
	nop
	nop
	nop
	

instDone:
    wfi
