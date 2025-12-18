.text
.global main
main:
    lui x2, 0x00010011
	addi a1, zero, 1
    nop
    nop
    nop
	addi a2, a1, 2
    nop
    nop
    nop
	addi a3, a2, 3
	j Subroutine
    nop

Subroutine:
	addi t2, zero, 4
	addi t3, zero, 5
	addi t4, zero, 6
	addi t5, zero, 7
	j Destination
    nop

Destination:
	# A nop is needed, even when we come from Subroutine.
	# nop
	addi a3, a3, 2
    wfi