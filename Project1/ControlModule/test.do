.main clear

do compile.do

vcom -reportprogress 300 -work work tb_ControlUnit.vhd

vsim -gui work.tb_ControlUnit -voptargs=+acc
