-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: DFmux2t1.vhd
--Right Barrel Shifter Testbed
--tb_rbshift.vhd
-------------------------------------------------------------------------
--10/16/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library std;
use std.textio.all;             -- For basic I/O

entity tb_rbshift is
    generic(
        gCLK_HPER   : time := 10 ns;
        DATA_WIDTH  : integer := 32);
end tb_rbshift;

architecture mixed of tb_rbshift is

    component rbshift is
        generic(DATA_WIDTH  : positive;
                CNT_WIDTH   : positive);
        port(
            i_valIn     : in std_logic_vector(31 downto 0);
            i_sCnt      : in std_logic_vector(4 downto 0);
            o_valOut    : out std_logic_vector(31 downto 0));
    end component;

    signal CLK   : std_logic := '0';


    signal s_valIn     : std_logic_vector(31 downto 0);
    signal s_sCnt      : std_logic_vector(4 downto 0);
    signal s_valOut    : std_logic_vector(31 downto 0);

    
begin
    rShifter: rbshift
        generic map(DATA_WIDTH  => 32,
                    CNT_WIDTH   => 5)
        port map(
            i_valIn     => s_valIn,
            i_sCnt      => s_sCnt,
            o_valOut    => s_valOut);

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
    s_valIn     <= std_logic_vector(to_unsigned(25, 32));
    s_sCnt    <= std_logic_vector(to_unsigned(2, 5));

    wait;
    end process;
end mixed;