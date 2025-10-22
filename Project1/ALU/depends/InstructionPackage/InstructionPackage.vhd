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

    -- 1110011 --
    constant OPCODE_ECALL             : std_logic_vector(6 downto 0) := "1110011";
    constant OPCODE_EBREAK            : std_logic_vector(6 downto 0) := "1110011";


                        --------------
                        --  FUNCT3  --
                        --------------
    -- 0110011
    constant FUNCT3_ADD               : unsigned := x"0";
    constant FUNCT3_SUB               : unsigned := x"0";
    constant FUNCT3_XOR               : unsigned := x"4";
    constant FUNCT3_OR                : unsigned := x"6";
    constant FUNCT3_AND               : unsigned := x"7";
    constant FUNCT3_SLL               : unsigned := x"1";
    constant FUNCT3_SRL               : unsigned := x"5";
    constant FUNCT3_SRA               : unsigned := x"5";
    constant FUNCT3_SLT               : unsigned := x"2";
    constant FUNCT3_SLTU              : unsigned := x"3";

    -- 0010011 --
    constant FUNCT3_ADDI              : unsigned := x"0";
    constant FUNCT3_XORI              : unsigned := x"4";
    constant FUNCT3_ORI               : unsigned := x"6";
    constant FUNCT3_ANDI              : unsigned := x"7";
    constant FUNCT3_SLLI              : unsigned := x"1";
    constant FUNCT3_SRLI              : unsigned := x"5";
    constant FUNCT3_SRAI              : unsigned := x"5";
    constant FUNCT3_SLTI              : unsigned := x"2";
    constant FUNCT3_SLTIU             : unsigned := x"3";

    -- 0000011 --
    constant FUNCT3_LB                : unsigned := x"0";
    constant FUNCT3_LH                : unsigned := x"1";
    constant FUNCT3_LW                : unsigned := x"2";
    constant FUNCT3_LBU               : unsigned := x"4";
    constant FUNCT3_LHU               : unsigned := x"5";

    -- 0100011 --
    constant FUNCT3_SB                : unsigned := x"0";
    constant FUNCT3_SH                : unsigned := x"1";
    constant FUNCT3_SW                : unsigned := x"2";

    -- 1100011 --
    constant FUNCT3_BEQ                : unsigned := x"0";
    constant FUNCT3_BNE                : unsigned := "1100011";
    constant FUNCT3_BLT                : unsigned := "1100011";
    constant FUNCT3_BGE                : unsigned := "1100011";
    constant FUNCT3_BLTU               : unsigned := "1100011";
    constant FUNCT3_BGEU               : unsigned := "1100011";
    -- 1101111 --
    constant FUNCT3_JAL                : unsigned := "1101111";

    -- 1100111 --
    constant FUNCT3_JALR               : unsigned := "1100111";

    -- 1110011 --
    constant FUNCT3_ECALL              : unsigned := "1110011";
    constant FUNCT3_EBREAK             : unsigned := "1110011";

end package InstructionPackage;