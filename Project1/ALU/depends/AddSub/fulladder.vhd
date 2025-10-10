-------------------------------------------------------------------------
-- James Gaul
-- CPRE 381
-- Iowa State University
-------------------------------------------------------------------------


-- fullAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VDHL full adder

--9/2/25 by JAG: Initially Created
-------------------------------------------------------------------------

--Library Declaration
library IEEE;
use IEEE.std_logic_1164.all;

--Entity Declaration
entity fullAdder is
	Port(	i_X	:	in std_logic;
		i_Y	:	in std_logic;
		i_Cin	:	in std_logic;

		o_S	:	out std_logic;
		o_Cout	:	out std_logic);
end fullAdder;

--Architecture
architecture structural of fullAdder is

	--AND Gate
	component andg2 is
		Port(	i_A, i_B	: in std_logic;
			o_F		: out std_logic);
	end component;
	
	--OR Gate
	component org2 is
		Port(	i_A, i_B	: in std_logic;
			o_F		: out std_logic);
	end component;
	
	--XOR Gate
	component xorg2 is
		Port(	i_A, i_B	: in std_logic;
			o_F		: out std_logic);
	end component;

signal	X_xor_Y, X_and_Y, XY_and_Cin : std_logic;

--Adder
begin
	x1: xorg2 port map(	i_A => i_X,
				i_B => i_Y,
				o_F => X_xor_Y);

	x2: xorg2 port map(	i_A => X_xor_Y,
				i_B => i_Cin,
				o_F => o_S);

	x3: andg2 port map(	i_A => X_xor_Y,
				i_B => i_Cin,
				o_F => XY_and_Cin);

	x4: andg2 port map(	i_A => i_X,
				i_B => i_Y,
				o_F => X_and_Y);

	x5: org2 port map(	i_A => XY_and_Cin,
				i_B => X_and_Y,
				o_F => o_Cout);
end structural;
