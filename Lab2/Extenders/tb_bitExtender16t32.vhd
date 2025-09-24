-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: tb_bitExtender16t32.vhd
--Description: a 16 to 32 extender for use in a RISC-V datafile

-- tb_bitExtender16t32.vhd
-------------------------------------------------------------------------
--9/24/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use ieee.numeric_std.all;

library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O
use work.array32.all;

entity tb_bitExtender16t32 is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_bitExtender16t32;


architecture mixed of tb_bitExtender16t32 is

	-- Define the total clock period time
	constant cCLK_PER  : time := gCLK_HPER * 2;

	component bitExtender16t32 is
		port(	i_sw	: in std_logic;
			i_16bit	: in std_logic_vector(15 downto 0);
			o_32bit	: out std_logic_vector(31 downto 0));
	end component;

	signal CLK	: std_logic := '0';

	signal s_sw	: std_logic;
	signal s_16bit	: std_logic_vector(15 downto 0);
	signal s_32bit	: std_logic_vector(31 downto 0);

begin
	g_Ext:  bitExtender16t32
		port map(	i_sw	=> s_sw,
				i_16bit	=> s_16bit,
				o_32bit => s_32bit);

  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

P_TEST_CASES: process
  begin

	wait for gCLK_HPER/2; --Change inputs on clk midpoints

	s_sw	<= '0';
	for i in 0 to 8 loop
		s_16bit <= std_logic_vector(to_signed(16*i, 16));
		wait for gCLK_HPER;
	end loop;
	
	s_sw	<= '1';
	for i in -10 to -1 loop
		s_16bit <= std_logic_vector(to_signed(i, 16));
		wait for gCLK_HPER;
	end loop;
--Test Cases

	wait;
end process;
end mixed;