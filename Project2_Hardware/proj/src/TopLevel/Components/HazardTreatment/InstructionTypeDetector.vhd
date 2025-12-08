library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.t_InstructionType;

entity InstructionTypeDetector is
    port(
        i_Opcode            : in  std_logic_vector(6 downto 0);
        o_InstructionType   : out t_InstructionType
    );
end InstructionTypeDetector;

architecture behavior of InstructionTypeDetector is
begin

    o_InstructionType <=
        R         when i_Opcode = "0110011" else  -- Standard Arithmetic

        I         when i_Opcode = "0010011" else  -- Immediate Arithmetic
        I         when i_Opcode = "0000011" else  -- Loads
        I         when i_Opcode = "1100111" else  -- JALR
        I         when i_Opcode = "1110011" else  -- ECALL

        S         when i_Opcode = "0100011" else  -- Stores

        B         when i_Opcode = "1100011" else  -- Branches

        U         when i_Opcode = "0110111" else  -- LUI
        U         when i_Opcode = "0010111" else  -- AUIPC

        J         when i_Opcode = "1101111" else  -- JAL

        unknown;
                            
end behavior;
