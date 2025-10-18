-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------


-- rippleAdder_n.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a ripple carry adder

--Dependencies: fulladder.vhd, xorg2.vhd

--9/2/25 by JAG: Initially Created
-------------------------------------------------------------------------

--Library Declaration
library IEEE;
use IEEE.std_logic_1164.all;

--Entity Declaration
entity rippleAdder_n is
  generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
  port( i_Carry     : in std_logic;
	i_A         : in std_logic_vector(N-1 downto 0);
	i_B         : in std_logic_vector(N-1 downto 0);

	o_OF	: out std_logic;
	o_Sum	: out std_logic_vector(N-1 downto 0));


end rippleAdder_n;

architecture structural of rippleAdder_n is

	--Full Adder
	component fulladder is
		Port(   i_X	: in std_logic;
			i_Y	: in std_logic;
			i_Cin	: in std_logic;

			o_S	: out std_logic;
			o_Cout	: out std_logic);
	end component;

	component xorg2 is
		Port(	i_A	: in std_logic;
			i_B	: in std_logic;
			o_F	: out std_logic);
		end component;

signal w_Carry	: std_logic_vector(N downto 0);
signal testVector : std_logic;
begin
G_NBit_RipAdder:

for i in 0 to N-1 generate
	ADDI: fulladder port map(
		i_X	=> i_A(i),
		i_Y	=> i_B(i),
		i_Cin	=> w_Carry(i),

		o_S	=> o_Sum(i),
		o_Cout	=> w_Carry(i+1));
	end generate G_NBit_RipAdder;

--Tie the in carry bit to w_Carry(0)	
	w_Carry(0) <= i_Carry;

--Tie the w_Carry (n-1) and (n) bits to an xor gate, tie the output to o_OF
	OF_GATE: xorg2 port map(
		i_A	=> w_Carry(n-1),
		i_B	=> w_Carry(n),
		o_F	=> o_OF);

end structural;
