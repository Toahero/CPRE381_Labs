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

    component fwdTypeChecker is
        port(
            
            i_ExOpCode        : in std_logic_vector(6 downto 0);
            i_FwdOpCode       : in std_logic_vector(6 downto 0);
            i_FromWb      : in std_logic;

            o_forwardRS1    : out std_logic;
            o_forwardRS2    : out std_logic
        );
    end component;

    signal s_IF_Instruction     : t_Instruction;
    signal s_ID_Instruction     : t_Instruction;
    signal s_EX_Instruction     : t_Instruction;
    signal s_MEM_Instruction    : t_Instruction;
    signal s_WB_Instruction     : t_Instruction;

    signal s_MemRS1Fwd : std_logic;
    signal s_MemRS2Fwd : std_logic;
    signal s_WbRs1Fwd  : std_logic;
    signal s_WbRS2Fwd  : std_logic;


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

    g_fwdCheckerOneSlot : fwdTypeChecker
        port map(
            i_ExOpCode          => s_IF_Instruction.Instruction(6 downto 0),
            i_FwdOpCode         => s_ID_Instruction.Instruction(6 downto 0),
            i_FromWb            => '0',
            
            o_forwardRS1        => s_MemRS1Fwd,
            o_forwardRS2        => s_MemRS1Fwd
        );

    g_fwdCheckerTwoSlots : fwdTypeChecker
        port map(
            i_ExOpCode          => s_IF_Instruction.Instruction(6 downto 0),
            i_FwdOpCode         => s_ID_Instruction.Instruction(6 downto 0),
            i_FromWb            => '1',
            
            o_forwardRS1        => s_WbRs1Fwd,
            o_forwardRS2        => s_WbRS2Fwd
        );

    o_NOP <= '1' when 
    (
        -- Read after Write
        (
            (i_JumpOrBranch = '1') or
            -- (s_IF_Instruction.RS1 = s_ID_Instruction .RD and s_ID_Instruction .isNOP = false) or
            -- (s_IF_Instruction.RS1 = s_EX_Instruction .RD and s_EX_Instruction .isNOP = false) or
            -- (s_IF_Instruction.RS1 = s_MEM_Instruction.RD and s_MEM_Instruction.isNOP = false) or

            -- (s_IF_Instruction.RS2 = s_ID_Instruction .RD and s_ID_Instruction .isNOP = false) or
            -- (s_IF_Instruction.RS2 = s_EX_Instruction .RD and s_EX_Instruction .isNOP = false) or
            -- (s_IF_Instruction.RS2 = s_MEM_Instruction.RD and s_MEM_Instruction.isNOP = false) or


            (s_IF_Instruction.RS1 = s_ID_Instruction .RD and s_ID_Instruction .isNOP = false and s_MemRS1Fwd = '0') or
            (s_IF_Instruction.RS1 = s_EX_Instruction .RD and s_EX_Instruction .isNOP = false and s_WbRs1Fwd = '0') or
            --(s_IF_Instruction.RS1 = s_MEM_Instruction.RD and s_MEM_Instruction.isNOP = false) or

            (s_IF_Instruction.RS2 = s_ID_Instruction .RD and s_ID_Instruction .isNOP = false and s_MemRS2Fwd = '0') or
            (s_IF_Instruction.RS2 = s_EX_Instruction .RD and s_EX_Instruction .isNOP = false and s_WbRS2Fwd = '0') or
            --(s_IF_Instruction.RS2 = s_MEM_Instruction.RD and s_MEM_Instruction.isNOP = false) or

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
