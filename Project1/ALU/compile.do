
# Dependancies
vcom -reportprogress 300 -work work depends/AddSub/addSub_n.vhd
vcom -reportprogress 300 -work work depends/AddSub/fulladder.vhd
vcom -reportprogress 300 -work work depends/AddSub/rippleAdder_n.vhd
vcom -reportprogress 300 -work work depends/IsZero/IsZero.vhd
vcom -reportprogress 300 -work work depends/IsNegative/IsNegative.vhd

# Entity
vcom -reportprogress 300 -work work ALU.vhd
