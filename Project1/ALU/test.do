
.main clear

quit -sim

do compile.do
vcom -reportprogress 300 -work work tb_ALU.vhd

vsim -gui work.tb_ALU -voptargs=+acc

add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint sim:/tb_alu/s_Clock

add wave -noupdate -divider {Inputs}
add wave -label {Input A} -position insertpoint sim:/tb_alu/s_iA
add wave -label {Input B} -position insertpoint sim:/tb_alu/s_iB
add wave -label {Out Select} -position insertpoint sim:/tb_alu/s_iOutSel
add wave -label {Mode Select} -radix binary -position insertpoint sim:/tb_alu/s_iModSel
add wave -label {Operation Select} -radix binary -position insertpoint sim:/tb_alu/s_iOppSel

add wave -noupdate -divider {Outputs}
add wave -label {Result} -position insertpoint sim:/tb_alu/s_oResult
add wave -label {Output} -position insertpoint sim:/tb_alu/s_ooutput

add wave -noupdate -divider {Output Flags}
add wave -label {Zero} -position insertpoint sim:/tb_alu/s_fzero
add wave -label {Overflow} -position insertpoint sim:/tb_alu/s_fovflw
add wave -label {Negative} -position insertpoint sim:/tb_alu/s_fnegative

run 350 ns
wave zoomfull
