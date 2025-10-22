-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: DFmux2t1.vhd
--Right Barrel Shifter
--rbshift.vhd
-------------------------------------------------------------------------
--10/15/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity rbshift is
    generic(DATA_WIDTH  : positive;
            CNT_WIDTH   : positive);
    port(
        i_valIn     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_sCnt      : in std_logic_vector(CNT_WIDTH-1 downto 0);
        i_arShift   : in std_logic;
        o_valOut    : out std_logic_vector(DATA_WIDTH-1 downto 0));
end rbshift;

architecture mixed of rbshift is
    
   component DFmux2t1 is
	Port(   i_D0	:	in std_logic;
            i_D1	:	in std_logic;
            i_S	    :	in std_logic;
            o_O	    :	out std_logic);
    end component;

    signal s_extSign    : std_logic;

    type ar_ShiftArr is array(0 to CNT_WIDTH) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_midShift   : ar_ShiftArr;
     
begin
    --Tie the first vector of Midshift to input
    s_midShift(0) <= i_valIn;

    --If arShift is high, extend with the msb of dataIn. Otherwise, extend with 0
    s_extSign <= i_valIn(DATA_WIDTH-1) when i_arShift = '1' else '0';

    g_valShiftArr: for i in 0 to CNT_WIDTH-1 generate
        g_MuxMain: for j in 0 to DATA_WIDTH -1 - 2**i generate
            g_mux: DFmux2t1
                port map(   i_D0    =>  s_midShift(i)(j),
                            i_D1    =>  s_midShift(i)(j+2**i),
                            i_S     =>  i_sCnt(i),
                            o_O     =>  s_midShift(i+1)(j));
        end generate g_MuxMain;
        
        g_MuxEnd: for j in DATA_WIDTH - 2**i to DATA_WIDTH -1 generate
            g_mux: DFmux2t1
                port map(   i_D0    =>  s_midShift(i)(j),
                            i_D1    =>  s_extSign,
                            i_S     =>  i_sCnt(i),
                            o_O     =>  s_midShift(i+1)(j));
        end generate g_MuxEnd;
        
    end generate g_valShiftArr;
    
        --Tie the last vector of Midshift to output
        o_valOut <= s_midShift(CNT_WIDTH);
    

end mixed;