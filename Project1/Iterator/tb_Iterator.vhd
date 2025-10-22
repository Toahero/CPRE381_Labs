-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: addSub_n.vhd, mux2t1_N.vhd, BranchDecoder.vhd
--Description: Instruction Iterator for a RISC_V processor

--tb_Iterator.vhd
-------------------------------------------------------------------------
--10/22/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_Iterator is
    generic(gCLK_HPER   : time := 10 ns; );
end tb_Iterator;

architecture mixed of tb_Iterator is
    component Iterator is
        generic(DATA_WIDTH: integer);
        port(
        i_instrNum  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_OffsetCnt : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_branch    : in std_logic;
        i_jump      : in std_logic;
        o_nextInst  : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
  end component;

signal CLK  : std_logic := '0';
signal s_instrNum   : std_logic_vector(31 downto 0);
signal s_OffsetCnt  : std_logic_vector(31 downto 0);
signal s_branch     : std_logic;
signal s_jump       : std_logic;
signal s_nextInst   : std_logic_vector(31 downto 0);

begin
    g_Iterator: Iterator
        generic map(DATA_WIDTH <= 31)
        port map(   i_instrNum <= s_instrNum,
                    i_OffsetCnt <= s_OffsetCnt,
                    i_branch    <= s_branch,
                    i_jump      <= s_jump,
                    o_nextInst <= s_nextInst);

P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

P_TEST_Instructions: process
begin
	wait for gCLK_HPER/2; --Change inputs on clk midpoints
    