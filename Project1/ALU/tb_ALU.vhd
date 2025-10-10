library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
    generic(
        clock : time := 10 ns
    );
end tb_ALU;

architecture behaviour of tb_ALU is

    component ALU is
        port(
            i_A         : in  std_logic_vector(31 downto 0);
            i_B         : in  std_logic_vector(31 downto 0);
            i_Sub       : in  std_logic;
            o_Result    : out std_logic_vector(31 downto 0);
            f_Zero      : out std_logic;
            f_Overflow  : out std_logic;
            f_Negative  : out std_logic
        );
    end component;
    
    signal s_iA         : std_logic_vector(31 downto 0);
    signal s_iB         : std_logic_vector(31 downto 0);
    signal s_iSub       : std_logic;
    signal s_oResult    : std_logic_vector(31 downto 0);
    signal s_fZero      : std_logic;
    signal s_fOverflow  : std_logic;
    signal s_fNegative  : std_logic;

begin

    testbench : ALU
        port map(
            i_A         => s_iA,
            i_B         => s_iB,
            i_Sub       => s_iSub,
            o_Result    => s_oResult,
            f_Zero      => s_fZero,
            f_Overflow  => s_fOverflow,
            f_Negative  => s_fNegative
        );

    tests : process
    begin
        wait for (clock / 4);

        -- Base State
        s_iA    <= x"00000000";
        s_iB    <= x"00000000";
        s_iSub  <= '0';
        wait for clock;
        assert s_oResult    = x"00000000"   report "Invalid Base State" severity FAILURE;
        assert s_fZero      = '0'           report "Invalid Base State" severity FAILURE;
        assert s_fOverflow  = '0'           report "Invalid Base State" severity FAILURE;
        assert s_fNegative  = '0'           report "Invalid Base State" severity FAILURE;

        wait;
    end process; -- tests

end behaviour; -- behaviour
