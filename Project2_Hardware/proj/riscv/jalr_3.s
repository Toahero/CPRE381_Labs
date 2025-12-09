.data 
result_target: .word 0 
result_ra: .word 0 
.text 
.globl main

main:
    la   x5, result_target
    la   x6, result_ra
    la   x7, target

    jalr ra, 0(x7)         # jump to target; save return address in ra
    addi t0, zero, -1

target:
    sw   t0, 0(x5)
    addi x1,x7, 0x0C
    jr   ra

after_return:
    sw   ra, 0(x6)
    wfi

