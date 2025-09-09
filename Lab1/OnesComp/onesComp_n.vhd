-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------


-- onesComp_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a ones complement inverter
--9/1/25 by JAG: Initially Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp_n is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D         : in std_logic_vector(N-1 downto 0);
       o_O         : out std_logic_vector(N-1 downto 0));

end onesComp_n;

architecture structural of onesComp_n is
	--NOT Gate
	component invg is
		Port(	i_A	: in std_logic;
			o_F	: out std_logic);
	end component;
begin
	G_NBIT_COMP: for i in 0 to N-1 generate
	COMP: invg port map(
		i_A => i_D(i), --ith instance's input hooked up to ith data input
		o_F => o_O(i));  --ith instance's output hooked up to ith data output
	end generate G_NBIT_COMP;

end structural;