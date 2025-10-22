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
    signal s_fZero      : std_logic;
    signal s_fovflw     : std_logic;
    signal s_fNegative  : std_logic;

begin

    p_clock : process
    begin
        wait for (clock / 2);
        s_Clock <= '0';

        wait for (clock / 2);
        s_Clock <= '1';        
    end process ; -- p_clock

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

        -- Test Case 1
        s_iA         <= x"00000001";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
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
        s_iOutSel    <= '0';
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
        s_iOutSel    <= '0';
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
        s_iOutSel    <= '0';
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
        s_iOutSel    <= '0';
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
        s_iOutSel    <= '0';
        s_iModSel    <= b"00";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 6a Failed" severity WARNING;
        assert s_ooutput    = x"FFFFFFFF"   report "Test 6b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 6c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 6d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 6e Failed" severity FAILURE;



                                -----------------------------
                                --- Barrell Shifter Tests ---
                                -----------------------------
        -- Base State
        s_iA         <= x"00000000";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
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
        assert s_fnegative  = '1'           report "Test 10e Failed" severity FAILURE;

        -- Test Case 11
        s_iA         <= x"80000000";
        s_iB         <= x"00000004";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 11a Failed" severity WARNING;
        assert s_ooutput    = x"F8000000"   report "Test 11b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 11c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 11d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 11e Failed" severity FAILURE;

        -- Test Case 12
        s_iA         <= x"80000000";
        s_iB         <= x"0000000C";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 12a Failed" severity WARNING;
        assert s_ooutput    = x"FFF80000"   report "Test 12b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 12c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 12d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 12e Failed" severity FAILURE;

        -- Test Case 13
        s_iA         <= x"80000000";
        s_iB         <= x"00000008";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 13a Failed" severity WARNING;
        assert s_ooutput    = x"FF800000"   report "Test 13b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 13c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 13d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 13e Failed" severity FAILURE;

        -- Test Case 14
        s_iA         <= x"000FF000";
        s_iB         <= x"00000004";
        s_iOppSel    <= b"11";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 14a Failed" severity WARNING;
        assert s_ooutput    = x"00FF0000"   report "Test 14b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 14c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 14d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 14e Failed" severity FAILURE;

        -- Test Case 15
        s_iA         <= x"000FF000";
        s_iB         <= x"00000008";
        s_iOppSel    <= b"11";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 15a Failed" severity WARNING;
        assert s_ooutput    = x"0FF00000"   report "Test 15b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 15c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 15d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 15e Failed" severity FAILURE;

        -- Test Case 16
        s_iA         <= x"000FF000";
        s_iB         <= x"0000000C";
        s_iOppSel    <= b"11";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 16a Failed" severity WARNING;
        assert s_ooutput    = x"FF000000"   report "Test 16b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 16c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 16d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 16e Failed" severity FAILURE;
        
        -- Test Case 17
        s_iA         <= x"000FF000";
        s_iB         <= x"00000004";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 17a Failed" severity WARNING;
        assert s_ooutput    = x"0000FF00"   report "Test 17b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 17c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 17d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 17e Failed" severity FAILURE;

        -- Test Case 18
        s_iA         <= x"000FF000";
        s_iB         <= x"00000008";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 18a Failed" severity WARNING;
        assert s_ooutput    = x"00000FF0"   report "Test 18b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 18c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 18d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 18e Failed" severity FAILURE;

        -- Test Case 19
        s_iA         <= x"000FF000";
        s_iB         <= x"0000000C";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"10";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 19a Failed" severity WARNING;
        assert s_ooutput    = x"000000FF"   report "Test 19b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 19c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 19d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 19e Failed" severity FAILURE;

                                --------------------------
                                --- Logic Module Tests ---
                                --------------------------
        -- Base State
        s_iA         <= x"00000000";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Invalid Base State (a)" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Invalid Base State (b)" severity FAILURE;
        assert s_fovflw     = '0'           report "Invalid Base State (c)" severity FAILURE;
        assert s_fzero      = '1'           report "Invalid Base State (d)" severity FAILURE;
        assert s_fnegative  = '0'           report "Invalid Base State (e)" severity FAILURE;

        -- Test Case 20
        s_iA         <= x"00000001";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 20a Failed" severity WARNING;
        assert s_ooutput    = x"00000001"   report "Test 20b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 20c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 20d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 20e Failed" severity FAILURE;

        -- Test Case 21
        s_iA         <= x"00000001";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 21a Failed" severity WARNING;
        assert s_ooutput    = x"00000001"   report "Test 21b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 21c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 21d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 21e Failed" severity FAILURE;

        -- Test Case 22
        s_iA         <= x"00000001";
        s_iB         <= x"00000001";
        s_iOppSel    <= b"10";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 22a Failed" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Test 22b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 22c Failed" severity FAILURE;
        assert s_fzero      = '1'           report "Test 22d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 22e Failed" severity FAILURE;

        -- Test Case 23
        s_iA         <= x"0000000F";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 22a Failed" severity WARNING;
        assert s_ooutput    = x"00000000"   report "Test 22b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 22c Failed" severity FAILURE;
        assert s_fzero      = '1'           report "Test 22d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 22e Failed" severity FAILURE;

        -- Test Case 24
        s_iA         <= x"0000000F";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 24a Failed" severity WARNING;
        assert s_ooutput    = x"0000000F"   report "Test 24b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 24c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 24d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 24e Failed" severity FAILURE;

        -- Test Case 25
        s_iA         <= x"0000000F";
        s_iB         <= x"00000000";
        s_iOppSel    <= b"10";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 25a Failed" severity WARNING;
        assert s_ooutput    = x"0000000F"   report "Test 25b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 25c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 25d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 25e Failed" severity FAILURE;

        -- Test Case 26
        s_iA         <= x"F000000F";
        s_iB         <= x"3000F000";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 26a Failed" severity WARNING;
        assert s_ooutput    = x"30000000"   report "Test 26b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 26c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 26d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 26e Failed" severity FAILURE;

        -- Test Case 27
        s_iA         <= x"F000000F";
        s_iB         <= x"3000F000";
        s_iOppSel    <= b"01";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 27a Failed" severity WARNING;
        assert s_ooutput    = x"F000F00F"   report "Test 27b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 27c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 27d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 27e Failed" severity FAILURE;

        -- Test Case 28
        s_iA         <= x"F000000F";
        s_iB         <= x"3000F000";
        s_iOppSel    <= b"10";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 28a Failed" severity WARNING;
        assert s_ooutput    = x"C000F00F"   report "Test 28b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 28c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 28d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 28e Failed" severity FAILURE;

        -- Test Case 29
        s_iA         <= x"FFFFFFFF";
        s_iB         <= x"01010101";
        s_iOppSel    <= b"00";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 29a Failed" severity WARNING;
        assert s_ooutput    = x"01010101"   report "Test 29b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 29c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 29d Failed" severity FAILURE;
        assert s_fnegative  = '0'           report "Test 29e Failed" severity FAILURE;

        -- Test Case 30
        s_iA         <= x"FFFFFFFF";
        s_iB         <= x"10100101";
        s_iOppSel    <= b"10";
        s_iOutSel    <= '0';
        s_iModSel    <= b"01";
        wait for clock;
        assert s_oResult    = x"00000000"   report "Test 30a Failed" severity WARNING;
        assert s_ooutput    = x"EFEFFEFE"   report "Test 30b Failed" severity FAILURE;
        assert s_fovflw     = '0'           report "Test 30c Failed" severity FAILURE;
        assert s_fzero      = '0'           report "Test 30d Failed" severity FAILURE;
        assert s_fnegative  = '1'           report "Test 30e Failed" severity FAILURE;

        wait;
    end process; -- tests

end behaviour;
