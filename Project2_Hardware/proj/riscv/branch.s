.data
.text
.globl main
main:
    # Test 1: Equal small positive values
    # Tests basic beq functionality with common case values.
    addi x1, x0, 5
    addi x2, x0, 5
    bne x1, x2, pass1
    addi x3, x0, -1
    
pass1:
    # Test 2: Unequal values (don't branch)
    # Tests beq correctly falls through when values differ.
    addi x4, x0, 3
    addi x5, x0, 9
    
    end:
        wfi