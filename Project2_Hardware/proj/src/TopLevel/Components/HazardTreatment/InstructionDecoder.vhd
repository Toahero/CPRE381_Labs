library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.t_InstructionType;
use work.RISCV_types.t_Instruction;
use work.RISCV_types.NOP;
use work.RISCV_types.ZERO;

entity InstructionDecoder is
    port(
        i_Instruction       : in  std_logic_vector(31 downto 0);
        o_Instruction       : out t_Instruction
    );
end InstructionDecoder;

architecture behavior of InstructionDecoder is

    component InstructionTypeDetector is
        port(
            i_Opcode            : in  std_logic_vector(6 downto 0);
            o_InstructionType   : out t_InstructionType
        );
    end component;

    component RegisterExtractor is
        port(
            i_Instruction       : in  std_logic_vector(31 downto 0);
            i_InstructionType   : in  t_InstructionType;
            o_RD                : out std_logic_vector(4 downto 0);
            o_RS1               : out std_logic_vector(4 downto 0);
            o_RS2               : out std_logic_vector(4 downto 0)
        );
    end component;
    
    component FunctionExtractor is
        port(
            i_Instruction       : in  std_logic_vector(31 downto 0);
            i_InstructionType   : in  t_InstructionType;
            o_Funct3            : out std_logic_vector(2 downto 0);
            o_Funct7            : out std_logic_vector(6 downto 0)
        );
    end component;

    signal s_Opcode             : std_logic_vector(6  downto 0);
    signal s_Instruction        : std_logic_vector(31 downto 0);
    signal s_InstructionType    : t_InstructionType;
    signal s_RD                 : std_logic_vector(4  downto 0);
    signal s_RS1                : std_logic_vector(4  downto 0);
    signal s_RS2                : std_logic_vector(4  downto 0);
    signal s_Funct3             : std_logic_vector(2  downto 0);
    signal s_Funct7             : std_logic_vector(6  downto 0);
    signal s_isNOP              : boolean;
    signal s_isFlushed          : boolean;

begin

    o_Instruction.Instruction       <= s_Instruction;
    o_Instruction.Opcode            <= s_Opcode;
    o_Instruction.InstructionType   <= s_InstructionType;
    o_Instruction.RS1               <= s_RS1;
    o_Instruction.RS2               <= s_RS2;
    o_Instruction.RD                <= s_RD;
    o_Instruction.Funct3            <= s_Funct3;
    o_Instruction.Funct7            <= s_Funct7;
    o_Instruction.isNOP             <= s_isNOP;
    o_Instruction.isFlushed         <= s_isFlushed;

    s_Opcode                        <= i_Instruction(6 downto 0);
    s_Instruction                   <= i_Instruction;

    g_InstructionTypeDetector : InstructionTypeDetector
        port map(
            i_Opcode            => s_Opcode,
            o_InstructionType   => s_InstructionType
        );

    g_RegisterExtractor : RegisterExtractor
        port map(
            i_Instruction       => i_Instruction,
            i_InstructionType   => s_InstructionType,
            o_RD                => s_RD,
            o_RS1               => s_RS1,
            o_RS2               => s_RS2
        );

    g_FunctionExtractor : FunctionExtractor
        port map(
            i_Instruction       => i_Instruction,
            i_InstructionType   => s_InstructionType,
            o_Funct3            => s_Funct3,
            o_Funct7            => s_Funct7
        );

    s_isNOP         <= i_Instruction = NOP;
    s_isFlushed     <= i_Instruction = ZERO;

end behavior;
