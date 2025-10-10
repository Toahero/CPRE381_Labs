-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: ALU Control Module for a simple RISC-V Processor

-- ALU_Control.vhd
-------------------------------------------------------------------------
--10/10/25 by JAG: Initially Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_Control is
    generic (ALU_OP_SIZE : positive := 4);
    port(
        inst_type   : in std_logic_vector(ALU_OP_SIZE-1 downto 0);
        funct3      : in std_logic_vector(2 downto 0);
    )