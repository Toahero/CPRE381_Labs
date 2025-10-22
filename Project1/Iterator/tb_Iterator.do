#tb_Iterator.do
quit -sim


vcom -2008 *.vhd
vsim -voptargs=+acc work.tb_Iterator
add wave -noupdate -divider "Standard Inputs"
add wave -noupdate -label Clock /tb_Iterator/s_CLK

add wave -noupdate -divider "Iterator Inputs"
add wave -noupdate -label Addr_Current -radix unsigned /tb_Iterator/s_instrNum

add wave -noupdate -label Offset -radix decimal /tb_Iterator/s_OffsetCnt

add wave -noupdate -label Branch /tb_Iterator/s_branch
add wave -noupdate -label Jump /tb_Iterator/s_jump

add wave -noupdate -divider "Output"
add wave -noupdate -label Addr_Next -radix unsigned /tb_Iterator/s_nextInst


add wave -noupdate -divider "Internal Signals"
add wave -noupdate -label Use_Offset /tb_Iterator/g_Iterator/s_OffsetEnable
add wave -noupdate -label Next_Linear /tb_Iterator/g_Iterator/s_InstPlusFour
add wave -noupdate -label Next_Jump /tb_Iterator/g_Iterator/s_InstOffset
add wave -noupdate -label Output /tb_Iterator/g_Iterator/o_nextInst
run 100
wave zoom full