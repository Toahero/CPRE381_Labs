.data
.text
.globl main

main:
    addi x4, x0, 0
    addi x5, x0, 2

loop:
    addi x4, x4, 1
    bne x4, x5, loop

done:
    wfi
