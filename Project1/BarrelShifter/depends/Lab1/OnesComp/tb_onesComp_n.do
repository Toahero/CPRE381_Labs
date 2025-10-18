#########################################################################
## Henry Duwe
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_onesComp_N.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              TPU MAC unit. It adds some useful signals for testing
##              functionality and debugging the system. It also formats
##              the waveform and runs the simulation.
##              
## 01/04/2020 by H3::Design created.
#########################################################################

add wave -noupdate -divider {Standard Inputs}
add wave -noupdate -label CLK /tb_onesComp_N/CLK


add wave -noupdate -divider {Data Inputs}
add wave -noupdate -label i_D /tb_onesComp_N/s_iD

add wave -noupdate -divider {Data Outputs}
add wave -noupdate -label o_O /tb_onesComp_N/s_oO

# Run for 100 timesteps (default is 1ns per timestep, but this can be modified so be aware).
