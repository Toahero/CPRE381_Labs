set WORK_FOLDER work

.main clear

do compile.do

vcom -reportprogress 300 -work $WORK_FOLDER tb_inst_mem.vhd

vsim -gui work.tb_inst_mem -voptargs=+acc
mem load -infile inst_mem.hex -format hex /tb_inst_mem/testbench/mem_module/ram

add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint sim:/tb_inst_mem/s_clk

add wave -noupdate -divider {Input}
add wave -label {Instruction Number} -radix unsigned -position insertpoint sim:/tb_inst_mem/s_inum

add wave -noupdate -divider {Output}
add wave -label {Instruction} -position insertpoint sim:/tb_inst_mem/s_oinst

add wave -noupdate -divider {Memory}
add wave -label {Memory} -position insertpoint sim:/tb_inst_mem/testbench/mem_module/ram

run 100 ns
wave zoomfull