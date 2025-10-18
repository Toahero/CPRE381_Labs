#tb_Datapath1.do
quit -sim


vcom -2008 *.vhd

vsim -voptargs=+acc work.tb_Datapath2
mem load -infile dmem.hex -format hex /tb_Datapath2/DATAFILE/dmem/ram

add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_Datapath2/CLK
add wave -noupdate -label Reset    /tb_Datapath2/reset
add wave -noupdate -label Instruction_Count -radix decimal /tb_Datapath2/ins_cnt

# Add Write signals
add wave -noupdate -divider "Operation Control"
add wave -noupdate -label AddSub   /tb_Datapath2/AddSub
add wave -noupdate -label Register_or_DataIn  /tb_Datapath2/ALUSrc

# Add Immediate input
add wave -noupdate -divider "Input"
add wave -noupdate -label Immediate -radix decimal  /tb_Datapath2/Imm

#Add Sum Values
add wave -noupdate -divider "Sum Values"
add wave -noupdate -label A_Val -radix decimal /tb_Datapath2/DATAFILE/RS1_Val
add wave -noupdate -label B_Val -radix decimal /tb_Datapath2/DATAFILE/sum_b
add wave -noupdate -label Sum -radix decimal /tb_Datapath2/DATAFILE/Sum_Val

#Register Signals
add wave -noupdate -divider "Register Signals"
add wave -noupdate  -label Register_Write  /tb_Datapath2/Reg_Wr
add wave -noupdate -label Rd -radix unsigned  /tb_Datapath2/Rd
add wave -noupdate -label RS1 -radix unsigned  /tb_Datapath2/RS1
add wave -noupdate -label RS2 -radix unsigned  /tb_Datapath2/RS2

#Add Register Values
add wave -noupdate -divider "Register Values"
add wave -noupdate -label Registers -radix decimal /tb_Datapath2/DATAFILE/g_reg/s_ReadAr

#Add Memory Signals
add wave -noupdate -divider "Memory"
add wave -noupdate -label Mem_Wr   /tb_Datapath2/Mem_Wr
#add wave -noupdate -label clock /tb_Datapath2/DATAFILE/dmem/clk
add wave -noupdate -label Memory_Address -radix unsigned  /tb_Datapath2/DATAFILE/dmem/addr
add wave -noupdate -label Memory_In -radix decimal /tb_Datapath2/DATAFILE/dmem/data
add wave -noupdate -label Memory_out -radix decimal /tb_Datapath2/DATAFILE/dmem/q
add wave -noupdate -label Ram -radix decimal /tb_Datapath2/DATAFILE/dmem/ram






#Uncomment to display internal datapath signals
add wave -noupdate -divider "Internal Signals"
#add wave -noupdate -radix decimal /tb_Datapath2/DATAFILE/*
#add wave -noupdate -radix decimal /tb_Datapath2/DATAFILE/dmem/*


run 500
wave zoom full
