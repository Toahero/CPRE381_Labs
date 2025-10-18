-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: DFmux2t1.vhd
--Left Barrel Shifter
--lbshift.vhd
-------------------------------------------------------------------------
--10/16/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity lbshift is
    generic(DATA_WIDTH  : positive;
            CNT_WIDTH   : positive);
    port(
        i_valIn     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_sCnt      : in std_logic_vector(CNT_WIDTH-1 downto 0);
        o_valOut    : out std_logic_vector(DATA_WIDTH-1 downto 0));
end lbshift;

architecture mixed of lbshift is
    
   component DFmux2t1 is
	Port(   i_D0	:	in std_logic;
            i_D1	:	in std_logic;
            i_S	    :	in std_logic;
            o_O	    :	out std_logic);
    end component;

    type ar_ShiftArr is array(0 to CNT_WIDTH) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_midShift   : ar_ShiftArr;
     
begin
    --Tie the first vector of Midshift to input
    s_midShift(0) <= i_valIn;

    g_valShiftArr: for i in 0 to CNT_WIDTH-1 generate
        g_MuxMain: for j in 2**i to DATA_WIDTH -1 generate
            g_mux: DFmux2t1
                port map(   i_D0    =>  s_midShift(i)(j),
                            i_D1    =>  s_midShift(i)(j-(2**i)),
                            i_S     =>  i_sCnt(i),
                            o_O     =>  s_midShift(i+1)(j));
        end generate g_MuxMain;
        
        g_MuxEnd: for j in 0 to 2**i-1 generate
            g_mux: DFmux2t1
                port map(   i_D0    =>  s_midShift(i)(j),
                            i_D1    =>  '0',
                            i_S     =>  i_sCnt(i),
                            o_O     =>  s_midShift(i+1)(j));
        end generate g_MuxEnd;
        
        
        
    end generate g_valShiftArr;
    
        --Tie the last vector of Midshift to output
        o_valOut <= s_midShift(CNT_WIDTH);
    

end mixed;