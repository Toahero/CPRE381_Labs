-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: DFmux2t1.vhd
--Right Barrel Shifter Testbed
--tb_dualShift.vhd
-------------------------------------------------------------------------
--10/16/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library std;
use std.textio.all;             -- For basic I/O

entity tb_dualShift is
    generic(
        gCLK_HPER   : time := 10 ns;
        DATA_WIDTH  : integer := 32);
end tb_dualShift;

architecture mixed of tb_dualShift is

    component dualShift is
        generic(DATA_WIDTH  : positive;
                CNT_WIDTH   : positive);
        port(
            i_valueIn       : in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_shiftCount    : in std_logic_vector(CNT_WIDTH-1 downto 0); --The number of bits to be shifted
            i_arithmetic       : in std_logic; -- 0 for logical shift, 1 for arithmetic shift
            i_shiftLeft     : in std_logic; --0 for shift right, 1 for shift left
            o_valueOut      : out std_logic_vector(DATA_WIDTH-1 downto 0));
    end component;

    signal CLK   : std_logic := '0';


    signal s_valIn     : std_logic_vector(31 downto 0);
    signal s_sCnt      : std_logic_vector(4 downto 0);
    signal s_arith      : std_logic;
    signal s_sLeft     : std_logic;
    signal s_valOut    : std_logic_vector(31 downto 0);

    
begin
    dShift: dualShift
        generic map(DATA_WIDTH  => 32,
                    CNT_WIDTH   => 5)
        port map(
            i_valueIn       => s_valIn,
            i_shiftCount    => s_sCnt,
            i_arithmetic    => s_arith,
            i_shiftLeft     => s_sLeft,
            o_valueOut      => s_valOut);

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
    s_arith     <= '0';
    s_valIn     <= std_logic_vector(to_unsigned(25, 32));
    s_sCnt    <= std_logic_vector(to_unsigned(2, 5));
    s_sLeft     <= '0';
    wait for gCLK_HPER/2; 
    s_sCnt    <= std_logic_vector(to_unsigned(0, 5));
    wait for gCLK_HPER/2; 
    s_sLeft     <= '1';
    s_sCnt    <= std_logic_vector(to_unsigned(2, 5));
    wait;
    end process;
end mixed;