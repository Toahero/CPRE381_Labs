-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: dffg.vhd

-- tb_nBitRegister.vhd
-------------------------------------------------------------------------
--9/11/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_nBitRegister is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_nBitRegister;

architecture mixed of tb_nBitRegister is

	-- Define the total clock period time
	constant cCLK_PER  : time := gCLK_HPER * 2;

	--Component Interface
	component nBitRegister is
		generic(Reg_Size : integer := 32);
		port(   i_CLK  	: in std_logic;
            		i_reset	: in std_logic;
            		i_WrEn	: in std_logic;
            		i_write	: in std_logic_vector(Reg_Size-1 downto 0);
            		o_read 	: out std_logic_vector(Reg_Size-1 downto 0));

	end component;

	signal CLK, reset	: std_logic := '0';

	
	signal s_WrEn	: std_logic := '0';
	signal s_write	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
	signal s_read	: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";

begin
  DUT0: nBitRegister
  generic map (Reg_Size => DATA_WIDTH)
  port map(
            i_CLK	=> CLK,
            i_reset	=> reset,
            i_WrEn	=> s_WrEn,
            i_write	=> s_write,
            o_read	=> s_read);

  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  

-- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges
	
	--Test Case 1 -Test Loading the register
	s_WrEn <= '1';
	s_write <= x"FFFFFFFF";

	wait for gCLK_HPER*2;

	wait;
end process;

end mixed;