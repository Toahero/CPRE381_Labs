vlib work
vmap work work

#Compile Libraries
vcom -reportprogress 300 -work work proj/src/RISCV_types.vhd
vcom -reportprogress 300 -work work proj/src/TopLevel/Components/Regfile/array32.vhd

# Compile all .vhd files recursively
set vhdFiles [exec find . -type f -name "*.vhd"]

foreach file $vhdFiles {
    vcom -reportprogress 300 -work work $file
}
