add wave -noupdate -divider {Global Control}
add wave -label {Cycle} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/s_CycleTracker
add wave -label {Clock} -position insertpoint vsim:/tb/MyRiscv/iCLK
add wave -label {Reset} -position insertpoint vsim:/tb/MyRiscv/iRST
add wave -label {Halt} -position insertpoint vsim:/tb/MyRiscv/s_Halt

add wave -noupdate -divider {Instruction Fetch}

add wave -noupdate -divider {IFID Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_IFID_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_IFID_Current

add wave -noupdate -divider {Instruction Decode}

add wave -noupdate -divider {IDEX Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_IDEX_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_IDEX_Current

add wave -noupdate -divider {Execute}
add wave -label {Next} -position insertpoint 

add wave -noupdate -divider {EXMEM Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_EXMEM_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_EXMEM_Current

add wave -noupdate -divider {Memory}

add wave -noupdate -divider {MEMWB Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_MEMWB_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_MEMWB_Current

add wave -noupdate -divider {Write Back}
