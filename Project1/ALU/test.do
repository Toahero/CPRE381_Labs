.main clear

do compile.do
vcom -reportprogress 300 -work work tb_ALU.vhd

vsim -gui work.tb_ALU -voptargs=+acc

# add wave -noupdate -divider {Clock}
# add wave -label {Clock} -position insertpoint sim:/tb_inst_mem/s_clk

