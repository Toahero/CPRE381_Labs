-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: a 20 bit to 32 bit extender module

-- BitExtender20t32.vhd
-------------------------------------------------------------------------
--9/24/25 by JAG: Initially Created
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity bitExtender20t32 is
	port(	i_sw	: in std_logic;
		i_20bit	: in std_logic_vector(19 downto 0);
		o_32bit	: out std_logic_vector(31 downto 0));
end bitExtender20t32;

architecture dataflow of bitExtender16t32 is
signal extendVal: std_logic_vector(11 downto 0);

begin
	with i_sw select
		extendVal <=	x"FFF" when '1',
				x"000" when others;
o_32bit	<= extendVal & i_20bit;
end dataflow;