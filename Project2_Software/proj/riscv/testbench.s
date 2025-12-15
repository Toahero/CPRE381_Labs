.text
main:
    lui		x2,		0x0007FFFF
    nop
    nop
    nop
    addi x2, x2, 0xfffffffc

    	# ADDI
	addi	t0,	zero,	 1
	addi	a0,	zero,	 5
	addi	a1,	zero,	-5
	nop
	nop
	nop

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
    nop
    nop
    nop
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
    nop
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
    
    
#AUIPC
auipc t0, 100000

#Store and load
lui		x2,		0x0007FFFF
    nop
    nop
    nop
    addi x2, x2, 0xfffffffc
    nop
    nop
    nop
    addi    sp,     sp,     -48
    nop
    nop
    nop
    
    
    lb      s0 ,    0 (sp)
    lh      s1 ,    4 (sp)    
    lbu     s2 ,    0 (sp)
    lhu     s3 ,    4 (sp)
    nop
    nop
    nop
    
    j branch
    nop
    nop
    nop

# --- Recursive Frames (no "call") ---

frame1:
    addi    sp, sp, -16
    nop
    nop
    nop
    sw      ra, 12(sp)
    nop
    jal     ra, frame2
    nop
    nop
    nop
    lw      ra, 12(sp)
    addi    sp, sp, 16
    nop
    nop
    jr      ra
    nop

frame2:
    addi    sp, sp, -16
    nop
    nop
    nop
    sw      ra, 12(sp)
    nop
    jal     ra, frame3
    nop
    lw      ra, 12(sp)
    addi    sp, sp, 16
    nop
    nop
    jr      ra
    nop

frame3:
    addi    sp, sp, -16
    nop
    nop
    nop
    sw      ra, 12(sp)
    jal     ra, frame4
    nop
    lw      ra, 12(sp)
    nop
    nop
    nop
    addi    sp, sp, 16
    nop
    nop
    jr      ra
    nop

frame4:
    addi    sp, sp, -16
    nop
    nop
    nop
    sw      ra, 12(sp)
    jal     ra, frame5
    nop
    lw      ra, 12(sp)
    addi    sp, sp, 16
    nop
    nop
    jr      ra
    nop

frame5:
    addi    sp, sp, -16
    nop
    nop
    nop
    sw      ra, 12(sp)
    jal     ra, frame6
    nop
    lw      ra, 12(sp)
    nop
    nop
    nop
    addi    sp, sp, 16
    jr      ra
    nop

frame6:
    addi    sp, sp, -16
    nop
    nop
    nop
    sw      ra, 12(sp)
    # Base case – just return
    lw      ra, 12(sp)
    nop
    nop
    addi    sp, sp, 16
    nop
    nop
    jr      ra
    nop
    nop
    nop


branch:

addi t0, zero, -5
addi t1, zero, -5
addi t2, zero, 5
nop
nop
nop
#Doesn't Branch
beq t1, t2, notEqual
nop
#Branches
beq t0, t1, notEqual
nop

notEqual:
#doesn't branch
bne t0, t1, lessThan
nop
#branches
bne t0, t2, lessThan
nop
greaterThanOrEq:
#doesn't branch
bge t1, t2, lessThanUnsigned
nop
#branches
bge t2, t0, lessThanUnsigned
nop

lessThan:
#doesn't branch
ble t2, t1, greaterThanOrEq
nop
#branches
ble t0, t2, greaterThanOrEq
nop
lessThanUnsigned:
#doesn't branch
bleu t0, t2, greaterThanUnsigned
nop
#branches
bleu t2, t0, greaterThanUnsigned
nop

greaterThanUnsigned:
#doesn't branch
bgeu t2, t0, die
nop
#branches
bgeu t0, t2, die
nop

die:
nop
nop
nop
wfi