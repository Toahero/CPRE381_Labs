vlib work
vmap work work


# Compile all .vhd files recursively
set vhdFiles [exec find . -type f -name "*.vhd"]

foreach file $vhdFiles {
    vcom -reportprogress 300 -work work $file
}
