library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_IsZero is
  generic(
    clock : time := 10 ns;
    WIDTH : integer := 32
  );
end tb_IsZero;

architecture behaviour of tb_IsZero is

    component IsZero is
        generic(
            WIDTH : integer := 32
        );
        port(
            i_Value : in std_logic_vector(WIDTH - 1 downto 0);
            o_IsZero : out std_logic := '0'
        );
    end component;

    signal s_Clock : std_logic;

    signal s_iInput : std_logic_vector(WIDTH - 1 downto 0);
    signal s_oIsZero : std_logic;

    signal s_testCase : integer := 0;

begin

    testbench : IsZero
        generic map(
            WIDTH       => WIDTH
        )
        port map(
            i_Value     => s_iInput,
            o_IsZero    => s_oIsZero
        );

    tests : process
    begin
        wait for (clock / 4);

        -- Base State --
        s_testCase <= 0;
        s_iInput <= x"00000000";
        wait for clock;
        assert s_oIsZero = '1' report "Invalid Base State" severity FAILURE;

        -- Test Case 1 --
        s_testCase <= 1;
        s_iInput <= x"00000001";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 1 Failed" severity FAILURE;

        -- Test Case 2 --
        s_testCase <= 2;
        s_iInput <= x"FFFFFFFF";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 2 Failed" severity FAILURE;

        -- Test Case 3 --
        s_testCase <= 3;
        s_iInput <= x"7FFFFFFF";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 3 Failed" severity FAILURE;

        -- Test Case 4 --
        s_testCase <= 4;
        s_iInput <= x"FFFFFFFE";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 3 Failed" severity FAILURE;

        -- Test Case 5 --
        s_testCase <= 5;
        s_iInput <= x"0F0F0F0F";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 5 Failed" severity FAILURE;

        -- Test Case 6 --
        s_testCase <= 6;
        s_iInput <= x"F0F0F0F0";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 6 Failed" severity FAILURE;

        -- Test Case 7 --
        s_testCase <= 7;
        s_iInput <= x"33333333";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 7 Failed" severity FAILURE;

        -- Test Case 8 --
        s_testCase <= 8;
        s_iInput <= x"CCCCCCCC";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 8 Failed" severity FAILURE;

        -- Test Case 9 --
        s_testCase <= 9;
        s_iInput <= x"99999999";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 9 Failed" severity FAILURE;

        -- Test Case 10 --
        s_testCase <= 10;
        s_iInput <= x"55555555";
        wait for clock;
        assert s_oIsZero = '0' report "Test Case 10 Failed" severity FAILURE;

        -- Test Case 11 --
        s_iInput <= x"00000000";
        wait for clock;
        assert s_oIsZero = '1' report "Test Case 11 Failed" severity FAILURE;

        wait;        
    end process ; -- tests


end behaviour ; -- behaviour
