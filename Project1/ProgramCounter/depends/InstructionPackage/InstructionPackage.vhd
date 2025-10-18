library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package InstructionPackage is
    
                        -------------
                        -- OPCODES --
                        -------------
    -- 0110011
    constant OPCODE_ADD               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_SUB               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_XOR               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_OR                : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_AND               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_SLL               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_SRL               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_SRA               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_SLT               : std_logic_vector(6 downto 0) := "0110011";
    constant OPCODE_SLTU              : std_logic_vector(6 downto 0) := "0110011";

    -- 0010011 --
    constant OPCODE_ADDI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_XORI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_ORI               : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_ANDI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_SLLI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_SRLI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_SRAI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_SLTI              : std_logic_vector(6 downto 0) := "0010011";
    constant OPCODE_SLTIU             : std_logic_vector(6 downto 0) := "0010011";

    -- 0000011 --
    constant OPCODE_LB                : std_logic_vector(6 downto 0) := "0000011";
    constant OPCODE_LH                : std_logic_vector(6 downto 0) := "0000011";
    constant OPCODE_LW                : std_logic_vector(6 downto 0) := "0000011";
    constant OPCODE_LBU               : std_logic_vector(6 downto 0) := "0000011";
    constant OPCODE_LHU               : std_logic_vector(6 downto 0) := "0000011";

    -- 0100011 --
    constant OPCODE_SB                : std_logic_vector(6 downto 0) := "0100011";
    constant OPCODE_SH                : std_logic_vector(6 downto 0) := "0100011";
    constant OPCODE_SW                : std_logic_vector(6 downto 0) := "0100011";

    -- 1100011 --
    constant OPCODE_BEQ               : std_logic_vector(6 downto 0) := "1100011";
    constant OPCODE_BNE               : std_logic_vector(6 downto 0) := "1100011";
    constant OPCODE_BLT               : std_logic_vector(6 downto 0) := "1100011";
    constant OPCODE_BGE               : std_logic_vector(6 downto 0) := "1100011";
    constant OPCODE_BLTU              : std_logic_vector(6 downto 0) := "1100011";
    constant OPCODE_BGEU              : std_logic_vector(6 downto 0) := "1100011";

    -- 1101111 --
    constant OPCODE_JAL               : std_logic_vector(6 downto 0) := "1101111";

    -- 1100111 --
    constant OPCODE_JALR              : std_logic_vector(6 downto 0) := "1100111";

    -- 0110111 --
    constant OPCODE_LUI               : std_logic_vector(6 downto 0) := "0110111";

    -- 0010111 --
    constant OPCODE_AUIPC             : std_logic_vector(6 downto 0) := "0010111";

    -- 1110011 --
    constant OPCODE_ECALL             : std_logic_vector(6 downto 0) := "1110011";
    constant OPCODE_EBREAK            : std_logic_vector(6 downto 0) := "1110011";


                        --------------
                        --  FUNCT3  --
                        --------------
    -- 0110011
    constant FUNCT3_ADD               : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_SUB               : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_XOR               : std_logic_vector(2 downto 0) := "100";
    constant FUNCT3_OR                : std_logic_vector(2 downto 0) := "110";
    constant FUNCT3_AND               : std_logic_vector(2 downto 0) := "111";
    constant FUNCT3_SLL               : std_logic_vector(2 downto 0) := "001";
    constant FUNCT3_SRL               : std_logic_vector(2 downto 0) := "101";
    constant FUNCT3_SRA               : std_logic_vector(2 downto 0) := "101";
    constant FUNCT3_SLT               : std_logic_vector(2 downto 0) := "010";
    constant FUNCT3_SLTU              : std_logic_vector(2 downto 0) := "011";

    -- 0010011 --
    constant FUNCT3_ADDI              : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_XORI              : std_logic_vector(2 downto 0) := "100";
    constant FUNCT3_ORI               : std_logic_vector(2 downto 0) := "110";
    constant FUNCT3_ANDI              : std_logic_vector(2 downto 0) := "111";
    constant FUNCT3_SLLI              : std_logic_vector(2 downto 0) := "001";
    constant FUNCT3_SRLI              : std_logic_vector(2 downto 0) := "101";
    constant FUNCT3_SRAI              : std_logic_vector(2 downto 0) := "101";
    constant FUNCT3_SLTI              : std_logic_vector(2 downto 0) := "010";
    constant FUNCT3_SLTIU             : std_logic_vector(2 downto 0) := "011";

    -- 0000011 --
    constant FUNCT3_LB                : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_LH                : std_logic_vector(2 downto 0) := "001";
    constant FUNCT3_LW                : std_logic_vector(2 downto 0) := "010";
    constant FUNCT3_LBU               : std_logic_vector(2 downto 0) := "100";
    constant FUNCT3_LHU               : std_logic_vector(2 downto 0) := "101";

    -- 0100011 --
    constant FUNCT3_SB                : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_SH                : std_logic_vector(2 downto 0) := "001";
    constant FUNCT3_SW                : std_logic_vector(2 downto 0) := "010";

    -- 1100011 --
    constant FUNCT3_BEQ                : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_BNE                : std_logic_vector(2 downto 0) := "001";
    constant FUNCT3_BLT                : std_logic_vector(2 downto 0) := "100";
    constant FUNCT3_BGE                : std_logic_vector(2 downto 0) := "101";
    constant FUNCT3_BLTU               : std_logic_vector(2 downto 0) := "110";
    constant FUNCT3_BGEU               : std_logic_vector(2 downto 0) := "111";

    -- 1101111 --
    constant FUNCT3_JAL                : std_logic_vector(2 downto 0) := "000";

    -- 1100111 --
    constant FUNCT3_JALR               : std_logic_vector(2 downto 0) := "000";

    -- 0110111 --
    constant FUNCT3_LUI                : std_logic_vector(2 downto 0) := "000";

    -- 0010111 --
    constant FUNCT3_AUIPC              : std_logic_vector(2 downto 0) := "000";

    -- 1110011 --
    constant FUNCT3_ECALL              : std_logic_vector(2 downto 0) := "000";
    constant FUNCT3_EBREAK             : std_logic_vector(2 downto 0) := "000";

end package InstructionPackage;