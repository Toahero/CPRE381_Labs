-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: Datapath1.vhd
--Testbed for the first datapath
--tb_Datapath1.vhd
-------------------------------------------------------------------------
--9/20/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use ieee.numeric_std.all;
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_Datapath1 is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 32);   -- Generic for half of the clock cycle period
end tb_Datapath1;

architecture mixed of tb_Datapath1 is

	constant cCLK_PER  : time := gCLK_HPER * 2;

	component Datapath1 is
	port(	clock	: in std_logic;
		reset	: in std_logic;
		
		ALUSrc	: in std_logic;
		ValIn	: in std_logic_vector(31 downto 0);

		AddSub	: in std_logic;

		WrEn	: in std_logic;
		Rd	: in std_logic_vector(4 downto 0);
	
		RS1	: in std_logic_vector(4 downto 0);
		RS2	: in std_logic_vector(4 downto 0));

	end component;

	signal CLK	: std_logic := '0';
	signal reset	: std_logic := '0';
		
	signal s_ALUSrc	: std_logic := '0';
	signal s_ValIn	: std_logic_vector(31 downto 0) := x"00000000";

	signal s_AddSub	: std_logic := '0';

	signal s_WrEn	: std_logic := '0';
	signal s_Rd	: std_logic_vector(4 downto 0) := "00000";
	
	signal s_RS1	: std_logic_vector(4 downto 0) := "00000";
	signal s_RS2	: std_logic_vector(4 downto 0) := "00000";
begin
	DATAFILE: Datapath1
		port map(
			clock	=> CLK,
			reset	=> reset,
			ALUSrc	=> s_ALUSrc,
			ValIn	=> s_ValIn,
			AddSub	=> s_AddSub,
			WrEn	=> s_WrEn,
			Rd	=> s_Rd,
			RS1	=> s_RS1,
			RS2	=> s_RS2);

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
	wait for gCLK_HPER*3; --Wait for reset to finish
	wait for gCLK_HPER/2; --Change inputs on clk midpoints

--Test Cases

	for i in 1 to 10 loop
		--For Registers 1 to 10, set each to its register number
		s_ALUSrc 	<= '1';
		s_AddSub	<= '0';
		s_Rd		<= std_logic_vector(to_unsigned(i, 5));
		s_RS1		<= std_logic_vector(to_unsigned(0, 5));
		s_ValIn		<= std_logic_vector(to_signed(i, 32));
		--Enable for one clock cycle
		s_WrEn		<= '1';
		wait for gCLK_HPER;
		s_WrEn		<= '0';
		wait for gCLK_HPER;
	end loop;

--Math 1: add 11, 1, 2 (1+2 = 3)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(11, 5));
	s_RS1		<= std_logic_vector(to_unsigned(1, 5));
	s_RS2		<= std_logic_vector(to_unsigned(2, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 2: sub 12, 11, 3 (3-3 = 0)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '1';
	s_Rd		<= std_logic_vector(to_unsigned(12, 5));
	s_RS1		<= std_logic_vector(to_unsigned(11, 5));
	s_RS2		<= std_logic_vector(to_unsigned(3, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 3: add 13, 12, 4 (0+4 = 4)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(13, 5));
	s_RS1		<= std_logic_vector(to_unsigned(12, 5));
	s_RS2		<= std_logic_vector(to_unsigned(4, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 4: sub 14, 13, 5 (4-5 = -1)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '1';
	s_Rd		<= std_logic_vector(to_unsigned(14, 5));
	s_RS1		<= std_logic_vector(to_unsigned(13, 5));
	s_RS2		<= std_logic_vector(to_unsigned(5, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 5: add 15, 14, 6 (-1+6 = 5)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(15, 5));
	s_RS1		<= std_logic_vector(to_unsigned(14, 5));
	s_RS2		<= std_logic_vector(to_unsigned(6, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 6: sub 16, 15, 7 (5-7 = -2)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '1';
	s_Rd		<= std_logic_vector(to_unsigned(16, 5));
	s_RS1		<= std_logic_vector(to_unsigned(15, 5));
	s_RS2		<= std_logic_vector(to_unsigned(7, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 7: add 17, 16, 8 (-2+8 = 6)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(17, 5));
	s_RS1		<= std_logic_vector(to_unsigned(16, 5));
	s_RS2		<= std_logic_vector(to_unsigned(8, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 8: sub 18, 17, 9 (6-9 = -3)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '1';
	s_Rd		<= std_logic_vector(to_unsigned(18, 5));
	s_RS1		<= std_logic_vector(to_unsigned(17, 5));
	s_RS2		<= std_logic_vector(to_unsigned(9, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 9: add 19, 18, 10 (-3+10 = 7)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(19, 5));
	s_RS1		<= std_logic_vector(to_unsigned(18, 5));
	s_RS2		<= std_logic_vector(to_unsigned(10, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Place -35 in 20 (addi 20, 0, -35)
	s_ALUSrc 	<= '1';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(20, 5));
	s_RS1		<= std_logic_vector(to_unsigned(0, 5));
	s_ValIn		<= std_logic_vector(to_signed(-35, 32));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

--Math 10: add 21, 19, 20 (7+-35 = -28)
	s_ALUSrc 	<= '0';
	s_AddSub	<= '0';
	s_Rd		<= std_logic_vector(to_unsigned(21, 5));
	s_RS1		<= std_logic_vector(to_unsigned(19, 5));
	s_RS2		<= std_logic_vector(to_unsigned(20, 5));
	--Enable for one clock cycle
	s_WrEn		<= '1';
	wait for gCLK_HPER;
	s_WrEn		<= '0';
	wait for gCLK_HPER;

wait;
end process;
end mixed;