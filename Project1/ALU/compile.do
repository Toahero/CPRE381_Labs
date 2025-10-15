vlib work
vmap work work

# Compile Dependencies
cd depends

set compileFiles [exec find . -type f -name compile.do]

foreach f $compileFiles {
    do $f
}

cd ../

# Compile all .vhd files recursively
set vhdFiles [exec find . -type f -name "*.vhd"]

foreach file $vhdFiles {
    vcom -reportprogress 300 -work work $file
}
