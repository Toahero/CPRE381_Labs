#Extender.do
#For tb_ImmediateExtender
quit -sim


vcom -2008 *.vhd

vsim -voptargs=+acc work.tb_ImmediateExtender

add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock    /tb_ImmediateExtender/CLK

add wave -noupdate -divider "Input and Output"
add wave -noupdate  -label Instruction -radix hexadecimal /tb_ImmediateExtender/s_instruction
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/s_immediate

add wave -noupdate -divider "Internal Signals"
add wave -noupdate -divider "I type"
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_iTypeIn
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_iTypeOut

add wave -noupdate -divider "S type"
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_STypeIn
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_STypeOut

add wave -noupdate -divider "b type"
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_bTypeIn
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_bTypeOut

add wave -noupdate -divider "u type"
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_uTypeIn
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_uTypeOut

add wave -noupdate -divider "j type"
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_jTypeIn
add wave -noupdate  -label Immediate -radix decimal /tb_ImmediateExtender/ComponentUnderTest/s_jTypeOut

run 200
wave zoom full
