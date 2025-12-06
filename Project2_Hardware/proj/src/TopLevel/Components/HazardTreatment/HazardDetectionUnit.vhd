library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.t_Instruction;
use work.RISCV_types.t_InstructionType;

entity HazardDetectionUnit is
    port(        
        i_IF_Instruction    : in  std_logic_vector(31 downto 0);
        i_ID_Instruction    : in  std_logic_vector(31 downto 0);
        i_EX_Instruction    : in  std_logic_vector(31 downto 0);
        i_MEM_Instruction   : in  std_logic_vector(31 downto 0);
        i_WB_Instruction    : in  std_logic_vector(31 downto 0);

        o_NOP               : out std_logic;
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

    o_NOP <= '1' when 
    (
        -- Read after Write
        (
            (s_IF_Instruction.RS1 = s_ID_Instruction .RD and s_IF_Instruction.RS1 /= "00000") or
            (s_IF_Instruction.RS1 = s_EX_Instruction .RD and s_IF_Instruction.RS1 /= "00000") or
            (s_IF_Instruction.RS1 = s_MEM_Instruction.RD and s_IF_Instruction.RS1 /= "00000") or
            (s_IF_Instruction.RS1 = s_WB_Instruction .RD and s_IF_Instruction.RS1 /= "00000") or

            (s_IF_Instruction.RS2 = s_ID_Instruction .RD and s_IF_Instruction.RS2 /= "00000") or
            (s_IF_Instruction.RS2 = s_EX_Instruction .RD and s_IF_Instruction.RS2 /= "00000") or
            (s_IF_Instruction.RS2 = s_MEM_Instruction.RD and s_IF_Instruction.RS2 /= "00000") or
            (s_IF_Instruction.RS2 = s_WB_Instruction .RD and s_IF_Instruction.RS2 /= "00000") or

            (s_EX_Instruction.InstructionType = B) or
            (s_EX_Instruction.InstructionType = J) or
            (s_EX_Instruction.Opcode = "1100111")
        )
    )
    else '0';

    o_IFID_WriteEnable          <= '1';
    o_IDEX_WriteEnable          <= '1';
    o_EXMEM_WriteEnable         <= '1';
    o_MEMWB_WriteEnable         <= '1';

    o_IFID_Reset                <= '1' when
    (
        -- Branches
        (
            --s_ID_Instruction.InstructionType = B
            s_EX_Instruction.InstructionType = B or
            s_EX_Instruction.InstructionType = J or
            s_EX_Instruction.Opcode = "1100111"
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
