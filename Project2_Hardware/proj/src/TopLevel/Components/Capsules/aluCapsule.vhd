-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: ALU.vhd, ALU_Control.vhd
--Combined ALU/ALU control module
--aluCapsule.vhd
-------------------------------------------------------------------------
--11/14/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity aluCapsule is
    port(   i_instruction   : in std_logic_vector(31 downto 0);
            i_PCAddr        : in std_logic_vector(31 downto 0);
            i_A             : in std_logic_vector(31 downto 0);
            i_B             : in std_logic_vector(31 downto 0);

            o_Result            : out std_logic_vector(31 downto 0);
            o_output            : out std_logic_vector(31 downto 0);
            f_ovflw             : out std_logic
        );

end aluCapsule;

architecture structural of aluCapsule is
    component ALU_Control is
    port(
        i_Opcode            : in  std_logic_vector(6 downto 0);
        i_Funct3            : in  std_logic_vector(2 downto 0);
        i_Funct7            : in  std_logic_vector(6 downto 0);
        i_PCAddr            : in  std_logic_vector(31 downto 0);

        o_AOverride         : out std_logic_vector(31 downto 0);
        o_BOverride         : out std_logic_vector(31 downto 0);
        o_BOverrideEnable   : out std_logic;
        o_AOverrideEnable   : out std_logic;

        o_ModuleSelect      : out std_logic_vector(1 downto 0);
        o_OperationSelect   : out std_logic_vector(1 downto 0);
        o_Funct3Passthrough : out std_logic_vector(2 downto 0)
    );
    end component;

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

    signal s_AOverride      : std_logic_vector(31 downto 0);
    signal s_BOverride      : std_logic_vector(31 downto 0);

    signal s_AOverrideEnable : std_logic;
    signal s_BOverrideEnable : std_logic;



    signal s_ModSel         : std_logic_vector(1 downto 0);
    signal s_OppSel         : std_logic_vector(1 downto 0);

    --Signals to contain redundant input/Output
    signal rs_OutSel         : std_logic;
    signal rs_Passthrough    : std_logic_vector(2 downto 0);
    signal rs_flags          : std_logic_vector(2 downto 0);

begin
    g_ALU_CONT  : ALU_Control
    port map(   i_Opcode    => i_instruction(6 downto 0),
                i_Funct3    => i_instruction(14 downto 12),
                i_Funct7    => i_instruction(31 downto 25),
                i_PCAddr    => i_PCAddr,
                
                o_AOverride => s_AOverride,
                o_BOverride => s_BOverride,
                o_AOverrideEnable => s_AOverrideEnable,
                o_BOverrideEnable => s_BOverrideEnable,
                o_ModuleSelect      => s_ModSel,
                o_OperationSelect   => s_OppSel,
                o_Funct3Passthrough => rs_Passthrough);

    g_ALU   : ALU
    port map(   i_A     => i_A,
                i_B     => i_B,
                
                i_AOverride => s_AOverride,
                i_BOverride => s_BOverride,
                i_AOverrideEnable => s_AOverrideEnable,
                i_BOverrideEnable => s_BOverrideEnable,
                i_OutSel        => rs_OutSel,
                i_ModSel        => s_ModSel,
                i_OppSel        => s_OppSel,
                i_BranchCond    => i_instruction(14 downto 12),
                
                o_Result        => o_Result,
                o_Output        => o_Output,
                
                f_ovflw         => f_ovflw,
                f_zero          => rs_flags(0),
                f_negative      => rs_flags(1),
                f_branch        => rs_flags(2));

end structural;