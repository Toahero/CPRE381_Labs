.main clear

do compile.do
vcom -reportprogress 300 -work work tb_ALU.vhd

vsim -gui work.tb_ALU -voptargs=+acc


