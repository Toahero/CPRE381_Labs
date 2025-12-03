vlib work
vmap work work

vcom -reportprogress 300 -work work RISCV_types.vhd

# Compile all .vhd files recursively
set vhdFiles [exec find . -type f -name "*.vhd"]

foreach file $vhdFiles {
    vcom -reportprogress 300 -work work $file
}
