#tb_lbshift.do
quit -sim


vcom -2008 *.vhd

vsim -voptargs=+acc work.tb_lbshift
add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_lbshift/CLK
add wave -noupdate -divider "Component Inputs"
add wave -noupdate -radix binary /tb_lbshift/*
add wave -noupdate -divider "Signal Array"
add wave -noupdate -radix binary /tb_lbshift/lShifter/s_midShift

run 50
wave zoom full
