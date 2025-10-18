#########################################################################
## Henry Duwe
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_DFmux2t1.do
#########################################################################
## DESCRIPTION: Testbench for a 2t1 MUX
#########################################################################

# Setup the wave form with useful signals

add wave -noupdate -divider {Standard Inputs}
add wave -noupdate -label CLK /tb_DFmux2t1/CLK

# Add data inputs that are specific to this design. These are the ones set during our test cases.
# Note that I've set the radix to unsigned, meaning that the values in the waveform will be displayed
# as unsigned decimal values. This may be more convenient for your debugging. However, you should be
# careful to look at the radix specifier (e.g., the decimal value 32'd10 is the same as the hexidecimal
# value 32'hA.
add wave -noupdate -divider {Data Inputs}
add wave -noupdate -label i_S /tb_DFmux2t1/s_iS
add wave -noupdate -label i_D0 /tb_DFmux2t1/s_iD0
add wave -noupdate -label i_D1 /tb_DFmux2t1/s_iD1

# Add data outputs that are specific to this design. These are the ones that we'll check for correctness.
add wave -noupdate -divider {Data Outputs}
add wave -noupdate -label o_O /tb_DFmux2t1/s_oO

# Run for 100 timesteps (default is 1ns per timestep, but this can be modified so be aware).
