-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Description: Testbed for branch decoder

--tb_BranchDecoder.vhd
-------------------------------------------------------------------------
--10/22/25 by JAG: Initially Created
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_BranchDecoder is
    generic(gCLK_HPER   : time := 10 ns);
end tb_BranchDecoder;

architecture mixed of tb_BranchDecoder is

component BranchDecoder is
  port(
        i_branchEn  : in std_logic;
        i_funct3    : in std_logic_vector(2 downto 0);

    --Flag inputs
        i_FlagZero  : in std_logic;
        i_FlagNeg   : in std_logic;

    --Outputs
        o_branch    : out std_logic);
end component;

signal CLK  : std_logic := '0';

signal s_branchEn   : std_logic := '0';
signal s_funct3     : std_logic_vector(2 downto 0) := "000";
signal s_FlagZero   : std_logic := '0';
signal s_FlagNeg    : std_logic := '0';
signal s_branch     : std_logic := '0';

begin

    DECODER: BranchDecoder
        port map(
            i_branchEn  => s_branchEn,
            i_funct3    => s_funct3,
            i_FlagZero  => s_FlagZero,
            i_FlagNeg   => s_FlagNeg,
            o_branch    => s_branch);

P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


P_TEST_InstructionS: process
begin
    wait for gCLK_HPER/2; --Change inputs on clk midpoints
    
    --TEST beq 1
    s_funct3   <= "000";
    s_branchEn <= '1';
    s_FlagZero <= '1';
    wait for gCLK_HPER;
    assert s_branch = '1' report "beq test 1 Failed" severity FAILURE;

  --TEST beq 2
    s_funct3   <= "000";
    s_branchEn <= '0';
    s_FlagZero <= '1';
    wait for gCLK_HPER;
    assert s_branch = '0' report "beq test 2 Failed" severity FAILURE;

      --TEST beq 3
    s_funct3   <= "000";
    s_branchEn <= '0';
    s_FlagZero <= '0';
    wait for gCLK_HPER;
    assert s_branch = '0' report "beq test 3 Failed" severity FAILURE;

    --TEST bne 1
    s_branchEn <= '1';
    s_funct3   <= "001";
    s_FlagZero <= '0';
    wait for gCLK_HPER;
    assert s_branch = '1' report "bne test 1 Failed" severity FAILURE;

    wait;
end process;
end mixed;