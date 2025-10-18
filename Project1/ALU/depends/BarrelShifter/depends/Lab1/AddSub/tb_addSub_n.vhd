-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------


-- tb_addSub_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains testbed for an adder/subtractor

--Dependencies: tb_addSub_n.vhd

--9/6/25 by JAG: Initially Created
-------------------------------------------------------------------------

--Library Declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_addSub_n is
  generic(gCLK_HPER   : time := 10 ns;   -- Generic for half of the clock cycle period
          DATA_WIDTH  : integer := 32); 
end tb_addSub_n;

architecture mixed of tb_addSub_n is

component addSub_n is
	generic(Comp_Width : integer);
	port(	nAdd_Sub	: in std_logic;
		i_A		: in std_logic_vector(Comp_Width-1 downto 0);
		i_B		: in std_logic_vector(Comp_Width-1 downto 0);
		o_overflow	: out std_logic;
		o_Sum		: out std_logic_vector(Comp_Width-1 downto 0));
end component;
	
--Clock Signal
signal CLK : std_logic := '0';

--Testbed Signals
signal s_nAdd_Sub	: std_logic := '0';
signal s_iA		: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
signal s_iB		: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";
signal s_overflow		: std_logic := '0';
signal s_oSum		: std_logic_vector(DATA_WIDTH-1 downto 0) := x"00000000";

begin 
	ADD: addSub_n
	generic map (Comp_Width => DATA_WIDTH)
	port map(
		nAdd_Sub	=> s_nAdd_Sub,
		i_A		=> s_iA,
		i_B		=> s_iB,
		o_overflow	=> s_overflow,
		o_Sum		=> s_oSum);

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

	--Test Case 1: 7+7=E (14)
	s_nAdd_Sub	<= '0';
	s_iA		<= x"00000007";
	s_iB		<= x"00000007";
	
	wait for gCLK_HPER*2;

	--Test Case 1: -7 +7 = 0
	s_nAdd_Sub	<= '0';
	s_iA		<= x"FFFFFFF9";
	s_iB		<= x"00000007";
	
	wait for gCLK_HPER*2;
	
	--Test Case 2: D(13)-8 = 5
	s_nAdd_Sub	<= '1';
	s_iA		<= x"0000000D";
	s_iB		<= x"00000008";
	
	wait for gCLK_HPER*2;

	--Test Case 3: Upper Overflow
	s_nAdd_Sub	<= '0';
	s_iA		<= x"7FFFFFFF";
	s_iB		<= x"7FFFFFFF";
	
	wait for gCLK_HPER*2;

wait;
end process;
	

end mixed;