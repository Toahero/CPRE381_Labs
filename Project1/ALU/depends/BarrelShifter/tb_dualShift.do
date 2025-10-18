#tb_dualShift.do
quit -sim


vcom -2008 *.vhd

vsim -voptargs=+acc work.tb_dualShift
add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_dualShift/CLK
add wave -noupdate -divider "Component Inputs"
add wave -noupdate -radix binary /tb_dualShift/*

add wave -noupdate -divider "Component Inputs"
add wave -noupdate -radix binary /tb_dualShift/dShift/*

run 50
wave zoom full
