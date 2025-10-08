#tb_mem.do

# compile all code in src folder
vcom -2008 *.vhd

# start simulation with all signals shown
vsim -voptargs=+acc work.tb_dmem


add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_dmem/CLK

# Add Write signals
add wave -noupdate -divider "Input Signals"
add wave -noupdate  -label Write_Enable  /tb_dmem/s_we
add wave -noupdate -label address -radix decimal /tb_dmem/s_addr
add wave -noupdate -label data -radix decimal /tb_dmem/s_data
add wave -noupdate -label we /tb_dmem/s_we
add wave -noupdate -label q -radix decimal /tb_dmem/s_q

#Add Internal Signals
#add wave -noupdate -divider "Internal Signals"

#Uncomment to display all datapath signals
add wave -noupdate -radix hexadecimal /tb_dmem/dmem/ram

mem load -infile dmem.hex -format hex /tb_dmem/dmem/ram

run 500

wave zoom full
