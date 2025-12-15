.data
	data:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9

.text

main:
	# ADDI
	addi	t0,	zero,	 1
	addi	a0,	zero,	 5
	addi	a1,	zero,	-5

### REGULAR ###
	
	
	nop
	nop
	nop
	# ADD
	add	a2,	a0,	 a1
	
	
	nop
	nop
	nop
	# SUB
	sub	a2,	a2,	a1
	
	# XOR
	xor	a3,	a0,	a1
	
	
	nop
	nop
	# OR
	or	a2,	a2,	a1
	
	nop
	nop
	nop
	# AND
	and	a1,	a0,	a1
	
	nop
	# SLL
	sll	a2,	a0,	a3
	
	# SRL
	srl	a2,	a0,	t0
	
	# SRA
	sra	a2,	a1,	t0
	
	nop
	nop
	nop
	# SLT
	slt	a2,	a0,	a2
	
	# SLTU
	sltu	a2,	a1,	t0

### IMMEDIATE ###
	# XORI
	nop
	nop
	nop
	xori	t3,	t0,	 15
	
	# ORI
	ori	t2,	a1,	 16
	
	# ANDI
	andi	t0,	a0,	 17
	
	nop
	# SLLI
	slli	t2,	t3,	 3
	
	# SRLI
	srli	a2,	t3,	 2
	
	nop
	nop
	# SRAI
	srai	a2,	t2,	 2
	
	# SLTI
	slti	a2,	t3,	 3
	
	# SLTIU
	sltiu	a0,	t0,	 3
	
	ori s0, x0, 0x123
	nop
	nop
	nop
	j skip
	nop
	li s0, 0xffffffff
skip:
	ori s1, x0, 0x123
	
	nop
	nop
	nop
	beq s0, s1, skip2
	
	nop
	nop
	nop
	li s0, 0xffffffff
	nop
skip2:

	jal fun
	nop
	ori s3, x0, 0x123	
	beq s0, x0, exit
	nop

	ori s4, x0, 0x123
	nop
	j exit
	nop
fun:
	ori s2, x0, 0x123
	nop

	jr ra
	nop
exit:
	wfi

