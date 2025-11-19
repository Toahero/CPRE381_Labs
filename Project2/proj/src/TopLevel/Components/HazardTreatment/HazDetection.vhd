-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Hazard Detection Unit
--HazDetection.vhd
-------------------------------------------------------------------------
--11/14/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity HazDetection is
    port(   i_instruction   :in std_logic_vector(31 downto 0);
            i_IDEX_RD       :in std_logic_vector(5 downto 0);
            i_IDEX_MemRead  : in std_logic;

            o_PC_ADVANCE    : out std_logic
            o_INS_NOP       : out std_logic);

end HazDetection;

architecture dataflow of HazDetection is
    signal s_oppCode  : std_logic_vector(6 downto 0);
    signal s_IFID_RS1 : std_logic_vector(5 downto 0);
    signal s_IFID_RS2 : std_logic_vector(5 downto 0);

begin:
    s_oppCode   <= i_instruction(6 downto 0);
    s_IFID_RS1  <= i_instruction(19 downto 15);
    s_IFID_RS2  <= i_instruction(24 downto 20);
end dataflow;