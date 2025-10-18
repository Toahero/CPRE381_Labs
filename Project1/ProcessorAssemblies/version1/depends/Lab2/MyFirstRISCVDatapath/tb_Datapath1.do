#tb_Datapath1.do

add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_Datapath1/CLK
add wave -noupdate -label Reset    /tb_Datapath1/reset

# Add Write signals
add wave -noupdate -divider "Input Signals"
add wave -noupdate  -label Write_Enable  /tb_Datapath1/s_WrEn
add wave -noupdate  -label ALU_SRC  /tb_Datapath1/s_ALUSrc
add wave -noupdate -label AddSub   /tb_Datapath1/s_AddSub

add wave -noupdate -label Rd -radix decimal  /tb_Datapath1/s_Rd
add wave -noupdate -label RS1 -radix decimal  /tb_Datapath1/s_RS1
add wave -noupdate -label RS2 -radix decimal  /tb_Datapath1/s_RS2

add wave -noupdate -label Val_In -radix decimal  /tb_Datapath1/s_ValIn

#Add Internal Signals
add wave -noupdate -divider "Internal Signals"
add wave -noupdate -label RS1_Val -radix decimal /tb_Datapath1/DATAFILE/s_RS1_Val
add wave -noupdate -label RS2_Val -radix decimal /tb_Datapath1/DATAFILE/s_RS2_Val
add wave -noupdate -label Sum_Val -radix decimal /tb_Datapath1/DATAFILE/s_Sum_Val

#Uncomment to display all datapath signals
#add wave -noupdate -radix decimal /tb_Datapath1/DATAFILE/*


#Add Register Values
add wave -noupdate -divider "Register Values"
add wave -noupdate -label Registers -radix decimal /tb_Datapath1/DATAFILE/g_Reg/s_ReadAr
run 500
