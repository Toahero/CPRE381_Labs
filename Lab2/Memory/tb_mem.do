#tb_mem.do

add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_mem/CLK

# Add Write signals
add wave -noupdate -divider "Input Signals"
add wave -noupdate  -label Write_Enable  /tb_mem/s_we
add wave -noupdate -label address -radix decimal /tb_mem/s_addr
add wave -noupdate -label data -radix decimal /tb_mem/s_data
add wave -noupdate -label we /tb_mem/s_we
add wave -noupdate -label q -radix decimal /tb_mem/s_q

#Add Internal Signals
add wave -noupdate -divider "Internal Signals"

#Uncomment to display all datapath signals
add wave -noupdate -radix decimal /tb_mem/dmem/*

run 500
