library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU2 is
    generic(
        gCLK_HPER   : time := 10 ns;
        DATA_WIDTH  : integer   := 32
    );
end tb_ALU2;

architecture mixed of tb_ALU2 is
    component ALU is
        port(
            i_A                 : in std_logic_vector(31 downto 0);
            i_B                 : in std_logic_vector(31 downto 0);

            i_AOverride         : in std_logic_vector(31 downto 0);
            i_BOverride         : in std_logic_vector(31 downto 0);
            i_BOverrideEnable   : in std_logic;
            i_AOverrideEnable   : in std_logic;

            i_OutSel            : in std_logic;
            i_ModSel            : in std_logic_vector(1 downto 0);

            i_OppSel            : in std_logic_vector(1 downto 0);

            i_BranchCond        : in std_logic_vector(2 downto 0); -- Funct3

            o_Result            : out std_logic_vector(31 downto 0); -- Unused
            o_output            : out std_logic_vector(31 downto 0);

            f_ovflw             : out std_logic;
            f_zero              : out std_logic;
            f_negative          : out std_logic;
            f_branch            : out std_logic
        );
    end component;

        signal CLK : std_logic := '0';

        signal    s_A                 : std_logic_vector(31 downto 0);
        signal    s_B                 : std_logic_vector(31 downto 0);

        signal    s_AOverride         : std_logic_vector(31 downto 0);
        signal    s_BOverride         : std_logic_vector(31 downto 0);
        
        signal    s_AOverrideEnable   : std_logic;
        signal    s_BOverrideEnable   : std_logic;

        signal    s_OutSel            : std_logic;
        signal    s_ModSel            : std_logic_vector(1 downto 0);

        signal    s_OppSel            : std_logic_vector(1 downto 0);

        signal    s_BranchCond        : std_logic_vector(2 downto 0); -- Funct3

        signal    s_Result            : std_logic_vector(31 downto 0); -- Unused
        signal    s_output            : std_logic_vector(31 downto 0);

        signal    s_fovflw             : std_logic;
        signal    s_fzero              : std_logic;
        signal    s_fnegative          : std_logic;
        signal    s_fbranch            : std_logic;

begin
    g_ALU   : ALU
        port map(
            i_A     => s_A,
            i_B     => s_B,

            i_AOverride => s_AOverride,
            i_BOverride => s_BOverride,

            i_AOverrideEnable => s_AOverrideEnable,
            i_BOverrideEnable => s_BOverrideEnable,

            i_OutSel            => s_OutSel,
            i_ModSel            => s_ModSel,
            i_OppSel            => s_OppSel,
            i_BranchCond        => s_BranchCond,
            o_Result            => s_Result,
            o_output            => s_output,
            f_ovflw             => s_fovflw,
            f_zero              => s_fzero,
            f_negative          => s_fnegative,
            f_branch            => s_fbranch);

    P_CLK: process
    begin
        CLK <= '1';         -- clock starts at 1
        wait for gCLK_HPER; -- after half a cycle

        CLK <= '0';         -- clock becomes a 0 (negative edge)
        wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;

    P_TEST_Instructions: process
    begin
        wait for gCLK_HPER/2; --Change inputs on clk midpoints

        --Base State
        s_A                     <= std_logic_vector(to_signed(0, 32));
        s_B                     <= std_logic_vector(to_signed(0, 32));
        s_AOverrideEnable       <= '0';
        s_BOverrideEnable       <= '0';
        s_AOverride             <= std_logic_vector(to_signed(0, 32));
        s_BOverride             <= std_logic_vector(to_signed(0, 32));
        s_ModSel                <= "00";
        s_OppSel                <= "00";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);

        --Add 10 plus 5
        s_A                     <= std_logic_vector(to_signed(10, 32));
        s_B                     <= std_logic_vector(to_signed(5, 32));
        
        s_AOverrideEnable       <= '0';
        s_AOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_BOverrideEnable       <= '0';
        s_BOverride             <= std_logic_vector(to_signed(0, 32));
        s_OppSel                <= "00";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);
        
        --Add -105 plus 5
        s_A                     <= std_logic_vector(to_signed(-105, 32));
        s_B                     <= std_logic_vector(to_signed(5, 32));
        
        s_AOverrideEnable       <= '0';
        s_AOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_BOverrideEnable       <= '0';
        s_BOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_OppSel                <= "00";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);

        --Subtract 113 from 130
        s_A                     <= std_logic_vector(to_signed(130, 32));
        s_B                     <= std_logic_vector(to_signed(113, 32));
        
        s_AOverrideEnable       <= '0';
        s_AOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_BOverrideEnable       <= '0';
        s_BOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_ModSel                <= "00";
        s_OppSel                <= "01";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);

        --Multiply 225 by 4 (Shift Left 2)
        s_A                     <= std_logic_vector(to_signed(225, 32));
        s_B                     <= std_logic_vector(to_signed(2, 32));
        
        s_AOverrideEnable       <= '0';
        s_AOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_BOverrideEnable       <= '0';
        s_BOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_ModSel                <= "10";
        s_OppSel                <= "10";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);


        --Test A Override
        s_A                     <= std_logic_vector(to_signed(-1, 32));
        s_B                     <= std_logic_vector(to_signed(5, 32));
        
        s_AOverrideEnable       <= '1';
        s_AOverride             <= std_logic_vector(to_signed(25, 32));
        
        s_BOverrideEnable       <= '0';
        s_BOverride             <= std_logic_vector(to_signed(0, 32));
        s_ModSel                <= "00";
        s_OppSel                <= "00";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);

        --Test B Override
        s_A                     <= std_logic_vector(to_signed(10, 32));
        s_B                     <= std_logic_vector(to_signed(-1, 32));
        
        s_AOverrideEnable       <= '0';
        s_AOverride             <= std_logic_vector(to_signed(0, 32));
        
        s_BOverrideEnable       <= '1';
        s_BOverride             <= std_logic_vector(to_signed(90, 32));
        s_ModSel                <= "00";
        s_OppSel                <= "00";
        s_BranchCond            <= "000";
        wait for (gCLK_HPER * 2);

        wait;
    end process;
end mixed;
