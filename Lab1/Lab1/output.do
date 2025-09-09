onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Standard Inputs}
add wave -noupdate -label CLK /tb_tpu_mv_element/CLK
add wave -noupdate -label reset /tb_tpu_mv_element/reset
add wave -noupdate -divider {Data Inputs}
add wave -noupdate -radix unsigned /tb_tpu_mv_element/s_iX
add wave -noupdate -radix unsigned /tb_tpu_mv_element/s_iW
add wave -noupdate -radix unsigned /tb_tpu_mv_element/s_iLdW
add wave -noupdate -radix unsigned /tb_tpu_mv_element/s_iY
add wave -noupdate -divider {Data Outputs}
add wave -noupdate -radix unsigned -childformat {{/tb_tpu_mv_element/s_oY(31) -radix unsigned} {/tb_tpu_mv_element/s_oY(30) -radix unsigned} {/tb_tpu_mv_element/s_oY(29) -radix unsigned} {/tb_tpu_mv_element/s_oY(28) -radix unsigned} {/tb_tpu_mv_element/s_oY(27) -radix unsigned} {/tb_tpu_mv_element/s_oY(26) -radix unsigned} {/tb_tpu_mv_element/s_oY(25) -radix unsigned} {/tb_tpu_mv_element/s_oY(24) -radix unsigned} {/tb_tpu_mv_element/s_oY(23) -radix unsigned} {/tb_tpu_mv_element/s_oY(22) -radix unsigned} {/tb_tpu_mv_element/s_oY(21) -radix unsigned} {/tb_tpu_mv_element/s_oY(20) -radix unsigned} {/tb_tpu_mv_element/s_oY(19) -radix unsigned} {/tb_tpu_mv_element/s_oY(18) -radix unsigned} {/tb_tpu_mv_element/s_oY(17) -radix unsigned} {/tb_tpu_mv_element/s_oY(16) -radix unsigned} {/tb_tpu_mv_element/s_oY(15) -radix unsigned} {/tb_tpu_mv_element/s_oY(14) -radix unsigned} {/tb_tpu_mv_element/s_oY(13) -radix unsigned} {/tb_tpu_mv_element/s_oY(12) -radix unsigned} {/tb_tpu_mv_element/s_oY(11) -radix unsigned} {/tb_tpu_mv_element/s_oY(10) -radix unsigned} {/tb_tpu_mv_element/s_oY(9) -radix unsigned} {/tb_tpu_mv_element/s_oY(8) -radix unsigned} {/tb_tpu_mv_element/s_oY(7) -radix unsigned} {/tb_tpu_mv_element/s_oY(6) -radix unsigned} {/tb_tpu_mv_element/s_oY(5) -radix unsigned} {/tb_tpu_mv_element/s_oY(4) -radix unsigned} {/tb_tpu_mv_element/s_oY(3) -radix unsigned} {/tb_tpu_mv_element/s_oY(2) -radix unsigned} {/tb_tpu_mv_element/s_oY(1) -radix unsigned} {/tb_tpu_mv_element/s_oY(0) -radix unsigned}} -subitemconfig {/tb_tpu_mv_element/s_oY(31) {-radix unsigned} /tb_tpu_mv_element/s_oY(30) {-radix unsigned} /tb_tpu_mv_element/s_oY(29) {-radix unsigned} /tb_tpu_mv_element/s_oY(28) {-radix unsigned} /tb_tpu_mv_element/s_oY(27) {-radix unsigned} /tb_tpu_mv_element/s_oY(26) {-radix unsigned} /tb_tpu_mv_element/s_oY(25) {-radix unsigned} /tb_tpu_mv_element/s_oY(24) {-radix unsigned} /tb_tpu_mv_element/s_oY(23) {-radix unsigned} /tb_tpu_mv_element/s_oY(22) {-radix unsigned} /tb_tpu_mv_element/s_oY(21) {-radix unsigned} /tb_tpu_mv_element/s_oY(20) {-radix unsigned} /tb_tpu_mv_element/s_oY(19) {-radix unsigned} /tb_tpu_mv_element/s_oY(18) {-radix unsigned} /tb_tpu_mv_element/s_oY(17) {-radix unsigned} /tb_tpu_mv_element/s_oY(16) {-radix unsigned} /tb_tpu_mv_element/s_oY(15) {-radix unsigned} /tb_tpu_mv_element/s_oY(14) {-radix unsigned} /tb_tpu_mv_element/s_oY(13) {-radix unsigned} /tb_tpu_mv_element/s_oY(12) {-radix unsigned} /tb_tpu_mv_element/s_oY(11) {-radix unsigned} /tb_tpu_mv_element/s_oY(10) {-radix unsigned} /tb_tpu_mv_element/s_oY(9) {-radix unsigned} /tb_tpu_mv_element/s_oY(8) {-radix unsigned} /tb_tpu_mv_element/s_oY(7) {-radix unsigned} /tb_tpu_mv_element/s_oY(6) {-radix unsigned} /tb_tpu_mv_element/s_oY(5) {-radix unsigned} /tb_tpu_mv_element/s_oY(4) {-radix unsigned} /tb_tpu_mv_element/s_oY(3) {-radix unsigned} /tb_tpu_mv_element/s_oY(2) {-radix unsigned} /tb_tpu_mv_element/s_oY(1) {-radix unsigned} /tb_tpu_mv_element/s_oY(0) {-radix unsigned}} /tb_tpu_mv_element/s_oY
add wave -noupdate -radix unsigned /tb_tpu_mv_element/s_oX
add wave -noupdate -divider {Standard Inputs}
add wave -noupdate /tb_tpu_mv_element/CLK
add wave -noupdate /tb_tpu_mv_element/reset
add wave -noupdate -divider {Internal Design Signals}
add wave -noupdate /tb_tpu_mv_element/DUT0/g_Weight/iLd
add wave -noupdate /tb_tpu_mv_element/DUT0/g_Weight/sQ
add wave -noupdate /tb_tpu_mv_element/DUT0/g_Weight/oQ
add wave -noupdate /tb_tpu_mv_element/DUT0/iCLK
add wave -noupdate /tb_tpu_mv_element/DUT0/iX
add wave -noupdate /tb_tpu_mv_element/DUT0/iW
add wave -noupdate /tb_tpu_mv_element/DUT0/iLdW
add wave -noupdate /tb_tpu_mv_element/DUT0/iY
add wave -noupdate /tb_tpu_mv_element/DUT0/oY
add wave -noupdate /tb_tpu_mv_element/DUT0/oX
add wave -noupdate /tb_tpu_mv_element/DUT0/s_W
add wave -noupdate /tb_tpu_mv_element/DUT0/s_X1
add wave -noupdate /tb_tpu_mv_element/DUT0/s_Y1
add wave -noupdate /tb_tpu_mv_element/DUT0/s_WxX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {83 ns}
