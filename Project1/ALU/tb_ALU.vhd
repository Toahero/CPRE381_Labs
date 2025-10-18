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
            i_A : in std_logic_vector(31 downto 0);
            i_B : in std_logic_vector(31 downto 0);
    
            i_OutSel : in std_logic;
            i_ModSel : in std_logic;
    
            i_OppSel : in std_logic_vector(1 downto 0);
    
            o_Result : out std_logic_vector(31 downto 0);
            o_output : out std_logic_vector(31 downto 0);
    
            f_ovflw : out std_logic;
            f_zero : out std_logic;
            f_negative : out std_logic
        );
    end component;

    signal s_Clock      : std_logic;

    signal s_iA         : std_logic_vector(31 downto 0);
    signal s_iB         : std_logic_vector(31 downto 0);
    signal s_iOutSel    : std_logic;
    signal s_iModSel    : std_logic;
    signal s_iOppSel    : std_logic_vector(1 downto 0);
    signal s_oResult    : std_logic_vector(31 downto 0);
    signal s_ooutput    : std_logic_vector(31 downto 0);
    signal s_fovflw     : std_logic;
    signal s_fzero      : std_logic;
    signal s_fnegative  : std_logic;

    constant c_AddSubOutSel : std_logic := '0';
    constant c_BarellShifterOut : std_logic := '1';

begin

    testbench : ALU
        port map(
            i_A         => s_iA         ,
            i_B         => s_iB         ,
            i_OutSel    => s_iOutSel    ,
            i_ModSel    => s_iModSel    ,
            i_OppSel    => s_iOppSel    ,
            o_Result    => s_oResult    ,
            o_output    => s_ooutput    ,
            f_ovflw     => s_fovflw     ,
            f_zero      => s_fzero      ,
            f_negative  => s_fnegative   
        );

    p_clock : process
    begin
        wait for (clock / 2);
        s_Clock <= '0';

        wait for (clock / 2);
        s_Clock <= '1';
    end process;

    tests : process
    begin
        wait for (clock / 4);
        
        -- Base State
        s_iA         <= x"00000000";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= '0';
        wait for clock;
        assert s_oResult    = x"00000000"   report "Invalid Base State" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Invalid Base State" severity FAILURE;
        assert s_fovflw     = '0'           report "Invalid Base State" severity FAILURE;
        assert s_fzero      = '1'           report "Invalid Base State" severity FAILURE;
        assert s_fnegative  = '0'           report "Invalid Base State" severity FAILURE;

        wait;
    end process;

end behaviour ; -- behaviour

