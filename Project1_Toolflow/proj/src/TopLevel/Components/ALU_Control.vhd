library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISCV_types.all;

entity ALU_Control is
    port(
        i_Opcode : in std_logic_vector(6 downto 0);
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
        o_ModuleSelect      <=  "00" when "000",   -- FUNCT3_ADD, FUNCT3_SUB, FUNCT3_ADDI
                                "01" when "100",   -- FUNCT3_XOR, FUNCT3_XORI
                                "01" when "110",    -- FUNCT3_OR, FUNCT3_ORI
                                "01" when "111",   -- FUNCT3_AND, FUNCT3_ANDI
                                "10" when "001",   -- FUNCT3_SLL, FUNCT3_SLLI
                                "10" when "101",   -- FUNCT3_SRL, FUNCT3_SRA, FUNCT3_SRLI, FUNCT3_SRAI
                                "XX" when others;
    
    o_OperationSelect       <=  "01" when i_Funct7 = "0100000"    else
                                "01" when i_Funct3 = "001"        else
                                (others => '0');

end behaviour;
