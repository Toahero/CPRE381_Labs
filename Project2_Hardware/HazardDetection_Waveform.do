add wave -noupdate -divider {Global Control}
add wave -label {Cycle} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/s_CycleTracker
add wave -label {Clock} -position insertpoint vsim:/tb/MyRiscv/iCLK
add wave -label {Reset} -position insertpoint vsim:/tb/MyRiscv/iRST
add wave -label {Halt} -position insertpoint vsim:/tb/MyRiscv/s_Halt
add wave -label {NOP} -position insertpoint vsim:/tb/MyRiscv/s_NOP
add wave -label {Pause} -position insertpoint vsim:/tb/MyRiscv/s_Pause

add wave -noupdate -divider {Instructions}
add wave -noupdate -label {IF}    -position insertpoint vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_IF_Instruction.Instruction
add wave -noupdate -label {ID}    -position insertpoint vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_ID_Instruction.Instruction
add wave -noupdate -label {EX}    -position insertpoint vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_EX_Instruction.Instruction
add wave -noupdate -label {MEM}   -position insertpoint vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_MEM_Instruction.Instruction
add wave -noupdate -label {WB}    -position insertpoint vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_WB_Instruction.Instruction

add wave -noupdate -divider "Hazard Detection"
add wave -noupdate -label "EX RS1" -radix unsigned vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_EX_Instruction.RS1
add wave -noupdate -label "EX RS2" -radix unsigned vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_EX_Instruction.RS2
add wave -noupdate -label "Mem RD" -radix unsigned vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_MEM_Instruction.RD
add wave -noupdate -label "WB RD"  -radix unsigned vsim:/tb/MyRiscv/g_HazardDetectionUnit/s_WB_Instruction.RD
