.main clear

quit -sim

do compile.do

vcom -reportprogress 300 -work work tb_ProgramCounter.vhd

vsim -gui work.tb_ProgramCounter -voptargs=+acc

add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint sim:/tb_programcounter/s_iClock

add wave -noupdate -divider {Reset}
add wave -label {Reset} -position insertpoint sim:/tb_programcounter/s_iReset

add wave -noupdate -divider {Instruction Addresses}
add wave -label {Next Instruction Address} -position insertpoint sim:/tb_programcounter/testbench/g_InstructionAddressHolder/i_NextInstructionAddress
add wave -label {Current Instruction Address} -position insertpoint sim:/tb_programcounter/testbench/g_InstructionAddressHolder/o_CurrentInstructionAddress

run 50 ns
wave zoomfull
