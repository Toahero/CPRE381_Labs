-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------


-- tb_rippleAdder_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbed for an implementation of a scaleable ripple adder

--9/2/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_rippleAdder_n is
  generic(gCLK_HPER   : time := 10 ns;   -- Generic for half of the clock cycle period
          DATA_WIDTH  : integer := 8); 
end tb_rippleAdder_n;

architecture mixed of tb_rippleAdder_n is

--Define total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

--Component Interface
component rippleAdder_n is
	generic(N : integer);
	port(	i_Carry	: in std_logic;
		i_A	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);

		o_Carry	: out std_logic;
		o_Sum	: out std_logic_vector(N-1 downto 0));
	end component;

--Clock Signal
signal CLK : std_logic := '0';

--Testbed Signals
signal s_iCarry	: std_logic := '0';
signal s_iA	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00";
signal s_iB	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00";

signal s_oCarry	: std_logic := '0';
signal s_oSum	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00";

begin
	ADD: rippleAdder_n
	generic map (N => DATA_WIDTH)
	port map(
		i_Carry	=> s_iCarry,
		i_A	=> s_iA,
		i_B	=> s_iB,
		o_Carry => s_oCarry,
		o_Sum	=> s_oSum);

--Setup the test bench clock
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
		
	--Test Case 1: 1+1 =0
	s_iCarry <= '0';
	s_iA <= x"01";
	s_iB <= x"01";

	wait for gCLK_HPER*2;

	--Test Case 2: F+F = 1E
	s_iCarry <= '0';
	s_iA <= x"0F";
	s_iB <= x"0F";

	wait for gCLK_HPER*2;
	
	wait;
  end process;
end mixed;