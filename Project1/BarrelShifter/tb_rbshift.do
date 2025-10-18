#tb_rbshift.do
quit -sim


vcom -2008 *.vhd

vsim -voptargs=+acc work.tb_rbshift
add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_rbshift/CLK
add wave -noupdate -divider "Component Inputs"
add wave -noupdate -radix binary /tb_rbshift/*
add wave -noupdate -divider "Signal Array"
add wave -noupdate -radix binary /tb_rbshift/rShifter/s_midShift

run 50
wave zoom full
