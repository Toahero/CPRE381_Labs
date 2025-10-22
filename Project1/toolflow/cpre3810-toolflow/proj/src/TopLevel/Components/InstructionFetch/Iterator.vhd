-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: addSub_n.vhd, mux2t1_N.vhd, BranchDecoder.vhd
--Description: Instruction Iterator for a RISC_V processor

--Iterator.vhd
-------------------------------------------------------------------------
--10/22/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Iterator is
  generic(DATA_WIDTH: integer);
  port(
    i_instrNum  :   in std_logic_vector(DATA_WIDTH-1 downto 0);
    i_OffsetCnt :   in std_logic_vector(DATA_WIDTH-1 downto 0);
    i_branch    : in std_logic;
    i_jump      : in std_logic;
    o_nextInst  : out std_logic_vector(DATA_WIDTH-1 downto 0));

end  Iterator;

architecture mixed of Iterator is

component addSub_n is
	generic(Comp_Width : integer); -- Generic of type integer for input/output data width.
	port(	nAdd_Sub	: in std_logic;
		i_A		: in std_logic_vector(Comp_Width-1 downto 0);
		i_B		: in std_logic_vector(Comp_Width-1 downto 0);
		o_overflow	: out std_logic;
		o_Sum		: out std_logic_vector(Comp_Width-1 downto 0));
end component;

component mux2t1_N is
  		generic(N : integer); -- Generic of type integer for input/output data width.
  		port(	i_S          : in std_logic;
			i_D0         : in std_logic_vector(N-1 downto 0);
			i_D1         : in std_logic_vector(N-1 downto 0);
			o_O          : out std_logic_vector(N-1 downto 0)
		);
end component;

signal s_InstPlusFour   : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_InstOffset : std_logic_vector(DATA_WIDTH-1 downto 0);

signal s_OffsetEnable   : std_logic;

signal s_FourOvFl   : std_logic;
signal s_OffOvFlw   : std_logic;

signal s_NextRaw    : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

s_OffsetEnable <= i_jump OR i_branch;

FourAdder: addSub_n
    generic map(Comp_Width => DATA_WIDTH)
    port map(   nAdd_Sub    => '0',
                i_A         =>  i_instrNum,
                i_B         =>  std_logic_vector(to_signed(4, DATA_WIDTH)),
                o_overflow  => s_FourOvFl,
                o_Sum       => s_InstPlusFour);

OffsetAdder: addSub_n
    generic map(Comp_Width  => DATA_WIDTH)
    port map(   nAdd_Sub => '0',
                i_A         => i_instrNum,
                i_B         => i_OffsetCnt,
                o_overflow  => s_OffOvFlw,
                o_Sum       => s_InstOffset);

IteratorMux: mux2t1_N
        generic map (N   => DATA_WIDTH)
        port map(   i_S     => s_OffsetEnable,
                    i_D0    => s_InstPlusFour,
                    i_D1    => s_InstOffset,
                    o_O     => s_NextRaw);

o_nextInst <= s_NextRaw(DATA_WIDTH-1 downto 2) & "00";
end mixed;
