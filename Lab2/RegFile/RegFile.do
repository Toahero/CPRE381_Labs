add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_RegFile/CLK
add wave -noupdate -label Reset    /tb_RegFile/reset

# Add RS1 signals
add wave -noupdate -divider "Read Port 1"
add wave -noupdate -label RS1_Select  -radix unsigned /tb_RegFile/s_RS1Sel
add wave -noupdate -label RS1 -radix decimal    /tb_RegFile/s_RS1

# Add RS2 signals
add wave -noupdate -divider "Read Port 2"
add wave -noupdate -label RS2_Select  -radix unsigned /tb_RegFile/s_RS2Sel
add wave -noupdate -label RS2 -radix decimal    /tb_RegFile/s_RS2

# Add Write signals
add wave -noupdate -divider "Write Port"
add wave -noupdate  -label Write_Enable  /tb_RegFile/s_WrEn
add wave -noupdate -label Rd_Select -radix unsigned  /tb_RegFile/s_RdSel
add wave -noupdate -label Rd -radix decimal   /tb_RegFile/s_Rd

# Add Internal Signals
add wave -noupdate -label s_WrEn /tb_RegFile/g_REGFILE/s_WrEn
add wave -noupdate -label Registers -radix decimal /tb_RegFile/g_REGFILE/s_ReadAr


run 1000
