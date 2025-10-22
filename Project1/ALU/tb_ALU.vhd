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
            i_ModSel : in std_logic_vector(1 downto 0);
    
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
    signal s_iModSel    : std_logic_vector(1 downto 0);
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
        s_iOutSel    <= '0';
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Invalid Base State (a)" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Invalid Base State (b)" severity FAILURE;
        assert s_fovflw     = '0'           report "Invalid Base State (c)" severity FAILURE;
        assert s_fzero      = '1'           report "Invalid Base State (d)" severity FAILURE;
        assert s_fnegative  = '0'           report "Invalid Base State (e)" severity FAILURE;

                                --------------------
                                --- AddSub Tests ---
                                --------------------
        -- Test Case 1
        s_iA         <= x"00000001";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 1a Failed" severity WARNING;
        assert s_ooutput    = x"00000001"   report "Test 1b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 1c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 1d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 1e Failed" severity FAILURE;

        -- Test Case 2
        s_iA         <= x"00000000";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"00";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 2a Failed" severity WARNING;
        assert s_ooutput    = x"00000001"   report "Test 2b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 2c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 2d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 2e Failed" severity FAILURE;

        -- Test Case 3
        s_iA         <= x"00000001";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"00";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 3a Failed" severity WARNING;
        assert s_ooutput    = x"00000002"   report "Test 3b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 3c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 3d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 3e Failed" severity FAILURE;

        -- Test Case 4
        s_iA         <= x"00000001";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"01";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 4a Failed" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Test 4b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 4c Failed" severity FAILURE;
        assert s_fzero      = '1'           report "Test 4d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 4e Failed" severity FAILURE;

        -- Test Case 5
        s_iA         <= x"80000000";
        s_iB         <= x"80000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 5a Failed" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Test 5b Failed" severity FAILURE;
        assert s_fovflw     = '1'           report "Test 5c Failed" severity FAILURE;
        assert s_fzero      = '1'           report "Test 5d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 5e Failed" severity FAILURE;

        -- Test Case 6
        s_iA         <= x"00000000";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"01";
        s_iOutSel    <= c_AddSubOutSel;
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 6a Failed" severity WARNING;
        assert s_ooutput    = x"FFFFFFFF"   report "Test 6b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 6c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 6d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 6e Failed" severity FAILURE;

                                ----------------------------
                                --- Barell Shifter Tests ---
                                ----------------------------

        -- Base State
        s_iA         <= x"00000000";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Invalid Base State (a)" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Invalid Base State (b)" severity FAILURE;
        assert s_fovflw     = '0'           report "Invalid Base State (c)" severity FAILURE;
        assert s_fzero      = '1'           report "Invalid Base State (d)" severity FAILURE;
        assert s_fnegative  = '0'           report "Invalid Base State (e)" severity FAILURE;

        -- Test Case 7
        s_iA         <= x"00000001";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 7a Failed" severity WARNING;
        assert s_ooutput    = x"00000001"   report "Test 7b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 7c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 7d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 7e Failed" severity FAILURE;

        -- Test Case 8
        s_iA         <= x"00000001";
        s_iB         <= x"00000004";
        s_iOppSel    <= b"10";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 8a Failed" severity WARNING;
        assert s_ooutput    = x"00000010"   report "Test 8b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 8c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 8d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 8e Failed" severity FAILURE;

        -- Test Case 9
        s_iA         <= x"00000001";
        s_iB         <= x"00000008";
        s_iOppSel    <= b"10";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 9a Failed" severity WARNING;
        assert s_ooutput    = x"00000100"   report "Test 9b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 9c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 9d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 9e Failed" severity FAILURE;

        -- Test Case 10
        s_iA         <= x"80000000";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 10a Failed" severity WARNING;
        assert s_ooutput    = x"C0000000"   report "Test 10b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 10c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 10d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 10e Failed" severity FAILURE;

        -- Test Case 11
        s_iA         <= x"80000000";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 11a Failed" severity WARNING;
        assert s_ooutput    = x"C0000000"   report "Test 11b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 11c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 11d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 11e Failed" severity FAILURE;

        wait;
    end process;

end behaviour;
