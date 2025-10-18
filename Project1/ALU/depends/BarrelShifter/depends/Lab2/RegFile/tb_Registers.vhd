-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: mux32t1.vhd, RegisterDecoder.vhd, nBitRegister.vhd, array32.vhd
--Testbed for RISC-V Register system
--tb_registers.vhd
-------------------------------------------------------------------------
--9/15/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use ieee.numeric_std.all;
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

use work.array32.all;

entity tb_registers is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_registers;

architecture mixed of tb_registers is

	-- Define the total clock period time
	constant cCLK_PER  : time := gCLK_HPER * 2;

	--Component Interface
	component Registers is
		port(	
			clock	: in std_logic;
			reset	: in std_logic;
	
			RS1Sel	: in std_logic_vector(4 downto 0);
			RS1	: out std_logic_vector(31 downto 0);

			RS2Sel	: in std_logic_vector(4 downto 0);
			RS2	: out std_logic_vector(31 downto 0);

			WrEn	: in std_logic;
			RdSel	: in std_logic_vector(4 downto 0);
			Rd	: in std_logic_vector(31 downto 0));
	end component;

	signal CLK	: std_logic := '0';
	signal reset	: std_logic := '0';
	
	signal s_RS1Sel	: std_logic_vector(4 downto 0) := "00000";
	signal s_RS1	: std_logic_vector(31 downto 0) := x"00000000";
	
	signal s_RS2Sel	: std_logic_vector(4 downto 0) := "00000";
	signal s_RS2	: std_logic_vector(31 downto 0) := x"00000000";

	signal s_WrEn	: std_logic := '0';
	signal s_RdSel	: std_logic_vector(4 downto 0) := "00000";
	signal s_Rd	: std_logic_vector(31 downto 0) := x"00000000";

begin
	REGFILE: Registers
		port map(
			clock	=>	CLK,
			reset	=>	reset,
			RS1Sel	=>	s_RS1Sel,
			RS1	=>	s_RS1,
			RS2Sel	=>	s_RS2Sel,
			RS2	=>	s_RS2,
			WrEn	=>	s_WrEn,
			RdSel	=>	s_RdSel,
			Rd	=>	s_Rd);
  
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
  

P_TEST_CASES: process
  begin
	wait for gCLK_HPER/2; --Change inputs on clk midpoints

--Test Cases
--Set each Register to "0000FFFF" in turn (this should fail for reg 0)
	for i in 0 to 32 loop
		s_RdSel <= std_logic_vector(to_unsigned(i, 5));
		wait for gCLK_HPER;
		s_Rd	<= x"0000FFFF";
		s_WrEn	<= '1';
		wait for gCLK_HPER;
		s_WrEn	<= '0';
	end loop;
		
		
	wait;
end process;
end mixed;