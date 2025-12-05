    .data
    .text
    .globl main
main:
    li s0, 15 # s0 = 15
    li s1, 16 # s1 = 16
    add s0, s0, s1 # s0 = s0 + s1

    wfi