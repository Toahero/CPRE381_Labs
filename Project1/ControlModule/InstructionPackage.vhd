library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package InstructionPackage is
    constant ALU_SOURCE_REGISTER    : unsigned := "0110011";
    constant MEM_WRITE_ENABLE       : unsigned := "0100011";

                        -------------
                        -- OPCODES --
                        -------------
    -- 0110011
    constant OPCODE_ADD               : unsigned := "0110011";
    constant OPCODE_SUB               : unsigned := "0110011";
    constant OPCODE_XOR               : unsigned := "0110011";
    constant OPCODE_OR                : unsigned := "0110011";
    constant OPCODE_AND               : unsigned := "0110011";
    constant OPCODE_SLL               : unsigned := "0110011";
    constant OPCODE_SRL               : unsigned := "0110011";
    constant OPCODE_SRA               : unsigned := "0110011";
    constant OPCODE_SLT               : unsigned := "0110011";
    constant OPCODE_SLTU              : unsigned := "0110011";

    -- 0010011 --
    constant OPCODE_ADDI              : unsigned := "0010011";
    constant OPCODE_XORI              : unsigned := "0010011";
    constant OPCODE_ORI               : unsigned := "0010011";
    constant OPCODE_ANDI              : unsigned := "0010011";
    constant OPCODE_SLLI              : unsigned := "0010011";
    constant OPCODE_SRLI              : unsigned := "0010011";
    constant OPCODE_SRAI              : unsigned := "0010011";
    constant OPCODE_SLTI              : unsigned := "0010011";
    constant OPCODE_SLTIU             : unsigned := "0010011";

    -- 0000011 --
    constant OPCODE_LB                : unsigned := "0010011";
    constant OPCODE_LH                : unsigned := "0010011";
    constant OPCODE_LW                : unsigned := "0010011";
    constant OPCODE_LBU               : unsigned := "0010011";
    constant OPCODE_LHU               : unsigned := "0010011";

    -- 0100011 --
    constant OPCODE_SB                : unsigned := "0100011";
    constant OPCODE_SH                : unsigned := "0100011";
    constant OPCODE_SW                : unsigned := "0100011";

    -- 1100011 --
    constant OPCODE_BEQ                : unsigned := "1100011";
    constant OPCODE_BNE                : unsigned := "1100011";
    constant OPCODE_BLT                : unsigned := "1100011";
    constant OPCODE_BGE                : unsigned := "1100011";
    constant OPCODE_BLTU               : unsigned := "1100011";
    constant OPCODE_BGEU               : unsigned := "1100011";

    -- 1101111 --
    constant OPCODE_JAL                : unsigned := "1101111";

    -- 1100111 --
    constant OPCODE_JALR               : unsigned := "1100111";

    -- 1110011 --
    constant OPCODE_ECALL              : unsigned := "1110011";
    constant OPCODE_EBREAK             : unsigned := "1110011";

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
    constant OPCODE_LB                : unsigned := "0010011";
    constant OPCODE_LH                : unsigned := "0010011";
    constant OPCODE_LW                : unsigned := "0010011";
    constant OPCODE_LBU               : unsigned := "0010011";
    constant OPCODE_LHU               : unsigned := "0010011";

    -- 0100011 --
    constant OPCODE_SB                : unsigned := "0100011";
    constant OPCODE_SH                : unsigned := "0100011";
    constant OPCODE_SW                : unsigned := "0100011";

    -- 1100011 --
    constant OPCODE_BEQ                : unsigned := "1100011";
    constant OPCODE_BNE                : unsigned := "1100011";
    constant OPCODE_BLT                : unsigned := "1100011";
    constant OPCODE_BGE                : unsigned := "1100011";
    constant OPCODE_BLTU               : unsigned := "1100011";
    constant OPCODE_BGEU               : unsigned := "1100011";

    -- 1101111 --
    constant OPCODE_JAL                : unsigned := "1101111";

    -- 1100111 --
    constant OPCODE_JALR               : unsigned := "1100111";

    -- 1110011 --
    constant OPCODE_ECALL              : unsigned := "1110011";
    constant OPCODE_EBREAK             : unsigned := "1110011";


end package InstructionPackage;