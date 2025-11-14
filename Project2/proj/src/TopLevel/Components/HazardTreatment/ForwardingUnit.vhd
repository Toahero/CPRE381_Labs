-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: none
--Forwarding Unit
--ForwardingUnit.vhd
-------------------------------------------------------------------------
--11/14/25 by JAG: Initially Created
-------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is
    port(   i_IDEX_RS1  : in std_logic_vector(5 downto 0);
            i_IDEX_RS2  : in std_logic_vector(5 downto 0);
            i_MEM_RD    : in std_logic_vector(5 downto 0);
            i_WB_RD     : in std_logic_vector(5 downto 0);

            i_EXMEM_WB  : in std_logic;
            i_MEMWB_WB  : in std_logic;

            o_ForwardA  : out std_logic_vector(1 downto 0);
            o_ForwardB  : out std_logic_vector(1 downto 0));

end ForwardingUnit;

