-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Description: Instruction Iterator for a RISC_V processor

--BranchDecoder.vhd
-------------------------------------------------------------------------
--10/22/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity BranchDecoder is
  port(
        i_branchEn  : in std_logic;
        i_funct3    : in std_logic_vector(2 downto 0);

    --Flag inputs
        i_FlagZero  : in std_logic;
        i_FlagNeg   : in std_logic;

    --Outputs
        o_branch    : out std_logic);
end  BranchDecoder;

architecture dataflow of BranchDecoder is
    signal s_beq    : std_logic;
    signal s_bne    : std_logic;
    signal s_blt    : std_logic;
    signal s_bge    : std_logic;
    signal s_bltu   : std_logic;
    signal s_bgeu   : std_logic;

    signal s_active : std_logic;
begin

--Branch Signal Generation
    --If A-B == 0, A and B are equal
    s_beq <= '1' when i_FlagZero = '1' else
        '0';

    --If A-B != 0, A and B are not equal
    s_bne <= '1' when i_FlagZero = '0' else
        '0';

    --If A-B are negative, A is less than B
    s_blt <= '1' when i_FlagNeg = '1' else
        '0';

    --If A-B are not negative, A is >= B
    s_bge <= '1' when i_FlagNeg = '0' else
        '0';

    --Another Greater than branch, but with unsigned (handled elsewhere)
    s_bltu <= '1' when i_FlagNeg = '1' else
        '0';

    --Another less/equal branch, but with unsigned (handled elsewhere)
    s_bgeu <= '1' when i_FlagNeg = '0' else
        '0';

--Set s_active to the branch specified by funct3
with i_funct3 select s_active <=
        s_beq when "000",
        s_bne when "001",
        s_blt when "100",
        s_bge when "101",
        s_bltu when "110",
        s_bgeu when "111",
        '0' when others;

o_branch <= i_branchEn AND s_active;
end dataflow;
