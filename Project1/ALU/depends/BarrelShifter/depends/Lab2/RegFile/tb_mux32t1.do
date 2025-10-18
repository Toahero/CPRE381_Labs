#########################################################################
## Henry Duwe
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_mux32t1.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              TPU MAC unit. It adds some useful signals for testing
##              functionality and debugging the system. It also formats
##              the waveform and runs the simulation.
##              
## 01/04/2020 by H3::Design created.
#########################################################################

# Setup the wave form with useful signals

# Add the standard, non-data clock and reset input signals.
# First, add a helpful header label.
add wave -noupdate -divider {Standard Inputs}
add wave -noupdate -label CLK /tb_mux32t1/CLK

# Add data inputs that are specific to this design. These are the ones set during our test cases.
# Note that I've set the radix to unsigned, meaning that the values in the waveform will be displayed
# as unsigned decimal values. This may be more convenient for your debugging. However, you should be
# careful to look at the radix specifier (e.g., the decimal value 32'd10 is the same as the hexidecimal
# value 32'hA.
add wave -noupdate -divider {Data Inputs}
add wave -noupdate -label Select -radix binary /tb_mux32t1/s_Sel
add wave -noupdate -label MuxValues /tb_mux32t1/s_d

# Add data outputs that are specific to this design. These are the ones that we'll check for correctness.
add wave -noupdate -divider {Data Outputs}
add wave -noupdate -label output -radix hexadecimal /tb_mux32t1/s_OUT

force s_Sel(4) 0 0, 1 400 -repeat 800
force s_Sel(3) 0 0, 1 200 -repeat 400
force s_Sel(2) 0 0, 1 100 -repeat 200
force s_Sel(1) 0 0, 1 50 -repeat 100
force s_Sel(0) 0 0, 1 25 -repeat 50

run 800
