-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: ALU Control Module for a simple RISC-V Processor
    --Initial version, can only do add/subtract commands.

-- ALU_Control_v1.vhd
-------------------------------------------------------------------------
--10/10/25 by JAG: Initially Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Control_v1 is
    generic (ALU_OP_SIZE : positive := 4);
    port(
        inst_type   : in std_logic_vector(ALU_OP_SIZE-1 downto 0);
        funct3      : in std_logic_vector(2 downto 0);
        funct7      : in std_logic_vector(3 downto 0);

        o_sub       : out std_logic);
end ALU_Control_v1;

architecture dataflow of ALU_Control_v1 is
begin
    o_sub <= '1' when (inst_type = x0  AND funct3 = x0 AND funct7 = x20) else
        '0';