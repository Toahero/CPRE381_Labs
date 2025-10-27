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

    
    o_ModuleSelect      <=  
                            "00" when i_Funct3 = "000"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) ADD, SUB
                            "01" when i_Funct3 = "100"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) XOR
                            "01" when i_Funct3 = "110"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) OR
                            "01" when i_Funct3 = "111"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) AND
                            "10" when i_Funct3 = "001"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) SLL
                            "10" when i_Funct3 = "101"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) SRL, SRA
                            "00" when i_Opcode = "0110111"                                                          else    -- lui
                            "00" when i_Opcode = "0000011"                                                          else    -- LB, LH, LW, LBU, LHU
                            "00" when i_Opcode = "0100011"                                                          else    -- SB, SH, SW
                            "XX";
    
    o_OperationSelect   <=  
                            "01" when i_Funct3 = "000"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  and i_Funct7 = "0100000"    else    --      SUB
                            "00" when i_Funct3 = "000"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  ADD
                            "10" when i_Funct3 = "100"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  XOR
                            "01" when i_Funct3 = "110"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  OR
                            "00" when i_Funct3 = "111"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  AND
                            "10" when i_Funct3 = "001"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  SLL
                            "01" when i_Funct3 = "101"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  and i_Funct7 = "0100000"    else    -- (i)  SRA
                            "00" when i_Funct3 = "101"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  SRL
                            "00" when i_Opcode = "0110111"                                                                                      else    -- LUI
                            "00" when i_Opcode = "0000011"                                                                                      else    -- LB, LH, LW, LBU, LHU
                            "00" when i_Opcode = "0100011"                                                                                      else    -- SB, SH, SW
                            "XX";

end behaviour;
