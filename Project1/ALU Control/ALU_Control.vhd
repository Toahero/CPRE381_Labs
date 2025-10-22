library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.InstructionPackage.all;

entity ALU_Control is
    port(
        i_Funct3 : in std_logic_vector(2 downto 0);
        i_Funct7 : in std_logic_vector(2 downto 0);

        o_OutSel : out std_logic;
        o_ModuleSelect : out std_logic_vector(1 downto 0);
        o_OperationSelect : out std_logic_vector(1 downto 0)
    );
end ALU_Control;

architecture behaviour of ALU_Control is
begin

    o_OutSel <= '0';

    with i_Funct3 select
        o_ModuleSelect      <=  b"00" when FUNCT3_ADD
                                b"00" when FUNCT3_SUB
                                b"00" when FUNCT3_ADDI
                                b"01" when FUNCT3_XOR
                                b"01" when FUNCT3_OR
                                b"01" when FUNCT3_AND
                                b"01" when FUNCT3_XORI
                                b"01" when FUNCT3_ORI
                                b"01" when FUNCT3_ANDI
                                b"10" when FUNCT3_SLL
                                b"10" when FUNCT3_SRL
                                b"10" when FUNCT3_SRA
                                b"10" when FUNCT3_SLLI
                                b"10" when FUNCT3_SRLI
                                b"10" when FUNCT3_SRAI
                                b"XX" when others;
    
    o_OperationSelect       <=  b"01" when i_Funct7 = FUNCT7_SUB    else
                                b"01" when i_Funct3 = FUNCT3_SLL    else
                                b"01" when i_Funct3 = FUNCT3_SLLI   else
                                b"10" when i_Funct7 = FUNCT7_SRA    else
                                b"10" when i_Funct7 = FUNCT7_SRAI   else
                                (others => '0');

end behaviour;
