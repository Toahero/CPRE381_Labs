set WORK_FOLDER work

# Compile

vcom -reportprogress 300 -work $WORK_FOLDER mem.vhd
vcom -reportprogress 300 -work $WORK_FOLDER inst_mem.vhd
