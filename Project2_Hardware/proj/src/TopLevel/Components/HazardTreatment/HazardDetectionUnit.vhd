library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.t_Instruction;
use work.RISCV_types.t_InstructionType;

entity HazardDetectionUnit is
    port(
        i_JumpOrBranch      : in std_logic;
        i_IF_Instruction    : in  std_logic_vector(31 downto 0);
        i_ID_Instruction    : in  std_logic_vector(31 downto 0);
        i_EX_Instruction    : in  std_logic_vector(31 downto 0);
        i_MEM_Instruction   : in  std_logic_vector(31 downto 0);
        i_WB_Instruction    : in  std_logic_vector(31 downto 0);

        o_ForwardingEnable  : out std_logic;
        o_NOP               : out std_logic;
        o_Pause             : out std_logic;
        o_IFID_Reset        : out std_logic;
        o_IFID_WriteEnable  : out std_logic;
        o_IDEX_Reset        : out std_logic;
        o_IDEX_WriteEnable  : out std_logic;
        o_EXMEM_Reset       : out std_logic;
        o_EXMEM_WriteEnable : out std_logic;
        o_MEMWB_Reset       : out std_logic;
        o_MEMWB_WriteEnable : out std_logic
    );
end HazardDetectionUnit;

architecture dataflow of HazardDetectionUnit is

    component InstructionDecoder is
        port(
            i_Instruction           : in  std_logic_vector(31 downto 0);
            o_Instruction       : out t_Instruction
        );
    end component;

    signal s_ForwardingEnable   : std_logic;

    signal s_IF_Instruction     : t_Instruction;
    signal s_ID_Instruction     : t_Instruction;
    signal s_EX_Instruction     : t_Instruction;
    signal s_MEM_Instruction    : t_Instruction;
    signal s_WB_Instruction     : t_Instruction;

begin

    g_InstructionDecoder_IF : InstructionDecoder
        port map(
            i_Instruction       => i_IF_Instruction,
            o_Instruction       => s_IF_Instruction
        );

    g_InstructionDecoder_ID : InstructionDecoder
        port map(
            i_Instruction       => i_ID_Instruction,
            o_Instruction       => s_ID_Instruction
        );

    g_InstructionDecoder_EX : InstructionDecoder
        port map(
            i_Instruction       => i_EX_Instruction,
            o_Instruction       => s_EX_Instruction
        );

    g_InstructionDecoder_MEM : InstructionDecoder
        port map(
            i_Instruction       => i_MEM_Instruction,
            o_Instruction       => s_MEM_Instruction
        );

    g_InstructionDecoder_WB : InstructionDecoder
        port map(
            i_Instruction       => i_WB_Instruction,
            o_Instruction       => s_WB_Instruction
        );

    o_ForwardingEnable <= s_ForwardingEnable;
    s_ForwardingEnable <= 
    '1' when 
    (
        s_IF_Instruction.InstructionType = R and s_ID_Instruction.InstructionType = R
    )
    else '0';

    o_NOP <= '1' when 
    (
        -- Read after Write
        (
            (i_JumpOrBranch = '1') or

            (s_IF_Instruction.RS1 = s_ID_Instruction .RD and s_ID_Instruction .isNOP = false) or
            (s_IF_Instruction.RS1 = s_EX_Instruction .RD and s_EX_Instruction .isNOP = false) or
            (s_IF_Instruction.RS1 = s_MEM_Instruction.RD and s_MEM_Instruction.isNOP = false) or

            (s_IF_Instruction.RS2 = s_ID_Instruction .RD and s_ID_Instruction .isNOP = false) or
            (s_IF_Instruction.RS2 = s_EX_Instruction .RD and s_EX_Instruction .isNOP = false) or
            (s_IF_Instruction.RS2 = s_MEM_Instruction.RD and s_MEM_Instruction.isNOP = false) or

            false
        )
    )
    else '0';

    o_Pause <= o_NOP;

    o_IFID_WriteEnable          <= '1';
    o_IDEX_WriteEnable          <= '1';
    o_EXMEM_WriteEnable         <= '1';
    o_MEMWB_WriteEnable         <= '1';

    o_IFID_Reset                <= '1' when
    (
        -- Branches
        (
            i_JumpOrBranch = '1'
        )
    )
    else '0';

    o_IDEX_Reset                <= '1' when
    (
        false
    )
    else '0';

    o_EXMEM_Reset               <= '1' when
    (
        false
    )
    else '0';

    o_MEMWB_Reset               <= '1' when
    (
        false
    )
    else '0';

end dataflow;
