.main clear
quit -sim

do compile.do

vsim -gui work.tb_Buffer -voptargs=+acc

add wave -noupdate -divider {Control}
add wave -label {Clock} -position insertpoint sim:/tb_buffer/s_Clock
add wave -label {Reset} -position insertpoint sim:/tb_buffer/s_Reset
add wave -label {Write Enable} -position insertpoint sim:/tb_buffer/s_WriteEnable

add wave -noupdate -divider {Input}
add wave -label {Next} -position insertpoint sim:/tb_buffer/s_Next

add wave -noupdate -divider {Output}
add wave -label {Current} -position insertpoint sim:/tb_buffer/s_Current

run 100 ns
wave zoomfull
