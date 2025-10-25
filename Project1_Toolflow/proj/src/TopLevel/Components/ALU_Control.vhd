library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISCV_types.all;

entity ALU_Control is
    port(
        i_Opcode : in std_logic_vector(6 downto 0);
        i_Funct3 : in std_logic_vector(2 downto 0);
        i_Funct7 : in std_logic_vector(6 downto 0);
        i_PCAddr : in std_logic_vector(31 downto 0);

        o_aOverride : out std_logic;
        o_OvrValue  : out std_logic_vector(31 downto 0);
        o_ModuleSelect : out std_logic_vector(1 downto 0);
        o_OperationSelect : out std_logic_vector(1 downto 0)
    );
end ALU_Control;

architecture behaviour of ALU_Control is
begin
    with i_Opcode select
    o_aOverride  <=  '1' when "0110111" | "0010111",
                    '0' when others;

    with i_Opcode select
    o_OvrValue  <=  i_PCAddr when "0010111", --auipc function
                    x"00000000" when others;

    
    o_ModuleSelect      <=  "00" when i_Opcode = "0110111" else -- LUI
                            "00" when i_Opcode = "0010111" else -- LUI
                            "00" when i_Funct3 = "000" else   -- FUNCT3_ADD, FUNCT3_SUB, FUNCT3_ADDI
                            "01" when i_Funct3 = "100" else   -- FUNCT3_XOR, FUNCT3_XORI
                            "01" when i_Funct3 = "110" else    -- FUNCT3_OR, FUNCT3_ORI
                            "01" when i_Funct3 = "111" else   -- FUNCT3_AND, FUNCT3_ANDI
                            "10" when i_Funct3 = "001" else   -- FUNCT3_SLL, FUNCT3_SLLI
                            "10" when i_Funct3 = "101" else   -- FUNCT3_SRL, FUNCT3_SRA, FUNCT3_SRLI, FUNCT3_SRAI
                            "00";
    
    o_OperationSelect   <=  "01" when i_Funct7 = "0100000"  and i_Opcode = "0110011"    else -- FUNCT7_SUB, FUNCT7_SRA, FUNCT7_SRAI
                            "01" when i_Funct3 = "001"      and i_Opcode = "0110011"     else -- FUNCT3_SLL, FUNCT3_SLLI
                            "01" when i_Funct3 = "110"      and i_Opcode = "0110011" else
                            "01" when i_Funct3 = "110"      and i_Opcode = "0010011" else
                            "01" when i_Funct3 = "101"      and i_Funct7(5) and i_Opcode = "0010011" else
                            "00" when i_Funct3 = "101"      and i_Opcode = "0010011" else
                            "10" when i_Funct3 = "100"      else
                            (others => '0');

end behaviour;
