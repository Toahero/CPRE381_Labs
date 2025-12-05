#tb_ALU2.do
quit -sim


#vcom -2008 *.vhd

vsim -voptargs=+acc work.tb_ALU2

add wave -noupdate -label Clock /tb_ALU2/CLK

add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Input_A -radix decimal /tb_ALU2/s_A
add wave -noupdate -label Input_B -radix decimal /tb_ALU2/s_B

add wave -noupdate -divider "Override Inputs"
add wave -noupdate -label Override_A -radix decimal /tb_ALU2/s_AOverride
add wave -noupdate -label Override_B -radix decimal /tb_ALU2/s_BOverride

add wave -noupdate -divider "Override Enables"
add wave -noupdate -label OvRd_Enable_A /tb_ALU2/s_AOverrideEnable
add wave -noupdate -label OvRd_Enable_B /tb_ALU2/s_BOverrideEnable

add wave -noupdate -divider "Module Controls"
add wave -noupdate -label Module_Select -radix binary /tb_ALU2/s_ModSel
add wave -noupdate -label Operation_Select -radix binary /tb_ALU2/s_ModSel

add wave -noupdate -divider "Outputs"
add wave -noupdate -label Output -radix decimal /tb_ALU2/s_output
add wave -noupdate -label Flag_Overflow /tb_ALU2/s_fovflw
add wave -noupdate -label Flag_Zero /tb_ALU2/s_fzero
add wave -noupdate -label Flag_Negative /tb_ALU2/s_fnegative
add wave -noupdate -label Flag_Branch /tb_ALU2/s_fbranch

run 200

wave zoom full
