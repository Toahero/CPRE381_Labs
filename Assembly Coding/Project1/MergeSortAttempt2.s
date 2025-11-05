.data
array: .word 1, 17, 7, -44, -5 #array to be sorted
size: .word  5             # size of "array" (agrees with array declaration)
.text


main:
la	a0, array
la	a1, size
lw	a1, 0(a1)

call mergeSort


la   a0, array        # first argument for print (array)
la	a1, size     #second argument for print (size)
lw	a1, 0(a1)
jal  print            # call print routine.
j die 


mergeSort:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        sw      a1,-24(s0)
        lw      a5,-24(s0)
        addi    a5,a5,-1
        mv      a2,a5
        li      a1,0
        lw      a0,-20(s0)
        call    mergeSortRec
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra

mergeArrays:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        addi    s0,sp,64
        sw      a0,-52(s0)
        sw      a1,-56(s0)
        sw      a2,-60(s0)
        sw      a3,-64(s0)
        mv      a3,sp
        mv      a1,a3
        lw      a2,-64(s0)
        lw      a3,-56(s0)
        sub     a3,a2,a3
        addi    a3,a3,1
        sw      a3,-32(s0)
        sw      zero,-20(s0)
        lw      a3,-56(s0)
        sw      a3,-24(s0)
        lw      a3,-60(s0)
        addi    a3,a3,1
        sw      a3,-28(s0)
        lw      a3,-32(s0)
        addi    a2,a3,-1
        sw      a2,-36(s0)
        mv      a2,a3
        mv      t3,a2
        li      t4,0
        srli    a2,t3,27
        slli    a7,t4,5
        add     a7,a2,a7
        slli    a6,t3,5
        mv      a2,a3
        mv      t1,a2
        li      t2,0
        srli    a2,t1,27
        slli    a5,t2,5
        add     a5,a2,a5
        slli    a4,t1,5
        mv      a5,a3
        slli    a5,a5,2
        addi    a5,a5,15
        srli    a5,a5,4
        slli    a5,a5,4
        sub     sp,sp,a5
        mv      a5,sp
        addi    a5,a5,3
        srli    a5,a5,2
        slli    a5,a5,2
        sw      a5,-40(s0)
        j       .L2
.L6:
        lw      a5,-24(s0)
        slli    a5,a5,2
        lw      a4,-52(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        lw      a5,-28(s0)
        slli    a5,a5,2
        lw      a3,-52(s0)
        add     a5,a3,a5
        lw      a5,0(a5)
        sub     a5,a4,a5
        bge     a5,zero,.L3
        lw      a4,-40(s0)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a4,a5
        lw      a4,-56(s0)
        sw      a4,0(a5)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
        j       .L4
.L3:
        lw      a5,-28(s0)
        slli    a5,a5,2
        lw      a4,-52(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        lw      a3,-40(s0)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L4:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L2:
        lw      a4,-24(s0)
        lw      a5,-60(s0)
        bgt     a4,a5,.L7
        lw      a4,-28(s0)
        lw      a5,-64(s0)
        ble     a4,a5,.L6
        j       .L7
.L8:
        lw      a5,-24(s0)
        slli    a5,a5,2
        lw      a4,-52(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        lw      a3,-40(s0)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L7:
        lw      a4,-24(s0)
        lw      a5,-60(s0)
        ble     a4,a5,.L8
        j       .L9
.L10:
        lw      a5,-28(s0)
        slli    a5,a5,2
        lw      a4,-52(s0)
        add     a5,a4,a5
        lw      a4,0(a5)
        lw      a3,-40(s0)
        lw      a5,-20(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L9:
        lw      a4,-28(s0)
        lw      a5,-64(s0)
        ble     a4,a5,.L10
        sw      zero,-20(s0)
        j       .L11
.L12:
        lw      a4,-56(s0)
        lw      a5,-20(s0)
        add     a5,a4,a5
        slli    a5,a5,2
        lw      a4,-52(s0)
        add     a5,a4,a5
        lw      a3,-40(s0)
        lw      a4,-20(s0)
        slli    a4,a4,2
        add     a4,a3,a4
        lw      a4,0(a4)
        sw      a4,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L11:
        lw      a4,-20(s0)
        lw      a5,-32(s0)
        blt     a4,a5,.L12
        mv      sp,a1
        nop
        addi    sp,s0,-64
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
mergeSortRec:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        sw      a2,-44(s0)
        sw      zero,-20(s0)
        lw      a4,-40(s0)
        lw      a5,-44(s0)
        bge     a4,a5,.L15
        lw      a4,-40(s0)
        lw      a5,-44(s0)
        add     a5,a4,a5
        srai    a5,a5,1
        sw      a5,-20(s0)
        lw      a2,-20(s0)
        lw      a1,-40(s0)
        lw      a0,-36(s0)
        call    mergeSortRec
        lw      a5,-20(s0)
        addi    a5,a5,1
        lw      a2,-44(s0)
        mv      a1,a5
        lw      a0,-36(s0)
        call    mergeSortRec
        lw      a3,-44(s0)
        lw      a2,-20(s0)
        lw      a1,-40(s0)
        lw      a0,-36(s0)
        call    mergeArrays
.L15:
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
        
die:
wfi

###############################################################
# Subroutine to print the numbers on one line.
      .data
space:.asciz  " "          # space to insert between numbers
head: .asciz  "The sorted numbers are:\n"
      .text
print:add  t0, zero, a0  # starting address of array of data to be printed
      add  t1, zero, a1  # initialize loop counter to array size
      la   a0, head        # load address of the print heading string
      ori  a7, zero , 4           # specify Print String service
      ecall               # print the heading string
      
out:  lw   a0, 0(t0)      # load the integer to be printed (the current Fib. number)
      ori  a7, zero , 1           # specify Print Integer service
      ecall               # print fibonacci number
      
      la   a0, space       # load address of spacer for syscall
      ori  a7, zero , 4           # specify Print String service
      ecall               # print the spacer string
      
      addi t0, t0, 4      # increment address of data to be printed
      addi t1, t1, -1     # decrement loop counter
      bne t1, zero , out         # repeat while not finished
      
      jr   ra              # return from subroutine
      
# End of subroutine to print the numbers on one line
###############################################################