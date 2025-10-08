.main clear

do compile.do

vcom -reportprogress 300 -work work tb_IsZero.vhd

vsim -gui work.tb_IsZero -voptargs=+acc

add wave -noupdate -divider {Progress}
add wave -label {Test Number} -radix unsigned -position insertpoint sim:/tb_iszero/s_testCase

add wave -noupdate -divider {Input}
add wave -label {Value} -position insertpoint sim:/tb_iszero/s_iInput

add wave -noupdate -divider {Output}
add wave -label {Is Zero} -position insertpoint sim:/tb_iszero/s_oIsZero

run 125 ns
wave zoomfull
