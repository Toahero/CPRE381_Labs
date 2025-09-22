-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: mux32t1.vhd
--Description: 32x 32t1 Multiplexer testbed

-- tb_Mux32t1.vhd
-------------------------------------------------------------------------
--9/13/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use ieee.numeric_std.all;

library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O
use work.array32.all;

entity tb_Mux32t1 is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_Mux32t1;

architecture mixed of tb_Mux32t1 is

	-- Define the total clock period time
	constant cCLK_PER  : time := gCLK_HPER * 2;

	--Component Interface
	component mux32t1 is
		port(	i_d	: in array32bits32;
			i_sel	: in std_logic_vector(4 downto 0);
			o_out	: out std_logic_vector(31 downto 0));
	end component;

	signal CLK	: std_logic := '0';

	signal s_d	: array32bits32;
	signal s_Sel	: std_logic_vector(4 downto 0) := "00000";
	signal s_Out	: std_logic_vector(31 downto 0) := x"00000000";

begin
	DUT0:	mux32t1
		port map( 	i_d	=> s_d,
				i_sel	=> s_Sel,
				o_out	=> s_Out);
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


P_TEST_CASES: process
  begin

	for i in 0 to 31 loop
		s_d(i) <= std_logic_vector(to_unsigned(i * 65536, 32));
	end loop;
	wait for gCLK_HPER/2; --Change inputs on clk midpoints

--Test Cases

	wait;
end process;
end mixed;