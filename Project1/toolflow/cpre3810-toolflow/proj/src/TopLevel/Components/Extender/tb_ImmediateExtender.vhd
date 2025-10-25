-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: a testbed for a RISCV immediate extender

-- tb_ImmediateExtender.vhd
-------------------------------------------------------------------------
--10/24/25 by JAG: Initially Created
-------------------------------------------------------------------------
-- library declaration

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ImmediateExtender is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_ImmediateExtender;

architecture testbed of tb_ImmediateExtender is

    component ImmediateExtender is
        port(   i_instruction   : in std_logic_vector(31 downto 0);
                o_output        : out std_logic_vector(31 downto 0));
    end component;

    signal CLK              : std_logic;
    signal s_instruction    : std_logic_vector(31 downto 0);
    signal s_immediate      : std_logic_vector(31 downto 0);

begin
    ComponentUnderTest: ImmediateExtender
    port map(   i_instruction => s_instruction,
                o_output        => s_immediate);
    
    
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

--Instruction 1: Addi, Imm = 1
s_instruction <= x"00100093";
wait for gCLK_HPER;

--Instruction 2: Addi, Imm = 2
s_instruction <= x"00200113";
wait for gCLK_HPER;

--Instruction 3: Addi, Imm = 3
s_instruction <= x"00300193";
wait for gCLK_HPER;


--Instruction 4: Addi, Imm = -16
s_instruction <= x"FF060513";
wait for gCLK_HPER;

--Instruction 5: SW, Imm = 6
s_instruction <= x"00742323";
wait for gCLK_HPER;

--Instruction 6: beq, Imm = -8
s_instruction <= x"FE211CE3";
wait for gCLK_HPER;


    wait;
    end process;
end testbed;