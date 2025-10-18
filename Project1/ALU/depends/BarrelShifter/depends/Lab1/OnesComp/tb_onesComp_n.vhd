-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------


-- tb_onesComp_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbed for an implementation of a ones comp system

--9/2/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_onesComp_n is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_onesComp_n;

architecture mixed of tb_onesComp_n is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

--Component Interface
   component onesComp_n is
	generic(N : integer := 32);
	port(i_D	: in std_logic_vector(N-1 downto 0);
	     o_O	: out std_logic_vector(N-1 downto 0));
   end component;

--Clock Signal
signal CLK : std_logic := '0';

--Testbed Signals
signal s_iD	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
signal s_oO	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";

begin
	DUT0: onesComp_n
	generic map (N => DATA_WIDTH)
	port map(
		i_D	=> s_iD,
		o_O	=> s_oO);

--Set up the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- change inputs on clk edges

	--Test Case 1:
	s_iD	<= x"00000000";
    	wait for gCLK_HPER*2;
    

	--Test Case 2:
	s_iD	<= x"FFFFFFFF";
    	wait for gCLK_HPER*2;

	--Test Case 3:
	s_iD	<= x"AAAAAAAA";
	wait for gCLK_HPER*2;


	wait;
  end process;
end mixed;
	