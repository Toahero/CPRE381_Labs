.data
.text
.global main
main:

    # R Type Instructions

    addi t0, zero, 0 # t0 = zero + 0
    addi t1, zero, 1 # t1 = zero + 0
    addi t2, zero, 2 # t2 = zero + 0
    nop
    nop
    add t3, zero, t1 # t3 = t0 + t2
    sub t1, t1, t2
    nop
    nop
    nop
    xor t4, t1, t3
    or  t1, t1, t3
    addi t4, zero, 3
    nop
    nop
    nop
    and t1, t4, t1
    nop
    nop
    nop
    nop
    sll t0, t1, t2
    srl t1, t2, t4
    sra t2, t3, t4
    nop
    nop
    slt t3, t0, t1
    nop
    nop
    nop
    nop
    sltu t4, t3, zero

    # I Type Instructions
    addi t0, zero, 0
    addi t1, zero, 1
    addi t2, zero, 2
    addi t3, zero, 3
    addi t4, zero, 4

    wfi
