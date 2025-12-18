#tb_Registers.do
quit -sim

vsim -voptargs=+acc work.tb_Registers

add wave -noupdate -label Clock /tb_Registers/CLK

add wave -noupdate -divider "Input Instruction"
add wave -noupdate -label Trigger_Nop /tb_Registers/s_nop_trigger
add wave -noupdate -label Instruction_In /tb_Registers/s_InstructionIn

add wave -noupdate -divider "IFID Register"
add wave -noupdate -label Instruction /tb_Registers/s_IFID_OUT.Instruction
add wave -noupdate -label flush /tb_Registers/s_IFID_Reset

add wave -noupdate -divider "IDEX Register"
add wave -noupdate -label Instruction /tb_Registers/s_IDEX_OUT.Instruction
add wave -noupdate -label flush /tb_Registers/s_IDEX_Reset

add wave -noupdate -divider "EXMEM Register"
add wave -noupdate -label Instruction /tb_Registers/s_EXMEM_OUT.Instruction
add wave -noupdate -label flush /tb_Registers/s_EXMEM_Reset

add wave -noupdate -divider "MEMWB Register"
add wave -noupdate -label Instruction /tb_Registers/s_MEMWB_OUT.Instruction
add wave -noupdate -label flush /tb_Registers/s_MEMWB_Reset

run 300
wave zoom full
