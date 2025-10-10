vlib work
vmap work work

# Compile Dependancies
cd depends

set compileFiles [exec find . -type f -name compile.do]

foreach f $compileFiles {
    do $f
}

cd ../

# Entity
vcom -reportprogress 300 -work work ALU.vhd
