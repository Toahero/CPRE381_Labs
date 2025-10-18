-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: DFmux2t1.vhd
--Bi-Directional Barrel Shifter
--lbshift.vhd
-------------------------------------------------------------------------
--10/16/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity dualShift is
    generic(
        DATA_WIDTH  : positive;
        CNT_WIDTH   : positive
    );
    port(
        i_valueIn     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_shiftCount  : in std_logic_vector(CNT_WIDTH-1 downto 0); --The number of bits to be shifted
        i_arithmetic  : in std_logic;
        i_shiftLeft   : in std_logic; --0 for shift right, 1 for shift left
        o_valueOut    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end dualShift;

architecture mixed of dualShift is

    --2t1 Multiplexer
	component mux2t1_N is
  		generic(N : integer); -- Generic of type integer for input/output data width.
  		port(	i_S          : in std_logic;
			i_D0         : in std_logic_vector(N-1 downto 0);
			i_D1         : in std_logic_vector(N-1 downto 0);
			o_O          : out std_logic_vector(N-1 downto 0)
		);
	end component;

   component rbshift is
        generic(DATA_WIDTH  : positive;
                CNT_WIDTH   : positive);
        port(
            i_valIn     : in std_logic_vector(31 downto 0);
            i_sCnt      : in std_logic_vector(4 downto 0);
            i_arShift   : in std_logic;
            o_valOut    : out std_logic_vector(31 downto 0));
    end component;
    
    signal s_inputReversed  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_rightShifted   : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_LeftShiftRev   : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal s_LeftShiftFor   : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
    Reverser: for i in 0 to DATA_WIDTH-1 generate
        s_inputReversed(i) <= i_valueIn(DATA_WIDTH - 1 -i);--Reverse the input bits for the left shift portion
        s_LeftShiftFor(i)  <= s_LeftShiftRev(DATA_WIDTH-1 -i); --Reverse the output back to forwards afterward
    end generate Reverser;

    rightShifter    :   rbshift
        generic map(DATA_WIDTH  => DATA_WIDTH,
                    CNT_WIDTH   => CNT_WIDTH)
        port map(
            i_valIn     => i_valueIn,
            i_sCnt      => i_shiftCount,
            i_arShift   => i_arithmetic,
            o_valOut    => s_rightShifted);
    
    leftShifter    :   rbshift
        generic map(DATA_WIDTH  => DATA_WIDTH,
                    CNT_WIDTH   => CNT_WIDTH)
        port map(
            i_valIn     => s_inputReversed,
            i_sCnt      => i_shiftCount,
            i_arShift   => '0',
            o_valOut    => s_LeftShiftRev);

    DirMux  : mux2t1_N
            generic map(N       => DATA_WIDTH)
            port map(   i_S     => i_shiftLeft,
                        i_D0    => s_rightShifted,
                        i_D1    => s_LeftShiftFor,
                        o_O     => o_valueOut);

    
end mixed;