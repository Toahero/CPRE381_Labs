.text
main:
    # Needed to pass :(
    li		sp,		0x7FFFEFFC

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

    li      s0 ,    1
    li      s1 ,    2
    li      s2 ,    3
    li      s3 ,    4
    li      s4 ,    5
    li      s5 ,    6
    li      s6 ,    7
    li      s7 ,    8
    li      s8 ,    9
    li      s9 ,    10
    li      s10,    11
    li      s11,    12

    addi    sp,     sp,     -48
    sw      s0 ,    0 (sp)
    sw      s1 ,    4 (sp)
    sw      s2 ,    8 (sp)
    sw      s3 ,    12(sp)
    sw      s4 ,    16(sp)
    sw      s5 ,    20(sp)
    sw      s6 ,    24(sp)
    sw      s7 ,    28(sp)
    sw      s8 ,    32(sp)
    sw      s9 ,    36(sp)
    sw      s10,    40(sp)
    sw      s11,    44(sp)

    # Jump-and-link into frame1 (start recursion)
    jal     ra, frame1

    lw      s0 ,    0 (sp)
    lw      s1 ,    4 (sp)
    lw      s2 ,    8 (sp)
    lw      s3 ,    12(sp)
    lw      s4 ,    16(sp)
    lw      s5 ,    20(sp)
    lw      s6 ,    24(sp)
    lw      s7 ,    28(sp)
    lw      s8 ,    32(sp)
    lw      s9 ,    36(sp)
    lw      s10,    40(sp)
    lw      s11,    44(sp)
    addi    sp,     sp,     48

    addi    s0 , 	s0 ,    0
    addi    s1 ,	s1 ,    0
    addi    s2 , 	s2 ,    0
    addi    s3 , 	s3 ,    0
    addi    s4 , 	s4 ,    0
    addi    s5 , 	s5 ,    0
    addi    s6 , 	s6 ,    0
    addi    s7 , 	s7 ,    0
    addi    s8 , 	s8 ,    0
    addi    s9 , 	s9 ,    0
    addi    s10, 	s10,    0
    addi    s11, 	s11,    0
    j die


# --- Recursive Frames (no "call") ---

frame1:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    jal     ra, frame2
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jr      ra

frame2:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    jal     ra, frame3
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jr      ra

frame3:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    jal     ra, frame4
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jr      ra

frame4:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    jal     ra, frame5
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jr      ra

frame5:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    jal     ra, frame6
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jr      ra

frame6:
    addi    sp, sp, -16
    sw      ra, 12(sp)
    # Base case – just return
    lw      ra, 12(sp)
    addi    sp, sp, 16
    jr      ra

die:
wfi