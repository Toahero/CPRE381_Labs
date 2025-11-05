.text
.globl main

main:
    li      t0, 0          # t0 = counter
    li      t1, 5          # t1 = limit
    li      t2, 1          # t2 = increment

    # Call add_loop using JAL (function call)
    jal     ra, add_loop

    # When returned, jump to end
    jal     zero, end


# -----------------------------------------
# add_loop: increments t0 until t0 == t1
# Demonstrates arithmetic and branches
# -----------------------------------------
add_loop:
    add     t0, t0, t2     # t0 += t2
    blt     t0, t1, add_loop  # if t0 < t1, repeat
    beq     t0, t1, after_loop # if equal, continue
    jal     zero, end         # safety (shouldn’t hit)
    
after_loop:
    # Jump to helper using JALR (indirect jump)
    la      t3, helper
    jalr    ra, 0(t3)

    jr      ra                # return to caller


# -----------------------------------------
# helper: performs simple arithmetic and branching
# -----------------------------------------
helper:
    li      t4, 10
    sub     t5, t4, t0       # t5 = 10 - t0

    bge     t5, zero, not_negative
    addi    t5, t5, -1       # if negative, adjust by -1
    jr      ra

not_negative:
    addi    t6, t5, 5        # t6 = t5 + 5 (simple math)
    add     t6, t6, t1       # t6 = t6 + t1
    jr      ra


# -----------------------------------------
# end: stop program
# -----------------------------------------
end:
    wfi                      # wait for interrupt (halts execution)
