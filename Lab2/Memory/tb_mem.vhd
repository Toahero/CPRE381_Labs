-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: Datapath1.vhd
--Testbed for the first datapath
--tb_mem.vhd
-------------------------------------------------------------------------
--9/21/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use ieee.numeric_std.all;
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mem is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_mem;

architecture mixed of tb_mem is

	constant cCLK_PER  : time := gCLK_HPER * 2;

	component mem is
		generic( 	DATA_WIDTH : natural; 
				ADDR_WIDTH: natural);
		port(	clk		: in std_logic;
			addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
			we		: in std_logic := '1';
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
	end component;

signal CLK	:  std_logic := '0';
signal s_addr	:  std_logic_vector(9 downto 0) := "0000000000";
signal s_data	:  std_logic_vector(31 downto 0):= x"00000000";
signal s_we	:  std_logic := '0';
signal s_q	:  std_logic_vector(31 downto 0):= x"00000000";

begin
	dmem: mem
		generic map(	DATA_WIDTH	=> 32, 
				ADDR_WIDTH => 10)
		port map(
			CLK	=> clk,
			addr	=> s_addr,
			data	=> s_data,
			we	=> s_we,
			q	=> s_q);

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

	for i in 0 to 9 loop
		--Read each of the initial 10 values
		s_addr	<= std_logic_vector(to_unsigned(i, 10));
		wait for gCLK_HPER;
	end loop;

wait;
end process;
end mixed;