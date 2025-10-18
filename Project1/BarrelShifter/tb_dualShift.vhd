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
        DATA_WIDTH  : integer := 32
    );
end tb_dualShift;

architecture mixed of tb_dualShift is

    component dualShift is
        generic(
            DATA_WIDTH  : positive;
            CNT_WIDTH   : positive
        );
        port(
            i_valueIn       : in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_shiftCount    : in std_logic_vector(CNT_WIDTH-1 downto 0); --The number of bits to be shifted
            i_arithmetic    : in std_logic; -- 0 for logical shift, 1 for arithmetic shift
            i_shiftLeft     : in std_logic; --0 for shift right, 1 for shift left
            o_valueOut      : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    signal CLK   : std_logic := '0';


    signal s_valIn     : std_logic_vector(31 downto 0);
    signal s_sCnt      : std_logic_vector(4 downto 0);
    signal s_arith     : std_logic;
    signal s_sLeft     : std_logic;
    signal s_valOut    : std_logic_vector(31 downto 0);

begin
    dShift: dualShift
        generic map(
            DATA_WIDTH  => 32,
            CNT_WIDTH   => 5
        )
        port map(
            i_valueIn       => s_valIn,
            i_shiftCount    => s_sCnt,
            i_arithmetic    => s_arith,
            i_shiftLeft     => s_sLeft,
            o_valueOut      => s_valOut
        );

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

        -- Base State
        s_valIn <= x"00000000";
        s_sCnt  <= b"00000";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000000" report "Invalid Base State" severity FAILURE;

        -- Test Case 1
        s_valIn <= x"0000000F";
        s_sCnt  <= b"00100";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000000" report "Test Case 1 Failed" severity FAILURE;

        -- Test Case 2
        s_valIn <= x"0000000F";
        s_sCnt  <= b"00100";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"000000F0" report "Test Case 2 Failed" severity FAILURE;

        -- Test Case 3
        s_valIn <= x"0000000F";
        s_sCnt  <= b"11111";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"80000000" report "Test Case 3 Failed" severity FAILURE;

        -- Test Case 4
        s_valIn <= x"80000000";
        s_sCnt  <= b"00001";
        s_arith <=  '1';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"C0000000" report "Test Case 4 Failed" severity FAILURE;

        -- Test Case 5
        s_valIn <= x"F0000000";
        s_sCnt  <= b"00100";
        s_arith <=  '1';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"FF000000" report "Test Case 5 Failed" severity FAILURE;

        -- Test Case 6
        s_valIn <= x"70000000";
        s_sCnt  <= b"00100";
        s_arith <=  '1';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"07000000" report "Test Case 6 Failed" severity FAILURE;

        -- Test Case 7
        s_valIn <= x"00000001";
        s_sCnt  <= b"00001";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000002" report "Test Case 7 Failed" severity FAILURE;

        -- Test Case 8
        s_valIn <= x"00000001";
        s_sCnt  <= b"00010";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000004" report "Test Case 8 Failed" severity FAILURE;

        -- Test Case 9
        s_valIn <= x"00000001";
        s_sCnt  <= b"00011";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000008" report "Test Case 9 Failed" severity FAILURE;

        -- Test Case 10
        s_valIn <= x"00000001";
        s_sCnt  <= b"00100";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000010" report "Test Case 10 Failed" severity FAILURE;

        -- Test Case 11
        s_valIn <= x"80000000";
        s_sCnt  <= b"00001";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"40000000" report "Test Case 11 Failed" severity FAILURE;

        -- Test Case 12
        s_valIn <= x"80000000";
        s_sCnt  <= b"00010";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"20000000" report "Test Case 12 Failed" severity FAILURE;

        -- Test Case 13
        s_valIn <= x"80000000";
        s_sCnt  <= b"00011";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"10000000" report "Test Case 13 Failed" severity FAILURE;

        -- Test Case 14
        s_valIn <= x"80000000";
        s_sCnt  <= b"00100";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"08000000" report "Test Case 14 Failed" severity FAILURE;

        -- Test Case 15
        s_valIn <= x"000FF000";
        s_sCnt  <= b"00100";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00FF0000" report "Test Case 15 Failed" severity FAILURE;

        -- Test Case 16
        s_valIn <= x"000FF000";
        s_sCnt  <= b"01000";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"0FF00000" report "Test Case 16 Failed" severity FAILURE;

        -- Test Case 17
        s_valIn <= x"000FF000";
        s_sCnt  <= b"01100";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"FF000000" report "Test Case 17 Failed" severity FAILURE;

        -- Test Case 18
        s_valIn <= x"000FF000";
        s_sCnt  <= b"10000";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"F0000000" report "Test Case 18 Failed" severity FAILURE;

        -- Test Case 19
        s_valIn <= x"000FF000";
        s_sCnt  <= b"10100";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000000" report "Test Case 19 Failed" severity FAILURE;

        -- Test Case 20
        s_valIn <= x"80000000";
        s_sCnt  <= b"00100";
        s_arith <=  '1';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"F8000000" report "Test Case 20 Failed" severity FAILURE;

        -- Test Case 21
        s_valIn <= x"80000000";
        s_sCnt  <= b"11111";
        s_arith <=  '1';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"FFFFFFFF" report "Test Case 21 Failed" severity FAILURE;

        -- Test Case 22
        s_valIn <= x"80000000";
        s_sCnt  <= b"11111";
        s_arith <=  '0';
        s_sLeft <=  '0';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"00000001" report "Test Case 22 Failed" severity FAILURE;

        -- Test Case 23
        s_valIn <= x"00000001";
        s_sCnt  <= b"11111";
        s_arith <=  '0';
        s_sLeft <=  '1';
        wait for (gCLK_HPER * 2);
        assert s_valOut = x"80000000" report "Test Case 23 Failed" severity FAILURE;

        wait;
    end process;
end mixed;
