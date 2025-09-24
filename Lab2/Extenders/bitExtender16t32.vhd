-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------
--Dependencies: None
--Description: a 16 to 32 extender for use in a RISC-V datafile

-- bitExtender16t32.vhd
-------------------------------------------------------------------------
--9/24/25 by JAG: Initially Created
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity bitExtender16t32 is
	port(	i_sw	: in std_logic;
		i_16bit	: in std_logic_vector(15 downto 0);
		o_32bit	: out std_logic_vector(31 downto 0));
end bitExtender16t32;

architecture dataflow of bitExtender16t32 is
signal extendVal: std_logic_vector(15 downto 0);

begin
	with i_sw select
		extendVal <=	x"FFFF" when '1',
				x"0000" when others;
o_32bit	<= extendVal & i_16bit;
end dataflow;