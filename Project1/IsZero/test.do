.main clear

do compile.do

vcom -reportprogress 300 -work work tb_IsZero.vhd

vsim -gui work.tb_IsZero -voptargs=+acc

add wave -noupdate -divider {Test Number}
add wave -label {Line Number} -radix unsigned -position insertpoint sim:/tb_datapath/s_Line

add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint sim:/tb_datapath/s_iClock

add wave -noupdate -divider {Input}
add wave -label {Input} -position insertpoint sim:/tb_datapath/s_iClock

add wave -noupdate -divider {Output}
add wave -label {Output} -position insertpoint sim:/tb_datapath/s_iClock
