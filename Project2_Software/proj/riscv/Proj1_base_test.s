.data
	data:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9

.text

main:
	# ADDI
	addi	t0,	zero,	 1
	addi	a0,	zero,	 5
	addi	a1,	zero,	-5

### REGULAR ###
	
	# ADD
	add	a2,	a0,	 a1
	
	# SUB
	sub	a2,	a0,	a1
	
	# XOR
	xor	a2,	a0,	a1
	
	# OR
	or	a2,	a0,	a1
	
	# AND
	and	a2,	a0,	a1
	
	# SLL
	sll	a2,	a0,	a0
	
	# SRL
	srl	a2,	a0,	t0
	
	# SRA
	sra	a2,	a1,	t0
	
	# SLT
	slt	a2,	a0,	a1
	
	# SLTU
	sltu	a2,	a1,	t0

### IMMEDIATE ###
	# XORI
	xori	a2,	a0,	 15
	
	# ORI
	ori	a2,	a0,	 16
	
	# ANDI
	andi	a2,	a0,	 17
	
	# SLLI
	slli	a2,	a0,	 3
	
	# SRLI
	srli	a2,	a0,	 2
	
	# SRAI
	srai	a2,	a1,	 2
	
	# SLTI
	slti	a2,	a0,	 3
	slti	a2,	a0,	 6
	slti	a2,	a0,	-6
	
	# SLTIU
	sltiu	a2,	a0,	 3
	sltiu	a2,	a0,	 6
	sltiu	a2,	a0,	-6	
	wfi