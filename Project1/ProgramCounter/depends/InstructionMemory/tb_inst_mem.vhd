library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_inst_mem is
    generic(
        clock : time := 10 ns;

		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
    );
end tb_inst_mem;

architecture behaviour of tb_inst_mem is

    component inst_mem is
        generic(
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
        port(
            i_clk   : in std_logic;
            i_num   : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            o_inst  : out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    signal s_clk : std_logic;

    signal s_inum : std_logic_vector((ADDR_WIDTH-1) downto 0);
    signal s_oinst : std_logic_vector((DATA_WIDTH -1) downto 0);

begin

    testbench : inst_mem
        generic map(
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map(
            i_clk  => s_clk,
            i_num  => s_inum,
            o_inst => s_oinst
        );

    p_clock : process
    begin
        wait for clock / 2;
        s_clk <= '0';

        wait for clock / 2;
        s_clk <= '1';

    end process; -- p_clock

    tests : process
    begin
        wait for (clock / 4);

        -- Base State -- 
        s_inum <= b"0000000000";
        wait for clock;
        assert s_oinst = x"00000000" report "Invalid Base State" severity FAILURE;

        -- Test Case 1 -- 
        s_inum <= b"0000000001";
        wait for clock;
        assert s_oinst = x"00000123" report "Test Case 1 Failed" severity FAILURE;

        -- Test Case 2 -- 
        s_inum <= b"0000000010";
        wait for clock;
        assert s_oinst = x"00000456" report "Test Case 2 Failed" severity FAILURE;

        -- Test Case 3 -- 
        s_inum <= b"0000000011";
        wait for clock;
        assert s_oinst = x"00000000" report "Test Case 3 Failed" severity FAILURE;

        -- Test Case 4 -- 
        s_inum <= b"0000000100";
        wait for clock;
        assert s_oinst = x"00000101" report "Test Case 4 Failed" severity FAILURE;

        -- Test Case 5 -- 
        s_inum <= b"0000000101";
        wait for clock;
        assert s_oinst = x"00000050" report "Test Case 5 Failed" severity FAILURE;

        -- Test Case 6 -- 
        s_inum <= b"0000000110";
        wait for clock;
        assert s_oinst = x"00000000" report "Test Case 6 Failed" severity FAILURE;
        
        wait;
    end process; -- tests

end behaviour ; -- behaviour
