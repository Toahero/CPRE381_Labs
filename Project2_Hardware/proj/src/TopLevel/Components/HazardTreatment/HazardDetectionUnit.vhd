-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
-- Dependencies: none
-- Hazard Detection Unit
-- HazDetection.vhd
-------------------------------------------------------------------------
-- 11/14/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
    port(
        i_IF_Instruction    : in  std_logic_vector(31 downto 0);
        i_ID_Instruction    : in  std_logic_vector(31 downto 0);
        i_EX_Instruction    : in  std_logic_vector(31 downto 0);
        i_MEM_Instruction   : in  std_logic_vector(31 downto 0);
        i_WB_Instruction    : in  std_logic_vector(31 downto 0);

        o_NOP               : out std_logic
    );
end HazardDetectionUnit;

architecture dataflow of HazardDetectionUnit is

begin



end dataflow;
