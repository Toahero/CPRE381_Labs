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

begin

    o_Instruction.Opcode        <= i_Instruction(6 downto 0);
    o_Instruction.Instruction   <= i_Instruction;

    g_InstructionTypeDetector : InstructionTypeDetector
        port map(
            i_Opcode            => o_Instruction.Opcode,
            o_InstructionType   => o_Instruction.InstructionType
        );

    g_RegisterExtractor : RegisterExtractor
        port map(
            i_Instruction       => i_Instruction,
            i_InstructionType   => o_Instruction.InstructionType,
            o_RD                => o_Instruction.RD,
            o_RS1               => o_Instruction.RS1,
            o_RS2               => o_Instruction.RS2
        );

    g_FunctionExtractor : FunctionExtractor
        port map(
            i_Instruction       => i_Instruction,
            i_InstructionType   => o_Instruction.InstructionType,
            o_Funct3            => o_Instruction.Funct3,
            o_Funct7            => o_Instruction.Funct7
        );

    o_Instruction.isNOP         <= i_Instruction = NOP;
    o_Instruction.isFlushed     <= i_Instruction = ZERO;

end behavior;
