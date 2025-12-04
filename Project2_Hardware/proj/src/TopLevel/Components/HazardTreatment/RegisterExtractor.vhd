library IEEE;
use IEEE.std_logic_1164.all;

use work.RISCV_types.t_InstructionType;
use work.RISCV_types.t_Instruction;

entity RegisterExtractor is
    port(
        i_Instruction       : in  std_logic_vector(31 downto 0);
        i_InstructionType   : in  t_InstructionType;
        o_RD                : out std_logic_vector(4 downto 0);
        o_RS1               : out std_logic_vector(4 downto 0);
        o_RS2               : out std_logic_vector(4 downto 0)
    );
end RegisterExtractor;

architecture behavior of RegisterExtractor is
begin

    o_RD    <=
                i_Instruction(11 downto  7) when i_InstructionType = R else
                i_Instruction(11 downto  7) when i_InstructionType = I else
                i_Instruction(11 downto  7) when i_InstructionType = U else
                i_Instruction(11 downto  7) when i_InstructionType = J else
                "00000";

    o_RS1   <=
                i_Instruction(19 downto 15) when i_InstructionType = R else
                i_Instruction(19 downto 15) when i_InstructionType = I else
                i_Instruction(19 downto 15) when i_InstructionType = S else
                i_Instruction(19 downto 15) when i_InstructionType = B else
                "00000";

    o_RS2   <=
                i_Instruction(24 downto 20) when i_InstructionType = R else
                i_Instruction(24 downto 20) when i_InstructionType = S else
                i_Instruction(24 downto 20) when i_InstructionType = B else
                "00000";

end behavior;
