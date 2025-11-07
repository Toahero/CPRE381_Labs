library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISCV_types.all;

entity ALU_Control is
    port(
        i_Opcode            : in  std_logic_vector(6 downto 0);
        i_Funct3            : in  std_logic_vector(2 downto 0);
        i_Funct7            : in  std_logic_vector(6 downto 0);
        i_PCAddr            : in  std_logic_vector(31 downto 0);

        o_AOverride         : out std_logic_vector(31 downto 0);
        o_BOverride         : out std_logic_vector(31 downto 0);
        o_BOverrideEnable   : out std_logic;
        o_AOverrideEnable   : out std_logic;

        o_ModuleSelect      : out std_logic_vector(1 downto 0);
        o_OperationSelect   : out std_logic_vector(1 downto 0);
        o_Funct3Passthrough : out std_logic_vector(2 downto 0)
    );
end ALU_Control;

architecture behaviour of ALU_Control is
begin

    o_Funct3Passthrough <= i_Funct3;

    o_AOverride         <=
                            i_PCAddr    when i_Opcode = "0010111" else -- AUIPC
                            i_PCAddr    when i_Opcode = "1101111" else -- JAL
                            i_PCAddr    when i_Opcode = "1100111" else -- JALR
                            x"00000000" when i_Opcode = "0110111" else -- LUI
                            x"XXXXXXXX";

    o_AOverrideEnable   <=
                            '1'  when i_Opcode = "0010111" else
                            '1'  when i_Opcode = "1101111" else
                            '1'  when i_Opcode = "1100111" else
                            '1'  when i_Opcode = "0110111" else
                            '0';

    o_BOverride         <=
                            x"00000004" when i_Opcode = "1101111" else -- JAL
                            x"00000004" when i_Opcode = "1100111" else -- JALR
                            x"XXXXXXXX";

    o_BOverrideEnable   <=
                            '1'  when i_Opcode = "1101111" else
                            '1'  when i_Opcode = "1100111" else
                            '0';

    o_ModuleSelect      <=  
                            "00" when i_Funct3 = "000"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) ADD, SUB
                            "01" when i_Funct3 = "100"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) XOR
                            "01" when i_Funct3 = "110"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) OR
                            "01" when i_Funct3 = "111"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) AND
                            "10" when i_Funct3 = "001"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) SLL
                            "10" when i_Funct3 = "101"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) SRL, SRA
                            "11" when i_Funct3 = "010"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) SLT
                            "11" when i_Funct3 = "011"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")  else    -- (i) SLTU
                            "00" when i_Opcode = "0110111"                                                          else    -- LUI
                            "00" when i_Opcode = "0010111"                                                          else    -- AUIPC
                            "00" when i_Opcode = "1100111"                                                          else    -- JALR
                            "00" when i_Opcode = "1101111"                                                          else    -- JAL
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
                            "00" when i_Funct3 = "010"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  SLT
                            "10" when i_Funct3 = "011"      and     (i_Opcode = "0110011" or i_Opcode = "0010011")                              else    -- (i)  SLTU
                            "00" when i_Opcode = "0110111"                                                                                      else    -- LUI
                            "00" when i_Opcode = "0010111"                                                                                      else    -- AUIPC
                            "00" when i_Opcode = "1100111"                                                                                      else    -- JALR
                            "00" when i_Opcode = "1101111"                                                                                      else    -- JAL
                            "00" when i_Opcode = "0000011"                                                                                      else    -- LB, LH, LW, LBU, LHU
                            "00" when i_Opcode = "0100011"                                                                                      else    -- SB, SH, SW
                            "XX";

end behaviour;
