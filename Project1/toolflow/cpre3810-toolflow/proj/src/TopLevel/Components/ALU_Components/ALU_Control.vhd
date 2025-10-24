library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.InstructionPackage.all;

entity ALU_Control is
    port(
        i_Funct3 : in std_logic_vector(2 downto 0);
        i_Funct7 : in std_logic_vector(6 downto 0);

        o_OutSel : out std_logic;
        o_ModuleSelect : out std_logic_vector(1 downto 0);
        o_OperationSelect : out std_logic_vector(1 downto 0)
    );
end ALU_Control;

architecture behaviour of ALU_Control is
begin

    o_OutSel <= '0';

    with i_Funct3 select
        o_ModuleSelect      <=  "00" when FUNCT3_ADD,
                                "00" when FUNCT3_SUB,
                                "00" when FUNCT3_ADDI,
                                "01" when FUNCT3_XOR,
                                "01" when FUNCT3_OR,
                                "01" when FUNCT3_AND,
                                "01" when FUNCT3_XORI,
                                "01" when FUNCT3_ORI,
                                "01" when FUNCT3_ANDI,
                                "10" when FUNCT3_SLL,
                                "10" when FUNCT3_SRL,
                                "10" when FUNCT3_SRA,
                                "10" when FUNCT3_SLLI,
                                "10" when FUNCT3_SRLI,
                                "10" when FUNCT3_SRAI,
                                "XX" when others;
    
    o_OperationSelect       <=  "01" when i_Funct7 = FUNCT7_SUB    else
                                "01" when i_Funct3 = FUNCT3_SLL    else
                                "01" when i_Funct3 = FUNCT3_SLLI   else
                                "10" when i_Funct7 = FUNCT7_SRA    else
                                "10" when i_Funct7 = FUNCT7_SRAI   else
                                (others => '0');

end behaviour;
