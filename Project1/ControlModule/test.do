.main clear

do compile.do

vcom -reportprogress 300 -work work tb_ControlUnit.vhd

vsim -gui work.tb_ControlUnit -voptargs=+acc

add wave -noupdate -divider {Inputs}
add wave -label {Op Code}               -radix binary -position insertpoint sim:/tb_controlunit/s_i_opCode
add wave -label {Funct 7 / Immediate}   -radix hex -position insertpoint sim:/tb_controlunit/s_i_funt7_imm

add wave -noupdate -divider {Outputs}
add wave -label {Register Write Enable} -position insertpoint sim:/tb_controlunit/s_MemToReg
add wave -label {Memory Write Enable} -position insertpoint sim:/tb_controlunit/s_Reg_WE
add wave -label {Jump} -position insertpoint sim:/tb_controlunit/s_Jump
add wave -label {Memory to Register} -position insertpoint sim:/tb_controlunit/s_MemToReg
add wave -label {Branch} -position insertpoint sim:/tb_controlunit/s_Branch

run 100 ns
wave zoomfull
