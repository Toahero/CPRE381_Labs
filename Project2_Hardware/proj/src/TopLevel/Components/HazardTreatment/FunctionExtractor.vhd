library IEEE;
use IEEE.std_logic_1164.all;

-- use work.RISCV_types.t_InstructionType;
-- use work.RISCV_types.t_Instruction;

use work.RISCV_types.all;

entity FunctionExtractor is
    port(
        i_Instruction       : in  std_logic_vector(31 downto 0);
        i_InstructionType   : in  t_InstructionType;
        o_Funct3            : out std_logic_vector(2 downto 0);
        o_Funct7            : out std_logic_vector(6 downto 0)
    );
end FunctionExtractor;

architecture behavior of FunctionExtractor is
begin

    o_Funct3    <=
                i_Instruction(14 downto 12) when i_InstructionType = R else
                i_Instruction(14 downto 12) when i_InstructionType = I else
                i_Instruction(14 downto 12) when i_InstructionType = S else
                i_Instruction(14 downto 12) when i_InstructionType = B else
                "000";

    o_Funct7   <=
                i_Instruction(31 downto 25) when i_InstructionType = R else
                i_Instruction(31 downto 25) when
                (
                    i_InstructionType = I and 
                    (
                        o_Funct3 = "001" or o_Funct3 = "101"
                    )
                )
                else
                "0000000";

end behavior;
