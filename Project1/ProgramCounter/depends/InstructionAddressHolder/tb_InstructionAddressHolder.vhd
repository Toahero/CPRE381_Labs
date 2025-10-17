library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_InstructionAddressHolder is
    generic(
        clock : time := 10 ns;
        ADDR_WIDTH : integer := 12        
    );
end tb_InstructionAddressHolder;

architecture behaviour of tb_InstructionAddressHolder is

    component InstructionAddressHolder is
        generic(
            ADDR_WIDTH : integer := 12
        );
        port(
            i_Clock : in std_logic;
            i_Reset : in std_logic;
            i_NextInstructionAddress : in std_logic_vector((ADDR_WIDTH - 1) downto 0);
            o_CurrentInstructionAddress : out std_logic_vector((ADDR_WIDTH - 1) downto 0)
        );
    end component;

    signal s_iClock : std_logic;
    signal s_iReset : std_logic;
    signal s_iNextInstructionAddress : std_logic_vector((ADDR_WIDTH - 1) downto 0);
    signal s_oCurrentInstructionAddress : std_logic_vector((ADDR_WIDTH - 1) downto 0);

begin

    p_clock : process
    begin
        wait for (clock / 2);
        s_iClock <= '0';

        wait for (clock / 2);
        s_iClock <= '1';
    end process;

    testbench : InstructionAddressHolder
        generic map(
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map(
            i_Clock => s_iClock,
            i_Reset => s_iReset,
            i_NextInstructionAddress => s_iNextInstructionAddress,
            o_CurrentInstructionAddress => s_oCurrentInstructionAddress
        );

    tests : process
    begin
        wait for (clock / 4);

        -- Base State
        s_iReset                    <= '0';
        s_iNextInstructionAddress   <= x"000";
        wait for clock;
        assert s_oCurrentInstructionAddress = x"000" report "Invalid Base State" severity FAILURE;

        -- Test Case 1
        s_iReset                    <= '1';
        s_iNextInstructionAddress   <= x"000";
        wait for (clock / 10);
        s_iReset                    <= '0';
        assert s_oCurrentInstructionAddress = x"BEE" report "Test Case 1 Failed" severity FAILURE;

        -- Test Case 2
        s_iReset                    <= '0';
        s_iNextInstructionAddress   <= x"CAD";
        wait for clock;
        assert s_oCurrentInstructionAddress = x"CAD" report "Test Case 2 Failed" severity FAILURE;

        -- Test Case 3
        s_iReset                    <= '0';
        s_iNextInstructionAddress   <= x"000";
        wait for (clock / 10);
        assert s_oCurrentInstructionAddress = x"CAD" report "Test Case 3 Failed" severity FAILURE;

        wait;
    end process;

end behaviour;
