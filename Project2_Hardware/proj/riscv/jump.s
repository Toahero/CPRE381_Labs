.data
.text
.globl main

main:
    addi t0, zero, 0
    addi t1, zero, 0
    jal ra, step1
    # nop
    # This shouldn't run
    addi t0, t0, 1
    
step1:
    addi t1, t1, 1
    wfi
