.main clear

quit -sim

do compile.do

vcom -reportprogress 300 -work work tb_InstructionAddressHolder.vhd

vsim -gui work.tb_InstructionAddressHolder -voptargs=+acc

add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint sim:/tb_instructionaddressholder/s_iClock

add wave -noupdate -divider {Input}
add wave -label {Reset} -position insertpoint sim:/tb_instructionaddressholder/s_iReset
add wave -label {Reset Value} -position insertpoint sim:/tb_instructionaddressholder/testbench/g_PCRegister/i_ResetValue
add wave -label {Next Address} -position insertpoint sim:/tb_instructionaddressholder/s_iNextInstructionAddress

add wave -noupdate -divider {Output}
add wave -label {Current Address} -position insertpoint sim:/tb_instructionaddressholder/s_oCurrentInstructionAddress

run 50 ns
wave zoomfull