add wave -noupdate -divider {Global Control}
add wave -label {Cycle} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/s_CycleTracker
add wave -label {Clock} -position insertpoint vsim:/tb/MyRiscv/iCLK




#add wave -noupdate -divider "Argument Registers"

#add wave -noupdate -label "Ex Register RS1" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_Ex_RS1
#add wave -noupdate -label "Ex Register RS2" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_Ex_RS2

add wave -noupdate -divider "Memory Checker"
add wave -noupdate -label "Ex Register RS1" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_Ex_RS1
add wave -noupdate -label "Ex Register RS2" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_Ex_RS2
add wave -noupdate -label "RD_Reg" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_Mem_RD
add wave -noupdate -label "RS1 Forwardable Type" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_RS1_Fwdable_Type
add wave -noupdate -label "RS1 Matches RD" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_MemRD_EqualsExRS1
add wave -noupdate -label "Output RS1" vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/o_forwardRS1
add wave -noupdate -label "RS2 Forwardable Type" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_RS2_Fwdable_Type
add wave -noupdate -label "RS2 Matches RD" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/s_MemRD_EqualsExRS2
add wave -noupdate -label "Output RS2" vsim:/tb/MyRiscv/g_ForwardingUnit/g_MemChecker/o_forwardRS2

add wave -noupdate -divider "Writeback Checker"
add wave -noupdate -label "Ex Register RS1" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_Ex_RS1
add wave -noupdate -label "Ex Register RS2" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_Ex_RS2
add wave -noupdate -label "RD_Reg" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_Wb_RD
add wave -noupdate -label "RS1 Forwardable Type" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_RS1_Fwdable_Type
add wave -noupdate -label "RS1 Matches RD" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_WbRD_EqualsExRS1
add wave -noupdate -label "Output RS1" vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/o_forwardRS1

add wave -noupdate -label "RS2 Forwardable Type" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_RS2_Fwdable_Type
add wave -noupdate -label "RS2 Matches RD" -radix unsigned vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/s_WbRD_EqualsExRS2
add wave -noupdate -label "Output RS2" vsim:/tb/MyRiscv/g_ForwardingUnit/g_WbChecker/o_forwardRS2

add wave -noupdate -divider "RS1 Value Mux"
#add wave -noupdate -label Selection -radix unsigned vsim:/tb/MyRiscv/s_ForwardSel_ValA
add wave -noupdate -label "Execution Stage" -radix decimal vsim:/tb/MyRiscv/g_ValueA_Forwarding/i_D0
add wave -noupdate -label "Memory Stage" -radix decimal vsim:/tb/MyRiscv/g_ValueA_Forwarding/i_D1
add wave -noupdate -label "Writeback Stage" -radix decimal vsim:/tb/MyRiscv/g_ValueA_Forwarding/i_D2
add wave -noupdate -label "Output" -radix decimal vsim:/tb/MyRiscv/g_ValueA_Forwarding/o_Output

add wave -noupdate -divider "Forward Selection"
add wave -noupdate -label ValueA_Select -radix unsigned vsim:/tb/MyRiscv/s_ForwardSel_ValA
add wave -noupdate -label ValueB_Select -radix unsigned vsim:/tb/MyRiscv/s_ForwardSel_ValB

add wave -noupdate -divider "RS2 Value Mux"
#add wave -noupdate -label Selection -radix unsigned vsim:/tb/MyRiscv/s_ForwardSel_ValB
add wave -noupdate -label "Execution Stage" -radix decimal vsim:/tb/MyRiscv/g_ValueB_Forwarding/i_D0
add wave -noupdate -label "Memory Stage" -radix decimal vsim:/tb/MyRiscv/g_ValueB_Forwarding/i_D1
add wave -noupdate -label "Writeback Stage" -radix decimal vsim:/tb/MyRiscv/g_ValueB_Forwarding/i_D2
add wave -noupdate -label "Output" -radix decimal vsim:/tb/MyRiscv/g_ValueB_Forwarding/o_Output

add wave -noupdate -divider "ALU Values"
add wave -noupdate -label "A input" -radix decimal vsim:/tb/MyRiscv/g_ALU/i_A
add wave -noupdate -label "B input" -radix decimal vsim:/tb/MyRiscv/g_ALU/i_B
add wave -noupdate -label "ALU Output" -radix decimal vsim:/tb/MyRiscv/g_ALU/o_output

add wave -noupdate -divider "Writeback Values"
add wave -noupdate -label "RD Register" -radix unsigned vsim:/tb/MyRiscv/g_RegisterFile/RdSel
add wave -noupdate -label "RD Value" -radix decimal vsim:/tb/MyRiscv/g_RegisterFile/Rd

