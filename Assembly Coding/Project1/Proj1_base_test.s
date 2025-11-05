addi t0, zero, 5
addi t1, zero 8
sub t3, t1, t0
or t4, t2, t0
and t5, t3, t1
sll t0, t1, t0
srl t1, t2, t3
sra t2, t1, t3
slt t3, t0, t2
sltu t4, t3, t0

xori t5, t2, 5
ori t0, t1, 2
andi t1, t2, -9
slli t2, t4, 2
srli t3, t1, 2
slti t4, t0, 1
sltiu t5, t4, -1
wfi