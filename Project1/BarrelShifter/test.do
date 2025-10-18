.main clear

quit -sim

do compile.do

vsim -gui work.tb_dualShift -voptargs=+acc

add wave -noupdate -divider {Clock}
add wave -label {Clock} -position insertpoint sim:/tb_dualshift/CLK

add wave -noupdate -divider {Inputs}
add wave -label {Value In} -radix hex -position insertpoint sim:/tb_dualshift/s_valIn
add wave -label {Shift Count} -radix unsigned -position insertpoint sim:/tb_dualshift/s_sCnt

add wave -noupdate -divider {Flags}
add wave -label {Arithmatic} -position insertpoint sim:/tb_dualshift/s_arith
add wave -label {Shift Left} -position insertpoint sim:/tb_dualshift/s_sLeft

add wave -noupdate -divider {Output}
add wave -label {Value Out} -radix hex -position insertpoint sim:/tb_dualshift/s_valOut

run 500 ns
wave zoomfull
