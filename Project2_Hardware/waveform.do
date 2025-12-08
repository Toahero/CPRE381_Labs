.main clear

# Find all WLF files under ./output
set wlf_list [glob -nocomplain -types f ./output/*/vsim.wlf]

if { [llength $wlf_list] == 0 } {
    echo "No WLF files found."
    return
}

# Find the newest WLF by modification time
set newest ""
set newest_time 0
foreach f $wlf_list {
    set mtime [file mtime $f]
    if { $mtime > $newest_time } {
        set newest $f
        set newest_time $mtime
    }
}

echo "Loading newest WLF: $newest"
vsim -view $newest

add wave -noupdate -divider {Global Control}
add wave -label {Cycle} -radix unsigned -position insertpoint vsim:/tb/MyRiscv/s_CycleTracker
add wave -label {Clock} -position insertpoint vsim:/tb/MyRiscv/iCLK
add wave -label {Reset} -position insertpoint vsim:/tb/MyRiscv/iRST
add wave -label {Halt} -position insertpoint vsim:/tb/MyRiscv/s_Halt
add wave -label {NOP} -position insertpoint vsim:/tb/MyRiscv/s_NOP
add wave -label {Pause} -position insertpoint vsim:/tb/MyRiscv/s_Pause

add wave -noupdate -divider {IFID Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_IFID_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_IFID_Current

add wave -noupdate -divider {IDEX Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_IDEX_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_IDEX_Current

add wave -noupdate -divider {EXMEM Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_EXMEM_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_EXMEM_Current

add wave -noupdate -divider {MEMWB Buffer}
add wave -label {Next} -position insertpoint vsim:/tb/MyRiscv/s_MEMWB_Next
add wave -label {Current} -position insertpoint vsim:/tb/MyRiscv/s_MEMWB_Current

