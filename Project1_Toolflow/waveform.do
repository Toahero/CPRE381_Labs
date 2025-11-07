add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint vsim:/tb/CLK
add wave -label {Reset} -position insertpoint vsim:/tb/reset
add wave -label {Cycle} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/s_CycleTracker

add wave -noupdate -divider {Program Counter / Instruction Memory}
add wave -label {Current Instruction Address} -position insertpoint vsim:/tb/MyRiscv/g_ProgramCounter/o_CurrentInstructionAddress
add wave -label {Next Instruction Address} -position insertpoint vsim:/tb/MyRiscv/g_ProgramCounter/i_NextInstructionAddress
add wave -label {Instruction} -position insertpoint vsim:/tb/MyRiscv/g_ImemHack/output_vec

add wave -noupdate -divider {Immediate Generator}
add wave -label {Hexadecimal} -radix hexadecimal -position insertpoint vsim:/tb/MyRiscv/g_ImmediateGeneration/o_output
add wave -label {Decimal} -radix decimal -position insertpoint vsim:/tb/MyRiscv/g_ImmediateGeneration/o_output

add wave -noupdate -divider {Registers}
add wave -label {Select Register 1} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/RS1Sel
add wave -label {Read Register 1} -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/RS1
add wave -label {Select Register 2} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/RS2Sel
add wave -label {Read Register 2} -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/RS2
add wave -label {Write Enable} -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/WrEn
add wave -label {Write Register} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/RdSel
add wave -label {Write Register Data} -position insertpoint vsim:/tb/MyRiscv/g_RegisterFile/Rd

add wave -noupdate -divider {ALU}
add wave -label {A Hexadecimal} -position insertpoint vsim:/tb/MyRiscv/g_ALU/s_Operand1
add wave -label {B Hexadecimal} -position insertpoint vsim:/tb/MyRiscv/g_ALU/s_Operand2
add wave -label {Output Hexadecimal} -position insertpoint vsim:/tb/MyRiscv/g_ALU/i_B
add wave -label {A Decimal} -radix decimal -position insertpoint vsim:/tb/MyRiscv/g_ALU/s_Operand1
add wave -label {B Decimal} -radix decimal -position insertpoint vsim:/tb/MyRiscv/g_ALU/s_Operand2
add wave -label {Output Decimal} -radix decimal -position insertpoint vsim:/tb/MyRiscv/g_ALU/i_B
add wave -label {Module Select} -radix binary -position insertpoint vsim:/tb/MyRiscv/g_ALU/i_ModSel
add wave -label {Operation Select} -radix binary -position insertpoint vsim:/tb/MyRiscv/g_ALU/i_OppSel
add wave -label {Branch Condition} -radix binary -position insertpoint vsim:/tb/MyRiscv/g_ALU/i_BranchCond

add wave -noupdate -divider {Data Memory}
add wave -label {Address} -position insertpoint vsim:/tb/MyRiscv/DMem/addr
add wave -label {Write Enable} -position insertpoint vsim:/tb/MyRiscv/DMem/we
add wave -label {Input Data} -position insertpoint vsim:/tb/MyRiscv/DMem/data
add wave -label {Sign Extended Output} -position insertpoint vsim:/tb/MyRiscv/g_DMEMSignExtender/o_SignExtendedDMEM
