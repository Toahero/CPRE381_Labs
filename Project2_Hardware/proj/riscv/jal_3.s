.data
.text
.globl main
main:
    # Check if the jump and link put correct value in the return register
    addi t0, t0,0
    la t1, Target
    jal t0, Target # the function we want to test
    # nop
    addi t0, t1, 5 # t0 = t1 + 5
    
Target: 
    beq t1,t0, End
    addi t3,t3,8

End:
    wfi